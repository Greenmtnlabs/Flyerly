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




@interface LauchViewController : UIViewController {
	PhotoController *ptController;
	FlyrViewController *tpController;
	SettingViewController *spController;
	AddFriendsController *addFriendsController;
	LoadingView *loadingView;
    
    IBOutlet UILabel *createFlyrLabel;
    IBOutlet UILabel *savedFlyrLabel;
    IBOutlet UILabel *inviteFriendLabel;

    IBOutlet UIImageView *firstFlyer;
    IBOutlet UIImageView *secondFlyer;
    IBOutlet UIImageView *thirdFlyer;
    IBOutlet UIImageView *fourthFlyer;

	IBOutlet FBLoginButton *faceBookButton;
	BOOL loadingViewFlag;
}
@property(nonatomic,retain) PhotoController *ptController;
@property (nonatomic, retain) LoadingView *loadingView;
@property(nonatomic,retain) FlyrViewController *tpController;
@property(nonatomic,retain) SettingViewController *spController;
@property(nonatomic,retain) AddFriendsController *addFriendsController;
@property (nonatomic, retain) IBOutlet FBLoginButton *faceBookButton;

@property (nonatomic, retain) IBOutlet UILabel *createFlyrLabel;
@property (nonatomic, retain) IBOutlet UILabel *savedFlyrLabel;
@property (nonatomic, retain) IBOutlet UILabel *inviteFriendLabel;

@property (nonatomic, retain) IBOutlet UIImageView *firstFlyer;
@property (nonatomic, retain) IBOutlet UIImageView *secondFlyer;
@property (nonatomic, retain) IBOutlet UIImageView *thirdFlyer;
@property (nonatomic, retain) IBOutlet UIImageView *fourthFlyer;

-(IBAction)doNew:(id)sender;
-(IBAction)doOpen:(id)sender;
-(IBAction)doAbout:(id)sender;
-(IBAction)doInvite:(id)sender;
@end
