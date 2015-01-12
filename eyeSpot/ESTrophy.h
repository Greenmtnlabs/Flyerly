//
//  ESTrophy.h
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 2/20/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ESGameInfo;

@interface ESTrophy : NSManagedObject

@property (nonatomic, retain) NSURL *imageURL; /* unused */
@property (nonatomic, retain) NSSet *associatedGames;
@property (nonatomic, assign) int32_t index;
@property (nonatomic, retain, readonly) UIImage *image;

+ (NSArray *)allTrophiesWithContext:(NSManagedObjectContext *)managedObjectContext;
+ (BOOL)initializeUsingDefaultData;

@end

@interface ESTrophy (CoreDataGeneratedAccessors)

- (void)addAssociatedGamesObject:(ESGameInfo *)value;
- (void)removeAssociatedGamesObject:(ESGameInfo *)value;
- (void)addAssociatedGames:(NSSet *)values;
- (void)removeAssociatedGames:(NSSet *)values;

@end
