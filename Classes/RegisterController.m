//
//  RegisterController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 7/4/13.
//
//

#import "RegisterController.h"
#import <Parse/PFQuery.h>

@interface RegisterController ()

@end

@implementation RegisterController
@synthesize username,password,confirmPassword,signUp,signUpFacebook,signUpTwitter;

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
    username.borderStyle = UITextBorderStyleNone;
    password.borderStyle = UITextBorderStyleNone;
    confirmPassword.borderStyle = UITextBorderStyleNone;

}

-(IBAction)onSignUp{

    [self validate];
    
}

-(IBAction)onSignUpFacebook{}

-(IBAction)onSignUpTwitter{}

-(void)validate{

    // Check empty fields
    if(!username || [username.text isEqualToString:@""] ||
       !password || [password.text isEqualToString:@""] ||
       !confirmPassword || [confirmPassword.text isEqualToString:@""]){
        
        NSLog(@"Please fill all the fields");
        return;
    }
    
    // Check password matched
    if(![password.text isEqualToString:confirmPassword.text]){
        
        NSLog(@"Password not matched");
        return;
    }
    
    // Check username already exists
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:username.text];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        
        NSString *dbUsername = [object objectForKey:@"username"];
        NSLog(@"DB Username: %@", dbUsername);

        if(dbUsername){
            
            NSLog(@"User already exists");
            
        } else {
        
            NSLog(@"Create this user");
        }
        
    }];
}

@end
