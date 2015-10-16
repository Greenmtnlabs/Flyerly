//
//  WebViewViewController.m
//  Flyr
//
//  Created by rufi on 16/10/2015.
//
//

#import "WebViewViewController.h"

@interface WebViewViewController ()

@end

@implementation WebViewViewController
@synthesize webView;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigation];
    [self loadWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * Method to load WebView
 * @params:
 *      void
 * @return:
 *      void
 */

-(void) loadWebView{
    
    NSURL *url = [NSURL URLWithString:@"https://twitter.com/hashtag/flyerly"];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
}

/*
 * Method to set navigation bar controls
 * @params:
 *      void
 * @return:
 *      void
 */

-(void)setNavigation {
    
    // for Navigation Bar logo
    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 102, 38)];
    [logo setImage:[UIImage imageNamed:@"flyerlylogo"]];
    self.navigationItem.titleView = logo;
    
    // Back Navigation button
    btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [btnBack addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"home_button"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    btnBack.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
   
    // adds left button to navigation
    [self.navigationItem setLeftBarButtonItem:backBarButton];
}

/*
 * Method to redirect to home screen
 * @params:
 *      void
 * @return:
 *      void
 */
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
