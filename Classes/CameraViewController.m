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

@implementation CameraViewController

NSMutableArray *productArray;

/**
 * Setup the controller.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure the camera view
    self.cameraView.shouldAutoRotateView = YES;
    self.cameraView.savePicturesToLibrary = NO;
    self.takesPicturesWithVolumeButtons = NO;
    
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
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    userPurchases = appDelegate.userPurchases;
   
    if ([[PFUser currentUser] sessionToken].length != 0) {
        
        if ( [userPurchases checkKeyExistsInPurchases:@"comflyerlyAllDesignBundle"] ||
             [userPurchases checkKeyExistsInPurchases:@"comflyerlyUnlockCreateVideoFlyerOption"] ) {
            
            [_mode setBackgroundImage:[UIImage imageNamed:@"ModeVideo.png"]
                                forState:UIControlStateNormal];
        }
        
    }
    
    //Here we Add Flyer ImageView For Video
    [self.cameraView addSubview:_flyerImageView];
    _flyerImageView.hidden = YES;
    
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
        

}

/*
 * Here we Open InAppPurchase Modal View
 */
-(void)openPanel {
    
    inappviewcontroller = [[[InAppViewController alloc] init] autorelease];
    [self presentModalViewController:inappviewcontroller animated:YES];
    if ( productArray.count == 0 ){
        [inappviewcontroller requestProduct];
    }
    if( productArray.count != 0 ) {
        
        //[inappviewcontroller.contentLoaderIndicatorView stopAnimating];
        //inappviewcontroller.contentLoaderIndicatorView.hidden = YES;
    }
    
    inappviewcontroller.buttondelegate = self;
}


/**
 * Crop image using NBUKit
 */
-(void) cropImage:(UIImage *)image {
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    CropViewController *nbuCrop = [[CropViewController alloc] initWithNibName:@"CropViewController" bundle:nil];
    nbuCrop.desiredImageSize = _desiredImageSize;
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
    
    CropVideoViewController *cropVideo = [[CropVideoViewController alloc] initWithNibName:@"CropVideoViewController" bundle:nil];
    cropVideo.desiredVideoSize = _desiredImageSize;
    cropVideo.url = movieUrl;
    cropVideo.onVideoFinished = _onVideoFinished;
    cropVideo.onVideoCancel = _onVideoCancel;
    
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
        self.flyerImageView.hidden = NO;
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
        
        UIAlertView *photoAlert = [[UIAlertView alloc ] initWithTitle:@"" message:@"Flyerly does not access to your photo album.To enable access go to the Settings app >> Privacy >> Photos and enable Flyerly" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [photoAlert show];
        return;
        
    }

    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    LibraryViewController *nbugallery = [[LibraryViewController alloc]initWithNibName:@"LibraryViewController" bundle:nil];
    nbugallery.desiredImageSize = _desiredImageSize;
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

- ( void )inAppPurchasePanelContent {
    
    [inappviewcontroller inAppDataLoaded];
}

/*
 * Here we Manage Camera Mode for Image or Video
 */
- (IBAction)setCameraMode:(id)sender {

    UIButton *shoot = (UIButton *)  self.cameraView.shootButton;
    UIButton *flash = (UIButton *)  self.cameraView.flashButton;

    if ([[PFUser currentUser] sessionToken].length != 0) {
        if ( [userPurchases checkKeyExistsInPurchases:@"comflyerlyAllDesignBundle"] ||
             [userPurchases checkKeyExistsInPurchases:@"comflyerlyUnlockCreateVideoFlyerOption"] ) {
            
            if ([_mode isSelected] == YES) {
                
                //Enable Camera Mode
                [_mode setSelected:NO];
                [shoot setImage:[UIImage imageNamed:@"camera_button"] forState:UIControlStateNormal];
                [shoot setImage:[UIImage imageNamed:@"camera_button"] forState:UIControlStateSelected];
                [flash setHidden:NO];
                _progressView.hidden = YES;
                _flyerImageView.hidden = YES;
                
            }else {
                
                //Enable Video Mode
                [_mode setSelected:YES];
                [shoot setImage:[UIImage imageNamed:@"recording_button"] forState:UIControlStateNormal];
                [shoot setImage:[UIImage imageNamed:@"stop_button"] forState:UIControlStateSelected];
                [flash setHidden:YES];
                _progressView.hidden = NO;
                _flyerImageView.image = nil;
                _flyerImageView.hidden = NO;
            }
        }else {
            [self openPanel];
        }
    
    }else {
        [self openPanel];
    }
    
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

- (void)inAppPurchasePanelButtonTappedWasPressed:(NSString *)inAppPurchasePanelButtonCurrentTitle {
    
    __weak InAppViewController *inappviewcontroller_ = inappviewcontroller;
    if ([inAppPurchasePanelButtonCurrentTitle isEqualToString:(@"Sign In")]) {
        
        // Put code here for button's intended action.
        signInController = [[SigninController alloc]initWithNibName:@"SigninController" bundle:nil];
        
        FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
        signInController.launchController = appDelegate.lauchController;
        
        __weak CameraViewController *cameraViewController = self;
        __weak UserPurchases *userPurchases_ = appDelegate.userPurchases;
        userPurchases_.delegate = self;
        
        [inappviewcontroller_.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        
        signInController.signInCompletion = ^void(void) {
            
            UINavigationController* navigationController = cameraViewController.navigationController;
            [navigationController popViewControllerAnimated:NO];
            [userPurchases_ setUserPurcahsesFromParse];
        };
        
        [self.navigationController pushViewController:signInController animated:YES];
    }else if ([inAppPurchasePanelButtonCurrentTitle isEqualToString:(@"RESTORE PURCHASES")]){
        [inappviewcontroller_ restorePurchase];
    }
}

- (void) userPurchasesLoaded {
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    UserPurchases *userPurchases_ = appDelegate.userPurchases;
    
    if ( [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyAllDesignBundle"]  ||
         [userPurchases_ checkKeyExistsInPurchases:@"com.flyerly.UnlockCreateVideoFlyerOption"] ) {
        
        [_mode setImage:[UIImage imageNamed:@"ModeVideo.png"] forState:UIControlStateNormal];
        [inappviewcontroller.paidFeaturesTview reloadData];
    }else {
        
        [self presentModalViewController:inappviewcontroller animated:YES];
    }
    
}

- ( void )productSuccesfullyPurchased: (NSString *)productId {
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    UserPurchases *userPurchases_ = appDelegate.userPurchases;
    if ( [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyAllDesignBundle"] ||
        [userPurchases_ checkKeyExistsInPurchases:@"com.flyerly.UnlockCreateVideoFlyerOption"] ) {
        
        UIImage *buttonImage = [UIImage imageNamed:@"ModeVideo.png"];
        [_mode setImage:buttonImage forState:UIControlStateNormal];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    UserPurchases *userPurchases_ = appDelegate.userPurchases;
    //NSMutableDictionary *oldPurchases =  userPurchases_.oldPurchases;//[[NSUserDefaults standardUserDefaults] valueForKey:@"InAppPurchases"];
    
    
    if ( [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyAllDesignBundle"] ||
        [userPurchases_ checkKeyExistsInPurchases:@"com.flyerly.UnlockCreateVideoFlyerOption"] ) {
        
        UIImage *buttonImage = [UIImage imageNamed:@"ModeVideo.png"];
        [_mode setImage:buttonImage forState:UIControlStateNormal];
    }
}



@end

