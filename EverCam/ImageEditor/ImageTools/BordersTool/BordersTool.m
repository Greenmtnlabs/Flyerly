/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/


#import "SharingVC.h"
#import "BordersTool.h"
#import "CircleView.h"
#import "IAPController.h"
#import "Configs.h"


static NSString* const kBordersToolBordersPathKey = @"bordersPath";

@interface _BordersView : UIView
- (UIImageView*)imageView;
- (id)initWithImage:(UIImage *)image;
- (void)setScale:(CGFloat)scale;
@end



@implementation BordersTool
{
    UIScrollView *_menuScroll;
    UIImage *_thumnailImage;
    
    // For IAP =========
    UIImageView *iapDot;
    NSTimer *iapTimer;
    int tagINT,
    bordersTAG;
}

+ (NSArray*)subtools
{
    return nil;
}

+ (NSString*)defaultTitle {
    return NSLocalizedString(@"BordersTool", @"");
}

+ (BOOL)isAvailable {
    return true;
}



#pragma mark- BORDERS PATH ============

+ (NSString*)defaultBordersPath
{
    return [[[ImageEditorTheme bundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", NSStringFromClass(self)]];
}

+ (NSDictionary*)optionalInfo
{
    return @{kBordersToolBordersPathKey:[self defaultBordersPath]};
}



#pragma mark- INITIALIZATION ==========

- (void)setup {
    
    _originalImage = self.editor.imageView.image;
    
    // Fire IAP timer
    iapTimer = [NSTimer scheduledTimerWithTimeInterval:0.2  target:self selector:@selector(removeIapDots:)  userInfo:nil repeats:true];
    tagINT = 0;
    bordersTAG = -1;
    
    
    imageContainerView = [[UIView alloc] initWithFrame: CGRectMake(0, 44, self.editor.view.frame.size.width, self.editor.view.frame.size.width)];
    imageContainerView.backgroundColor = [UIColor clearColor];
    imageContainerView.clipsToBounds = true;
    imageContainerView.backgroundColor = [UIColor whiteColor];
    [self.editor.view addSubview:imageContainerView];
    NSLog(@"imgContainer: %f - %f", imageContainerView.frame.size.width,
          imageContainerView.frame.size.height);
    
    
    self.editor.imageView.center = CGPointMake(imageContainerView.frame.size.width/2,
                                               imageContainerView.frame.size.height/2);
    self.editor.imageView.transform = CGAffineTransformScale(self.editor.imageView.transform, 0.8, 0.8);
    [imageContainerView addSubview:self.editor.imageView];
    
    self.editor.imageView.userInteractionEnabled = true;
    
    
    // Add PAN & PINCH Gesture Recogn. to the Image
    pinchGest = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(imageDidPinch:)];
    panGest = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(imageDidPan:)];
    [self.editor.imageView addGestureRecognizer:pinchGest];
    [self.editor.imageView addGestureRecognizer:panGest];

    
    _menuScroll = [[UIScrollView alloc] initWithFrame:self.editor.menuView.frame];
    _menuScroll.backgroundColor = self.editor.menuView.backgroundColor;
    _menuScroll.showsHorizontalScrollIndicator = true;
    [self.editor.view addSubview:_menuScroll];
    
    // Bring ImageView to front
    [self.editor.view bringSubviewToFront:self.editor.imageView];
    
    
    // Title Label =============
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _menuScroll.top -30, self.editor.view.frame.size.width, 25)];
    titleLabel.font = NAVBAR_FONT;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"Move & Scale";
    [self.editor.view addSubview:titleLabel];
    
    
    // Call the setup of the Borders Toolbar menu
    [self setBordersMenu];
    
    
    _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height - _menuScroll.top);
    [UIView animateWithDuration:kImageToolAnimationDuration
    animations:^{
    _menuScroll.transform = CGAffineTransformIdentity;
    }];
}

- (void)cleanup {
    [self.editor.scrollView addSubview: self.editor.imageView];
    [self.editor resetZoomScaleWithAnimated: true];
    
    [iapTimer invalidate];
    
    // Remove all the Views and Gestures =======
    [_workingView removeFromSuperview];
    [imageContainerView removeFromSuperview];
    [titleLabel removeFromSuperview];
    [self.editor.imageView removeGestureRecognizer:pinchGest];
    [self.editor.imageView removeGestureRecognizer:panGest];
    
    
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
        for (int i = 700+freeBorders; i <= iapDot.tag; i++) {
            [[self.editor.view viewWithTag:i] removeFromSuperview];
        }
        [iapTimer invalidate];
    }
    // NSLog(@"timerON!");
}

- (void)executeWithCompletionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self buildImage: _originalImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}

