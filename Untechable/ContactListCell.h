//
//  ContactListCell.h
//  Untechable
//
//  Created by RIKSOF Developer on 12/23/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactListCell : UITableViewCell

@property (nonatomic,strong)IBOutlet UILabel *contactName;
@property (nonatomic,strong)IBOutlet UIButton *phone;
@property (nonatomic,strong)IBOutlet UIButton *sms;
@property (nonatomic,strong)IBOutlet UIButton *email;

@end
