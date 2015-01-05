//
//  EmailCell.m
//  Untechable
//
//  Created by RIKSOF Developer on 12/26/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "EmailCell.h"

ContactsCustomizedModal *contactModal_;

@implementation EmailCell

@synthesize untechable,emailButton,contactEmail;

-(void)setCellValues :(NSString *)email {
    
    //NSMutableArray *alLEmails = [[NSMutableArray alloc] initWithArray:allEmail];
    self.contactEmail.text = email;
    
}

-(void)setCellModal :(ContactsCustomizedModal *)contactModal{

    contactModal_ = contactModal;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
