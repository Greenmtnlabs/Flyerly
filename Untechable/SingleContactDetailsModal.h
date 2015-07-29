//
//  ContactDetailsModal.h
//  Untechable
//
//  Created by arqam on 13/07/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface SingleContactDetailsModal : NSObject

@property (nonatomic,strong)NSString *contactName;
@property (nonatomic,strong)NSMutableArray *emailAddresses;
@property (nonatomic,strong)NSMutableArray *phoneNumbers;
@property (nonatomic,strong)NSString *customTextForContact;
@property (nonatomic,strong)NSMutableArray *cutomizingStatusArray;
@property BOOL *IsCustomized;



-(BOOL)hasContacts;


@end
