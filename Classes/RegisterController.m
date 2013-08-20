//
//  RegisterController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 7/4/13.
//
//

#import "RegisterController.h"
#import <Parse/PFQuery.h>
#import "PhotoController.h"
#import "Common.h"
#import "AddFriendsController.h"
#import "FlyrAppDelegate.h"
#import "LoadingView.h"
#import "AccountController.h"


@interface RegisterController ()

@end

@implementation RegisterController
@synthesize username,password,confirmPassword,signUp,signUpFacebook,signUpTwitter,loadingView,email,name,phno,act;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

#pragma Zohaib Method

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFieldRect =
    [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.2)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction >= 0.5)
    {
        heightFraction = 0.8;
    }
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

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
    globle = [Singleton RetrieveSingleton];
    NSLog(@"%@",globle.twitterUser);
    if (globle.twitterUser == nil) {
        username.text = @"";
    }else{
        username.text = globle.twitterUser;
        username.enabled = NO;
        password.text = @"null";
        password.enabled = NO;
        confirmPassword.text =@"null";
        signUpFacebook.hidden = YES;
        signUpTwitter.hidden = YES;
    }
    //email.text =@"Zohaib.Abbasi@gmail.com";
    //name.text =@"Zohaib Aziz Abbasi";
    //phno.text =@"03452139691";

	// Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg_without_logo2"] forBarMetrics:UIBarMetricsDefault];

    //set title
    //self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Register" rect:CGRectMake(-50, -6, 50, 50)];
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(-50, -6, 50, 50)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0 ];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"REGISTER";
    self.navigationItem.titleView = label;

    // remove borders
    username.borderStyle = UITextBorderStyleNone;
    password.borderStyle = UITextBorderStyleNone;
    confirmPassword.borderStyle = UITextBorderStyleNone;
    
    // add clear text option
    username.clearButtonMode = UITextFieldViewModeWhileEditing;
    password.clearButtonMode = UITextFieldViewModeWhileEditing;
    confirmPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    if(IS_IPHONE_5){
        [signUpFacebook setFrame:CGRectMake(34, 360, 253, 40)];
        [signUpTwitter setFrame:CGRectMake(34, 395, 253, 40)];
        [act setFrame:CGRectMake(227, 400, 20, 20)];
    }

    // Setup welcome button
    UIButton *welcomeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 29, 25)];
   // [welcomeButton setTitle:@" Welcome" forState:UIControlStateNormal];
    welcomeButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [welcomeButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [welcomeButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:welcomeButton];
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:leftBarButton,nil]];

    
    UIButton *signUpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 29, 29)];
    // [welcomeButton setTitle:@" Welcome" forState:UIControlStateNormal];
    [signUpButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [signUpButton setBackgroundImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:signUpButton];
    [self.navigationItem setRightBarButtonItem:rightBarButton];

/*
    // Navigation bar sign in button
    UIBarButtonItem *doneTopRightButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign up" style:UIBarButtonItemStylePlain target:self action:@selector(onSignUp)];
    
    [doneTopRightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:BUTTON_FONT size:13.0], UITextAttributeFont,nil] forState:UIControlStateNormal];
    
    [doneTopRightButton setTintColor:[UIColor colorWithRed:104.0/255.0 green:173.0/255.0 blue:57.0/255.0 alpha:1]];
    self.navigationItem.rightBarButtonItem = doneTopRightButton;
    [doneTopRightButton release];
*/
}

-(IBAction)goBack{
    
	[self.navigationController popViewControllerAnimated:NO];
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

-(void)onSignUp{
    
    [self showLoadingView:@"Registering..."];
    
    if([self validate]){
        [self signUp:YES username:username.text password:password.text];
    }
}

-(void)signUp:(BOOL)validationDone username:(NSString *)userName password:(NSString *)pwd{
    // Check username already exists
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:userName];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        
        NSString *dbUsername = [object objectForKey:@"username"];
        
        if(dbUsername){
            username.text = userName;
            password.text = pwd;
           // change by Preston [self showAlert:@"Warning!" message:@"User already exists"];
            warningAlert = [[UIAlertView  alloc]initWithTitle:@"Flyerly Account Already Exists" message:@"Please sign in using existing credentials" delegate:self cancelButtonTitle:@"Sign In" otherButtonTitles:@"Cancel",nil];
            [warningAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
            //[warningAlert show];
            [warningAlert autorelease];
            
            [self removeLoadingView];

        } else {
            
            //[self showAlert:@"Warning!" message:@"Create this user"];
            [self createUser:userName password:pwd];
        }
        
    }];
}

-(IBAction)onSignUpFacebook{
    
    [self showLoadingView:@"Registering..."];
    
    if([AddFriendsController connected]){

        FlyrAppDelegate *appDelegate = (FlyrAppDelegate *) [[UIApplication sharedApplication]delegate];
        appDelegate.facebook.sessionDelegate = self;
        
        if(!appDelegate.facebook) {
            
            //get facebook app id
            NSString *path = [[NSBundle mainBundle] pathForResource: @"Flyr-Info" ofType: @"plist"];
            NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
            appDelegate.facebook = [[Facebook alloc] initWithAppId:[dict objectForKey: @"FacebookAppID"] andDelegate:self];
        }
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
            appDelegate.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
            appDelegate.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        }

        if([appDelegate.facebook isSessionValid]) {
            
            [appDelegate.facebook requestWithGraphPath:@"me" andDelegate:self];

        } else {
            
            [appDelegate.facebook authorize:[NSArray arrayWithObjects: @"read_stream",
                                             @"publish_stream", @"email", nil]];
        }
    }else{
        [self showAlert:@"Warning!" message:@"You're not connected to the internet. Please connect and retry."];
        [self removeLoadingView];
    }
}

