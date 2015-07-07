//
//  SetupGuideOption.m
//  Untechable
//
//  Created by RIKSOF Developer on 7/7/15.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "SetupGuideOption.h"
#import "SetupGuideViewController.h"
#import "SettingsViewController.h"

@implementation SetupGuideOption

@synthesize setupBtn;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _statusLabel.text = @"";
    // Configure the view for the selected state
}

@end
