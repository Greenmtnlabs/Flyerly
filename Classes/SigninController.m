//
//  SigninController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 7/4/13.
//
//

#import "SigninController.h"
#import "Common.h"
#import "PhotoController.h"
#import <Parse/PFQuery.h>
#import "AddFriendsController.h"
#import "LoadingView.h"
#import "AccountController.h"

@interface SigninController ()

@end

@implementation SigninController
@synthesize email,password,signIn,signUp,signInFacebook,signInTwitter,emailImage,passwordImage,loadingView,forgetPassword1,act;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
    globle = [Singleton RetrieveSingleton];
    
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:@"Forgot Password?"];
    
    // making text property to underline text-
    [titleString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [titleString length])];
    
    // using text on button
    [forgetPassword1 setAttributedTitle: titleString forState:UIControlStateNormal];
    forgetPassword1.titleLabel.textColor = [UIColor grayColor];
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage   imageNamed:@"top_bg_without_logo2"] forBarMetrics:UIBarMetricsDefault];

    //set title
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(-35, -6, 50, 50)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"SIGN IN";
    
    self.navigationItem.titleView = label;//[PhotoController setTitleViewWithTitle:@"Sign In" rect:CGRectMake(-35, -6, 50, 50)];

    // remove borders
    email.borderStyle = UITextBorderStyleNone;
    password.borderStyle = UITextBorderStyleNone;
    
    // set clear text overlay
    email.clearButtonMode = UITextFieldViewModeWhileEditing;
    password.clearButtonMode = UITextFieldViewModeWhileEditing;
    usr = [[NSUserDefaults standardUserDefaults] stringForKey:@"User"];
    if (usr != nil) {
        email.text = usr;
        password.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"Password"];

//    email.text= @"riz_ahmed_86@yahoo.com";
 //   password.text = @"logs";
    }
    // Setup welcome button
    UIButton *welcomeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 29, 25)];
    //[welcomeButton setTitle:@"" forState:UIControlStateNormal];
    welcomeButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [welcomeButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [welcomeButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:welcomeButton];
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:leftBarButton,nil]];

    UIButton *siginBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [siginBtn setTitle:@"Sign In" forState:UIControlStateNormal];
    siginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
    [siginBtn addTarget:self action:@selector(onSignIn) forControlEvents:UIControlEventTouchUpInside];
    [siginBtn setBackgroundImage:[UIImage imageNamed:@"signin_button"] forState:UIControlStateNormal];
    UIBarButtonItem *righBarButton = [[UIBarButtonItem alloc] initWithCustomView:siginBtn];
    [self.navigationItem setRightBarButtonItem:righBarButton];
/*
    // Navigation bar sign in button
    UIBarButtonItem *signInTopRightButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign In" style:UIBarButtonItemStylePlain target:self action:@selector(onSignIn)];
    
    [signInTopRightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:BUTTON_FONT size:13.0], UITextAttributeFont,nil] forState:UIControlStateNormal];
    
    [signInTopRightButton setTintColor:[UIColor colorWithRed:104.0/255.0 green:173.0/255.0 blue:57.0/255.0 alpha:1]];
    self.navigationItem.rightBarButtonItem = signInTopRightButton;
    [signInTopRightButton release];
 */
}

-(IBAction)forgetPassword{

    [self showLoadingView:@"Wait..."];
    NSLog(@"Forget Password");
    
    [PFUser requestPasswordResetForEmailInBackground:email.text block:^(BOOL succeeded, NSError *error){
        if (error) {
            
            NSString *errorValue = [error.userInfo objectForKey:@"error"];
            [self removeLoadingView];
            [self showAlert:@"Warning!" message:errorValue];
            
        } else {

            [self removeLoadingView];
            [self showAlert:@"Message!" message:@"Email has been sent to your inbox to change your password."];
        }
    }];
}

-(void)showLoadingView:(NSString *)message{
    loadingView =[LoadingView loadingViewInView:self.view  text:message];
}

