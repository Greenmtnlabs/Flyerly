//
//  ESTile.h
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 2/20/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class ESBoard;
@interface ESTile : NSManagedObject

@property (nonatomic, retain, readonly) NSURL *imageURL;
@property (nonatomic, retain) NSString *imagePath;
@property (nonatomic) int32_t index;
@property (nonatomic) BOOL isChecked;
@property (nonatomic, retain) NSSet *associatedGames;
@property (nonatomic, retain) ESBoard *board;
@end

@interface ESTile (CoreDataGeneratedAccessors)

- (void)addAssociatedGamesObject:(NSManagedObject *)value;
- (void)removeAssociatedGamesObject:(NSManagedObject *)value;
- (void)addAssociatedGames:(NSSet *)values;
- (void)removeAssociatedGames:(NSSet *)values;

@end
