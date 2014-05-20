//
//  CameraViewController.m
//  NBUKitDemo
//
//  Created by Riksof Pvt. Ltd. on 22/Jan/2014.
//

#import "CameraViewController.h"
#import "CropViewController.h"
#import "LibraryViewController.h"

@implementation CameraViewController

NSMutableArray *productArray;

@synthesize cameraLines;
@synthesize desiredImageSize,progressView;
@synthesize onImageTaken,onVideoFinished,onVideoCancel,mode,videoAllow,flyerImageView,inAppPurchasePanel;

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
    
    if ([self.videoAllow isEqualToString:@"YES"]) {
        mode.hidden = NO;
    }else {
        mode.hidden = YES;
    }
    
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    UserPurchases *userPurchases_ = appDelegate.userPurchases;
   
    if ([[PFUser currentUser] sessionToken].length != 0) {
        
        if ( [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyAllDesignBundle"] ||
            [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyUnlockCreateVideoFlyerOption"] ) {
            
            productPurchased = YES;
        }
        
    }
    
    inAppPurchasePanel = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.origin.y, 320,400 )];
    inappviewcontroller = [[InAppPurchaseViewController alloc] initWithNibName:@"InAppPurchaseViewController" bundle:nil];
    
    inAppPurchasePanel = inappviewcontroller.view;
    inAppPurchasePanel.hidden = YES;
    [self.view addSubview:inAppPurchasePanel];
    
    //Here we Add Flyer ImageView For Video
    [self.cameraView addSubview:flyerImageView];
    flyerImageView.hidden = YES;
    
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
    
    
    // Configure for video
    // self.cameraView.targetMovieFolder = [UIApplication sharedApplication];
    
    self.cameraView.captureMovieResultBlock = ^(NSURL *movieUrl,NSError * error) {
        if (!error) {
            
           // NSLog(@"%@",movieUrl);
            self.onVideoFinished(movieUrl);
            [self.navigationController popViewControllerAnimated:YES];
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
 * Here we Open InAppPurchase Panel
 */
-(void)openPanel {
    
    inappviewcontroller.buttondelegate = self;
    
    if ( productArray.count == 0 ){
        [inappviewcontroller requestProduct];
    }
    
    inAppPurchasePanel.hidden = NO;
    [inAppPurchasePanel removeFromSuperview];
    
    inAppPurchasePanel = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.origin.y, 320,400 )];
    
    //inAppPurchasePanel = shareviewcontroller.view;
    inAppPurchasePanel = inappviewcontroller.view;
    [self.view addSubview:inAppPurchasePanel];
    inappviewcontroller.buttondelegate = self;
    inappviewcontroller.Yvalue = [NSString stringWithFormat:@"%f",self.view.frame.size.height];
    
    //Create Animation Here
    [inAppPurchasePanel setFrame:CGRectMake(0, self.view.frame.size.height, 320,265 )];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4f];
    [inAppPurchasePanel setFrame:CGRectMake(0, self.view.frame.size.height - 265, 320,265 )];
    [UIView commitAnimations];
    if( productArray.count != 0 ) {
        
        [inappviewcontroller.contentLoaderIndicatorView stopAnimating];
        inappviewcontroller.contentLoaderIndicatorView.hidden = YES;
    }
}


/**
 * Crop image using NBUKit
 */
-(void) cropImage:(UIImage *)image {
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    CropViewController *nbuCrop = [[CropViewController alloc] initWithNibName:@"CropViewController" bundle:nil];
    nbuCrop.desiredImageSize = desiredImageSize;
    nbuCrop.image = [image imageWithOrientationUp];
    nbuCrop.onImageTaken = onImageTaken;

    // Pop the current view, and push the crop view.
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [viewControllers addObject:nbuCrop];
    [[self navigationController] setViewControllers:viewControllers animated:YES];
}

#pragma mark - Button handlers

/**
 * Show / hide camera lines.
 */
- (IBAction)setCameraLine:(id)sender{
    if (cameraLines.hidden == YES) {
        cameraLines.hidden = NO;
    }else{
        cameraLines.hidden = YES;
    }
}

/**
 * Go Back.
 */
