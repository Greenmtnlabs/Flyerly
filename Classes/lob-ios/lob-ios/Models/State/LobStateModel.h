//
//  LobStateModel.h
//  lob-ios
//
//  Created by Zealous Amoeba on 1/3/14.
//  www.zealousamoeba.org
//  Copyright (c) 2014 Lob. All rights reserved.
//

#import "LobAbstractModel.h"

@interface LobStateModel : LobAbstractModel
@property(nonatomic, strong) NSString *stateId;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *shortName;

- (instancetype)initStateWithId:(NSString*)stateId;

- (instancetype)initStateWithName:(NSString*)name
                        shortName:(NSString*)shortName;

@end
