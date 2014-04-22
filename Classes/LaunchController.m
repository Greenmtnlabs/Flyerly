//
//  LaunchController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 22/Jan/2014.
//
//

#import "LaunchController.h"
#import "FlyrAppDelegate.h"
#import "Common.h"

@interface LaunchController ()

@end

@implementation LaunchController
@synthesize registerButton, signinButton;

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
    globle = [FlyerlySingleton RetrieveSingleton];

}

-(void)viewWillAppear:(BOOL)animated{

    [self.navigationItem setHidesBackButton:YES];
    self.navigationController.navigationBarHidden = YES;
}

-(IBAction)onRegister{
    
    globle.twitterUser = nil;
    
      if( IS_IPHONE_5 ){
          
       registerController = [[RegisterController alloc] initWithNibName:@"RegisterViewController_iPhone5" bundle:nil];
          
    } else {
        
       registerController = [[RegisterController alloc] initWithNibName:@"RegisterController" bundle:nil];

    }
    
    signinController = [[SigninController alloc]initWithNibName:@"SigninController" bundle:nil];
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    signinController.launchController = appDelegate.lauchController;
    
    registerController.signInController = signinController;
    
    //Redirecting the user to Main screen on succesfull login
    signinController.signInCompletion = ^void(void) {
        NSLog(@"Sign In via LauchController Register");
    
        [appDelegate.lauchController.navigationController popToViewController:appDelegate.lauchController animated:YES];
        
    };

    [self.navigationController pushViewController:registerController animated:YES];
}

-(IBAction)onSignIn{
    
   
    signinController = [[SigninController alloc]initWithNibName:@"SigninController" bundle:nil];
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    signinController.launchController = appDelegate.lauchController;
    
    registerController.signInController = signinController;
    
    //Redirecting the user to Main screen on succesfull login
    signinController.signInCompletion = ^void(void) {
        NSLog(@"Sign In via LauchController Sign In");
        
        [appDelegate.lauchController.navigationController popToViewController:appDelegate.lauchController animated:YES];
        
    };
    
    [self.navigationController pushViewController:signinController animated:YES];
}


@end
