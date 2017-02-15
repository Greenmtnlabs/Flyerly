//
//  FlyrAppDelegate.h
//  Flyr
//
//  Developed by RIKSOF (Private) Limited
//  Copyright Flyerly. All rights reserved.
//

#import "FlyrAppDelegate.h"
#import "PaypalMobile.h"
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

NSString *kCheckTokenStep1 = @"kCheckTokenStep";
NSString *FlickrSharingSuccessNotification = @"FlickrSharingSuccessNotification";
NSString *FlickrSharingFailureNotification = @"FlickrSharingFailureNotification";
NSString *FacebookDidLoginNotification = @"FacebookDidLoginNotification";

#define TIME 10
@implementation FlyrAppDelegate {
    UIApplication *app;
    UIBackgroundTaskIdentifier bgTask;
}

@synthesize window;
@synthesize navigationController;
@synthesize  lauchController,accountController,flyerConfigurator;
@synthesize sharingProgressParentView,_persistence;


#pragma mark Application lifecycle
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    app = application;
    bgTask = [app beginBackgroundTaskWithName:@"MyTask" expirationHandler:^{
        // Clean up any unfinished task business by marking where you
        // stopped or ending the task outright.
        
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         [self goingToBg];
    });
    
    NSLog(@"backgroundTimeRemaining: %f", [[UIApplication sharedApplication] backgroundTimeRemaining]);
}

-(void)endAppBgTask
{
    [app endBackgroundTask:bgTask];
    bgTask = UIBackgroundTaskInvalid;
}

/**
 * Perform task when app going to background
 */
-(void)goingToBg {
    
    if ([[self.navigationController topViewController] isKindOfClass:[CreateFlyerController class]]) {
        
        //Here we Save Data for Future Error Handling
        NSArray *views = [self.navigationController viewControllers];
        CreateFlyerController *createView;
        
        for (int i =0 ; i <views.count; i++) {
            
            if ([[views objectAtIndex:i] isKindOfClass:[CreateFlyerController class]]) {
                createView = [views objectAtIndex:i];
            }
        }

        //When flyer is picture flyer
        if ([createView.flyer isVideoFlyer] == NO) {
            if( [createView.flyer isSaveRequired] == YES ) {

                // Here we Save Flyer Info
                [createView.flyer saveFlyer];
                
                //Here we Create One History BackUp for Future Undo Request
                [createView.flyer addToHistory];
                
                [createView.flyer isVideoMergeProcessRequired];
                
                //Here we remove Borders from layer if user touch any layer
                [createView.flyimgView layerStoppedEditing:createView.currentLayer];
                
                //Here we take Snap shot of Flyer and
                //Flyer Add to Gallery if user allow to Access there photos
                [createView.flyer setUpdatedSnapshotWithImage:[createView getFlyerSnapShot]];

                [createView.flyer saveIntoGallery];
            }
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
    //[SHKFacebook handleDidBecomeActive];
    [FBSDKAppEvents activateApp];
}



- (void)applicationWillTerminate:(UIApplication *)application
{
    // Save data if appropriate
    //[SHKFacebook handleWillTerminate];
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
    //[PFPush handlePush:userInfo];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    NSLog(@"[url absoluteString] = %@", [url absoluteString]);
    
    //if ([[url absoluteString] hasPrefix:[NSString stringWithFormat:@"fb%@://bridge/share",SHKCONFIG(facebookAppId)]]) {
        return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    //}
    
//    if ([[url absoluteString] hasPrefix:[NSString stringWithFormat:@"fb%@", SHKCONFIG(facebookAppId)]]) {
//        
//       //return One of the handled URL
//        return [FBAppCall handleOpenURL:url
//                      sourceApplication:sourceApplication
//                            withSession:[PFFacebookUtils session]] || [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
//    }
//    
//    if([[url absoluteString] hasPrefix:kCallbackURLBaseStringPrefix]){
//        return YES;
//    } else {
//  
//        return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
//    }
    
}

/**
 * Application bring up.
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"Selected Target = %@", APP_NAME);
    
    _persistence = [[RMStoreKeychainPersistence alloc] init];
    [RMStore defaultStore].transactionPersistor = _persistence;
    
    /* Uncomment this line if you want to remove transactions from the phone.
    [_persistence removeTransactions];
    */
    
    // Configurator initialization
    flyerConfigurator = [[FlyerlyConfigurator alloc] init];
//    DefaultSHKConfigurator  *configurator = flyerConfigurator;
//    
//    [SHKConfiguration sharedInstanceWithConfigurator:configurator];

    // Crittercism for crash reports.
    [Crittercism enableWithAppID:[flyerConfigurator crittercismAppId]];
    
//    // Setup paypal
//    [PayPalMobile initializeWithClientIdsForEnvironments:
//     @{[flyerConfigurator paypalEnvironment] : [flyerConfigurator paypalEnvironmentId]}];
//    
//    [PayPalMobile preconnectWithEnvironment:[flyerConfigurator paypalEnvironment]];
//    
    //[LobRequest initWithAPIKey:[flyerConfigurator lobAppId]];
    
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
    
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"20eaa2f1-f36d-4187-8613-82851a490f05";
        configuration.clientKey = @"gThiRyKWsxaBiBfvmMUKu6GgjQKI5m2g";
        configuration.server = @"https://api.parse.buddy.com/parse/";
    }]];
    
#else

    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"20eaa2f1-f36d-4187-8613-82851a490f05";
        configuration.clientKey = @"gThiRyKWsxaBiBfvmMUKu6GgjQKI5m2g";
        configuration.server = @"https://api.parse.buddy.com/parse/";
    }]];
    
