/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/


#import "ImageEditorViewController.h"
#import "ImageToolBase.h"
#import "Configs.h"


@interface ImageEditorViewController()
<
ImageToolProtocol
>
@property (nonatomic, strong) ImageToolBase *currentTool;
@property (nonatomic, strong, readwrite) ImageToolInfo *toolInfo;
@property (nonatomic, strong) UIImageView *targetImageView;
@end




@implementation ImageEditorViewController
{
    UIImage *_originalImage;
    UIView *_bgView;
}
@synthesize toolInfo = _toolInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)init
{
    self = [self initWithNibName:@"ImageEditorViewController" bundle:nil];
    if (self){
        _toolInfo = [ImageToolInfo toolInfoForToolClass:[self class]];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image
{
    return [self initWithImage:image delegate:nil];
}

- (id)initWithImage:(UIImage*)image delegate:(id<ImageEditorDelegate>)delegate
{
    self = [self init];
    if (self){
        _originalImage = [image deepCopy];
        self.delegate = delegate;
    }
    return self;
}

- (id)initWithDelegate:(id<ImageEditorDelegate>)delegate
{
    self = [self init];
    if (self){
        self.delegate = delegate;
    }
    return self;
}



- (void)viewWillAppear:(BOOL)animated {
    
    [self resetZoomScaleWithAnimated:true];
    [self resetImageViewFrame];
    
    
    if (_targetImageView){
        [self expropriateImageView];
        
    } else {
        [self refreshImageView];
    }
    
    
    // Set the Title's font and color
    _navigationBar.titleTextAttributes =   [NSDictionary dictionaryWithObjectsAndKeys:
    [UIColor whiteColor],
    NSForegroundColorAttributeName, NAVBAR_FONT,
    NSFontAttributeName,nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _toolInfo.title;
    
    [self resetImageViewFrame];
    
    self.view.frame = [UIScreen mainScreen].bounds;
    
    if([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.navigationController.interactivePopGestureRecognizer.enabled = false;
    }
       
    if (self.navigationController != nil){
        [self.navigationController setNavigationBarHidden:false animated:true];
        _navigationBar.hidden = true;
        [_navigationBar popNavigationItemAnimated:false];
    } else {
        _navigationBar.topItem.title = self.title;
    }
    
    [self setMenuView];
    
    if(_imageView==nil){
        _imageView = [UIImageView new];
        [_scrollView addSubview:_imageView];
    }
}




#pragma mark- View transition

- (void)copyImageViewInfo:(UIImageView*)fromView toView:(UIImageView*)toView
{
    CGAffineTransform transform = fromView.transform;
    fromView.transform = CGAffineTransformIdentity;
    
    toView.transform = CGAffineTransformIdentity;
    toView.frame = [toView.superview convertRect:fromView.frame fromView:fromView.superview];
    toView.transform = transform;
    toView.image = fromView.image;
    toView.contentMode = fromView.contentMode;
    toView.clipsToBounds = fromView.clipsToBounds;
    
    fromView.transform = transform;
}


- (void)expropriateImageView
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    UIImageView *animateView = [UIImageView new];
    [window addSubview:animateView];
    [self copyImageViewInfo:self.targetImageView toView:animateView];
    
    _bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:_bgView atIndex:0];
    
    _bgView.backgroundColor = self.view.backgroundColor;
    self.view.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:0];
    
    self.targetImageView.hidden = YES;
    _imageView.hidden = YES;
    _bgView.alpha = 0;
    _navigationBar.transform = CGAffineTransformMakeTranslation(0, -_navigationBar.height);
    _menuView.transform = CGAffineTransformMakeTranslation(0, self.view.height-_menuView.top);
    
    [UIView animateWithDuration:kImageToolAnimationDuration
                     animations:^{
                         animateView.transform = CGAffineTransformIdentity;
                         
                         CGFloat dy = ([UIDevice iosVersion]<7) ? [UIApplication sharedApplication].statusBarFrame.size.height : 0;
                         
                         CGSize size = (_imageView.image) ? _imageView.image.size : _imageView.frame.size;
                         if(size.width>0 && size.height>0){
                             CGFloat ratio = MIN(_scrollView.width / size.width, _scrollView.height / size.height);
                             CGFloat W = ratio * size.width;
                             CGFloat H = ratio * size.height;
                             animateView.frame = CGRectMake((_scrollView.width-W)/2 + _scrollView.left, (_scrollView.height-H)/2 + _scrollView.top + dy, W, H);
                         }
                         
                         _bgView.alpha = 1;
                         _navigationBar.transform = CGAffineTransformIdentity;
                         _menuView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         self.targetImageView.hidden = NO;
                         _imageView.hidden = NO;
                         [animateView removeFromSuperview];

                     }];
}

- (void)restoreImageView:(BOOL)canceled
{
    if(!canceled){
        self.targetImageView.image = _imageView.image;
    }
    self.targetImageView.hidden = true;
    
    id<ImageEditorTransitionDelegate> delegate = [self transitionDelegate];
    if([delegate respondsToSelector:@selector(imageEditor:willDismissWithImageView:canceled:)]){
        [delegate imageEditor:self willDismissWithImageView:self.targetImageView canceled:canceled];
    }
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    UIImageView *animateView = [UIImageView new];
    [window addSubview:animateView];
    [self copyImageViewInfo:_imageView toView:animateView];
    
    _menuView.frame = [window convertRect:_menuView.frame fromView:_menuView.superview];
    _navigationBar.frame = [window convertRect:_navigationBar.frame fromView:_navigationBar.superview];
    
    [window addSubview:_menuView];
    [window addSubview:_navigationBar];
    
    self.view.userInteractionEnabled = NO;
    _menuView.userInteractionEnabled = NO;
    _navigationBar.userInteractionEnabled = NO;
    _imageView.hidden = YES;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         _bgView.alpha = 0;
                         _menuView.alpha = 0;
                         _navigationBar.alpha = 0;
                         
                         _menuView.transform = CGAffineTransformMakeTranslation(0, self.view.height-_menuView.top);
                         _navigationBar.transform = CGAffineTransformMakeTranslation(0, -_navigationBar.height);
                         
                         [self copyImageViewInfo:self.targetImageView toView:animateView];
                     }
                     completion:^(BOOL finished) {
                         [animateView removeFromSuperview];
                         [_menuView removeFromSuperview];
                         [_navigationBar removeFromSuperview];
                         
                         [self willMoveToParentViewController:nil];
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                         
                         _imageView.hidden = NO;
                         self.targetImageView.hidden = NO;
                         
                         if([delegate respondsToSelector:@selector(imageEditor:didDismissWithImageView:canceled:)]){
                             [delegate imageEditor:self didDismissWithImageView:self.targetImageView canceled:canceled];


                         }
                     }
     ];
}

