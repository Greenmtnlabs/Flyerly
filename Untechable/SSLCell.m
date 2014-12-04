//
//  SSLCell.m
//  Untechable
//
//  Created by RIKSOF Developer on 12/4/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "SSLCell.h"

@implementation SSLCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.sslSwitch addTarget:self
                       action:@selector(sslStateChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
