//
//  SigninController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 7/4/13.
//
//

#import "SigninController.h"
#import "Common.h"
#import "CreateFlyerController.h"
#import <Parse/PFQuery.h>
#import "InviteFriendsController.h"
#import "AccountController.h"

@interface SigninController ()

@end

@implementation SigninController
@synthesize email,password,signIn,signUp,signInFacebook,signInTwitter,emailImage,passwordImage,forgetPassword1;

- (void)viewDidLoad
{
    [super viewDidLoad];
    

	// Do any additional setup after loading the view.
    globle = [FlyerlySingleton RetrieveSingleton];
    
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:@"Forgot Password?"];
    // making text property to underline text-
    [titleString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, [titleString length])];
    
    // using text on button
    [forgetPassword1 setAttributedTitle: titleString forState:UIControlStateNormal];
    forgetPassword1.titleLabel.textColor = [UIColor grayColor];
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg_without_logo2"] forBarMetrics:UIBarMetricsDefault];

    //set title
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-35, -6, 50, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"SIGN IN";
    
    self.navigationItem.titleView = label;
    
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
    }
    
    // back button
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
     backBtn.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:leftBarButton,nil]];

    // Done button
    UIButton *DoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    DoneBtn.showsTouchWhenHighlighted = YES;
    [DoneBtn addTarget:self action:@selector(onSignIn) forControlEvents:UIControlEventTouchUpInside];
    [DoneBtn setBackgroundImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
    UIBarButtonItem *righBarButton = [[UIBarButtonItem alloc] initWithCustomView:DoneBtn];
    [self.navigationItem setRightBarButtonItem:righBarButton];
}

-(IBAction)forgetPassword{
    ResetPWViewController *passWordContrller = [[ResetPWViewController alloc]initWithNibName:@"ResetPWViewController" bundle:nil];
    [self.navigationController pushViewController:passWordContrller animated:YES ];
}


-(void)showLoadingView {
    [self showLoadingIndicator];
}


-(void)removeLoadingView {
    [self hideLoadingIndicator];
}


-(BOOL)validate{
    
    // Check empty fields
    if(!email || [email.text isEqualToString:@""] ||
       !password || [password.text isEqualToString:@""]){
        
        [self showAlert:@"Think you forgot something..." message:@""];
        [self removeLoadingView];
        return NO;
    }
    return YES;
}

-(IBAction)onSignIn{

    globle.twitterUser = nil;
    [self showLoadingView];
    
    if([self validate]){
        [self signIn:YES username:email.text password:password.text];
    }
}

-(IBAction)goBack{
    
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)signIn:(BOOL)validated username:(NSString *)userName password:(NSString *)pwd{
    NSLog(@"User %@",userName);
    //NSLog(@"password %@",pwd);
    NSError *loginError = nil;
    userName = [userName lowercaseString];
/*
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:userName];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        
        dbUsername = [object objectForKey:@"username"];
        
        if(!dbUsername && globle.twitterUser != nil){
            if (IS_IPHONE_5) {
                registerController = [[RegisterController alloc]initWithNibName:@"RegisterViewController_iPhone5" bundle:nil];
            }else{
                registerController = [[RegisterController alloc]initWithNibName:@"RegisterController" bundle:nil];
            }
            [self.navigationController pushViewController:registerController animated:YES];

        }}];
*/
    
    [PFUser logInWithUsername:[userName lowercaseString] password:pwd error:&loginError];
   
    if(loginError){
        warningAlert = [[UIAlertView  alloc]initWithTitle:@"Invalid username or password" message:@"" delegate:self cancelButtonTitle:@"Register" otherButtonTitles:@"Try Again",nil];
        //[warningAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
        [warningAlert show];
        
    }else{
        
       // NSLog(@"Email: %@", userName);
        //NSLog(@"Path: %@", [AccountController getPathFromEmail:userName]);

        //usr = [[NSUserDefaults standardUserDefaults] stringForKey:@"User"];
         //if (usr == nil) {
            [[NSUserDefaults standardUserDefaults]  setObject:userName forKey:@"User"];
            [[NSUserDefaults standardUserDefaults]  setObject:pwd forKey:@"Password"];
         //}


        launchController = [[LauchViewController alloc]initWithNibName:@"LauchViewController" bundle:nil];
        [self.navigationController pushViewController:launchController animated:YES];
    }
    
}

