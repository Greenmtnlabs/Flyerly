//
//  LobStateModel.m
//  lob-ios
//
//  Created by Zealous Amoeba on 1/3/14.
//  www.zealousamoeba.org
//  Copyright (c) 2014 Lob. All rights reserved.
//

#import "LobStateModel.h"

@implementation LobStateModel
@synthesize dateCreated = _dateCreated;
@synthesize dateModified = _dateModified;

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if(self = [super init])
    {
        _dateCreated = NULL;
        _dateModified = NULL;
        
        _stateId = dict[@"id"];
        _name = dict[@"name"];
        _shortName = dict[@"short_name"];
    }
    return self;
}

- (instancetype)initStateWithId:(NSString*)stateId
{
    return [self initWithDictionary:@{@"id" : stateId}];
}

- (instancetype)initStateWithName:(NSString*)name
                        shortName:(NSString*)shortName
{
    return [self initWithDictionary:@{@"name" : name,
                                      @"short_name" : shortName}];
}

#pragma mark -
#pragma mark Description

-(NSString *)description
{
    NSString *format = @"(%@) %@, %@";
    return [NSString stringWithFormat:format,_stateId,_name,_shortName];
}

@end
