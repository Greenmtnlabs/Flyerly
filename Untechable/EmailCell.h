//
//  EmailCell.h
//  Untechable
//
//  Created by RIKSOF Developer on 12/26/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"
#import "ContactsCustomizedModal.h"

@interface EmailCell : UITableViewCell

@property (nonatomic,strong)IBOutlet UILabel *contactEmail;
@property (strong, nonatomic) IBOutlet UIButton *emailButton;

@property (nonatomic,strong)  Untechable *untechable;

-(void)setCellValues :(NSString *)email;

-(void)setCellValues :(ContactsCustomizedModal *) contactModal Number:(int)phoneNumber;

-(void)setCellModal :(ContactsCustomizedModal *)contactModal;

@end
