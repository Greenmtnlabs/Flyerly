//
//  SettingViewController.m
//  Exchange
//
//  Created by krunal on 18/08/09.
//  Copyright 2009 iauro. All rights reserved.
//

#import "SettingViewController.h"
#import "MyNavigationBar.h"
#import <CoreGraphics/CoreGraphics.h>
#import "Common.h"
#import "FlyrAppDelegate.h"
#import "TMAPIClient.h"
#import "HelpController.h"
#import "PhotoController.h"
//#import "FBConnectGlobal.h"

/*extern NSString* kApiKey;
extern NSString* kApiSecret; 
extern NSString* kGetSessionProxy;  
*/
//static NSString* kApiKey = @"64a5dc77bd0a8fd3fbbabd3a5e943ed8";
//static NSString* kApiSecret = @"e9861b57e32abb6821c6853854786302"; // @"<YOUR SECRET KEY>";
//static NSString* kGetSessionProxy=nil; // @"<YOUR SESSION CALLBACK)>";

@implementation SettingViewController
@synthesize flickrButton,facebookButton,twitterButton,instagramButton,tumblrButton,clipboardButton,emailButton,smsButton,helpTab,loadingView,saveToCameraRollLabel,saveToRollSwitch;

-(void)viewWillAppear:(BOOL)animated{

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg_without_logo2"] forBarMetrics:UIBarMetricsDefault];
    //self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Settings" rect:CGRectMake(-45, -6, 50, 50)];
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(-45, -6, 50, 50)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"SHARING SETTINGS";
    self.navigationItem.titleView = label;

    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 31, 30)];
    [menuButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu_button"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(goToMain) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    [self.navigationItem setRightBarButtonItem:menuBarButton];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 31, 30)];
    [backBtn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goToMain) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
}

-(void)viewDidLoad{

    
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"facebookSetting"]){
        [facebookButton setSelected:YES];
    }else{
        [facebookButton setSelected:NO];
    }
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"twitterSetting"]){
        [twitterButton setSelected:YES];
    }else{
        [twitterButton setSelected:NO];
    }

    if([[NSUserDefaults standardUserDefaults] stringForKey:@"instagramSetting"]){
        [instagramButton setSelected:YES];
    }else{
        [instagramButton setSelected:NO];
    }
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"emailSetting"]){
        [emailButton setSelected:YES];
    }else{
        [emailButton setSelected:NO];
    }
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"smsSetting"]){
        [smsButton setSelected:YES];
    }else{
        [smsButton setSelected:NO];
    }
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"clipSetting"]){
        [clipboardButton setSelected:YES];
    }else{
        [clipboardButton setSelected:NO];
    }
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"tumblrSetting"]){
        [tumblrButton setSelected:YES];
    }else{
        [tumblrButton setSelected:NO];
    }
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"flickrSetting"]){
        [flickrButton setSelected:YES];
    }else{
        [flickrButton setSelected:NO];
    }

    if([[NSUserDefaults standardUserDefaults] stringForKey:@"saveToCameraRollSetting"]){
        [saveToRollSwitch setOn:YES];
    }else{
        [saveToRollSwitch setOn:NO];
    }
    
    // Set font and size on camera roll text
    //[saveToCameraRollLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:13]];
}

-(void)goToMain{
        if(IS_IPHONE_5){
            launchController = [[LauchViewController alloc]initWithNibName:@"LauchViewControllerIPhone5" bundle:nil];
        }   else{
            launchController = [[LauchViewController alloc]initWithNibName:@"LauchViewController" bundle:nil];
        }
    
        [self.navigationController pushViewController:launchController animated:YES];
    }

-(IBAction)onClickFacebookButton{
    
    if([facebookButton isSelected]){
        [facebookButton setSelected:NO];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"facebookSetting"];
    } else {
        
        FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
        appDelegate.facebook.sessionDelegate = self;
        
        if([appDelegate.facebook isSessionValid]) {
            [facebookButton setSelected:YES];
            [[NSUserDefaults standardUserDefaults] setObject:@"enabled" forKey:@"facebookSetting"];
            
        } else {
            [appDelegate.facebook authorize:[NSArray arrayWithObjects: @"read_stream",
                                             @"publish_stream", @"email", nil]];
        }
    }
}

-(IBAction)onClickSaveToCameraRollSwitchButton{
    if([saveToRollSwitch isOn]){
        [saveToRollSwitch setOn:YES];
        [[NSUserDefaults standardUserDefaults] setObject:@"enabled" forKey:@"saveToCameraRollSetting"];
    }
    else{
        [saveToRollSwitch setOn:NO];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"saveToCameraRollSetting"];
    }
}

#pragma Request receive code
- (void)fbDidLogin {
	NSLog(@"logged in");
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.facebook.accessToken forKey:@"FBAccessTokenKey"];
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.facebook.expirationDate forKey:@"FBExpirationDateKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [facebookButton setSelected:YES];
    [[NSUserDefaults standardUserDefaults] setObject:@"enabled" forKey:@"facebookSetting"];    
}

