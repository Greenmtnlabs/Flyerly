//
//  RegisterController.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 7/4/13.
//
//

#import <UIKit/UIKit.h>
#import "FlyerlyMainScreen.h"
#import "FlyrAppDelegate.h"
#import "FlyerlySingleton.h"
#import "ParentViewController.h"
#import "FlyerUser.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <ParseTwitterUtils/PFTwitterUtils.h>
#import "SigninController.h"
#import "Common.h"
#import "FlyrAppDelegate.h"

@class FlyerlySingleton,FlyerlyMainScreen,SigninController;
@interface RegisterController : ParentViewController <UITextFieldDelegate>{
    
    FlyerlyMainScreen *launchController;
    CGFloat animatedDistance;
    NSArray *twitterAccounts;
    UIView *waiting;
    FlyerlySingleton *globle;
    UIAlertView *warningAlert;
}

@property(nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property(nonatomic, strong) IBOutlet UITextField *username;
@property(nonatomic, strong) IBOutlet UITextField *password;
@property(nonatomic, strong) IBOutlet UITextField *confirmPassword;
@property(nonatomic, strong) IBOutlet UITextField *email;
@property(nonatomic, strong) IBOutlet UITextField *name;
@property(nonatomic, strong) IBOutlet UITextField *phno;
@property(nonatomic, strong) IBOutlet UIButton *signUp;
@property(nonatomic, strong) IBOutlet UIButton *signUpFacebook;
@property(nonatomic, strong) IBOutlet UIButton *signUpTwitter;
@property(nonatomic, strong) IBOutlet UILabel *usrExist;

@property(nonatomic, weak) SigninController *signInController;

-(void)goBack;
-(void)onSignUp;
-(void)createUser:(NSString *)userName password:(NSString *)pwd;

-(IBAction)userExist;
-(IBAction)onSignUp;
-(IBAction)onSignUpFacebook;
-(IBAction)onSignUpTwitter;

@end
