//
//  LobCheckModel.m
//  lob-ios
//
//  Created by Zealous Amoeba on 1/3/14.
//  www.zealousamoeba.org
//  Copyright (c) 2014 Lob. All rights reserved.
//

#import "LobCheckModel.h"
#import "LobAddressModel.h"
#import "LobBankAccountModel.h"

@implementation LobCheckModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if(self = [super initWithDictionary:dict]) {
        self.checkId = dict[@"id"];
        self.name = dict[@"name"];
        self.checkNumber = dict[@"check_number"];
        self.memo = dict[@"memo"];
        self.amount = dict[@"amount"];
        self.toAddress = [LobAddressModel initWithDictionary:dict[@"to"]];
        self.bank = [LobBankAccountModel initWithDictionary:dict[@"bank_account"]];
        self.status = dict[@"status"];
        self.message = dict[@"message"];
    }
    return self;
}

- (instancetype)initCheckWithId:(NSString *)checkId
{
    return [self initWithDictionary:@{@"id" : checkId}];
}

- (instancetype)initCheckWithName:(NSString *)name
                      checkNumber:(NSString *)checkNumber
                             memo:(NSString *)memo
                           amount:(NSString *)amount
                        toAddress:(LobAddressModel *)toAddress
                      bankAccount:(LobBankAccountModel *)bank
                           status:(NSString *)status
                          message:(NSString *)message
{
    NSDictionary *dict = @{@"name" : name,
                           @"check_number" : checkNumber,
                           @"memo" : memo,
                           @"amount" : amount,
                           @"status" : status,
                           @"message" : message};

    self = [self initWithDictionary:dict];
    
    self.toAddress = toAddress;
    self.bank = bank;
    
    return self;
}

#pragma mark -
#pragma mark Description

- (NSString *)description
{
    NSString *format = @"(%@) %@, %@ %@, %@ | %@ | %@ | %@, %@";
    return [NSString stringWithFormat:format,self.checkId,self.name,self.checkNumber,self.memo,self.amount,self.toAddress,self.bank,self.status,self.message];
}

#pragma mark -
#pragma mark Request Methods

- (NSString *)urlParamsForCreateRequest
{
    NSMutableArray *items = [NSMutableArray array];
    
    NSArray *nameValues = @[@[@"name" , @"name"],
                            @[@"check_number" , @"checkNumber"],
                            @[@"memo" , @"memo"],
                            @[@"amount" , @"amount"],
                            @[@"status" , @"status"],
                            @[@"message" , @"message"]];
    
    [LobAbstractModel populateItems:items
                          fromPairs:nameValues
                           onObject:self
                             prefix:@""];
    
    if(self.toAddress != NULL)
    {
        NSString *addrParams = [self.toAddress urlParamsForInclusionWithPrefix:@"to"];
        [items addObject:addrParams];
    }
    
    [items addObject:[NSString stringWithFormat:@"bank_account=%@",[self.bank bankId]]];
    
    return [LobAbstractModel paramStringWithItems:items];
}

@end
