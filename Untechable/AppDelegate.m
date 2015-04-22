//
//  AppDelegate.m
//  Untechable
//
//  Created by ABDUL RAUF on 24/09/2014.
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "UntechableListController/UntechablesList.h"
#import "AddUntechableController.h"
#import "Common.h"
#import "Crittercism.h"
#import "NameAndPhoneCellView.h"

@implementation AppDelegate

Untechable *untechable;
NSMutableArray *allUntechables;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Crittercism enableWithAppID: CRITTERCISM_APP_ID];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self setDefaultModel];
    
    [self.window makeKeyAndVisible];
    return YES;

}

/*
 Variable we must need in model, for testing we can use these vars
 */
-(void) configureTestData
{
    untechable.userId   = TEST_UID;
    //untechable.eventId = TEST_EID;
    //untechable.twillioNumber = TEST_TWILLIO_NUM;
    //untechable.twillioNumber = @"123";
}

#pragma mark -  Model funcs
// set default vaules in model
-(void)setDefaultModel{
    
    //init object
    untechable  = [[Untechable alloc] init];
    untechable.commonFunctions = [[CommonFunctions alloc] init];
    
    //For testing -------- { --
    [self configureTestData];
    //For testing -------- } --
    
    UINavigationController *navigationController;
    
    allUntechables = [untechable.commonFunctions getAllUntechables:untechable.userId];
    //check wheter untechables are already added, if not then go to add untechable screen
    // else show untechable list..
    if ( allUntechables.count <= 0 ){

        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"Enter Your Name and Number"
                                                        delegate:self
                                               cancelButtonTitle:@"Done"
                                               otherButtonTitles:nil, nil];
        
        
        alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        UITextField * alertTextField1 = [alert textFieldAtIndex:0];
        alertTextField1.keyboardType = UIKeyboardTypeTwitter;
        alertTextField1.placeholder = @"Name";
        
        UITextField * alertTextField2 = [alert textFieldAtIndex:1];
        alertTextField2.secureTextEntry=NO;
        alertTextField2.keyboardType = UIKeyboardTypeNumberPad;
        alertTextField2.placeholder = @"Phone Number";
        
        [alert show];
        
    } else {
        
    UntechablesList *mainViewController = [[UntechablesList alloc] initWithNibName:@"UntechablesList" bundle:nil];
    navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
        
    }
    self.window.rootViewController = navigationController;
}

/**
 Action catch for the uiAlertview buttons
 we have to save name and phone number on button press
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    untechable  = [[Untechable alloc] init];
    untechable.commonFunctions = [[CommonFunctions alloc] init];
     UINavigationController *navigationController;
    //For testing -------- { --
    [self configureTestData];
    //For testing -------- } --
    AddUntechableController *mainViewController = [[AddUntechableController alloc] initWithNibName:@"AddUntechableController" bundle:nil];
        mainViewController.untechable = untechable;
        navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    
        //getting text from the text fields
        NSString *name = [alertView textFieldAtIndex:0].text;
        NSString *phoneNumber = [alertView textFieldAtIndex:1].text;
    
        NameAndPhoneCellView *nameAndPhoneObj = [[ NameAndPhoneCellView alloc] init];
    
        //setting the name in model
        [nameAndPhoneObj setUserName:name];
    
        //setting the phone number in model
        [nameAndPhoneObj setPhoneNumber:phoneNumber];
    
        self.window.rootViewController = navigationController;
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
    return [FBSession.activeSession handleOpenURL:url];
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
