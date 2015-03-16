//
//  LobVerifyModel.m
//  lob-ios
//
//  Created by Zealous Amoeba on 1/3/14.
//  www.zealousamoeba.org
//  Copyright (c) 2014 Lob. All rights reserved.
//

#import "LobVerifyModel.h"
#import "LobAddressModel.h"

@implementation LobVerifyModel
@synthesize dateCreated = _dateCreated;
@synthesize dateModified = _dateModified;

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if(self = [super init])
    {
        self.dateCreated = NULL;
        self.dateModified = NULL;
        
        self.address = [LobAddressModel initWithDictionary:dict[@"address"]];
        self.message = dict[@"message"];
    }
    return self;
}

- (instancetype)initVerifyModelWithMessage:(NSString*)message
                                   address:(LobAddressModel*)address
{
    self = [self initWithDictionary:@{@"message" : message}];
    self.address = address;
    
    return self;
}

#pragma mark -
#pragma mark Description

- (NSString *)description
{
    NSString *format = @"%@ | %@";
    return [NSString stringWithFormat:format,self.message,self.address];
}


@end