-(void)removeLoadingView{
    for (UIView *subview in self.view.subviews) {
        if([subview isKindOfClass:[LoadingView class]]){
            [subview removeFromSuperview];
        }
    }
}

-(BOOL)validate{
    
    // Check empty fields
    if(!email || [email.text isEqualToString:@""] ||
       !password || [password.text isEqualToString:@""]){
        
        [self showAlert:@"Warning!" message:@"Please fill all the fields"];
        [self removeLoadingView];
        return NO;
    }
    return YES;
}

-(IBAction)onSignIn{
    
    /*FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    appDelegate.loginId = [AccountController getPathFromEmail:@"riz_ahmed_86@yahoo.com"];
    
    if(IS_IPHONE_5){
        launchController = [[LauchViewController alloc]initWithNibName:@"LauchViewControllerIPhone5" bundle:nil];
    }   else{
        launchController = [[LauchViewController alloc]initWithNibName:@"LauchViewController" bundle:nil];
    }    
    [self performSelectorOnMainThread:@selector(pushViewController:) withObject:launchController waitUntilDone:YES];*/
    
    globle.twitterUser = nil;
    [self showLoadingView:@"Signing In..."];
    
    if([self validate]){
        [self signIn:YES username:email.text password:password.text];
    }
}

-(IBAction)goBack{
    
	[self.navigationController popViewControllerAnimated:NO];
}

-(void)signIn:(BOOL)validated username:(NSString *)userName password:(NSString *)pwd{
    NSError *loginError = nil;
    NSString *s;
    NSLog(@"email.text %@",userName);
    NSLog(@"password %@",pwd);

    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:userName];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        
        dbUsername = [object objectForKey:@"username"];
        
        if(!dbUsername){
           [self removeLoadingView];
            registerController = [[RegisterController alloc]initWithNibName:@"RegisterController" bundle:nil];
            [self.navigationController pushViewController:registerController animated:YES];

        }}];
    
    [PFUser logInWithUsername:userName password:pwd error:&loginError];
   // NSString *errorValue = [loginError.userInfo objectForKey:@"error"];

    if(loginError){
            [self removeLoadingView];
            [self showAlert:@"Flyerly Warning!" message:@"Username or Password is incorrect"];
        
    }else{
        
        NSLog(@"Email: %@", userName);
        NSLog(@"Path: %@", [AccountController getPathFromEmail:userName]);
        FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
        appDelegate.loginId = [AccountController getPathFromEmail:userName];
        usr = [[NSUserDefaults standardUserDefaults] stringForKey:@"User"];
         if (usr == nil) {
            [[NSUserDefaults standardUserDefaults]  setObject:userName forKey:@"User"];
            [[NSUserDefaults standardUserDefaults]  setObject:pwd forKey:@"Password"];
         }

        if(IS_IPHONE_5){
            launchController = [[LauchViewController alloc]initWithNibName:@"LauchViewControllerIPhone5" bundle:nil];
        }   else{
            launchController = [[LauchViewController alloc]initWithNibName:@"LauchViewController" bundle:nil];
        }
        
        //[self.navigationController pushViewController:launchController animated:YES];
        [self performSelectorOnMainThread:@selector(pushViewController:) withObject:launchController waitUntilDone:YES];
    }
    
}

-(void)pushViewController:(UIViewController*)theViewController{
    [self.navigationController pushViewController:theViewController animated:YES];
}

-(IBAction)onSignInFacebook{

    [self showLoadingView:@"Signing In..."];

    if([AddFriendsController connected]){
        
        FlyrAppDelegate *appDelegate = (FlyrAppDelegate *) [[UIApplication sharedApplication]delegate];
        appDelegate.facebook.sessionDelegate = self;
        
        if(!appDelegate.facebook) {
            
            //get facebook app id
            NSString *path = [[NSBundle mainBundle] pathForResource: @"Flyr-Info" ofType: @"plist"];
            NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
            appDelegate.facebook = [[Facebook alloc] initWithAppId:[dict objectForKey: @"FacebookAppID"] andDelegate:self];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSLog(@"%@",[defaults objectForKey:@"FBAccessTokenKey"]);
            NSLog(@"%@",[defaults objectForKey:@"FBExpirationDateKey"]);

            if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
                appDelegate.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
                appDelegate.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
            }
        }
        
        if([appDelegate.facebook isSessionValid]) {
            
            [appDelegate.facebook requestWithGraphPath:@"me" andDelegate:self];
            
        } else {
           // [appDelegate.facebook  requestWithGraphPath:@"me" andDelegate:self ];
            [appDelegate.facebook  authorize:[NSArray arrayWithObjects: @"read_stream",
                                             @"publish_stream", @"email", nil]];
        }
    }else{
        [self showAlert:@"Warning!" message:@"You're not connected to the internet. Please connect and retry."];
        [self removeLoadingView];
    }
}

