//
//  SigninController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 7/4/13.
//
//

#import "SigninController.h"
#import "Common.h"

@interface SigninController ()

@end

@implementation SigninController
@synthesize email,password,signIn,signUp,signInFacebook,signInTwitter,emailImage,passwordImage;

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
    
    // remove borders
    email.borderStyle = UITextBorderStyleNone;
    password.borderStyle = UITextBorderStyleNone;
}

-(IBAction)onSignIn{
    if(IS_IPHONE_5){
        launchController = [[LauchViewController alloc]initWithNibName:@"LauchViewControllerIPhone5" bundle:nil];
    }   else{
        launchController = [[LauchViewController alloc]initWithNibName:@"LauchViewController" bundle:nil];
    }
    
    [self.navigationController pushViewController:launchController animated:YES];
}

-(IBAction)onSignInFacebook{}

-(IBAction)onSignInTwitter{}

-(IBAction)onSignUp{}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
