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
    //customTextForContact = untechable.spendingTimeTxt;
    //cutomizingStatusArray = [[NSMutableArray alloc] init];
    return self;
}


/*
 * Here we Return Email Status of Contact
 */
/*
-(NSString *)getEmailStatus {
    return [cutomizingStatusArray objectAtIndex:0];
}
*/

/*
 * Here we Return SMS Share Status of Contact
 */
/*
-(NSString *)getSmsStatus {
    return [cutomizingStatusArray objectAtIndex:1];
    
}
*/


/*
 * Here we Return Phone Share Status of Contact
 */

/*
-(NSString *)getPhoneStatus {
    return [cutomizingStatusArray objectAtIndex:2];
    
}

-(void)setEmailStatus :(int)status_ {
    
    [cutomizingStatusArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%d",status_]];
}


-(void)setPhoneStatus :(int)status_ {
    
    [cutomizingStatusArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%d",status_]];
}


-(void)setSmsStatus :(int)status_ {
    
    [cutomizingStatusArray replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%d",status_]];
}
 */
@end

