//
//  LobAbstractModel.m
//  lob-ios
//
//  Created by Zealous Amoeba on 1/11/14.
//  Copyright (c) 2014 Lob. All rights reserved.
//

#import "LobAbstractModel.h"

@implementation LobAbstractModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if(dict == NULL || [dict isEqual:[NSNull null]]) return NULL;
    
    if(self = [super init])
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
        
        if(dict[@"date_created"] == NULL) _dateCreated = NULL;
        else _dateCreated = [dateFormat dateFromString:dict[@"date_created"]];
        
        if(dict[@"date_modified"] == NULL) _dateModified = NULL;
        else _dateModified = [dateFormat dateFromString:dict[@"date_modified"]];
    }
    return self;
}

+ (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if(dict == NULL || [dict isEqual:[NSNull null]]) return NULL;
    else return [[self alloc] initWithDictionary:dict];
}

+ (NSArray *)modelsFromArrayOfDictionaries:(NSArray *)array
{
    NSMutableArray *mutableArray = [NSMutableArray array];
    for(NSDictionary *dict in array)
    {
        LobAbstractModel *model = [self initWithDictionary:dict];
        [mutableArray addObject:model];
    }
    
    return [NSArray arrayWithArray:mutableArray];
}

#pragma mark -
#pragma mark Request Methods

+ (void)populateItems:(NSMutableArray *)items fromPairs:(NSArray *)pairs onObject:(id)object prefix:(NSString *)prefix
{
    for(NSArray *arr in pairs)
    {
        if ([arr count] > 0) {
            id value = [object valueForKey:arr[1]];
            NSString *valueString = nil;
            //BOOL's are actually nsnumbers under the hood
            if ([value isKindOfClass:[NSNumber class]]) {
                valueString = ([value boolValue]) ? @"True" : @"False";
            } else if ([value isKindOfClass:[NSString class]]) {
                valueString = (NSString *)value;
            }
            if (valueString) {
                valueString = [valueString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSString *item = [LobAbstractModel paramItemWithName:arr[0] andValue:value prefix:prefix];
                
                [items addObject:item];
            }
        }
    }
}

+ (NSString *)paramStringWithItems:(NSArray *)items {
    return [NSString stringWithFormat:@"%@",[items componentsJoinedByString:@"&"]];
}

+ (NSString *)paramItemWithName:(NSString*)name andValue:(NSString *)value prefix:(NSString *)prefix
{
    if([prefix isEqualToString:@""]) return [name stringByAppendingFormat:@"=%@",value];
    else return [NSString stringWithFormat:@"%@[%@]=%@",prefix,name,value];
}

- (NSString *)urlParamsForCreateRequest
{
    return @"";
}

- (NSString *)urlParamsForInclusionWithPrefix:(NSString *)prefix
{
    return @"";
}

@end
