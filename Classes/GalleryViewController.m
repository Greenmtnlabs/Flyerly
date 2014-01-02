//
//  GalleryViewController.m
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

#import "GalleryViewController.h"

@implementation GalleryViewController

- (void)commonInit
{
    [super commonInit];
    
    self.imageLoader = self;
}

- (void)loadView
{
    [NSBundle  loadNibNamed:@"GalleryViewController"
                     owner:self
                   options:nil];
    
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setShowThumbnailsView:NO];
     globle = [Singleton RetrieveSingleton];
    // Create right bar button
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 31, 30)];
    [menuButton addTarget:self action:@selector(CallNBUcropImage) forControlEvents:UIControlEventTouchUpInside];
    
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu_button"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
      // [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];
    
    
    [[NBUAssetsLibrary sharedLibrary] allImageAssetsWithResultBlock:^(NSArray * assets,
                                                                      NSError * error)
    {
        if (!error)
        {
            self.objectArray = assets;
        }
    }];
}

- (void)imageForObject:(id)object size:(NBUImageSize)size
           resultBlock:(NBUImageLoaderResultBlock)resultBlock
{
    // Just let the default loader to do it
    [[NBUImageLoader sharedLoader] imageForObject:object
                                             size:size
                                      resultBlock:resultBlock];
    
}

- (NSString *)captionForObject:(id)object
{
    // An asset?
    if ([object isKindOfClass:[NBUAsset class]])
    {
        NSString *fpath = ((NBUAsset *)object).URL.absoluteString;
        return ((NBUAsset *)object).URL.absoluteString;
    }
    
    // Or just the object description
    if ([object isKindOfClass:[NSObject class]])
    {
        return ((NSObject *)object).description;
    }
    
    // No caption
    return nil;
}

//Crop Image
-(void)CallNBUcropImage{
    nbuCrop = [[CropViewController alloc] initWithNibName:@"CropViewController" bundle:nil];
    [nbuCrop awakeFromNib];
    [self.navigationController pushViewController:nbuCrop animated:YES];
}

- (void)setCurrentIndex:(NSInteger)index
               animated:(BOOL)animated
{
    [self.imageLoader imageForObject:self.objectArray[index]
                            size:NBUImageSizeFullResolution
                     resultBlock:^(UIImage * image,
                                   NSError * error)
     {
       globle.NBUimage = image;
         //[self.navigationController popViewControllerAnimated:YES];
         
     }];
}



- (void)setShowThumbnailsView:(BOOL)yesOrNo
{
    [self setShowThumbnailsView:yesOrNo
                       animated:NO];
}





@end



