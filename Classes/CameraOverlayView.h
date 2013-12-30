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
#import <NBUKit/NBUKit.h>

@interface CameraOverlayView : NBUGalleryViewController{

    IBOutlet UIImageView *borderImage;
    IBOutlet UIImageView *gridImageView;
    IBOutlet UIButton *libraryLatestPhoto;
    PhotoController *photoController;
    CustomPhotoController *customPhotoController;
}

@property (nonatomic, strong) IBOutlet UIButton *flashButton;
@property (nonatomic, strong) IBOutlet UIImageView *borderImage;
@property (nonatomic, strong) IBOutlet UIImageView *gridImageView;
@property (nonatomic, strong) IBOutlet UIButton *libraryLatestPhoto;
@property (nonatomic, strong) PhotoController *photoController;

- (IBAction)onBack;
- (IBAction)toggleGrid;
- (IBAction)toggleFlash;
- (IBAction)invertCamera;
- (IBAction)smile;
- (IBAction)loadLibrary;

@end
