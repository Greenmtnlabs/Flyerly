//
//  AccountController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 22/Jan/2014.
//
//

#import "AccountController.h"
#import "FlyrAppDelegate.h"
#import "Common.h"

@interface AccountController ()

@end

@implementation AccountController
@synthesize registerButton, signinButton,test;

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
  
    
    if(IS_IPHONE_5){
       registerController = [[RegisterController alloc] initWithNibName:@"RegisterViewController_iPhone5" bundle:nil];
    }else{
       registerController = [[RegisterController alloc] initWithNibName:@"RegisterController" bundle:nil];

    }

    [self.navigationController pushViewController:registerController animated:YES];
}

-(IBAction)onSignIn{
    
   signinController = [[SigninController alloc] initWithNibName:@"SigninController" bundle:nil];
    
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
