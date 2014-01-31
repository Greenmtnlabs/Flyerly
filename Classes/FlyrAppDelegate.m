//
//  FlyrAppDelegate.h
//  Flyr
//
//  Developed by RIKSOF (Private) Limited
//  Copyright Flyerly. All rights reserved.
//

#import "FlyrAppDelegate.h"


NSString *kCheckTokenStep1 = @"kCheckTokenStep";
NSString *FlickrSharingSuccessNotification = @"FlickrSharingSuccessNotification";
NSString *FlickrSharingFailureNotification = @"FlickrSharingFailureNotification";
NSString *FacebookDidLoginNotification = @"FacebookDidLoginNotification";

#define TIME 10

@implementation FlyrAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize faceBookPermissionFlag,changesFlag;
@synthesize fontScrollView,colorScrollView, sizeScrollView,svController,lauchController,accountController;
@synthesize sharingProgressParentView;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {

	changesFlag = NO;
	
    NSString *greeted = [[NSUserDefaults standardUserDefaults] stringForKey:@"greeted"];
    
    if(!greeted){
        NSLog(@"Welcome to the world of Flyerly");
        [[NSUserDefaults standardUserDefaults] setObject:@"greeted" forKey:@"greeted"];

        lauchController = [[LauchViewController alloc]initWithNibName:@"LauchViewController" bundle:nil];

        [navigationController pushViewController:lauchController animated:NO];
        [window addSubview:[navigationController view]];

        AfterUpdateController *afterUpdateView = [[AfterUpdateController alloc]initWithNibName:@"AfterUpdateController" bundle:nil];
        [navigationController pushViewController:afterUpdateView animated:NO];
        
    } else {
        
        NSLog(@"User already Greeted !");

        lauchController = [[LauchViewController alloc]initWithNibName:@"LauchViewController" bundle:nil];
        accountController = [[AccountController alloc]initWithNibName:@"AccountController" bundle:nil];
        
        [navigationController pushViewController:lauchController animated:NO];
        [navigationController pushViewController:accountController animated:NO];
        [window addSubview:[navigationController view]];
    }

	[window makeKeyAndVisible];
	
	[NSTimer scheduledTimerWithTimeInterval:TIME target:self selector:@selector(next) userInfo:nil repeats:YES];
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
    
    if([[url absoluteString] hasPrefix:kCallbackURLBaseStringPrefix]){
            NSString *token = nil;
            NSString *verifier = nil;
            BOOL result = OFExtractOAuthCallback(url, [NSURL URLWithString:kCallbackURLBaseString], &token, &verifier);
            
            if (!result) {
                NSLog(@"Cannot obtain token/secret from URL: %@", [url absoluteString]);
                return NO;
            }
        return YES;
    } else if([[url absoluteString] hasPrefix:@"fb"]){
        return [PFFacebookUtils handleOpenURL:url];
    } else {
  
        return nil;
        
    }
}

/**
 * Application bring up.
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    // Configurator initialization
    FlyerlyConfigurator *flyerConfigurator = [[FlyerlyConfigurator alloc] init];
    DefaultSHKConfigurator  *configurator = flyerConfigurator;
    
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];

    // Crittercism for crash reports.
    [Crittercism initWithAppID:[flyerConfigurator crittercismAppId]];
    
#ifdef DEBUG
    
    // Setup parse Offline
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
    
	changesFlag = NO;

    // This flag represents the condition whether application setting has been altered first time
    // after installing app
    if( ![[NSUserDefaults standardUserDefaults] stringForKey:@"saveToCameraRollSettingFlag"] ){
        [[NSUserDefaults standardUserDefaults] setObject:@"enabled" forKey:@"saveToCameraRollSettingFlag"];
        [[NSUserDefaults standardUserDefaults] setObject:@"enabled" forKey:@"saveToCameraRollSetting"];
    }

    if( ![[NSUserDefaults standardUserDefaults] stringForKey:@"cameraSetting"] ){
        [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"cameraSetting"];
    }

    // Determin if the user has been greeted?
    NSString *greeted = [[NSUserDefaults standardUserDefaults] stringForKey:@"greeted"];
    
    if( !greeted ) {
        // Show the greeting before going to the main app.
        [[NSUserDefaults standardUserDefaults] setObject:@"greeted" forKey:@"greeted"];
        
        lauchController = [[LauchViewController alloc]initWithNibName:@"LauchViewController" bundle:nil];
        
        [navigationController pushViewController:lauchController animated:NO];
        
        AfterUpdateController *afterUpdateView = [[AfterUpdateController alloc]initWithNibName:@"AfterUpdateController" bundle:nil];
        [navigationController setRootViewController:afterUpdateView];
        
    } else {
        // User has already been greeted.
        
        // Is the user logged in?
        if ( [PFUser currentUser] == nil ) {
            accountController = [[AccountController alloc]initWithNibName:@"AccountController" bundle:nil];
            [navigationController setRootViewController:accountController];
        } else {
            lauchController = [[LauchViewController alloc]initWithNibName:@"LauchViewController" bundle:nil];
            [navigationController setRootViewController:lauchController];
        }
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

    //Checking user Exist in Parse
    PFQuery *query = [PFUser  query];
    [query whereKey:@"username" equalTo:[olduser lowercaseString]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        
        if (error) {
            NSLog(@"Twitter User Not Exits");
            
        }else{
            NSLog(@"Old Twitter User found");
            
            // Migrate Account For 3.0 Version
            [FlyerUser migrateUserto3dot0:object];
            
        }
    }];



}


/*
Here we Getting user Email ID from Currently login facebook ID
For Checking old Detail is available in parse or not
if it exist then we call Merging Process
*/
-(void)fbChangeforNewVersion{

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
                    
                    NSLog(@"Email NotExits");

                }else{
                    NSLog(@"Email Exist");
                    
                    // Migrate Account For 3.0 Version
                    [FlyerUser migrateUserto3dot0:object];

                }
            }];


        }
    }];
}


@end

