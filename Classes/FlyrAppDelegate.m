//
//  FlyrAppDelegate.h
//  Flyr
//
//  Developed by RIKSOF (Private) Limited
//  Copyright Flyerly. All rights reserved.
//

#import "FlyrAppDelegate.h"
#import "PaypalMobile.h"
#import "LobRequest.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>

NSString *kCheckTokenStep1 = @"kCheckTokenStep";
NSString *FlickrSharingSuccessNotification = @"FlickrSharingSuccessNotification";
NSString *FlickrSharingFailureNotification = @"FlickrSharingFailureNotification";
NSString *FacebookDidLoginNotification = @"FacebookDidLoginNotification";

#define TIME 10

@implementation FlyrAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize  lauchController,accountController,flyerConfigurator;
@synthesize sharingProgressParentView,_persistence;


#pragma mark Application lifecycle
/* 
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self goingToBg];
    });
}
 */

- (void)applicationWillResignActive:(UIApplication *)application {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [self goingToBg];
    });
}

-(void)goingToBg
{
    if ([[self.navigationController topViewController] isKindOfClass:[CreateFlyerController class]]) {
        
        //Here we Save Data for Future Error Handling
        NSArray *views = [self.navigationController viewControllers];
        CreateFlyerController *createView;
        
        for (int i =0 ; i <views.count; i++) {
            
            if ([[views objectAtIndex:i] isKindOfClass:[CreateFlyerController class]]) {
                createView = [views objectAtIndex:i];
            }
        }
        
        //Save On background Mode
        // Here we Save Flyer Info
        [createView.flyer saveFlyer];
        
        //Here we Create One History BackUp for Future Undo Request
        [createView.flyer addToHistory];
        
        //Here we Merge Video for Sharing
        if ([createView.flyer isVideoFlyer]) {
            
            //Here Compare Current Flyer with history Flyer
            if ([createView.flyer isVideoMergeProcessRequired]) {
                    //Here we Merge All Layers in Video File
                    [createView videoMergeProcess];
            }
            
        }else {
                //Here we remove Borders from layer if user touch any layer
                [createView.flyimgView layerStoppedEditing:createView.currentLayer];
                
                //Here we take Snap shot of Flyer and
                //Flyer Add to Gallery if user allow to Access there photos
                [createView.flyer setUpdatedSnapshotWithImage:[createView getFlyerSnapShot]];
        }
    }

}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    // handler code here
    if (!url) {
        return NO;
    }
    
    NSString *URLString = [url absoluteString];
    [[NSUserDefaults standardUserDefaults] setObject:URLString forKey:@"url"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [SHKFacebook handleDidBecomeActive];
}



- (void)applicationWillTerminate:(UIApplication *)application
{
    // Save data if appropriate
    [SHKFacebook handleWillTerminate];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[@"global"];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    return [PFFacebookUtils handleOpenURL:url];
    
    if ([[url absoluteString] hasPrefix:[NSString stringWithFormat:@"fb%@", SHKCONFIG(facebookAppId)]]) {
        [SHKFacebook handleOpenURL:url];
        [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
        return YES;
    }
    
    if([[url absoluteString] hasPrefix:kCallbackURLBaseStringPrefix]){
        return YES;
    } else {
  
        return nil;
        
    }
}

/**
 * Application bring up.
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _persistence = [[RMStoreKeychainPersistence alloc] init];
    [RMStore defaultStore].transactionPersistor = _persistence;
    
    /* Uncomment this line if you want to remove transactions from the phone.
    [_persistence removeTransactions];
    */
    
    // Configurator initialization
    flyerConfigurator = [[FlyerlyConfigurator alloc] init];
    DefaultSHKConfigurator  *configurator = flyerConfigurator;
    
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];

    // Crittercism for crash reports.
    [Crittercism enableWithAppID:[flyerConfigurator crittercismAppId]];
    
    // Setup paypal
    [PayPalMobile initializeWithClientIdsForEnvironments:
     @{[flyerConfigurator paypalEnvironment] : [flyerConfigurator paypalEnvironmentId]}];
    
    [PayPalMobile preconnectWithEnvironment:[flyerConfigurator paypalEnvironment]];
    
    [LobRequest initWithAPIKey:[flyerConfigurator lobAppId]];
    
    //-- Set Notification
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    
#ifdef DEBUG
    
    // Setup parse Offline ozair's account
    [Parse setApplicationId:[flyerConfigurator parseOfflineAppId]
                  clientKey:[flyerConfigurator parseOfflineClientKey]];
