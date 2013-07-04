//
//  SigninController.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 7/4/13.
//
//

#import <UIKit/UIKit.h>
#import "LauchViewController.h"

@interface SigninController : UIViewController{
    
    IBOutlet UIImageView *emailImage;
    IBOutlet UIImageView *passwordImage;

    IBOutlet UITextField *email;
    IBOutlet UITextField *password;
    
    IBOutlet UIButton *signIn;
    IBOutlet UIButton *signUp;
    IBOutlet UIButton *signInFacebook;
    IBOutlet UIButton *signInTwitter;
    
    LauchViewController *launchController;
}

@property(nonatomic, retain) IBOutlet UIImageView *emailImage;
@property(nonatomic, retain) IBOutlet UIImageView *passwordImage;

@property(nonatomic, retain) IBOutlet UITextField *email;
@property(nonatomic, retain) IBOutlet UITextField *password;

@property(nonatomic, retain) IBOutlet UIButton *signIn;
@property(nonatomic, retain) IBOutlet UIButton *signUp;
@property(nonatomic, retain) IBOutlet UIButton *signInFacebook;
@property(nonatomic, retain) IBOutlet UIButton *signInTwitter;

-(IBAction)onSignIn;
-(IBAction)onSignUp;
-(IBAction)onSignInFacebook;
-(IBAction)onSignInTwitter;

@end
