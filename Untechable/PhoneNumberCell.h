//
//  PhoneNumberCell.h
//  Untechable
//
//  Created by RIKSOF Developer on 12/26/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsCustomizedModal.h"

@interface PhoneNumberCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *smsButton;
@property (strong, nonatomic) IBOutlet UIButton *callButton;

@property (strong,nonatomic)IBOutlet UILabel *nubmerType;
@property (strong,nonatomic)IBOutlet UILabel *nubmer;

-(void)setCellValues :(NSString *)numberType Number:(NSString *)phoneNumber;
@end
