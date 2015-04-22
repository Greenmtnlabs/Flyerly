//
//  NameAndPhoneCellView.m
//  Untechable
//
//  Created by RIKSOF Developer on 4/21/15.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "NameAndPhoneCellView.h"

@implementation NameAndPhoneCellView

NSString *currentEnteredUserName;
NSString *currentEnteredPhoneNumber;

- (void)awakeFromNib {
    // get the setted value of name and number and
    // set it in the fields by default
    NSString *name = [self getUserName];
    _nameEditField.text = name;
    
    NSString *phoneNumber = [self getPhoneNumber];
    _phoneEditField.text = phoneNumber;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)nameEditField:(id)sender {
    
    
}

- (IBAction)phoneEditField:(id)sender {
    
    if( [ self.textLabel.text isEqual:@""]){
        
    } else {
        [ self setPhoneNumber:self.textLabel.text];
    }
}

/**
 setting up user name got from the edit text
 */
- ( void ) setUserName:(NSString *)userName {
    currentEnteredUserName = userName;
}

/**
 get the current user name
 */
-( NSString *)getUserName{
    return currentEnteredUserName;
}

/**
 setting up user name got from the edit text
 */
- ( void ) setPhoneNumber:(NSString *)phoneNumber {
    currentEnteredPhoneNumber = phoneNumber;
}

/**
 get the current user name
 */
-( NSString *)getPhoneNumber{
    return currentEnteredPhoneNumber;
}

- (IBAction)nameChange:(id)sender {
    NSString *currentName = _nameEditField.text;
    [self setUserName:currentName];
}

- (IBAction)phoneNumberChange:(id)sender {
    NSString *currentPhoneNumber = _phoneEditField.text;
    [self setPhoneNumber:currentPhoneNumber];
}



@end
