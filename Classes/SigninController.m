//
//  SigninController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 7/4/13.
//
//

#import "SigninController.h"
#import <Parse/Parse.h>
#import <Parse/PFFacebookUtils.h>
#import <Parse/PFTwitterUtils.h>

@interface SigninController (){
    UIBarButtonItem *leftBarButton, *righBarButton;
}

@end

@implementation SigninController
@synthesize email,password,signIn,signUp,signInFacebook,signInTwitter,emailImage,passwordImage,forgetPassword1;
@synthesize launchController;
@synthesize signInCompletion;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    // Adding notifications to move UIView up when keyboard get opened
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    
    globle = [FlyerlySingleton RetrieveSingleton];
    
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:@"Forgot Password?"];
    
    // making text property to underline text-
    [titleString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, [titleString length])];
    
    // using text on button
    [forgetPassword1 setAttributedTitle: titleString forState:UIControlStateNormal];
    forgetPassword1.titleLabel.textColor = [UIColor grayColor];
    
    self.navigationController.navigationBarHidden = NO;

    //set title
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];
    label.text = @"SIGN IN";
    
    self.navigationItem.titleView = label;
    
    // remove borders
    email.borderStyle = UITextBorderStyleNone;
    password.borderStyle = UITextBorderStyleNone;
    
    // set clear text overlay
    email.clearButtonMode = UITextFieldViewModeWhileEditing;
    password.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    // back button
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
     backBtn.showsTouchWhenHighlighted = YES;
    leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:leftBarButton,nil]];

    // Done button
    UIButton *DoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    DoneBtn.showsTouchWhenHighlighted = YES;
    [DoneBtn addTarget:self action:@selector(onSignIn) forControlEvents:UIControlEventTouchUpInside];
    [DoneBtn setBackgroundImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
    righBarButton = [[UIBarButtonItem alloc] initWithCustomView:DoneBtn];
    [self.navigationItem setRightBarButtonItem:righBarButton];
}

-(IBAction)forgetPassword{
    ResetPWViewController *passWordContrller = [[ResetPWViewController alloc]initWithNibName:@"ResetPWViewController" bundle:nil];
    [self.navigationController pushViewController:passWordContrller animated:YES ];
}

// Show Hide loader
-(void)showLoader:(BOOL)show {
    if(show) {
        [self showLoadingIndicator];
        [self enableLinks:NO];
    } else {
        [self hideLoadingIndicator];
        [self enableLinks:YES];
    }
}

// Enable link on screen
-(void)enableLinks:(BOOL)enable {
    
    righBarButton.enabled = enable;
    leftBarButton.enabled = enable;

    email.enabled = enable;
    password.enabled = enable;

    signIn.enabled = enable;
    signUp.enabled = enable;

    signInFacebook.enabled = enable;
    signInTwitter.enabled = enable;
    forgetPassword1.enabled = enable;
}


-(BOOL)validate{
    
    // Check empty fields
    if(!email || [email.text isEqualToString:@""] ||
       !password || [password.text isEqualToString:@""]){
        
        [self showAlert:@"Think you forgot something..." message:@""];
        [self showLoader:NO];
        return NO;
    }
    return YES;
}

-(IBAction)onSignIn{

    if ([FlyerlySingleton connected]) {
        globle.twitterUser = nil;
        [self showLoader:YES];
        
        //Validation
        if([self validate]){
            [self signIn:YES username:email.text password:password.text];
        }
    }else {
        [self showAlert:@"You're not connected to the internet. Please connect and retry." message:@""];
    }
}

-(IBAction)goBack{
    
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)signIn:(BOOL)validated username:(NSString *)userName password:(NSString *)pwd{

    NSError *loginError = nil;
    userName = [userName lowercaseString];
    
    [PFUser logInWithUsername:[userName lowercaseString] password:pwd error:&loginError];
   
    if(loginError){
        warningAlert = [[UIAlertView  alloc]initWithTitle:@"Invalid username or password" message:@"" delegate:self cancelButtonTitle:@"Register" otherButtonTitles:@"Try Again",nil];
        [warningAlert show];
        
    }else{
        
        //Saving User Info for again login
        [[NSUserDefaults standardUserDefaults]  setObject:userName forKey:@"User"];
        [[NSUserDefaults standardUserDefaults]  setBool:YES forKey:@"FlyerlyUser"];
        
        //Update Folder Structure For 3.0 Version
        PFUser *user = [PFUser currentUser];
        [FlyerUser updateFolderStructure:[user objectForKey:@"username"]];
        
        // We keep an instance of navigation contrller since the completion block might pop us out of the
        // navigation controller
        UINavigationController *navigationController = self.navigationController;
        
        [self onSignInSuccess];
        
        if (launchController == nil)
        {
            launchController = [[FlyerlyMainScreen alloc]initWithNibName:@"FlyerlyMainScreen" bundle:nil];
            [navigationController pushViewController: launchController animated:YES];
        }
        
    }
    
}