-(IBAction)onSignInTwitter{
    if([AddFriendsController connected]){
        act.hidden = NO;
        waiting.hidden = NO;
        if([TWTweetComposeViewController canSendTweet]){
            
            ACAccountStore *account = [[ACAccountStore alloc] init];
            ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
            
            // Request access from the user to access their Twitter account
            [account requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
                // Did user allow us access?
                if (granted == YES) {
                    
                    // Populate array with all available Twitter accounts
                    NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
                    // Sanity check
                    if ([arrayOfAccounts count] > 1) {
                        if([TWTweetComposeViewController canSendTweet]) {
                            [self getTwitterAccounts:self];
                        } else {
                            
                            [self setAlertForSettingPage:self];
                            
                            
                        }

                    }else if ([arrayOfAccounts count] > 0) {
                        [self showLoadingView:@"Signing In..."];
                        // Keep it simple, use the first account available
                        ACAccount *acct = [arrayOfAccounts objectAtIndex:0];
                        
                        //Convert twitter username to email
                        NSString *twitterEmail = [AccountController getPathFromEmail:[acct username]];
                        globle.twitterUser = twitterEmail;
                        // sign in
                        [self signIn:YES username:twitterEmail password:@"null"];
                        act.hidden = YES;
                        waiting.hidden = YES;
                        
                    }
                }
                
            }];
            
        } else {
            [self showAlert:@"No Twitter connection" message:@"You must be connected to Twitter to continue."];
            [self removeLoadingView];
        }
        
        
    }else{
        [self showAlert:@"Warning!" message:@"You're not connected to the internet. Please connect and retry."];
        [self removeLoadingView];
    }

}

-(void)request:(FBRequest *)request didLoad:(id)result{
    
    NSLog(@"Data: %@", result);
    
    if(result){
        
        if ([result isKindOfClass:[NSDictionary class]])
        {
            NSString *emailParam = [result objectForKey: @"email"];
            [self signIn:YES username:emailParam password:@"null"];
        }
    }
}

-(IBAction)onSignUp{
    registerController = [[RegisterController alloc]initWithNibName:@"RegisterController" bundle:nil];
    [self.navigationController pushViewController:registerController animated:YES];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if([string isEqualToString:@"\n"]){
        if([textField canResignFirstResponder])
        {
            [textField resignFirstResponder];
        }
        return NO;
    }
    
    return YES;
}

- (void)fbDidLogin {
	NSLog(@"logged in");
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    
    //save to session
    NSLog(@"%@",appDelegate.facebook.accessToken);
    NSLog(@"%@",appDelegate.facebook.expirationDate);
    
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.facebook.accessToken forKey:@"FBAccessTokenKey"];
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.facebook.expirationDate forKey:@"FBExpirationDateKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //[self onSignUpFacebook];
    [appDelegate.facebook requestWithGraphPath:@"me" andDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
	[emailImage release];
    [passwordImage release];
    
    [email release];
    [password release];
    
    [signIn release];
    [signUp release];
    [signInFacebook release];
    [signInTwitter release];
    
    [forgetPassword1 release];
    
    [launchController release];
    [registerController release];
    [loadingView release];

    [super dealloc];
}

