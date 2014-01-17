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
#import "Singleton.h"
#import "ProfileViewController.h"
#import "ParentViewController.h"

@class FBSession,Singleton,LauchViewController;
@interface RegisterController : ParentViewController <UITextFieldDelegate,UIActionSheetDelegate,UIAlertViewDelegate>{
    
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
    IBOutlet UITextField *confirmPassword;
    
    IBOutlet UIButton *signUp;
    IBOutlet UIButton *signUpFacebook;
    IBOutlet UIButton *signUpTwitter;
    
    LauchViewController *launchController;
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

@property(nonatomic,strong) IBOutlet UIScrollView *scrollView;
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

-(void)goBack;
-(IBAction)userExist;
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
