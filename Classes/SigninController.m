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
@synthesize email,password,signIn,signUp,signInFacebook,signInTwitter,emailImage,passwordImage,loadingView,forgetPassword1;

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
    
    self.navigationController.navigationBarHidden = NO;

    //set title	
    self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Sign In" rect:CGRectMake(-35, -6, 50, 50)];

    // remove borders
    email.borderStyle = UITextBorderStyleNone;
    password.borderStyle = UITextBorderStyleNone;
    
    // set clear text overlay
    email.clearButtonMode = UITextFieldViewModeWhileEditing;
    password.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //email.text= @"riz_ahmed_86@yahoo.com";
    //password.text = @"logs";
    
    // Setup welcome button
    UIButton *welcomeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 76, 32)];
    [welcomeButton setTitle:@" Welcome" forState:UIControlStateNormal];
    welcomeButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [welcomeButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [welcomeButton setBackgroundImage:[UIImage imageNamed:@"welcome_button"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:welcomeButton];
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:leftBarButton,nil]];
    
    // Navigation bar sign in button
    UIBarButtonItem *signInTopRightButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign In" style:UIBarButtonItemStylePlain target:self action:@selector(onSignIn)];
    
    //[signInTopRightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"Helvetica-Bold" size:11.0], UITextAttributeFont,nil] forState:UIControlStateNormal];
    
    [signInTopRightButton setTintColor:[UIColor colorWithRed:104.0/255.0 green:173.0/255.0 blue:57.0/255.0 alpha:1]];
    self.navigationItem.rightBarButtonItem = signInTopRightButton;
    [signInTopRightButton release];
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
    NSLog(@"email.text %@",userName);
    NSLog(@"password %@",pwd);
    [PFUser logInWithUsername:userName password:pwd error:&loginError];
    
    if(loginError){
        NSString *errorValue = [loginError.userInfo objectForKey:@"error"];
        [self removeLoadingView];
        [self showAlert:@"Warning!" message:errorValue];
    }else{
        
        NSLog(@"Email: %@", userName);
        NSLog(@"Path: %@", [AccountController getPathFromEmail:userName]);
        FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
        appDelegate.loginId = [AccountController getPathFromEmail:userName];

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
            if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
                appDelegate.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
                appDelegate.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
            }
        }
        
        if([appDelegate.facebook isSessionValid]) {
            
            [appDelegate.facebook requestWithGraphPath:@"me" andDelegate:self];
            
        } else {
            
            [appDelegate.facebook authorize:[NSArray arrayWithObjects: @"read_stream",
                                             @"publish_stream", @"email", nil]];
        }
    }else{
        [self showAlert:@"Warning!" message:@"You must be connected to the Internet."];
        [self removeLoadingView];
    }
}

-(IBAction)onSignInTwitter{

    [self showLoadingView:@"Signing In..."];

    if([AddFriendsController connected]){
        
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
                    if ([arrayOfAccounts count] > 0) {
                        
                        // Keep it simple, use the first account available
                        ACAccount *acct = [arrayOfAccounts objectAtIndex:0];
                        
                        //Convert twitter username to email
                        NSString *twitterEmail = [AccountController getTwitterEmailByUsername:[acct username]];
                        
                        // sign in
                        [self signIn:YES username:twitterEmail password:@"null"];
                        
                    }
                }
            }];
            
        } else {
            
            [self showAlert:@"No Twitter connection" message:@"You must be connected to Twitter to continue."];
            [self removeLoadingView];
        }
        
        
    }else{
        [self showAlert:@"Warning!" message:@"You must be connected to the Internet."];
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

@end