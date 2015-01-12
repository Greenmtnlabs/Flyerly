//
//  NSManagedObjectContext+ESSaveUtilities.m
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 3/13/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import <FlurrySDK/Flurry.h>
#import "NSManagedObjectContext+ESSaveUtilities.h"

@implementation NSManagedObjectContext (ESSaveUtilities)

- (BOOL)es_saveAndAutomaticallyReportErrors:(__autoreleasing NSError **)errorFromUser
{
    __autoreleasing NSError *myError;
    __autoreleasing NSError **errorToUse = (errorFromUser == NULL) ? &myError : errorFromUser;
    BOOL success = [self save:errorToUse];
    if (!success) {
       [Flurry logError:kESEventTagForCoreDataError
                message:[*errorToUse localizedDescription]
                  error:*errorToUse];
    }
    return success;
}
@end
