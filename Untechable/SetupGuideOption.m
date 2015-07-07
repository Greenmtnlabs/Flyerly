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

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _statusLabel.text = @"";
    // Configure the view for the selected state
}

- (IBAction)onTouchSetup:(id)sender {
    
    UIViewController *tv = (UIViewController *) self.superview.superview;
    
    SetupGuideViewController *secondSetupScreen = [[SetupGuideViewController alloc] initWithNibName:@"SetupGuideViewController" bundle:nil];
    //secondSetupScreen.untechable = untechable;
    [tv.navigationController pushViewController:secondSetupScreen animated:YES];
    
}
@end
