//
//  SettingsCellView.m
//  Untechable
//
//  Created by Abdul Rauf on 28/01/2015.
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
        [socialNetworkButton setTitle:@"Log Out" forState:UIControlStateNormal];
        [loginStatus setText:@"Logged In"];
        NSLog(@"set button logout");
    }
    
    UIImage *socialIocn = [UIImage imageNamed:ImageName];
    [socialNetworkImage setImage:socialIocn];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
