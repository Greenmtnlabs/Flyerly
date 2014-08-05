//
//  LobSettingModel.m
//  lob-ios
//
//  Created by Zealous Amoeba on 1/3/14.
//  www.zealousamoeba.org
//  Copyright (c) 2014 Lob. All rights reserved.
//

#import "LobSettingModel.h"

@implementation LobSettingModel
@synthesize dateCreated = _dateCreated;
@synthesize dateModified = _dateModified;

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if(self = [super init])
    {
        self.dateCreated = NULL;
        self.dateModified = NULL;
        
        self.settingId = dict[@"id"];
        self.type = dict[@"type"];
        self.description = dict[@"description"];
        self.paper = dict[@"paper"];
        self.width = dict[@"width"];
        self.length = dict[@"length"];
        self.color = dict[@"color"];
        self.notes = dict[@"notes"];
    }
    return self;
}

- (instancetype)initSettingWithId:(NSString*)settingId
{
    return [self initWithDictionary:@{@"id" : settingId}];
}

- (instancetype)initSettingWithType:(NSString*)type
                        description:(NSString*)description
                              paper:(NSString*)paper
                              witdh:(NSString*)width
                             length:(NSString*)length
                              color:(NSString*)color
                              notes:(NSString*)notes
{
    NSDictionary *dict = @{@"type" : type,
                           @"description" : description,
                           @"paper" : paper,
                           @"width" : width,
                           @"length" : length,
                           @"color" : color,
                           @"notes" : notes};

    return [self initWithDictionary:dict];
}

#pragma mark -
#pragma mark Description

- (NSString *)description
{
    NSString *format = @"(%@) %@, %@ - %@, %@, %@ - %@, %@";
    return [NSString stringWithFormat:format,self.settingId,self.type,self.description,self.paper,self.width,self.length,self.color,self.notes];
}

@end
