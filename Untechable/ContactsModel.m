//
//  ContactsModel.m
//  Untechable
//
//  Created by rufi on 30/10/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "ContactsModel.h"

@implementation ContactsModel

@synthesize delegate,name,description,img,checkImageName,status,others,imageUrl,zip;


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


