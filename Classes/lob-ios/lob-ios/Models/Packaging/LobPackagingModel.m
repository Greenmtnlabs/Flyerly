//
//  LobPackagingModel.m
//  lob-ios
//
//  Created by Zealous Amoeba on 1/3/14.
//  www.zealousamoeba.org
//  Copyright (c) 2014 Lob. All rights reserved.
//

#import "LobPackagingModel.h"

@implementation LobPackagingModel
@synthesize dateCreated = _dateCreated;
@synthesize dateModified = _dateModified;

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if(self = [super init])
    {
        self.dateCreated = NULL;
        self.dateModified = NULL;
        
        self.packagingId = dict[@"id"];
        self.name = dict[@"name"];
    }
    return self;
}

- (instancetype)initPackagingWithId:(NSString*)packagingId
{
    return [self initWithDictionary:@{@"id" : packagingId}];
}

- (instancetype)initPackagingWithName:(NSString*)name
{
    return [self initWithDictionary:@{@"name" : name}];
}

@end
