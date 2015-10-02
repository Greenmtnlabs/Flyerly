//
//  CustomTextTableViewCell.m
//
//  Created by RIKSOF Developer on 12/29/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "CustomTextTableViewCell.h"

ContactsCustomizedModal *contactModal_;


@implementation CustomTextTableViewCell

@synthesize customText, lblSeperator;
@synthesize delegate;
@synthesize contact_Name, contact_Image;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellValuesWithDeleg :(NSString *)name message: (NSString *)message customText:(NSString *) spendingTimeText ContactImage:(UIImage *) contactImage deleg:(id)deleg {
    
    self.customText.text = spendingTimeText;
    [self.customText sizeToFit];
    self.customText.delegate = self;
    
    [_lblMessage setText:NSLocalizedString(@"How to notify?", nil)];

    [self updateChrCounter:message];
    
    self.contact_Name.text = message;
    if ( contactImage != nil ){
        self.contact_Image.image = contactImage;
    }

    contact_Name.numberOfLines = 0;
    [contact_Name sizeToFit];

    self.contact_Image.layer.cornerRadius = self.contact_Image.frame.size.width / 2;
    self.contact_Image.clipsToBounds = YES;
    
    UIColor *untechableGreen = [UIColor colorWithRed:(66/255.0) green:(247/255.0) blue:(206/255.0) alpha:1];
    
    self.lblSeperator.backgroundColor = untechableGreen;
    
    if( deleg != nil )
    self.delegate = deleg;
}


-(void)setCellValues :(NSString *)contactName ContactImage:(UIImage *) contactImage;
{
    
    
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if([text length] == 0) {
        if([textView.text length] != 0) {
            return YES;
        }
    } else if ([[textView text] length] > 123) {
        return NO;
    }

    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


@end
