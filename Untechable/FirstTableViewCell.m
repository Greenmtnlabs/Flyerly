//
//  FirstTableViewCell.m
//  Untechable
//
//  Created by RIKSOF Developer on 12/26/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "FirstTableViewCell.h"

@implementation FirstTableViewCell

@synthesize contactName,contactImage;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellValues :(NSString *)contactName{
    
    self.contactName.text = contactName;
}

@end
