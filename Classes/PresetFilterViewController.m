//
//  PresetFilterViewController.m
//  NBUKitDemo
//
//  Created by Ernesto Rivera on 2012/08/13.
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

#import "PresetFilterViewController.h"


@implementation PresetFilterViewController
{
    NSArray * _providerFilters;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
     globle = [Singleton RetrieveSingleton];
    
    //Apply Button
    UIButton *applyButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 32)];
    [applyButton addTarget:self action:@selector(apply:) forControlEvents:UIControlEventTouchUpInside];
    [applyButton setTitle:@"Apply" forState:UIControlStateNormal];
    [applyButton setBackgroundImage:[UIImage imageNamed:@"crop_button"] forState:UIControlStateNormal];
    UIBarButtonItem *applyBarButton = [[UIBarButtonItem alloc] initWithCustomView:applyButton];
    
    
    //Done Button
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 32)];
    [doneButton addTarget:self action:@selector(backtoMainView) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"crop_button"] forState:UIControlStateNormal];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    //Reset Button
    UIButton *resetButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 32)];
    [resetButton addTarget:self action:@selector(reset:) forControlEvents:UIControlEventTouchUpInside];
    [resetButton setTitle:@"Reset" forState:UIControlStateNormal];
    [resetButton setBackgroundImage:[UIImage imageNamed:@"crop_button"] forState:UIControlStateNormal];
    UIBarButtonItem *resetBarButton = [[UIBarButtonItem alloc] initWithCustomView:resetButton];

    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:doneBarButton,applyBarButton,resetBarButton,nil]];
    
    // Configure and set all available filters
    _providerFilters = [NBUFilterProvider availableFilters];
    self.filters = _providerFilters;

    /*
     Another possibility:
     
    _filters = @[
                 [NBUFilterProvider filterWithName:@"Reset"
                                              type:NBUFilterTypeNone
                                            values:nil],
                 [NBUFilterProvider filterWithName:nil
                                              type:NBUFilterTypeGamma
                                            values:nil],
                 [NBUFilterProvider filterWithName:nil
                                              type:NBUFilterTypeSaturation
                                            values:nil],
                 [NBUFilterProvider filterWithName:nil
                                              type:NBUFilterTypeSharpen
                                            values:nil]
                 ];
     */
    
    // Our test image
    self.image = globle.NBUimage; //[UIImage imageNamed:@"photo_hires.jpg"];
    
    // Our resultBlock
    self.resultBlock = ^(UIImage * image)
    {
        // *** Do whatever you want with the resulting image here ***
         globle.NBUimage = image;
        // Push the resulting image in a new controller
        //NBUGalleryViewController * controller = [NBUGalleryViewController new];
        //controller.objectArray = @[image];
        //[weakSelf.navigationController pushViewController:controller
          //                                       animated:YES];
    };
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Add .acv filters
    NSMutableArray * customFilters = [NSMutableArray array];
    NSArray * fileURLs = [[NSFileManager defaultManager] URLsForFilesWithExtensions:@[@"acv"]
                                                              searchInDirectoryURLs:@[[NSBundle mainBundle].bundleURL]];
    for (NSURL * url in fileURLs)
    {
        [customFilters addObject:[NBUFilterProvider filterWithName:[url.lastPathComponent stringByDeletingPathExtension]
                                                              type:NBUFilterTypeToneCurve
                                                            values:@{@"curveFile": url}]];
    }
    
    // Add custom filters created with the editor
    NSURL * filtersURL = [[UIApplication sharedApplication].libraryDirectory URLByAppendingPathComponent:@"Filters"];
    NSArray * contents = [[NSFileManager defaultManager] URLsForFilesWithExtensions:@[@"plist"]
                                                              searchInDirectoryURLs:@[filtersURL]];
    
    NBULogInfo(@"Filters folder contents: %@", contents);
    
    NBUFilterGroup * filter;
    NSDictionary * configuration;
    for (NSURL * fileURL in contents)
    {
        configuration = [NSDictionary dictionaryWithContentsOfURL:fileURL];
        if (!configuration)
        {
            NBULogWarn(@"Skipping file at: %@", fileURL);
            continue;
        }
        
        filter = [NBUFilterGroup filterGroupWithName:nil
                                                type:NBUFilterTypeGroup
                                             filters:nil];
        filter.configurationDictionary = configuration;
        
        NBULogInfo(@"Adding %@", filter);
        
        [customFilters addObject:filter];
    }
    
    self.filters = [_providerFilters arrayByAddingObjectsFromArray:customFilters];
}

- (IBAction)changeImage:(id)sender
{
    /*
    [NBUImagePickerController startPickerWithTarget:self
                                            options:(NBUImagePickerOptionSingleImage |
                                                     NBUImagePickerOptionDisableFilters |
                                                     NBUImagePickerOptionDisableCrop |
                                                     NBUImagePickerOptionDisableConfirmation |
                                                     NBUImagePickerOptionStartWithLibrary)
                                            nibName:nil
                                        resultBlock:^(NSArray * images)
     {
         if (images.count == 1)
         {
             self.image = images[0];
         }
     }];*/
}

-(void)backtoMainView{
    
    NSInteger noOfViewControllers = [self.navigationController.viewControllers count];
    [self.navigationController
     popToViewController:[self.navigationController.viewControllers
                          objectAtIndex:(noOfViewControllers-4)] animated:YES];
    
}

@end

