//
//  CropViewController.m
//  NBUKitDemo
//
//  Created by Ernesto Rivera on 2012/07/31.
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

#import "CropViewController.h"

@implementation CropViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
     globle = [Singleton RetrieveSingleton];
    
    //Done Button
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 32)];
    [doneButton addTarget:self action:@selector(backtoMainView) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"crop_button"] forState:UIControlStateNormal];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    //Crop Button
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 32)];
    [menuButton addTarget:self action:@selector(apply:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setTitle:@"Crop" forState:UIControlStateNormal];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"crop_button"] forState:UIControlStateNormal];
    UIBarButtonItem *cropBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    //Reset Button
    UIButton *resetButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 32)];
    [resetButton addTarget:self action:@selector(reset:) forControlEvents:UIControlEventTouchUpInside];
    [resetButton setTitle:@"Reset" forState:UIControlStateNormal];
    [resetButton setBackgroundImage:[UIImage imageNamed:@"crop_button"] forState:UIControlStateNormal];
    UIBarButtonItem *resetBarButton = [[UIBarButtonItem alloc] initWithCustomView:resetButton];

    //Next Button
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 32)];
    [nextButton addTarget:self action:@selector(gotoFilterImage) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"crop_button"] forState:UIControlStateNormal];
    UIBarButtonItem *nextBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:nextBarButton,doneBarButton,cropBarButton,resetBarButton,nil]];
    
    // Configure the controller
    self.cropGuideSize = CGSizeMake(247.0, 227.0); // Matches our cropGuideView's image
    self.maximumScaleFactor = 10.0;                // We may get big pixels with this factor!
    
    // Our test image
    self.image = globle.NBUimage;//[UIImage imageNamed:@"photo.jpg"];
    
    // Our resultBlock
    __unsafe_unretained CropViewController * weakSelf = self;
    self.resultBlock = ^(UIImage * image)
    {
        // *** Do whatever you want with the resulting image here ***
        
        // Preview the changes
        weakSelf.cropView.image = image;
        globle.NBUimage = image;
    };
}

- (void)setCropView:(NBUCropView *)cropView
{
    super.cropView = cropView;
    
    cropView.allowAspectFit = YES; // The image can be downsized until it fits inside the cropGuideView
}

-(void)backtoMainView{
    
    NSInteger noOfViewControllers = [self.navigationController.viewControllers count];
    [self.navigationController
     popToViewController:[self.navigationController.viewControllers
                          objectAtIndex:(noOfViewControllers-3)] animated:YES];

}

-(void)gotoFilterImage{

    nbuFilter = [[PresetFilterViewController alloc]initWithNibName:@"PresetFilterViewController" bundle:nil];
    [nbuFilter awakeFromNib];
    [self.navigationController pushViewController:nbuFilter animated:YES];
    
}

@end