-(void)pushViewController:(UIViewController*)theViewController{
    [self.navigationController pushViewController:theViewController animated:YES];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    
    NSLog(@"%@",user);
    // here we use helper properties of FBGraphUser to dot-through to first_name and
    // id properties of the json response from the server; alternatively we could use
    // NSDictionary methods such as objectForKey to get values from the my json object
   // self.labelFirstName.text = [NSString stringWithFormat:@"Hello %@!", user.first_name];
    
    // setting the profileID property of the FBProfilePictureView instance
    // causes the control to fetch and display the profile picture for the user
   // self.profilePic.profileID = user.id;
   // self.loggedInUser = user;
}

-(IBAction)onSignInFacebook{
    

    // The permissions requested from the user
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];


    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
          [self hideLoadingIndicator]; // Hide loading indicator
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        } else if (user.isNew) {
            
            NSLog(@"User with facebook signed up and logged in!");

            // For Parse New User Merge to old Facebook User
            FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
            [appDelegate FbChangeforNewVersion];
            
             // Set Current UserName for Device configuration
            [[NSUserDefaults standardUserDefaults]  setObject:user.username forKey:@"User"];
            
            // Login success Move to Flyerly

            launchController = [[LauchViewController alloc]initWithNibName:@"LauchViewController" bundle:nil] ;
            
            [self performSelectorOnMainThread:@selector(pushViewController:) withObject:launchController waitUntilDone:YES];
        } else {
            NSLog(@"User with facebook logged in!");
            
            // Set Current UserName for Device configuration
            [[NSUserDefaults standardUserDefaults]  setObject:user.username forKey:@"User"];

            // Temp on for Testing here
            
          //  FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
            //[appDelegate FbChangeforNewVersion];
            
            // Login success Move to Flyerly
            launchController = [[LauchViewController alloc]initWithNibName:@"LauchViewController" bundle:nil] ;
            [self.navigationController pushViewController:launchController animated:YES];

        }
    }];
    [self showLoadingView];
    
    
/*
    if([AddFriendsController  connected]){
        
        FlyrAppDelegate *appDelegate = (FlyrAppDelegate *) [[UIApplication sharedApplication]delegate];
        appDelegate.facebook.sessionDelegate = self;
        
        if(!appDelegate.facebook) {
            
            //get facebook app id
            NSString *path = [[NSBundle mainBundle] pathForResource: @"Flyr-Info" ofType: @"plist"];
            NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
            appDelegate.facebook = [[Facebook alloc] initWithAppId:dict[@"FacebookAppID"] andDelegate:self];
            
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
            [appDelegate.facebook  authorize:@[@"read_stream",
                                             @"publish_stream", @"email"]];
        }
    }else{
        [self showAlert:@"You're not connected to the internet. Please connect and retry." message:@""];
        [self removeLoadingView];
    }*/
}

-(IBAction)onSignInTwitter{
    [self showLoadingIndicator];
    
    if([InviteFriendsController connected]){
        
        [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
            [self hideLoadingIndicator];
            if (!user) {
                NSLog(@"Uh oh. The user cancelled the Twitter login.");
                return;
            } else if (user.isNew) {
                NSLog(@"User signed up and logged in with Twitter!");

                NSString *twitterUsername = [PFTwitterUtils twitter].userId;
                
                // For Parse New User Merge to old Twitter User
                FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
                [appDelegate TwitterChangeforNewVersion:twitterUsername];
                
                // Set Current UserName for Device configuration
                [[NSUserDefaults standardUserDefaults]  setObject:[PFTwitterUtils twitter].screenName forKey:@"User"];
                
                // Login success Move to Flyerly
                launchController = [[LauchViewController alloc]initWithNibName:@"LauchViewController" bundle:nil] ;
                [self.navigationController pushViewController:launchController animated:YES];
                

            } else {
                
                NSLog(@"User logged in with Twitter!");
                
                // Set Current UserName for Device configuration
                [[NSUserDefaults standardUserDefaults]  setObject:[PFTwitterUtils twitter].screenName forKey:@"User"];

                // Temp on for Testing here
                // For Parse New User Merge to old Twitter User
                /*
                FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
                [appDelegate TwitterChangeforNewVersion:twitterUsername];*/

                
                // Login success Move to Flyerly
                launchController = [[LauchViewController alloc]initWithNibName:@"LauchViewController" bundle:nil] ;
                [self.navigationController pushViewController:launchController animated:YES];

                
            }     
        }];
        
        
        
        
        
        /*
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
                        [self showLoadingView];
                        // Keep it simple, use the first account available
                        ACAccount *acct = arrayOfAccounts[0];
                        
                        //Convert twitter username to email
                        NSString *twitterEmail = [AccountController getPathFromEmail:[acct username]];
                        globle.twitterUser = twitterEmail;
                        // sign in
                        [self signIn:YES username:twitterEmail password:@"null"];
                        
                    }
                }
                
            }];
            
        } else {
            [self showAlert:@"No Twitter connection" message:@"You must be connected to Twitter to continue."];
            [self removeLoadingView];
        }
        */
        
    }else{
        [self showAlert:@"You're not connected to the internet. Please connect and retry." message:@""];
        [self removeLoadingView];
    }

}

