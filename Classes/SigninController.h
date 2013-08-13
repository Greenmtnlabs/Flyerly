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
#import <Parse/PFLogInViewController.h>
#import "Singleton.h"
#import "AccountSelecter.h"
@class AccountSelecter,Singleton;
@interface SigninController : UIViewController<PFLogInViewControllerDelegate,FBRequestDelegate,FBSessionDelegate,FBDialogDelegate,FBLoginDialogDelegate>{
    
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
	LoadingView *loadingView;
    Singleton *globle;
}

@property(nonatomic, retain) IBOutlet UIImageView *emailImage;
@property(nonatomic, retain) IBOutlet UIImageView *passwordImage;

@property(nonatomic, retain) IBOutlet UITextField *email;
@property(nonatomic, retain) IBOutlet UITextField *password;

@property(nonatomic, retain) IBOutlet UIButton *signIn;
@property(nonatomic, retain) IBOutlet UIButton *signUp;
@property(nonatomic, retain) IBOutlet UIButton *signInFacebook;
@property(nonatomic, retain) IBOutlet UIButton *signInTwitter;
@property(nonatomic, retain) IBOutlet UIButton *forgetPassword1;

@property (nonatomic, retain) LoadingView *loadingView;

-(IBAction)onSignIn;
-(IBAction)onSignUp;
-(IBAction)onSignInFacebook;
-(IBAction)onSignInTwitter;
-(IBAction)forgetPassword;
-(void)signIn:(BOOL)validated username:(NSString *)userName password:(NSString *)pwd;


@end
