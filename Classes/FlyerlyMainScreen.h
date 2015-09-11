//
//  FlyerlyMainScreen
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 22/Jan/2014.
//


#import <UIKit/UIKit.h>
#import "CreateFlyerController.h"
#import "MainFlyerCell.h"
#import "Common.h"
#import "ShareViewController.h"
#import "HelpController.h"
#import "FlyrAppDelegate.h"
#import "Flyer.h"
#import "InAppViewController.h"
#import "RMStore.h"
#import "RMStoreKeychainPersistence.h"
#import "ParentViewController.h"
#import "GADInterstitialDelegate.h"
#import "GADInterstitial.h"
#import "InviteForPrint.h"
#import "PrintViewController.h"
#import "UserPurchases.h"
#import "IntroScreenViewController.h"


@class MainFlyerCell, Flyer, SigninController, RegisterController, InAppViewController, IntroScreenViewController, CreateFlyerController,ShareViewController,PrintViewController;

@interface FlyerlyMainScreen : ParentViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate,RMStoreObserver,InAppPurchasePanelButtonProtocol, UserPurchasesDelegate ,GADInterstitialDelegate>{

    CreateFlyerController *createFlyer;

    SigninController *signInController;
    RegisterController *signUpController;
    ShareViewController *shareviewcontroller;
    InAppViewController *inappviewcontroller;
    IntroScreenViewController *introScreenViewController;
    UserPurchases *userPurchases;
    NSMutableArray *flyerPaths;

    NSMutableArray *searchFlyerPaths;
    NSArray *requestedProducts;
    RMStoreKeychainPersistence *_persistence;
    PrintViewController *printViewController;
    UIButton *inviteButton,*createButton;
    UIBarButtonItem *rightUndoBarButton;
    
}


@property(nonatomic, strong) GADInterstitial *addInterstialFms;
@property ( nonatomic, strong ) IBOutlet UITableView *tView;
@property ( nonatomic, strong ) NSMutableArray *flyerPaths;
@property ( nonatomic, strong ) Flyer *flyer;
@property (nonatomic, strong) UIView *sharePanel;
@property (nonatomic, strong) UIAlertView *signInAlert;
@property (nonatomic, strong) UIButton *settingBtn;


-(IBAction)createFlyer:(id)sender;
-(IBAction)doAbout:(id)sender;
-(IBAction)doInvite:(id)sender;

-(NSMutableArray *)getFlyersPaths;

-(void)printFlyer;
-(void)enableHome:(BOOL)enable;

@end
