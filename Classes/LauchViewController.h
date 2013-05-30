//
//  LauchViewController.h
//  Flyer
//
//  Created by Krunal on 13/10/09.
//  Copyright 2009 iauro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "FBConnect/FBConnect.h"

@class FlyrViewController;
@class SettingViewController;
@class PhotoController ;
@class AddFriendsController;
@class LoadingView;
@class FBSession;
@class FacebookLikeView;

@interface LauchViewController : UIViewController<FBDialogDelegate,FBSessionDelegate,FBRequestDelegate> {
	PhotoController *ptController;
	FlyrViewController *tpController;
	SettingViewController *spController;
	AddFriendsController *addFriendsController;
	LoadingView *loadingView;
    
    IBOutlet UILabel *createFlyrLabel;
    IBOutlet UILabel *savedFlyrLabel;
    IBOutlet UILabel *inviteFriendLabel;

    IBOutlet UIButton *createFlyrButton;
    IBOutlet UIButton *savedFlyrButton;
    IBOutlet UIButton *inviteFriendButton;

    IBOutlet UIButton *likeButton;
    IBOutlet UIButton *followButton;
    
    IBOutlet UIImageView *firstFlyer;
    IBOutlet UIImageView *secondFlyer;
    IBOutlet UIImageView *thirdFlyer;
    IBOutlet UIImageView *fourthFlyer;
    IBOutlet UIImageView *fifthFlyer;
    IBOutlet UIImageView *sixthFlyer;

    IBOutlet FacebookLikeView *facebookLikeView;
    
	//IBOutlet FBLoginButton *faceBookButton;
	BOOL loadingViewFlag;
	NSMutableArray *photoArray;
	NSMutableArray *photoDetailArray;
    int numberOfFlyers;
    
    UIView *opaqueView;
    UIWebView *webview;
    UIButton *crossButton;
}
@property(nonatomic,retain) PhotoController *ptController;
@property (nonatomic, retain) LoadingView *loadingView;
@property(nonatomic,retain) FlyrViewController *tpController;
@property(nonatomic,retain) SettingViewController *spController;
@property(nonatomic,retain) AddFriendsController *addFriendsController;
//@property (nonatomic, retain) IBOutlet FBLoginButton *faceBookButton;

@property (nonatomic, retain) IBOutlet UILabel *createFlyrLabel;
@property (nonatomic, retain) IBOutlet UILabel *savedFlyrLabel;
@property (nonatomic, retain) IBOutlet UILabel *inviteFriendLabel;

@property (nonatomic, retain) IBOutlet UIButton *createFlyrButton;
@property (nonatomic, retain) IBOutlet UIButton *savedFlyrButton;
@property (nonatomic, retain) IBOutlet UIButton *inviteFriendButton;

@property (nonatomic, retain) IBOutlet UIButton *likeButton;
@property (nonatomic, retain) IBOutlet UIButton *followButton;

@property (nonatomic, retain) IBOutlet UIImageView *firstFlyer;
@property (nonatomic, retain) IBOutlet UIImageView *secondFlyer;
@property (nonatomic, retain) IBOutlet UIImageView *thirdFlyer;
@property (nonatomic, retain) IBOutlet UIImageView *fourthFlyer;
@property (nonatomic, retain) IBOutlet UIImageView *fifthFlyer;
@property (nonatomic, retain) IBOutlet UIImageView *sixthFlyer;
@property(nonatomic,retain) NSMutableArray *photoArray;
@property(nonatomic,retain) NSMutableArray *photoDetailArray;
@property (nonatomic, retain) IBOutlet FacebookLikeView *facebookLikeView;

-(IBAction)doNew:(id)sender;
-(IBAction)doOpen:(id)sender;
-(IBAction)doAbout:(id)sender;
-(IBAction)doInvite:(id)sender;
-(IBAction)showFlyerDetail:(UIImageView *)sender;
- (IBAction)showLikeButton;
- (IBAction)followOnTwitter:(id)sender;

@end
