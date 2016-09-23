/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/


#import "EffectTool.h"
#import "Configs.h"


@interface EffectTool()
@property (nonatomic, strong) UIView *selectedMenu;
@property (nonatomic, strong) EffectBase *selectedEffect;
@end


@implementation EffectTool
{
    UIImage *_originalImage;
    UIImage *_thumnailImage;
    
    UIScrollView *_menuScroll;
    UIActivityIndicatorView *_indicatorView;
}

+ (NSArray*)subtools
{
    return [ImageToolInfo toolsWithToolClass:[EffectBase class]];
}

+ (NSString*)defaultTitle
{
    return NSLocalizedString(@"EffectTool", @"");
}

+ (BOOL)isAvailable {
    return true;
}



#pragma mark- SETUP ===============

- (void)setup {
    _originalImage = self.editor.imageView.image;
    _thumnailImage = _originalImage;
    
    _menuScroll = [[UIScrollView alloc] initWithFrame:self.editor.menuView.frame];
    _menuScroll.backgroundColor = self.editor.menuView.backgroundColor;
    _menuScroll.showsHorizontalScrollIndicator = NO;
    [self.editor.view addSubview:_menuScroll];
    
    [self setEffectsMenu];
    
    _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
    [UIView animateWithDuration:kImageToolAnimationDuration animations:^{
        _menuScroll.transform = CGAffineTransformIdentity;
    }];
}

- (void)cleanup {
    [self.selectedEffect cleanup];
    [_indicatorView removeFromSuperview];
    
    [self.editor resetZoomScaleWithAnimated: true];
    
    [UIView animateWithDuration:kImageToolAnimationDuration animations:^{
        _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
    } completion:^(BOOL finished) {
        [_menuScroll removeFromSuperview];
    }];
}

- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _indicatorView = [ImageEditorTheme indicatorView];
        _indicatorView.center = self.editor.view.center;
        [self.editor.view addSubview:_indicatorView];
        [_indicatorView startAnimating];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self.selectedEffect applyEffect:_originalImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}



#pragma mark - SETUP EFFECTS MENU =====================

- (void)setEffectsMenu {
    CGFloat W = 70;
    CGFloat H = _menuScroll.height;
    CGFloat x = 0;
    
    for(ImageToolInfo *info in self.toolInfo.sortedSubtools){
        if(!info.available){
            continue;
        }
        
        ToolbarMenuItem *view = [ImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedMenu:) toolInfo:info];
        [_menuScroll addSubview:view];
        x += W;
        
        if(self.selectedMenu==nil){
            self.selectedMenu = view;
        }
    }
    _menuScroll.contentSize = CGSizeMake(MAX(x, _menuScroll.frame.size.width+1), 0);
}

- (void)tappedMenu:(UITapGestureRecognizer*)sender
{
    UIView *view = sender.view;
    
    view.alpha = 0.2;
    [UIView animateWithDuration:kImageToolAnimationDuration animations:^{
        view.alpha = 1;
    }];
    
    self.selectedMenu = view;
}

- (void)setSelectedMenu:(UIView *)selectedMenu {
    if(selectedMenu != _selectedMenu){
        _selectedMenu.backgroundColor = [UIColor clearColor];
        _selectedMenu = selectedMenu;
        
        Class effectClass = NSClassFromString(_selectedMenu.toolInfo.toolName);
        self.selectedEffect = [[effectClass alloc] initWithSuperView:self.editor.imageView.superview imageViewFrame:self.editor.imageView.frame toolInfo:_selectedMenu.toolInfo];
    }
}

- (void)setSelectedEffect:(EffectBase *)selectedEffect
{
    if(selectedEffect != _selectedEffect){
        [_selectedEffect cleanup];
        _selectedEffect = selectedEffect;
        _selectedEffect.delegate = self;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self buildThumnailImage];
        });
    }
}

- (void)buildThumnailImage
{
    UIImage *image;
    if(self.selectedEffect.needsThumnailPreview){
        image = [self.selectedEffect applyEffect:_thumnailImage];
    }
    else{
        image = [self.selectedEffect applyEffect:_originalImage];
    }
    [self.editor.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
}

#pragma mark- Effect delegate

- (void)effectParameterDidChange:(EffectBase *)effect
{
    if(effect == self.selectedEffect){
        static BOOL inProgress = NO;
        
        if(inProgress){ return; }
        inProgress = YES;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self buildThumnailImage];
            inProgress = NO;
        });
    }
}

@end
