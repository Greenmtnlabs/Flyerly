
//
//  Created by Riksof Pvt. Ltd. on 22/Jan/2014.
//

#import <UIKit/UIKit.h>
#import "MainSettingViewController.h"
#import "ParentViewController.h"
#import "FlyerlySingleton.h"
#import "Reachability.h"
#import "UserPurchases.h"
#import "InAppViewController.h"
#import "Flyer.h"
#import "RMStore.h"
#import "RMStoreKeychainPersistence.h"
#import "FlyerImageView.h"
#import "GADInterstitialDelegate.h"

@class FlyrViewController;
@class CreateFlyerController ;
@class InviteFriendsController;
@class InAppViewController;
@class FlyerlySingleton,SigninController;

@class MainSettingViewController,ParentViewController;

@interface FlyerlyMainScreen : ParentViewController <InAppPurchasePanelButtonProtocol, UserPurchasesDelegate ,GADInterstitialDelegate> {
    
	CreateFlyerController *createFlyer;
	FlyrViewController *tpController;
	InviteFriendsController *addFriendsController;
    FlyerlySingleton *globle;
    SigninController *signInController;
    InAppViewController *inappviewcontroller;
    UserPurchases *userPurchases;

    IBOutlet UIButton *setBotton;
    Flyer *flyer;

}

@property(nonatomic, strong) GADInterstitial *addInterstialFms;

@property(nonatomic,strong) FlyrViewController *tpController;
@property(nonatomic,strong) InviteFriendsController *addFriendsController;


@property (nonatomic, strong) IBOutlet UILabel *createFlyrLabel;
@property (nonatomic, strong) IBOutlet UILabel *savedFlyrLabel;
@property (nonatomic, strong) IBOutlet UILabel *inviteFriendLabel;

@property (nonatomic, strong) IBOutlet UIButton *createFlyrButton;
@property (nonatomic, strong) IBOutlet UIButton *savedFlyrButton;
@property (nonatomic, strong) IBOutlet UIButton *inviteFriendButton;

@property (nonatomic, strong) IBOutletCollection( UIImageView ) NSArray *flyerPreviews;
@property (nonatomic, strong) IBOutletCollection( UIButton ) NSArray *flyerButtons;

@property (nonatomic, strong) IBOutletCollection( UIActivityIndicatorView ) NSArray *activityIndicators;

@property (nonatomic, strong) NSMutableArray *recentFlyers;

-(IBAction)doNew:(id)sender;
-(IBAction)doOpen:(id)sender;
-(IBAction)doAbout:(id)sender;
-(IBAction)doInvite:(id)sender;
-(IBAction)showFlyerDetail:(UIImageView *)sender;

- (void)updateRecentFlyer:(NSMutableArray *)recentFlyers;
-(void)saveAfterTasksCheck;

@end
