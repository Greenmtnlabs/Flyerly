/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/


#import <QuartzCore/QuartzCore.h>
#import "CameraViewController.h"
#import "AppDelegate.h"
#import "PreviewVC.h"
#import "SettingsVC.h"


@interface CameraViewController ()
@end


@implementation CameraViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(BOOL)prefersStatusBarHidden {
    return true;
}
// Prevent the StatusBar from showing up after picking an image
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:true];
}



#pragma mark - VIEW SETUP METHODS
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Retake & Done buttons translations
    [_retakeOutlet setTitle:NSLocalizedString(@"RETAKE", @"") forState:UIControlStateNormal];
    [_doneOutlet setTitle:NSLocalizedString(@"NEXT", @"") forState:UIControlStateNormal];

    // Reset sliders
    _tintSlider.value = 0;
    _temperatureSlider.value = 5500;
    _exposureSlider.value = 0;
    tintON = false;
    exposureON = false;
    _tintView.hidden = true;
    _exposureView.hidden = true;
    
    // Set default Booleans
    pickerDidShow = false;
    FrontCamera = false;
    initializeCamera = true;
    photoFromCam = true;
    
    
    // Hide the captureImage
    _captureImage.hidden = true;
    
    
    // Alloc cropped Image for further use
    croppedImageWithoutOrientation = [[UIImage alloc] init];
  
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (initializeCamera){
        initializeCamera = false;
        
        // Initialize the Camera
        [self initializeCamera];
        
        flashON = false;
       //NSLog(@"flashON: %d", flashON);

    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}




#pragma mark - CAMERA INITIALIZATION

//AVCaptureSession to show live video feed in view
- (void) initializeCamera {
    if (session)
        [session release], session=nil;
    
    session = [[AVCaptureSession alloc] init];
	session.sessionPreset = AVCaptureSessionPresetPhoto;
	
    if (captureVideoPreviewLayer) {
        [captureVideoPreviewLayer release], captureVideoPreviewLayer = nil;
    }
	captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    
	captureVideoPreviewLayer.frame = _imagePreviewView.bounds;
	[_imagePreviewView.layer addSublayer:captureVideoPreviewLayer];
	
    
    UIView *view = [self imagePreviewView];
    CALayer *viewLayer = [view layer];
    [viewLayer setMasksToBounds: true];
    CGRect bounds = [view bounds];
    [captureVideoPreviewLayer setFrame:bounds];
    
    
    NSArray *devices = [AVCaptureDevice devices];
    frontCamera = nil;
    backCamera = nil;
    
    
    // Checks if camera is available
    if (devices.count == 0) {
        NSLog(@"No Camera Available");
        [self disableCameraDeviceControls];
        return;
    }
    
    for (AVCaptureDevice *device in devices) {
        if ([device hasMediaType:AVMediaTypeVideo]) {
            if ([device position] == AVCaptureDevicePositionBack) {
                backCamera = device;
            } else {
                frontCamera = device;
            }
        }
    }
    
    
    
    if (!FrontCamera) {
        
        // Back camera has Flash
        if ([backCamera hasFlash]) {
            [backCamera lockForConfiguration:nil];
            if (flashON) {
                backCamera.flashMode = AVCaptureFlashModeOn;
            } else {
                backCamera.flashMode = AVCaptureFlashModeOff;
                
            [backCamera unlockForConfiguration];
            _flashToggleButton.enabled = true;
            }
            
        // Back camera doesn't have Flash
        } else {
            if ([backCamera isFlashModeSupported:AVCaptureFlashModeOff]) {
                [backCamera lockForConfiguration:nil];
                [backCamera setFlashMode:AVCaptureFlashModeOff];
                [backCamera unlockForConfiguration];
            }
            _flashToggleButton.enabled = false;
        }
        
        
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
        if (!input) {
            NSLog(@"ERROR: trying to open camera: %@", error);
        }
        [session addInput:input];
    }
    
    
    
    // Front camera enabled ===========================
    if (FrontCamera) {
        
        _flashToggleButton.enabled = false;
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
        if (!input) {
            NSLog(@"ERROR: trying to open camera: %@", error);
        }
        [session addInput:input];
    }
     
    if (stillImageOutput)
        [stillImageOutput release], stillImageOutput=nil;
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil] autorelease];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
    
	[session startRunning];
}




