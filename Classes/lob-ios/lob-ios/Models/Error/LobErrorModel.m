//
//  LobErrorModel.m
//  lob-ios
//
//  Created by Peter Nagel on 9/11/14.
//  Copyright (c) 2014 Lob. All rights reserved.
//

#import "LobErrorModel.h"

@implementation LobErrorModel
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if(self = [super init])
    {
        self.errors = dict[@"errors"];
    }
    return self;
}
@end
