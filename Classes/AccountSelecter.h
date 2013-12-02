//
//  AccountSelecter.h
//  Flyr
//
//  Created by Khurram on 13/08/2013.
//
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import <Parse/PFLogInViewController.h>
#import <Parse/PFQuery.h>
#import "Common.h"
#import "AddFriendsController.h"
@class SigninController,Singleton;
@interface AccountSelecter : UIViewController <UITextFieldDelegate,UITableViewDelegate>{

    Singleton *globle;
    NSString *S;
    CGFloat animatedDistance;
}
@property(nonatomic, strong) IBOutlet UITextField *username;
@property(nonatomic, strong) IBOutlet UITextField *password;
@property(nonatomic, strong) IBOutlet UITextField *confirmPassword;
@property(nonatomic, strong) IBOutlet UITextField *email;
@property(nonatomic, strong) IBOutlet UITextField *name;
@property(nonatomic, strong) IBOutlet UITextField *phno;
@property(nonatomic, strong) IBOutlet UILabel *usrExist;
-(IBAction)userExist;
-(IBAction)save;
-(IBAction)changePW;

@end
