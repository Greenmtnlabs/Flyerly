//
//  EmailTableViewCell.m
//  Untechable
//
//  Created by Muhammad Raheel on 28/11/2014.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "EmailTableViewCell.h"

@interface EmailTableViewCell ()

@end

@implementation EmailTableViewCell

@synthesize button1;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
