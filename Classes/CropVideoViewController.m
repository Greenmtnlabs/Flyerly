//
//  CropVideoViewController.m
//  Flyr
//
//  Created by Khurram Ali on 21/05/2014.
//
//

#import "CropVideoViewController.h"
#import "FlyerlySingleton.h"

@interface CropVideoViewController ()

@end

@implementation CropVideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (( self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] )) {
        
        // Done Button
        UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 42)];
        [nextButton addTarget:self action:@selector(onDone) forControlEvents:UIControlEventTouchUpInside];
        [nextButton setBackgroundImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
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
        label.textColor = [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];
        label.text = @"CROP";
        
        self.navigationItem.titleView = label;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma - Button Event Handlers

/**
 * Go back to the last screen.
 */
-(void) goBack {
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController popViewControllerAnimated:YES];
    
    _onVideoCancel();
}

/**
 * We are done, use the cropped and filtered image.
 */
-(void)onDone {
    // Go back to the last screen.
    [self.navigationController popViewControllerAnimated:YES];
   
    _onVideoFinished( _url );
}

@end
