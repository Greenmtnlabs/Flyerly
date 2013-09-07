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
#import "TMAPIClient.h"
#import "DraftViewController.h"
#import "Flurry.h"
#import <Parse/Parse.h>
#import "BZFoursquare.h"
#import "BitlyConfig.h"

NSString *kCheckTokenStep = @"kCheckTokenStep";
NSString *FlickrSharingSuccessNotification = @"FlickrSharingSuccessNotification";
NSString *FlickrSharingFailureNotification = @"FlickrSharingFailureNotification";
NSString *FacebookDidLoginNotification = @"FacebookDidLoginNotification";

#define kAdWhirlApplicationKey @"b7dfccec5016102d840c2e1e0de86337"
#define TIME 10

@implementation FlyrAppDelegate

@synthesize window;
@synthesize navigationController,faceBookPermissionFlag,changesFlag;
@synthesize fontScrollView,colorScrollView,templateScrollView,sizeScrollView,svController,_tSession,lauchController,flickrContext,flickrRequest,accountController;
@synthesize session = _session;
//@synthesize adwhirl;
@synthesize flickrUserName,sharingProgressParentView;

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

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	NSLog(@"applicationDidReceiveMemoryWarning");
	[self clearCache];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
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

    return [[self facebook] handleOpenURL:url];
}

- (OFFlickrAPIRequest *)flickrRequest {
	if (!flickrRequest) {
		flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:flickrContext];
		flickrRequest.delegate = self;
	}
	
	return flickrRequest;
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
            [flickrRequest fetchOAuthAccessTokenWithRequestToken:token verifier:verifier];
        }
        
        return YES;

    } else if([[url absoluteString] hasPrefix:@"fb"]){
        
        // Send facebook did login notification
        //[[NSNotificationCenter defaultCenter] postNotificationName:FacebookDidLoginNotification object:self];
        //return YES;
        
        return [[self facebook] handleOpenURL:url];
        
    } else if([[url absoluteString] hasPrefix:@"fsqapi"]){
    
        return [[self foursquare] handleOpenURL:url];

    } else {
        
        return [[TMAPIClient sharedInstance] handleOpenURL:url];
    }
}

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
    
    // Setup Bit.ly
    [[BitlyConfig sharedBitlyConfig] setBitlyLogin:@"flyerly" bitlyAPIKey:@"R_3bdc6f8e82d260965325510421c980a0"];
  //  [[BitlyConfig sharedBitlyConfig] setBitlyAPIKey:@"R_3bdc6f8e82d260965325510421c980a0"];
    
    [self clearCache];
	changesFlag = NO;
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque];
	navigationController.navigationBar.barStyle = UIStatusBarStyleBlackOpaque;
    globle = [Singleton RetrieveSingleton];
    globle.twitterUser = nil;
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
            [navigationController pushViewController:accountController animated:YES];
        }else{
            [navigationController pushViewController:lauchController animated:YES];
        }

        [window addSubview:[navigationController view]];
    }
    
	[window makeKeyAndVisible];

    return YES;
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary {    
    NSLog(@"Request Complete With Response: %@", inResponseDictionary);
    
    if (inRequest.sessionInfo == kCheckTokenStep) {
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

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
//	[adwhirl release];
    [lauchController release];
	[navigationController release];
	[window release];
	[flickrUserName release];
	[super dealloc];
}


@end

