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
@synthesize desiredImageSize,progressView;
@synthesize onImageTaken,onVideoFinished,onVideoCancel,mode,videoAllow,flyerImageView;

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
    
    if ([self.videoAllow isEqualToString:@"YES"]) {
        mode.hidden = NO;
    }else {
        mode.hidden = YES;
    }
    
    //Here we Add Flyer ImageView For Video
    [self.cameraView addSubview:flyerImageView];
    flyerImageView.hidden = YES;
    
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
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    LibraryViewController *nbugallery = [[LibraryViewController alloc]initWithNibName:@"LibraryViewController" bundle:nil];
    nbugallery.desiredImageSize = desiredImageSize;
    nbugallery.onImageTaken = onImageTaken;
    nbugallery.onVideoFinished = onVideoFinished;
    nbugallery.videoAllow = videoAllow;
    
    // Pop the current view, and push the crop view.
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [viewControllers addObject:nbugallery];
    [[self navigationController] setViewControllers:viewControllers animated:YES];
}



/*
 * Here we Manage Camera Mode for Image or Video
 */
- (IBAction)setCameraMode:(id)sender {

    UIButton *shoot = (UIButton *)  self.cameraView.shootButton;
    UIButton *flash = (UIButton *)  self.cameraView.flashButton;

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

/*
 *Here we Set Action Perform of Mode
 */
- (IBAction)setShootAction:(id)sender {
    
    UIButton *shoot = (UIButton *)  self.cameraView.shootButton;
    
    if ([mode isSelected] == YES) {
        
        //Action for Video Mode
        [shoot setSelected:YES];
        [self.cameraView startStopRecording:nil];
        [self startRecording:sender];


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


static float progress = 0.0f;

-(IBAction)showWithProgress:(id)sender {
    progress = 0.0f;
    progressView.progress = progress;
    [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.3];
}

-(void)increaseProgress {
    progress+=0.01f;
    progressView.progress = progress;
    if(progress < 1.0)
        [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.3];
    else
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.0];
}

-(void)dismiss {
    
    [self.cameraView startStopRecording:nil];
}


@end

