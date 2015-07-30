//
//  ContactDetailsModal.m
//  Untechable
//
//  Created by arqam on 13/07/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingleContactDetailsModal.h"


@implementation SingleContactDetailsModal


@synthesize contactName,emailAddresses,phoneNumbers,customTextForContact,cutomizingStatusArray,IsCustomized;


-(id)init{
    
    self = [super init];
    emailAddresses = [[NSMutableArray alloc] init];
    phoneNumbers = [[NSMutableArray alloc] init];
    cutomizingStatusArray = [[NSMutableArray alloc] init];
    customTextForContact = @"";
    IsCustomized = NO;
    return self;
}


/**
 *
 * This method returns YES(true)
 * if any of the flags in this Modal
 * is set to 1
 * so useless contact can be deleted
 *
 * params: none
 * return: BOOL
 */

- (BOOL)hasContacts{
    return (phoneNumbers.count==0 && emailAddresses.count==0) ? NO : YES;
}

@end

