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
}
@property(nonatomic, retain) IBOutlet UITextField *username;
@property(nonatomic, retain) IBOutlet UITextField *password;
@property(nonatomic, retain) IBOutlet UITextField *confirmPassword;
@property(nonatomic, strong) IBOutlet UITextField *email;
@property(nonatomic, strong) IBOutlet UITextField *name;
@property(nonatomic, strong) IBOutlet UITextField *phno;
@property(nonatomic, retain) IBOutlet UILabel *usrExist;
-(IBAction)userExist;
-(IBAction)save;
-(IBAction)changePW;

@end
