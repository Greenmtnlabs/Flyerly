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
@synthesize username,password,confirmPassword,signUp,signUpFacebook,signUpTwitter,loadingView;

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
    self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Register" rect:CGRectMake(-50, -6, 50, 50)];

    // remove borders
    username.borderStyle = UITextBorderStyleNone;
    password.borderStyle = UITextBorderStyleNone;
    confirmPassword.borderStyle = UITextBorderStyleNone;
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
        [self showAlert:@"Warning!" message:@"You must be connected to the Internet."];
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
                        
                        [self signUp:YES username:[acct username] password:@"null"];

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
    user.email = userName;
    
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

@end