-(void)pushViewController:(UIViewController*)theViewController{
    [self.navigationController pushViewController:theViewController animated:YES];
}


-(IBAction)onSignInFacebook{    
    
    //Internet Connectivity Check
    if([FlyerlySingleton connected]){
        
        [self showLoader:YES];
        
        // The permissions requested from the user
        NSArray *permissionsArray = @[ @"email", @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];

        // Login PFUser using Facebook
        [PFFacebookUtils logInInBackgroundWithReadPermissions: permissionsArray block:^(PFUser *user, NSError *error) {
            
            [self showLoader:NO]; // Hide loading indicator
            
            NSLog(@"email=%@ - Email=%@ - name=%@ - contact=%@", user.email, user[@"email"], user[@"name"], user[@"contact"]);
            
            if ( !user ) {

                //User denied to access fb account of Device
                if ( !error ) {
                    NSLog(@"Uh oh. The user cancelled the Facebook login.");
                } else {
                    NSLog(@"Uh oh. An error occurred: %@", error);
                    NSDictionary *errorDict = [[NSDictionary alloc] initWithDictionary:error.userInfo];
                    NSString *error = [errorDict objectForKey:@"NSLocalizedFailureReason"];
                    if ( [error isEqualToString:@"com.facebook.sdk:SystemLoginDisallowedWithoutError"] ) {
                        // handle error here, for example by showing an alert to the user
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not login with Facebook"
                                                                        message:@"Facebook login failed. Please check your Facebook settings on your phone."
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        
                        [alert show];
                    }
                }
                
            } else{

                //Saving User Info for again login
                [[NSUserDefaults standardUserDefaults]  setObject:[user.username lowercaseString] forKey:@"User"];

                if (user.isNew) {

                    NSLog(@"User with facebook signed up and logged in!");

                    [self onSignInSuccess];
                    
                    // Login success Move to Flyerly
                     launchController = [[FlyerlyMainScreen alloc]initWithNibName:@"FlyerlyMainScreen" bundle:nil] ;
                    
                    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
                    appDelegate.lauchController = launchController;
                    
                    // For Parse New User Merge to old Facebook User

                    [appDelegate fbChangeforNewVersion];
                    
                    [self performSelectorOnMainThread:@selector(pushViewController:) withObject: launchController waitUntilDone:YES];

                    
                } else {
                    NSLog(@"User with facebook logged in!");
                    
                    [self onSignInSuccess];
                    
                    // Login success Move to Flyerly
                    launchController = [[FlyerlyMainScreen alloc]initWithNibName:@"FlyerlyMainScreen" bundle:nil] ;
                    
                    // Temp on for Testing here
                    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
                    
                    appDelegate.lauchController = launchController;
                    [appDelegate fbChangeforNewVersion];

                    if (launchController == nil) {
                        launchController = [[FlyerlyMainScreen alloc]initWithNibName:@"FlyerlyMainScreen" bundle:nil];
                    }

                }
            }
        }];
    }else {
        [self showAlert:@"You're not connected to the internet. Please connect and retry." message:@""];
    
    }
        
}

