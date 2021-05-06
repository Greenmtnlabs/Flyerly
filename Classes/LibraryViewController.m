//
//  LibraryViewController.m
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

#import "LibraryViewController.h"
#import "AssetsGroupViewController.h"
#import "FlyerlySingleton.h"
#import "AssetGroupViewControllerWithSearchFeild.h"
#import <NBUCompatibility.h>
#import <NBUAssetsLibrary.h>

@implementation LibraryViewController

+(void)initialize
{
    // Register our custom directory albums
//    [[NBUAssetsLibrary sharedLibrary] registerDirectoryGroupforURL:[NBUKit resourcesBundle].bundleURL
//                                                              name:nil];
//    [[NBUAssetsLibrary sharedLibrary] registerDirectoryGroupforURL:[NSBundle mainBundle].bundleURL
//                                                              name:nil];
  /*  [[NBUAssetsLibrary sharedLibrary] registerDirectoryGroupforURL:[UIApplication sharedApplication].documentsDirectory
                                                              name:@"App's Documents directory"];*/
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure grid view
    
    if ( IS_IPHONE_5|| IS_IPHONE_4) {
        self.objectTableView.nibNameForViews = @"CustomAssetsGroupView";
    }else if ( IS_IPHONE_6){
        self.objectTableView.nibNameForViews = @"CustomAssetsGroupView-iPhone6";
    }else if ( IS_IPHONE_6_PLUS || IS_IPHONE_XR || IS_IPHONE_XS){
        self.objectTableView.nibNameForViews = @"CustomAssetsGroupView-iPhone6-Plus";
    } else {
        self.objectTableView.nibNameForViews = @"CustomAssetsGroupView";
    }
    
    // Customization
    self.customBackButtonTitle = @"Albums";
    AssetsGroupViewController *asstController = [[AssetsGroupViewController alloc] initWithNibName:@"AssetsGroupViewController"
                                                                                            bundle:nil];
    self.assetsGroupController = asstController;

    // Pass the relevant properties
    asstController.reverseOrder = YES;
    asstController.desiredImageSize = self.desiredImageSize;
    asstController.desiredVideoSize = _desiredVideoSize;
    asstController.onImageTaken = self.onImageTaken;
    asstController.onVideoFinished = self.onVideoFinished;
    asstController.videoAllow = self.videoAllow;
    
    // Navigation buttons
    // BackButton
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    
    // Buy Images Button
    UIButton *buyImagesButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    buyImagesButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [buyImagesButton addTarget:self action:@selector(buyImages) forControlEvents:UIControlEventTouchUpInside];
    [buyImagesButton setBackgroundImage:[UIImage imageNamed:@"buy"] forState:UIControlStateNormal];
    buyImagesButton.showsTouchWhenHighlighted = YES;
    [buyImagesButton setHidden:YES];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:buyImagesButton];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    
    // Set the title view.
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-35, -6, 50, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];
    label.text = @"ALBUMS";
    
    self.navigationItem.titleView = label;
}

#pragma mark - Handling access authorization

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Authorized?
    if (![NBUAssetsLibrary sharedLibrary].userDeniedAccess)
    {
        // No need for info button
        //self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)accessInfo:(id)sender
{
    // User denied access?
    if ([NBUAssetsLibrary sharedLibrary].userDeniedAccess)
    {
        [[[UIAlertView alloc] initWithTitle:@"Access denied"
                                    message:@"Please go to Settings:Privacy:Photos to enable library access" delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    
    // Parental controls
    if ([NBUAssetsLibrary sharedLibrary].restrictedAccess)
    {
        [[[UIAlertView alloc] initWithTitle:@"Parental restrictions"
                                    message:@"Please go to Settings:General:Restrictions to enable library access" delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

#pragma mark - Button Handlers

/**
 * Cancel and go back.
 */
- (void)goBack {
    self.onVideoCancel();
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * Buy Images .
 */
- (void)buyImages {
    AssetGroupViewControllerWithSearchFeild *buyImagesController= [[AssetGroupViewControllerWithSearchFeild alloc]initWithNibName:@"AssetGroupViewControllerWithSearchFeild" bundle:nil];
    buyImagesController.onImageTaken = self.onImageTaken;
    buyImagesController.desiredImageSize = self.desiredImageSize;
    buyImagesController.isFromInApp = false;
	[self.navigationController pushViewController:buyImagesController animated:YES];
}

@end

