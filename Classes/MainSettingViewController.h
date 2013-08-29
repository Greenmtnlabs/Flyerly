//
//  MainSettingViewController.h
//  Flyr
//
//  Created by Khurram on 07/08/2013.
//
//

#import <UIKit/UIKit.h>
#import "SettingViewController.h"
#import "FlyrAppDelegate.h"
#import "AccountController.h"
#import "Common.h"
#import "HelpController.h"
#import "SettingViewController.h"
@class AccountController,LauchViewController,HelpController,SettingViewController;
@interface MainSettingViewController : UIViewController <UITableViewDelegate>{

    UITableView *tableView;
    NSMutableArray *category;
    NSMutableArray *groupCtg;
    SettingViewController *oldsettingveiwcontroller;
    UISwitch *mySwitch;
    AccountController   *actaController;
    HelpController *helpController;
}
@property (strong, nonatomic)IBOutlet UITableView *tableView;
- (void)changeSwitch:(id)sender;
- (void)signOut;
-(void)goBack;
-(void)editClick;
-(IBAction)gohelp;
-(IBAction)gofacbook:(id)sender;
-(IBAction)gotwitter:(id)sender;
-(IBAction)goemail:(id)sender;



@end
