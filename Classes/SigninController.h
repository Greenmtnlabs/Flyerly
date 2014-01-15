//
//  SigninController.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 7/4/13.
//
//

#import <UIKit/UIKit.h>
#import "LauchViewController.h"
#import "RegisterController.h"
#import <Parse/Parse.h>
#import "Singleton.h"
#import "AccountSelecter.h"
#import "ResetPWViewController.h"
#import "ParentViewController.h"


@class AccountSelecter,Singleton,RegisterController,ResetPWViewController;

@interface SigninController : ParentViewController <PFLogInViewControllerDelegate,FBLoginViewDelegate,UIActionSheetDelegate >{
    
    IBOutlet UIImageView *emailImage;
    IBOutlet UIImageView *passwordImage;

    IBOutlet UITextField *email;
    IBOutlet UITextField *password;
    
    IBOutlet UIButton *signIn;
    IBOutlet UIButton *signUp;
    IBOutlet UIButton *signInFacebook;
    IBOutlet UIButton *signInTwitter;
    NSString *usr;
    
    IBOutlet UIButton *forgetPassword1;

    LauchViewController *launchController;
    RegisterController *registerController;
    AccountSelecter *actSelecter;
    Singleton *globle;
    ResetPWViewController *passWordContrller;
    NSArray *twitterAccounts;
    UIView *waiting;
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

-(BOOL)twitterAccountExist:(NSString *)userId;

-(void)getTwitterAccounts:(id)delegate;
-(void)setAlertForSettingPage :(id)delegate;
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex ;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
-(void)displayUserList:(NSArray *)accounts ;


@end
