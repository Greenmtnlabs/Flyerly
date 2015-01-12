//
//  ESSettings.m
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 2/21/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import <FlurrySDK/Flurry.h>
#import "ESSettings.h"
#import "ESSoundManager.h"
#import "ESGameInfo.h"
#import "ESAppDelegate.h"

static NSString *kESIsSoundEnabledKey = @"kESIsSoundEnabledKey";

@implementation ESSettings
@dynamic isSoundEnabled;

+ (ESSettings *) sharedInstance
{
    static ESSettings *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ESSettings alloc] init];
    });
    return sharedInstance;
}

- (void)registerDefaults
{
    NSDictionary *defaults = @{kESIsSoundEnabledKey : @(YES)};
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];

}

- (BOOL)isSoundEnabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kESIsSoundEnabledKey];
}

- (void)setIsSoundEnabled:(BOOL)isSoundEnabled
{
    [[NSUserDefaults standardUserDefaults] setBool:isSoundEnabled
                                            forKey:kESIsSoundEnabledKey];
    if (isSoundEnabled) {
        [[ESSoundManager sharedInstance] playSound:ESSoundSwoosh];
    }
}

- (void)clearTrophyRoom
{
    NSManagedObjectContext *context = [[ESAppDelegate sharedAppDelegate] persistingManagedObjectContext];
    NSArray *gameInfos = [ESGameInfo allGameInfoObjectsWithContext:context];
    for (ESGameInfo *gameInfo in gameInfos) {
        [context deleteObject:gameInfo];
    }
    NSError *error;
    NSString *title, *msg;
    if ([context save:&error]) {
        title = @"Trophy Room Cleared";
        msg = @"We got rid of all those old trophies!";
    } else {
        title = @"Error";
        msg = @"Couldn't clear trophy room.";
        [Flurry logError:kESEventTagForCoreDataError message:@"Couldn't clear trophies" error:error];
    }
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
//                                                        message:msg
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//    [alertView show];
}
@end
