//
//  WebViewController.m
//  Flyr
//
//  Created by rufi on 04/11/2015.
//
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Setting navigation bar
    [self setNavigation];
    
}

#pragma mark Navigation/UI Related Methods

/*
 * Sets navigation bar at the top
 * @params:
 *      void
 * @return:
 *      void
 */
-(void) setNavigation{

    // for Navigation Bar logo
    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 102, 38)];
    
    [logo setImage:[UIImage imageNamed:@"flyerlylogo"]];
    self.navigationItem.titleView = logo;
    
     // Home Button
    btnHome = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [btnHome addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [btnHome setBackgroundImage:[UIImage imageNamed:@"home_button"] forState:UIControlStateNormal];
    btnHome.showsTouchWhenHighlighted = YES;
    leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:btnHome];
    
    // Set right bar items
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    
}

#pragma mark Custom Methods

/*
 * Back to Home Screen
 * @params:
 *      void
 * @return:
 *      void
 */
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}




@end