#pragma mark- Properties

- (id<ImageEditorTransitionDelegate>)transitionDelegate
{
    if([self.delegate conformsToProtocol:@protocol(ImageEditorTransitionDelegate)]){
        return (id<ImageEditorTransitionDelegate>)self.delegate;
    }
    return nil;
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    _toolInfo.title = title;
}

#pragma mark- ImageTool setting

+ (NSString*)defaultIconImagePath
{
    return nil;
}

+ (CGFloat)defaultDockedNumber
{
    return 0;
}

// Set the Title of the App ==========
+ (NSString*)defaultTitle
{
    return @"Editor";

}

+ (BOOL)isAvailable
{
    return true;
}

+ (NSArray*)subtools
{
    return [ImageToolInfo toolsWithToolClass:[ImageToolBase class]];
}

+ (NSDictionary*)optionalInfo
{
    return nil;
}




#pragma mark - SET MENU VIEW ================================

- (void)setMenuView {
    CGFloat x = 0;
    CGFloat W = 70;
    CGFloat H = _menuView.height;
    
    for(ImageToolInfo *info in self.toolInfo.sortedSubtools){
        if(!info.available){
            continue;
        }
        
        ToolbarMenuItem *view = [ImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedMenuView:) toolInfo:info];
      
        [_menuView addSubview:view];
        x += W;
    }
    _menuView.contentSize = CGSizeMake(MAX(x, _menuView.frame.size.width+1), 0);
}