#else
    
    // Setup parse Online
    [Parse setApplicationId:[flyerConfigurator parseOnlineAppId]
                  clientKey:[flyerConfigurator parseOnlineClientKey]];
    
#endif
  
    // Flurry stats
    [Flurry startSession:[flyerConfigurator flurrySessionId]];

    // Facebook initialization
    [PFFacebookUtils initializeFacebook];
    
    // Twitter Initialization
    [PFTwitterUtils initializeWithConsumerKey:[flyerConfigurator twitterConsumerKey] consumerSecret:[flyerConfigurator twitterSecret]];
    
    // Bitly configuration
    [[BitlyConfig sharedBitlyConfig] setBitlyLogin:[flyerConfigurator bitLyLogin] bitlyAPIKey:[flyerConfigurator bitLyKey]];

    //This is For remove Notification
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    // This flag represents the condition whether application setting has been altered first time
    // after installing app
    if( ![[NSUserDefaults standardUserDefaults] stringForKey:@"saveToCameraRollSettingFlag"] ){
        [[NSUserDefaults standardUserDefaults] setObject:@"enabled" forKey:@"saveToCameraRollSettingFlag"];
        [[NSUserDefaults standardUserDefaults] setObject:@"enabled" forKey:@"saveToCameraRollSetting"];
    }

    if( ![[NSUserDefaults standardUserDefaults] stringForKey:@"cameraSetting"] ){
        [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"cameraSetting"];
    }

    // We allow anonymous Parse users, so a new user doesn't necessarily have to signup/signin
    [PFUser enableAutomaticUser];
    
    // Then we create a directory for anonymous users data
    NSString *homeDirectoryPath = NSHomeDirectory();
    NSString *anonymousUserPath = [homeDirectoryPath stringByAppendingString:[NSString stringWithFormat:@"/Documents"]];
    NSArray *contentOfDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:anonymousUserPath error:NULL];
    
    NSError *error;
    if ( contentOfDirectory.count == 0 ) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[anonymousUserPath stringByAppendingString:@"/anonymous"] withIntermediateDirectories:YES attributes:nil error:&error];
        
        // Now check contents of document directory again
        contentOfDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:anonymousUserPath error:NULL];
    }

    // If the Documents folder has only one directory named anonymous then this is an anonymous user (hasn't signed up yet)
    if(contentOfDirectory.count  > 0 && [[contentOfDirectory objectAtIndex:0] isEqual:@"anonymous"]){
        
        // This is an anonymous user
        [PFUser currentUser].username = @"anonymous";
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"UpdatedVersion"];
        
        lauchController = [[FlyerlyMainScreen alloc]initWithNibName:@"FlyerlyMainScreen" bundle:nil];
        [navigationController setRootViewController:lauchController];
        
    // Otherwise we have an already logged in user
    } else if ([[NSUserDefaults standardUserDefaults] stringForKey:@"User"] != nil ){
        
        
        
        // If user has already updated to 4.0, the flow is normal
        if([[NSUserDefaults standardUserDefaults] stringForKey:@"UpdatedVersion"]){
            
            lauchController = [[FlyerlyMainScreen alloc]initWithNibName:@"FlyerlyMainScreen" bundle:nil];
            [navigationController setRootViewController:lauchController];
        
        // Otherwise this is the first time user has updated to 4.0
        } else {
         
            // Log out User.
            [MainSettingViewController signOut];
            
            //its for remember key of user have Updated Version
            [[NSUserDefaults standardUserDefaults] setObject:@"enabled" forKey:@"UpdatedVersion"];
            accountController = [[LaunchController alloc]initWithNibName:@"LaunchController" bundle:nil];
            [navigationController setRootViewController:accountController];

            
        }
    // A use signed up on this device but is currently not logged in
    } else if (contentOfDirectory.count > 0
               && !([[contentOfDirectory objectAtIndex:0] isEqual:@"anonymous"])) {
        
        accountController = [[LaunchController alloc]initWithNibName:@"LaunchController" bundle:nil];
        [navigationController setRootViewController:accountController];
        
    }
           
    // HERE WE SET ALL FLYER ARE PUBLIC DEFUALT
    if(![[NSUserDefaults standardUserDefaults] stringForKey:@"FlyerlyPublic"]){
        [[NSUserDefaults standardUserDefaults]  setObject:@"Public" forKey:@"FlyerlyPublic"];
    }
    [window  setRootViewController:navigationController];
    
    // Override point for customization after application launch.
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];

	[window makeKeyAndVisible];
    
    return YES;
}

