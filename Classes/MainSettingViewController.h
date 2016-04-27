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
#import "UserPurchases.h"
#import <ShareKit.h>
#import "FlyerlyTwitterLike.h"
#import "RMStoreKeychainPersistence.h"
#import "PrivicyPolicyViewController.h"
#import "TermsOfServiceViewController.h"


@class InputViewController,FlyerlySingleton ;
@class LaunchController,HelpController,ProfileViewController,TermsOfServiceViewController,PrivicyPolicyViewController,InAppViewController;
@interface MainSettingViewController : UIViewController <UITableViewDelegate, MFMailComposeViewControllerDelegate,InAppPurchasePanelButtonProtocol,UserPurchasesDelegate,SHKSharerDelegate, GADInterstitialDelegate, GADBannerViewDelegate>{

    NSMutableArray *category;
    NSMutableArray *groupCtg;
    UIAlertView *warningAlert;
    ProfileViewController *accountUpdater;
    SigninController *signInController;
    RegisterController *registerController;
    FlyerlySingleton *globle;
    InAppViewController *inappviewcontroller;
    PrivicyPolicyViewController * privicyPolicyView;
    TermsOfServiceViewController * termOfServiceView;
    BOOL bannerAdClosed;
    BOOL bannerShowed; 

}
@property (strong, nonatomic)IBOutlet UITableView *tableView;
@property (nonatomic, strong) RMStoreKeychainPersistence *_persistence;
- (void)changeSwitch:(id)sender;
+ (void)signOut;
-(void)goBack;
-(void)likeFacebook;
-(void)likeTwitter;
-(IBAction)gohelp;
-(IBAction)rateApp:(id)sender;
-(IBAction)gotwitter:(id)sender;
-(IBAction)goemail:(id)sender;
- (IBAction)onClickBtnDismissBannerAds:(id)sender;

@property(nonatomic, strong) GADInterstitial *interstitialAds;
//@property(nonatomic, strong) GADBannerView *bannerAds;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerAdsView;
@property (weak, nonatomic) IBOutlet UIButton *btnBannerAdsDismiss;


@end
