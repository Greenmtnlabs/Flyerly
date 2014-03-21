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
@synthesize cameraLines;
@synthesize desiredImageSize;
@synthesize onImageTaken,onVideoFinished;

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
    
    self.cameraView.targetResolution = CGSizeMake(640.0, 640.0); // The minimum resolution we want
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
            
            NSLog(@"%@",movieUrl);
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
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * Move to the gallery.
 */
- (IBAction)moveToGallery:(id)sender{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    LibraryViewController *nbugallery = [[LibraryViewController alloc]initWithNibName:@"LibraryViewController" bundle:nil];
    nbugallery.desiredImageSize = desiredImageSize;
    nbugallery.onImageTaken = onImageTaken;
    
    // Pop the current view, and push the crop view.
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [viewControllers addObject:nbugallery];
    [[self navigationController] setViewControllers:viewControllers animated:YES];
}


- (IBAction)startRecording:(id)sender {
    UIButton *rec = sender;
    [rec setSelected:YES];

}
@end

