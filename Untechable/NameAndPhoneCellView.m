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
    
    NSString *userNameInDb = [[NSUserDefaults standardUserDefaults]
                  stringForKey:@"userName"];
    
    if( name == NULL || [name isEqual:@""]){
        _nameEditField.text = userNameInDb;
    } else {
        _nameEditField.text = name;
    }
    
    // get the value from local db or model
    //if model has no value then get from db
    NSString *phoneNumber = [self getPhoneNumber];
    
    NSString *phoneNumberInDb = [[NSUserDefaults standardUserDefaults]
                                 stringForKey:@"phoneNumber"];
    if( phoneNumber == NULL || [phoneNumber isEqual:@""]){
        _phoneEditField.text = phoneNumberInDb;
    } else {
        _phoneEditField.text = phoneNumber;
    }
    
    

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
    
    NSString *valueToSave = currentName;
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self setUserName:valueToSave];
}

- (IBAction)phoneNumberChange:(id)sender {
    NSString *currentPhoneNumber = _phoneEditField.text;
    
    NSString *valueToSave = currentPhoneNumber;
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"phoneNumber"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self setPhoneNumber:valueToSave];
}





@end
