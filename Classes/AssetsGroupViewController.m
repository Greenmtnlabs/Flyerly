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

@implementation AssetsGroupViewController

#pragma mark - View Controller methods

/**
 * View loaded.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure the grid view
    self.gridView.margin = CGSizeMake(5.0, 5.0);
    self.gridView.nibNameForViews = @"CustomAssetThumbnailView";
    
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
    label.textAlignment = UITextAlignmentCenter;
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
    
    CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
    [self.scrollView setContentOffset:bottomOffset animated:NO];
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
- (BOOL)writeDataToPath:(NSString*)filePath andAsset:(ALAsset*)asset
{
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
        
        NSError *error = nil;
        NSString *homeDirectoryPath = NSHomeDirectory();
        NSString *rootPath = [homeDirectoryPath stringByAppendingString:[NSString stringWithFormat:@"/Documents/CustomMovie.mov"]];

        //HERE WE MAKE SURE FILE ALREADY EXISTS THEN DELETE IT OTHERWISE IGNORE
        if ( [[NSFileManager defaultManager] fileExistsAtPath:rootPath isDirectory:NULL] ) {
            [[NSFileManager defaultManager] removeItemAtPath:rootPath error:&error];
        }

        NSURL *movieURL = [NSURL fileURLWithPath:rootPath];

        //Background Thread
       // dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            BOOL status =  [self writeDataToPath:rootPath andAsset:asset.ALAsset];
            
            //WHEN FILE WILL COPIED INTO APP ROOT DIRECTORY THEN WE CALL OVER CALLBACK HERE
            if ( status ) {
                self.onVideoFinished(movieURL);
            }
            // Pop the current view, and push the crop view.
            NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
            [viewControllers removeLastObject];
            [viewControllers removeLastObject];
            [[self navigationController] setViewControllers:viewControllers animated:YES];

      //  });
        
        return;
    }
    
    // Get out of full screen mode.
    [self viewWillDisappear:NO];
    
    CropViewController *nbuCrop = [[CropViewController alloc] initWithNibName:@"CropViewController" bundle:nil];
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

- (void)objectUpdated:(NSDictionary *)userInfo
{
    [super objectUpdated:userInfo];
}




@end

