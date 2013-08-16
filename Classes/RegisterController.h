//
//  RegisterController.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 7/4/13.
//
//

#import <UIKit/UIKit.h>
#import "LauchViewController.h"
#import "FlyrAppDelegate.h"
#import "FBConnect.h"
#import "Singleton.h"
#import "AccountSelecter.h"
#import <Parse/PFLogInViewController.h>
#import <Parse/PFQuery.h>
@class FBSession,Singleton,LauchViewController;
@interface RegisterController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate,FBRequestDelegate,FBSessionDelegate,FBDialogDelegate,FBLoginDialogDelegate,UIAlertViewDelegate>{
    
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
    IBOutlet UITextField *confirmPassword;
    
    IBOutlet UIButton *signUp;
    IBOutlet UIButton *signUpFacebook;
    IBOutlet UIButton *signUpTwitter;
    
    LauchViewController *launchController;
	LoadingView *loadingView;
    CGFloat animatedDistance;
    NSArray *twitterAccounts;
    UIView *waiting;
    Singleton *globle;
    UIAlertView *warningAlert ;
	UIAlertView *discardAlert ;
	UIAlertView *deleteAlert ;
	UIAlertView *editAlert ;
    UIAlertView *inAppAlert ;
}

@property(nonatomic, retain) IBOutlet UITextField *username;
@property(nonatomic, retain) IBOutlet UITextField *password;
@property(nonatomic, retain) IBOutlet UITextField *confirmPassword;

@property(nonatomic, strong) IBOutlet UITextField *email;
@property(nonatomic, strong) IBOutlet UITextField *name;
@property(nonatomic, strong) IBOutlet UITextField *phno;


@property(nonatomic, retain) IBOutlet UIButton *signUp;
@property(nonatomic, retain) IBOutlet UIButton *signUpFacebook;
@property(nonatomic, retain) IBOutlet UIButton *signUpTwitter;
@property (nonatomic, retain) LoadingView *loadingView;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *act;


-(void)onSignUp;
-(IBAction)onSignUp;
-(IBAction)onSignUpFacebook;
-(IBAction)onSignUpTwitter;
-(void)createUser:(NSString *)userName password:(NSString *)pwd;


-(BOOL)CheckUserExists :(NSString *)userName password:(NSString *)pwd;
-(BOOL)twitterAccountExist:(NSString *)userId;
-(void)getTwitterAccounts:(id)delegate;
-(void)setAlertForSettingPage :(id)delegate;
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex ;
-(void)displayUserList:(NSArray *)accounts ;

@end
