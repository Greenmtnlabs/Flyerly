//
//  MainSettingViewController.h
//  Flyr
//
//  Created by Khurram on 07/08/2013.
//
//

#import <UIKit/UIKit.h>
#import "ShareSettingViewController.h"
#import "FlyrAppDelegate.h"
#import "AccountController.h"
#import "Common.h"
#import "HelpController.h"
#import "ShareSettingViewController.h"
#import "PhotoController.h"
#import "ProfileViewController.h"
#import "InputViewController.h"
#import "Singleton.h"
#import "MainSettingCell.h"
#import <ShareKit.h>


@class PhotoController,InputViewController,Singleton ;
@class AccountController,LauchViewController,HelpController,ShareSettingViewController,ProfileViewController;
@interface MainSettingViewController : UIViewController <UITableViewDelegate, MFMailComposeViewControllerDelegate>{

    NSMutableArray *category;
    NSMutableArray *groupCtg;
    ShareSettingViewController *oldsettingveiwcontroller;
    UIAlertView *warningAlert;
    PhotoController *ptController;
    ProfileViewController *accountUpdater;
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
