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

@protocol CustomTextTableViewCell <NSObject>
-(void)hideSaveButton:(BOOL)doHide;
-(void) saveSpendingTimeText;
@end

@interface CustomTextTableViewCell : UITableViewCell < UITextViewDelegate >

@property (nonatomic,strong)IBOutlet UITextView *customText;

-(void)setCellValuesWithDeleg :(NSString *)message deleg:(id)deleg;
@property (strong, nonatomic) IBOutlet UILabel *char_limit;


@property (weak, nonatomic) id deleg;
@property (weak, nonatomic) id<CustomTextTableViewCell> delegate;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;


@end
