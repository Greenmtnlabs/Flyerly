//
//  LobPostcardModel.h
//  lob-ios
//
//  Created by Zealous Amoeba on 1/3/14.
//  www.zealousamoeba.org
//  Copyright (c) 2014 Lob. All rights reserved.
//

#import "LobAbstractModel.h"

@class LobAddressModel;
@interface LobPostcardModel : LobAbstractModel
@property(nonatomic, strong) NSString *postcardId;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *message;
@property(nonatomic, strong) LobAddressModel *toAddress;
@property(nonatomic, strong) LobAddressModel *fromAddress;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSString *price;
@property(nonatomic, strong) NSString *frontUrl;
@property(nonatomic, strong) NSString *backUrl;
@property(nonatomic, assign) BOOL fullBleed;

- (instancetype)initPostcardWithId:(NSString*)postcardId;

- (instancetype)initPostcardWithName:(NSString*)name
                             message:(NSString*)message
                           toAddress:(LobAddressModel*)toAddress
                         fromAddress:(LobAddressModel*)fromAddress
                              status:(NSString*)status
                               price:(NSString*)price
                            frontUrl:(NSString*)frontUrl
                             backUrl:(NSString*)backUrl
                           fullBleed:(BOOL)fullBleed;

@end
