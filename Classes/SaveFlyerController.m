//
//  SaveFlyerController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd on 10/27/09.
//
//

#import "SaveFlyerController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CreateFlyerController.h"
#import "FlyrAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "ShareViewController.h"
#import "Common.h"
//#import "FBConnectGlobal.h"

@implementation SaveFlyerController

@synthesize twitterButton,mailButton,faceBookButton,uploadButton,ptController,dvController;
@synthesize flyrImg,twitUser,twitPass,twitAlert,facebookAlert,isDraftView;
@synthesize twitMsg,flyrImgData,_session,alertTextField,imgName;
//@synthesize navBar,twit;


-(void)callPhotoController{
	[self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)callDraftController{
	[self.navigationController popToViewController:dvController animated:YES];
	isDraftView = NO;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
 	_session = nil;
    
	UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0,44 ,320, 416)];
	imgView.image = flyrImg;
	[self.view addSubview:imgView];
	
	twitterButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
	twitterButton.frame = CGRectMake(1, 400, 105, 59);
	[twitterButton setBackgroundImage:[UIImage imageNamed:@"twit1.png"] forState:UIControlStateNormal];
	[twitterButton setBackgroundImage:[UIImage imageNamed:@"twit.png"] forState:UIControlStateSelected];
	[twitterButton setBackgroundImage:[UIImage imageNamed:@"twit.png"] forState:UIControlStateHighlighted];
    CALayer * l = [twitterButton layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:5];
    [l setBorderWidth:1.0];
    [l setBorderColor:[[UIColor lightGrayColor] CGColor]];
	[twitterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[twitterButton addTarget:self action:@selector(uploadOption:) forControlEvents:UIControlEventTouchUpInside];
	[self.view  addSubview:twitterButton];
	
	
	faceBookButton = [UIButton buttonWithType:UIButtonTypeCustom];
	faceBookButton.frame = CGRectMake(107, 400, 105, 59);
	//faceBookButton.style = FBLoginButtonStyleNormal;
	[faceBookButton setBackgroundImage:[UIImage imageNamed:@"facebook1.png"] forState:UIControlStateNormal];
	[faceBookButton setBackgroundImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateSelected];
	[faceBookButton setBackgroundImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateHighlighted];
	faceBookButton.backgroundColor = [UIColor clearColor];
	[faceBookButton addTarget:self action:@selector(uploadOption:) forControlEvents:UIControlEventTouchUpInside];
	CALayer * l1 = [faceBookButton layer];
    [l1 setMasksToBounds:YES];
    [l1 setCornerRadius:5];
    [l1 setBorderWidth:1.0];
    [l1 setBorderColor:[[UIColor lightGrayColor] CGColor]];
	[self.view  bringSubviewToFront:faceBookButton];
	[self.view addSubview:faceBookButton];
	
	mailButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	mailButton.frame = CGRectMake(106+107, 400, 105, 59);
	[mailButton setBackgroundImage:[UIImage imageNamed:@"mail1.png"] forState:UIControlStateNormal];
	[mailButton setBackgroundImage:[UIImage imageNamed:@"mail.png"] forState:UIControlStateSelected];
	[mailButton setBackgroundImage:[UIImage imageNamed:@"mail.png"] forState:UIControlStateHighlighted];
	CALayer * l2 = [mailButton layer];
	[l2 setMasksToBounds:YES];
	[l2 setCornerRadius:5];
	[l2 setBorderWidth:1.0];
	[l2 setBorderColor:[[UIColor lightGrayColor] CGColor]];
	//[mailButton setTitle:@"Mail" forState:UIControlStateNormal];
	[mailButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[mailButton addTarget:self action:@selector(uploadOption:) forControlEvents:UIControlEventTouchUpInside];
	[self.view  addSubview:mailButton];
	
	FlyrAppDelegate *appDele =(FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
	appDele.svController = self;
	
    
}

#pragma mark  Twitter PHOTO UPLOAD 


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	//[self.navBar.leftButton setEnabled:YES];
	if(alertView == twitAlert && buttonIndex == 1)
	{
		NSString *tempTwit = [NSString stringWithFormat:@"%@",alertTextField.text];
		
		if([tempTwit isEqualToString:@""] || [tempTwit isEqualToString:@"(null)"] )
			twitMsg = @"Created by #SocialFlyr";
		else
		{
			tempTwit = [tempTwit stringByAppendingString:@" #SocialFlyr"];
			twitMsg =[[NSString alloc]initWithString:tempTwit];
		}
			
		
		[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doTweet) userInfo:nil repeats:NO];
		[alertTextField resignFirstResponder];
	}
	else if(alertView == twitAlert && buttonIndex == 0)
		[alertTextField resignFirstResponder]; 
	else if(alertView == facebookAlert && buttonIndex == 1){
		[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(uploadPhoto) userInfo:nil repeats:NO];
	}
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

-(void)callTwitAlert
{
	twitAlert =[[UIAlertView alloc]initWithTitle:@"Share Flyr" message:@"\n\n" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
	twitAlert.frame = CGRectMake(50, 150, 250, 300);
	alertTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 55, 255, 30)];
	alertTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	alertTextField.placeholder = @"Enter your tweet";
	alertTextField.borderStyle = UITextBorderStyleRoundedRect;
	alertTextField.backgroundColor = [UIColor clearColor];
	alertTextField.returnKeyType = UIReturnKeyDone;
	alertTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	alertTextField.delegate = self;
	alertTextField.tag = 1;
	[twitAlert addSubview:alertTextField];
	CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0.0, 75.0);
	[twitAlert setTransform:myTransform];
	[twitAlert show];
}