#pragma Twitter
//this function will check that specified user account exist in settings/twitter accounts of iOS device
-(BOOL)twitterAccountExist:(NSString *)userId {
    
    // Create an account store object.
	ACAccountStore *accountStore = [[ACAccountStore alloc] init];
	
	// Create an account type that ensures Twitter accounts are retrieved.
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
	
    __block BOOL accountExist = NO;
    
    if([TWTweetComposeViewController canSendTweet]) {
        
        
        // Request access from the user to use their Twitter accounts.
        [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
            if(granted) {
                // Get the list of Twitter accounts.
                NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
                
                // For the sake of brevity, we'll assume there is only one Twitter account present.
                // You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present.
                if ([accountsArray count] > 0) {
                    // Grab the initial Twitter account to tweet from.
                    
                    for(int i = 0; i < accountsArray.count; i++) {
                        
                        ACAccount *twitterAccount = [accountsArray objectAtIndex:i];
                        NSString *userID = [[twitterAccount valueForKey:@"properties"] valueForKey:@"user_id"];
                        
                        if([userID isEqualToString:userId]) {
                            accountExist = YES;
                        }
                    }
                    
                    
                    
                }
            }
        }];
    }
    
    
    
    return accountExist;
    
    
}


//This function will return all twitter accounts avaliable on iOS Device
-(void)getTwitterAccounts:(id)delegate {
    
    // Create an account store object.
	ACAccountStore *accountStore = [[ACAccountStore alloc] init];
	
	// Create an account type that ensures Twitter accounts are retrieved.
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
	
    if([TWTweetComposeViewController canSendTweet]) {
        
        
        // Request access from the user to use their Twitter accounts.
        [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
            if(granted) {
                // Get the list of Twitter accounts.
                NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
                
                if(delegate != nil) {
                    [delegate performSelector:@selector(displayUserList:) withObject:accountsArray];
                }
                
                
            }
        }];
    }
    
    
    
}



-(void)setAlertForSettingPage :(id)delegate
{
    // Set up the built-in twitter composition view controller.
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    
    
    // Create the completion handler block.
    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
        [delegate dismissModalViewControllerAnimated:YES];
    }];
    
    // Present the tweet composition view controller modally.
    [delegate presentModalViewController:tweetViewController animated:YES];
    //tweetViewController.view.hidden = YES;
    for (UIView *view in tweetViewController.view.subviews){
        [view removeFromSuperview];
    }
    
}


-(void)displayUserList:(NSArray *)accounts {
    
    //hide loading
    waiting.hidden = YES;
    act.hidden = YES;

    
    
    NSMutableArray *tAccounts = [[NSMutableArray alloc] init];
    
    //create username array
    NSMutableArray *accountArray = [[NSMutableArray alloc] init];
    for(int i = 0 ; i < accounts.count ; i++) {
        ACAccount *account = [accounts objectAtIndex:i];
        [accountArray addObject:account.username];
        
        [tAccounts addObject:account];
        
        for(id key in [account valueForKey:@"properties"] ) {
            
            NSLog(@"%@",key);
            
        }
        
        
    }
    
    //set main variable
    twitterAccounts = tAccounts;
    
    
    //loop through each account and show them on UIAction sheet for selection
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Account" delegate:self  cancelButtonTitle:nil
                                               destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (int i = 0; i < accountArray.count; i++) {
        [actionSheet addButtonWithTitle:[accountArray objectAtIndex:i]];
    }
    
    [actionSheet addButtonWithTitle:@"Cancel"];
    actionSheet.cancelButtonIndex = accountArray.count;
    
    
    [actionSheet showInView:self.view];
    
}



/**
 * clickedButtonAtIndex (UIActionSheet)
 *
 * Handle the button clicks from mode of getting out selection.
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //if not cancel button presses
    if(buttonIndex != twitterAccounts.count) {
        
        //save to NSUserDefault
        ACAccount *account = [twitterAccounts objectAtIndex:buttonIndex];
        
        //Convert twitter username to email
        NSString *twitterUser = [AccountController getPathFromEmail:[account username]];
        [self signIn:YES username:twitterUser password:@"null"];
    }
    
    NSLog(@"%u",buttonIndex);
    
    
}


@end