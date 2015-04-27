//
//  CustomTextTableViewCell.m
//  Untechable
//
//  Created by RIKSOF Developer on 12/29/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "CustomTextTableViewCell.h"

ContactsCustomizedModal *contactModal_;


@implementation CustomTextTableViewCell

@synthesize untechable,customText;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
int a;
-(void)setCellValues :(NSString *)message {
    a = message.length;
    self.customText.text = message;
    
}

-(void)awakeFromNib{
    int len = contactModal_.customTextForContact.length;
    _char_limit.text=[NSString stringWithFormat:@"%i",124-len];
}

-(void)textViewDidChange:(UITextView *)_customText
{
    int len = [untechable spendingTimeTxt].length;
    _char_limit.text=[NSString stringWithFormat:@"%i",124-len];
}

@end
