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
#import "GADBannerView.h"

@class MainFlyerCell, Flyer, SigninController, RegisterController, InAppViewController, IntroScreenViewController, CreateFlyerController,ShareViewController,PrintViewController;

@interface FlyerlyMainScreen : ParentViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate,RMStoreObserver,InAppPurchasePanelButtonProtocol, UserPurchasesDelegate ,GADInterstitialDelegate, GADBannerViewDelegate>{

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
    UIButton *btnSettings, *btnInAppPurchase;
    UIBarButtonItem *rightBarButton, *leftBarButton;
    
    
}


@property(nonatomic, strong) GADInterstitial *addInterstialFms;
@property ( nonatomic, strong ) IBOutlet UITableView *tView;
@property ( nonatomic, strong ) NSMutableArray *flyerPaths;
@property ( nonatomic, strong ) Flyer *flyer;
@property (nonatomic, strong) UIView *sharePanel;
@property (nonatomic, strong) UIAlertView *signInAlert;
@property (nonatomic, strong) IBOutlet UIView *bottomBar;

@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnCreateFlyer;
@property (strong, nonatomic) IBOutlet UIButton *btnInvite;
@property (strong, nonatomic) IBOutlet UIButton *btnSaved;
@property (strong, nonatomic) IBOutlet UIButton *btnShared;
@property (strong, nonatomic) IBOutlet UIButton *btnSocial;



-(IBAction)createFlyer:(id)sender;
-(IBAction)doAbout:(id)sender;
-(IBAction)doInvite:(id)sender;
- (IBAction)showUnsharedFlyers:(id)sender;
- (IBAction)showSharedFlyers:(id)sender;
- (IBAction)showHashTagFlyers:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *vwSearch;

-(NSMutableArray *)getFlyersPaths;

-(void)printFlyer;
-(void)enableHome:(BOOL)enable;

//Add view for injecting in cells
@property(nonatomic, strong) IBOutletCollection(GADBannerView) NSMutableArray *bannerAdd;

-(void) updateCellTitle :(int)index text:(NSString *) text;

@end
