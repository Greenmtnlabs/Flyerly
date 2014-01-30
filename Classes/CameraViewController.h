//
//  CameraViewController.h
//  Flyr
//
//  Developed by RIKSOF (Private) Limited
//  Copyright Flyerly. All rights reserved.
//

#import "NBUCameraViewController.h"
#import "UIImage+NBUAdditions.h"
#import "FlyerlySingleton.h"

@class FlyerlySingleton;
@interface CameraViewController : NBUCameraViewController{
   FlyerlySingleton *globle;
}

// Outlets
@property (assign, nonatomic) IBOutlet UIImageView *cameraLines;

// Actions
- (IBAction)setCameraLine:(id)sender;
- (IBAction)moveToGallery:(id)sender;

@end

