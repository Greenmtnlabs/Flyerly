//
//  CameraOverlayView.m
//  Flyr
//
//  Created by Rizwan Ahmad on 4/22/13.
//
//

#import "CameraOverlayView.h"
#import "CustomPhotoController.h"

@implementation CameraOverlayView
@synthesize photoController, gridImageView, libraryLatestPhoto;

-(void)viewDidLoad{
    NSLog(@"Camera Overlay Loaded...");
    
    customPhotoController = [[CustomPhotoController alloc] initWithNibName:@"CustomPhotoController" bundle:nil];
    
    [self setLatestImage];
}

- (IBAction)onBack{
    [self.photoController.imgPicker dismissModalViewControllerAnimated:YES];
}

- (IBAction)toggleFlash{
    NSLog(@"Toggle Flash...");
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    int torchMode = [device torchMode];
    
    if([device isTorchModeSupported:torchMode]){
        [device lockForConfiguration:nil];
        
        if(torchMode == AVCaptureTorchModeOn){
            [device setTorchMode:AVCaptureTorchModeOff];
            [device setFlashMode:AVCaptureTorchModeOff];
        } else {
            [device setTorchMode:AVCaptureTorchModeOn];
            [device setFlashMode:AVCaptureTorchModeOn];
        }
        [device unlockForConfiguration];
    }
}

- (IBAction)toggleGrid{
    NSLog(@"Toggle Grid...");
    [gridImageView setHidden:![gridImageView isHidden]];
}

- (IBAction)invertCamera{
    NSLog(@"Invert Camera...");
}

- (IBAction)smile{
    NSLog(@"Take picture...");
    [photoController.imgPicker takePicture];
}

- (IBAction)loadLibrary{
    NSLog(@"Load Library...");
    
    // Access the uncropped image from info dictionary
    //UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Show the custom controller and get this image cropped.
    //customPhotoController.image = image;
    customPhotoController.callbackObject = photoController;
    customPhotoController.callbackOnComplete = @selector(onCompleteSelectingImage:);
    [photoController.navigationController pushViewController:customPhotoController animated:YES];
    [customPhotoController release];
    [photoController dismissModalViewControllerAnimated:YES];
}

-(void)setLatestImage{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        // Within the group enumeration block, filter to enumerate just photos.
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        // Chooses the photo at the last index
        [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:([group numberOfAssets] - 1)] options:0 usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
            
            // The end of the enumeration is signaled by asset == nil.
            if (alAsset) {
                ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                UIImage *latestPhoto = [UIImage imageWithCGImage:[representation fullScreenImage]];
                
                if([latestPhoto isKindOfClass:[UIImageView class]]){
                }
                // Do something interesting with the AV asset.
                [libraryLatestPhoto setBackgroundImage:latestPhoto forState:UIControlStateNormal];
                customPhotoController.image = latestPhoto;
                
            }
        }];
    } failureBlock: ^(NSError *error) {
        // Typically you should handle an error more gracefully than this.
        NSLog(@"No groups");
    }];
}

-(void)dealloc{
    gridImageView = nil;
    photoController = nil;
    [super dealloc];
}

@end
