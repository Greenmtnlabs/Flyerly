/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/



#import "SharingVC.h"

#import "TexturesTool.h"
#import "CircleView.h"
#import "IAPController.h"
#import "Configs.h"


static NSString * const kTexturesToolTexturesPathKey = @"texturesPath";

@interface _TexturesView : UIView
- (UIImageView*)imageView;
- (id)initWithImage:(UIImage *)image;
- (void)setScale:(CGFloat)scale;
@end



@implementation TexturesTool
{
    UIView *sliderContainer;
    UISlider *opacitySlider;
    UIScrollView *_menuScroll;
    
    // For IAP =========
    UIImageView *iapDot;
    NSTimer *iapTimer;
    int tagINT,
    texturesTAG;

}


+ (NSArray*)subtools
{
    
    return nil;
}

+ (NSString*)defaultTitle
{
    return NSLocalizedString(@"TexturesTool", @"");
}

+ (BOOL)isAvailable {
    return true;
}



#pragma mark- TEXTURES PATH ============

+ (NSString*)defaultTexturesPath
{
     return [[[ImageEditorTheme bundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", NSStringFromClass(self)]];
}

+ (NSDictionary*)optionalInfo
{
    return @{kTexturesToolTexturesPathKey:[self defaultTexturesPath]};
}



#pragma mark- INITIALIZATION ==========

- (void)setup {
    
    _originalImage = self.editor.imageView.image;
    
    // Fire IAP timer
    iapTimer = [NSTimer scheduledTimerWithTimeInterval:0.2  target:self selector:@selector(removeIapDots:)  userInfo:nil repeats:true];
    tagINT = 0;
    texturesTAG = -1;
    
    
    // ScrollView that contains Textures thumbnails (buttons) =========
    _menuScroll = [[UIScrollView alloc] initWithFrame:self.editor.menuView.frame];
    _menuScroll.backgroundColor = self.editor.menuView.backgroundColor;
    _menuScroll.showsHorizontalScrollIndicator = YES;
    [self.editor.view addSubview:_menuScroll];
    
    
    
    // WorkingView containing a selected Texture =========
    _workingView = [[UIView alloc] initWithFrame:[self.editor.view convertRect:self.editor.imageView.frame fromView:self.editor.imageView.superview]];
    _workingView.clipsToBounds = YES;
    [self.editor.view addSubview:_workingView];
    
    
    
    // Opacity Slider for Textures ================
    opacitySlider = [self sliderWithValue:0.5 minimumValue:0.0 maximumValue:1.0 action:@selector(sliderDidChange:)];
    opacitySlider.superview.center = CGPointMake(self.editor.view.width/2, self.editor.menuView.top-30);
    opacitySlider.thumbTintColor = [UIColor blackColor];
    opacitySlider.minimumTrackTintColor = LIGHT_COLOR;
    opacitySlider.maximumTrackTintColor = LIGHT_COLOR;

    // Call setup Textures menu
    [self setTexturesMenu];

    _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height - _menuScroll.top);
    [UIView animateWithDuration:kImageToolAnimationDuration  animations:^{
        _menuScroll.transform = CGAffineTransformIdentity;
    }];
}

- (UISlider*)sliderWithValue:(CGFloat)value minimumValue:(CGFloat)min maximumValue:(CGFloat)max action:(SEL)action {
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 0, 240, 35)];
    
    sliderContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, slider.height)];
    sliderContainer.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    sliderContainer.layer.cornerRadius = slider.height /2;
    
    slider.continuous = YES;
    [slider addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    
    slider.maximumValue = max;
    slider.minimumValue = min;
    slider.value = value;
    
    [sliderContainer addSubview:slider];
    [self.editor.view addSubview:sliderContainer];
    
    return slider;
}


#pragma mark - OPACITY SLIDER ===================
- (void)sliderDidChange:(UISlider*)sender {
    _workingView.alpha = sender.value;
}




- (void)cleanup {
   // [self.editor resetZoomScaleWithAnimated: true];
    
    [iapTimer invalidate];
    
    [_workingView removeFromSuperview];
    [opacitySlider removeFromSuperview];
    [sliderContainer removeFromSuperview];
    
    [UIView animateWithDuration:kImageToolAnimationDuration animations:^{
        _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
      } completion:^(BOOL finished) {
    [_menuScroll removeFromSuperview];
    }];
}

#pragma mark - REMOVE IAP DOTS METHOD  =================
// Remove iapDots icons from items that have been purchased with IAP
-(void)removeIapDots: (NSTimer *)timer  {
    if (iapMade) {
        for (int i = 800+freeTextures; i <= iapDot.tag; i++) {
            [[self.editor.view viewWithTag:i] removeFromSuperview];
        }
        [iapTimer invalidate];
    }
    // NSLog(@"timerON!");
}


- (void)executeWithCompletionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock  {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self buildImage:_originalImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}




#pragma mark - SET TEXTURES MENU =================