#pragma mark EXPOSURE BUTTON & SLIDER
- (IBAction)exposureButt:(id)sender {
    exposureON = !exposureON;
    
    _exposureLabel.text = [NSString stringWithFormat:@"Exposure: %.02f", _exposureSlider.value];
    if (exposureON) {
        _exposureView.hidden = false;
        [_exposureOut setBackgroundImage:[UIImage imageNamed:@"exposureON"] forState:UIControlStateNormal];
    } else {
        _exposureView.hidden = true;
        [_exposureOut setBackgroundImage:[UIImage imageNamed:@"exposureOFF"] forState:UIControlStateNormal];
    }
}


- (IBAction)changeExposureBias:(UISlider *)sender {
        NSError *error = nil;
    
    // Back Camera active
    if (!FrontCamera)  {
    if ([backCamera lockForConfiguration:&error]) {
        [backCamera setExposureTargetBias: sender.value completionHandler:nil];
        [backCamera unlockForConfiguration];
        _exposureLabel.text = [NSString stringWithFormat:@"Exposure: %.02f", sender.value];
    } else {
        NSLog(@"%@", error);
    }
    
    // Front Camera active
    } else {
        if ([frontCamera lockForConfiguration:&error]) {
            [frontCamera setExposureTargetBias: sender.value completionHandler:nil];
            [frontCamera unlockForConfiguration];
            _exposureLabel.text = [NSString stringWithFormat:@"Exposure: %.02f", sender.value];
        } else {
            NSLog(@"%@", error);
        }
    }
}




#pragma mark - TINT BUTTON & SLIDERS

- (IBAction)tintButt:(id)sender {
    if (!FrontCamera) {
    tintON = !tintON;
    
    _tintLabel.text = [NSString stringWithFormat:@"Tint: %.01f", _tintSlider.value];
    _temperatureLabel.text = [NSString stringWithFormat:@"Temperature: %.01f", _temperatureSlider.value];
    
    if (tintON) {
        _tintView.hidden = false;
        [_tintOut setBackgroundImage:[UIImage imageNamed:@"tintON"] forState:UIControlStateNormal];
    } else {
        _tintView.hidden = true;
        [_tintOut setBackgroundImage:[UIImage imageNamed:@"tintOFF"] forState:UIControlStateNormal];
    }
        
    }
}



- (IBAction)changeTemperature:(UISlider *)sender {
    AVCaptureWhiteBalanceTemperatureAndTintValues temperatureAndTint = {
        .temperature = _temperatureSlider.value,
        .tint = _tintSlider.value,
    };
    _temperatureLabel.text = [NSString stringWithFormat:@"Temperature: %.01f", _temperatureSlider.value];

    [self setWhiteBalanceGains:[backCamera deviceWhiteBalanceGainsForTemperatureAndTintValues:temperatureAndTint]];
}

- (IBAction)changeTint:(UISlider *)sender {
    AVCaptureWhiteBalanceTemperatureAndTintValues temperatureAndTint = {
        .temperature = _temperatureSlider.value,
        .tint = _tintSlider.value,
    };
    _tintLabel.text = [NSString stringWithFormat:@"Tint: %.01f", _tintSlider.value];

    [self setWhiteBalanceGains:[backCamera deviceWhiteBalanceGainsForTemperatureAndTintValues:temperatureAndTint]];
}

- (void)setWhiteBalanceGains:(AVCaptureWhiteBalanceGains)gains {
        NSError *error = nil;
        
        if ([backCamera lockForConfiguration:&error]) {
            AVCaptureWhiteBalanceGains normalizedGains = [self normalizedGains:gains]; // Conversion can yield out-of-bound values, cap to limits
            [backCamera setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains:normalizedGains completionHandler:nil];
            [backCamera unlockForConfiguration];
        } else {
            NSLog(@"%@", error);
        }
    }
    
- (AVCaptureWhiteBalanceGains)normalizedGains:(AVCaptureWhiteBalanceGains) gains {
    AVCaptureWhiteBalanceGains g = gains;
        
    g.redGain = MAX(1.0, g.redGain);
    g.greenGain = MAX(1.0, g.greenGain);
    g.blueGain = MAX(1.0, g.blueGain);
        
    g.redGain = MIN(backCamera.maxWhiteBalanceGain, g.redGain);
    g.greenGain = MIN(backCamera.maxWhiteBalanceGain, g.greenGain);
    g.blueGain = MIN(backCamera.maxWhiteBalanceGain, g.blueGain);
        
    return g;
}
    
    
    

