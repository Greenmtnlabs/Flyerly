//
//  InviteFriendsCell.m
//  Untechable
//
//  Created by rufi on 05/11/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "InviteFriendsCell.h"

@interface InviteFriendsCell ()

@end

@implementation InviteFriendsCell

@synthesize imgProfilePic, lblName, lblDescription, imgCheckBox;

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setCellObjects :(ContactsModel *)contactsModel :(int)status :(NSString *)tableName{
    
    // Set Values
    [lblDescription setText:contactsModel.name];
    
    if ([contactsModel.others isEqualToString:@""]){
        [lblDescription setText:contactsModel.description];
    }else {
        [lblDescription setText:contactsModel.others];
    }
   
    [imgProfilePic setImage:contactsModel.img];
    contactsModel.delegate =(id)self;
    if ( [tableName isEqualToString:@"InviteFriends"] ){
        [contactsModel setInvitedStatus:status];
    }else if ( [tableName isEqualToString:@"PrintInvites"] ){
        [contactsModel setInvitedStatus:0];
    }
}

#pragma mark Contacts  Delegate

-(void)invitedContacts :(ContactsModel *)contactsModel{
    
    [imgCheckBox setImage:[UIImage imageNamed:contactsModel.checkImageName]];
}


@end
