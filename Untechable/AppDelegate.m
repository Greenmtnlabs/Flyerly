
//
//  AppDelegate.m
//  Untechable
//
//  Created by RIKSOF Developer on 24/09/2014.
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "Crittercism.h"
#import "Common.h"
#import "UserPurchases.h"
#import "IntroScreenViewController.h"
#import "UntechableSingleton.h"
#import "SHKConfiguration.h"
#import "Flurry.h"


@implementation AppDelegate
@synthesize untechableConfigurator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    NSLog( @"homeDirectoryPath this will help us in finding realm file: %@", NSHomeDirectory() );
    
    // Configurator initialization
    untechableConfigurator = [[UntechableConfigurator alloc] init];
    DefaultSHKConfigurator  *configurator = untechableConfigurator;
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];
    
    UserPurchases *userPurchases = [UserPurchases getInstance];
    [userPurchases loadAllProducts:^(NSString *errorMsg){}];

    
    [Flurry startSession: FLURRY_API_KEY];
    
    [Crittercism enableWithAppID: CRITTERCISM_APP_ID];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    // Apply localization
    [self setLocalizedSpendingTimeText];
    
    // Load Intro Screen
    UINavigationController *navigationController;
    IntroScreenViewController *introScreenViewController = [[IntroScreenViewController alloc] initWithNibName:@"IntroScreenViewController" bundle:nil];
    navigationController = [[UINavigationController alloc] initWithRootViewController:introScreenViewController];
    
    self.window.rootViewController = navigationController;
    
    [self.window makeKeyAndVisible];
    return YES;
}
/**
 * This method sets Spending Time Text
 * according to the selected language of iPhone
 * and lets user added texts remains same
 */
-(void)setLocalizedSpendingTimeText{
    
    NSMutableArray *customSpendingTextArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"cutomSpendingTimeTextAry"]];

    NSMutableOrderedSet *set = [NSMutableOrderedSet orderedSetWithArray:DEF_SPENDING_TIME_ARY ];
    
    NSMutableArray *defaultSpendingTimeText = [NSMutableArray arrayWithArray:[set array]];
    
    if(customSpendingTextArray.count != 0){
        for (int i=0; i< DEF_SPENDING_TIME_ARY.count-1; i++) {
           [customSpendingTextArray replaceObjectAtIndex:i withObject: NSLocalizedString(defaultSpendingTimeText[i], nil)];
        }
    } else {
        
        [set unionSet:[NSSet setWithArray:defaultSpendingTimeText]];
        customSpendingTextArray = [NSMutableArray arrayWithArray:[set array]];
      
        for (int i=0; i<customSpendingTextArray.count; i++) {
            customSpendingTextArray[i] = NSLocalizedString(customSpendingTextArray[i], nil);
        }
    }
    
    int lastIndex = (int)customSpendingTextArray.count - 1;
    [customSpendingTextArray replaceObjectAtIndex: lastIndex withObject:NSLocalizedString(@"custom", nil)];
    
    [[NSUserDefaults standardUserDefaults] setObject:customSpendingTextArray forKey:@"cutomSpendingTimeTextAry"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

// During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.
// Override application:openURL:sourceApplication:annotation to call the FBsession object that handles the incoming URL
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    //return [FBSession.activeSession handleOpenURL:url]
    return [FBAppCall handleOpenURL:url sourceApplication:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    // Handle the user leaving the app while the Facebook login dialog is being shown
    // For example: when the user presses the iOS "home" button while the login dialog is active
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end
