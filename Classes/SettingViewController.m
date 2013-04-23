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
//#import "FBConnectGlobal.h"

/*extern NSString* kApiKey;
extern NSString* kApiSecret; 
extern NSString* kGetSessionProxy;  
*/
static NSString* kApiKey = @"64a5dc77bd0a8fd3fbbabd3a5e943ed8";
static NSString* kApiSecret = @"e9861b57e32abb6821c6853854786302"; // @"<YOUR SECRET KEY>";
static NSString* kGetSessionProxy=nil; // @"<YOUR SESSION CALLBACK)>";


@implementation SettingViewController
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