-(IBAction)onClickTwitterButton{
    
    if([twitterButton isSelected]){
        [twitterButton setSelected:NO];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"twitterSetting"];
        
    } else {
        
        if([TWTweetComposeViewController canSendTweet]){
            [twitterButton setSelected:YES];
            [[NSUserDefaults standardUserDefaults] setObject:@"enabled" forKey:@"twitterSetting"];
        }  else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"twitterSetting"];
            [self showAlert:@"No Twitter connection" message:@"You must be connected to Twitter from device settings."];
        }
    }
}

-(IBAction)onClickInstagramButton{
    if([instagramButton isSelected]){
        [instagramButton setSelected:NO];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"instagramSetting"];
    } else {
        [instagramButton setSelected:YES];
        [[NSUserDefaults standardUserDefaults] setObject:@"enabled" forKey:@"instagramSetting"];
    }
}

-(IBAction)onClickEmailButton{
    if([emailButton isSelected]){
        [emailButton setSelected:NO];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"emailSetting"];
    } else {
        [emailButton setSelected:YES];
        [[NSUserDefaults standardUserDefaults] setObject:@"enabled" forKey:@"emailSetting"];
    }
}

-(IBAction)onClickSMSButton{
    if([smsButton isSelected]){
        [smsButton setSelected:NO];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"smsSetting"];
    } else {
        [smsButton setSelected:YES];
        [[NSUserDefaults standardUserDefaults] setObject:@"enabled" forKey:@"smsSetting"];
    }
}

-(IBAction)onClickClipboardButton{
    if([clipboardButton isSelected]){
        [clipboardButton setSelected:NO];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"clipSetting"];
    } else {
        [clipboardButton setSelected:YES];
        [[NSUserDefaults standardUserDefaults] setObject:@"enabled" forKey:@"clipSetting"];
    }
}

-(void)showAlert:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(IBAction)onClickTumblrButton{
    if([tumblrButton isSelected]){
        [tumblrButton setSelected:NO];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tumblrSetting"];
    } else {
        
        [tumblrButton setSelected:YES];
        [[NSUserDefaults standardUserDefaults] setObject:@"enabled" forKey:@"tumblrSetting"];

        if([[TMAPIClient sharedInstance].OAuthToken length] > 0  && [[TMAPIClient sharedInstance].OAuthTokenSecret length] > 0){
            
        } else {
            
            [TMAPIClient sharedInstance].OAuthConsumerKey = TumblrAPIKey;
            [TMAPIClient sharedInstance].OAuthConsumerSecret = TumblrSecretKey;
            
            if((![[[TMAPIClient sharedInstance] OAuthToken] length] > 0) ||
               (![[[TMAPIClient sharedInstance] OAuthTokenSecret] length] > 0)){
                
                loadingView =[LoadingView loadingViewInView:self.view  text:@"Wait..."];

                [[TMAPIClient sharedInstance] authenticate:@"Flyerly" callback:^(NSError *error) {
                    
                    // Remove loading view
                    for (UIView *subview in self.view.subviews) {
                        if([subview isKindOfClass:[LoadingView class]]){
                            [subview removeFromSuperview];
                        }
                    }

                    if (error){
                        NSLog(@"Authentication failed: %@ %@", error, [error description]);
                    }else{
                        NSLog(@"Authentication successful!");
                        
                    }
                }];
            }
        }
    }
}

-(IBAction)onClickFlickrButton{
    if([flickrButton isSelected]){
        [flickrButton setSelected:NO];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"flickrSetting"];
    } else {
        
        [flickrButton setSelected:YES];
        [[NSUserDefaults standardUserDefaults] setObject:@"enabled" forKey:@"flickrSetting"];
        [flickrRequest setDelegate:self];
        
        //NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:kStoredAuthTokenKeyName];
        //NSString *authTokenSecret = [[NSUserDefaults standardUserDefaults] objectForKey:kStoredAuthTokenSecretKeyName];
        
        //if((![authToken length] > 0) || (![authTokenSecret length] > 0)){
        [self authorizeAction];
        //}
    }
}

- (void)authorizeAction {
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    
    // if there's already OAuthToken, we want to reauthorize
    if ([appDelegate.flickrContext.OAuthToken length]) {
        [appDelegate.flickrContext  setAuthToken:nil];
    }
    
    self.flickrRequest.sessionInfo = kTryObtainAuthToken;
    [self.flickrRequest  fetchOAuthRequestTokenWithCallbackURL:[NSURL URLWithString:kCallbackURLBaseString]];
}

