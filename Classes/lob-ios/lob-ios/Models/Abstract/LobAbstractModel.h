//
//  LobAbstractModel.h
//  lob-ios
//
//  Created by Zealous Amoeba on 1/11/14.
//  Copyright (c) 2014 Lob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LobAbstractModel : NSObject
@property(nonatomic, strong) NSDate *dateCreated;
@property(nonatomic, strong) NSDate *dateModified;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (NSArray *)modelsFromArrayOfDictionaries:(NSArray *)array;

#pragma mark -
#pragma mark Request Methods

+(void)populateItems:(NSMutableArray *)items fromPairs:(NSArray *)pairs onObject:(id)object prefix:(NSString *)prefix;
+(NSString *)paramStringWithItems:(NSArray *)items;
+(NSString *)paramItemWithName:(NSString *)name andValue:(NSString *)value prefix:(NSString *)prefix;

- (NSString *)urlParamsForCreateRequest;
- (NSString *)urlParamsForInclusionWithPrefix:(NSString *)prefix;

@end
