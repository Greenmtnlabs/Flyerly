//
//  LobRequest.h
//  lob-ios
//
//  Created by Zealous Amoeba on 1/3/14.
//  www.zealousamoeba.org
//  Copyright (c) 2014 Lob. All rights reserved.
//

#import "AbstractBlockRequest.h"

@class LobAddressModel;
@class LobBankAccountModel;
@class LobCheckModel;
@class LobCountryModel;
@class LobJobModel;
@class LobObjectModel;
@class LobPackagingModel;
@class LobPostcardModel;
@class LobServiceModel;
@class LobSettingModel;
@class LobStateModel;
@class LobVerifyModel;
@interface LobRequest : AbstractBlockRequest
@property(nonatomic, strong) NSString *apiKey;
@property(nonatomic, assign) int count;
@property(nonatomic, assign) int offset;

- (instancetype)initWithAPIKey:(NSString *)apiKey;
+ (instancetype)initWithAPIKey:(NSString *)apiKey;

/**
 * Address Requests
 */

- (void)listAddressesWithResponse:(void(^) (NSArray *addresses, NSError *error))response;

- (void)createAddressWithModel:(LobAddressModel *)address
                  withResponse:(void(^) (LobAddressModel *addr, NSError *error))response;

- (void)retrieveAddressWithId:(NSString *)addrId
                 withResponse:(void(^) (LobAddressModel *addr, NSError *error))response;

- (void)deleteAddressWithId:(NSString *)addrId
               withResponse:(void(^) (NSString *message, NSError *error))response;

/**
 * Bank Account Requests
 */

- (void)listBankAccountsWithResponse:(void(^) (NSArray *accounts, NSError *error))response;

- (void)createBankAccountWithModel:(LobBankAccountModel *)bankAccount
                      withResponse:(void(^) (LobBankAccountModel *bankAccount, NSError *error))response;

- (void)retrieveBankAccountWithId:(NSString *)bankId
                     withResponse:(void(^) (LobBankAccountModel *bankAccount, NSError *error))response;

/**
 * Check Requests
 */

- (void)listChecksWithResponse:(void(^) (NSArray *checks, NSError *error))response;

- (void)createCheckWithModel:(LobCheckModel *)check
                withResponse:(void(^) (LobCheckModel *check, NSError *error))response;

- (void)retrieveCheckWithId:(NSString *)checkId
               withResponse:(void(^) (LobCheckModel *check, NSError *error))response;

/**
 * Country Requests
 */

- (void)listCountriesWithResponse:(void(^) (NSArray *countries, NSError *error))response;

/**
 * Job Requests
 */

- (void)listJobsWithResponse:(void(^) (NSArray *jobs, NSError *error))response;

- (void)createJobWithModel:(LobJobModel *)job
              withResponse:(void(^) (LobJobModel *job, NSError *error))response;

- (void)retrieveJobWithId:(NSString *)jobId
             withResponse:(void(^) (LobJobModel *job, NSError *error))response;

/**
 * Object Requests
 */

- (void)listObjectsWithResponse:(void(^) (NSArray *objects, NSError *error))response;

//- (void)createObjectWithModel:(LobObjectModel *)object
//                 withResponse:(void(^) (LobObjectModel *object, NSError *error))response;

- (void)retrieveObjectWithId:(NSString *)objectId
                withResponse:(void(^) (LobObjectModel *object, NSError *error))response;

- (void)deleteObjectWithId:(NSString *)objectId
              withResponse:(void(^) (NSString *message, NSError *error))response;

/**
 * Packaging Requests
 */

- (void)listPackagingsWithResponse:(void(^) (NSArray *packagings, NSError *error))response;

/**
 * Postcard Requests
 */

- (void)listPostcardsWithResponse:(void(^) (NSArray *postcards, NSError *error))response;

- (void)createPostcardWithModel:(LobPostcardModel *)postcard
                   withResponse:(void(^) (LobPostcardModel *postcard, NSError *error))response;

- (void)retrievePostcardWithId:(NSString *)postcardId
                  withResponse:(void(^) (LobPostcardModel *postcard, NSError *error))response;

/**
 * Service Requests
 */

- (void)listServicesWithResponse:(void(^) (NSArray *services, NSError *error))response;

/**
 * Setting Requests
 */

- (void)listSettingsWithResponse:(void(^) (NSArray *settings, NSError *error))response;

- (void)retrieveSettingWithId:(NSString *)settingId
                 withResponse:(void(^) (LobSettingModel *setting, NSError *error))response;

/**
 * State Requests
 */

- (void)listStatesWithResponse:(void(^) (NSArray *states, NSError *error))response;

/**
 * Verify Requests
 */

- (void)verifyAddressModel:(LobAddressModel *)addr
              withResponse:(void(^) (LobVerifyModel *validation, NSError *error))response;

@end
