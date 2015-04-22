//
//  NameAndPhoneCellView.m
//  Untechable
//
//  Created by RIKSOF Developer on 4/21/15.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "NameAndPhoneCellView.h"
#import "CommonFunctions.h"

@implementation NameAndPhoneCellView

CommonFunctions *commonFunc;
- (void)awakeFromNib {
    // get the setted value of name and number and
    // set it in the fields by default
    commonFunc = [[CommonFunctions alloc] init];
    NSString *name = [ commonFunc getUserName ];
    
    NSString *userNameInDb = [[NSUserDefaults standardUserDefaults]
                  stringForKey:@"userName"];
    
    if( name == NULL || [name isEqual:@""]){
        _nameEditField.text = userNameInDb;
    } else {
        _nameEditField.text = name;
    }
    
    // get the value from local db or model
    //if model has no value then get from db
    NSString *phoneNumber = [commonFunc getPhoneNumber];
    
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
        [ commonFunc setPhoneNumber:self.textLabel.text];
    }
}


- (IBAction)nameChange:(id)sender {
    NSString *currentName = _nameEditField.text;
    
    NSString *valueToSave = currentName;
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [commonFunc setUserName:valueToSave];
}

- (IBAction)phoneNumberChange:(id)sender {
    NSString *currentPhoneNumber = _phoneEditField.text;
    
    NSString *valueToSave = currentPhoneNumber;
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"phoneNumber"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [commonFunc setPhoneNumber:valueToSave];
}





@end
