//
//  CropViewController.h
//  Flyr
//
//  Developed by RIKSOF (Private) Limited
//  Copyright Flyerly. All rights reserved.
//

#import "NBUEditImageViewController.h"
#import "FlyerlySingleton.h"

@class FlyerlySingleton;

@interface CropViewController : NBUEditImageViewController

@property CGSize desiredImageSize;
@property (strong, nonatomic) FlyerlySingleton *globle;

@end

