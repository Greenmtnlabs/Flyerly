//
//  LobCountryModel.h
//  lob-ios
//
//  Created by Zealous Amoeba on 1/3/14.
//  www.zealousamoeba.org
//  Copyright (c) 2014 Lob. All rights reserved.
//

#import "LobAbstractModel.h"

@interface LobCountryModel : LobAbstractModel
@property(nonatomic, strong) NSString *countryId;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *shortName;

- (instancetype)initCountryWithId:(NSString *)countryId;

- (instancetype)initCountryWithName:(NSString *)name
                          shortName:(NSString *)shortName;

@end
