//
//  PreferencesCellView.m
//  Untechable
//
//  Created by Abdul Rauf on 28/01/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "PreferencesCellView.h"
#import "Common.h"

@implementation PreferencesCellView

@synthesize socialNetworkName,socialNetworkButton;

- (void)awakeFromNib {
    // Initialization code
}

-(void)setCellValueswithSocialNetworkNake :(NSString *)networkName LoginStatus:(BOOL)LoginStatus{
    
    UIColor *defGreen = [UIColor colorWithRed:66.0/255.0 green:247.0/255.0 blue:206.0/255.0 alpha:1.0];//GREEN
    UIColor *defGray = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1.0];//GRAY

    socialNetworkName.font = [UIFont fontWithName:APP_FONT size:19];
    [socialNetworkName setText:networkName];
    
    if ( LoginStatus ){
        [socialNetworkButton setTitle:@"Log Out" forState:UIControlStateNormal];
        NSLog(@"set button logout");
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
