//
//  LobJobModel.m
//  lob-ios
//
//  Created by Zealous Amoeba on 1/3/14.
//  www.zealousamoeba.org
//  Copyright (c) 2014 Lob. All rights reserved.
//

#import "LobJobModel.h"
#import "LobAddressModel.h"
#import "LobPackagingModel.h"
#import "LobServiceModel.h"
#import "LobObjectModel.h"

@implementation LobJobModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if(self = [super initWithDictionary:dict])
    {
        self.jobId = dict[@"id"];
        self.name = dict[@"name"];
        self.price = dict[@"price"];
        self.toAddress = [LobAddressModel initWithDictionary:dict[@"to"]];
        self.fromAddress = [LobAddressModel initWithDictionary:dict[@"from"]];
        self.quantity = dict[@"quantity"];
        self.status = dict[@"status"];
        self.packaging = [LobPackagingModel initWithDictionary:dict[@"packaging"]];
        self.service = [LobServiceModel initWithDictionary:dict[@"service"]];
        self.objects = [LobObjectModel modelsFromArrayOfDictionaries:dict[@"objects"]];
    }
    return self;
}

- (instancetype)initJobWithId:(NSString*)jobId
{
    return [self initWithDictionary:@{@"id" : jobId}];
}

- (instancetype)initJobWithName:(NSString *)name
                          price:(NSString *)price
                      toAddress:(LobAddressModel *)toAddress
                    fromAddress:(LobAddressModel *)fromAddress
                       quantity:(NSString *)quantity
                         status:(NSString *)status
                       tracking:(NSString *)tracking
                      packaging:(LobPackagingModel *)packaging
                        service:(LobServiceModel *)service
                        objects:(NSArray *)objects
{
    NSDictionary *dict = @{@"name" : name,
                           @"price" : price,
                           @"quantity" : quantity,
                           @"status" : status,
                           @"tracking" : tracking};
    self = [self initWithDictionary:dict];
    
    self.packaging = packaging;
    self.service = service;
    self.objects = objects;
    
    return self;
}

#pragma mark -
#pragma mark Description

- (NSString *)description
{
    NSString *format = @"(%@) %@, %@ | %@ | %@ | %@, %@ | %@ | %@ | %@";
    return [NSString stringWithFormat:format,self.jobId,self.name,self.price,self.toAddress,self.fromAddress,self.quantity,self.status,self.packaging,self.service,self.objects];
}

#pragma mark -
#pragma mark Request Methods

-(NSString*)urlParamsForCreateRequest
{
    NSMutableArray *items = [NSMutableArray array];
    
    NSArray *nameValues = @[@[@"name" , @"name"],
                            @[@"price" , @"price"],
                            @[@"qunatity" , @"quantity"],
                            @[@"status" , @"status"]];
    
    [LobAbstractModel populateItems:items
                          fromPairs:nameValues
                           onObject:self
                             prefix:@""];
    
    if(self.toAddress != NULL)
    {
        NSString *addrParams = [self.toAddress urlParamsForInclusionWithPrefix:@"to"];
        [items addObject:addrParams];
    }
    
    if(self.fromAddress != NULL)
    {
        NSString *addrParams = [self.fromAddress urlParamsForInclusionWithPrefix:@"from"];
        [items addObject:addrParams];
    }
    
    if(self.packaging != NULL)
        [items addObject:[NSString stringWithFormat:@"packaging_id=%@",[self.packaging packagingId]]];

    if(self.service != NULL)
        [items addObject:[NSString stringWithFormat:@"service_id=%@",[self.service serviceId]]];
    
    int index = 1;
    for(LobObjectModel *object in self.objects)
    {
        NSString *name = [NSString stringWithFormat:@"object%i",index];
        NSString *item = [object urlParamsForInclusionWithPrefix:name];
        [items addObject:item];
        index++;
    }
    
    return [LobAbstractModel paramStringWithItems:items];
}


@end
