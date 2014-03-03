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
-(void)setCellObjects :(ContactsModel *)model :(int)status {

    // Set Values
    [dName setText:model.name];
    
    if (model.others != nil){
        [description setText:model.description];
    }else {
        [description setText:model.others];
    }
    [imgview setImage:model.img];
     model.delegate = self;
    [model setInvitedStatus:status];
   
    
}


#pragma mark Contacts  Delegate

-(void)contactInvited :(ContactsModel *)model{

    [checkBtn setBackgroundImage:[UIImage imageNamed:model.checkImageName] forState:UIControlStateNormal];
}

@end
