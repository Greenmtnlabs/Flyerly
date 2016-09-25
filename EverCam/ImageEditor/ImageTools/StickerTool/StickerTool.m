/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/



#import "PreviewVC.h"
#import "StickerTool.h"
#import "CircleView.h"
#import "IAPController.h"
#import "Configs.h"


static NSString* const kStickerToolStickerPathKey = @"stickerPath";

@interface _StickerView : UIView
+ (void)setActiveStickerView:(_StickerView *)view;
- (UIImageView*)imageView;
- (id)initWithImage:(UIImage *)image;
- (void)setScale:(CGFloat)scale;
@end



@implementation StickerTool
{
    UIImage *_originalImage;
    UIView *_workingView;
    UIScrollView *_menuScroll;
    
    // For IAP =========
    UIImageView *iapDot;
    NSTimer *iapTimer;
    int tagINT,
    stickersTAG;
    
}

+ (NSArray*)subtools {
    return nil;
}

+ (NSString*)defaultTitle {
    return NSLocalizedString(@"StickerTool", @"");
}

+ (BOOL)isAvailable {
    return true;
}




#pragma mark- STICKER PATHS ============
// Default Stickers Path ===============
+ (NSString*)defaultStickerPath
{
    return [[[ImageEditorTheme bundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", NSStringFromClass(self)]];
}

+ (NSDictionary*)optionalInfo
{
    return @{kStickerToolStickerPathKey:[self defaultStickerPath]};
}
//========================================





#pragma mark- INITIALIZATION ==========================

- (void)setup {
    
    _originalImage = self.editor.imageView.image;
    
    // Fire IAP timer
    iapTimer = [NSTimer scheduledTimerWithTimeInterval:0.2  target:self selector:@selector(removeIapDots:)  userInfo:nil repeats:true];
    tagINT = 0;
    stickersTAG = -1;
    
    
    _menuScroll = [[UIScrollView alloc] initWithFrame:self.editor.menuView.frame];
    _menuScroll.backgroundColor = self.editor.menuView.backgroundColor;
    _menuScroll.showsHorizontalScrollIndicator = true;
    [self.editor.view addSubview:_menuScroll];
    
    
    _workingView = [[UIView alloc] initWithFrame:[self.editor.view convertRect:self.editor.imageView.frame fromView:self.editor.imageView.superview]];
    _workingView.clipsToBounds = true;
    [self.editor.view addSubview:_workingView];
    
    [self setStickerMenu];
    
    _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
    [UIView animateWithDuration:kImageToolAnimationDuration animations:^{
        _menuScroll.transform = CGAffineTransformIdentity;
    }];
}

- (void)cleanup {
    //[self.editor resetZoomScaleWithAnimated:true];
    
    
    [iapTimer invalidate];
    [_workingView removeFromSuperview];
    
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
        for (int i = 500+freeStickers; i <= iapDot.tag; i++) {
            [[self.editor.view viewWithTag:i] removeFromSuperview];
        }
        [iapTimer invalidate];
    }
    // NSLog(@"timerON!");
}


- (void)executeWithCompletionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock
{
    [_StickerView setActiveStickerView:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self buildImage:_originalImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}



#pragma mark - SET STICKER MENU =================

- (void)setStickerMenu {
    CGFloat W = 70;
    CGFloat H = _menuScroll.height;
    CGFloat x = 0;

    
    stickerPath = self.toolInfo.optionalInfo[kStickerToolStickerPathKey];
    if(stickerPath == nil){
        stickerPath = [[self class] defaultStickerPath];
    }

 
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    filesList = [fileManager contentsOfDirectoryAtPath:stickerPath error:&error];
        
    for (NSString *pathStr in filesList){
        filePath = [NSString stringWithFormat:@"%@/%@", stickerPath, pathStr];
       // NSLog(@"FP: %@", filePath);
        
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
       
        if(image){
            ToolbarMenuItem *item = [ImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedStickerPanel:) toolInfo:nil];
            item.iconImage = [image aspectFit:CGSizeMake(50, 50)];
            item.userInfo = @{@"filePath" : filePath};
          
            tagINT++;
            item.tag = tagINT;
            
            // Add a little circle on the top of the PAID items that need to be unlocked with IAP
            if (!iapMade && item.tag >= freeStickers) {
                iapDot = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 6, 6)];
                iapDot.backgroundColor = PURPLE_COLOR;
                iapDot.layer.cornerRadius = iapDot.bounds.size.width/2;
                iapDot.tag = tagINT+500;
                [item addSubview:iapDot];
                //NSLog(@"iapDot TAG: %ld", (long)iapDot.tag);
            }
            //====================================================================
            
            
            [_menuScroll addSubview:item];
            x += W;
        }
    }
    
   //  NSLog(@"Stickers List: %@", filesList);
    
    _menuScroll.contentSize = CGSizeMake(MAX(x, _menuScroll.frame.size.width+1), 0);
}


- (void)tappedStickerPanel:(UITapGestureRecognizer*)sender {
    UIView *view = sender.view;
    //NSLog(@"tag: %ld", (long)view.tag);
    
    NSString *filePath = view.userInfo[@"filePath"];
    
    
    /*====================================================================================
     NO IAP MADE - open the IAP Controller
     =====================================================================================*/
    if (!iapMade && view.tag >= freeStickers) {
        IAPController *iapVC = [[IAPController alloc]initWithNibName:@"IAPController" bundle:nil];
        [self.editor presentViewController: iapVC animated:true completion:nil];
        
        
    /*========================================================================================
        IAP MADE!
    =========================================================================================*/
    } else {
        _StickerView *view = [[_StickerView alloc] initWithImage:[UIImage imageWithContentsOfFile:filePath]];
        CGFloat ratio = MIN( (0.5 * _workingView.width) / view.width, (0.5 * _workingView.height) / view.height);
        [view setScale:ratio];
        view.center = CGPointMake(_workingView.width/2, _workingView.height/2);
        [_workingView addSubview:view];
        [_StickerView setActiveStickerView:view];
        
        stickersTAG++;
        view.tag = stickersTAG;
    }

}



