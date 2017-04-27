//
//  FlyrAppDelegate.h
//  Flyr
//
//  Developed by RIKSOF (Private) Limited
//  Copyright Flyerly. All rights reserved.
//

#import "FlyerlySingleton.h"
#import "FlyerUser.h"
#import "Crittercism.h"
#import "Common.h"
#import "CreateFlyerController.h"
#import <QuartzCore/QuartzCore.h>
#import "FlyerlyMainScreen.h"
#import "AfterUpdateController.h"
#import "LaunchController.h"
#import "ShareViewController.h"
#import "Flurry.h"
#import "SHKConfiguration.h"
#import "FlyerlyConfigurator.h"
#import "MainSettingViewController.h"
#import "BitlyConfig.h"
#import "FlyerUser.h"
#import "RMStore.h"
#import "UserPurchases.h"
#import "RMStoreKeychainPersistence.h"


extern NSString *FacebookDidLoginNotification;

@class FlyerlyMainScreen;
@class AfterUpdateController;
@class LaunchController;

@interface FlyrAppDelegate : UIResponder <UIApplicationDelegate>


@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UINavigationController *navigationController;


@property (nonatomic, strong) FlyerlyMainScreen *lauchController;
@property (nonatomic, strong) LaunchController *accountController;
@property (nonatomic, strong) FlyerlyConfigurator *flyerConfigurator;

@property (nonatomic, strong) UIView *sharingProgressParentView;
@property (nonatomic, strong) RMStoreKeychainPersistence *_persistence;

-(void)fbChangeforNewVersion;
-(void)twitterChangeforNewVersion:(NSString *)olduser;
-(void)copyUsersDataForTesting;

-(void)endAppBgTask;

@end