- (void)cameraCancel:(id)sender{
    
    if ([self.videoAllow isEqualToString:@"YES"]) {
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
    nbugallery.desiredImageSize = desiredImageSize;
    nbugallery.onImageTaken = onImageTaken;
    nbugallery.onVideoFinished = onVideoFinished;
    nbugallery.onVideoCancel = onVideoCancel;
    nbugallery.videoAllow = videoAllow;
    
    // Pop the current view, and push the crop view.
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [viewControllers addObject:nbugallery];
    [[self navigationController] setViewControllers:viewControllers animated:YES];
}

- ( void )inAppPurchasePanelContent {
    
    [inappviewcontroller.contentLoaderIndicatorView stopAnimating];
    inappviewcontroller.contentLoaderIndicatorView.hidden = YES;
    [inappviewcontroller inAppDataLoaded];
}

/*
 * Here we Manage Camera Mode for Image or Video
 */
- (IBAction)setCameraMode:(id)sender {

    UIButton *shoot = (UIButton *)  self.cameraView.shootButton;
    UIButton *flash = (UIButton *)  self.cameraView.flashButton;

    
    if ( !productPurchased )
    {
        [self openPanel];
    }
    else
    {
        if ([mode isSelected] == YES) {
            
            //Enable Camera Mode
            [mode setSelected:NO];
            [shoot setImage:[UIImage imageNamed:@"camera_button"] forState:UIControlStateNormal];
            [shoot setImage:[UIImage imageNamed:@"camera_button"] forState:UIControlStateSelected];
            [flash setHidden:NO];
            progressView.hidden = YES;
            flyerImageView.hidden = YES;
            
        }else {
            
            //Enable Video Mode
            [mode setSelected:YES];
            [shoot setImage:[UIImage imageNamed:@"recording_button"] forState:UIControlStateNormal];
            [shoot setImage:[UIImage imageNamed:@"stop_button"] forState:UIControlStateSelected];
            [flash setHidden:YES];
            progressView.hidden = NO;
            flyerImageView.image = nil;
            flyerImageView.hidden = NO;
            
            
        }
    }
    
    
    
}

/*
 *Here we Set Action Perform of Mode
 */
- (IBAction)setShootAction:(id)sender {
    
    UIButton *shoot = (UIButton *)  self.cameraView.shootButton;
    
    if ([mode isSelected] == YES) {
        
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
    
    if ([mode isSelected] == YES) {
        
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
    progressView.progress = progress;
    [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.1];
}

-(void)increaseProgress {
    progress+=0.0033;
    progressView.progress = progress;
    if(progress < 1.0)
        [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.1];
    else
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.0];
}

-(void)dismiss {
    
    [self.cameraView startStopRecording:nil];
}

- (void)inAppPurchasePanelButtonTappedWasPressed:(NSString *)inAppPurchasePanelButtonCurrentTitle {
    
    __weak InAppPurchaseViewController *inappviewcontroller_ = inappviewcontroller;
    if ([inAppPurchasePanelButtonCurrentTitle isEqualToString:(@"Sign In")]) {
        // Put code here for button's intended action.
        NSLog(@"Sign In was selected.");
        
        signInController = [[SigninController alloc]initWithNibName:@"SigninController" bundle:nil];
        
        FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
        signInController.launchController = appDelegate.lauchController;
        
        __weak CameraViewController *cameraViewController = self;
        __weak UserPurchases *userPurchases_ = appDelegate.userPurchases;
        userPurchases_.delegate = self;
        
        signInController.signInCompletion = ^void(void) {
            NSLog(@"Sign In via In App");
            
            UINavigationController* navigationController = cameraViewController.navigationController;
            [navigationController popViewControllerAnimated:NO];
            
            [inappviewcontroller_.inAppPurchasePanelButton setTitle:@"RESTORE PURCHASES"];
            // Showing action sheet after succesfull sign in
            [userPurchases_ setUserPurcahsesFromParse];
        };
        
        [self.navigationController pushViewController:signInController animated:YES];
    }else if ([inAppPurchasePanelButtonCurrentTitle isEqualToString:(@"RESTORE PURCHASES")]){
        //[inappviewcontroller_ restorePurchase];
    }
}

- (void) userPurchasesLoaded {
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    UserPurchases *userPurchases_ = appDelegate.userPurchases;
    
    if ( [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyAllDesignBundle"]  ||
        [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyUnlockSavedFlyers"] ) {
        
         NSLog(@"Sample,key found");
        productPurchased = YES;
        UIImage *buttonImage = [UIImage imageNamed:@"ModeVideo.png"];
        [mode setImage:buttonImage forState:UIControlStateNormal];
        //[mode setImage:[UIImage imageNamed:@"ModeVideo.png"] forState:UIControlStateHighlighted];
        [inappviewcontroller.tView reloadData];
    }
    
}

- ( void )productSuccesfullyPurchased: (NSString *)productId {
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    UserPurchases *userPurchases_ = appDelegate.userPurchases;
    if ( [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyAllDesignBundle"] ||
        [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyUnlockSavedFlyers"] ) {
        
        UIImage *buttonImage = [UIImage imageNamed:@"ModeVideo.png"];
        [mode setImage:buttonImage forState:UIControlStateNormal];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    UserPurchases *userPurchases_ = appDelegate.userPurchases;
    //NSMutableDictionary *oldPurchases =  userPurchases_.oldPurchases;//[[NSUserDefaults standardUserDefaults] valueForKey:@"InAppPurchases"];
    
    
    if ( [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyAllDesignBundle"] ||
        [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyUnlockSavedFlyers"] ) {
        
        UIImage *buttonImage = [UIImage imageNamed:@"ModeVideo.png"];
        [mode setImage:buttonImage forState:UIControlStateNormal];
    }
}



@end

