//
//  LobCountryModel.m
//  lob-ios
//
//  Created by Zealous Amoeba on 1/3/14.
//  www.zealousamoeba.org
//  Copyright (c) 2014 Lob. All rights reserved.
//

#import "LobCountryModel.h"

@implementation LobCountryModel
@synthesize dateCreated = _dateCreated;
@synthesize dateModified = _dateModified;

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if(self = [super init])
    {
        self.dateCreated = NULL;
        self.dateModified = NULL;
        
        self.countryId = dict[@"id"];
        self.name = dict[@"name"];
        self.shortName = dict[@"short_name"];
    }
    return self;
}

- (instancetype)initCountryWithId:(NSString *)countryId
{
    return [self initWithDictionary:@{@"id" : countryId}];
}

- (instancetype)initCountryWithName:(NSString *)name
                          shortName:(NSString *)shortName
{
    NSDictionary *dict = @{@"name" : name,
                           @"short_name" : shortName};
    
    return [self initWithDictionary:dict];
}

#pragma mark -
#pragma mark Description

- (NSString *)description
{
    NSString *format = @"(%@) %@, %@";
    return [NSString stringWithFormat:format,self.countryId,self.name,self.shortName];
}

@end
