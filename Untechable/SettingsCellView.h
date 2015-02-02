//
//  SettingsCellView.h
//  Untechable
//
//  Created by Abdul Rauf on 28/01/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"

@interface SettingsCellView : UITableViewCell {
    
    
}

@property (nonatomic,strong)IBOutlet UIImageView *socialNetworkImage;
@property (nonatomic,strong)IBOutlet UILabel *socialNetworkName;
@property (nonatomic,strong)IBOutlet UILabel *loginStatus;
@property (nonatomic,strong)IBOutlet UIButton *socialNetworkButton;

-(void)setCellValueswithSocialNetworkName :(NSString *)networkName LoginStatus:(BOOL)LoginStatus NetworkImage:(NSString *)ImageName;

@end
