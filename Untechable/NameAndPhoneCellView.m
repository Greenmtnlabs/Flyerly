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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)nameEditField:(id)sender {
    
    if( [self.textLabel.text  isEqual: @""] ){
        
    } else {
        [ self setUserName:self.textLabel.text];
    }
    
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
+ ( void ) setUserName:(NSString *)userName {
    currentEnteredUserName = userName;
}

/**
 get the current user name
 */
+( NSString *)getUserName{
    return currentEnteredUserName;
}

/**
 setting up user name got from the edit text
 */
+ ( void ) setPhoneNumber:(NSString *)phoneNumber {
    currentEnteredPhoneNumber = phoneNumber;
}

/**
 get the current user name
 */
+( NSString *)getPhoneNumber{
    return currentEnteredPhoneNumber;
}



@end