- (void)resetImageViewFrame  {
    
    CGSize size = (_imageView.image) ? _imageView.image.size : _imageView.frame.size;
  //  NSLog(@"size: %f - %f", size.width, size.height);

    if(size.width > 0   &&   size.height > 0) {
        CGFloat ratio = MIN(_scrollView.frame.size.width / size.width, _scrollView.frame.size.height / size.height);
        CGFloat W = ratio * size.width * _scrollView.zoomScale;
        CGFloat H = ratio * size.height * _scrollView.zoomScale;
        _imageView.frame = CGRectMake((_scrollView.width-W)/2, (_scrollView.height-H)/2, W, H);
    }
    
    _scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin );
    
    /*
    // CONSOLE LOGS
    NSLog(@"ImageVIEW: %f -- %f", _imageView.frame.size.width, _imageView.frame.size.height);
    NSLog(@"UIImage: %f -- %f", _imageView.image.size.width, _imageView.image.size.height);
    NSLog(@"scrollView: %f - %f", _scrollView.frame.size.width, _scrollView.frame.size.height);
    */
}

- (void)fixZoomScaleWithAnimated:(BOOL)animated {
    CGFloat minZoomScale = _scrollView.minimumZoomScale;
    _scrollView.maximumZoomScale = 0.95*minZoomScale;
    _scrollView.minimumZoomScale = 0.95*minZoomScale;
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:animated];
}

- (void)resetZoomScaleWithAnimated:(BOOL)animated {
   // NSLog(@"resetZoomScaleWithAnimated");
    _scrollView.zoomScale = 1;
}

- (void)refreshImageView
{
    _imageView.image = _originalImage;
    
    [self resetImageViewFrame];
}

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

- (BOOL)shouldAutorotate
{
    return false;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}



#pragma mark- TOOL ACTIONS ===============
- (void)setCurrentTool:(ImageToolBase *)currentTool
{
    if (currentTool != _currentTool){
        [_currentTool cleanup];
        _currentTool = currentTool;
        [_currentTool setup];
        
        [self swapToolBarWithEditting:(_currentTool!=nil)];
    }
}



#pragma mark- MENU ACTIONS ==================
- (void)swapMenuViewWithEditting:(BOOL)editting
{
    [UIView animateWithDuration:kImageToolAnimationDuration animations:^{
            if (editting){
        _menuView.transform = CGAffineTransformMakeTranslation(0, self.view.height - _menuView.top);
        } else {
        _menuView.transform = CGAffineTransformIdentity;
        }
    }];
}

- (void)swapNavigationBarWithEditting:(BOOL)editting
{
    if(self.navigationController == nil){
        return;
    }
    
    [self.navigationController setNavigationBarHidden:editting animated:true];
    
    if (editting) {

        _navigationBar.hidden = NO;
        _navigationBar.transform = CGAffineTransformMakeTranslation(0, -_navigationBar.height);
        
        [UIView animateWithDuration:kImageToolAnimationDuration
                         animations:^{
        _navigationBar.transform = CGAffineTransformIdentity;
        }];
        
    } else {
        
        [UIView animateWithDuration:kImageToolAnimationDuration
                         animations:^{
                             _navigationBar.transform = CGAffineTransformMakeTranslation(0, -_navigationBar.height);
                         }
                         completion:^(BOOL finished) {
                             _navigationBar.hidden = YES;
                             _navigationBar.transform = CGAffineTransformIdentity;
                         }
         ];
    }
}

