//
//  RegisterController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 7/4/13.
//
//

#import "RegisterController.h"

@interface RegisterController ()

@end

@implementation RegisterController
@synthesize username,password,confirmPassword,signUp,signUpFacebook,signUpTwitter,email,name,phno,usrExist,scrollView;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    globle = [FlyerlySingleton RetrieveSingleton];
    
    self.navigationController.navigationBarHidden = NO;
    
    // for Navigation Bar Background
    self.navigationController.navigationBar.alpha = 1;

    //set title
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 80)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];
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
    email.clearButtonMode = UITextFieldViewModeWhileEditing;
    name.clearButtonMode = UITextFieldViewModeWhileEditing;
    phno.clearButtonMode = UITextFieldViewModeWhileEditing;

    //Back Bar button
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];

    //Done Bar button
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [doneButton addTarget:self action:@selector(onSignUp) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
    doneButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];

    [self.navigationItem setRightBarButtonItem:rightBarButton];
 

}

-(void)goBack{
    
	[self.navigationController popViewControllerAnimated:YES];
    
}


-(void)showLoadingView {
    [self showLoadingIndicator];
}


-(void)removeLoadingView{
    [self hideLoadingIndicator];
}


-(void)onSignUp{
    
    //Internet Connectivity Check
    if([FlyerlySingleton connected]){
        [self showLoadingView];
        
        //Validations
        if( [self validate] ){
            
            [self signUp:YES username:username.text password:password.text];
            
        }
    }else {
        [self showAlert:@"You're not connected to the internet. Please connect and retry." message:@""];
        
    }

}


-(void)signUp:(BOOL)validationDone username:(NSString *)userName password:(NSString *)pwd{
    
    // Check username already exists
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:userName];
    
    //query on parse
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        
        NSString *dbUsername = object[@"username"];
        
        if( dbUsername ){
            
            username.text = userName;
            password.text = pwd;
            
            //Saving User Info for again Login
            [[NSUserDefaults standardUserDefaults]  setObject:userName forKey:@"User"];
            
            warningAlert = [[UIAlertView  alloc]initWithTitle:@"Account already exists using this account." message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign In",nil];
            
            [warningAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
            [self removeLoadingView];

        } else {
            
            [self createUser:userName password:pwd];
            
        }
    }];
    
}


/*
 * Here we Using Parse Utility for Loign by Facebook
 */
-(IBAction)onSignUpFacebook{
    
    //Internet Connectivity Check
    if([FlyerlySingleton connected]){
        
        [self showLoadingView];
        
        // The permissions requested from the user
        NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
        
        // Login PFUser using Facebook
        [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
            [self hideLoadingIndicator]; // Hide loading indicator
            
            if ( !user ) {
                
                if (!error) {
                    NSLog(@"Uh oh. The user cancelled the Facebook login.");
                } else {
                    NSLog(@"Uh oh. An error occurred: %@", error);
                }
                
            } else if (user.isNew) {
                
                NSLog(@"User with facebook signed up and logged in!");
                
                FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
                
                 // here we Checking  User Merge required or not
                [appDelegate fbChangeforNewVersion];
                
                // Remove Current UserName for Device configuration
                [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"User"];
                
                // Login success Move to Flyerly
                launchController = [[FlyerlyMainScreen alloc]initWithNibName:@"FlyerlyMainScreen" bundle:nil] ;
                
                [self.navigationController pushViewController:launchController animated:nil];
                
            } else {
                
                NSLog(@"User with facebook logged in!");
                
                // Remove Current UserName for Device configuration
                [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"User"];
                
                // Temp on for Testing here
                // FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
                // [appDelegate fbChangeforNewVersion];
                
                // Login success Move to Flyerly
                launchController = [[FlyerlyMainScreen alloc]initWithNibName:@"FlyerlyMainScreen" bundle:nil] ;
                
                [self.navigationController pushViewController:launchController animated:YES];
                
            }
        }];

    }else {
        [self showAlert:@"You're not connected to the internet. Please connect and retry." message:@""];
    }
}


#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

	if( alertView == warningAlert && buttonIndex == 1 ) {

        launchController = [[FlyerlyMainScreen alloc]initWithNibName:@"FlyerlyMainScreen" bundle:nil];
        
        [self.navigationController pushViewController:launchController animated:YES];

    } else {
        
        [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"User"];
        
    }
    
}


