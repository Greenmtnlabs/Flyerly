//
//  MainSettingViewController.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd on 07/08/2013.
//
//

#import <UIKit/UIKit.h>
#import "FlyrAppDelegate.h"
#import "LaunchController.h"
#import "Common.h"
#import "HelpController.h"
#import "ProfileViewController.h"
#import "SigninController.h"
#import "RegisterController.h"
#import "InputViewController.h"
#import "FlyerlySingleton.h"
#import "MainSettingCell.h"
#import <ShareKit.h>
#import "FlyerlyTwitterLike.h"


@class InputViewController,FlyerlySingleton ;
@class LaunchController,HelpController,ProfileViewController;
@interface MainSettingViewController : UIViewController <UITableViewDelegate, MFMailComposeViewControllerDelegate>{

    NSMutableArray *category;
    NSMutableArray *groupCtg;
    UIAlertView *warningAlert;
    ProfileViewController *accountUpdater;
    SigninController *signInController;
    RegisterController *registerController;
    FlyerlySingleton *globle;

}
@property (strong, nonatomic)IBOutlet UITableView *tableView;
- (void)changeSwitch:(id)sender;
+ (void)signOut;
-(void)goBack;
-(void)likeFacebook;
-(void)likeTwitter;
-(IBAction)gohelp;
-(IBAction)rateApp:(id)sender;
-(IBAction)gotwitter:(id)sender;
-(IBAction)goemail:(id)sender;


@end
