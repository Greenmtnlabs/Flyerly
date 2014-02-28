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
    CGFloat animatedDistance;
}
@property(nonatomic, strong) IBOutlet UILabel *username;
@property(nonatomic, strong) IBOutlet UIImageView *backimgUsername;
@property(nonatomic, strong) IBOutlet UITextField *email;
@property(nonatomic, strong) IBOutlet UITextField *name;
@property(nonatomic, strong) IBOutlet UITextField *phno;
-(IBAction)save;
-(IBAction)changePW;

@end
