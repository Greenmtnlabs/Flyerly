//
//  SigninController.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 7/4/13.
//
//

#import <UIKit/UIKit.h>
#import "FlyerlyMainScreen.h"
#import "RegisterController.h"
#import <Parse/Parse.h>
#import "FlyerlySingleton.h"
#import "ResetPWViewController.h"
#import "ParentViewController.h"



@class FlyerlySingleton,RegisterController,ResetPWViewController,FlyerlyMainScreen;

@interface SigninController : ParentViewController <PFLogInViewControllerDelegate,FBLoginViewDelegate >{
    
    NSString *usr;
    FlyerlyMainScreen *launchController;
    RegisterController *registerController;
    FlyerlySingleton *globle;

    NSString *dbUsername;
    UIAlertView *warningAlert;
}

@property(nonatomic, strong) IBOutlet UIImageView *emailImage;
@property(nonatomic, strong) IBOutlet UIImageView *passwordImage;
@property(nonatomic, strong) IBOutlet UITextField *email;
@property(nonatomic, strong) IBOutlet UITextField *password;
@property(nonatomic, strong) IBOutlet UIButton *signIn;
@property(nonatomic, strong) IBOutlet UIButton *signUp;
@property(nonatomic, strong) IBOutlet UIButton *signInFacebook;
@property(nonatomic, strong) IBOutlet UIButton *signInTwitter;
@property(nonatomic, strong) IBOutlet UIButton *forgetPassword1;

-(IBAction)onSignIn;
-(IBAction)onSignUp;
-(IBAction)onSignInFacebook;
-(IBAction)onSignInTwitter;
-(IBAction)forgetPassword;
-(void)signIn:(BOOL)validated username:(NSString *)userName password:(NSString *)pwd;

@end
