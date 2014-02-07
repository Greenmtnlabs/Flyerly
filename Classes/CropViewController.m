//
//  CropViewController.m
//  Flyr
//
//  Developed by RIKSOF (Private) Limited
//  Copyright Flyerly. All rights reserved.
//

#import "CropViewController.h"
#import "FlyerlySingleton.h"

@implementation CropViewController
@synthesize desiredImageSize;
@synthesize onImageTaken;

#pragma mark - Initialization

/**
 * This view is initialized through the NIB.
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    if (( self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] )) {
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg_without_logo2"] forBarMetrics:UIBarMetricsDefault];

    
        // Done Button
        UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
        [nextButton addTarget:self action:@selector(onDone) forControlEvents:UIControlEventTouchUpInside];
        [nextButton setBackgroundImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
        UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    
        [self.navigationItem setRightBarButtonItem:doneBarButton];
    
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
        label.textColor = [UIColor whiteColor];
        label.text = @"CROP & FILTER";
        
        self.navigationItem.titleView = label;
    }
    
    return self;
}

#pragma mark - View Events

- (void)viewDidLoad {
    // Set working size for filters.
    self.workingSize = desiredImageSize;
    
    // Set the grid size.
    self.cropGuideSize = desiredImageSize;
    
    // Configure and set all available filters
    self.filters = [NBUFilterProvider availableFilters];
    
    // Configure crop view. We may get big pixels with this factor!
    self.maximumScaleFactor = 10.0;
    self.cropView.allowAspectFit = YES;
    
    // Use the image from filters for cropping.
    self.filterView.image = self.image;
    
    // Make sure the filters are visible. Get the current height based on
    // navigation bar status and device height.
    NSInteger height = [ [ UIScreen mainScreen ] bounds ].size.height;
    
    if ( height <= 480 ) {
        CGRect fr = self.filterView.superview.frame;
        fr.size.height -= 88;
        self.filterView.superview.frame = fr;
    }
    
    [super viewDidLoad];
}

#pragma - Button Event Handlers

/**
 * Go back to the last screen.
 */
-(void) goBack {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Camerabottom"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * We are done, use the cropped and filtered image.
 */
-(void)onDone {
    // Go back to the last screen.
    [self.navigationController popViewControllerAnimated:YES];
    
    self.image = self.filterView.image;
    self.onImageTaken( [self.editedImage imageWithOrientationUp] );
}

@end

