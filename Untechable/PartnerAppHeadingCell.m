//
//  PartnerAppHeadingCell.m
//  Untechable
//
//  Created by rufi on 14/12/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "PartnerAppHeadingCell.h"
#import "Common.h"

@implementation PartnerAppHeadingCell

@synthesize lblHeading;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setLabelTitle: (NSString *) title{
    
    [lblHeading setText:title];
    [lblHeading setTextColor:[UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1.0]];
}

@end
