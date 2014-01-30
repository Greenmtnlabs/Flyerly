//
//  CameraViewController.h
//  Flyr
//
//  Developed by RIKSOF (Private) Limited
//  Copyright Flyerly. All rights reserved.
//

#import "NBUCameraViewController.h"
#import "ObjectSlideView.h"
#import <NBUKit/NBUViewController.h>
#import "NBUCameraView.h"
#import "UIImage+NBUAdditions.h"
#import "NBUKitPrivate.h"
#import "FlyerlySingleton.h"

@class FlyerlySingleton;
@interface CameraViewController : NBUCameraViewController{
   FlyerlySingleton *globle;
}

// Outlets
@property (assign, nonatomic) IBOutlet UIButton * shootButton;
@property (assign, nonatomic) IBOutlet ObjectSlideView * slideView;

@property (assign, nonatomic) IBOutlet UIImageView *cameraLines;

// Actions
- (IBAction)customToggleFlash:(id)sender;
- (IBAction)setCameraline:(id)sender;
- (IBAction)CameraCancel:(id)sender;
- (IBAction)MovetoGallery:(id)sender;

@end

