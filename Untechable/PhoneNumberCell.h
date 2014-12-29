//
//  PhoneNumberCell.h
//  Untechable
//
//  Created by RIKSOF Developer on 12/26/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"
#import "ContactsCustomizedModal.h"

@interface PhoneNumberCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *smsButton;
@property (strong, nonatomic) IBOutlet UIButton *callButton;

@property (nonatomic,strong)  Untechable *untechable;
@property (nonatomic,strong)  ContactsCustomizedModal *contactModal;

@property (nonatomic,strong)IBOutlet UILabel *nubmerType;
@property (nonatomic,strong)IBOutlet UILabel *nubmer;

-(void)setCellValues :(NSString *)nubmerType Number:(NSString *)phoneNumber;

-(void)setCellModal :(ContactsCustomizedModal *)contactModal;


@end
