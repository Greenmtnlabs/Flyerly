//
//  EditButtonCell.m
//  Untechable
//
//  Created by rufi on 22/10/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//
#import "Common.h"
#import "EditButtonCell.h"

@implementation EditButtonCell

@synthesize btnChangeUntechNowSettings;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*
 * Method to update UI
 * @params:
 *      void
 * @return:
 *      void
 */
-(void)updateUI{
    
    btnChangeUntechNowSettings.layer.cornerRadius = 10;
    [btnChangeUntechNowSettings setTitle:NSLocalizedString(@"Change Untech Now Settings", nil) forState:normal];
    [btnChangeUntechNowSettings setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnChangeUntechNowSettings setBackgroundColor:DEF_GRAY];

}

@end
