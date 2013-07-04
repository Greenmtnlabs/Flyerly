//
//  AccountController.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 7/4/13.
//
//

#import <UIKit/UIKit.h>

@interface AccountController : UIViewController{
    
    IBOutlet UIButton *registerButton;
    IBOutlet UIButton *signinButton;
}

@property(nonatomic, retain) IBOutlet UIButton *registerButton;
@property(nonatomic, retain) IBOutlet UIButton *signinButton;

-(IBAction)onRegister;
-(IBAction)onSignIn;

@end
