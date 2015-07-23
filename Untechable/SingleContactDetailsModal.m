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


@synthesize name,allEmails,allPhoneNumbers;


-(id)init{
    
    self = [super init];
    allEmails = [[NSMutableArray alloc] init];
    allPhoneNumbers = [[NSMutableArray alloc] init];
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
    return (allPhoneNumbers.count==0 && allEmails.count==0) ? NO : YES;
}

@end

