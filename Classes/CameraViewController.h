//
//  CameraViewController.h
//  Flyr
//
//  Developed by RIKSOF (Private) Limited
//  Copyright Flyerly. All rights reserved.
//

#import "NBUCameraViewController.h"
#import "UIImage+NBUAdditions.h"
#import <AVFoundation/AVFoundation.h>
#import "InAppPurchaseViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SubNBUCamera.h"

@interface CameraViewController : NBUCameraViewController <inAppPurchasePanelButtonProtocol, UserPurchasesDelegate> {
    CGFloat progress;
    SubNBUCamera *cameraViewChild;
    InAppPurchaseViewController *inappviewcontroller;
    SigninController *signInController;
    BOOL productPurchased;
}

@property CGSize desiredImageSize;
@property (nonatomic, copy) void (^onImageTaken)(UIImage *);
@property (nonatomic, copy) void (^onVideoFinished)(NSURL *, CGRect, CGFloat);
@property (nonatomic, copy) void (^onVideoCancel)();



// Outlets
@property (assign, nonatomic) IBOutlet UIImageView *cameraLines;

@property (assign, nonatomic) IBOutlet UIImageView *flyerImageView;

@property (assign, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UIButton *mode;
@property BOOL videoAllow;
@property (nonatomic, strong) UIView *inAppPurchasePanel;



// Actions
- (IBAction)setCameraLine:(id)sender;
- (IBAction)setCameraMode:(id)sender;
- (IBAction)setShootAction:(id)sender;
- (IBAction)tapAndHold:(id)sender;

- (IBAction)moveToGallery:(id)sender;
- (IBAction)startRecording:(id)sender;

@end

