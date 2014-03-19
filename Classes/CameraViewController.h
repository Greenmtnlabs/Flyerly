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
@property (assign, nonatomic) IBOutlet UIButton *shootButton;
@property (nonatomic, assign) BOOL forVideo;

// Actions
- (IBAction)setCameraLine:(id)sender;
- (IBAction)moveToGallery:(id)sender;
- (IBAction)shoot:(id)sender;

@end

