//
//  FlyrAppDelegate.m
//  Flyr
//
//  Created by Nilesh on 20/10/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "Crittercism.h"
#import "FlyrAppDelegate.h"
#import "Common.h"
#import "PhotoController.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageCache.h"
#import "LauchViewController.h"
#import "AfterUpdateController.h"
#import "AccountController.h"
#import "DraftViewController.h"
#import "Flurry.h"
#import <Parse/Parse.h>
#import "BZFoursquare.h"





NSString *kCheckTokenStep1 = @"kCheckTokenStep";
NSString *FlickrSharingSuccessNotification = @"FlickrSharingSuccessNotification";
NSString *FlickrSharingFailureNotification = @"FlickrSharingFailureNotification";
NSString *FacebookDidLoginNotification = @"FacebookDidLoginNotification";

#define kAdWhirlApplicationKey @"b7dfccec5016102d840c2e1e0de86337"
#define TIME 10

@implementation FlyrAppDelegate

@synthesize window;
@synthesize navigationController,faceBookPermissionFlag,changesFlag;
@synthesize fontScrollView,colorScrollView,templateScrollView,sizeScrollView,svController,lauchController,accountController;
@synthesize session = _session;
//@synthesize adwhirl;
@synthesize sharingProgressParentView;

#pragma mark Ad whirl delegate methods

-(void)next{
	//[adwhirl getNextAd];
}

- (NSString*)adWhirlApplicationKey
{
	return kAdWhirlApplicationKey;  //Return your AdWhirl application key here
}

//- (void)rollerDidReceiveAd:(ARRollerView*)rollerView
//{
//	NSString* mostRecentNetworkName = [rollerView mostRecentNetworkName];
//	NSLog(@"Received ad from %@!", mostRecentNetworkName);
//
//}
//- (void)rollerDidFailToReceiveAd:(ARRollerView*)rollerView usingBackup:(BOOL)YesOrNo
//{
//	NSLog(@"Failed to receive ad from %@.  Using Backup: %@", [rollerView mostRecentNetworkName], YesOrNo ? @"YES" : @"NO");
//}

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	[self clearCache];
	changesFlag = NO;
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque];
	navigationController.navigationBar.barStyle = UIStatusBarStyleBlackOpaque;

    NSString *greeted = [[NSUserDefaults standardUserDefaults] stringForKey:@"greeted"];
    
    if(!greeted){
        NSLog(@"Welcome to the world of Flyerly");
        [[NSUserDefaults standardUserDefaults] setObject:@"greeted" forKey:@"greeted"];
        
        if(IS_IPHONE_5){
            lauchController = [[LauchViewController alloc]initWithNibName:@"LauchViewControllerIPhone5" bundle:nil];
        }else{
            lauchController = [[LauchViewController alloc]initWithNibName:@"LauchViewController" bundle:nil];
        }

        [navigationController pushViewController:lauchController animated:NO];
        //accountController = [[AccountController alloc]initWithNibName:@"AccountController" bundle:nil];
        //[navigationController pushViewController:accountController animated:NO];
        [window addSubview:[navigationController view]];

        AfterUpdateController *afterUpdateView = [[AfterUpdateController alloc]initWithNibName:@"AfterUpdateController" bundle:nil];
        [navigationController pushViewController:afterUpdateView animated:NO];
        
    } else {
        
        NSLog(@"User already Greeted !");

        if(IS_IPHONE_5){
            lauchController = [[LauchViewController alloc]initWithNibName:@"LauchViewControllerIPhone5" bundle:nil];
            accountController = [[AccountController alloc]initWithNibName:@"AcountViewControlleriPhone5" bundle:nil];

        }else{
            lauchController = [[LauchViewController alloc]initWithNibName:@"LauchViewController" bundle:nil];
            accountController = [[AccountController alloc]initWithNibName:@"AccountController" bundle:nil];
        }
        [navigationController pushViewController:lauchController animated:NO];
        [navigationController pushViewController:accountController animated:NO];
        [window addSubview:[navigationController view]];
    }

	[window makeKeyAndVisible];
	
	//adwhirl = [ARRollerView requestRollerViewWithDelegate:self];
	//adwhirl.
	//[adwhirl setFrame:CGRectMake(0, 318, 320, 50)];
	//[self.view addSubview:adwhirl];
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

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	NSLog(@"applicationDidReceiveMemoryWarning");
	[self clearCache];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [FBSession.activeSession close];
	[self clearCache];
}


/*
+ (void) increaseNetworkActivityIndicator
{
	NetworkActivityIndicatorCounter++;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NetworkActivityIndicatorCounter > 0;
}

+ (void) decreaseNetworkActivityIndicator
{
	NetworkActivityIndicatorCounter--;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NetworkActivityIndicatorCounter > 0;
}
 */

