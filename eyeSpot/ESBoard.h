//
//  ESBoard.h
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 2/20/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ESGameInfo, ESTile;

@interface ESBoard : NSManagedObject

@property (nonatomic, retain, readonly) NSURL *thumbnailURL;
@property (nonatomic, retain) NSString *thumbnailPath;
@property (nonatomic, retain) NSString * title;
@property (nonatomic) BOOL isAvailable, isCustom;
@property (nonatomic) int32_t index;
@property (nonatomic, retain) NSSet *associatedGames;
@property (nonatomic, retain) NSOrderedSet *tiles;
@property (nonatomic, readonly) BOOL hasTrophy;
@property (nonatomic, readonly) NSString *productID;

+ (BOOL)initializeUsingDefaultData;
+ (NSArray *)allBoards:(NSManagedObjectContext *)managedObjectContext;
- (NSUInteger) maximumNumberOfTiles;
@end


@interface ESBoard (CoreDataGeneratedAccessors)

- (void)addAssociatedGamesObject:(ESGameInfo *)value;
- (void)removeAssociatedGamesObject:(ESGameInfo *)value;
- (void)addAssociatedGames:(NSSet *)values;
- (void)removeAssociatedGames:(NSSet *)values;

- (void)insertObject:(ESTile *)value inTilesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTilesAtIndex:(NSUInteger)idx;
- (void)insertTiles:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTilesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTilesAtIndex:(NSUInteger)idx withObject:(ESTile *)value;
- (void)replaceTilesAtIndexes:(NSIndexSet *)indexes withTiles:(NSArray *)values;
- (void)addTilesObject:(ESTile *)value;
- (void)removeTilesObject:(ESTile *)value;
- (void)addTiles:(NSOrderedSet *)values;
- (void)removeTiles:(NSOrderedSet *)values;
@end
