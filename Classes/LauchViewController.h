
//
//  Created by Riksof Pvt. Ltd. on 22/Jan/2014.
//

#import <UIKit/UIKit.h>
#import "MainSettingViewController.h"
#import "ParentViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FacebookLikeView.h"
#import "FlyerlySingleton.h"
#import "Reachability.h"
#import "Flyer.h"
#import "FlyerImageView.h"

@class FlyrViewController;
@class ShareSettingViewController;
@class CreateFlyerController ;
@class InviteFriendsController;
@class FBSession;
@class FacebookLikeView;
@class MainSettingViewController;


@interface LauchViewController : ParentViewController<UIWebViewDelegate,UIActionSheetDelegate,FacebookLikeViewDelegate> {
    
	CreateFlyerController *createFlyer;
	FlyrViewController *tpController;
	ShareSettingViewController *spController;
	InviteFriendsController *addFriendsController;
    FlyerlySingleton *globle;
    
    IBOutlet UIButton *likeButton;
    IBOutlet UIButton *followButton;
    IBOutlet UIButton *setBotton;
    
	BOOL loadingViewFlag;
	NSMutableArray *photoArray;
	NSMutableArray *photoDetailArray;
    int numberOfFlyers;
    
    
    UIView *opaqueView;
    NSArray *twtAcconts;
    Flyer *flyer;
    NSMutableArray *recentFlyers;

}

@property(nonatomic,strong) FlyrViewController *tpController;
@property(nonatomic,strong) ShareSettingViewController *spController;
@property(nonatomic,strong) InviteFriendsController *addFriendsController;

@property (nonatomic, strong) IBOutlet UILabel *createFlyrLabel;
@property (nonatomic, strong) IBOutlet UILabel *savedFlyrLabel;
@property (nonatomic, strong) IBOutlet UILabel *inviteFriendLabel;

@property (nonatomic, strong) IBOutlet UIButton *createFlyrButton;
@property (nonatomic, strong) IBOutlet UIButton *savedFlyrButton;
@property (nonatomic, strong) IBOutlet UIButton *inviteFriendButton;

@property (nonatomic, strong) IBOutlet UIButton *likeButton;
@property (nonatomic, strong) IBOutlet UIButton *followButton;

@property (nonatomic, strong) IBOutlet UIImageView *firstFlyer;
@property (nonatomic, strong) IBOutlet UIImageView *secondFlyer;
@property (nonatomic, strong) IBOutlet UIImageView *thirdFlyer;
@property (nonatomic, strong) IBOutlet UIImageView *fourthFlyer;
@property(nonatomic,strong) NSMutableArray *photoArray;
@property(nonatomic,strong) NSMutableArray *photoDetailArray;

@property (nonatomic, strong) IBOutlet UIView *likeView;
@property (nonatomic, strong) IBOutlet FacebookLikeView *facebookLikeView;
@property (nonatomic, strong) IBOutlet UIWebView *webview;

-(IBAction)doNew:(id)sender;
-(IBAction)doOpen:(id)sender;
-(IBAction)doAbout:(id)sender;
-(IBAction)doInvite:(id)sender;
-(IBAction)showFlyerDetail:(UIImageView *)sender;
- (IBAction)showLikeButton;
- (IBAction)onTwitter:(id)sender;
-(IBAction)goBack;

- (void)updateRecentFlyer:(NSMutableArray *)recentFlyers;
- (void)setFacebookLikeStatus;
@end
