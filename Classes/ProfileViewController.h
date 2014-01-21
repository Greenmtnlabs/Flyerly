//
//  AccountSelecter.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd on 13/08/2013.
//
//

#import <UIKit/UIKit.h>
#import "FlyerlySingleton.h"
#import "Common.h"
#import "InviteFriendsController.h"


@class FlyerlySingleton;
@interface ProfileViewController : UIViewController <UITextFieldDelegate,UITableViewDelegate>{

    FlyerlySingleton *globle;
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
