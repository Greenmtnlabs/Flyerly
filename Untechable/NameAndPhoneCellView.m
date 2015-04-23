//
//  NameAndPhoneCellView.m
//  Untechable
//
//  Created by RIKSOF Developer on 4/21/15.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "NameAndPhoneCellView.h"
#import "CommonFunctions.h"
#import "Common.h"

@implementation NameAndPhoneCellView

NSString *userNameInDb;
NSString *phoneNumberInDb;

CommonFunctions *commonFunc;
- (void)awakeFromNib {
    // get the setted value of name and number and
    // set it in the fields by default
    commonFunc = [[CommonFunctions alloc] init];
    
    userNameInDb = [[NSUserDefaults standardUserDefaults]
                  stringForKey:@"userName"];
    
    // get the value from the local db
    phoneNumberInDb = [[NSUserDefaults standardUserDefaults]
                                 stringForKey:@"phoneNumber"];
    
    NSString *nameAndNumberToBeShown = [NSString stringWithFormat:@"%@  %@", userNameInDb, phoneNumberInDb];
    _onTouchLabel.text = nameAndNumberToBeShown;
        
    if( IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 ){
        
        UIImage *image = [UIImage imageNamed:@"telephone_2x.png"];
        [_nameAndPhoneImage setImage:image];
        
    } else if( IS_IPHONE_6_PLUS) {
        
        UIImage *image = [UIImage imageNamed:@"telephone_3x.png"];
        [_nameAndPhoneImage setImage:image];
        
    } else {
        
        UIImage *image = [UIImage imageNamed:@"telephone_2x.png"];
        [_nameAndPhoneImage setImage:image];
        
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 On tapping the edit button
 Show an AlerView
 So user can enter new name and password
 */
- (IBAction)onEditButtonTouch:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                     message:@"Enter Your Name and Number"
                                                    delegate:self
                                           cancelButtonTitle:@"Done"
                                           otherButtonTitles:nil, nil];
    
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    //Name field
    UITextField * nameField = [alert textFieldAtIndex:0];
    nameField.text = userNameInDb;
    nameField.keyboardType = UIKeyboardTypeTwitter;
    nameField.placeholder = @"Name";
    
    //phone number field
    UITextField * phoneNumberField = [alert textFieldAtIndex:1];
    phoneNumberField.text = phoneNumberInDb;
    phoneNumberField.secureTextEntry=NO;
    phoneNumberField.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumberField.placeholder = @"Phone Number";
    
    [alert show];

}

/**
 Action catch for the uiAlertview buttons
 we have to save name and phone number on button press
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //getting text from the text fields
    NSString *name = [alertView textFieldAtIndex:0].text;
    NSString *phoneNumber = [alertView textFieldAtIndex:1].text;
    
    //setting the name in model
    NSString *nameToSave = name;
    [[NSUserDefaults standardUserDefaults] setObject:nameToSave forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    userNameInDb = name;
    [commonFunc setUserName:nameToSave];
    
    //setting the phone number in model
    NSString *phoneNumberTobeSave = phoneNumber;
    [[NSUserDefaults standardUserDefaults] setObject:phoneNumberTobeSave forKey:@"phoneNumber"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    phoneNumberInDb = phoneNumber;
    
    [commonFunc setPhoneNumber:phoneNumberTobeSave];
    
    // now show the updated username and number 
    NSString *nameAndNumberToBeShown = [NSString stringWithFormat:@"%@  %@", name, phoneNumber];
    _onTouchLabel.text = nameAndNumberToBeShown;

}


@end
