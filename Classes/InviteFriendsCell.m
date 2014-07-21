//
//  AddFriendsDetail.m
//  Flyr
//
//  Created by Riksof on 04/12/2013.
//
//

#import "InviteFriendsCell.h"

@interface InviteFriendsCell ()

@end

@implementation InviteFriendsCell

@synthesize imgview,description,dName,checkBtn;


/*
 * Set CellObjects
 */
-(void)setCellObjects :(ContactsModel *)model :(int)status :(NSString*) tableName {

    // Set Values
    [dName setText:model.name];
    
    if ([model.others isEqualToString:@""]){
        [description setText:model.description];
    }else {
        [description setText:model.others];
    }
    [imgview setImage:model.img];
    model.delegate = self;
    if ( [tableName isEqualToString:@"InviteFriends"] ){
        [model setInvitedStatus:status];
    }else if ( [tableName isEqualToString:@"PrintInvites"] ){
        [model setInvitedStatus:0];
    }
    
}


#pragma mark Contacts  Delegate

-(void)contactInvited :(ContactsModel *)model{

    [checkBtn setImage:[UIImage imageNamed:model.checkImageName]];
}

@end