-(void)callFacebookAlert{
	facebookAlert = [[UIAlertView alloc]initWithTitle:@"Share Flyr" message:@"" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
	[facebookAlert show];
}

#pragma mark  faceBook PHOTO UPLOAD 

-(void)uploadPhoto {
    [FBRequest requestForUploadPhoto:flyrImg];
}

#pragma mark  In APP MAIL  PHOTO UPLOAD 
-(void)launchMailAppOnDevice
{
	NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=SocialFlyr";
	NSString *body = @"&body=";
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

-(void)displayComposerSheet 
{
	
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	[picker setSubject:@"Check out my SocialFlyr..."];
	// Set up recipients
	NSArray *toRecipients = [[NSArray alloc]init];
	NSArray *ccRecipients =   [[NSArray alloc]init];
	NSArray *bccRecipients =   [[NSArray alloc]init];
	[picker setToRecipients:toRecipients];
	[picker setCcRecipients:ccRecipients];	
	[picker setBccRecipients:bccRecipients];
	// Fill out the email body text
	NSData *imageData = UIImagePNGRepresentation(flyrImg);
	[picker addAttachmentData:imageData mimeType:@"image/png" fileName:@"flyr.png"];
	NSString *emailBody = @"";
	[picker setMessageBody:emailBody isHTML:NO];
	[self presentModalViewController:picker animated:YES];
}

-(void)dismiss
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	switch (result) {
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
			break;
	}
	[controller dismissModalViewControllerAnimated:YES];
}

-(void) showInlineMailClient {
	//[self.navBar setUserInteractionEnabled:YES];
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		if ([mailClass canSendMail])
		{
			[self displayComposerSheet];
		}
		else
		{
			[self launchMailAppOnDevice];
		}
	}
	else
	{
		[self launchMailAppOnDevice];
	}
}


#pragma mark  Facebook permission delegate
/*
- (void)dialogDidSucceed:(FBDialog*)dialog {
	
    FlyrAppDelegate *appDele =(FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
	appDele.faceBookPermissionFlag = YES;
         [self callFacebookAlert];
}

- (void)dialogDidCancel:(FBDialog*)dialog {
    [self callFacebookAlert];
}*/

#pragma mark  UPLOAD TAB Functions

-(void) uploadOption:(id) sender 
{
	[uploadButton setAlpha:0];
	if(sender == twitterButton)
	{
		/*twitDialog = [[TwitLogin alloc]init];
		twitDialog.flyerImage = flyrImg;
		twitDialog.svController = self;
		[twitDialog show];
		[self.view addSubview:twitDialog];*/
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSString  *passStr = [defaults objectForKey:@"tpass_pref"];
		NSString *userStr = [defaults objectForKey:@"tuser_pref"];
		
		if(passStr != nil && userStr != nil ){
			//[appDele._tSession callLoginFromLoginController];
			[self callTwitAlert];
		}
		else{
			UIAlertView *fail = [[UIAlertView alloc]initWithTitle:@"Twitter" message:@"Authentication failed: \n Set username and password in Preferences" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[fail show];
		}
	}
	else if(sender == faceBookButton) {
	}
	else if(sender == mailButton)
	{
		[NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(showInlineMailClient) userInfo:nil repeats:NO];
	}
}

@end
