//
//  LobBankAccountModel.m
//  lob-ios
//
//  Created by Zealous Amoeba on 1/3/14.
//  www.zealousamoeba.org
//  Copyright (c) 2014 Lob. All rights reserved.
//

#import "LobBankAccountModel.h"
#import "LobAddressModel.h"

@implementation LobBankAccountModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if(self = [super initWithDictionary:dict])
    {
        self.bankId = dict[@"id"];
        self.routingNumber = dict[@"routing_number"];
        self.accountNumber = dict[@"account_number"];
        self.bankCode = dict[@"bank_code"];
        self.signatory = dict[@"signatory"];
        self.bankAddress = [LobAddressModel initWithDictionary:dict[@"bank_address"]];
        self.accountAddress = [LobAddressModel initWithDictionary:dict[@"account_address"]];
    }
    return self;
}

- (instancetype)initBankAccountWithId:(NSString *)bankId
{
    return [self initWithDictionary:@{@"id" : bankId}];
}

- (instancetype)initBankAccountWithRoutingNumber:(NSString *)routingNumber
                                   accountNumber:(NSString *)accountNumber
                                        bankCode:(NSString *)bankCode
                                        signatory:(NSString *)signatory
                                     bankAddress:(LobAddressModel *)bankAddress
                                  accountAddress:(LobAddressModel *)accountAddress
{
    NSDictionary *dict = @{@"routine_number" : routingNumber,
                           @"account_number" : accountNumber};
    
    self = [self initWithDictionary:dict];
    
    self.bankAddress = bankAddress;
    self.accountAddress = accountAddress;
    
    return self;
}

#pragma mark -
#pragma mark Description 

- (NSString *)description
{
    NSString *format = @"(%@) %@ %@, %@ | %@ | %@";
    return [NSString stringWithFormat:format,self.bankId,self.routingNumber,self.accountNumber,self.bankCode,self.bankAddress,self.accountAddress];
}

#pragma mark -
#pragma mark Request Methods

- (NSString *)urlParamsForCreateRequest
{
    NSMutableArray *items = [NSMutableArray array];
    
    NSArray *nameValues = @[@[@"routing_number",@"routingNumber"],
                            @[@"account_number",@"accountNumber"],
                            @[@"signatory",@"signatory"],
                            @[@"bank_code",@"bankCode"]];
    
    [LobAbstractModel populateItems:items
                          fromPairs:nameValues
                           onObject:self
                             prefix:@""];
    
    if(self.bankAddress != NULL)
    {
        NSString *addrParams = [self.bankAddress urlParamsForInclusionWithPrefix:@"bank_address"];
        [items addObject:addrParams];
    }
    
    if(self.accountAddress != NULL)
    {
        NSString *addrParams = [self.accountAddress urlParamsForInclusionWithPrefix:@"account_address"];
        [items addObject:addrParams];
    }
    
    return [LobAbstractModel paramStringWithItems:items];
}

@end