-(void)onSignUpFacebook:(BOOL)overloaded result:(id)result{
    if ([result isKindOfClass:[NSDictionary class]])
    {
        NSString *email = [result objectForKey: @"email"];
        [self signUp:YES username:email password:@"null"];
    }
}

-(BOOL)CheckUserExists :(NSString *)userName password:(NSString *)pwd{
    NSError *loginError = nil;

    [PFUser logInWithUsername:userName password:pwd error:&loginError];
    if(loginError){
        return NO;
    }else{
        return YES;
    }
}

#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(alertView == warningAlert && buttonIndex == 0) {
        globle.twitterUser = nil;
        [[NSUserDefaults standardUserDefaults]  setObject:username.text forKey:@"User"];
        [[NSUserDefaults standardUserDefaults]  setObject:password.text forKey:@"Password"];
        
        if(IS_IPHONE_5){
            launchController = [[LauchViewController alloc]initWithNibName:@"LauchViewControllerIPhone5" bundle:nil];
        }   else{
            launchController = [[LauchViewController alloc]initWithNibName:@"LauchViewController" bundle:nil];
        }
        
        [self.navigationController pushViewController:launchController animated:YES];
        //[self performSelectorOnMainThread:@selector(pushViewController:) withObject:launchController waitUntilDone:YES];

    }
    [self.view release];
    act.hidden = YES;
    waiting.hidden = YES;
}


-(IBAction)onSignUpTwitter{
    
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
                        // Keep it simple, use the first account available
                        ACAccount *acct = [arrayOfAccounts objectAtIndex:0];
                        
                        //Convert twitter username to email
                        NSString *twitterUser = [AccountController getPathFromEmail:[acct username]];
                        username.text = twitterUser;
                        password.text = @"null";
                        confirmPassword.text = @"null";
                    
                        if([self CheckUserExists:twitterUser password:@"null"])
                        {

                        warningAlert = [[UIAlertView  alloc]initWithTitle:@"Flyerly Account Already Exists" message:@"Please sign in using existing credentials" delegate:self cancelButtonTitle:@"Sign In" otherButtonTitles:@"Cancel",nil];
                            [warningAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
                            //[warningAlert show];
                            [warningAlert autorelease];
                            
                        }

                        // sign in
                       // [self signIn:YES username:twitterEmail password:@"null"];
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
        [self onSignUpFacebook:YES result:result];
    }
}

-(BOOL)validate{

    // Check empty fields
    if(!username || [username.text isEqualToString:@""]){
        
        [self showAlert:@"Warning!" message:@"Please fill all Account fields"];
        [self removeLoadingView];
        return NO;
    }

    if ([globle.twitterUser isEqualToString:nil]) {

        if(!password || [password.text isEqualToString:@""] ||
       !confirmPassword || [confirmPassword.text isEqualToString:@""]){
        
        [self showAlert:@"Warning!" message:@"Please fill all Account fields"];
        [self removeLoadingView];
        return NO;
        }

    
    // Check password matched
        if(![password.text isEqualToString:confirmPassword.text]){
        
        [self showAlert:@"Warning!" message:@"Password not matched"];
        [self removeLoadingView];
        return NO;
        }
    }
    
    if([email.text length] == 0 ){
        [self showAlert:@"Warning!" message:@"Email Address Must Required"];
        [self removeLoadingView];
        return NO;
    }
    return YES;
}

-(void)createUser:(NSString *)userName password:(NSString *)pwd{
    
    // username and password
    PFUser *user = [PFUser user];
    user.username = userName;
    user.password = pwd;
    user.email = email.text;
    [user setObject:name.text forKey:@"name"];
    [user setObject:phno.text forKey:@"contact"];

    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            
            NSString *errorValue = [error.userInfo objectForKey:@"error"];
            [self showAlert:@"Warning!" message:errorValue];
            [self removeLoadingView];

        } else {
            [PFUser logInWithUsername:userName password:pwd];
            
            NSLog(@"Email: %@", userName);
            NSLog(@"Path: %@", [AccountController getPathFromEmail:userName]);
            FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
            appDelegate.loginId = [AccountController  getPathFromEmail:userName];

            if(IS_IPHONE_5){
                launchController = [[LauchViewController alloc]initWithNibName:@"LauchViewControllerIPhone5" bundle:nil];
            }   else{
                launchController = [[LauchViewController alloc]initWithNibName:@"LauchViewController" bundle:nil];
            }
            
            [self.navigationController pushViewController:launchController animated:YES];
        }
    }];
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

- (void)dealloc {
    
	[username release];
    [password release];    
    [confirmPassword release];
    
    [signUp release];    
    [signUpFacebook release];
    [signUpTwitter release];
    
    [launchController release];
    [loadingView release];
    
    [super dealloc];
}

#pragma Zohaib Changes
-(IBAction)signInWithTwitter:(id)sender {
    
    if([TWTweetComposeViewController canSendTweet]) {
        waiting.hidden = NO;
        //[Twitter getTwitterAccounts:self];
    } else {
        
       // [Twitter setAlertForSettingPage:self];
        
        
    }
    
    
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
        username.text = twitterUser;
        password.text = @"null";
        confirmPassword.text = @"null";
        
        if([self CheckUserExists:twitterUser password:@"null"])
        {
            warningAlert = [[UIAlertView  alloc]initWithTitle:@"Flyerly Account Already Exists" message:@"Please sign in using existing credentials" delegate:self cancelButtonTitle:@"Sign In" otherButtonTitles:@"Cancel",nil];
            [warningAlert show];
            
        }

       // [self signIn:YES username:twitterUser password:@"null"];
    }
    NSLog(@"%u",buttonIndex);
    act.hidden = YES;
    waiting.hidden = YES;
    
}


@end
