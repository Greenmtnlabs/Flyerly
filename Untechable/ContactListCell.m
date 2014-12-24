//
//  ContactListCell.m
//  Untechable
//
//  Created by RIKSOF Developer on 12/23/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "ContactListCell.h"
#import "ContactsCustomizedModal.h"

@implementation ContactListCell

@synthesize contactName;

/*
 * Set CellObjects
 */
-(void)setCellObjects :(ContactsCustomizedModal *)model :(int)status :(NSString*) tableName {
    
    // Set Values
    [contactName setText:model.name];
    
    /*if ([model.others isEqualToString:@""]){
        [description setText:model.description];
    }else {
        [description setText:model.others];
    }
    [imgview setImage:model.img];*/
    model.delegate = self;
    if ( [tableName isEqualToString:@"InviteFriends"] ){
        [model setInvitedStatus:status];
    }else if ( [tableName isEqualToString:@"PrintInvites"] ){
        [model setInvitedStatus:0];
    }
    
}


#pragma mark Contacts  Delegate

-(void)contactInvited :(ContactsCustomizedModal *)model{
    
    //[checkBtn setImage:[UIImage imageNamed:model.checkImageName]];
}
@end
