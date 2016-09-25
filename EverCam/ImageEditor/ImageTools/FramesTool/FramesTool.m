/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/


#import "PreviewVC.h"
#import "FramesTool.h"
#import "CircleView.h"
#import "IAPController.h"
#import "Configs.h"


static NSString* const kFramesToolFramesPathKey = @"framesPath";


@interface _FramesView : UIView
- (UIImageView*)imageView;
- (id)initWithImage:(UIImage *)image;
- (void)setScale:(CGFloat)scale;
@end



@implementation FramesTool
{
    UIView *sliderContainer;
    UISlider *opacitySlider;
    UIScrollView *_menuScroll;
    
    // For IAP =========
    UIImageView *iapDot;
    NSTimer *iapTimer;
    int tagINT,
    framesTAG;

}


+ (NSArray*)subtools {
    return nil;
}

+ (NSString*)defaultTitle {
    return NSLocalizedString(@"FramesTool", @"");
}

+ (BOOL)isAvailable {
    return true;
}



#pragma mark- FRAMES PATH ====================================

// Default Frames Path ===============
+ (NSString*)defaultFramesPath
{
    return [[[ImageEditorTheme bundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", NSStringFromClass(self)]];
}
+ (NSDictionary*)optionalInfo
{
    return @{kFramesToolFramesPathKey:[self defaultFramesPath]};
}




#pragma mark- INITIALIZATION ==========

- (void)setup {
    
    _originalImage = self.editor.imageView.image;
    
    // Fire IAP timer
    iapTimer = [NSTimer scheduledTimerWithTimeInterval:0.2  target:self selector:@selector(removeIapDots:)  userInfo:nil repeats:true];
    tagINT = 0;
    framesTAG = -1;
    
    
    _menuScroll = [[UIScrollView alloc] initWithFrame:self.editor.menuView.frame];
    _menuScroll.backgroundColor = self.editor.menuView.backgroundColor;
    _menuScroll.showsHorizontalScrollIndicator = true;
    [self.editor.view addSubview:_menuScroll];
    
    
    // WorkingView containing a selected Frame
    _workingView = [[UIView alloc] initWithFrame:[self.editor.view convertRect:self.editor.imageView.frame fromView:self.editor.imageView.superview]];
    _workingView.clipsToBounds = true;
    [self.editor.view addSubview:_workingView];
    
    
    // Scale Slider for Textures ================
    opacitySlider = [self sliderWithValue:0.5 minimumValue:0.0 maximumValue:1.0 action:@selector(sliderDidChange:)];
    opacitySlider.superview.center = CGPointMake(self.editor.view.width/2, self.editor.menuView.top-30);
    opacitySlider.thumbTintColor = [UIColor blackColor];
    opacitySlider.minimumTrackTintColor = LIGHT_COLOR;
    opacitySlider.maximumTrackTintColor = LIGHT_COLOR;
    
    
    
    [self setFramesMenu];
    
    _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height - _menuScroll.top);
    [UIView animateWithDuration:kImageToolAnimationDuration animations:^{
        _menuScroll.transform = CGAffineTransformIdentity;
    }];
}

- (UISlider*)sliderWithValue:(CGFloat)value minimumValue:(CGFloat)min maximumValue:(CGFloat)max action:(SEL)action
{
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 0, 240, 35)];
    
    sliderContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, slider.height)];
    sliderContainer.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    sliderContainer.layer.cornerRadius = slider.height /2;
    
    slider.continuous = true;
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
   // [self.editor resetZoomScaleWithAnimated:true];
    [iapTimer invalidate];

    
    [_workingView removeFromSuperview];
    [sliderContainer removeFromSuperview];
    [opacitySlider removeFromSuperview];
    
    
    [UIView animateWithDuration:kImageToolAnimationDuration
    animations:^{
    _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
      }
    completion:^(BOOL finished) {
    
        [_menuScroll removeFromSuperview];
    }];
}

#pragma mark - REMOVE IAP DOTS METHOD  =================
// Remove iapDots icons from items that have been purchased with IAP
-(void)removeIapDots: (NSTimer *)timer  {
    if (iapMade) {
        for (int i = 600+freeFrames; i <= iapDot.tag; i++) {
            [[self.editor.view viewWithTag:i] removeFromSuperview];
        }
        [iapTimer invalidate];
    }
    // NSLog(@"timerON!");
}

