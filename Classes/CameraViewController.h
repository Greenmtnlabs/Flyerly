//
//  CameraViewController.h
//  NBUKitDemo
//
//  Created by Riksof Pvt. Ltd. on 22/Jan/2014.
//  Copyright (c) 2012 CyberAgent Inc.
//
#import "NBUCameraViewController.h"
#import "ObjectSlideView.h"
#import <NBUKit/NBUViewController.h>
#import "NBUCameraView.h"
#import "UIImage+NBUAdditions.h"
#import "NBUKitPrivate.h"
#import "CropViewController.h"
#import "FlyerlySingleton.h"
#import "GalleryViewController.h"


@class GalleryViewController,FlyerlySingleton;
@interface CameraViewController : NBUCameraViewController{

   FlyerlySingleton *globle;
    CropViewController *nbuCrop;
    GalleryViewController *nbugallery;
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