#pragma mark - SNAP IMAGE BUTTON
- (IBAction)camButt:(id)sender {
    _camOut.enabled = false;
    
    if (!haveImage) {
        _captureImage.image = nil; // Remove old image from view
        _captureImage.hidden = false; // Show the captured image view
        _imagePreviewView.hidden = true; // Hide the live video feed
        [self capImage];
   
    } else {
        _captureImage.hidden = true;
        _imagePreviewView.hidden = false;
        haveImage = false;
    }
    
    
    // Reset Exposure View
    exposureON = false;
    _exposureView.hidden = true;
    [_exposureOut setBackgroundImage:[UIImage imageNamed:@"exposureOFF"] forState:UIControlStateNormal];

    // Reset Tint View
    tintON = false;
    _tintView.hidden = true;
    [_tintOut setBackgroundImage:[UIImage imageNamed:@"tintOFF"] forState:UIControlStateNormal];

}
// Method to capture Image from AVCaptureSession
- (void) capImage {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections) {
        
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        
        if (videoConnection) {
            break;
        }
    }
    
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        
        if (imageSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
            [self processImage:[UIImage imageWithData:imageData]];
        }
    }];
}




#pragma mark - PROCESS CAPTURED IMAGE, Crop, Resize and Rotate it
- (void) processImage:(UIImage *)image {
    haveImage = true;
    photoFromCam = true;

    
    UIImage *smallImage = [self imageWithImage:image scaledToWidth: 640.0f];
    CGRect cropRect = CGRectMake(0, 0, 640, 1136);
    CGImageRef imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
    croppedImageWithoutOrientation = [[UIImage imageWithCGImage:imageRef] copy];
    
    UIImage *croppedImage = nil;
    // adjust image orientation
    switch ([[UIDevice currentDevice] orientation]) {
        case UIDeviceOrientationLandscapeLeft:
            croppedImage = [[[UIImage alloc] initWithCGImage: imageRef
                                                        scale: 1.0
                                                  orientation: UIImageOrientationLeft] autorelease];
            break;
        case UIDeviceOrientationLandscapeRight:
            croppedImage = [[[UIImage alloc] initWithCGImage: imageRef
                                                        scale: 1.0
                                                  orientation: UIImageOrientationRight] autorelease];
            break;
            
        case UIDeviceOrientationFaceUp:
            croppedImage = [[[UIImage alloc] initWithCGImage: imageRef
                                                        scale: 1.0
                                                  orientation: UIImageOrientationUp] autorelease];
            break;
        
        case UIDeviceOrientationPortraitUpsideDown:
            croppedImage = [[[UIImage alloc] initWithCGImage: imageRef
                                                      scale: 1.0
                                                orientation: UIImageOrientationDown] autorelease];
            break;
            
        default:
            croppedImage = [UIImage imageWithCGImage:imageRef];
            break;
    }
    CGImageRelease(imageRef);

    
    [_captureImage setImage:croppedImage];
    NSLog(@"ImageSize: %f - %f", croppedImage.size.width, croppedImage.size.height);
    
    
    [self setCapturedImage];
}

- (void)setCapturedImage {
    // This piece of code is needed in case of a picture taken with Front Camera, because the front camera saves mirrored pictures as default, so this code flips the taken picture to a normal layout.
    if (FrontCamera) {
        _captureImage.image = [UIImage imageWithCGImage:_captureImage.image.CGImage
                                                  scale:_captureImage.image.scale
                                            orientation:UIImageOrientationUpMirrored];
        _captureImage.frame = _imagePreviewView.frame;
    }

    // Stop capturing image
    [session stopRunning];
    
    // Hide Top/Bottom controller after taking photo for editing
    [self hideControllers];
}

#pragma mark - Device Availability Controls
- (void)disableCameraDeviceControls {
    _cameraToggleButton.enabled = false;
    _flashToggleButton.enabled = false;
    _camOut.enabled = false;
}

#pragma mark - UIImagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if (info) {
        photoFromCam = false;
        
        UIImage* outputImage = [info objectForKey:UIImagePickerControllerEditedImage];
        if (outputImage == nil) {
            outputImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }

        if (outputImage) {
            _captureImage.hidden = false;
            _captureImage.image = outputImage;
            
            [self dismissViewControllerAnimated:true completion:nil];

            // Hide Top/Bottom controller after taking photo for editing
            [self hideControllers];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    initializeCamera = true;
    [picker dismissViewControllerAnimated:true completion:nil];
}



#pragma mark - GRID BUTTON ===========
- (IBAction)gridButt:(UIButton *)sender{
    if (sender.selected) {
        sender.selected = false;
        [UIView animateWithDuration:0.2 delay:0.0 options:0 animations:^{
            _gridImage.alpha = 0.0f;
        } completion:nil];
    }
    else{
        sender.selected = true;
        [UIView animateWithDuration:0.2 delay:0.0 options:0 animations:^{
            _gridImage.alpha = 1.0f;
        } completion:nil];
    }
}





#pragma mark - CANCEL BUTTON
-(IBAction)cancelButt:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}


