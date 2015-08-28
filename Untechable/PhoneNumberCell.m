//
//  PhoneNumberCell.m
//  Untechable
//
//  Created by RIKSOF Developer on 12/26/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "PhoneNumberCell.h"


@implementation PhoneNumberCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellValues :(NSString *)numberType Number:(NSString *)phoneNumber{

    self.nubmerType.text = numberType;
    self.nubmer.text = phoneNumber;
}

@end