- (void)swapToolBarWithEditting:(BOOL)editting
{
    [self swapMenuViewWithEditting:editting];
    [self swapNavigationBarWithEditting:editting];
    
    if (self.currentTool){
        
        // Set the Title's font and color
        _navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
        [UIColor whiteColor], NSForegroundColorAttributeName,
        NAVBAR_FONT, NSFontAttributeName,nil];
        
        // Show the name of the current Tool you're using
        UINavigationItem *item  = [[UINavigationItem alloc] initWithTitle: self.currentTool.toolInfo.title];
        
        item.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ImageEditor_OKBtnTitle", @"") style:UIBarButtonItemStylePlain target:self action:@selector(pushedDoneBtn:)];
        
        item.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ImageEditor_BackBtnTitle", @"") style:UIBarButtonItemStylePlain target:self action:@selector(pushedCancelBtn:)];
        
        
        // Set the button bar item's Tint Color and Attributes
        [item.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
        [UIColor whiteColor], NSForegroundColorAttributeName,
        NAVBAR_FONT, NSFontAttributeName,nil] forState:UIControlStateNormal];
        item.rightBarButtonItem.tintColor = [UIColor blackColor];

        
        [item.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
        [UIColor lightGrayColor], NSForegroundColorAttributeName,
        NAVBAR_FONT, NSFontAttributeName,nil] forState:UIControlStateNormal];
        item.leftBarButtonItem.tintColor = [UIColor whiteColor];

        
        [_navigationBar pushNavigationItem:item animated:(self.navigationController==nil)];
   
    } else {
        [_navigationBar popNavigationItemAnimated:(self.navigationController==nil)];
    }
}

- (void)setupToolWithToolInfo:(ImageToolInfo*)info
{
    if(self.currentTool){ return; }
    
    Class toolClass = NSClassFromString(info.toolName);
    
    if(toolClass){
        id instance = [toolClass alloc];
        if(instance!=nil && [instance isKindOfClass:[ImageToolBase class]]){
            instance = [instance initWithImageEditor:self withToolInfo:info];
            self.currentTool = instance;
        }
    }
}

- (void)tappedMenuView:(UITapGestureRecognizer*)sender
{
    UIView *view = sender.view;
    
    view.alpha = 0.2;
    [UIView animateWithDuration:kImageToolAnimationDuration
                     animations:^{
                         view.alpha = 1;
                     }];
    
    [self setupToolWithToolInfo:view.toolInfo];
    
}



#pragma mark - CANCEL BUTTON METHOD ===================
- (IBAction)pushedCancelBtn:(id)sender
{
    _imageView.image = _originalImage;
    [self resetImageViewFrame];
    
    self.currentTool = nil;
}

#pragma mark - DONE BUTTON METHOD ======================
- (IBAction)pushedDoneBtn:(id)sender
{
    self.view.userInteractionEnabled = NO;
    
    [self.currentTool executeWithCompletionBlock:^(UIImage *image, NSError *error, NSDictionary *userInfo) {
        if(error){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if(image){
            _originalImage = image;
            _imageView.image = image;
            
            [self resetImageViewFrame];
            self.currentTool = nil;
        }
        self.view.userInteractionEnabled = true;
       }];
}



- (void)pushedCloseBtn:(id)sender  {
    if (self.targetImageView==nil){
        if([self.delegate respondsToSelector:@selector(imageEditorDidCancel:)]){
            [self.delegate imageEditorDidCancel:self];
      
        } else {
        [self dismissViewControllerAnimated:true completion:nil];
        }
        
    } else {
        _imageView.image = _targetImageView.image;
        [self restoreImageView:true];
    }
}

- (void)pushedFinishBtn:(id)sender
{
    if(self.targetImageView==nil){
        if([self.delegate respondsToSelector:@selector(imageEditor:didFinishEdittingWithImage:)]){
            [self.delegate imageEditor:self didFinishEdittingWithImage:_originalImage];
        
        } else {
       
            [self dismissViewControllerAnimated:true completion:nil];
        }
        
    } else {
        _imageView.image = _originalImage;
        [self restoreImageView:NO];
    }
}

#pragma mark- ScrollView delegate ============================

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat Ws = _scrollView.frame.size.width - _scrollView.contentInset.left - _scrollView.contentInset.right;
    CGFloat Hs = _scrollView.frame.size.height - _scrollView.contentInset.top - _scrollView.contentInset.bottom;
    CGFloat W = _imageView.frame.size.width;
    CGFloat H = _imageView.frame.size.height;
    
    CGRect rct = _imageView.frame;
    rct.origin.x = MAX((Ws-W)/2, 0);
    rct.origin.y = MAX((Hs-H)/2, 0);
    _imageView.frame = rct;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