#pragma mark - DONE BUTTON
- (IBAction)donePhotoCapture:(id)sender {
    // save original photo into Photo Library
    if (saveOriginalPhoto) {
        UIImageWriteToSavedPhotosAlbum(_captureImage.image, nil, nil, nil);
    }
    
    // Go to Preview VC
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PreviewVC *prevVC = (PreviewVC *)[storyboard instantiateViewControllerWithIdentifier:@"PreviewVC"];
    passedImage = _captureImage.image;
    [self presentViewController:prevVC animated:true completion:nil];

}



#pragma mark - RETAKE PHOTO BUTTON
- (IBAction)retakePhoto:(id)sender{
    _camOut.enabled = true;
    _captureImage.image = nil;
    _imagePreviewView.hidden = false;
    
    // Shows Camera Controls
    [self showControllers];
    
    haveImage = false;
    FrontCamera = false;
    [self performSelector:@selector(initializeCamera) withObject:nil afterDelay:0.001];
}




#pragma mark - SWITCH CAMERA BUTTON
- (IBAction)switchCamera:(UIButton *)sender { //switch cameras front and rear cameras
    // Stop current recording process
    [session stopRunning];
    
    if (sender.selected) {  // Switch to Back camera
        sender.selected = false;
        FrontCamera = false;
        _tintOut.hidden = false;
        
        [self performSelector:@selector(initializeCamera) withObject:nil afterDelay:0.001];
    
        
    } else { // Switch to Front camera
        sender.selected = true;
        FrontCamera = true;
        // Hide TintView (available only for Back camera)
        tintON = false;
        _tintView.hidden = true;
        _tintOut.hidden = true;
        
        [self performSelector:@selector(initializeCamera) withObject:nil afterDelay:0.001];
    }
}




#pragma mark - FLASH BUTTON
- (IBAction)flashToggleButt:(UIButton *)sender{
    flashON = !flashON;
    
    if (!FrontCamera) {
        
        // Set FLASH OFF
        if (!flashON) {
            [_flashToggleButton setBackgroundImage:[UIImage imageNamed:@"flashOFF"] forState:UIControlStateNormal];
            
            NSArray *devices = [AVCaptureDevice devices];
            for (AVCaptureDevice *device in devices) {
                
                if ([device hasMediaType:AVMediaTypeVideo]) {
                    if ([device position] == AVCaptureDevicePositionBack) {
                        if ([device hasFlash]){
                            [device lockForConfiguration:nil];
                            [device setFlashMode:AVCaptureFlashModeOff];
                            [device unlockForConfiguration];
                            break;
                        }
                    }
                }
            }

            
        // Set FLASH ON
        }  else {
            [_flashToggleButton setBackgroundImage:[UIImage imageNamed:@"flashON"] forState:UIControlStateNormal];
            
            NSArray *devices = [AVCaptureDevice devices];
            for (AVCaptureDevice *device in devices) {
                
                if ([device hasMediaType:AVMediaTypeVideo]) {
                    if ([device position] == AVCaptureDevicePositionBack) {
                        if ([device hasFlash]){
                            [device lockForConfiguration:nil];
                            [device setFlashMode:AVCaptureFlashModeOn];
                            [device unlockForConfiguration];
                            
                            break;
                        }
                    }
                }
            }

        }
    }
}


#pragma mark - SHOW/HIDE TOP BAR CONTROLS ==================
- (void)hideControllers{
    [UIView animateWithDuration:0.2 animations:^{
        _photoBar.center = CGPointMake(_photoBar.center.x, _photoBar.center.y+116.0);
        _topBar.center = CGPointMake(_topBar.center.x, _topBar.center.y-44.0);
        _buttonsView.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    } completion:nil];
}

- (void)showControllers{
    [UIView animateWithDuration:0.2 animations:^{
        _photoBar.center = CGPointMake(_photoBar.center.x, _photoBar.center.y-116.0);
        _topBar.center = CGPointMake(_topBar.center.x, _topBar.center.y+44.0);
        _buttonsView.frame = CGRectMake(0, -44, self.view.frame.size.width, 44);

    } completion:nil];
}



-(void) dealloc  {
    [_imagePreviewView release];
    [_captureImage release];
    
    if (session)
        [session release], session = nil;
    
    if (captureVideoPreviewLayer)
        [captureVideoPreviewLayer release], captureVideoPreviewLayer = nil;
    
    if (stillImageOutput)
        [stillImageOutput release], stillImageOutput = nil;
}




#pragma mark - UIIMAGE UTILITY
- (UIImage*)imageWithImage:(UIImage *)sourceImage scaledToWidth:(float) i_width {
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
