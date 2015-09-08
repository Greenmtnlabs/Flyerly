//
//  FlyerlyMainScreen
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 22/Jan/2014.
//


#import <UIKit/UIKit.h>
#import "CreateFlyerController.h"
#import "SaveFlyerCell.h"
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
#import "GADInterstitialDelegate.h"
#import "InviteForPrint.h"
#import "PrintViewController.h"
#import "UserPurchases.h"


@class SaveFlyerCell, Flyer, SigninController, RegisterController, InAppViewController, CreateFlyerController,ShareViewController,PrintViewController;

@interface FlyerlyMainScreen : ParentViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate,RMStoreObserver,InAppPurchasePanelButtonProtocol, UserPurchasesDelegate ,GADInterstitialDelegate>{

    CreateFlyerController *createFlyer;
    BOOL searching;
    BOOL lockFlyer;
    BOOL sheetAlreadyOpen;
    BOOL cancelRequest;

    SigninController *signInController;
    RegisterController *signUpController;
    ShareViewController *shareviewcontroller;
    InAppViewController *inappviewcontroller;
    UserPurchases *userPurchases;
    NSMutableArray *flyerPaths;

    NSMutableArray *searchFlyerPaths;
    NSArray *requestedProducts;
    RMStoreKeychainPersistence *_persistence;
    PrintViewController *printViewController;
    UIButton *helpButton, *backButton,*createButton;
    UIBarButtonItem *rightUndoBarButton;
}


@property(nonatomic, strong) GADInterstitial *interstitial;
@property ( nonatomic, strong ) IBOutlet UITableView *tView;
@property ( nonatomic, strong ) IBOutlet UITextField *searchTextField;
@property ( nonatomic, strong ) NSMutableArray *flyerPaths;
@property ( nonatomic, strong ) Flyer *flyer;
@property (nonatomic, strong) UIView *sharePanel;
@property (nonatomic, strong) UIAlertView *signInAlert;


-(void)goBack;
-(NSMutableArray *)getFlyersPaths;
-(IBAction)createFlyer:(id)sender;

-(void)printFlyer;
-(void)enableHome:(BOOL)enable;

@end