- (void)executeWithCompletionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self buildImage:_originalImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}



#pragma mark - SET FRAMES MENU =================

- (void)setFramesMenu {
    CGFloat W = 70;
    CGFloat H = _menuScroll.height;
    CGFloat x = 0;
    
    
     framesPath = self.toolInfo.optionalInfo[kFramesToolFramesPathKey];
     if(framesPath == nil){
     framesPath = [[self class] defaultFramesPath];
     }
     
    
     NSFileManager *fileManager = [NSFileManager defaultManager];
     NSError *error = nil;
     filesList = [fileManager contentsOfDirectoryAtPath:framesPath error:&error];
     
     for (NSString *pathStr in filesList){
     filePath = [NSString stringWithFormat:@"%@/%@", framesPath, pathStr];
     
     UIImage *image = [UIImage imageWithContentsOfFile:filePath];
     
     if(image){
     ToolbarMenuItem *item = [ImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedFramesPanel:) toolInfo:nil];
     item.iconImage = [image aspectFit:CGSizeMake(50, 50)];
     item.userInfo = @{@"filePath" : filePath};
     
         tagINT++;
         item.tag = tagINT;
         
         // Add a little circle on the top of the PAID items that need to be unlocked with IAP
         if (!iapMade && item.tag >= freeFrames) {
             iapDot = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 6, 6)];
             iapDot.backgroundColor = PURPLE_COLOR;
             iapDot.layer.cornerRadius = iapDot.bounds.size.width/2;
             iapDot.tag = tagINT+600;
             [item addSubview:iapDot];
             //NSLog(@"iapDot TAG: %ld", (long)iapDot.tag);
         }
         //====================================================================

     
     [_menuScroll addSubview:item];
     x += W;
     }
    }
    
    // Resize scrollView
    _menuScroll.contentSize = CGSizeMake(MAX(x, _menuScroll.frame.size.width+1), 0);
}


- (void)tappedFramesPanel:(UITapGestureRecognizer*)sender  {
    UIView *view = sender.view;
    NSString *filePath = view.userInfo[@"filePath"];

    
    /*====================================================================================
     NO IAP MADE - open the IAP Controller
     =====================================================================================*/
    if (!iapMade && view.tag >= freeFrames) {
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
        
        
        _FramesView *view = [[_FramesView alloc] initWithImage:[UIImage imageWithContentsOfFile:filePath]];
        // Puts the frame in the center of the image
        view.center = CGPointMake(_workingView.width/2, _workingView.height/2);
        
        width = _workingView.width;
        height = _workingView.height;
        
        view.frame = CGRectMake(0,0, width, height);
        
        [_workingView addSubview:view];
        [_workingView.superview bringSubviewToFront:sliderContainer];
     
        framesTAG++;
        view.tag = framesTAG;
    }
    
    _workingView.alpha = opacitySlider.value;
}


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





#pragma mark - FRAMES VIEW IMPLEMENTATION ======================
@implementation _FramesView
{
    
    UIImageView *_imageView;
    UIButton *_deleteButton;
    
    CGFloat _scale;
    CGFloat _arg;
    
    CGPoint _initialPoint;
    CGFloat _initialArg;
    CGFloat _initialScale;
    
}

// Initializes the Frame Image ==========
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
        
        
        // Initializes Pinch Gesture for Frame Zoom
       [self initPinchGesture];
        
    }
    return self;
}


-(void)initPinchGesture  {
    
    _imageView.userInteractionEnabled = YES;
    
    [_imageView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPinch:)]];

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


-(void)viewDidPinch: (UIPinchGestureRecognizer *) sender {
    
    if (sender.state == UIGestureRecognizerStateEnded
    || sender.state == UIGestureRecognizerStateChanged) {
    
        NSLog(@"SCALE: = %f", sender.scale);
        
        CGFloat currentScale = self.frame.size.width / self.bounds.size.width;
        CGFloat newScale = currentScale * sender.scale;
        
        if (newScale < 1.0) {
            newScale = 1.0;
        }
        if (newScale > 2.0) {
            newScale = 2.0;
        }
        
        CGAffineTransform transform = CGAffineTransformMakeScale(newScale, newScale);
        self.transform = transform;
        sender.scale = 1;
    }
    
}


@end