- (void)setTexturesMenu {
    CGFloat W = 70;
    CGFloat H = _menuScroll.height;
    CGFloat x = 0;

    
    
    texturesPath = self.toolInfo.optionalInfo[kTexturesToolTexturesPathKey];
    if(texturesPath == nil){
        texturesPath = [[self class] defaultTexturesPath];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    filesList = [fileManager contentsOfDirectoryAtPath:texturesPath error:&error];

    for (NSString *pathStr in filesList) {
        filePath = [NSString stringWithFormat:@"%@/%@", texturesPath, pathStr];
    
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
       
        if (image){
            ToolbarMenuItem *item = [ImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedTexturesPanel:) toolInfo:nil];
            item.iconImage = [image aspectFit:CGSizeMake(50, 50)];
            item.userInfo = @{@"filePath" : filePath};
            
            tagINT++;
            item.tag = tagINT;
            
            // Add a little circle on the top of the PAID items that need to be unlocked with IAP
            if (!iapMade && item.tag >= freeTextures) {
                iapDot = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 6, 6)];
                iapDot.backgroundColor = PURPLE_COLOR;
                iapDot.layer.cornerRadius = iapDot.bounds.size.width/2;
                iapDot.tag = tagINT+800;
                [item addSubview:iapDot];
                //NSLog(@"iapDot TAG: %ld", (long)iapDot.tag);
            }
            //====================================================================
            
            
            [_menuScroll addSubview: item];
            x += W;
        }
    }
    
    NSLog(@"%@", filesList);
    _menuScroll.contentSize = CGSizeMake(MAX(x, _menuScroll.frame.size.width+1), 0);

}


- (void)tappedTexturesPanel:(UITapGestureRecognizer*)sender {
    UIView *view = sender.view;
    NSString *filePath = view.userInfo[@"filePath"];

    
    /*====================================================================================
     NO IAP MADE - open the IAP Controller
     =====================================================================================*/
    if (!iapMade && view.tag >= freeTextures) {
        IAPController *iapVC = [[IAPController alloc]initWithNibName:@"IAPController" bundle:nil];
        [self.editor presentViewController: iapVC animated:true completion:nil];
        
        
        
    /*========================================================================================
        IAP MADE!
    =========================================================================================*/
    } else {
        
         [_workingView removeFromSuperview];
         
         // WorkingView containing Textures =========
         _workingView = [[UIView alloc] initWithFrame:[self.editor.view convertRect:self.editor.imageView.frame fromView:self.editor.imageView.superview]];
         _workingView.clipsToBounds = YES;
         [self.editor.view addSubview:_workingView];

         
        _TexturesView *texturesView = [[_TexturesView alloc] initWithImage:[UIImage imageWithContentsOfFile:filePath]];
         // Puts the Texture in the center of the image
        texturesView.center = CGPointMake(_workingView.width/2, _workingView.height/2);
        
         width = _workingView.width;
         height = _workingView.height;
         
         texturesView.frame = CGRectMake(0,0, width, height);
    
        [_workingView addSubview:texturesView];
        [_workingView.superview bringSubviewToFront:sliderContainer];
        
        
        texturesTAG++;
        view.tag = texturesTAG;
    }
    
    _workingView.alpha = opacitySlider.value;
}


- (UIImage*)buildImage:(UIImage*)image
{
    UIGraphicsBeginImageContext(image.size);
    
    [image drawAtPoint:CGPointZero];
    
    CGFloat scale = image.size.width / _workingView.width;
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale);
    [_workingView drawViewHierarchyInRect:_workingView.bounds afterScreenUpdates: false];

    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tmp;
}


@end





#pragma mark - TEXTURES VIEW IMPLEMENTATION ======================
@implementation _TexturesView
{
    UIImageView *_imageView;
    
    CGFloat _scale;
    CGFloat _arg;
    
    CGPoint _initialPoint;
    CGFloat _initialArg;
    CGFloat _initialScale;
}


// Initializes the Texture Overlay Image ==========
- (id)initWithImage:(UIImage *)image
{
    self = [super initWithFrame:CGRectMake(0, 0, _imageView.frame.size.width, _imageView.frame.size.height)];
    
    if(self){

        _imageView = [[UIImageView alloc] initWithImage:image];
        _imageView.center = self.center;
        
        width = _workingView.width;
        height = _workingView.height;
        
        _imageView.frame = CGRectMake(0,0, width, height);
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        
        [self addSubview:_imageView];
        
        
        _scale = 2;
        _arg = 0;
        
    }
    return self;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* view= [super hitTest:point withEvent:event];
    if(view==self){
        return nil;
    }
    return view;
}

- (UIImageView*)imageView
{
    return _imageView;
}


- (void)setActive:(BOOL)active
{
    _imageView.layer.borderWidth = (active) ? 1/_scale : 0;
    _imageView.layer.borderColor = [[UIColor clearColor] CGColor];
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    
    self.transform = CGAffineTransformIdentity;
    
    _imageView.transform = CGAffineTransformMakeScale(_scale, _scale);
    
    CGRect rct = self.frame;
    rct.origin.x += (rct.size.width - (_imageView.width + 32)) / 2;
    rct.origin.y += (rct.size.height - (_imageView.height + 32)) / 2;
    rct.size.width  = _imageView.width + 32;
    rct.size.height = _imageView.height + 32;
    self.frame = rct;
    
    _imageView.center = CGPointMake(rct.size.width/2, rct.size.height/2);
    
    self.transform = CGAffineTransformMakeRotation(_arg);
    
    _imageView.layer.borderWidth = 1/_scale;
    _imageView.layer.cornerRadius = 3/_scale;
}


@end
