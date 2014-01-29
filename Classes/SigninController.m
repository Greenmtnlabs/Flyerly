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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg_without_logo2"] forBarMetrics:UIBarMetricsDefault];

    //set title
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
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
    
    //Validation
    if([self validate]){
        [self signIn:YES username:email.text password:password.text];
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
        [[NSUserDefaults standardUserDefaults]  setObject:pwd forKey:@"Password"];

        launchController = [[LauchViewController alloc]initWithNibName:@"LauchViewController" bundle:nil];
        [self.navigationController pushViewController:launchController animated:YES];
    }
    
}

-(void)pushViewController:(UIViewController*)theViewController{
    [self.navigationController pushViewController:theViewController animated:YES];
}


-(IBAction)onSignInFacebook{
    
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

            FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
            
            // For Parse New User Merge to old Facebook User
            [appDelegate FbChangeforNewVersion];
            
             // Remove Current UserName for Device configuration
            [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"User"];
            
            // Login success Move to Flyerly
            launchController = [[LauchViewController alloc]initWithNibName:@"LauchViewController" bundle:nil] ;
            
            [self performSelectorOnMainThread:@selector(pushViewController:) withObject:launchController waitUntilDone:YES];
            
        } else {
            NSLog(@"User with facebook logged in!");
            
            // Remove Current UserName for Device configuration
            [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"User"];

            // Temp on for Testing here
            // FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
            // [appDelegate FbChangeforNewVersion];
            
            // Login success Move to Flyerly
            launchController = [[LauchViewController alloc]initWithNibName:@"LauchViewController" bundle:nil] ;
            [self.navigationController pushViewController:launchController animated:YES];

        }
    }];

        
}

-(IBAction)onSignInTwitter{
    [self showLoadingIndicator];
    
    if([InviteFriendsController connected]){
        
        [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
            
            [self hideLoadingIndicator];
            
            if ( !user ) {
                
                //User denied to access fb account of Device
                NSLog(@"Uh oh. The user cancelled the Twitter login.");
                return;
                
            } else if ( user.isNew ) {
                
                NSLog(@"User signed up and logged in with Twitter!");

                NSString *twitterUsername = [PFTwitterUtils twitter].userId;
                
                // For Parse New User Merge to old Twitter User
                FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
                [appDelegate TwitterChangeforNewVersion:twitterUsername];
                
                // Remove Current UserName for Device configuration
                [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"User"];

                // Login success Move to Flyerly
                launchController = [[LauchViewController alloc]initWithNibName:@"LauchViewController" bundle:nil] ;
                [self.navigationController pushViewController:launchController animated:YES];
                

            } else {
                
                NSLog(@"User logged in with Twitter!");
                
                // Remove Current UserName for Device configuration
                [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"User"];

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
    
        
    }else{
        [self showAlert:@"You're not connected to the internet. Please connect and retry." message:@""];
        [self removeLoadingView];
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