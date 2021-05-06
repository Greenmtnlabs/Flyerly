//
//  CameraViewController.m
//  NBUKitDemo
//
//  Created by Riksof Pvt. Ltd. on 22/Jan/2014.
//

#import "CameraViewController.h"
#import "CropViewController.h"
#import "LibraryViewController.h"
#import "CropVideoViewController.h"
#import "Common.h"

@implementation CameraViewController

@synthesize isVideoFlyer,tapAndHoldLabel;

/**
 * Setup the controller.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure the camera view
    self.cameraView.shouldAutoRotateView = YES;
    self.cameraView.savePicturesToLibrary = NO;
    self.takesPicturesWithVolumeButtons = NO;
    
    // Target folder is the temp directory.
    self.cameraView.targetMovieFolder = [UIApplication sharedApplication].temporaryDirectory;
    
    // BackButton
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [backButton addTarget:self action:@selector(cameraCancel:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"cancelcamera"] forState:UIControlStateNormal];
    backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Camerabottom"] forBarMetrics:UIBarMetricsDefault];
    
    productPurchased = NO;
    _mode.hidden = !_videoAllow;
    _mode.selected = YES;
    
    UserPurchases *userPurchases = [UserPurchases getInstance];
   
    if ([[PFUser currentUser] sessionToken].length != 0) {
        
        if ( [userPurchases canCreateVideoFlyer] ) {
            [_mode setImage:[UIImage imageNamed:@"ModeVideo.png"] forState:UIControlStateNormal];
        }
    }
    
    self.cameraView.targetResolution = CGSizeMake( 1024, 1024 ); // The minimum resolution we want
    self.cameraView.keepFrontCameraPicturesMirrored = YES;
    
    __weak CameraViewController *weakSelf = self;
    
    self.cameraView.captureResultBlock = ^(UIImage * image,
                                           NSError * error) {
        if (!error) {
            
            dispatch_async( dispatch_get_main_queue(), ^{
                // Pass Image
                weakSelf.navigationController.navigationBarHidden = NO;
          
                // Crop the image
                [weakSelf cropImage:image];
            });
        }
    };
    
    
    // Capture block for videos
    self.cameraView.captureMovieResultBlock = ^(NSURL *movieUrl, NSError * error) {
        if (!error) {

            
            // Do in the main UI thread.
            dispatch_async( dispatch_get_main_queue(), ^{
                // Show navigation bar
                weakSelf.navigationController.navigationBarHidden = NO;
                
                // Crop the video
                [weakSelf cropVideo:movieUrl];
            });

        }
        
    };

    self.cameraView.flashButtonConfigurationBlock = [self.cameraView buttonConfigurationBlockWithTitleFrom:
                                                    @[@"Flash Off", @"Flash On", @"Auto"]];
    self.cameraView.focusButtonConfigurationBlock = [self.cameraView buttonConfigurationBlockWithTitleFrom:
                                                    @[@"Fcs", @"Auto", @"Cont"]];
    self.cameraView.exposureButtonConfigurationBlock = [self.cameraView buttonConfigurationBlockWithTitleFrom:
                                                        @[@"Exp", @"Auto", @"Cont"]];
    self.cameraView.whiteBalanceButtonConfigurationBlock = [self.cameraView buttonConfigurationBlockWithTitleFrom:

                                                            @[@"Lckd", @"Auto", @"Cont"]];
        

    [self setCameraModeForVideo];
}

/*
 * Here we Open InAppPurchase Modal View
 */
-(void)openPanel {
    if( IS_IPHONE_4 ) {
        inappviewcontroller = [[InAppViewController alloc] initWithNibName:@"InAppViewController-iPhone4" bundle:nil];
    } else if( IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS || IS_IPHONE_XR || IS_IPHONE_XS){
        inappviewcontroller = [[InAppViewController alloc] initWithNibName:@"InAppViewController" bundle:nil];
    }else {
        inappviewcontroller = [[InAppViewController alloc] initWithNibName:@"InAppViewController-iPhone4" bundle:nil];
    }
    [self presentViewController:inappviewcontroller animated:YES completion:nil];
    
    [inappviewcontroller requestProduct];
    inappviewcontroller.buttondelegate = self;
}


/**
 * Crop image using NBUKit
 */
-(void) cropImage:(UIImage *)image {
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    CropViewController *nbuCrop;
    if( IS_IPHONE_4 || IS_IPHONE_5) {
        nbuCrop = [[CropViewController alloc] initWithNibName:@"CropViewController" bundle:nil];
    }else if ( IS_IPHONE_6){
        nbuCrop = [[CropViewController alloc] initWithNibName:@"CropViewController-iPhone6" bundle:nil];
    } else if ( IS_IPHONE_6_PLUS || IS_IPHONE_XR || IS_IPHONE_XS){
        nbuCrop = [[CropViewController alloc] initWithNibName:@"CropViewController-iPhone6-Plus" bundle:nil];
    } else{
        nbuCrop = [[CropViewController alloc] initWithNibName:@"CropViewController" bundle:nil];
    }
    
    nbuCrop.desiredImageSize = _desiredImageSize;
    /*if ( IS_IPHONE_6 ){
        nbuCrop.desiredImageSize =  CGSizeMake( 350,
               380);
    }*/
    nbuCrop.image = [image imageWithOrientationUp];
    nbuCrop.onImageTaken = _onImageTaken;

    // Pop the current view, and push the crop view.
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [viewControllers addObject:nbuCrop];
    [[self navigationController] setViewControllers:viewControllers animated:YES];
}

