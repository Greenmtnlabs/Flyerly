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
#import "Crittercism.h"
#import "BZFoursquare.h"
#import "Singleton.h"
#import <Parse/Parse.h>
#import "SHKFacebook.h"
#import "SHKConfiguration.h"
#import "MySHKConfigurator.h"


extern NSString *FlickrSharingSuccessNotification;
extern NSString *FlickrSharingFailureNotification;
extern NSString *FacebookDidLoginNotification;

@class FBSession;
@class SaveFlyerController;
@class LauchViewController;
@class AfterUpdateController;
@class AccountController;
@class Singleton;

@interface FlyrAppDelegate : UIResponder <UIApplicationDelegate> {
	UIScrollView *fontScrollView;
	UIScrollView *colorScrollView;
	UIScrollView *sizeScrollView;
	UIScrollView *templateScrollView;
         UIWindow *window;
         UINavigationController *navigationController;
	SaveFlyerController *svController;
    LauchViewController *lauchController;
    AccountController *accountController;
    Singleton *globle;
	BOOL faceBookPermissionFlag;
	BOOL changesFlag;
    BZFoursquare *foursquare_;
    id loggedInUserID;
    UIView *sharingProgressParentView;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UINavigationController *navigationController;
@property (nonatomic, strong) UIScrollView *fontScrollView;
@property (nonatomic, strong) UIScrollView *colorScrollView;
@property (nonatomic, strong) UIScrollView *sizeScrollView;
@property (nonatomic, strong) UIScrollView *templateScrollView;
@property (nonatomic, strong) SaveFlyerController *svController;
@property (nonatomic, strong) LauchViewController *lauchController;
@property (nonatomic, strong) AccountController *accountController;
@property(nonatomic,strong) BZFoursquare *foursquare;
@property (nonatomic,assign)	BOOL faceBookPermissionFlag;
@property (nonatomic,assign) BOOL changesFlag;
@property (strong, nonatomic) FBSession *session;
@property (nonatomic, strong) UIView *sharingProgressParentView;
@property (nonatomic, strong) NSString *loginId;

-(void)next;
-(void)clearCache;
-(void)FbChangeforNewVersion;
-(void)TwitterChangeforNewVersion:(NSString *)olduser;
-(void)MergeAccount:(PFObject *)oldUserobj;
- (void)setAndStoreFlickrAuthToken:(NSString *)inAuthToken secret:(NSString *)inSecret;
@end

