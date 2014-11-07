//
//  LobServiceModel.m
//  lob-ios
//
//  Created by Zealous Amoeba on 1/3/14.
//  www.zealousamoeba.org
//  Copyright (c) 2014 Lob. All rights reserved.
//

#import "LobServiceModel.h"

@implementation LobServiceModel
@synthesize dateCreated = _dateCreated;
@synthesize dateModified = _dateModified;

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if(self = [super init])
    {
        self.dateCreated = NULL;
        self.dateModified = NULL;
        
        self.serviceId = dict[@"id"];
        self.name = dict[@"name"];
    }
    return self;
}

- (instancetype)initServiceWithId:(NSString*)serviceId
{
    return [self initWithDictionary:@{@"id" : serviceId}];
}

- (instancetype)initServiceWithName:(NSString*)name
{
    return [self initWithDictionary:@{@"name" : name}];
}

#pragma mark -
#pragma mark Description

- (NSString *)description
{
    NSString *format = @"(%@) %@, %@";
    return [NSString stringWithFormat:format,self.serviceId,self.name,self.description];
}

@end
