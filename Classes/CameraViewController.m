//
//  CameraViewController.m
//  NBUKitDemo
//
//  Created by Riksof Pvt. Ltd. on 22/Jan/2014.
//

#import "CameraViewController.h"
#import "CropViewController.h"

@implementation CameraViewController
@synthesize cameraLines;
@synthesize desiredImageSize;

/**
 * Setup the controller.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    globle = [FlyerlySingleton RetrieveSingleton];
    
    // Configure the camera view
    self.cameraView.shouldAutoRotateView = YES;
    self.cameraView.savePicturesToLibrary = NO;
    
    // BackButton
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [backButton addTarget:self action:@selector(cameraCancel:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"cancelcamera"] forState:UIControlStateNormal];
    backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Camerabottom"] forBarMetrics:UIBarMetricsDefault];
    
    self.cameraView.targetResolution = CGSizeMake(640.0, 640.0); // The minimum resolution we want
    self.cameraView.keepFrontCameraPicturesMirrored = YES;
    self.cameraView.captureResultBlock = ^(UIImage * image,
                                           NSError * error) {
        if (!error) {
            // Pass Image
            globle.NBUimage = [image thumbnailWithSize:CGSizeMake(310.0, 309.0)];
             self.navigationController.navigationBarHidden = NO;
            [self cropImage];
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
}

/**
 * Crop image using NBUKit
 */
-(void) cropImage {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg_without_logo2"] forBarMetrics:UIBarMetricsDefault];
    CropViewController *nbuCrop = [[CropViewController alloc] initWithNibName:@"CropViewController" bundle:nil];
    nbuCrop.desiredImageSize = desiredImageSize;

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
    globle.NBUimage = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * Move to the gallery.
 */
- (IBAction)moveToGallery:(id)sender{
    globle.NBUimage = nil;
    globle.gallerComesFromCamera = @"yes";
    GalleryViewController *nbugallery = [[GalleryViewController alloc]initWithNibName:@"GalleryViewController" bundle:nil];
    
    // Pop the current view, and push the crop view.
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [viewControllers addObject:nbugallery];
    [[self navigationController] setViewControllers:viewControllers animated:YES];
}

@end

