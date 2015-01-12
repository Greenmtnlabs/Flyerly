//
//  ESTrophy.m
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 2/20/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import "ESTrophy.h"
#import "ESGameInfo.h"
#import "ESAppDelegate.h"
#import "NSManagedObjectContext+ESSaveUtilities.h"

@implementation ESTrophy

@dynamic imageURL;
@dynamic associatedGames;
@dynamic index;

+ (NSArray *)allTrophiesWithContext:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    NSSortDescriptor *indexSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    fetchRequest.sortDescriptors = @[indexSortDescriptor];
    
    NSError *error;
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest
                                                          error:&error];
    return result;
}

+ (BOOL)initializeUsingDefaultData
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *defaultTrophiesURL = [mainBundle URLForResource:@"Default Trophies" withExtension:@"plist"];
    NSArray *defaultTrophies = [NSArray arrayWithContentsOfURL:defaultTrophiesURL];
    
    NSManagedObjectContext *managedObjectContext = [[ESAppDelegate sharedAppDelegate] persistingManagedObjectContext];
    
    // Delete existing trophies
    for (ESTrophy *trophy in [ESTrophy allTrophiesWithContext:managedObjectContext]) {
        [managedObjectContext deleteObject:trophy];
    }
    
    for (NSDictionary *trophyDict in defaultTrophies) {
        ESTrophy *trophy = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                                         inManagedObjectContext:managedObjectContext];

        NSString *imageFilename = [trophyDict[@"string"] stringByDeletingPathExtension];
        NSString *imageExtension = [trophyDict[@"string"] pathExtension];
        trophy.imageURL = [mainBundle URLForResource:imageFilename withExtension:imageExtension];
        trophy.index = [trophyDict[@"index"] intValue];
    }
    
    __autoreleasing NSError *saveError;
    return [managedObjectContext es_saveAndAutomaticallyReportErrors:&saveError];
}

- (UIImage *)image
{
    UIImage  *image = [UIImage imageNamed:[NSString stringWithFormat:@"trophy%d", self.index]];
    return image;
}

@end
