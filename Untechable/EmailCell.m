//
//  EmailCell.m
//  Untechable
//
//  Created by RIKSOF Developer on 12/26/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "EmailCell.h"

@implementation EmailCell

-(void)setCellValues :(NSString *)email {
    
    //NSMutableArray *alLEmails = [[NSMutableArray alloc] initWithArray:allEmail];
    self.email.text = email;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