/**
 * Crop video using crop video view controller.
 */
-(void) cropVideo:(NSURL *)movieUrl {
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    //Background Thread
    CropVideoViewController *cropVideo;
    if( IS_IPHONE_4 || IS_IPHONE_5) {
        cropVideo = [[CropVideoViewController alloc] initWithNibName:@"CropVideoViewController" bundle:nil];
    }else if ( IS_IPHONE_6){
        cropVideo = [[CropVideoViewController alloc] initWithNibName:@"CropVideoViewController-iPhone6" bundle:nil];
    }else if ( IS_IPHONE_6_PLUS || IS_IPHONE_XR || IS_IPHONE_XS){
        cropVideo = [[CropVideoViewController alloc] initWithNibName:@"CropVideoViewController-iPhone6-Plus" bundle:nil];
    } else{
        cropVideo = [[CropVideoViewController alloc] initWithNibName:@"CropVideoViewController" bundle:nil];
    }
    
    cropVideo.desiredVideoSize = _desiredVideoSize;
    cropVideo.url = movieUrl;
    cropVideo.onVideoFinished = _onVideoFinished;
    cropVideo.onVideoCancel = _onVideoCancel;
    cropVideo.fromCamera = YES;
    
    // Pop the current view, and push the crop view.
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [viewControllers addObject:cropVideo];
    [[self navigationController] setViewControllers:viewControllers animated:YES];
}

#pragma mark - Button handlers

/**
 * Show / hide camera lines.
 */
- (IBAction)setCameraLine:(id)sender{
    _cameraLines.hidden = !_cameraLines.hidden;
}

/**
 * Go Back.
 */