- (OFFlickrAPIRequest *)flickrRequest
{
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    
    if (!flickrRequest) {
        flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:appDelegate.flickrContext];
        flickrRequest.delegate = self;
		flickrRequest.requestTimeoutInterval = 60.0;
    }
    
    return flickrRequest;
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didObtainOAuthRequestToken:(NSString *)inRequestToken secret:(NSString *)inSecret;
{
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    // these two lines are important
    appDelegate.flickrContext.OAuthToken = inRequestToken;
    appDelegate.flickrContext.OAuthTokenSecret = inSecret;
    
    NSURL *authURL = [appDelegate.flickrContext userAuthorizationURLWithRequestToken:inRequestToken requestedPermission:OFFlickrWritePermission];
    [[UIApplication sharedApplication] openURL:authURL];
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError{
    NSLog(@"Fail request %@, error: %@", inRequest, inError);
}

-(IBAction)loadHelpController{
    HelpController *helpController = [[HelpController alloc]initWithNibName:@"HelpController" bundle:nil];
    [self.navigationController pushViewController:helpController animated:NO];
}

/*
@synthesize password,user,doneButton,scrollView,navBar,twitDialog;

-(void)initSession{
	if (kGetSessionProxy) {
		_session = [[FBSession sessionForApplication:kApiKey getSessionProxy:kGetSessionProxy
											delegate:self] retain];
	} else {
		_session = [[FBSession sessionForApplication:kApiKey secret:kApiSecret delegate:self] retain];
	}
	[_session resume];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

		[self initSession];
    }
    return self;
}

- (void)session:(FBSession*)session didLogin:(FBUID)uid{
	NSLog(@"45");
	//FlyrAppDelegate *appDele =(FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
	//appDele._session = _session;
	
}

-(void)callMenu{
	[self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	navBar= [[MyNavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
	[self.view addSubview:navBar];
	navBar.alpha = ALPHA1;
	[navBar show:@"Settings" left:@"Menu" right:@""];
	
	[navBar.leftButton removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	[navBar.rightButton removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	
	[navBar.leftButton addTarget:self action:@selector(callMenu) forControlEvents:UIControlEventTouchUpInside];
	[navBar.rightButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	[self.view bringSubviewToFront:navBar];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
     [super viewDidLoad];
     //[server becomeFirstResponder];
	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2f];
	//self.navigationItem.title = @"Setting";
	//self.navigationController.navigationBarHidden = NO;
	//self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	[UIView commitAnimations];
	self.view.frame = CGRectMake(0, 44, 320, 416);

	password.delegate = self;
	user.delegate = self;

	keyboardShown = false;
	scrollView.pagingEnabled = YES;
	scrollView.contentSize = CGSizeMake(300, 300);
	scrollView.showsVerticalScrollIndicator = YES;
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
	scrollView.scrollsToTop = YES;
	
	[self registerForKeyboardNotifications];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString  *passStr = [defaults objectForKey:@"passwordPref"];
	NSString *userStr = [defaults objectForKey:@"userPref"];

	password.text = passStr;
	user.text = userStr;
	//doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doDone:)];
	//[self.navigationItem setRightBarButtonItem:doneButton animated:YES];
	
}

-(IBAction)createTwitLogin:(id)sender{
	twitDialog = [[TwitLogin alloc]init];
	//twitDialog.flyerImage = flyrImg;
	FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
	twitDialog.svController = appDele.svController;
	appDele._tSession = twitDialog;
	[twitDialog show];
	[self.view addSubview:twitDialog];
}


- (void)postDismissCleanup {
	//FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
	//[appDele.dialog dismiss:YES];
	[navBar removeFromSuperview];
	[navBar release];
}

- (void)dismissNavBar:(BOOL)animated {
	
	
	if (animated) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(postDismissCleanup)];
		navBar.alpha = 0;
		[UIView commitAnimations];
	} else {
		[self postDismissCleanup];
	}
}

-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:YES];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject:password.text forKey:@"passwordPref"];
	[defaults setObject:user.text forKey:@"userPref"];
	[self dismissNavBar:YES];
	//[self.navigationController popToRootViewControllerAnimated:YES];
}




- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasHidden:)
												 name:UIKeyboardDidHideNotification object:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (keyboardShown)
        return;
    NSDictionary* info = [aNotification userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    CGRect viewFrame = [scrollView frame];
    viewFrame.size.height -= keyboardSize.height;
    scrollView.frame = viewFrame;
    CGRect textFieldRect = [activeField frame];
    [scrollView scrollRectToVisible:textFieldRect animated:YES];
	keyboardShown = YES;
}


- (void)keyboardWasHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    CGRect viewFrame = [scrollView frame];
    viewFrame.size.height += keyboardSize.height;
    scrollView.frame = viewFrame;
	[scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    keyboardShown = NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
	activeField = textField;
	return;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	if(textField == user)
	{
		[user resignFirstResponder];
		[password becomeFirstResponder];
	}
	return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
	
    //[_session release];
    [super dealloc];
}

*/
@end
