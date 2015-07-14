//
//  ContactDetailsModal.h
//  Untechable
//
//  Created by arqam on 13/07/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface SingleContactDetailsModal : NSObject

@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSMutableArray *allEmails;
@property (nonatomic,strong)NSMutableArray *allPhoneNumbers;

/**
 * This is a sample json object for this model
 {
 name: "Rehan"
 allEmails:[
 ["abdul@rauf.com","email status 1/0 in string " ],
 ["abdul@rauf.com","email status 1/0 in string " ]
 ],
 allPhoneNumbers:[
 ["phonenumber123","sms status 1/0 in string ", "call status 1/0" ],
 ["phonenumber123","sms status 1/0 in string ", "call status 1/0" ]
 ]
 }
 */
@end
