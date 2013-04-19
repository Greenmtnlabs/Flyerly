//
//  FlyrAppDelegate.h
//  Flyr
//
//  Created by Nilesh on 20/10/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

//#import "ARRollerView.h"
//#import "ARRollerProtocol.h"
#import "FBConnect/FBConnect.h"
@class FBSession;
#import "TwitLogin.h"
#import "FBPermissionDialog.h"


@class SaveFlyerController;
@class LauchViewController;
@class AfterUpdateController;

@interface FlyrAppDelegate : NSObject <UIApplicationDelegate> {
//@interface FlyrAppDelegate : NSObject <UIApplicationDelegate,ARRollerDelegate> {
	UIScrollView *fontScrollView;
	UIScrollView *colorScrollView;
	UIScrollView *sizeScrollView;
	UIScrollView *templateScrollView;
         UIWindow *window;
         UINavigationController *navigationController;
	SaveFlyerController *svController;
	//NSMutableArray *templateArray;
	//NSMutableArray *iconArray;
	FBDialog* dialog;
	FBPermissionDialog* perDialog;
	FBStreamDialog* streamDialog;
	FBSession* _session;
	TwitLogin *_tSession;
	BOOL faceBookPermissionFlag;
	BOOL changesFlag;
	//ARRollerView *adwhirl;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) UIScrollView *fontScrollView;
@property (nonatomic, retain) UIScrollView *colorScrollView;
@property (nonatomic, retain) UIScrollView *sizeScrollView;
@property (nonatomic, retain) UIScrollView *templateScrollView;
@property (nonatomic, retain) SaveFlyerController *svController;
@property (nonatomic, retain) FBDialog* dialog;
@property (nonatomic,retain) FBPermissionDialog* perDialog;
@property (nonatomic,retain) FBStreamDialog* streamDialog;
@property (nonatomic,retain)  FBSession* _session;
@property (nonatomic,retain) TwitLogin *_tSession;
@property (nonatomic,assign)	BOOL faceBookPermissionFlag;
@property (nonatomic,assign) BOOL changesFlag;
//@property(nonatomic,retain) ARRollerView *adwhirl;
-(void)next;
//@property (nonatomic, retain) NSMutableArray *templateArray;
//@property (nonatomic, retain) NSMutableArray *iconArray;
-(void)clearCache;
//+ (void) increaseNetworkActivityIndicator;
//+ (void) decreaseNetworkActivityIndicator;
@end

