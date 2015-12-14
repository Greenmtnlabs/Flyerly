//
//  HowToButtonCell.m
//  Untechable
//
//  Created by rufi on 14/12/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "HowToButtonCell.h"
#import "Common.h"

@implementation HowToButtonCell

@synthesize btnHowTo;

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
    
    btnHowTo.layer.cornerRadius = 10;
    [btnHowTo setTitle:NSLocalizedString(@"How To", nil) forState:normal];
    [btnHowTo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnHowTo setBackgroundColor:DEF_GRAY];
    
}

@end
