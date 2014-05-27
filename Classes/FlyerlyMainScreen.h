
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

//@class SigninController;
@class FlyrViewController;
@class CreateFlyerController ;
@class InviteFriendsController;
@class InAppViewController;
@class FlyerlySingleton,SigninController;

@class MainSettingViewController,ParentViewController;

@interface FlyerlyMainScreen : ParentViewController <InAppPurchasePanelButtonProtocol, UserPurchasesDelegate> {
    
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

@property(nonatomic,strong) FlyrViewController *tpController;
@property(nonatomic,strong) InviteFriendsController *addFriendsController;


@property (nonatomic, strong) IBOutlet UILabel *createFlyrLabel;
@property (nonatomic, strong) IBOutlet UILabel *savedFlyrLabel;
@property (nonatomic, strong) IBOutlet UILabel *inviteFriendLabel;

@property (nonatomic, strong) IBOutlet UIButton *createFlyrButton;
@property (nonatomic, strong) IBOutlet UIButton *savedFlyrButton;
@property (nonatomic, strong) IBOutlet UIButton *inviteFriendButton;

@property (nonatomic, strong) IBOutlet UIImageView *firstFlyer;
@property (nonatomic, strong) IBOutlet UIImageView *secondFlyer;
@property (nonatomic, strong) IBOutlet UIImageView *thirdFlyer;
@property (nonatomic, strong) IBOutlet UIImageView *fourthFlyer;

@property (nonatomic, strong) IBOutlet UIButton *firstFlyerButton;
@property (nonatomic, strong) IBOutlet UIButton *secondFlyerButton;
@property (nonatomic, strong) IBOutlet UIButton *thirdFlyerButton;
@property (nonatomic, strong) IBOutlet UIButton *fourthFlyerButton;


@property (nonatomic, strong) NSMutableArray *recentFlyers;
@property (nonatomic, assign) BOOL showIndicators;
@property (nonatomic, strong)UIActivityIndicatorView *uiBusy1;
@property (nonatomic, strong)UIActivityIndicatorView *uiBusy2;
@property (nonatomic, strong)UIActivityIndicatorView *uiBusy3;
@property (nonatomic, strong)UIActivityIndicatorView *uiBusy4;



-(IBAction)doNew:(id)sender;
-(IBAction)doOpen:(id)sender;
-(IBAction)doAbout:(id)sender;
-(IBAction)doInvite:(id)sender;
-(IBAction)showFlyerDetail:(UIImageView *)sender;

- (void)updateRecentFlyer:(NSMutableArray *)recentFlyers;

@end
