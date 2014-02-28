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
#import "CreateFlyerController.h"
#import "ProfileViewController.h"
#import "InputViewController.h"
#import "FlyerlySingleton.h"
#import "MainSettingCell.h"
#import <ShareKit.h>


@class CreateFlyerController,InputViewController,FlyerlySingleton ;
@class LaunchController,HelpController,ProfileViewController;
@interface MainSettingViewController : UIViewController <UITableViewDelegate, MFMailComposeViewControllerDelegate>{

    NSMutableArray *category;
    NSMutableArray *groupCtg;
    UIAlertView *warningAlert;
    CreateFlyerController *ptController;
    ProfileViewController *accountUpdater;
    FlyerlySingleton *globle;

}
@property (strong, nonatomic)IBOutlet UITableView *tableView;
- (void)changeSwitch:(id)sender;
- (void)signOut;
-(void)goBack;
-(IBAction)gohelp;
-(IBAction)rateApp:(id)sender;
-(IBAction)gotwitter:(id)sender;
-(IBAction)goemail:(id)sender;

-(void)createNewFlyer;

@end