- (void)cameraCancel:(id)sender{
    
    if ( _videoAllow ) {
        self.onVideoCancel();
    }
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * Move to the gallery.
 */
- (IBAction)moveToGallery:(id)sender{
    
    //HERE WE CHECK USER DID ALLOWED TO ACESS PHOTO library
    if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusRestricted || [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
        
        NSString *msg = [NSString stringWithFormat:@"%@ does not access to your photo album. To enable access go to the Settings app >> Privacy >> Photos and enable Flyerly",  APP_NAME];
        
        UIAlertView *photoAlert = [[UIAlertView alloc ] initWithTitle:@"" message: msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [photoAlert show];
        return;
        
    }

    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    LibraryViewController *nbugallery = [[LibraryViewController alloc]initWithNibName:@"LibraryViewController" bundle:nil];
    nbugallery.desiredImageSize = _desiredImageSize;
    nbugallery.desiredVideoSize = _desiredVideoSize;
    nbugallery.onImageTaken = _onImageTaken;
    nbugallery.onVideoFinished = _onVideoFinished;
    nbugallery.onVideoCancel = _onVideoCancel;
    nbugallery.videoAllow = _videoAllow;
    
    // Pop the current view, and push the crop view.
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [viewControllers addObject:nbugallery];
    [[self navigationController] setViewControllers:viewControllers animated:YES];
}

- ( void )inAppPurchasePanelContent
{
    [inappviewcontroller inAppDataLoaded];
}

/*
 * Here we Manage Camera Mode for Image or Video
 */
- (IBAction)setCameraMode:(id)sender {
    
    [self setCameraModeForVideo];
}


/*
 * Here we Manage Camera Mode for Image or Video
 */
- (void)setCameraModeForVideo {

    UIButton *shoot = (UIButton *)  self.cameraView.shootButton;
    UIButton *flash = (UIButton *)  self.cameraView.flashButton;

    UserPurchases *userPurchases_ = [UserPurchases getInstance];
    
    if ( self.isVideoFlyer && _videoAllow)
        _mode.selected = NO;
    
    if ( [userPurchases_ canCreateVideoFlyer] ) {
    
        if ( [_mode isSelected] == YES ) {
            // Enable Camera Mode
            [_mode setSelected:NO];
            [shoot setImage:[UIImage imageNamed:@"camera_button"] forState:UIControlStateNormal];
            [shoot setImage:[UIImage imageNamed:@"camera_button"] forState:UIControlStateSelected];
            [flash setHidden:NO];
            tapAndHoldLabel.alpha = 0;
            _progressView.hidden = YES;
        }else {
            // Enable Video Mode
            [_mode setSelected:YES];
            [shoot setImage:[UIImage imageNamed:@"recording_button"] forState:UIControlStateNormal];
            [shoot setImage:[UIImage imageNamed:@"stop_button"] forState:UIControlStateSelected];
            dispatch_async(dispatch_get_main_queue(), ^{
                [flash setHidden:YES];//works
            });
                
            tapAndHoldLabel.alpha = 1;
            _progressView.hidden = NO;
        }
    
    }else {
    
        if ( [_mode isSelected] == NO) {
            [self openPanel];
        }
        
        //Enable Camera Mode
        [_mode setSelected:NO];
        [shoot setImage:[UIImage imageNamed:@"camera_button"] forState:UIControlStateNormal];
        [shoot setImage:[UIImage imageNamed:@"camera_button"] forState:UIControlStateSelected];
        [flash setHidden:NO];
        _progressView.hidden = YES;
        
    }
    
    isVideoFlyer = NO;
}

/*
 *Here we Set Action Perform of Mode
 */
- (IBAction)setShootAction:(id)sender {
    
    UIButton *shoot = (UIButton *)  self.cameraView.shootButton;
    
    if ([_mode isSelected] == YES) {
        
        //Action for Video Mode
        [shoot setSelected:YES];
         progress = 1;

    } else {
        
        //Action for Camera Mode
        [shoot setSelected:NO];
        [self.cameraView takePicture:nil];
    
    }
}

- (IBAction)tapAndHold:(id)sender {
    UIButton *shoot = (UIButton *)  self.cameraView.shootButton;
    
    if ([_mode isSelected] == YES) {
        
        //Action for Video Mode
        [shoot setSelected:YES];
        [self.cameraView startStopRecording:nil];
        [self startRecording:sender];
    }
}


#pragma mark Progress Bar

- (IBAction)startRecording:(id)sender {
    UIButton *rec = sender;
    [rec setSelected:YES];
    [self showWithProgress:nil];
    
}

-(IBAction)showWithProgress:(id)sender {
    progress = 0.0f;
    _progressView.progress = progress;
    [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.1];
}

-(void)increaseProgress {
    progress+=0.0033;
    _progressView.progress = progress;
    if(progress < 1.0)
        [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.1];
    else
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.0];
}

-(void)dismiss {
    
    [self.cameraView startStopRecording:nil];
}

- (void)inAppPurchasePanelButtonTappedWasPressed:(NSString *)inAppPurchasePanelButtonCurrentTitle
{
    
    __weak InAppViewController *inappviewcontroller_ = inappviewcontroller;
    if ([inAppPurchasePanelButtonCurrentTitle isEqualToString:(@"Sign In")])
    {
        // Put code here for button's intended action.
        signInController = [[SigninController alloc]initWithNibName:@"SigninController" bundle:nil];
        
        FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
        signInController.launchController = appDelegate.lauchController;
        
        __weak CameraViewController *cameraViewController = self;
        UserPurchases *userPurchases_ = [UserPurchases getInstance];
        
        userPurchases_.delegate = self;
        
        [inappviewcontroller_.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        
        signInController.signInCompletion = ^void(void) {
            
            UINavigationController* navigationController = cameraViewController.navigationController;
            [navigationController popViewControllerAnimated:NO];
            [userPurchases_ setUserPurcahsesFromParse];
        };
        
        [self.navigationController pushViewController:signInController animated:YES];
    }
    else if ([inAppPurchasePanelButtonCurrentTitle isEqualToString:(@"Restore Purchases")]){
        [inappviewcontroller_ restorePurchase];
    }
}

- (void) userPurchasesLoaded
{
    UserPurchases *userPurchases_ = [UserPurchases getInstance];
    
    if ( [userPurchases_ canCreateVideoFlyer] )
    {
        [_mode setImage:[UIImage imageNamed:@"ModeVideo.png"] forState:UIControlStateNormal];
        [inappviewcontroller.paidFeaturesTview reloadData];
    }
    else
    {
        
        [self presentViewController:inappviewcontroller animated:YES completion:nil];
    }
}

- ( void )productSuccesfullyPurchased: (NSString *)productId
{
    UserPurchases *userPurchases_ = [UserPurchases getInstance];
    
    if ( [userPurchases_ canCreateVideoFlyer] )
    {
        UIImage *buttonImage = [UIImage imageNamed:@"ModeVideo.png"];
        [_mode setImage:buttonImage forState:UIControlStateNormal];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Camerabottom"] forBarMetrics:UIBarMetricsDefault];
    
    UserPurchases *userPurchases_ = [UserPurchases getInstance];
    
    if ( [userPurchases_ canCreateVideoFlyer] )
    {
        UIImage *buttonImage = [UIImage imageNamed:@"ModeVideo.png"];
        [_mode setImage:buttonImage forState:UIControlStateNormal];
    }
}

- (void)inAppPanelDismissed
{

}

@end

