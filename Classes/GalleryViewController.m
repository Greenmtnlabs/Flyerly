//
//  GalleryViewController.h
//  Flyr
//
//  Developed by RIKSOF (Private) Limited
//  Copyright Flyerly. All rights reserved.
//

#import "GalleryViewController.h"
#import "CropViewController.h"
#import "FlyerlySingleton.h"

@implementation GalleryViewController
@synthesize desiredImageSize;
@synthesize onImageTaken;

/**
 * Initialize the gallery.
 */
- (void)commonInit {
    [super commonInit];
    
    // Load all the assets from photo library.
    [[NBUAssetsLibrary sharedLibrary] allImageAssetsWithResultBlock:^(NSArray * assets,NSError * error) {
        if (!error) {
            self.objectArray = assets;
            [self setShowThumbnailsView:YES];
            self.title = @"GalleryView";
        }
     }];
}

/**
 * Load the view.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // BackButton
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    
    // Right button
    UIButton *rigButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rigButton];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    
    // Set the title view.
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-35, -6, 50, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"SELECT PHOTO";
    
    self.navigationItem.titleView = label;
}


#pragma mark - Gallery methods

/**
 * Crop image using NBUKit
 */
-(void) cropImage:(UIImage *)img {
    
    // Get out of full screen mode.
    [self viewWillDisappear:NO];
    
    CropViewController *nbuCrop = [[CropViewController alloc] initWithNibName:@"CropViewController" bundle:nil];
    nbuCrop.desiredImageSize = desiredImageSize;
    nbuCrop.image = [img imageWithOrientationUp];
    nbuCrop.onImageTaken = onImageTaken;
    
    // Pop the current view, and push the crop view.
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [viewControllers addObject:nbuCrop];
    [[self navigationController] setViewControllers:viewControllers animated:YES];
}


#pragma mark - Button event handlers

/**
 * Select this image and go to the crop and filter screen.
 */
- (void)thumbnailWasTapped:(UIView *)sender {
	[self.imageLoader imageForObject:self.objectArray[sender.tag]
                                size:NBUImageSizeFullResolution
                         resultBlock:^(UIImage * image,
                                       NSError * error)
    {
        if (!error) {
                                 
            dispatch_async( dispatch_get_main_queue(), ^{
                // Crop the image
                [self cropImage:image];
            });
        }
     }];
}

/**
 * Cancel and go back.
 */
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end



