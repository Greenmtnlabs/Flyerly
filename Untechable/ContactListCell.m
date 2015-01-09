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

@synthesize contactName,contactImage;

/*
 * Set CellObjects
 */
-(void)setCellObjects :(ContactsCustomizedModal *)model :(int)status :(NSString*) tableName {
    
    // Set Values
    [contactName setText:model.name];
    
    if ( model.img != nil ){
        self.contactImage.image = model.img;
    }
    self.contactImage.layer.cornerRadius = self.contactImage.frame.size.width / 2;
    self.contactImage.clipsToBounds = YES;
    
    if ( model.IsCustomized ){
        // HERE WE SET SOCIAL NETWORK STATUS OF FLYER
        NSInteger statusCount = 0;
        UIImageView *iconImage;
        
        
        iconImage = [_customizationStatus objectAtIndex:statusCount];
        if ( [[model getEmailStatus] isEqualToString:@"1"] ) {
            iconImage.image = [UIImage imageNamed:@"email_selected"];
            statusCount++;
        }
        
        iconImage = [_customizationStatus objectAtIndex:statusCount];
        if ( [[model getPhoneStatus] isEqualToString:@"1"] ) {
            iconImage.image = [UIImage imageNamed:@"sms_selected"];
            statusCount++;
        }
        
        iconImage = [_customizationStatus objectAtIndex:statusCount];
        if ( [[model getSmsStatus] isEqualToString:@"1"] ) {
            iconImage.image = [UIImage imageNamed:@"phone_selected"];
            statusCount++;
        }
    }
    /*if ([model.others isEqualToString:@""]){
        [description setText:model.description];
    }else {
        [description setText:model.others];
    }
    [imgview setImage:model.img];*/
    model.delegate = self;
   
}
#pragma mark Contacts  Delegate

-(void)contactInvited :(ContactsCustomizedModal *)model{
    
    //[checkBtn setImage:[UIImage imageNamed:model.checkImageName]];
}

/*
 * HERE WE SET FLYER IMAGE ,TITLE,DESCRICPTION,DATE AND SOCIAL NETWORK STATUS
 */
- (void)renderCell :(ContactsCustomizedModal *)contactModal LockStatus:(BOOL )status {
    
    
    
}

@end
