//
//  PhoneNumberCell.m
//  Untechable
//
//  Created by RIKSOF Developer on 12/26/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "PhoneNumberCell.h"

ContactsCustomizedModal *contactModal_;

@implementation PhoneNumberCell

@synthesize untechable,contactModal;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellValues :(NSString *)nubmerType Number:(NSString *)phoneNumber{

    self.nubmerType.text = nubmerType;
    self.nubmer.text = phoneNumber;
}

-(void)setCellModal :(ContactsCustomizedModal *)contactModal{

    contactModal_ = contactModal;
}

- (IBAction)btnClic:(id)sender {
    
    BOOL alreadyExist = NO;
    
    if( sender == _smsButton ){
        
        for ( int i = 0; i < untechable.customizedContacts.count; i++ ){
            ContactsCustomizedModal *tempModal = [[ContactsCustomizedModal alloc] init];
            
            tempModal = [untechable.customizedContacts objectAtIndex:i];
            
            if ( [tempModal.name isEqualToString:contactModal_.name] ){
                
                alreadyExist = YES;
            }
        }
        
        if ( alreadyExist ){
            
        }else {
            
            NSMutableArray *temp = [[NSMutableArray alloc] init];
            NSMutableArray *temp_ = [[NSMutableArray alloc] init];
            
            NSMutableDictionary *contactDict = [[NSMutableDictionary alloc] init];
            
            [contactDict setObject:contactModal_ forKey:contactModal_.name];
            
            NSMutableDictionary *status = [[NSMutableDictionary alloc] init];
            
            NSMutableArray *allStatus = [[ NSMutableArray alloc] initWithCapacity:2];
            
            [allStatus insertObject:@"YES" atIndex:0];
            
            [status setObject:allStatus forKey:self.nubmerType.text];
            
            [temp addObject:status];
            
            [temp_ addObject:contactDict];
            
            contactModal_.phoneNumbersStatus  = temp;
            
            untechable.customizedContacts = temp_;
            [untechable.customizedContacts addObject:contactDict];
        }
        
    }else if ( sender == _callButton ){
    
    }
}

@end