#pragma mark- BUILD IMAGE METHOD ============
- (UIImage*)buildImage:(UIImage*)image {
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







#pragma mark - STICKER VIEW IMPLEMENTATION ======================
@implementation _StickerView {
    
    UIImageView *_imageView;
    UIButton *_deleteButton;
    CircleView *_circleView;
    
    CGFloat _scale;
    CGFloat _arg;
    
    CGPoint _initialPoint;
    CGFloat _initialArg;
    CGFloat _initialScale;
}

+ (void)setActiveStickerView:(_StickerView*)view
{
    static _StickerView *activeView = nil;
    if(view != activeView){
        [activeView setActive:NO];
        activeView = view;
        [activeView setActive:YES];
        
        [activeView.superview bringSubviewToFront:activeView];
    }
}

- (id)initWithImage:(UIImage *)image
{
    self = [super initWithFrame:CGRectMake(0, 0, image.size.width+32, image.size.height+32)];
    if(self){
        
        // Alloc the ImageView that contains the selected sticker
        _imageView = [[UIImageView alloc] initWithImage:image];
        _imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _imageView.layer.cornerRadius = 3;
        _imageView.center = self.center;
        [self addSubview:_imageView];
        
        
        // Delete button (delete the selected sticker)
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"st_deleteButt"] forState:UIControlStateNormal];
        _deleteButton.frame = CGRectMake(0, 0, 35, 35);
        _deleteButton.center = _imageView.frame.origin;
        [_deleteButton addTarget:self action:@selector(pushedDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        
        
        // Circle View (Resize the current sticker)
        _circleView = [[CircleView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        _circleView.center = CGPointMake(_imageView.width + _imageView.frame.origin.x, _imageView.height + _imageView.frame.origin.y);
        _circleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        _circleView.radius = 0.7;
        _circleView.color = [UIColor whiteColor];
        _circleView.borderColor = MAIN_COLOR;
        _circleView.borderWidth = 2;
        [self addSubview:_circleView];
        
        
        _scale = 1;
        _arg = 0;
        
        [self initGestures];
    }
    return self;
}

- (void)initGestures
{
    _imageView.userInteractionEnabled = YES;
    [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)]];
    [_imageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)]];
    [_circleView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(circleViewDidPan:)]];
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

- (void)pushedDeleteBtn:(id)sender
{
    _StickerView *nextTarget = nil;
    
    const NSInteger index = [self.superview.subviews indexOfObject:self];
    
    for(NSInteger i=index+1; i<self.superview.subviews.count; ++i){
        UIView *view = [self.superview.subviews objectAtIndex:i];
        if([view isKindOfClass:[_StickerView class]]){
            nextTarget = (_StickerView*)view;
            break;
        }
    }
    
    if(nextTarget==nil){
        for(NSInteger i=index-1; i>=0; --i){
            UIView *view = [self.superview.subviews objectAtIndex:i];
            if([view isKindOfClass:[_StickerView class]]){
                nextTarget = (_StickerView*)view;
                break;
            }
        }
    }
    
    [[self class] setActiveStickerView:nextTarget];
    [self removeFromSuperview];
}

- (void)setActive:(BOOL)active
{
    _deleteButton.hidden = !active;
    _circleView.hidden = !active;
    _imageView.layer.borderWidth = (active) ? 1/_scale : 0;
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

- (void)viewDidTap:(UITapGestureRecognizer*)sender
{
    [[self class] setActiveStickerView:self];
}

- (void)viewDidPan:(UIPanGestureRecognizer*)sender
{
    [[self class] setActiveStickerView:self];
    
    CGPoint p = [sender translationInView:self.superview];
    
    if(sender.state == UIGestureRecognizerStateBegan){
        _initialPoint = self.center;
    }
    self.center = CGPointMake(_initialPoint.x + p.x, _initialPoint.y + p.y);
}

- (void)circleViewDidPan:(UIPanGestureRecognizer*)sender
{
    CGPoint p = [sender translationInView:self.superview];
    
    static CGFloat tmpR = 1;
    static CGFloat tmpA = 0;
    if(sender.state == UIGestureRecognizerStateBegan){
        _initialPoint = [self.superview convertPoint:_circleView.center fromView:_circleView.superview];
        
        CGPoint p = CGPointMake(_initialPoint.x - self.center.x, _initialPoint.y - self.center.y);
        tmpR = sqrt(p.x*p.x + p.y*p.y);
        tmpA = atan2(p.y, p.x);
        
        _initialArg = _arg;
        _initialScale = _scale;
    }
    
    p = CGPointMake(_initialPoint.x + p.x - self.center.x, _initialPoint.y + p.y - self.center.y);
    CGFloat R = sqrt(p.x*p.x + p.y*p.y);
    CGFloat arg = atan2(p.y, p.x);
    
    _arg   = _initialArg + arg - tmpA;
    [self setScale:MAX(_initialScale * R / tmpR, 0.2)];
}

@end
