//
//  FlyrAppDelegate.h
//  Flyr
//
//  Developed by RIKSOF (Private) Limited
//  Copyright Flyerly. All rights reserved.
//

#import "FlyerlySingleton.h"
#import <Parse/Parse.h>
#import "FlyerUser.h"
#import "Crittercism.h"
#import "Common.h"
#import "CreateFlyerController.h"
#import <QuartzCore/QuartzCore.h>
#import "LauchViewController.h"
#import "AfterUpdateController.h"
#import "AccountController.h"
#import "ShareViewController.h"
#import "Flurry.h"
#import "SHKConfiguration.h"
#import "FlyerlyConfigurator.h"
#import "BitlyConfig.h"
#import "FlyerUser.h"

extern NSString *FacebookDidLoginNotification;

@class SaveFlyerController;
@class LauchViewController;
@class AfterUpdateController;
@class AccountController;

@interface FlyrAppDelegate : UIResponder <UIApplicationDelegate> {
	UIScrollView *fontScrollView;
	UIScrollView *colorScrollView;
	UIScrollView *sizeScrollView;
	SaveFlyerController *svController;
    LauchViewController *lauchController;
    AccountController *accountController;
	BOOL faceBookPermissionFlag;
	BOOL changesFlag;
    UIView *sharingProgressParentView;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UINavigationController *navigationController;
@property (nonatomic, strong) UIScrollView *fontScrollView;
@property (nonatomic, strong) UIScrollView *colorScrollView;
@property (nonatomic, strong) UIScrollView *sizeScrollView;
@property (nonatomic, strong) SaveFlyerController *svController;
@property (nonatomic, strong) LauchViewController *lauchController;
@property (nonatomic, strong) AccountController *accountController;
@property (nonatomic,assign)	BOOL faceBookPermissionFlag;
@property (nonatomic,assign) BOOL changesFlag;
@property (nonatomic, strong) UIView *sharingProgressParentView;

-(void)FbChangeforNewVersion;
-(void)TwitterChangeforNewVersion:(NSString *)olduser;
@end

