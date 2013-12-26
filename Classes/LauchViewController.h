//
//  LauchViewController.h
//  Flyer
//
//  Created by Krunal on 13/10/09.
//  Copyright 2009 iauro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainSettingViewController.h"
#import "ParentViewController.h"
@class FlyrViewController;
@class SettingViewController;
@class PhotoController ;
@class AddFriendsController;
@class FBSession;
@class FacebookLikeView;
@class MainSettingViewController;


@interface LauchViewController : ParentViewController<UIWebViewDelegate,UIActionSheetDelegate> {
	PhotoController *ptController;
	FlyrViewController *tpController;
	SettingViewController *spController;
	AddFriendsController *addFriendsController;
    
    IBOutlet UILabel *createFlyrLabel;
    IBOutlet UILabel *savedFlyrLabel;
    IBOutlet UILabel *inviteFriendLabel;
    IBOutlet UIButton *createFlyrButton;
    IBOutlet UIButton *savedFlyrButton;
    IBOutlet UIButton *inviteFriendButton;
        IBOutlet UIButton *likeButton;
    IBOutlet UIButton *followButton;
    IBOutlet UIButton *setBotton;

    IBOutlet UIImageView *firstFlyer;
    IBOutlet UIImageView *secondFlyer;
    IBOutlet UIImageView *thirdFlyer;
    IBOutlet UIImageView *fourthFlyer;
    
    IBOutlet UIView *likeView;
    IBOutlet FacebookLikeView *facebookLikeView;
    
	//IBOutlet FBLoginButton *faceBookButton;
	BOOL loadingViewFlag;
	NSMutableArray *photoArray;
	NSMutableArray *photoDetailArray;
    int numberOfFlyers;
    
    UIView *opaqueView;
    IBOutlet UIWebView *webview;
    IBOutlet UIButton *crossButton;
    
    NSArray *arrayOfAccounts;
}
@property(nonatomic,strong) PhotoController *ptController;
@property(nonatomic,strong) FlyrViewController *tpController;
@property(nonatomic,strong) SettingViewController *spController;
@property(nonatomic,strong) AddFriendsController *addFriendsController;

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
-(void)loadMasterSetting;
- (void)fbDidLogin;
@end