-(void)clearCache{
/*
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	 NSString *cachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"URLCache"];
	 if (![[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil]) {
	 return;
	 }
	 
	 if (![[NSFileManager defaultManager] createDirectoryAtPath:cachePath 
	 withIntermediateDirectories:NO
	 attributes:nil 
	 error:nil]) {
	 return;
	 }
	NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths1 objectAtIndex:0]; 
	NSString *dummyCacheDirectory = [cacheDirectory substringToIndex:65];
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cacheDirectory error:nil];
	
	
    NSString *filename = [cacheDirectory stringByAppendingPathComponent:cacheDirectory]; 
    filename = [filename stringByAppendingPathComponent:filename]; 
	 //NSLog(filename);
	//
 */
	[[ImageCache sharedImageCache] removeAllImagesInMemory];
    [self.session close];
	
}



- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    //return [PFFacebookUtils handleOpenURL:url];
    
        return [[self facebook] handleOpenURL:url];
    
}

- (OFFlickrAPIRequest *)flickrRequest {
    /*
	if (!flickrRequest) {
		flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:flickrContext];
		flickrRequest.delegate = self;
	}
	*/
	return nil; //flickrRequest;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if([[url absoluteString] hasPrefix:kCallbackURLBaseStringPrefix]){
        
        if ([self flickrRequest].sessionInfo) {
            // already running some other request
            NSLog(@"Already running some other request");
        }
        else {
            NSString *token = nil;
            NSString *verifier = nil;
            BOOL result = OFExtractOAuthCallback(url, [NSURL URLWithString:kCallbackURLBaseString], &token, &verifier);
            
            if (!result) {
                NSLog(@"Cannot obtain token/secret from URL: %@", [url absoluteString]);
                return NO;
            }
            
            [self flickrRequest].sessionInfo = kGetAccessTokenStep;
           // [flickrRequest fetchOAuthAccessTokenWithRequestToken:token verifier:verifier];
        }
        
        return YES;

    } else if([[url absoluteString] hasPrefix:@"fb"]){
        
        // Send facebook did login notification
        //[[NSNotificationCenter defaultCenter] postNotificationName:FacebookDidLoginNotification object:self];
        //return YES;
        return [PFFacebookUtils handleOpenURL:url];
       // return [[self facebook] handleOpenURL:url];
        
    } else if([[url absoluteString] hasPrefix:@"fsqapi"]){
    
        return [[self foursquare] handleOpenURL:url];

    } else {
        //Tumbler Return
        return nil;//[[SHKTumblr  sharedInstance] handleOpenURL:url];
    }
}
/*
- (OFFlickrAPIContext *)flickrContext
{
    if (!flickrContext) {
        flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:FlickrAPIKey sharedSecret:FlickrSecretKey];
        
        NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:kStoredAuthTokenKeyName];
        NSString *authTokenSecret = [[NSUserDefaults standardUserDefaults] objectForKey:kStoredAuthTokenSecretKeyName];
        
        if (([authToken length] > 0) && ([authTokenSecret length] > 0)) {
            flickrContext.OAuthToken = authToken;
            flickrContext.OAuthTokenSecret = authTokenSecret;
        }
    }
    
    return flickrContext;
}
*/
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:self.session];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Crittercism for crash reports.
    [Crittercism initWithAppID: @"519a14f897c8f27969000019"];
    [Flurry startSession:@"ZWXZFGSQZ4GMYZBVZYN3"];

    // Setup parse
    [Parse setApplicationId:@"rrU7ilSR4TZNQD9xlDtH8wFoQNK4st5AaITq6Fan"
                  clientKey:@"P0FxBvDvw0eDYYT01cx8nhaDQdl90BdHGc22jPLn"];

    // Your Facebook application id is configured in Info.plist.
    [PFFacebookUtils initializeFacebook];
    
    //Twitter Initialize
    [PFTwitterUtils initializeWithConsumerKey:@"SAXU48fGEpSMQl56cgRDQ" consumerSecret:@"tNMJrWNA3eqSQn87Gv2WH1KCb3EGpdHHi7YRd1YG6xw"];
    
    // Setup Bit.ly
    /*
    [[BitlyConfig sharedBitlyConfig] setBitlyLogin:@"flyerly" bitlyAPIKey:@"R_3bdc6f8e82d260965325510421c980a0"];*/
  //  [[BitlyConfig sharedBitlyConfig] setBitlyAPIKey:@"R_3bdc6f8e82d260965325510421c980a0"];
    
    //Here you load ShareKit submodule with app specific configuration
    
    DefaultSHKConfigurator *configurator = [[MySHKConfigurator alloc] init];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];
    
    
    //[self clearCache];
	changesFlag = NO;
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque];
	navigationController.navigationBar.barStyle = UIStatusBarStyleBlackOpaque;
    globle = [Singleton RetrieveSingleton];
    globle.twitterUser = nil;
    float ver =  [[[UIDevice currentDevice] systemVersion] floatValue];
    globle.iosVersion =[NSString stringWithFormat:@"%f",ver];

    //This flag represents the condition whether application setting has been altered first time
    // after installing app
    if(![[NSUserDefaults standardUserDefaults] stringForKey:@"saveToCameraRollSettingFlag"]){
        [[NSUserDefaults standardUserDefaults] setObject:@"enabled" forKey:@"saveToCameraRollSettingFlag"];
        [[NSUserDefaults standardUserDefaults] setObject:@"enabled" forKey:@"saveToCameraRollSetting"];
    }

    if(![[NSUserDefaults standardUserDefaults] stringForKey:@"cameraSetting"]){
        [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"cameraSetting"];
    }

    NSString *greeted = [[NSUserDefaults standardUserDefaults] stringForKey:@"greeted"];
    
    if(!greeted){
        NSLog(@"Welcome to the world of Flyerly");
        [[NSUserDefaults standardUserDefaults] setObject:@"greeted" forKey:@"greeted"];
        
        if(IS_IPHONE_5){
            lauchController = [[LauchViewController alloc]initWithNibName:@"LauchViewControllerIPhone5" bundle:nil];
        }else{
            lauchController = [[LauchViewController alloc]initWithNibName:@"LauchViewController" bundle:nil];
        }
        
        [navigationController pushViewController:lauchController animated:NO];
        //accountController = [[AccountController alloc]initWithNibName:@"AccountController" bundle:nil];
        //[navigationController pushViewController:accountController animated:NO];
        [window addSubview:[navigationController view]];
        
        AfterUpdateController *afterUpdateView = [[AfterUpdateController alloc]initWithNibName:@"AfterUpdateController" bundle:nil];
        [navigationController pushViewController:afterUpdateView animated:NO];
        
    } else {
        
        NSLog(@"User already Greeted !");
        if(IS_IPHONE_5){
                accountController = [[[AccountController alloc]initWithNibName:@"AcountViewControlleriPhone5" bundle:nil] autorelease];
            lauchController = [[[LauchViewController alloc]initWithNibName:@"LauchViewControllerIPhone5" bundle:nil] autorelease];

        }else{
            accountController = [[[AccountController alloc]initWithNibName:@"AccountController" bundle:nil] autorelease];
            lauchController = [[[LauchViewController alloc]initWithNibName:@"LauchViewController" bundle:nil] autorelease];

        }
        
        // Is the ser logged in?
        
        if ( [PFUser currentUser] == nil ) {
            [navigationController   pushViewController:accountController animated:YES];
        }else{
            [navigationController pushViewController:lauchController animated:YES];
            FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
            appDelegate.loginId = [[NSUserDefaults standardUserDefaults]  objectForKey:@"User"];
            
        }

        [window addSubview:[navigationController view]];
    }
    
    // Override point for customization after application launch.
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];

	[window makeKeyAndVisible];

    return YES;
}
/*
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary {    
    NSLog(@"Request Complete With Response: %@", inResponseDictionary);
    
    if (inRequest.sessionInfo == kCheckTokenStep1) {
		self.flickrUserName = [inResponseDictionary valueForKeyPath:@"user.username._text"];
	}
	
    [self flickrRequest].sessionInfo = nil;
	[[NSNotificationCenter defaultCenter] postNotificationName:FlickrSharingSuccessNotification object:nil];
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didObtainOAuthAccessToken:(NSString *)inAccessToken secret:(NSString *)inSecret userFullName:(NSString *)inFullName userName:(NSString *)inUserName userNSID:(NSString *)inNSID {
    [self setAndStoreFlickrAuthToken:inAccessToken secret:inSecret];
    
    self.flickrUserName = inUserName;    
	//[[NSNotificationCenter defaultCenter] postNotificationName:SnapAndRunShouldUpdateAuthInfoNotification object:self];
    [self flickrRequest].sessionInfo = nil;
}

- (void)setAndStoreFlickrAuthToken:(NSString *)inAuthToken secret:(NSString *)inSecret {
	if (![inAuthToken length] || ![inSecret length]) {
		self.flickrContext.OAuthToken = nil;
        self.flickrContext.OAuthTokenSecret = nil;
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:kStoredAuthTokenKeyName];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kStoredAuthTokenSecretKeyName];
        
	}
	else {
		self.flickrContext.OAuthToken = inAuthToken;
        self.flickrContext.OAuthTokenSecret = inSecret;
		[[NSUserDefaults standardUserDefaults] setObject:inAuthToken forKey:kStoredAuthTokenKeyName];
		[[NSUserDefaults standardUserDefaults] setObject:inSecret forKey:kStoredAuthTokenSecretKeyName];
	}
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didObtainOAuthRequestToken:(NSString *)inRequestToken secret:(NSString *)inSecret; {
    flickrContext.OAuthToken = inRequestToken;
    flickrContext.OAuthTokenSecret = inSecret;
    
}


- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError{
    NSLog(@"Fail request %@, error: %@", inRequest, inError);
	[[NSNotificationCenter defaultCenter] postNotificationName:FlickrSharingFailureNotification object:self];
}
*/

