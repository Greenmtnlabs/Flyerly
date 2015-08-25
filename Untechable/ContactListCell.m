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
    [contactName setText:model.contactName];
    
    if ( model.img != nil ){
        self.contactImage.image = model.img;
    } else {
        self.contactImage.image =[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dfcontact" ofType:@"jpg"]];
    }
    self.contactImage.layer.cornerRadius = self.contactImage.frame.size.width / 2;
    self.contactImage.clipsToBounds = YES;
    
    
    // Set social network status for untech
    NSInteger statusCount = 0;
    UIImageView *iconImage;
    
    iconImage = [_customizationStatus objectAtIndex:statusCount];
    if ( [model getEmailStatus] ) {
        iconImage.image = [UIImage imageNamed:@"email_selected"];
        statusCount++;
    }
    
    iconImage = [_customizationStatus objectAtIndex:statusCount];
    if ( [model getPhoneStatus] ) {
        iconImage.image = [UIImage imageNamed:@"sms_selected"];
        statusCount++;
    }
    
    iconImage = [_customizationStatus objectAtIndex:statusCount];
    if ( [model getSmsStatus] ) {
        iconImage.image = [UIImage imageNamed:@"phone_selected"];
        statusCount++;
    }
    model.delegate = self;
   
}
#pragma mark Contacts  Delegate

-(void)contactInvited :(ContactsCustomizedModal *)model{
    
    
}

/*
 * HERE WE SET untech IMAGE ,TITLE,DESCRICPTION,DATE AND SOCIAL NETWORK STATUS
 */
- (void)renderCell :(ContactsCustomizedModal *)contactModal LockStatus:(BOOL )status {
    
}

@end
