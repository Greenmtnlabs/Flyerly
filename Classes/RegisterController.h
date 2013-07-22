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

@class FBSession;
@interface RegisterController : UIViewController<UITextFieldDelegate,FBRequestDelegate,FBSessionDelegate,FBDialogDelegate,FBLoginDialogDelegate>{
    
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
    IBOutlet UITextField *confirmPassword;
    
    IBOutlet UIButton *signUp;
    IBOutlet UIButton *signUpFacebook;
    IBOutlet UIButton *signUpTwitter;
    
    LauchViewController *launchController;
	LoadingView *loadingView;
}

@property(nonatomic, retain) IBOutlet UITextField *username;
@property(nonatomic, retain) IBOutlet UITextField *password;
@property(nonatomic, retain) IBOutlet UITextField *confirmPassword;

@property(nonatomic, retain) IBOutlet UIButton *signUp;
@property(nonatomic, retain) IBOutlet UIButton *signUpFacebook;
@property(nonatomic, retain) IBOutlet UIButton *signUpTwitter;
@property (nonatomic, retain) LoadingView *loadingView;

-(IBAction)onSignUp;
-(IBAction)onSignUpFacebook;
-(IBAction)onSignUpTwitter;

@end
