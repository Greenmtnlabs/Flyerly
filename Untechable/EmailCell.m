//
//  EmailCell.m
//  Untechable
//
//  Created by rufi on 01/10/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "EmailCell.h"

@implementation EmailCell
@synthesize emailButton,contactEmail;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellValues :(NSString *)email {
    self.contactEmail.text = email;
}


@end
