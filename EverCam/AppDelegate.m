/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2015
 http://www.fvimagination.com
 
==============================*/


#import "AppDelegate.h"
#import "HomeVC.h"
#import "Configs.h"



@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    return true;
}



-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    // Resets icon's badge number to zero
    application.applicationIconBadgeNumber = 0;
    
}




- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
