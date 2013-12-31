//
//  CameraViewController.h
//  NBUKitDemo
//
//  Created by Ernesto Rivera on 2012/10/15.
//  Copyright (c) 2012 CyberAgent Inc.
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
#import "NBUCameraViewController.h"
#import "ObjectSlideView.h"
#import <NBUKit/NBUViewController.h>
#import "NBUCameraView.h"
#import "UIImage+NBUAdditions.h"
#import "NBUKitPrivate.h"
#import "Singleton.h"

@interface CameraViewController : NBUCameraViewController{

   Singleton *globle;
}

// Outlets
@property (assign, nonatomic) IBOutlet UIButton * shootButton;
@property (assign, nonatomic) IBOutlet ObjectSlideView * slideView;

// Actions
- (IBAction)customToggleFlash:(id)sender;

@end

