//
//  PreferencesCellView.h
//  Untechable
//
//  Created by Abdul Rauf on 28/01/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"

@interface PreferencesCellView : UITableViewCell {
    
    
}

@property (nonatomic,strong)IBOutlet UILabel *socialNetworkName;

-(void)setCellValueswithSocialNetworkNake :(NSString *)networkName;

@end
