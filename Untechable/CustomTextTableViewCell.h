//
//  CustomTextTableViewCell.h
//  Untechable
//
//  Created by RIKSOF Developer on 12/29/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"
#import "ContactsCustomizedModal.h"

@interface CustomTextTableViewCell : UITableViewCell

@property (nonatomic,strong)  Untechable *untechable;

@property (nonatomic,strong)IBOutlet UITextView *customText;

-(void)setCellValues :(NSString *)message;

@end
