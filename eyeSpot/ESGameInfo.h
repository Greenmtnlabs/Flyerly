//
//  ESGameInfo.h
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 2/22/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ESBoard, ESTrophy;

@interface ESGameInfo : NSManagedObject

@property (nonatomic) NSDate *wonDate;
@property (nonatomic, retain) ESBoard *board;
@property (nonatomic, retain) ESTrophy *selectedTrophy;

+ (NSArray *)allGameInfoObjectsWithContext:(NSManagedObjectContext *)managedObjectContext;
@end
