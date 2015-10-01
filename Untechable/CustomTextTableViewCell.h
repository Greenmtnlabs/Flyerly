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

-(void)setCellValuesWithDeleg :(NSString *)name message: (NSString *)message customText:(NSString *) spendingTimeText ContactImage:(UIImage *) contactImage deleg:(id)deleg;
@property (strong, nonatomic) IBOutlet UILabel *char_limit;


@property (weak, nonatomic) id deleg;
@property (weak, nonatomic) id<CustomTextTableViewCell> delegate;

@property (strong, nonatomic) IBOutlet UILabel *lblMessage;
@property (strong, nonatomic) IBOutlet UILabel *contact_Name;
@property (strong, nonatomic) IBOutlet UIImageView *contact_Image;

@property (strong, nonatomic) IBOutlet UILabel *lblSeperator;

@end
