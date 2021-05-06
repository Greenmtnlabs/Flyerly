//
//  AssetsGroupViewController.m
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

#import "AssetsGroupViewController.h"
#import <NBUImagePicker/NBUImagePicker.h>
#import <NBUCompatibility.h>
#import "FlyerlySingleton.h"
#import "CropViewController.h"
#import "CropVideoViewController.h"
#import "Common.h"

@implementation AssetsGroupViewController

@dynamic gridView, groupNameLabel, assetsCountLabel, loading, assets, selectedAssetsURLs, reverseOrder, loadSize;


@synthesize inAppPurchasePanel;

#pragma mark - View Controller methods

/**
 * View loaded.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure the grid view
    self.gridView.margin = CGSizeMake(5.0, 5.0);
    //self.gridView.sizeToFit;

    
    if( IS_IPHONE_4 || IS_IPHONE_5){
        self.gridView.nibNameForViews = @"CustomAssetThumbnailView";
     }else if ( IS_IPHONE_6){
        self.gridView.nibNameForViews = @"CustomAssetThumbnailView-iPhone6";
    }else if ( IS_IPHONE_6_PLUS || IS_IPHONE_XR || IS_IPHONE_XS){
        self.gridView.nibNameForViews = @"CustomAssetThumbnailView-iPhone6-Plus"; //Files are in NBU/Gallery/
    } else{
        self.gridView.nibNameForViews = @"CustomAssetThumbnailView";
    }
    
    NSLog(@"self.gridView(w:%f,h%f):", self.gridView.size.width, self.gridView.size.height );
    
    
    // Configure the selection behaviour
    self.selectionCountLimit = 1;
    
    // BackButton
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    
    // Set the title view.
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-35, -6, 50, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];
    label.text = self.assetsGroup.name;
    
    self.navigationItem.titleView = label;
}

/**
 * View disappeared.
 */
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // Stop loading assets?
    if (!self.navigationController)
    {
        [self.assetsGroup stopLoadingAssets];
    }
}

/**
 * View appeared.
 *
 * @param animated
 *            BOOL indicating if the appearance was animated.
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // We are not scorlling, just showing latest on top
    //CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
    //[self.scrollView setContentOffset:bottomOffset animated:NO];
    
}


#pragma mark - Button Handlers

/**
 * Cancel and go back.
 */
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}



/*
 * HERE WE GET BYTES FROM ASSET AND CREATE NEW FILE WITH SENDED PATH
 */
- (BOOL)writeDataToPath:(NSString*)filePath andAsset:(ALAsset*)asset {
    
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    if (!handle) {
        return NO;
    }
    
    static const NSUInteger BufferSize = 1024*1024;
    
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    uint8_t *buffer = calloc(BufferSize, sizeof(*buffer));
    NSUInteger offset = 0, bytesRead = 0;
    
    do {
        @try {
            bytesRead = [rep getBytes:buffer fromOffset:offset length:BufferSize error:nil];
            [handle writeData:[NSData dataWithBytesNoCopy:buffer length:bytesRead freeWhenDone:NO]];
            offset += bytesRead;
        } @catch (NSException *exception) {
            free(buffer);
            
            return NO;
        }
    } while (bytesRead > 0);
    
    free(buffer);
    return YES;
}

/**
 * An asset was selected. Process it.
 */
