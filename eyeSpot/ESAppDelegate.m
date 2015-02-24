//
//  ESAppDelegate.m
//  eyeSpot
//
//  Created by Vladimir Fleurima on 2/20/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import <FlurrySDK/Flurry.h>
#import "ESAppDelegate.h"
#import "ESBoard.h"
#import "ESTrophy.h"
#import "ESSettings.h"
#import "ESStore.h"
#import "Crittercism.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@implementation ESAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [ESStore sharedStore];
    [Flurry startSession:@"GV8P7XRZBY7CCFG9DQ9V"];
    [Flurry logAllPageViews:self.window.rootViewController];
    [Crittercism enableWithAppID: @"54e6f95a51de5e9f042edc40"];
    NSArray *boards = [ESBoard allBoards:self.managedObjectContext];
    if (DBG_RESET_DATA || 0 == [boards count]) {
        [ESBoard initializeUsingDefaultData];
        [ESTrophy initializeUsingDefaultData];
    }
    [[ESSettings sharedInstance] registerDefaults];
    return YES;
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

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Core Data
// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectContext *)persistingManagedObjectContext
{
    return self.managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    static BOOL didDeleteExistingStore = NO;
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    
    NSError *error = nil;
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@TRUE, NSInferMappingModelAutomaticallyOption:@TRUE};
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:options
                                                           error:&error]) {

        if (error.code != NSPersistentStoreIncompatibleVersionHashError && error.code == NSMigrationMissingSourceModelError) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            [Flurry logError:kESEventTagForCoreDataError message:[error localizedDescription] error:error];
        }
        
        if (!didDeleteExistingStore) {
            [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
            _persistentStoreCoordinator = nil;
            didDeleteExistingStore = YES;
            return self.persistentStoreCoordinator;
        } else {
            // If we deleted the existing store and we still can't create a new one, abort.
            abort();
        }
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Utility
+ (ESAppDelegate *) sharedAppDelegate
{
    return (ESAppDelegate *)[[UIApplication sharedApplication] delegate];
}
@end
