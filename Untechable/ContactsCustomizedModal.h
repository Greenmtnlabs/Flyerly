//
//  ContactsModal.h
//  Untechable
//
//  Created by RIKSOF Developer on 12/24/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Untechable.h"

@class ContactsCustomizedModal;

@protocol ContactsCustomizedModalDelegate <NSObject>

-(void)contactInvited :(ContactsCustomizedModal *)model;
@end


@interface ContactsCustomizedModal : NSObject

// Model variables to be saved in database
@property (nonatomic,strong)NSString *contactName;
@property (nonatomic,strong)NSString *customTextForContact;
@property (nonatomic,strong)NSMutableArray *allEmails;
@property (nonatomic,strong)NSMutableArray *allPhoneNumbers;


// Extras
@property (nonatomic,weak) id <ContactsCustomizedModalDelegate>delegate;

// UI related related bars
@property (nonatomic,strong)UIImage *img;
@property (nonatomic,strong)NSString *imageUrl;
@property (nonatomic,strong)NSString *checkImageName;
@property (nonatomic,assign)int status;


// Functions

-(BOOL)getEmailStatus;
-(BOOL)getSmsStatus;
-(BOOL)getPhoneStatus;

@end
