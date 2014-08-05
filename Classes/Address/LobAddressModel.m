//
//  LobAddressModel.m
//  lob-ios
//
//  Created by Zealous Amoeba on 1/3/14.
//  www.zealousamoeba.org
//  Copyright (c) 2014 Lob. All rights reserved.
//

#import "LobAddressModel.h"

@implementation LobAddressModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if(self = [super initWithDictionary:dict])
    {
        self.addressId = dict[@"id"];
        self.name = dict[@"name"];
        self.email = dict[@"email"];
        self.phone = dict[@"phone"];
        self.addressLine1 = dict[@"address_line1"];
        self.addressLine2 = dict[@"address_line2"];
        self.addressCity = dict[@"address_city"];
        self.addressState = dict[@"address_state"];
        self.addressZip = dict[@"address_zip"];
        self.addressCountry = dict[@"address_country"];
    }
    return self;
}

- (instancetype)initAddressWithId:(NSString *)addressId
{
    return [self initWithDictionary:@{@"id" : addressId}];
}

- (instancetype)initAddressWithName:(NSString *)name
                              email:(NSString *)email
                              phone:(NSString *)phone
                       addressLine1:(NSString *)addressLine1
                       addressLine2:(NSString *)addressLine2
                        addressCity:(NSString *)addressCity
                       addressState:(NSString *)addressState
                         addressZip:(NSString *)addressZip
                     addressCountry:(NSString *)addressCountry
{
    NSDictionary *dict = @{@"name" : name,
                           @"email" : email,
                           @"phone" : phone,
                           @"address_line1" : addressLine1,
                           @"address_line2" : addressLine2,
                           @"address_city" : addressCity,
                           @"address_state" : addressState,
                           @"address_zip" : addressZip,
                           @"address_country" : addressCountry};

    return [self initWithDictionary:dict];
}

#pragma mark -
#pragma mark Description

- (NSString *)description
{
    NSString *format = @"(%@) %@, %@, %@ - %@ %@, %@ %@, %@, %@";
    return [NSString stringWithFormat:format,self.addressId,self.name,self.email,self.phone,self.addressLine1,self.addressLine2,self.addressCity,self.addressState,self.addressZip,self.addressCountry];
}

#pragma mark -
#pragma mark Request Methods

- (NSString *)urlParamsForCreateRequest
{
    NSMutableArray *items = [NSMutableArray array];
    
    NSArray *nameValues = @[@[@"name", @"name"],
                            @[@"address_line1",@"addressLine1"],
                            @[@"address_line2",@"addressLine2"],
                            @[@"address_city",@"addressCity"],
                            @[@"address_state",@"addressState"],
                            @[@"address_zip",@"addressZip"],
                            @[@"address_country",@"addressCountry"]];
    
    [LobAbstractModel populateItems:items
                          fromPairs:nameValues
                           onObject:self
                             prefix:@""];
    
    return [LobAbstractModel paramStringWithItems:items];
}

- (NSString *)urlParamsForInclusionWithPrefix:(NSString *)prefix
{
    if(self.addressId != NULL && ![self.addressId isEqualToString:@""])
        return [NSString stringWithFormat:@"%@=%@",prefix,self.addressId];
    else
    {
        NSArray *nameValues = @[@[@"name",@"name"],
                                @[@"email",@"email"],
                                @[@"phone",@"phone"],
                                @[@"address_line1",@"addressLine1"],
                                @[@"address_line2",@"addressLine2"],
                                @[@"address_city",@"addressCity"],
                                @[@"address_state",@"addressState"],
                                @[@"address_zip",@"addressZip"],
                                @[@"address_country",@"addressCountry"]];
    
        NSMutableArray *items = [NSMutableArray array];
        
        [LobAbstractModel populateItems:items
                              fromPairs:nameValues
                               onObject:self
                                 prefix:prefix];
        
        return [LobAbstractModel paramStringWithItems:items];
    }
}

@end