- (void)thumbnailViewSelectionStateChanged:(NSNotification *)notification {
    
    // Refresh selected assets
    NBUAssetThumbnailView *assetView = (NBUAssetThumbnailView *)notification.object;
    NBUAsset *asset = assetView.asset;
    
    
    //HERE WE CHECK SELECTED ITEM IS VIDEO
    if (asset.type == NBUAssetTypeVideo) {
        
        UserPurchases *userPurchases_ = [UserPurchases getInstance];
        
        if ([[PFUser currentUser] sessionToken].length != 0) {
            
            if ( [userPurchases_ canCreateVideoFlyer] ) {
                
                NSError *error = nil;
                NSString *homeDirectoryPath = NSHomeDirectory();
                NSString *rootPath = [homeDirectoryPath stringByAppendingString:
                                      [NSString stringWithFormat:@"/Documents/FlyerlyMovie.mov"]];
                
                //HERE WE MAKE SURE FILE ALREADY EXISTS THEN DELETE IT OTHERWISE IGNORE
                if ( [[NSFileManager defaultManager] fileExistsAtPath:rootPath isDirectory:NULL] ) {
                    [[NSFileManager defaultManager] removeItemAtPath:rootPath error:&error];
                }
                
                self.loading = YES;
                
                //Background Thread
                CropVideoViewController *cropVideo;
                if( IS_IPHONE_4 || IS_IPHONE_5){
                    cropVideo = [[CropVideoViewController alloc] initWithNibName:@"CropVideoViewController" bundle:nil];
                }else if ( IS_IPHONE_6){
                    cropVideo = [[CropVideoViewController alloc] initWithNibName:@"CropVideoViewController-iPhone6" bundle:nil];
                }else if ( IS_IPHONE_6_PLUS || IS_IPHONE_XR || IS_IPHONE_XS){
                    cropVideo = [[CropVideoViewController alloc] initWithNibName:@"CropVideoViewController-iPhone6-Plus" bundle:nil];
                } else {
                    cropVideo = [[CropVideoViewController alloc] initWithNibName:@"CropVideoViewController" bundle:nil];
                }
                
                
                cropVideo.desiredVideoSize = _desiredVideoSize;
                cropVideo.url = asset.ALAsset.defaultRepresentation.url;
                cropVideo.onVideoFinished = _onVideoFinished;
                cropVideo.onVideoCancel = _onVideoCancel;
                    
                // Pop the current view, and push the crop view.
                NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
                [viewControllers removeLastObject];
                [viewControllers removeLastObject];
                [viewControllers addObject:cropVideo];
                [[self navigationController] setViewControllers:viewControllers animated:YES];
                
            }else {
                [self openPanel];
            }
            
        } else {
            [self openPanel];
        }
    } else {
    
        // Get out of full screen mode.
        [self viewWillDisappear:NO];
        
        CropViewController *nbuCrop;
        
        if( IS_IPHONE_4 || IS_IPHONE_5){
            nbuCrop = [[CropViewController alloc] initWithNibName:@"CropViewController" bundle:nil];
        }else if ( IS_IPHONE_6){
            nbuCrop = [[CropViewController alloc] initWithNibName:@"CropViewController-iPhone6" bundle:nil];
        }else if ( IS_IPHONE_6_PLUS || IS_IPHONE_XR || IS_IPHONE_XS){
            nbuCrop = [[CropViewController alloc] initWithNibName:@"CropViewController-iPhone6-Plus" bundle:nil];
        } else {
            nbuCrop = [[CropViewController alloc] initWithNibName:@"CropViewController" bundle:nil];
        }
        
        nbuCrop.desiredImageSize = self.desiredImageSize;
        nbuCrop.image = [asset.fullResolutionImage imageWithOrientationUp];
        nbuCrop.onImageTaken = self.onImageTaken;
    
        // Pop the current view, and push the crop view.
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
        [viewControllers removeLastObject];
        [viewControllers removeLastObject];
        [viewControllers addObject:nbuCrop];
        [[self navigationController] setViewControllers:viewControllers animated:YES];
    }
}

- ( void )inAppPurchasePanelContent {    
    [inappviewcontroller inAppDataLoaded];
}

- ( void )productSuccesfullyPurchased: (NSString *)productId {
    
}


- (void) userPurchasesLoaded {
    
    UserPurchases *userPurchases_ = [UserPurchases getInstance];
    
    if ( [userPurchases_ checkKeyExistsInPurchases: IN_APP_ID_SAVED_FLYERS] ) {
        [inappviewcontroller.paidFeaturesTview reloadData];
        
    }else {
        [self presentViewController:inappviewcontroller animated:YES completion:nil];
        
    }
    
}

