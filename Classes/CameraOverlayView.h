//
//  CameraOverlayView.h
//  Flyr
//
//  Created by Rizwan Ahmad on 4/22/13.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoController.h"
#import "CustomPhotoController.h"

@interface CameraOverlayView : UIViewController{

    IBOutlet UIImageView *gridImageView;
    IBOutlet UIButton *libraryLatestPhoto;
    PhotoController *photoController;
    CustomPhotoController *customPhotoController;
}

@property (nonatomic, retain) IBOutlet UIImageView *gridImageView;
@property (nonatomic, retain) IBOutlet UIButton *libraryLatestPhoto;
@property (nonatomic, retain) PhotoController *photoController;

- (IBAction)onBack;
- (IBAction)toggleGrid;
- (IBAction)toggleFlash;
- (IBAction)invertCamera;
- (IBAction)smile;
- (IBAction)loadLibrary;

@end
