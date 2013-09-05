//
//  AccountSelecter.m
//  Flyr
//
//  Created by Khurram on 13/08/2013.
//
//

#import "AccountSelecter.h"

@interface AccountSelecter ()

@end

@implementation AccountSelecter
@synthesize username,password,confirmPassword,email,name,phno;

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
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg_without_logo2"] forBarMetrics:UIBarMetricsDefault];
    
    //set title
    //self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Register" rect:CGRectMake(-50, -6, 50, 50)];
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(-50, -6, 150, 80)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    //    label.backgroundColor = [UIColor blueColor ];
    label.text = @"PROFILE";
    self.navigationItem.titleView = label;

    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 29, 25)];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:leftBarButton,nil]];

    
    globle = [Singleton RetrieveSingleton];
    PFUser *user = [PFUser currentUser];
    username.text = user.username;
    email.text = user.email;
    name.text = [user objectForKey:@"name"];
    phno.text = [user objectForKey:@"contact"];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)save{
    if([self Uservalidate]){
        PFUser *user = [PFUser currentUser];
        [user setObject:username.text forKey:@"username"];
        [user setObject:phno.text forKey:@"contact"];
        [user setObject:name.text forKey:@"name"];
        [user setObject:email.text forKey:@"email"];
        [user saveInBackground];
        [self showAlert:@"Profile Updated Successfully" message:@""];
    }
      
    [password resignFirstResponder];
   }
-(IBAction)changePW{
    
    [PFUser requestPasswordResetForEmailInBackground:email.text block:^(BOOL succeeded, NSError *error){
        if (error) {
            NSString *errorValue = [error.userInfo objectForKey:@"error"];
              [self showAlert:@"No account exists with email" message:@""];
        } else {
            [self showAlert:@"Reset password email has been sent." message:@""];
        }}];

}

-(BOOL)Uservalidate{
    
    // Check empty fields
    if(!username || [username.text isEqualToString:@""]){
        [self showAlert:@"Please complete all required fields" message:@""];
        return NO;
    }
    
    

    if([email.text length] == 0 ){
        [self showAlert:@"Email Address Must Required" message:@""];
        return NO;
    }
    return YES;
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

/*
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
    else if (heightFraction >= 0.3)
    {
        heightFraction = 0.5;
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
*/
@end