- (void)inAppPurchasePanelButtonTappedWasPressed:(NSString *)inAppPurchasePanelButtonCurrentTitle {
    
    __weak InAppViewController *inappviewcontroller_ = inappviewcontroller;
    if ([inAppPurchasePanelButtonCurrentTitle isEqualToString:(@"Sign In")]) {
        // Put code here for button's intended action.
        
        signInController = [[SigninController alloc]initWithNibName:@"SigninController" bundle:nil];
        
        FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
        signInController.launchController = appDelegate.lauchController;
        
        __weak AssetsGroupViewController *assetsGroupViewController = self;
        
        UserPurchases *userPurchases_ = [UserPurchases getInstance];
        userPurchases_.delegate = self;
        
        [inappviewcontroller_.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        
        signInController.signInCompletion = ^void(void) {
            
            UINavigationController* navigationController = assetsGroupViewController.navigationController;
            [navigationController popViewControllerAnimated:NO];
            [userPurchases_ setUserPurcahsesFromParse];

        };
        
        [self.navigationController pushViewController:signInController animated:YES];
    }else if ([inAppPurchasePanelButtonCurrentTitle isEqualToString:(@"Restore Purchases")]){
        [inappviewcontroller_ restorePurchase];
    }
}


/*
 * Here we Open InAppPurchase Panel
 */
-(void)openPanel {
    
    if( IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS || IS_IPHONE_XR || IS_IPHONE_XS){
        inappviewcontroller = [[InAppViewController alloc] initWithNibName:@"InAppViewController" bundle:nil];
    }else {
        inappviewcontroller = [[InAppViewController alloc] initWithNibName:@"InAppViewController-iPhone4" bundle:nil];
    }
    
    [self presentViewController:inappviewcontroller animated:YES completion:nil];
    
    [inappviewcontroller requestProduct];
    inappviewcontroller.buttondelegate = self;
}

#pragma mark  Override On selection


- (void)objectUpdated:(NSDictionary *)userInfo
{
   // [super objectUpdated:userInfo];
    
    // Clean up before reuse
    NBUAssetsGroup * oldGroup = userInfo[NBUObjectUpdatedOldObjectKey];
    if (oldGroup)
    {
        [oldGroup stopLoadingAssets];
        [self.gridView resetGridView];
    }
    
    // Set the group name
    if (self.groupNameLabel)
        self.groupNameLabel.text = self.assetsGroup.name;
    else
        self.title = self.assetsGroup.name;
    self.selectedAssets = nil;
    
    // Check the number of images
    [self.assetsGroup stopLoadingAssets];
    NSUInteger totalCount;
   
    // Here we Check Selection For Photo or Background
    if ( _videoAllow ) {
        totalCount = self.assetsGroup.videoAssetsCount;
    } else {
        totalCount = self.assetsGroup.imageAssetsCount;
    }
    
    // And update the count label
    if (self.assetsCountLabel)
    {
        switch (totalCount)
        {
            case 0:
            {
                self.assetsCountLabel.text = [NSString stringWithFormat:NBULocalizedString(@"NBUAssetsGroupViewController NoImagesLabel", @"No images"),
                                          totalCount];
                break;
            }
            case 1:
            {
                self.assetsCountLabel.text = [NSString stringWithFormat:NBULocalizedString(@"NBUAssetsGroupView Only one image", @"1 image"),
                                          totalCount];
                break;
            }
            default:
            {
                self.assetsCountLabel.text = [NSString stringWithFormat:NBULocalizedString(@"NBUAssetsGroupView Number of images", @"%d images"),
                                          totalCount];
                break;
            }
        }
    }
    
    // No need to load assets
    if (totalCount == 0)
    {
        self.loading = NO;
        return;
    }
    
    // Load assets
    NBULogInfo(@"Loading %lu images for group %@...", (unsigned long)totalCount, self.assetsGroup.name);
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       self.loading = YES;
                   });
    __unsafe_unretained NBUAssetsGroupViewController * weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NBUAssetType *contentType;

        // Here we Check Selection For Photo or Background
        if ( _videoAllow ) {
            contentType = NBUAssetTypeVideo;
        } else {
            contentType = NBUAssetTypeImage;
        }
        
        [weakSelf.assetsGroup assetsWithTypes:contentType
                                    atIndexes:nil
                                 reverseOrder:YES
                          incrementalLoadSize:self.loadSize
                                  resultBlock:^(NSArray * assets,
                                                BOOL finished,
                                                NSError * error)
         {
             if (!error)
             {
                 assets = assets;
                 
                 // Update from time to time only...
                 if (assets.count == 100 ||
                     assets.count == 400 ||
                     assets.count == totalCount)
                 {
                     NBULogVerbose(@"...%lu images loaded", (unsigned long)assets.count);
                     
                     
                     // Stop loading?
                     if (assets.count == totalCount)
                     {
                         dispatch_async(dispatch_get_main_queue(), ^
                                        {
                                            self.loading = NO;
                                        });
                     }
                     
                     // Check for selectedAssets
                     NSArray * selectedAssets = [self selectedAssetsFromAssets:assets
                                                            selectedAssetsURLs:self.selectedAssetsURLs];
                     
                     // Update grid view and selected assets on main thread
                     dispatch_async(dispatch_get_main_queue(), ^
                                    {
                                        self.selectedAssets = selectedAssets;
                                        weakSelf.gridView.objectArray = assets;
                                        
                                    });
                 }
             }
         }];
    });
    
    
}


- (NSArray *)selectedAssetsFromAssets:(NSArray *)assets
                   selectedAssetsURLs:(NSArray *)selectedAssetsURLs
{
    NSMutableArray * selectedAssets;
    if (selectedAssetsURLs.count > 0)
    {
        selectedAssets = [NSMutableArray array];
        for (NBUAsset * asset in assets)
        {
            for (NSURL * url in selectedAssetsURLs)
            {
                if ([asset.URL.absoluteString isEqualToString:url.absoluteString])
                {
                    [selectedAssets addObject:asset];
                    break;
                }
            }
            // Stop looking if we found all of them
            if (selectedAssets.count == selectedAssetsURLs.count)
                break;
        }
    }
    return selectedAssets;
}

- (void)inAppPanelDismissed {

}

@end

