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

// Outlets
@property (assign, nonatomic) IBOutlet UIImageView *cameraLines;

// Actions
- (IBAction)setCameraLine:(id)sender;
- (IBAction)moveToGallery:(id)sender;
- (IBAction)startRecording:(id)sender;

@end

