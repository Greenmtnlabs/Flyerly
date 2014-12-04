//
//  ServerAccountDetailsViewCell.m
//  Untechable
//
//  Created by RIKSOF Developer on 12/4/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "ServerAccountDetailsViewCell.h"

@implementation ServerAccountDetailsViewCell

@synthesize inputFeild,inputLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellValueswithInputLabel :(NSString *)label FeildPlaceholder:(NSString *)palceHolder{
    
    self.inputLabel.text = label;
    self.inputFeild.placeholder = palceHolder;
}

@end
