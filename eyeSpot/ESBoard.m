//
//  ESBoard.m
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 2/20/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import "ESBoard.h"
#import "ESGameInfo.h"
#import "ESTile.h"
#import "ESAppDelegate.h"
#import "NSURL+ESUtilities.h"
#import "NSManagedObjectContext+ESSaveUtilities.h"

@implementation ESBoard

@dynamic thumbnailPath;
@dynamic title;
@dynamic isAvailable;
@dynamic index;
@dynamic associatedGames;
@dynamic tiles;
@dynamic isCustom;

- (BOOL)hasTrophy
{
    return ([self.associatedGames count] > 0);
}

- (NSURL *)thumbnailURL
{
    NSURL *homeURL = [NSURL fileURLWithPath:NSHomeDirectory() isDirectory:YES];
    return [NSURL URLWithString:self.thumbnailPath relativeToURL:homeURL];
}

+ (NSArray *)allBoards:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    NSSortDescriptor *indexSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    fetchRequest.sortDescriptors = @[indexSortDescriptor];
    
    NSError *error;
    NSArray *boards = [managedObjectContext executeFetchRequest:fetchRequest
                                                          error:&error];
    return boards;
}

+ (BOOL)initializeUsingDefaultData
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *defaultBoardsURL = [mainBundle URLForResource:@"Default Boards" withExtension:@"plist"];
//    NSURL *defaultTilesURL = [mainBundle URLForResource:@"Default Tiles" withExtension:@"plist"];
    NSArray *defaultBoards = [NSArray arrayWithContentsOfURL:defaultBoardsURL];
//    NSArray *defaultTiles = [NSArray arrayWithContentsOfURL:defaultTilesURL];
    NSArray *possibleTileURLs = [mainBundle URLsForResourcesWithExtension:@"jpg" subdirectory:nil];
    
    NSManagedObjectContext *managedObjectContext = [[ESAppDelegate sharedAppDelegate] persistingManagedObjectContext];
    
    // Delete existing boards & tiles
    for (ESBoard *board in [ESBoard allBoards:managedObjectContext]) {
        [managedObjectContext deleteObject:board];
    }
    
    NSUInteger index = 0;
    for (NSDictionary *boardDict in defaultBoards) {
        ESBoard *board = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                                       inManagedObjectContext:managedObjectContext];
        NSString *thumbnailFilename = [boardDict[@"thumbnail"] stringByDeletingPathExtension];
        NSString *thumbnailExtension = [boardDict[@"thumbnail"] pathExtension];
        NSURL *thumbnailURL = [mainBundle URLForResource:thumbnailFilename withExtension:thumbnailExtension];
        board.thumbnailPath = [thumbnailURL es_pathRelativeToHomeDirectory];
        board.title = boardDict[@"title"];
        board.isAvailable = [boardDict[@"isAvailable"] boolValue];
        board.index = index++;
        
        // Get list of tiles
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lastPathComponent beginswith[cd] %@", [board tilePrefix]];
        NSArray *tileURLs = [possibleTileURLs filteredArrayUsingPredicate:predicate];

        NSUInteger tileIndex = 0;
        for (int i = 0, n = [tileURLs count], maxTiles = [board maximumNumberOfTiles];
             i < n && i < maxTiles;
             i++) {
            NSURL *tileURL = tileURLs[i];
            ESTile *tile = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([ESTile class])
                                                         inManagedObjectContext:managedObjectContext];
            tile.imagePath = [tileURL es_pathRelativeToHomeDirectory];
            tile.index = tileIndex++;
            
            NSMutableOrderedSet *set = [board mutableOrderedSetValueForKey:@"tiles"];
            [set addObject:tile];
        }
        
//        for (NSNumber *tileIndex in boardDict[@"tiles"]) {
//            NSDictionary *tileDict = defaultTiles[[tileIndex intValue]];
//            ESTile *tile = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([ESTile class])
//                                                         inManagedObjectContext:managedObjectContext];
//            NSString *imageFilename = [tileDict[@"image"] stringByDeletingPathExtension];
//            NSString *imageExtension = [tileDict[@"image"] pathExtension];
//            tile.imageURL = [mainBundle URLForResource:imageFilename withExtension:imageExtension];
//            tile.index = [tileDict[@"index"] intValue];
//            
//            NSMutableOrderedSet *set = [board mutableOrderedSetValueForKey:@"tiles"];
//            [set addObject:tile];
//        }
    }
    
    return [managedObjectContext es_saveAndAutomaticallyReportErrors:nil];
}

- (NSUInteger) maximumNumberOfTiles
{
    NSDictionary *relationshipsByName = [self.entity relationshipsByName];
    NSRelationshipDescription *relationshipDescription = relationshipsByName[@"tiles"];
    return relationshipDescription.maxCount;
}

- (NSString *)productID
{
    NSString *suffix = self.title;
    if ([suffix isEqualToString:@"Doctor's Office"]) {
        suffix = @"DoctorsOffice";
    } else if ([suffix isEqualToString:@"Road Trip"]) {
        suffix = @"RoadTrip";
    }
    return [kESBoardProductIDPrefix stringByAppendingString:suffix];
}

- (NSString *)tilePrefix
{
    NSString *prefix = self.title;
    if ([prefix isEqualToString:@"Doctor's Office"]) {
        prefix = @"Doctor";
    } else if ([prefix isEqualToString:@"Road Trip"]) {
        prefix = @"RT";
    } else if ([prefix isEqualToString:@"Colors"]) {
        prefix = @"Color";
    }
    return prefix;
}

@end
