//
//  LobVerifyModel.h
//  lob-ios
//
//  Created by Zealous Amoeba on 1/3/14.
//  www.zealousamoeba.org
//  Copyright (c) 2014 Lob. All rights reserved.
//

#import "LobAbstractModel.h"

@class LobAddressModel;
@interface LobVerifyModel : LobAbstractModel
@property(nonatomic, strong) NSString *message;
@property(nonatomic, strong) LobAddressModel *address;

- (instancetype)initVerifyModelWithMessage:(NSString*)message
                                   address:(LobAddressModel*)address;

@end
