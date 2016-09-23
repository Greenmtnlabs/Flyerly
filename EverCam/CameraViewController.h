/*============================
 
     EverCam 
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
==============================*/


//  ARC Helper
#ifndef ah_retain
#if __has_feature(objc_arc)
#define ah_retain self
#define ah_dealloc self
#define release self
#define autorelease self
#else
#define ah_retain retain
#define ah_dealloc dealloc
#define __bridge
#endif
#endif


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>



@interface CameraViewController : UIViewController
<
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIGestureRecognizerDelegate
>
{
    UIImage *combinedImage;
        
    BOOL pickerDidShow;
    BOOL FrontCamera;
    BOOL flashON;
    BOOL haveImage;
    BOOL initializeCamera;
    BOOL photoFromCam;
    BOOL exposureON;
    BOOL tintON;
    
    AVCaptureSession *session;
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    AVCaptureStillImageOutput *stillImageOutput;
    UIImage *croppedImageWithoutOrientation;
}
@property (nonatomic, assign) id delegate;


/* Views */
@property (retain, nonatomic) IBOutlet UIView *imagePreviewView;
@property (retain, nonatomic) IBOutlet UIImageView *captureImage;

// TopBar
@property (nonatomic, strong) IBOutlet UIView *topBar;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) IBOutlet UIButton *cameraToggleButton;
@property (nonatomic, strong) IBOutlet UIButton *flashToggleButton;
@property (retain, nonatomic) IBOutlet UIImageView *gridImage;

// Photo Bar
@property (nonatomic, strong) IBOutlet UIView *photoBar;
@property (strong, nonatomic) IBOutlet UIButton *camOut;


// Retake/Done buttons ===============
@property (strong, nonatomic) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) IBOutlet UIButton *retakeOutlet;
@property (weak, nonatomic) IBOutlet UIButton *doneOutlet;


// Exposure View =============
@property (strong, nonatomic) IBOutlet UIView *exposureView;
@property (strong, nonatomic) IBOutlet UIButton *exposureOut;

@property (strong, nonatomic) IBOutlet UISlider *exposureSlider;
@property (strong, nonatomic) IBOutlet UILabel *exposureLabel;


// Tint View ============
@property (strong, nonatomic) IBOutlet UIView *tintView;
@property (strong, nonatomic) IBOutlet UISlider *tintSlider;
@property (strong, nonatomic) IBOutlet UISlider *temperatureSlider;
@property (strong, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (strong, nonatomic) IBOutlet UILabel *tintLabel;
@property (strong, nonatomic) IBOutlet UIButton *tintOut;


@end


