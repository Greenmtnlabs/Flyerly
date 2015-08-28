//
//  SettingsCellView.m
//  Untechable
//
//  Created by RIKSOF Developer on 28/01/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "SettingsCellView.h"
#import "Common.h"

@implementation SettingsCellView

@synthesize socialNetworkName,socialNetworkButton,loginStatus,socialNetworkImage;

- (void)awakeFromNib {
    // Initialization code
}

-(void)setCellValueswithSocialNetworkName :(NSString *)networkName LoginStatus:(BOOL)LoginStatus NetworkImage:(NSString *)ImageName{

    socialNetworkName.font = [UIFont fontWithName:APP_FONT size:19];
    [socialNetworkName setText:networkName];
    
    if ( LoginStatus ){
        [socialNetworkButton setTitle:NSLocalizedString(@"Log Out", nil) forState:UIControlStateNormal];
        [loginStatus setText: NSLocalizedString(@"Logged In", nil)];
        NSLog(@"set button logout");
    } else {
        [socialNetworkButton setTitle:NSLocalizedString(@"Log In", nil) forState:UIControlStateNormal];
        [loginStatus setText: NSLocalizedString(@"Logged Out", nil)];
    
    }
    
    UIImage *socialIocn = [UIImage imageNamed:ImageName];
    [socialNetworkImage setImage:socialIocn];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
