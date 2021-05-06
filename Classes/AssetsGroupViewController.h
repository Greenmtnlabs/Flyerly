//
//  AssetsGroupViewController.h
//  PickerDemo
//
//  Created by Ernesto Rivera on 2012/11/09.
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
#import <NBUImagePicker/NBUAssetsGroupViewController.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "InAppViewController.h"
#import "NBUImagePickerPrivate.h"

@class ObjectGridView, NBUAssetsGroup;
@interface AssetsGroupViewController : NBUAssetsGroupViewController <InAppPurchasePanelButtonProtocol, UserPurchasesDelegate> {
    
    InAppViewController *inappviewcontroller;
    UserPurchases *userPurchases;
    SigninController *signInController;
    BOOL productPurchased;
    
}

@property CGSize desiredImageSize;
@property CGSize desiredVideoSize;
@property (nonatomic, copy) void (^onImageTaken)(UIImage *);
@property (nonatomic, copy) void (^onVideoFinished)(NSURL *, CGRect, CGFloat);
@property (nonatomic, copy) void (^onVideoCancel)();
@property (nonatomic, strong) UIView *inAppPurchasePanel;



@property BOOL videoAllow;


//required For Override
/// An ObjectGridView used to display group's NBUAsset objects.
@property (weak, nonatomic) IBOutlet ObjectGridView * gridView;
@property (weak, nonatomic) IBOutlet UILabel * groupNameLabel;
/// An optional UILabel that will be updated automatically with the assets count.
@property (weak, nonatomic) IBOutlet UILabel * assetsCountLabel;
/// Whether or not the controller is loading assets (KVO compliant).
@property (nonatomic, assign, getter=isLoading) BOOL loading;
/// The currently retrieved NBUAsset objects.
@property (strong, nonatomic, readonly) NSArray * assets;
@property (strong, nonatomic)  NSArray * selectedAssetsURLs;
/// Whether to present reverse the assets' order (newest assets on top). Default `NO`.
@property (nonatomic) BOOL reverseOrder;

/// The number of assets to be incrementally loaded. Default `100`, set to `0` to load all at once;
@property (nonatomic) NSUInteger loadSize;


@end