-(void)request:(FBRequest *)request didLoad:(id)result{
    
    NSLog(@"Data: %@", result);
    
    if(result){
        
        if ([result isKindOfClass:[NSDictionary class]])
        {
            NSString *emailParam = result[@"email"];
            [self signIn:YES username:emailParam password:@"null"];
        }
    }
}

-(IBAction)onSignUp{
    if (IS_IPHONE_5) {
        registerController = [[RegisterController alloc]initWithNibName:@"RegisterViewController_iPhone5" bundle:nil];
    }else{
        registerController = [[RegisterController alloc]initWithNibName:@"RegisterController" bundle:nil];
    }
        [self.navigationController pushViewController:registerController animated:YES];
}

-(void)showAlert:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
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
    /*
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    
    //save to session
    NSLog(@"%@",appDelegate.facebook.accessToken);
    NSLog(@"%@",appDelegate.facebook.expirationDate);
    
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.facebook.accessToken forKey:@"FBAccessTokenKey"];
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.facebook.expirationDate forKey:@"FBExpirationDateKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //[self onSignUpFacebook];
    [appDelegate.facebook requestWithGraphPath:@"me" andDelegate:self];*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                        
                        ACAccount *twitterAccount = accountsArray[i];
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
    
    NSMutableArray *tAccounts = [[NSMutableArray alloc] init];
    
    //create username array
    NSMutableArray *accountArray = [[NSMutableArray alloc] init];
    for(int i = 0 ; i < accounts.count ; i++) {
        ACAccount *account = accounts[i];
        [accountArray addObject:account.username];
        
        [tAccounts addObject:account];        
        
    }

    //set main variable
    twitterAccounts = tAccounts;
    
    
    //loop through each account and show them on UIAction sheet for selection
    
    //loop through each account and show them on UIAction sheet for selection
    dispatch_async(dispatch_get_main_queue(), ^{
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Choose Account" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
        
        for (int i = 0; i < accountArray.count; i++) {
            [actionSheet addButtonWithTitle:accountArray[i]];
        }
        
        [actionSheet addButtonWithTitle:@"Cancel"];
        actionSheet.cancelButtonIndex = accountArray.count;
        
        
        [actionSheet showInView:self.view];
    });
    
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
        ACAccount *account = twitterAccounts[buttonIndex];
        
        //Convert twitter username to email
        NSString *twitterUser = [AccountController getPathFromEmail:[account username]];
        [self signIn:YES username:twitterUser password:@"null"];
    }
    
   // NSLog(@"%d",buttonIndex);
       [self hideLoadingIndicator];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(alertView == warningAlert && buttonIndex == 0) {
        if (IS_IPHONE_5) {
            registerController = [[RegisterController alloc]initWithNibName:@"RegisterViewController_iPhone5" bundle:nil];
        }else{
            registerController = [[RegisterController alloc]initWithNibName:@"RegisterController" bundle:nil];
        }
        [self.navigationController pushViewController:registerController animated:YES];
        
    }
    [self hideLoadingIndicator];
}

@end