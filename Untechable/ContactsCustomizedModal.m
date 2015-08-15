//
//  ContactsModal.m
//  Untechable
//
//  Created by RIKSOF Developer on 12/24/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "ContactsCustomizedModal.h"


@implementation ContactsCustomizedModal

@synthesize contactName,customTextForContact, allEmails, allPhoneNumbers;
@synthesize delegate;
@synthesize img,checkImageName,status,imageUrl;


-(id)init{    
    self = [super init];
    allEmails = [[NSMutableArray alloc] init];
    allPhoneNumbers = [[NSMutableArray alloc] init];
    return self;
}

-(void)setInvitedStatus :(int)sts{
    
    
    status = sts;
    
    if (status == 1) {
        checkImageName = @"checkBlue";
    } else if (status == 2) {
        checkImageName = @"checkDouble";
    }else {
        checkImageName = @"checkgray";
    }
    
    [self.delegate contactInvited:self];
}

/*
 * Here we Return Email Status of Contact, @"1" for true case
 */
-(BOOL)getEmailStatus {
    BOOL csStatus = NO;
    for(int i=0; i<allEmails.count; i++){
        if( [[allEmails[i] objectAtIndex:1] isEqualToString:@"1"] ){
            csStatus = YES;
            break;
        }
    }
    return csStatus;
}


/*
 * Here we Return SMS Share Status of Contact
 */
-(BOOL)getSmsStatus {
    BOOL csStatus = NO;
    for(int i=0; i<allPhoneNumbers.count; i++){
        if( [[allPhoneNumbers[i] objectAtIndex:3] isEqualToString:@"1"] ){
            csStatus = YES;
            break;
        }
    }
    return csStatus;
}


/*
 * Here we Return Phone Share Status of Contact
 */

-(BOOL)getPhoneStatus {
    BOOL csStatus = NO;
    for(int i=0; i<allPhoneNumbers.count; i++){
        if( [[allPhoneNumbers[i] objectAtIndex:2] isEqualToString:@"1"] ){
            csStatus = YES;
            break;
        }
    }
    return csStatus;
    
}
@end
