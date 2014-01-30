//
//  CameraViewController.m
//  NBUKitDemo
//
//  Created by Riksof Pvt. Ltd. on 22/Jan/2014.
//

#import "CameraViewController.h"
#import "CropViewController.h"

@implementation CameraViewController

@synthesize shootButton = _shootButton,cameraLines;
@synthesize slideView = _slideView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    globle = [FlyerlySingleton RetrieveSingleton];
    
    // Configure the slide view
    _slideView.targetObjectViewSize = CGSizeMake(46.0, 46.0);
    _slideView.margin = CGSizeMake(2.0, 2.0);
    
    // Configure the camera view
    self.cameraView.shouldAutoRotateView = YES;
    self.cameraView.savePicturesToLibrary = YES;
    
    //BackButton
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [backButton addTarget:self action:@selector(CameraCancel:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"cancelcamera"] forState:UIControlStateNormal];
    backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    
    

    
    self.cameraView.targetResolution = CGSizeMake(640.0, 640.0); // The minimum resolution we want
    self.cameraView.keepFrontCameraPicturesMirrored = YES;
    self.cameraView.captureResultBlock = ^(UIImage * image,
                                           NSError * error)
    {
        if (!error)
        {
            // *** Only used to update the slide view ***
            /*
            UIImage * thumbnail = [image thumbnailWithSize:_slideView.targetObjectViewSize];
            NSMutableArray * tmp = [NSMutableArray arrayWithArray:_slideView.objectArray];
            [tmp insertObject:thumbnail atIndex:0];
            _slideView.objectArray = tmp;*/
            
            //Pass Image
            globle.NBUimage = [[UIImage alloc] init];
            globle.NBUimage = [image thumbnailWithSize:CGSizeMake(310.0, 309.0)];
             self.navigationController.navigationBarHidden = NO;
            [self cropImage];
            //[self.navigationController popViewControllerAnimated:YES];
        }
    };
    
    self.cameraView.flashButtonConfigurationBlock = [self.cameraView buttonConfigurationBlockWithTitleFrom:
                                                    @[@"Flash", @"On", @"Auto"]];
    self.cameraView.focusButtonConfigurationBlock = [self.cameraView buttonConfigurationBlockWithTitleFrom:
                                                    @[@"Fcs", @"Auto", @"Cont"]];
    self.cameraView.exposureButtonConfigurationBlock = [self.cameraView buttonConfigurationBlockWithTitleFrom:
                                                        @[@"Exp", @"Auto", @"Cont"]];
    self.cameraView.whiteBalanceButtonConfigurationBlock = [self.cameraView buttonConfigurationBlockWithTitleFrom:
                                                            @[@"Lckd", @"Auto", @"Cont"]];
    
    // Configure for video
//    self.cameraView.targetMovieFolder = [UIApplication sharedApplication].temporaryDirectory;
    
    // Optionally auto-save pictures to the library
    self.cameraView.saveResultBlock = ^(UIImage * image,
                                        NSDictionary * metadata,
                                        NSURL * url,
                                        NSError * error)
    {
        // *** Do something with the image and its URL ***
        NSLog(@"Done");
    };
    
    // Connect the shoot button
    self.cameraView.shootButton = _shootButton;
    [_shootButton addTarget:self.cameraView
                     action:@selector(takePicture:)
           forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Disconnect shoot button
    [_shootButton removeTarget:nil
                        action:@selector(takePicture:)
              forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Camerabottom"] forBarMetrics:UIBarMetricsDefault];    // Enable shootButton
    _shootButton.userInteractionEnabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Disable shootButton
    _shootButton.userInteractionEnabled = NO;
}

- (IBAction)customToggleFlash:(id)sender
{
    // We intentionally skip AVCaptureFlashModeAuto
    if (self.cameraView.currentFlashMode == AVCaptureFlashModeOff)
    {
        self.cameraView.currentFlashMode = AVCaptureFlashModeOn;
    }
    else
    {
        self.cameraView.currentFlashMode = AVCaptureFlashModeOff;
    }
}

/**
 * Crop image using NBUKit
 */
-(void) cropImage {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg_without_logo2"] forBarMetrics:UIBarMetricsDefault];
    CropViewController *nbuCrop = [[CropViewController alloc] initWithNibName:@"CropViewController" bundle:nil];

    // Pop the current view, and push the crop view.
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [viewControllers addObject:nbuCrop];
    [[self navigationController] setViewControllers:viewControllers animated:YES];
}

- (IBAction)setCameraline:(id)sender{
    if (cameraLines.hidden == YES) {
        cameraLines.hidden = NO;
    }else{
        cameraLines.hidden = YES;
    }
}

- (IBAction)CameraCancel:(id)sender{
    globle.NBUimage = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)MovetoGallery:(id)sender{
    globle.NBUimage = nil;
    globle.gallerComesFromCamera = @"yes";
    GalleryViewController *nbugallery = [[GalleryViewController alloc]initWithNibName:@"GalleryViewController" bundle:nil];
    [self.navigationController pushViewController:nbugallery animated:YES];
}

@end

