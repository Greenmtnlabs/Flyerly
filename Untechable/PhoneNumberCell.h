//
//  PhoneNumberCell.h
//  Untechable
//
//  Created by RIKSOF Developer on 12/26/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneNumberCell : UITableViewCell

@property (nonatomic,strong)IBOutlet UILabel *nubmerType;
@property (nonatomic,strong)IBOutlet UILabel *nubmer;

-(void)setCellValues :(NSString *)nubmerType Number:(NSString *)phoneNumber;

@end