/*
 For Checking Twitter old Detail is available in parse or not
 if it exist then we call Merging Process
*/
-(void)twitterChangeforNewVersion:(NSString *)olduser{

    [lauchController showLoadingIndicator];

    if ([PFUser currentUser] != nil) {
    //Checking user Exist in Parse
    PFQuery *query = [PFUser  query];
    [query whereKey:@"username" equalTo:[olduser lowercaseString]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        
        if (error) {
            [lauchController hideLoadingIndicator];
            
        }else{
            
            // Migrate Account For 3.0 Version
            [FlyerUser migrateUserto3dot0:object];
            
            //Getting Recent Flyers
            lauchController.recentFlyers = [Flyer recentFlyerPreview:4];
            
            //Set Recent Flyers
            [lauchController updateRecentFlyer:lauchController.recentFlyers];
            [lauchController hideLoadingIndicator];
            
        }
    }];
    }


}


/*
Here we Getting user Email ID from Currently login facebook ID
For Checking old Detail is available in parse or not
if it exist then we call Merging Process
*/
-(void)fbChangeforNewVersion{
    
    [lauchController showLoadingIndicator];

    // Create request for user's Facebook data
    FBRequest *request = [FBRequest requestForMe];
    
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            NSString *email = userData[@"email"];

            //Checking Email Exist in Parse
            PFQuery *query = [PFUser  query];
            [query whereKey:@"email" equalTo:email];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
                if (error) {
                    
                    [lauchController hideLoadingIndicator];

                }else{
                    
                    // Migrate Account For 3.0 Version
                    [FlyerUser migrateUserto3dot0:object];
                    
                    //Getting Recent Flyers
                    
                    lauchController.recentFlyers = [Flyer recentFlyerPreview:4];
                    
                    //Set Recent Flyers
                    [lauchController updateRecentFlyer:lauchController.recentFlyers];
                    [lauchController hideLoadingIndicator];
                    
                }
            }];
        }
    }];
}


/*
 * Here we Copy Data on Device For Testing Merge User Process
 */
-(void)copyUsersDataForTesting {
    
    //Getting Home Directory
	NSString *homeDirectoryPath = NSHomeDirectory();
	NSString *docPath = [homeDirectoryPath stringByAppendingString:@"/Documents"];

    
    //Here we Copy Default Directory From Resource Bundle
    [self copyDirectory:docPath];
    
    //its for remember key of user Data already copy to Device
    [[NSUserDefaults standardUserDefaults] setObject:@"enabled" forKey:@"userDataExist"];
    
    NSLog(@"User Data Copied Successfully");


}



/*
 * Here we Copy User Bundle from Resource Bundle
 */
-(void) copyDirectory:(NSString *)directory {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSString *documentDBFolderPath = directory;
    NSString *resourceDBFolderPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/UsersData"];
    
    if (![fileManager fileExistsAtPath:documentDBFolderPath]) {
        //Create Directory!
        [fileManager createDirectoryAtPath:documentDBFolderPath withIntermediateDirectories:NO attributes:nil error:&error];
    } else {
        //NSLog(@"Directory exists! %@", documentDBFolderPath);
    }
    
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:resourceDBFolderPath error:&error];
    
    for (NSString *s in fileList) {
        
        NSString *newFilePath = [documentDBFolderPath stringByAppendingPathComponent:s];
        NSString *oldFilePath = [resourceDBFolderPath stringByAppendingPathComponent:s];
        
        if (![fileManager fileExistsAtPath:newFilePath]) {
            
            //File does not exist, copy it
            [fileManager copyItemAtPath:oldFilePath toPath:newFilePath error:&error];
            
        } else {
            //NSLog(@"File exists: %@", newFilePath);
        }
    }
    
}



@end