//-(IBAction)onSignInTwitter{
//	
//    
//    if([FlyerlySingleton connected]){
//        
//        [self showLoader:YES];
//        
//        [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
//
//            [self showLoader:NO];
//            BOOL canSave = NO;
//
//            if ( !user ) {
//                //User denied to access fb account of Device
//                NSLog(@"Uh oh. The user cancelled the Twitter login.");
//                return;
//            } else {
//
//                NSString *twitterUsername = @"teamleadsqa"; //[PFTwitterUtils twitter].screenName;
//
//                if(![twitterUsername isEqualToString:@""]) {
//                    if(user.isNew || (user.username == nil || [user.username isEqualToString:@""]) ){
//                        canSave = YES;
//                        user.username = twitterUsername;
//                        [[PFUser currentUser] setObject:twitterUsername forKey:@"username"];
//                    }
//                    
//                    if(user.isNew || (user[@"name"] == nil || [user[@"name"] isEqualToString:@""]) ){
//                        canSave = YES;
//                        user[@"name"] = twitterUsername;
//                        [[PFUser currentUser] setObject:twitterUsername forKey:@"name"];
//                    }
//                }
//
//                if (user.isNew) {
//
//                    canSave = YES;
//                    [[PFUser currentUser] setObject:APP_NAME forKey:@"appName"];
//
//                    // We keep an instance of navigation contrller since the completion block might pop us out of the navigation controller
//                    UINavigationController *navigationController = self.navigationController;
//
//                    [self onSignInSuccess];
//
//                    //Saving User Info for again login
//                    [[NSUserDefaults standardUserDefaults]  setObject:[twitterUsername lowercaseString] forKey:@"User"];
//
//                    // Login success Move to Flyerly
//                    launchController = [[FlyerlyMainScreen alloc]initWithNibName:@"FlyerlyMainScreen" bundle:nil] ;
//
//                    // For Parse New User Merge to old Twitter User
//                    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
//                    appDelegate.lauchController = launchController;
//                    [appDelegate twitterChangeforNewVersion:twitterUsername];
//
//                    if ( launchController == nil) {
//                        launchController = [[FlyerlyMainScreen alloc]initWithNibName:@"FlyerlyMainScreen" bundle:nil];
//                        [navigationController pushViewController:launchController animated:YES];
//                    }
//                }
//                else {
//
//                    // We keep an instance of navigation contrller since the completion block might pop us out of the
//                    // navigation controller
//                    UINavigationController *navigationController = self.navigationController;
//
//                    [self onSignInSuccess];
//
//                    //Saving User Info for again login
//                    [[NSUserDefaults standardUserDefaults]  setObject:[twitterUsername lowercaseString] forKey:@"User"];
//
//                    // Login success Move to Flyerly
//
//                    if ( launchController == nil) {
//                        launchController = [[FlyerlyMainScreen alloc]initWithNibName:@"FlyerlyMainScreen" bundle:nil];
//                        [navigationController pushViewController:launchController animated:YES];
//                    }
//                }
//
//                if(canSave) {
//                    [[PFUser currentUser] saveInBackground];
//                }
//            }
//        }];
//    }else{
//        [self showAlert:@"You're not connected to the internet. Please connect and retry." message:@""];
//    }
//
//}



-(IBAction)onSignUp{
    
    if (IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS || IS_IPHONE_XR || IS_IPHONE_XS) {
        registerController = [[RegisterController alloc]initWithNibName:@"RegisterViewController_iPhone5" bundle:nil];
    }else{
        registerController = [[RegisterController alloc]initWithNibName:@"RegisterController" bundle:nil];
    }
    
    registerController.signInController = self;
    
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// return the Sign In succes status
- (void) onSignInSuccess {
    
    [FlyerUser mergeAnonymousUser];
    
    // Update parse when Anonymous user logs in
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"UserType"] isEqualToString: ANONYMOUS]) {
        InAppViewController *controller = [[InAppViewController alloc] init];
        [controller updateParse];
        [[NSUserDefaults standardUserDefaults]setValue: REGISTERED forKey: @"UserType"];
    }
    
    UserPurchases *userPurchases_ = [UserPurchases getInstance];
    userPurchases_.delegate = launchController;
    [userPurchases_ setUserPurcahsesFromParse];

    if (signInCompletion)
    {
        signInCompletion();
    }
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -120.0f;
        self.view.frame = f;
    }];
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = 0.0f;
        self.view.frame = f;
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
    if(alertView == warningAlert && buttonIndex == 0) {
        
        if (IS_IPHONE_5 || IS_IPHONE_6_PLUS || IS_IPHONE_6 || IS_IPHONE_XR || IS_IPHONE_XS) {
            registerController = [[RegisterController alloc]initWithNibName:@"RegisterViewController_iPhone5" bundle:nil];
        }else{
            registerController = [[RegisterController alloc]initWithNibName:@"RegisterController" bundle:nil];
        }
        
        registerController.signInController = self;
        
        [self.navigationController pushViewController:registerController animated:YES];
        
    }
    [self showLoader:NO];
}

@end
