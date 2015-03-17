//
//  LobJobModel.h
//  lob-ios
//
//  Created by Zealous Amoeba on 1/3/14.
//  www.zealousamoeba.org
//  Copyright (c) 2014 Lob. All rights reserved.
//

#import "LobAbstractModel.h"

@class LobAddressModel;
@class LobPackagingModel;
@class LobServiceModel;
@interface LobJobModel : LobAbstractModel
@property(nonatomic, strong) NSString *jobId;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *price;
@property(nonatomic, strong) LobAddressModel *toAddress;
@property(nonatomic, strong) LobAddressModel *fromAddress;
@property(nonatomic, strong) NSString *quantity;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSString *tracking;
@property(nonatomic, strong) LobPackagingModel *packaging;
@property(nonatomic, strong) LobServiceModel *service;
@property(nonatomic, strong) NSArray *objects;

- (instancetype)initJobWithId:(NSString*)jobId;

- (instancetype)initJobWithName:(NSString *)name
                          price:(NSString *)price
                      toAddress:(LobAddressModel *)toAddress
                    fromAddress:(LobAddressModel *)fromAddress
                       quantity:(NSString *)quantity
                         status:(NSString *)status
                       tracking:(NSString *)tracking
                      packaging:(LobPackagingModel *)packaging
                        service:(LobServiceModel *)service
                        objects:(NSArray *)objects;

@end
