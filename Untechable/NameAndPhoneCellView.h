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

//setter getter for username
+ ( void ) setUserName:(NSString *)userName;
+ ( NSString *) getUserName;
//setter getter for phoneNumber
+ ( void ) setPhoneNumber:( NSString *)phoneNumber;
+ ( NSString *)getPhoneNumber;

- (IBAction)nameEditField:(id)sender;
- (IBAction)phoneEditField:(id)sender;

@end
