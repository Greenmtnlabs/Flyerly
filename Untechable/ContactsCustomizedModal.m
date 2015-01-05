//
//  ContactsModal.m
//  Untechable
//
//  Created by RIKSOF Developer on 12/24/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "ContactsCustomizedModal.h"


@implementation ContactsCustomizedModal

@synthesize delegate,name,description,img,checkImageName,status,others,imageUrl,zip,mobileNumber,mainNumber,iPhoneNumber,homeNumber,workNumber,allEmails,allPhoneNumbers,phoneNumbersStatus,customTextForContact,untechable,cutomizingStatusArray;


-(id)init{
    
    self = [super init];
    customTextForContact = untechable.spendingTimeTxt;
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

-(void)setEmailStatus :(int)status {
    
    [cutomizingStatusArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%d",status]];
    
    //Here we write the Array of Text files .txt
    //[cutomizingStatusArray writeToFile:socialFile atomically:YES];
    
}


-(void)setPhoneStatus :(int)status {
    
    [cutomizingStatusArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%d",status]];
    
    //Here we write the Array of Text files .txt
    //[cutomizingStatusArray writeToFile:socialFile atomically:YES];
    
}


-(void)setSmsStatus :(int)status {
    
    [cutomizingStatusArray replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%d",status]];
    
    //Here we write the Array of Text files .txt
    //[cutomizingStatusArray writeToFile:socialFile atomically:YES];
    
}
@end
