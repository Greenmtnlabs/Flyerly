//
//  ESGameInfo.m
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 2/22/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import "ESGameInfo.h"
#import "ESBoard.h"
#import "ESTrophy.h"


@implementation ESGameInfo

@dynamic wonDate;
@dynamic board;
@dynamic selectedTrophy;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    [self setPrimitiveValue:[NSDate date] forKey:@"wonDate"];
}

+ (NSArray *)allGameInfoObjectsWithContext:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    NSSortDescriptor *wonDateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"wonDate" ascending:YES];
    fetchRequest.sortDescriptors = @[wonDateSortDescriptor];
    
    NSError *error;
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest
                                                          error:&error];
    return result;
}

@end
