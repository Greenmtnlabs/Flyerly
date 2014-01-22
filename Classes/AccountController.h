//
//  AccountController.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 7/4/13.
//
//

#import <UIKit/UIKit.h>
#import "LauchViewController.h"
#import "RegisterController.h"
#import "SigninController.h"
#import "FlyerlySingleton.h"



@class FlyerlySingleton,SigninController,RegisterController;
@interface AccountController : UIViewController{
    
    IBOutlet UIButton *registerButton;
    IBOutlet UIButton *signinButton;
    FlyerlySingleton  *globle;
    SigninController *signinController;
    RegisterController *registerController;
}

@property(nonatomic, strong) IBOutlet UIButton *registerButton;
@property(nonatomic, strong) IBOutlet UIButton *signinButton;
@property(nonatomic, strong) IBOutlet UIButton *test;

-(IBAction)onRegister;
-(IBAction)onSignIn;
+(NSString *)getPathFromEmail:(NSString *)email;
+(NSString *)getTwitterEmailByUsername:(NSString *)userName;

@end
