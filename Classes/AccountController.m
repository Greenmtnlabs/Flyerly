//
//  AccountController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 7/4/13.
//
//

#import "AccountController.h"
#import "FlyrAppDelegate.h"
#import "Common.h"

@interface AccountController ()

@end

@implementation AccountController
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
}

-(void)viewWillAppear:(BOOL)animated{

    [self.navigationItem setHidesBackButton:YES];
}

-(IBAction)onRegister{
    RegisterController *registerController = [[RegisterController alloc]initWithNibName:@"RegisterController" bundle:nil];
    [self.navigationController pushViewController:registerController animated:YES];
}

-(IBAction)onSignIn{
    SigninController *signinController = [[SigninController alloc]initWithNibName:@"SigninController" bundle:nil];
    [self.navigationController pushViewController:signinController animated:YES];
}

+(NSString *)getPathFromEmail:(NSString *)email{
    return [[email stringByReplacingOccurrencesOfString:@"@" withString:@"_"] stringByReplacingOccurrencesOfString:@"." withString:@"_"];
}

+(NSString *)getTwitterEmailByUsername:(NSString *)userName{
    
    if ([userName rangeOfString:@"@"].location == NSNotFound) {
        
        NSLog(@"Not an email address - convert it into email");
        NSString *twitterEmail = [NSString stringWithFormat:@"%@@twitter.com", userName];
        return twitterEmail;
        
    } else {
        NSLog(@"Its a valid email - Return this");
        return userName;
    }
    
    return userName;
}

@end
