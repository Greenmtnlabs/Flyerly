//
//  FlyrAppDelegate.m
//  Flyr
//
//  Created by Nilesh on 20/10/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "FlyrAppDelegate.h"
#import "Common.h"
#import "PhotoController.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageCache.h"
#import "LauchViewController.h"
#import "AfterUpdateController.h"
#import "TMAPIClient.h"
//#import "ARRollerView.h"
//#import "ARRollerProtocol.h"

//#define kAdWhirlApplicationKey @"b9c3615f2c88102da8949a322e50052a "
#define kAdWhirlApplicationKey @"b7dfccec5016102d840c2e1e0de86337"
//#define facebookAppID @"136691489852349"

#define TIME 10

//static int NetworkActivityIndicatorCounter = 0;
@implementation FlyrAppDelegate

@synthesize window;
@synthesize navigationController,faceBookPermissionFlag,changesFlag;
@synthesize fontScrollView,colorScrollView,templateScrollView,sizeScrollView,svController,_tSession,lauchController;
//@synthesize adwhirl;
@synthesize session = _session;




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
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackTranslucent];
	navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;

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
        [window addSubview:[navigationController view]];

        AfterUpdateController *afterUpdateView = [[AfterUpdateController alloc]initWithNibName:@"AfterUpdateController" bundle:nil];
        [navigationController pushViewController:afterUpdateView animated:NO];
        
    } else {
        
        NSLog(@"User already Greeted !");

        if(IS_IPHONE_5){
            lauchController = [[LauchViewController alloc]initWithNibName:@"LauchViewControllerIPhone5" bundle:nil];
        }else{
            lauchController = [[LauchViewController alloc]initWithNibName:@"LauchViewController" bundle:nil];
        }

        [navigationController pushViewController:lauchController animated:NO];
        [window addSubview:[navigationController view]];
    }

	[window makeKeyAndVisible];
	
    //initialize facebook
    //self.facebook = [[Facebook alloc] initWithAppId:facebookAppID andDelegate:self];

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
	/*NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	 NSString *cachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"URLCache"];
	 if (![[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil]) {
	 return;
	 }
	 
	 if (![[NSFileManager defaultManager] createDirectoryAtPath:cachePath 
	 withIntermediateDirectories:NO
	 attributes:nil 
	 error:nil]) {
	 return;
	 }*/
	//NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); 
    //NSString *cacheDirectory = [paths objectAtIndex:0]; 
	//NSString *dummyCacheDirectory = [cacheDirectory substringToIndex:65];
	//NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cacheDirectory error:nil];
	
	
    //NSString *filename = [cacheDirectory stringByAppendingPathComponent:cacheDirectoryPath]; 
    //filename = [filename stringByAppendingPathComponent:cacheFileName]; 
	// NSLog(filename);
	
	[[ImageCache sharedImageCache] removeAllImagesInMemory];
    [self.session close];
	
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation {
    // attempt to extract a token from the url

//    return [[self facebook] handleOpenURL:url];
//}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {

    return [[self facebook] handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[TMAPIClient sharedInstance] handleOpenURL:url];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    // FBSample logic
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [FBAppCall handleDidBecomeActiveWithSession:self.session];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
//	[adwhirl release];
    [lauchController release];
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