-(IBAction)onSignUpTwitter{


    
    //Connectivity Check
    if([FlyerlySingleton connected]){
        
        [self showLoadingIndicator];

        [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
            
            [self hideLoadingIndicator];
            
            if (!user) {
                
                NSLog(@"Uh oh. The user cancelled the Twitter login.");
                return;
                
            } else if (user.isNew) {
                
                NSLog(@"User signed up and logged in with Twitter!");
                
                NSString *twitterUsername = [PFTwitterUtils twitter].userId;
                
                FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
                
                // here we Checking  User Merge required or not
                [appDelegate twitterChangeforNewVersion:twitterUsername];
                
                // Remove Current UserName for Device configuration
                [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"User"];
                
                // Login success Move to Flyerly
                launchController = [[FlyerlyMainScreen alloc]initWithNibName:@"FlyerlyMainScreen" bundle:nil] ;
                [self.navigationController pushViewController:launchController animated:YES];
                
            } else {
                
                NSLog(@"User logged in with Twitter!");
                
                // Remove Current UserName for Device configuration
                [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"User"];
                
                // Temp on for Testing here
                // For Parse New User Merge to old Twitter User
                /*
                 FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
                 [appDelegate twitterChangeforNewVersion:twitterUsername];*/
                
                
                // Login success Move to Flyerly
                launchController = [[FlyerlyMainScreen alloc]initWithNibName:@"FlyerlyMainScreen" bundle:nil] ;
                [self.navigationController pushViewController:launchController animated:YES];
                
                
            }
        }];
        
        
    } else {
        
        [self showAlert:@"You're not connected to the internet. Please connect and retry." message:@""];
        [self removeLoadingView];
        
    }

}


-(BOOL)validate{

    
    
    // Check empty fields
    if(username.text == nil || [username.text isEqualToString:@""]){
        
        [self showAlert:@"Please complete all required fields" message:@""];
        [self removeLoadingView];
        return NO;
    }
    
    if(!password || [password.text isEqualToString:@""] ||
       !confirmPassword || [confirmPassword.text isEqualToString:@""]){
        
        [self showAlert:@"Please complete all required fields." message:@""];
        [self removeLoadingView];
        return NO;
    }
    
    
    // Check password matched
    if(![password.text isEqualToString:confirmPassword.text]){
        
        [self showAlert:@"Passwords do not match." message:@""];
        [self removeLoadingView];
        return NO;
    }

    
    if([email.text length] == 0 ){
        [self showAlert:@"Warning!" message:@"Email Address Must Required"];
        [self removeLoadingView];
        return NO;
    }
    if([usrExist.text isEqualToString:@"taken"] ){
        [self showAlert:@"Username already taken" message:@""];
        [self removeLoadingView];
        return NO;
    }
    
    return YES;
}

-(void)createUser:(NSString *)userName password:(NSString *)pwd{
    
    // username and password
    PFUser *user = [PFUser user];
    user.username = [userName lowercaseString];
    user.password = pwd;
    user.email = email.text;
    if (name.text != nil)
        user[@"name"] = name.text;
    if (phno.text != nil)
        user[@"contact"] = phno.text;
    
    //Saving User Info for again login
    [[NSUserDefaults standardUserDefaults]  setObject:userName forKey:@"User"];

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (error) {
            
            NSString *errorValue = (error.userInfo)[@"error"];
            [self showAlert:@"Warning!" message:errorValue];
            [self removeLoadingView];

        } else {
            
            [PFUser logInWithUsername:userName password:pwd];
            launchController = [[FlyerlyMainScreen alloc]initWithNibName:@"FlyerlyMainScreen" bundle:nil];
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


/*
 * For Checking Duplicate User
 */
-(IBAction)userExist{
    
    if( username.text != nil ){
        
        PFQuery *query = [PFUser  query];
        [query whereKey:@"username" equalTo:[username.text lowercaseString]];
        
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
            if (error) {
                [usrExist setHidden:NO];
                [usrExist setText:@"available"];
                [usrExist setTextColor:[UIColor greenColor]];
            }else{
                [usrExist setHidden:NO];
                [usrExist setText:@"taken"];
                [usrExist setTextColor:[UIColor redColor]];
            }
        }];
    }
    
}


#pragma TextFields Method

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

@end
