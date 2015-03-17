//
//  LobPackagingModel.h
//  lob-ios
//
//  Created by Zealous Amoeba on 1/3/14.
//  www.zealousamoeba.org
//  Copyright (c) 2014 Lob. All rights reserved.
//

#import "LobAbstractModel.h"

@interface LobPackagingModel : LobAbstractModel
@property(nonatomic, strong) NSString *packagingId;
@property(nonatomic, strong) NSString *name;
- (instancetype)initPackagingWithId:(NSString*)packagingId;

- (instancetype)initPackagingWithName:(NSString*)name;

@end
