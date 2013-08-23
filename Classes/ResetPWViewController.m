//
//  ResetPWViewController.m
//  Flyr
//
//  Created by Khurram on 23/08/2013.
//
//

#import "ResetPWViewController.h"


@implementation ResetPWViewController

@synthesize username,loadingView;
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
    label.text = @"REGISTER";
    self.navigationItem.titleView = label;
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 29, 25)];
    // [welcomeButton setTitle:@" Welcome" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:leftBarButton,nil]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(IBAction)SearchBotton:(id)sender{
    [self showLoadingView:@"Wait..."];
    NSLog(@"Forget Password");
    
    
    [PFUser requestPasswordResetForEmailInBackground:username.text block:^(BOOL succeeded, NSError *error){
        if (error) {
            
            NSString *errorValue = [error.userInfo objectForKey:@"error"];
            [self removeLoadingView];
            [self showAlert:@"Warning!" message:errorValue];
            
        } else {
            
            [self removeLoadingView];
            [self showAlert:@"Message!" message:@"Email has been sent to your inbox to change your password."];
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

-(void)goBack{
    
	[self.navigationController popViewControllerAnimated:NO];
}

@end
