//
//  NameAndPhoneCellView.h
//  Untechable
//
//  Created by RIKSOF Developer on 4/21/15.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NameAndPhoneCellView : UITableViewCell

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *nameEditField;
@property (weak, nonatomic) IBOutlet UITextField *phoneEditField;

//setter getter for username
- ( void ) setUserName:(NSString *)userName;
- ( NSString *) getUserName;
//setter getter for phoneNumber
- ( void ) setPhoneNumber:( NSString *)phoneNumber;
- ( NSString *)getPhoneNumber;

- (IBAction)nameChange:(id)sender;
- (IBAction)phoneNumberChange:(id)sender;


@end
