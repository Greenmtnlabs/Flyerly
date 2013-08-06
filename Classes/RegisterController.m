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
@synthesize username,password,confirmPassword,signUp,signUpFacebook,signUpTwitter,loadingView,email,name,phno;

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
    email.text =@"Zohaib.Abbasi@gmail.com";
    name.text =@"Zohaib Aziz Abbasi";
    phno.text =@"03452139691";

	// Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;

    //set title
    //self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Register" rect:CGRectMake(-50, -6, 50, 50)];
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(-50, -6, 50, 50)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
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
    
    // Setup welcome button
    UIButton *welcomeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 76, 32)];
    [welcomeButton setTitle:@" Welcome" forState:UIControlStateNormal];
    welcomeButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [welcomeButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [welcomeButton setBackgroundImage:[UIImage imageNamed:@"welcome_button"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:welcomeButton];
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:leftBarButton,nil]];

    // Navigation bar sign in button
    UIBarButtonItem *doneTopRightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(onSignUp)];
    
    [doneTopRightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:BUTTON_FONT size:13.0], UITextAttributeFont,nil] forState:UIControlStateNormal];
    
    [doneTopRightButton setTintColor:[UIColor colorWithRed:104.0/255.0 green:173.0/255.0 blue:57.0/255.0 alpha:1]];
    self.navigationItem.rightBarButtonItem = doneTopRightButton;
    [doneTopRightButton release];

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

-(IBAction)onSignUp{
    
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
            
            [self showAlert:@"Warning!" message:@"User already exists"];
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

-(IBAction)onSignUpTwitter{
    
    [self showLoadingView:@"Registering..."];
    
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
                        
                        // sign up
                        [self signUp:YES username:twitterEmail password:@"null"];

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
    if(!username || [username.text isEqualToString:@""] ||
       !password || [password.text isEqualToString:@""] ||
       !confirmPassword || [confirmPassword.text isEqualToString:@""]){
        
        [self showAlert:@"Warning!" message:@"Please fill all the fields"];
        [self removeLoadingView];
        return NO;
    }
    
    // Check password matched
    if(![password.text isEqualToString:confirmPassword.text]){
        
        [self showAlert:@"Warning!" message:@"Password not matched"];
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
            appDelegate.loginId = [AccountController getPathFromEmail:userName];

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

@end
