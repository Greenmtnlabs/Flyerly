//
// CameraViewController.h
// Flyr
//
// Developed by RIKSOF (Private) Limited
// Copyright Flyerly. All rights reserved.
//

#import "NBUCameraViewController.h"
#import "UIImage+NBUAdditions.h"
#import <AVFoundation/AVFoundation.h>
#import "InAppViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SubNBUCamera.h"
#import "UserPurchases.h"

@class SigninController;
@class InAppViewController;

@interface CameraViewController : NBUCameraViewController <InAppPurchasePanelButtonProtocol, UserPurchasesDelegate> {
    CGFloat progress;
    SubNBUCamera *cameraViewChild;
    InAppViewController *inappviewcontroller;
    SigninController *signInController;
    BOOL productPurchased;
    UserPurchases *userPurchases;
}

@property CGSize desiredImageSize;
@property CGSize desiredVideoSize;
@property (nonatomic, copy) void (^onImageTaken)(UIImage *);
@property (nonatomic, copy) void (^onVideoFinished)(NSURL *, CGRect, CGFloat);
@property (nonatomic, copy) void (^onVideoCancel)();



// Outlets
@property (assign, nonatomic) IBOutlet UIImageView *cameraLines;
@property (assign, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UIButton *mode;
@property BOOL videoAllow;
@property BOOL isVideoFlyer;
@property (nonatomic, strong) UIView *inAppPurchasePanel;
@property (strong, nonatomic) IBOutlet UILabel *tapAndHoldLabel;


-(void)setCameraModeForVideo;

// Actions
- (IBAction)setCameraLine:(id)sender;
- (IBAction)setCameraMode:(id)sender;
- (IBAction)setShootAction:(id)sender;
- (IBAction)tapAndHold:(id)sender;
- (IBAction)moveToGallery:(id)sender;
- (IBAction)startRecording:(id)sender;

@end