#endif
  
    // Flurry stats
    [Flurry startSession:[flyerConfigurator flurrySessionId]];

    // Facebook initialization
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions: launchOptions];
    
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
    
    // get the number of folders in current directory.
    NSArray *arrayOfValues = [self checkNumberOfFolders:contentOfDirectory path:anonymousUserPath];
    int numberOfFolders = [[arrayOfValues objectAtIndex:0] intValue];
    //int indexForAnon  = [[arrayOfValues objectAtIndex:1] intValue];
    
    NSError *error;
    // if there is no directory then create one for anonymous.
    if ( numberOfFolders == 0 ) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[anonymousUserPath stringByAppendingString:@"/anonymous"] withIntermediateDirectories:YES attributes:nil error:&error];
        
        // Now check contents of document directory again
        contentOfDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:anonymousUserPath error:NULL];
    }
    // get the number of folders in current directory.
    NSArray *arrayOfValuess = [self checkNumberOfFolders:contentOfDirectory path:anonymousUserPath];
    int indexForAnon  = [[arrayOfValuess objectAtIndex:1] intValue];
    
    // If the Documents folder has only one directory named anonymous then this is an anonymous user (hasn't signed up yet)
    if(contentOfDirectory.count  > 0 && [[contentOfDirectory objectAtIndex:indexForAnon] isEqual:@"anonymous"]){
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
    
    //return YES;
    return [ [FBSDKApplicationDelegate sharedInstance] application :application
                                      didFinishLaunchingWithOptions:launchOptions];
}

/**
 A method that will check the number of folders at specified given path,
 will return the count of folders.
 **/
-(NSArray *)checkNumberOfFolders:(NSArray * )contentOfFolders path:(NSString *) path {

    NSFileManager *filemgr;
    NSDictionary *attribs;
    
    filemgr = [NSFileManager defaultManager];
    
    // initializing count
    int count = 0;
    
    //remember the index of the anon user
    int indexForAnon = 0;
    
    for( int i = 0; i < contentOfFolders.count; i++ ) {
        
        NSString *thisFilePath = [NSString stringWithFormat:@"%@/%@",path,contentOfFolders[i]];
        attribs = [filemgr attributesOfItemAtPath:thisFilePath error: NULL];
        if( [[attribs objectForKey: @"NSFileType"] isEqualToString:NSFileTypeDirectory]  ){
            count++;
            
        }
        // check where anonymous folder index is
        if( [thisFilePath containsString:@"anonymous"] ) {
            indexForAnon = i;
        }
    }
    
    // array that holds count of number of directories at path and the index where aonymous folder lies.
    // at 0th index we'll save count of directories and at 1st index we'll save index of anonymous folder
    NSArray *returnArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:count], [NSNumber numberWithInt:indexForAnon], nil];
    return returnArray;
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
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,email,name" forKey:@"fields"];
    // Send request to Facebook
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            NSString *email = userData[@"email"];
            NSString *name = userData[@"name"];

            BOOL canSave = false;
            BOOL isNew = [[PFUser currentUser] isNew];
            PFUser *currentUser = [PFUser currentUser];

            // when new user signup via facebook, then push appName to server
            if (isNew) {
                [[PFUser currentUser] setObject:APP_NAME forKey:@"appName"];
                canSave = true;
            }

            // Store the current user's Facebook ID on the user
            if ( email != nil && (isNew || currentUser.email == nil || [currentUser.email isEqualToString:@""])) {
                [[PFUser currentUser] setObject:email forKey:@"email"];
                canSave = true;
            }

            if (name != nil ){
                if(isNew || currentUser.username == nil || [currentUser.username isEqualToString:@""]) {
                    [[NSUserDefaults standardUserDefaults]  setObject:[name lowercaseString] forKey:@"User"];
                    [[PFUser currentUser] setObject:name forKey:@"username"];
                    canSave = true;
                }

                if(isNew || currentUser[@"name"] == nil || [currentUser[@"name"] isEqualToString:@""]) {
                    [[PFUser currentUser] setObject:name forKey:@"name"];
                    canSave = true;
                }
            }
            
            if ( email != nil ){
                //Checking Email Exist in Parse
                PFQuery *query = [PFUser  query];
                [query whereKey:@"email" equalTo:email];
                [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){

                    if (error) {
                        [lauchController hideLoadingIndicator];
                    }else{
                        // Migrate Account For 3.0 Version
                        [FlyerUser migrateUserto3dot0:object];
                        
                        [lauchController hideLoadingIndicator];
                        
                    }
                }];
            } else {
                [lauchController hideLoadingIndicator];
            }
            
            if (canSave){
                [[PFUser currentUser] saveInBackground];
            }
        }
        else {
            [lauchController hideLoadingIndicator];
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
        NSLog(@"Directory exists! %@", documentDBFolderPath);
    }
    
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:resourceDBFolderPath error:&error];
    
    for (NSString *s in fileList) {
        
        NSString *newFilePath = [documentDBFolderPath stringByAppendingPathComponent:s];
        NSString *oldFilePath = [resourceDBFolderPath stringByAppendingPathComponent:s];
        
        if (![fileManager fileExistsAtPath:newFilePath]) {
            
            //File does not exist, copy it
            [fileManager copyItemAtPath:oldFilePath toPath:newFilePath error:&error];
            
        } else {
            NSLog(@"File exists: %@", newFilePath);
        }
    }
    
}



@end