// Gesture Recognizers =============
-(void)imageDidPinch: (UIPinchGestureRecognizer *) recognizer {
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}
- (void)imageDidPan:(UIPanGestureRecognizer*)recognizer {
    CGPoint translation = [recognizer translationInView:self.editor.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.editor.view];

}



#pragma mark - SET BORDERS TOOLBAR MENU =================
- (void)setBordersMenu {
    CGFloat W = 70;
    CGFloat H = _menuScroll.height;
    CGFloat x = 0;

    
    bordersPath = self.toolInfo.optionalInfo[kBordersToolBordersPathKey];
    if(bordersPath == nil) { bordersPath = [[self class] defaultBordersPath];  }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    filesList = [fileManager contentsOfDirectoryAtPath:bordersPath error:&error];
        
    for (NSString *pathStr in filesList){
        filePath = [NSString stringWithFormat:@"%@/%@", bordersPath, pathStr];
        
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
       
        if(image){
            ToolbarMenuItem *item = [ImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedBordersPanel:) toolInfo:nil];
            item.iconImage = [image aspectFit:CGSizeMake(50, 50)];
            item.userInfo = @{@"filePath" : filePath};
          
            tagINT++;
            item.tag = tagINT;
            
            // Add a little circle on the top of the PAID items that need to be unlocked with IAP
            if (!iapMade && item.tag >= freeBorders) {
                iapDot = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 6, 6)];
                iapDot.backgroundColor = PURPLE_COLOR;
                iapDot.layer.cornerRadius = iapDot.bounds.size.width/2;
                iapDot.tag = tagINT+700;
                [item addSubview:iapDot];
                //NSLog(@"iapDot TAG: %ld", (long)iapDot.tag);
            }
            //====================================================================

            
            [_menuScroll addSubview: item];
            x += W;
        }
    }
    
    _menuScroll.contentSize = CGSizeMake(MAX(x, _menuScroll.frame.size.width+1), 0);
}


- (void)tappedBordersPanel:(UITapGestureRecognizer*)sender {
    UIView *view = sender.view;
    NSString *filePath = view.userInfo[@"filePath"];
    // NSLog(@"filepath= %@", filePath);
    
    
    /*====================================================================================
     NO IAP MADE - open the IAP Controller
     =====================================================================================*/
    if (!iapMade && view.tag >= freeBorders) {
        IAPController *iapVC = [[IAPController alloc]initWithNibName:@"IAPController" bundle:nil];
        [self.editor presentViewController: iapVC animated:true completion:nil];
        
        
        
    /*========================================================================================
        IAP MADE!
    =========================================================================================*/
    } else {
         _BordersView *bordersView = [[_BordersView alloc] initWithImage:[UIImage imageWithContentsOfFile:filePath]];
         
         // Puts the frame in the center of the image
         bordersView.center = CGPointMake(imageContainerView.width/2, imageContainerView.height/2);
         bordersView.frame = CGRectMake(0, 0, imageContainerView.width, imageContainerView.height);
         [imageContainerView addSubview:bordersView];
         [imageContainerView bringSubviewToFront:self.editor.imageView];
        
        bordersTAG++;
        view.tag = bordersTAG;
    }
}



- (UIImage*)buildImage:(UIImage*)image {
    // Crop a Combined Image from the taken picture
    CGRect rect = [imageContainerView bounds];
    UIGraphicsBeginImageContext(rect.size);
    [_workingView drawViewHierarchyInRect:_workingView.bounds afterScreenUpdates: false];
    [imageContainerView drawViewHierarchyInRect:imageContainerView.bounds afterScreenUpdates: false];
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tmp;
   // NSLog(@"tmpW: %f - tmpH: %f", tmp.size.width, tmp.size.height);
}


@end





#pragma mark - BORDERS VIEW IMPLEMENTATION ======================
@implementation _BordersView  {
    
    UIImageView *_imageView;
    UIButton *_deleteButton;
    
    CGFloat _scale;
    CGFloat _arg;
    
    CGPoint _initialPoint;
    CGFloat _initialArg;
    CGFloat _initialScale;
}



- (id)initWithImage:(UIImage *)image
{
    self = [super initWithFrame:CGRectMake(0, 0, _imageView.frame.size.width, _imageView.frame.size.height)];
    
    if(self){
        _imageView = [[UIImageView alloc] initWithImage:image];
        _imageView.center = self.center;
        
        width = imageContainerView.width;
        height = imageContainerView.height;
        
        _imageView.frame = CGRectMake(0,0, width, height);
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = true;
        
       // NSLog(@"width: %f - height: %f", width, height);
       // NSLog(@"imageW:%f - imageH%f", _imageView.frame.size.width, _imageView.frame.size.height);
        
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
