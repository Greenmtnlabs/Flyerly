//
//  LobPostcardModel.m
//  lob-ios
//
//  Created by Zealous Amoeba on 1/3/14.
//  www.zealousamoeba.org
//  Copyright (c) 2014 Lob. All rights reserved.
//

#import "LobPostcardModel.h"
#import "LobAddressModel.h"

@implementation LobPostcardModel

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    if(self = [super initWithDictionary:dict])
    {
        self.postcardId = dict[@"id"];
        self.name = dict[@"name"];
        self.message = dict[@"message"];
        self.toAddress = [LobAddressModel initWithDictionary:dict[@"to"]];
        self.fromAddress = [LobAddressModel initWithDictionary:dict[@"from"]];
        self.status = dict[@"status"];
        self.price = dict[@"price"];
        self.frontUrl = dict[@"front"];
        self.backUrl = dict[@"back"];
        
        if(dict[@"full_bleed"]) self.fullBleed = [dict[@"full_bleed"] boolValue];
        else self.fullBleed = false;
    }
    return self;
}

- (instancetype)initPostcardWithId:(NSString*)postcardId
{
    return [self initWithDictionary:@{@"id" : postcardId}];
}

- (instancetype)initPostcardWithName:(NSString*)name
                             message:(NSString*)message
                           toAddress:(LobAddressModel*)toAddress
                         fromAddress:(LobAddressModel*)fromAddress
                              status:(NSString*)status
                               price:(NSString*)price
                            frontUrl:(NSString*)frontUrl
                             backUrl:(NSString*)backUrl
                           fullBleed:(BOOL)fullBleed
{
    NSDictionary *dict = @{@"name" : name,
                           @"message" : message,
                           @"status" : status,
                           @"price" : price,
                           @"front" : frontUrl,
                           @"back" : backUrl};
    
    self = [self initWithDictionary:dict];
    
    self.toAddress = toAddress;
    self.fromAddress = fromAddress;
    self.fullBleed = fullBleed;
    
    return self;
}

#pragma mark -
#pragma mark Description

- (NSString *)description
{
    NSString *format = @"(%@) %@, %@ | %@ | %@ | %@, %@";
    return [NSString stringWithFormat:format,self.postcardId,self.name,self.message,self.toAddress,self.fromAddress,self.status,self.price];
}

#pragma mark -
#pragma mark Request Methods

- (NSString *)urlParamsForCreateRequest
{
    NSMutableArray *items = [NSMutableArray array];
    
    NSArray *nameValues = @[@[@"name" , @"name"],
                            @[@"full_bleed", @"fullBleed"],
                            @[@"message" , @"message"],
                            @[@"status" , @"status"],
                            @[@"price" , @"price"],
                            @[@"front" , @"frontUrl"],
                            @[@"back" , @"backUrl"]];
    

    [LobAbstractModel populateItems:items
                          fromPairs:nameValues
                           onObject:self
                             prefix:@""];
    
    NSString *toParams = [self.toAddress urlParamsForInclusionWithPrefix:@"to"];
    [items addObject:toParams];
    
    NSString *fromParams = [self.fromAddress urlParamsForInclusionWithPrefix:@"from"];
    [items addObject:fromParams];
    
    return [LobAbstractModel paramStringWithItems:items];
}

@end
