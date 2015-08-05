//
//  ContactsModal.m
//  Untechable
//
//  Created by RIKSOF Developer on 12/24/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "ContactsCustomizedModal.h"


@implementation ContactsCustomizedModal

@synthesize delegate,name,description,img,checkImageName,status,others,imageUrl,zip,mobileNumber,mainNumber,iPhoneNumber,homeNumber,workNumber,allEmails,allPhoneNumbers,phoneNumbersStatus,customTextForContact,untechable,cutomizingStatusArray,IsCustomized;


-(id)init{
    
    self = [super init];
    customTextForContact = untechable.spendingTimeTxt;
    cutomizingStatusArray = [[NSMutableArray alloc] init];
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
 * Here we Return Email Status of Contact
 */
-(NSString *)getEmailStatus {
    return [cutomizingStatusArray objectAtIndex:0];
}

/*
 * Here we Return SMS Share Status of Contact
 */
-(NSString *)getSmsStatus {
    return [cutomizingStatusArray objectAtIndex:1];
    
}



/*
 * Here we Return Phone Share Status of Contact
 */

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

-(void)removeNotSelectedPhoneNumbers {    
    NSMutableArray *tempAllPhoneNumbers = [[NSMutableArray alloc] init];
    for(int j=0; j<[allPhoneNumbers count]; j++){
        if([allPhoneNumbers[j][2] isEqualToString:@"1" ]||  [allPhoneNumbers[j][3]isEqualToString:@"1"] ){
            [tempAllPhoneNumbers addObject:allPhoneNumbers[j]];
        }
    }
    allPhoneNumbers = [[NSMutableArray alloc] initWithArray:tempAllPhoneNumbers];
}


-(void)removeNotSelectedEmails {
    NSMutableArray *tempAllEmails = [[NSMutableArray alloc] init];
    for(int j=0; j<[allEmails count]; j++){
        if([allEmails[j][1] isEqualToString:@"1" ] ){
            [tempAllEmails addObject:allEmails[j]];
        }
    }
    allEmails = [[NSMutableArray alloc] initWithArray:tempAllEmails];
}

@end
