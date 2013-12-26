//
//  LoginController.m
//  Flyer
//
//  Created by Krunal on 05/10/09.
//  Copyright 2009 iauro. All rights reserved.
//

#import "LoginController.h"
#import "MGTwitterEngine.h"
#import <QuartzCore/QuartzCore.h>
#import "MGTwitterEngineGlobalHeader.h"
#import "PhotoController.h"
#import "TwitLogin.h"
#import "OLBTwitpicEngine.h"
#import "HudView.h"

@implementation LoginController

@synthesize netObj,netStat,userName,passWord,twit,flyerImg;

-(id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle modal:(BOOL)modal
{
	self = [super initWithNibName:nibName bundle:nibBundle];
	if(self)
	{
		_modal = modal;
	}
	
	return self;
}

- (IBAction)cancel:(id)sender 
{
	if(_remember)
		[MGTwitterEngine remindPassword];
          [self.navigationController dismissModalViewControllerAnimated:YES];
	//[self.navigationController popViewControllerAnimated:YES];
}


-(void)doTweet:(NSString*)twitUser password:(NSString*)twitPassword
{
	//UIImage *img = [self getCurrentFrameAndSaveIt];
	twit = [[OLBTwitpicEngine alloc]initWithDelegate:self];
	
	[twit uploadImageToTwitpic:flyerImg withMessage:nil username:twitUser password:twitPassword];
}

- (void)twitpicEngine:(OLBTwitpicEngine *)engine didUploadImageWithResponse:(NSString *)response{
	NSLog(response);
}


-(void)sendStatusCode:(NSInteger)statusCode
{
	printf("status:%d",statusCode);
	if(statusCode == 200)
	{
		[self.navigationController dismissModalViewControllerAnimated:YES];
		[self.navigationController popViewControllerAnimated:YES];
		
		[self doTweet:userName password:passWord];
	}
	else
	{
		UIAlertView *fail = [[UIAlertView alloc]initWithTitle:@"Twitter" message:@"Authentication failed: Wrong username or password combination." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[fail show];
	}
}




- (void)login:(NSString*)user password:(NSString*)pass
{

	
	userName = user;
	passWord = pass;
	
	[MGTwitterEngine setUsername:userName password:passWord remember:[rememberSwitch isOn]];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"AccountChanged" object:nil 
													  userInfo:@{@"login": userName, @"password": passWord}];
	
	MGTwitterEngine *mte = [[MGTwitterEngine alloc]initWithDelegate:self];
	mte.loginController =self;
	//[mte showHUD];
	
	NSString *temp = [mte checkUserCredentials];
	NSLog(temp);
	
}

+ (void)showModeless:(UINavigationController*)parentController animated:(BOOL)anim
{
	static LoginController* sharedController;
	if(!sharedController)
	{
		sharedController = [[LoginController alloc] initWithNibName:@"Login" bundle:nil modal:NO];
	}
	
	[parentController pushViewController:sharedController animated:anim];
}

+ (void)showModal:(UINavigationController*)parentController
{
	static LoginController* sharedController;
	static UINavigationController *navigationController;
	if(!sharedController)
	{
		sharedController = [[LoginController alloc] initWithNibName:@"Login" bundle:nil modal:YES];
		navigationController = [[UINavigationController alloc] initWithRootViewController:sharedController];
	}
	
	[parentController presentModalViewController:navigationController animated:YES];
}

-(void)viewDidLoad
{
	
	self.title = @"Twitter";
	self.navigationItem.title = @"Twitter Account";
	if (nil == netStat) 
	{
		netStat = [[UIAlertView alloc]initWithTitle:@"NETWORK STATUS" message:@"Network Unreachable!\nPlease make sure that you are connected to Internet." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
	}
	//netObj =[[MyNetworkController alloc]init];
	//if([netObj connectedToNetwork] == YES)
	{

		//_remember = [[loginField text] length] == 0? NO: YES;
		[rememberSwitch setOn: _remember];
		
		if(_remember)
			[MGTwitterEngine forgetPassword];
	}
	//else 
	{	
	//	[netStat show];
		
	}
	self.navigationController.navigationBarHidden = YES;
	//self.view.frame = CGRectMake(0,0, 320, 480);
	TwitLogin *t = [[TwitLogin alloc]init];
	t.lController = self;
	[t show];
	[self.view addSubview:t];

	
}


#pragma mark  keyboardWindow Fuctions




-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:YES];
	//self.view.backgroundColor = [UIColor blackColor];
	//self.navigationController.navigationBarHidden = YES;
}



-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:YES];
	self.navigationController.navigationBarHidden = NO;
	//[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
	//textField.keyboardType = UIKeyboardTypeDefault;
}

@end



