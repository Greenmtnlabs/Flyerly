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
#import "PhotoController.h"
#import "AccountSelecter.h"
#import "InputViewController.h"
#import "Singleton.h"
#import "MainSettingCell.h"
#import <ShareKit.h>


@class PhotoController,InputViewController,Singleton ;
@class AccountController,LauchViewController,HelpController,SettingViewController,AccountSelecter;
@interface MainSettingViewController : UIViewController <UITableViewDelegate, MFMailComposeViewControllerDelegate>{

    NSMutableArray *category;
    NSMutableArray *groupCtg;
    SettingViewController *oldsettingveiwcontroller;
    UIAlertView *warningAlert;
    PhotoController *ptController;
    AccountSelecter *accountUpdater;
    Singleton *globle;

}
@property (strong, nonatomic)IBOutlet UITableView *tableView;
- (void)changeSwitch:(id)sender;
- (void)signOut;
-(void)goBack;
-(IBAction)gohelp;
-(IBAction)RateApp:(id)sender;
-(IBAction)gotwitter:(id)sender;
-(IBAction)goemail:(id)sender;

-(void)CreateNewFlyer;

@end
