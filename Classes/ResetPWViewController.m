//
//  ResetPWViewController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd on 23/08/2013.
//
//

#import "ResetPWViewController.h"


@implementation ResetPWViewController

@synthesize username, lblRecoverAccount;

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
    
    //Bar Title
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-50, -6, 150, 80)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];
    label.text = @"FORGOT PASSWORD?";
    self.navigationItem.titleView = label;
    
    //Back Bar Button
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
     backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:leftBarButton,nil]];
    
    lblRecoverAccount.text = [NSString stringWithFormat:@"Recover Your %@ Account", APP_NAME] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
 * Here we Check User Exist on Parse or not
 * for send Password Info to user by Parse
 */
-(IBAction)SearchBotton:(id)sender{
    [self showLoadingView];
    NSLog(@"Forget Password");
    
    if (username.text == nil || [username.text isEqualToString:@""]) {
        [self removeLoadingView];
        [self showAlert:@"Think you forgot something..." message:@""];
        return;
    }
    
    NSString *string = username.text;
    
    //Checking For User Enter Username or Email Address
    if ( [string rangeOfString:@"@"].location == NSNotFound ) {
        
        
        //Getting Account Info with Username
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:[username.text lowercaseString]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
            
            dbUsername = object[@"email"];
            NSLog(@"%@",dbUsername);
            
            if( dbUsername ){
                
                //Requesting for Send Email to User
                [PFUser requestPasswordResetForEmailInBackground:dbUsername block:^(BOOL succeeded, NSError *error){
                    if (error) {
                        [self removeLoadingView];
                         [self showAlert:@"No account exists with username" message:@""];
                    } else {
                        
                        [self removeLoadingView];
                        [self showAlert:@"Reset password email has been sent." message:@""];
                    }}];

            } else {

                [self removeLoadingView];
                [self showAlert:@"No account exists with username" message:@""];
            }  }];
        
    } else {
        
        //Requesting for Send Email to User by email Address
        [PFUser requestPasswordResetForEmailInBackground:username.text block:^(BOOL succeeded, NSError *error){
            if (error) {
                [self removeLoadingView];
                [self showAlert:@"No account exists with email address." message:@""];
            } else {
                
                [self removeLoadingView];
                [self showAlert:@"Reset password email has been sent." message:@""];
            }}];
    }

}


-(void)showAlert:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)showLoadingView {
    [self showLoadingIndicator];
}

-(void)removeLoadingView{
    [self hideLoadingIndicator];
}

-(void)goBack{
	[self.navigationController popViewControllerAnimated:YES];
}

@end
