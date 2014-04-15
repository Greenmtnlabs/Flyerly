//
//  SigninController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 7/4/13.
//
//

#import "SigninController.h"


@interface SigninController ()

@end

@implementation SigninController
@synthesize email,password,signIn,signUp,signInFacebook,signInTwitter,emailImage,passwordImage,forgetPassword1;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    label.textAlignment = UITextAlignmentCenter;
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

    if ([FlyerlySingleton connected]) {
        globle.twitterUser = nil;
        [self showLoadingView];
        
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
    
    NSLog(@"User %@",userName);

    NSError *loginError = nil;
    userName = [userName lowercaseString];
    
    [PFUser logInWithUsername:[userName lowercaseString] password:pwd error:&loginError];
   
    if(loginError){
        warningAlert = [[UIAlertView  alloc]initWithTitle:@"Invalid username or password" message:@"" delegate:self cancelButtonTitle:@"Register" otherButtonTitles:@"Try Again",nil];
        [warningAlert show];
        
    }else{
        
        //Saving User Info for again login
        [[NSUserDefaults standardUserDefaults]  setObject:userName forKey:@"User"];
        
        //Update Folder Structure For 3.0 Version
        PFUser *user = [PFUser currentUser];
        [FlyerUser updateFolderStructure:[user objectForKey:@"username"]];
        
        UINavigationController* navigationController = self.navigationController;
        
        [navigationController popViewControllerAnimated:NO];
        
        [self onSignInSuccess];        
        
        if (self.launchController == nil) {
            self.launchController = [[FlyerlyMainScreen alloc]initWithNibName:@"FlyerlyMainScreen" bundle:nil];
            [navigationController pushViewController:self.launchController animated:YES];
        }        
        
    }
    
}

-(void)pushViewController:(UIViewController*)theViewController{
    [self.navigationController pushViewController:theViewController animated:YES];
}


-(IBAction)onSignInFacebook{
    
    
    //Internet Connectivity Check
    if([FlyerlySingleton connected]){
        
        [self showLoadingView];
        
        // The permissions requested from the user
        NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];

        // Login PFUser using Facebook
        [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
            
            [self hideLoadingIndicator]; // Hide loading indicator
            
            if ( !user ) {

                //User denied to access fb account of Device
                if ( !error ) {
                    NSLog(@"Uh oh. The user cancelled the Facebook login.");
                } else {
                    NSLog(@"Uh oh. An error occurred: %@", error);
                }
                
            } else if (user.isNew) {
                
                NSLog(@"User with facebook signed up and logged in!");
                
                [self onSignInSuccess];
                
                 // Remove Current UserName for Device configuration
                [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"User"];
                
                // Login success Move to Flyerly
                self.launchController = [[FlyerlyMainScreen alloc]initWithNibName:@"FlyerlyMainScreen" bundle:nil] ;
                
                FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
                appDelegate.lauchController = self.launchController;
                
                // For Parse New User Merge to old Facebook User
                [appDelegate fbChangeforNewVersion];

                
                [self performSelectorOnMainThread:@selector(pushViewController:) withObject:self.launchController waitUntilDone:YES];
                
            } else {
                NSLog(@"User with facebook logged in!");
                
                [self onSignInSuccess];
                
                // Remove Current UserName for Device configuration
                [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"User"];
                
                // Login success Move to Flyerly
                self.launchController = [[FlyerlyMainScreen alloc]initWithNibName:@"FlyerlyMainScreen" bundle:nil] ;
                
                // Temp on for Testing here
                FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
                appDelegate.lauchController = self.launchController;
                [appDelegate fbChangeforNewVersion];

                [self.navigationController pushViewController:self.launchController animated:YES];

            }
        }];
    }else {
        [self showAlert:@"You're not connected to the internet. Please connect and retry." message:@""];
    
    }
        
}

-(IBAction)onSignInTwitter{
	
    
    if([FlyerlySingleton connected]){
        
        [self showLoadingIndicator];
        
        [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
            
            [self hideLoadingIndicator];
            
            if ( !user ) {
                
                //User denied to access fb account of Device
                NSLog(@"Uh oh. The user cancelled the Twitter login.");
                return;
                
            } else if ( user.isNew ) {
                
                NSLog(@"User signed up and logged in with Twitter!");
                
                [self onSignInSuccess];

                NSString *twitterUsername = [PFTwitterUtils twitter].screenName;                

                
                // Remove Current UserName for Device configuration
                [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"User"];

                // Login success Move to Flyerly
                self.launchController = [[FlyerlyMainScreen alloc]initWithNibName:@"FlyerlyMainScreen" bundle:nil] ;
                
                // For Parse New User Merge to old Twitter User
                FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
                appDelegate.lauchController = self.launchController;
                [appDelegate twitterChangeforNewVersion:twitterUsername];
                
                [self.navigationController pushViewController:self.launchController animated:YES];
                

            } else {
                
                NSLog(@"User logged in with Twitter!");
                
                [self onSignInSuccess];
                
                // Remove Current UserName for Device configuration
                [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"User"];

                
                // Login success Move to Flyerly
                self.launchController = [[FlyerlyMainScreen alloc]initWithNibName:@"FlyerlyMainScreen" bundle:nil] ;
                [self.navigationController pushViewController:self.launchController animated:YES];

                
            }     
        }];
    
        
    }else{
        [self showAlert:@"You're not connected to the internet. Please connect and retry." message:@""];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// return the Sign In succes status
- (void) onSignInSuccess {
    
    if (self.signInCompletion) {
        self.signInCompletion();
        [FlyerUser mergeAnonymousUser];
        
    }
    
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