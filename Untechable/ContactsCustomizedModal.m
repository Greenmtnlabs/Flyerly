//
//  ContactsModal.m
//  Untechable
//
//  Created by RIKSOF Developer on 12/24/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "ContactsCustomizedModal.h"


@implementation ContactsCustomizedModal

@synthesize delegate,name,description,img,checkImageName,status,others,imageUrl,zip,mobileNumber,mainNumber,iPhoneNumber,homeNumber,workNumber,allEmails,allPhoneNumbers,phoneNumbersStatus;


-(id)init{
    
    self = [super init];
    
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


@end