/*
 For Checking Twitter old Detail is available in parse or not
 if it exist then we call Merging Process
*/
-(void)TwitterChangeforNewVersion:(NSString *)olduser{

    //Checking user Exist in Parse
    PFQuery *query = [PFUser  query];
    [query whereKey:@"username" equalTo:[olduser lowercaseString]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        
        if (error) {
            NSLog(@"Twitter User Not Exits");
            
        }else{
            NSLog(@"Old Twitter User found");
            
            // Merging Account Process
            [self MergeAccount:object];
            
        }
    }];



}


/*
Here we Getting user Email ID from Currently login facebook ID
For Checking old Detail is available in parse or not
if it exist then we call Merging Process
*/
-(void)FbChangeforNewVersion{

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
                    
                    // Merging Account Info
                    [self MergeAccount:object];

                }
            }];


        }
    }];
}

-(void)MergeAccount:(PFObject *)oldUserobj{
  
    
    //Update fields of newly created user from old user
    PFUser *user = [PFUser currentUser];
    user[@"contact"] = [oldUserobj objectForKey:@"contact"];
    user[@"name"] = [oldUserobj objectForKey:@"name"];
    //user[@"email"] = [oldUserobj objectForKey:@"email"];
    user[@"fbinvited"] = [oldUserobj objectForKey:@"fbinvited"];
    user[@"tweetinvited"] = [oldUserobj objectForKey:@"tweetinvited"];
    [user saveInBackground];

    NSString  *NewUID = user.objectId;
    NSString  *OldUID = oldUserobj.objectId;
    
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    
	NSString *homeDirectoryPath = NSHomeDirectory();
    NSString *NewUIDFolderName = [user objectForKey:@"username"];
	NSString *OldUIDPath = [homeDirectoryPath stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@/",[oldUserobj objectForKey:@"username"]]];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:OldUIDPath isDirectory:NULL]) {
        //NSError *error;
		//[[NSFileManager defaultManager] createDirectoryAtPath:usernamePath withIntermediateDirectories:YES attributes:nil error:&error];
	}else{
        
        // Crate New folder
        //[[NSFileManager defaultManager] createDirectoryAtPath:NewUIDPath withIntermediateDirectories:YES attributes:nil error:&error];
        
        NSString *newDirectoryName = NewUIDFolderName;
        NSString *oldPath = OldUIDPath;
        NSString *newPath = [[oldPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:newDirectoryName];
        NSError *error = nil;
        [[NSFileManager defaultManager] moveItemAtPath:oldPath toPath:newPath error:&error];
        if (error) {
            NSLog(@"%@",error.localizedDescription);
            // handle error
        }
    }
    
    // For Merging User info Parse not allow here
    // So Now we run Server side script from here and passing user names
    // For transfer Purchases and Old Flyers Info
    [PFCloud callFunctionInBackground:@"mergeUser"
                       withParameters:@{@"oldUser":OldUID,@"newUser":NewUID}
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        NSLog(@"Cloud Success");
                                        // result is @"Hello world!"
                                    }
     }];
    
 /*
    // Transfer Old Flyers to New User from Old User

    // Getting Old Flyers Detail
    // Assume PFObject *myPost was previously created.
    PFQuery *query = [PFQuery queryWithClassName:@"Flyer"];
    [query whereKey:@"user" equalTo:oldUserobj];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objsAry, NSError *error) {
        
        if (!error) {
            
            // The find succeeded.
            for (PFObject *obj in objsAry) {
                
                NSLog(@"%@",obj.ACL);
                obj[@"user"] = NewUID;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //Save All Objects
                int success = [PFObject saveAll:objsAry];
                NSLog(@"Status %@", success? @"updated successfully": @"update failed");
            });
           
            
        } else {
            
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }]; //Find Objects
    
*/

}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
//	[adwhirl release];
    [lauchController release];
	[navigationController release];
	[window release];
}


@end

