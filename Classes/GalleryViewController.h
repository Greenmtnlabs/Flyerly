//
//  GalleryViewController.h
//  Flyr
//
//  Developed by RIKSOF (Private) Limited
//  Copyright Flyerly. All rights reserved.
//

#import "NBUImageLoader.h"
#import "NBUGalleryViewController.h"
#import "NBUAssetsLibrary.h"
#import <Foundation/Foundation.h>
#import <NBUKit/NBUKit.h>
#import "NBUImagePicker.h"
#import "NBUGalleryView.h"
#import "FlyerlySingleton.h"

@class FlyerlySingleton;
@interface GalleryViewController : NBUGalleryViewController {
    FlyerlySingleton *globle;
}

@end

