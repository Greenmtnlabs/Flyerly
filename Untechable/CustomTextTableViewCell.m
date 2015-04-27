//
//  CustomTextTableViewCell.m
//  Untechable
//
//  Created by RIKSOF Developer on 12/29/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "CustomTextTableViewCell.h"

ContactsCustomizedModal *contactModal_;


@implementation CustomTextTableViewCell

@synthesize untechable,customText;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellValues :(NSString *)message {
    self.customText.text = message;
    int len = message.length;
    _char_limit.text=[NSString stringWithFormat:@"%i",124-len];

    
}


@end
