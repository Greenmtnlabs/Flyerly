//
//  ResetPWViewController.m
//  Flyr
//
//  Created by Khurram on 23/08/2013.
//
//

#import "ResetPWViewController.h"


@implementation ResetPWViewController

@synthesize username;
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
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(-50, -6, 150, 80)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    //    label.backgroundColor = [UIColor blueColor ];
    label.text = @"FORGOT PASSWORD?";
    self.navigationItem.titleView = label;
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 29, 25)];
    // [welcomeButton setTitle:@" Welcome" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
     backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:leftBarButton,nil]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(IBAction)SearchBotton:(id)sender{
    [self showLoadingView];
    NSLog(@"Forget Password");
    
    NSString *string = username.text;
    if ([string rangeOfString:@"@"].location == NSNotFound) {
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:username.text];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
            
            dbUsername = object[@"email"];
            NSLog(@"%@",dbUsername);
            if(dbUsername){
                [PFUser requestPasswordResetForEmailInBackground:dbUsername block:^(BOOL succeeded, NSError *error){
                    if (error) {
                        NSString *errorValue = (error.userInfo)[@"error"];
                        [self removeLoadingView];
                         [self showAlert:@"No account exists with username" message:@""];
                        //[self showAlert:@"Warning!" message:errorValue];
                    } else {
                        
                        [self removeLoadingView];
                        [self showAlert:@"Reset password email has been sent." message:@""];
                    }}];

            }else{
                //NSString *errorValue = [error.userInfo objectForKey:@"error"];
                [self removeLoadingView];
                //[self showAlert:@"Warning!" message:errorValue];
                [self showAlert:@"No account exists with username" message:@""];
                [dbUsername release];
            }  }];

        
        
    } else {
        [PFUser requestPasswordResetForEmailInBackground:username.text block:^(BOOL succeeded, NSError *error){
            if (error) {
                 NSString *errorValue = (error.userInfo)[@"error"];
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
    [alert release];
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
