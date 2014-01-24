//
//  AccountController.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 7/4/13.
//
//

#import <UIKit/UIKit.h>
#import "RegisterController.h"
#import "SigninController.h"
#import "FlyerlySingleton.h"



@class FlyerlySingleton,SigninController,RegisterController;
@interface AccountController : UIViewController{
    
    FlyerlySingleton  *globle;
    SigninController *signinController;
    RegisterController *registerController;
}

@property(nonatomic, strong) IBOutlet UIButton *registerButton;
@property(nonatomic, strong) IBOutlet UIButton *signinButton;


-(IBAction)onRegister;
-(IBAction)onSignIn;

@end
