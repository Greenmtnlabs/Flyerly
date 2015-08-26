//
//  CustomTextTableViewCell.m
//
//  Created by RIKSOF Developer on 12/29/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "CustomTextTableViewCell.h"

ContactsCustomizedModal *contactModal_;


@implementation CustomTextTableViewCell

@synthesize customText;
@synthesize delegate;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellValuesWithDeleg :(NSString *)message deleg:(id)deleg {
    self.customText.text = message;
    self.customText.delegate = self;
    
    [self updateChrCounter:message];
    if( deleg != nil )
    self.delegate = deleg;
    
    [self applyLocalization];
}

-(void)applyLocalization{
    [_lblMessage_iPhone5 setText:NSLocalizedString(@"Select one or more modes", nil)];
    [_lblMessage_iPhone6 setText:NSLocalizedString(@"Select one or more modes", nil)];
    [_lblMessage_iPhone6Plus setText:NSLocalizedString(@"Select one or more modes", nil)];
}

-(void)updateChrCounter:(NSString *)message {
   
    int len = (int)message.length;
    _char_limit.text=[NSString stringWithFormat:@"%i",124-len];
    
}


#pragma mark - Delegate Methods
- (void)textViewDidChange:(UITextView *)textView{
    [self updateChrCounter:textView.text];
    [self.delegate saveSpendingTimeText];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text length] == 0)
    {
        if([textView.text length] != 0)
        {
            return YES;
        }
    }
    else if([[textView text] length] > 123)
    {
        return NO;
    }

    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }

    return YES;
}


@end
