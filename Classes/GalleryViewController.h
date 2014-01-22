//
//  GalleryViewController.h
//  NBUKitDemo
//
//  Created by Ernesto Rivera on 2013/04/15.
//  Copyright (c) 2013 CyberAgent Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
#import "NBUImageLoader.h"
#import "NBUGalleryViewController.h"
#import "NBUAssetsLibrary.h"
#import <Foundation/Foundation.h>
#import <NBUKit/NBUKit.h>
#import "NBUImagePicker.h"
#import "NBUGalleryView.h"
#import "FlyerlySingleton.h"
#import "CropViewController.h"


@class CropViewController;
@interface GalleryViewController : NBUGalleryViewController <NBUImageLoader>{

    CropViewController *nbuCrop;
    FlyerlySingleton *globle;
    
}

-(void)CallNBUcropImage;
-(void)goback;
@end

