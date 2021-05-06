//
//  LobRequest.m
//  lob-ios
//
//  Created by Zealous Amoeba on 1/3/14.
//  www.zealousamoeba.org
//  Copyright (c) 2014 Lob. All rights reserved.
//

#import "LobRequest.h"

#import "AFNetworking.h"





#import "LobAddressModel.h"
#import "LobBankAccountModel.h"
#import "LobCheckModel.h"
#import "LobCountryModel.h"
#import "LobJobModel.h"
#import "LobObjectModel.h"
#import "LobPackagingModel.h"
#import "LobPostcardModel.h"
#import "LobServiceModel.h"
#import "LobSettingModel.h"
#import "LobStateModel.h"
#import "LobVerifyModel.h"

@implementation LobRequest

- (instancetype)init
{
    if(self = [super init])
    {
        self.apiKey = @"";
        self.count = 2;
        self.offset = 1;
    }
    return self;
}

- (instancetype)initWithAPIKey:(NSString * )apiKey
{
    if(self = [super init]) {
        self.apiKey = [NSString stringWithFormat:@"%@:",apiKey];
        if(self.apiKey == NULL) self.apiKey = @"";
    }
    return self;
}

+ (instancetype)initWithAPIKey:(NSString * )apiKey
{
    return [[LobRequest alloc] initWithAPIKey:apiKey];
}

#pragma mark -
#pragma mark Request Methods

- (NSString* )urlExtWithListParamFromURLStr:(NSString* )urlStr
{
    NSString *ext = @"";
    if(self.count == -1 && self.offset == -1) return urlStr;
    else if(self.count == -1 && self.offset > -1) ext = [NSString stringWithFormat:@"/?offset=%i",self.offset];
    else if(self.offset == -1 && self.count > -1) ext = [NSString stringWithFormat:@"/?count=%i",self.count];
    else ext = [NSString stringWithFormat:@"?count=%i&offset=%i",self.count,self.offset];

    return [urlStr stringByAppendingString:ext];
}

