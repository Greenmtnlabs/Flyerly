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

// Outlets
@property (assign, nonatomic) IBOutlet UIImageView *cameraLines;

// Actions
- (IBAction)setCameraLine:(id)sender;
- (IBAction)moveToGallery:(id)sender;

@end

