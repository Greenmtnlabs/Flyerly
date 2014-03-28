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



@interface CameraViewController : NBUCameraViewController

@property CGSize desiredImageSize;
@property (nonatomic, copy) void (^onImageTaken)(UIImage *);
@property (nonatomic, copy) void (^onVideoFinished)(NSURL *);
@property (nonatomic, copy) void (^onVideoCancel)();


// Outlets
@property (assign, nonatomic) IBOutlet UIImageView *cameraLines;

@property (assign, nonatomic) IBOutlet UIImageView *flyerImageView;

@property (assign, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UIButton *mode;
@property (strong, nonatomic) NSString *videoAllow;




// Actions
- (IBAction)setCameraLine:(id)sender;
- (IBAction)setCameraMode:(id)sender;
- (IBAction)setShootAction:(id)sender;
- (IBAction)tapAndHold:(id)sender;

- (IBAction)moveToGallery:(id)sender;
- (IBAction)startRecording:(id)sender;

@end