- (void)addAuthorizationToRequest:(NSMutableURLRequest * )request
{
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSData *authData = [self.apiKey dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@",[AbstractBlockRequest base64forData:authData]];
    [request addValue:authValue forHTTPHeaderField:@"Authorization"];
}

#pragma mark -
#pragma mark Setters

- (void)setApiKey:(NSString * )apiKey
{
    _apiKey = [NSString stringWithFormat:@"%@:",apiKey];
    if(_apiKey == NULL) _apiKey = @"";
}

#pragma mark -
#pragma mark Requests

/**
 * Address Requests
 */

- (void)listAddressesWithResponse:(void(^) (NSArray *addresses, NSError *error))response
{
    [self listModelsFromURLExn:URLStr_Addresses
             withResponseClass:NSStringFromClass([LobAddressModel class])
                   andResponse:^(NSArray *models, NSError *error)
    {
        response(models,error);
    }];
}

- (void)createAddressWithModel:(LobAddressModel* )address
                  withResponse:(void(^) (LobAddressModel *addr, NSError *error))response
{
    NSString *urlStr = [URLStr_Base stringByAppendingString:URLStr_Addresses];
    
    [self createModelWithURLStr:urlStr
                         params:[address urlParamsForCreateRequest]
              withResponseClass:NSStringFromClass([LobAddressModel class])
                    andResponse:^(LobAbstractModel *model, NSError *error)
    {
        response((LobAddressModel* )model,error);
    }];
}

- (void)retrieveAddressWithId:(NSString* )addrId
                 withResponse:(void(^) (LobAddressModel *addr, NSError *error))response
{
    [self retrieveModelFromURLExn:URLStr_Addresses
                           withId:addrId
                 andResponseClass:NSStringFromClass([LobAddressModel class])
                      andResponse:^(LobAbstractModel *model, NSError *error)
    {
        response((LobAddressModel* )model,error);
    }];
}

- (void)deleteAddressWithId:(NSString* )addrId
               withResponse:(void(^) (NSString *message, NSError *error))response
{
    [self deleteModelFromURLExn:URLStr_Addresses
                         withId:addrId andResponse:^(NSString *message, NSError *error)
    {
        response(message,error);
    }];
}

/**
 * Bank Account Requests
 */

- (void)listBankAccountsWithResponse:(void(^) (NSArray *accounts, NSError *error))response
{
    [self listModelsFromURLExn:URLStr_BankAccounts
             withResponseClass:NSStringFromClass([LobBankAccountModel class])
                   andResponse:^(NSArray *models, NSError *error)
    {
        response(models,error);
    }];
}

- (void)createBankAccountWithModel:(LobBankAccountModel* )bankAccount
                      withResponse:(void(^) (LobBankAccountModel *bankAccount, NSError *error))response
{
    NSString *urlStr = [URLStr_Base stringByAppendingString:URLStr_BankAccounts];
    
    [self createModelWithURLStr:urlStr
                         params:[bankAccount urlParamsForCreateRequest]
              withResponseClass:NSStringFromClass([LobBankAccountModel class])
                    andResponse:^(LobAbstractModel *model, NSError *error)
    {
        response((LobBankAccountModel* )model,error);
    }];
}

- (void)retrieveBankAccountWithId:(NSString* )bankId
                     withResponse:(void(^) (LobBankAccountModel *bankAccount, NSError *error))response
{
    [self retrieveModelFromURLExn:URLStr_BankAccounts
                           withId:bankId
                 andResponseClass:NSStringFromClass([LobBankAccountModel class])
                      andResponse:^(LobAbstractModel *model, NSError *error)
    {
        response((LobBankAccountModel* )model,error);
    }];
}

/**
 * Check Requests
 */

- (void)listChecksWithResponse:(void(^) (NSArray *checks, NSError *error))response
{
    [self listModelsFromURLExn:URLStr_Checks
             withResponseClass:NSStringFromClass([LobCheckModel class])
                   andResponse:^(NSArray *models, NSError *error)
    {
        response(models,error);
    }];
}

- (void)createCheckWithModel:(LobCheckModel* )check
                withResponse:(void(^) (LobCheckModel *check, NSError *error))response
{
    NSString *urlStr = [URLStr_Base stringByAppendingString:URLStr_Checks];
    
    [self createModelWithURLStr:urlStr
                         params:[check urlParamsForCreateRequest]
              withResponseClass:NSStringFromClass([LobCheckModel class])
                    andResponse:^(LobAbstractModel *model, NSError *error)
    {
        response((LobCheckModel* )model,error);
    }];
}

- (void)retrieveCheckWithId:(NSString* )checkId
               withResponse:(void(^) (LobCheckModel *check, NSError *error))response
{
    [self retrieveModelFromURLExn:URLStr_Checks
                           withId:checkId
                 andResponseClass:NSStringFromClass([LobCheckModel class])
                      andResponse:^(LobAbstractModel *model, NSError *error)
    {
        response((LobCheckModel* )model,error);
    }];
}

/**
 * Country Requests
 */

- (void)listCountriesWithResponse:(void(^) (NSArray *countries, NSError *error))response
{
    [self listModelsFromURLExn:URLStr_Countries
             withResponseClass:NSStringFromClass([LobCountryModel class])
                   andResponse:^(NSArray *models, NSError *error)
    {
        response(models,error);
    }];
}

/**
 * Job Requests
 */

- (void)listJobsWithResponse:(void(^) (NSArray *jobs, NSError *error))response
{
    [self listModelsFromURLExn:URLStr_Jobs
             withResponseClass:NSStringFromClass([LobJobModel class])
                   andResponse:^(NSArray *models, NSError *error)
    {
        response(models,error);
    }];
}

- (void)createJobWithModel:(LobJobModel* )job
              withResponse:(void(^) (LobJobModel *job, NSError *error))response
{
    NSString *urlStr = [URLStr_Base stringByAppendingString:URLStr_Jobs];
    
    [self createModelWithURLStr:urlStr
                         params:[job urlParamsForCreateRequest]
              withResponseClass:NSStringFromClass([LobJobModel class])
                    andResponse:^(LobAbstractModel *model, NSError *error)
    {
        response((LobJobModel* )model,error);
    }];
}

- (void)retrieveJobWithId:(NSString* )jobId
             withResponse:(void(^) (LobJobModel *job, NSError *error))response
{
    [self retrieveModelFromURLExn:URLStr_Jobs withId:jobId
                 andResponseClass:NSStringFromClass([LobJobModel class])
                      andResponse:^(LobAbstractModel *model, NSError *error)
    {
        response((LobJobModel* )model,error);
    }];
}

/**
 * Object Requests
 */

- (void)listObjectsWithResponse:(void(^) (NSArray *objects, NSError *error))response
{
    [self listModelsFromURLExn:URLStr_Objects
             withResponseClass:NSStringFromClass([LobObjectModel class])
                   andResponse:^(NSArray *models, NSError *error)
    {
        response(models,error);
    }];
}

//- (void)createObjectWithModel:(LobObjectModel* )object withResponse:(void(^) (LobObjectModel *object, NSError *error))response
//{
//    NSString *urlStr = [URLStr_Base stringByAppendingString:URLStr_Objects];
//    //NSURL *url = [NSURL URLWithString:urlStr];
//    
//    if(object.localFilePath)
//    {
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        
//        //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
//        
//        NSString *user = [self.apiKey substringToIndex:self.apiKey.length-1];
//        [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:user password:@""];
//        
//        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
//        if(object.name) paramDict[@"name"] = object.name;
//        paramDict[@"setting"] = object.setting.settingId;
//        if(object.quantity) paramDict[@"quantity"] = object.quantity;
//        paramDict[@"double_sided"] = object.doubleSided ? @"1" : @"0";
//        
//        
//        [manager POST:urlStr parameters:@{} constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
//        {
//            [formData throttleBandwidthWithPacketSize:kAFUploadStream3GSuggestedPacketSize delay:kAFUploadStream3GSuggestedDelay];
//         
//            NSData *data = [NSData dataWithContentsOfFile:object.file];
//            [formData appendPartWithFileData:data name:@"file" fileName:@"file" mimeType:@"application/pdf"];;
//            [formData appendPartWithFormData:[object.name dataUsingEncoding:NSUTF8StringEncoding] name:@"name"];
//            [formData appendPartWithFormData:[object.setting.settingId dataUsingEncoding:NSUTF8StringEncoding] name:@"setting"];
//        }
//        success:^(AFHTTPRequestOperation *operation, id responseObject)
//        {
//            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//            self.statusCode = operation.response.statusCode;
//            response([LobObjectModel initWithDictionary:responseDict],NULL);
//        }
//        failure:^(AFHTTPRequestOperation *operation, NSError *error)
//        {
//            self.statusCode = operation.response.statusCode;
//            response(NULL,error);
//        }];
//    }
//    else
//    {
//        [self createModelWithURLStr:urlStr params:[object urlParamsForCreateRequest]
//                  withResponseClass:NSStringFromClass([LobObjectModel class])
//                        andResponse:^(LobAbstractModel *model, NSError *error)
//         {
//             response((LobObjectModel* )model,error);
//         }];
//    }
//}

- (void)retrieveObjectWithId:(NSString* )objectId
                withResponse:(void(^) (LobObjectModel *object, NSError *error))response
{
    [self retrieveModelFromURLExn:URLStr_Objects
                           withId:objectId
                 andResponseClass:NSStringFromClass([LobObjectModel class])
                      andResponse:^(LobAbstractModel *model, NSError *error)
    {
        response((LobObjectModel* )model,error);
    }];
}

- (void)deleteObjectWithId:(NSString* )objectId
              withResponse:(void(^) (NSString *message, NSError *error))response
{
    [self deleteModelFromURLExn:URLStr_Objects withId:objectId
                    andResponse:^(NSString *message, NSError *error)
    {
        response(message,error);
    }];
}

/**
 * Packaging Requests
 */

- (void)listPackagingsWithResponse:(void(^) (NSArray *packagings, NSError *error))response
{
    [self listModelsFromURLExn:URLStr_Packagings
             withResponseClass:NSStringFromClass([LobPackagingModel class])
                   andResponse:^(NSArray *models, NSError *error)
    {
        response(models,error);
    }];
}

/**
 * Postcard Requests
 */

- (void)listPostcardsWithResponse:(void(^) (NSArray *postcards, NSError *error))response
{
    [self listModelsFromURLExn:URLStr_Postcards
             withResponseClass:NSStringFromClass([LobPostcardModel class])
                   andResponse:^(NSArray *models, NSError *error)
    {
        response(models,error);
    }];
}

- (void)createPostcardWithModel:(LobPostcardModel* )postcard
                   withResponse:(void(^) (LobPostcardModel *postcard, NSError *error))response
{
    NSString *urlStr = [URLStr_Base stringByAppendingString:URLStr_Postcards];
    
    [self createModelWithURLStr:urlStr params:[postcard urlParamsForCreateRequest]
              withResponseClass:NSStringFromClass([LobPostcardModel class])
                    andResponse:^(LobAbstractModel *model, NSError *error)
    {
        response((LobPostcardModel* )model,error);
    }];
}

- (void)retrievePostcardWithId:(NSString* )postcardId
                  withResponse:(void(^) (LobPostcardModel *postcard, NSError *error))response
{
    [self retrieveModelFromURLExn:URLStr_Postcards
                           withId:postcardId
                 andResponseClass:NSStringFromClass([LobPostcardModel class])
                      andResponse:^(LobAbstractModel *model, NSError *error)
    {
        response((LobPostcardModel* )model,error);
    }];
}

/**
 * Service Requests
 */

- (void)listServicesWithResponse:(void(^) (NSArray *services, NSError *error))response
{
    [self listModelsFromURLExn:URLStr_Services
             withResponseClass:NSStringFromClass([LobServiceModel class])
                   andResponse:^(NSArray *models, NSError *error)
    {
        response(models,error);
    }];
}

/**
 * Setting Requests
 */

- (void)listSettingsWithResponse:(void(^) (NSArray *settings, NSError *error))response
{
    [self listModelsFromURLExn:URLStr_Settings
             withResponseClass:NSStringFromClass([LobSettingModel class])
                   andResponse:^(NSArray *models, NSError *error)
    {
        response(models,error);
    }];
}

- (void)retrieveSettingWithId:(NSString* )settingId
                 withResponse:(void(^) (LobSettingModel *setting, NSError *error))response
{
    [self retrieveModelFromURLExn:URLStr_Settings
                           withId:settingId
                 andResponseClass:NSStringFromClass([LobSettingModel class])
                      andResponse:^(LobAbstractModel *model, NSError *error)
    {
        response((LobSettingModel* )model,error);
    }];
}

/**
 * State Requests
 */

- (void)listStatesWithResponse:(void(^) (NSArray *states, NSError *error))response
{
    [self listModelsFromURLExn:URLStr_States
             withResponseClass:NSStringFromClass([LobStateModel class])
                   andResponse:^(NSArray *models, NSError *error)
    {
        response(models,error);
    }];
}

/**
 * Verify Requests
 */

- (void)verifyAddressModel:(LobAddressModel* )addr
              withResponse:(void(^) (LobVerifyModel *validation, NSError *error))response
{
    NSString *urlStr = [URLStr_Base stringByAppendingString:URLStr_Verify];

    [self getUrlStr:urlStr withMethod:HTTP_Post withEdit:^(NSMutableURLRequest *request)
    {
        [self addAuthorizationToRequest:request];
        [request setHTTPBody:[[addr urlParamsForCreateRequest] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    andResponse:^(NSData *data, NSError *error)
    {
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];

        response([LobVerifyModel initWithDictionary:responseDict],error);
    }];
}

#pragma mark -
#pragma mark Template Request Methods

- (void)listModelsFromURLExn:(NSString* )urlExn
           withResponseClass:(NSString* )classStr
                 andResponse:(void(^) (NSArray *models, NSError *error))response
{
    NSString *urlStr = [URLStr_Base stringByAppendingString:urlExn];
    NSString *urlStrWithParams = [self urlExtWithListParamFromURLStr:urlStr];
    
    [self getUrlStr:urlStrWithParams withMethod:HTTP_Get withEdit:^(NSMutableURLRequest *request)
    {
        [self addAuthorizationToRequest:request];
    }
    andResponse:^(NSData *data, NSError *error)
    {
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        response([NSClassFromString(classStr) modelsFromArrayOfDictionaries:responseDict[@"data"]],error);
    }];
}

- (void)createModelWithURLStr:(NSString* )urlStr
                       params:(NSString* )params
            withResponseClass:(NSString* )classStr
                  andResponse:(void(^) (LobAbstractModel *model, NSError *error))response
{
    [self getUrlStr:urlStr withMethod:HTTP_Post withEdit:^(NSMutableURLRequest *request)
    {
        [self addAuthorizationToRequest:request];
        [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    }
    andResponse:^(NSData *data, NSError *error)
    {
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        response([NSClassFromString(classStr) initWithDictionary:responseDict],error);
    }];
}

- (void)retrieveModelFromURLExn:(NSString* )urlExn
                         withId:(NSString* )modelId
               andResponseClass:(NSString* )classStr
                    andResponse:(void(^) (LobAbstractModel *model, NSError *error))response
{
    NSString *urlStr = [URLStr_Base stringByAppendingString:urlExn];
    NSString *urlStrWithParams = [NSString stringWithFormat:@"%@/%@",urlStr,modelId];
    
    [self getUrlStr:urlStrWithParams withMethod:HTTP_Get withEdit:^(NSMutableURLRequest *request)
    {
        [self addAuthorizationToRequest:request];
    }
    andResponse:^(NSData *data, NSError *error)
    {
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        response([NSClassFromString(classStr) initWithDictionary:responseDict],error);
    }];
}

- (void)deleteModelFromURLExn:(NSString* )urlExn
                       withId:(NSString* )modelId
                  andResponse:(void(^) (NSString *message, NSError *error))response
{
    NSString *urlStr = [URLStr_Base stringByAppendingString:urlExn];
    NSString *urlStrWithParams = [NSString stringWithFormat:@"%@/%@",urlStr,modelId];
    
    [self getUrlStr:urlStrWithParams withMethod:HTTP_Delete withEdit:^(NSMutableURLRequest *request)
    {
        [self addAuthorizationToRequest:request];
    }
    andResponse:^(NSData *data, NSError *error)
    {
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        response(responseDict[@"message"],error);
    }];
}


@end

