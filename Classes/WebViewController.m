//
//  WebViewController.m
//  Flyr
//
//  Created by rufi on 04/11/2015.
//
//

#import "WebViewController.h"
#import "FlyerlySingleton.h"

@interface WebViewController ()

@end

@implementation WebViewController
@synthesize webView;
@synthesize segmentedButton, popupAlert;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Setting navigation bar
    [self setNavigation];
    
    webView.delegate = self;
    // Setting selected segment
    self.segmentedButton.selectedSegmentIndex = 0;
    
    // Setting default URL
    [self openWebView:@"https://twitter.com/hashtag/flyerly"];
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

#pragma mark WebView Delegate Methods

/*
 * Invokes when webview statrts loading
 */
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showLoadingView];
    [loadingView setHidden:NO];
}

/*
 * Invokes when webview finishes loading
 */

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [loadingView setHidden:YES];
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

/*
 * Opens WebView
 * @params:
 *      stringURL: NSString
 * @return:
 *      void
 */
-(void)openWebView:(NSString *) stringURL{
    
    if([FlyerlySingleton connected]){
        //Create a URL Object
        NSURL *url = [NSURL URLWithString:stringURL];
        //URL Requst Object
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        //Load the request in the UIWebView.
        [self.webView loadRequest:requestObj];
     }else {
         // Alert when no internet
         popupAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                 message:@"Check your internet connection."
                                                delegate:self
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
         [popupAlert show];
     }
}

/*
 * Invokes when segment changes
 */
- (IBAction)segmentedControlAction:(id)sender {
    
    NSString *urlAddress;
    
    if (segmentedButton.selectedSegmentIndex == 0) {
        urlAddress  = @"https://twitter.com/hashtag/flyerly";
    }
    else if(segmentedButton.selectedSegmentIndex == 1){
        urlAddress  = @"https://instagram.com/explore/tags/flyerly/";
    }
    [self openWebView:urlAddress];
}

/*
 * Shows loading view while webview loads
 * @params:
 *      void
 * @return:
 *      void
 */
-(void) showLoadingView{
    
    double x = self.view.frame.size.width - 80;
    double y = self.view.frame.size.height;
    loadingView = [[UIView alloc]initWithFrame:CGRectMake(x/2, y/2, 80, 80)];
    loadingView.backgroundColor = [UIColor colorWithWhite:0. alpha:0.6];
    loadingView.layer.cornerRadius = 5;
    
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = CGPointMake(loadingView.frame.size.width / 2.0, 35);
    [activityView startAnimating];
    activityView.tag = 100;
    [loadingView addSubview:activityView];
    
    UILabel* lblLoading = [[UILabel alloc]initWithFrame:CGRectMake(0, 48, 80, 30)];
    lblLoading.text = @"Loading...";
    lblLoading.textColor = [UIColor whiteColor];
    lblLoading.font = [UIFont fontWithName:lblLoading.font.fontName size:15];
    lblLoading.textAlignment = NSTextAlignmentCenter;
    [loadingView addSubview:lblLoading];
    
    [self.view addSubview:loadingView];
}

@end
