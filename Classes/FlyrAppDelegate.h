//
//  FlyrAppDelegate.h
//  Flyr
//
//  Created by Nilesh on 20/10/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

//#import "ARRollerView.h"
//#import "ARRollerProtocol.h"
//#import "FBPermissionDialog.h"
#import "FBConnect/FBConnect.h"
#import "TwitLogin.h"
#import <ObjectiveFlickr.h>
#import "Crittercism.h"
#import "BZFoursquare.h"

extern NSString *FlickrSharingSuccessNotification;
extern NSString *FlickrSharingFailureNotification;
extern NSString *FacebookDidLoginNotification;

@class FBSession;
@class SaveFlyerController;
@class LauchViewController;
@class AfterUpdateController;
@class AccountController;

@interface FlyrAppDelegate : NSObject <UIApplicationDelegate,OFFlickrAPIRequestDelegate> {
	UIScrollView *fontScrollView;
	UIScrollView *colorScrollView;
	UIScrollView *sizeScrollView;
	UIScrollView *templateScrollView;
         UIWindow *window;
         UINavigationController *navigationController;
	SaveFlyerController *svController;
    LauchViewController *lauchController;
    AccountController *accountController;

	TwitLogin *_tSession;
	BOOL faceBookPermissionFlag;
	BOOL changesFlag;
	OFFlickrAPIContext *flickrContext;
	OFFlickrAPIRequest *flickrRequest;
	NSString *flickrUserName;
    BZFoursquare *foursquare_;
    
    UIView *sharingProgressParentView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) UIScrollView *fontScrollView;
@property (nonatomic, retain) UIScrollView *colorScrollView;
@property (nonatomic, retain) UIScrollView *sizeScrollView;
@property (nonatomic, retain) UIScrollView *templateScrollView;
@property (nonatomic, retain) SaveFlyerController *svController;
@property (nonatomic, retain) LauchViewController *lauchController;
@property (nonatomic, retain) AccountController *accountController;
@property (nonatomic, retain) OFFlickrAPIContext *flickrContext;
@property (nonatomic, retain) OFFlickrAPIRequest *flickrRequest;

@property (strong, nonatomic) Facebook *facebook;
@property (nonatomic,retain) TwitLogin *_tSession;
@property(nonatomic,strong) BZFoursquare *foursquare;
@property (nonatomic,assign)	BOOL faceBookPermissionFlag;
@property (nonatomic,assign) BOOL changesFlag;

@property (strong, nonatomic) FBSession *session;
@property (nonatomic, retain) NSString *flickrUserName;
@property (nonatomic, retain) UIView *sharingProgressParentView;

@property (nonatomic, retain) NSString *loginId;

//@property (nonatomic, retain) FBDialog* dialog;
//@property (nonatomic,retain) FBPermissionDialog* perDialog;
//@property (nonatomic,retain) FBStreamDialog* streamDialog;
//@property (nonatomic,retain)  FBSession* _session;
//@property(nonatomic,retain) ARRollerView *adwhirl;
//@property (nonatomic, retain) NSMutableArray *templateArray;
//@property (nonatomic, retain) NSMutableArray *iconArray;
//+ (void) increaseNetworkActivityIndicator;
//+ (void) decreaseNetworkActivityIndicator;

-(void)next;
-(void)clearCache;
- (void)setAndStoreFlickrAuthToken:(NSString *)inAuthToken secret:(NSString *)inSecret;
@end

