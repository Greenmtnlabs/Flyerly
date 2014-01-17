//
//  SettingViewController.m
//  Exchange
//
//  Created by krunal on 18/08/09.
//  Copyright 2009 iauro. All rights reserved.
//

#import "ShareSettingViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import "Common.h"
#import "FlyrAppDelegate.h"
#import "HelpController.h"
#import "PhotoController.h"


@implementation ShareSettingViewController
@synthesize flickrButton,facebookButton,twitterButton,instagramButton,tumblrButton,clipboardButton,emailButton,smsButton,helpTab,saveToCameraRollLabel,saveToRollSwitch;

-(void)viewWillAppear:(BOOL)animated{

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg_without_logo2"] forBarMetrics:UIBarMetricsDefault];
    //self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Settings" rect:CGRectMake(-45, -6, 50, 50)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-35, -6, 50, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"SHARE SETTINGS";
    self.navigationItem.titleView = label;

    UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [helpButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [helpButton setBackgroundImage:[UIImage imageNamed:@"help_icon"] forState:UIControlStateNormal];
    [helpButton addTarget:self action:@selector(gohelp) forControlEvents:UIControlEventTouchUpInside];
    helpButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *helpBarButton = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
    [self.navigationItem setRightBarButtonItem:helpBarButton];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [backBtn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
     backBtn.showsTouchWhenHighlighted = YES;
    [backBtn addTarget:self action:@selector(goToMain) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
}

-(void)viewDidLoad{

    globle = [Singleton RetrieveSingleton];
    [self.view setBackgroundColor:[globle colorWithHexString:@"f5f1de"]];

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
        [self.navigationController popViewControllerAnimated:YES];
    }

-(IBAction)onClickFacebookButton{
    
    if([facebookButton isSelected]){
        [facebookButton setSelected:NO];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"facebookSetting"];
    } else {
        
        [facebookButton setSelected:YES];
        [[NSUserDefaults standardUserDefaults] setObject:@"enabled" forKey:@"facebookSetting"];
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
/*
- (void)fbDidLogin {
	NSLog(@"logged in");
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.facebook.accessToken forKey:@"FBAccessTokenKey"];
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.facebook.expirationDate forKey:@"FBExpirationDateKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [facebookButton setSelected:YES];
    [[NSUserDefaults standardUserDefaults] setObject:@"enabled" forKey:@"facebookSetting"];    
}
 */

-(IBAction)OntwitterComments{
    InputViewController  *inputv = [[InputViewController alloc]initWithNibName:@"InputViewController" bundle:nil];
    [self.navigationController presentModalViewController:inputv animated:YES];
}

-(IBAction)RateApp:(id)sender{
    float ver = [ globle.iosVersion floatValue];
    NSString* url;
    if (ver >= 7) {
        url = [NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id344130515"];
    }else{
        url = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", @"344130515"];
    }
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
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
}

-(IBAction)onClickTumblrButton{
    if([tumblrButton isSelected]){
        [tumblrButton setSelected:NO];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tumblrSetting"];
    } else {
        
        [tumblrButton setSelected:YES];
        [[NSUserDefaults standardUserDefaults] setObject:@"enabled" forKey:@"tumblrSetting"];
/*
        if([[TMAPIClient sharedInstance].OAuthToken length] > 0  && [[TMAPIClient sharedInstance].OAuthTokenSecret length] > 0){
            
        } else {
            
            [TMAPIClient sharedInstance].OAuthConsumerKey = TumblrAPIKey;
            [TMAPIClient sharedInstance].OAuthConsumerSecret = TumblrSecretKey;
            
            if((![[[TMAPIClient sharedInstance] OAuthToken] length] > 0) ||
               (![[[TMAPIClient sharedInstance] OAuthTokenSecret] length] > 0)){
                
                [self showLoadingIndicator];

                [[TMAPIClient sharedInstance] authenticate:@"Flyerly" callback:^(NSError *error) {
 
                    // Remove loading view
                    [self hideLoadingIndicator];

                    if (error){
                        NSLog(@"Authentication failed: %@ %@", error, [error description]);
                    }else{
                        NSLog(@"Authentication successful!");
                        
                    }
                }];
            }
        } */
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
        //[self authorizeAction];
        //}
    }
}
/*
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
*/
-(IBAction)loadHelpController{
    HelpController *helpController = [[HelpController alloc]initWithNibName:@"HelpController" bundle:nil];
    [self.navigationController pushViewController:helpController animated:NO];
}

-(IBAction)makeEmail{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    if([MFMailComposeViewController canSendMail]){
        
        picker.mailComposeDelegate = self;
        [picker setSubject:@"email feedback..."];
        
        // Set up recipients
        NSMutableArray *toRecipients = [[NSMutableArray alloc]init];
        [toRecipients addObject:@"support@greenmtnlabs.com"];
        [picker setToRecipients:toRecipients];
        
        //NSString *emailBody = [NSString stringWithFormat:@"<font size='4'><a href = '%@'>Share a flyer</a></font>", @"http://www.flyer.us"];
        //[picker setMessageBody:emailBody isHTML:YES];
        
        [self presentModalViewController:picker animated:YES];
    }
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

-(void)gohelp{
    HelpController *helpController = [[HelpController alloc]initWithNibName:@"HelpController" bundle:nil];
    [self.navigationController pushViewController:helpController animated:NO];
    
}

@end
