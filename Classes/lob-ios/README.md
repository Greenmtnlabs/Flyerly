## PLEASE NOTE: The IOS Wrapper only supports the latest version of the API. For more information about versioning please check out the [documentation](https://lob.com/docs).

Lob.com iOS Client
==================

Lob.com iOS Client is a simple wrapper for the [Lob.com](https://www.lob.com) API ([docs](https://www.lob.com/docs)).

### Setting Up The Project

To include the iOS Client just put the iOS Client project within the project you want to use it in. The process is outlined on Stack Overflow:
http://stackoverflow.com/questions/9370518/xcode-4-2-how-include-one-project-into-another-one

Basics
------
After including the iOS Client Project, import the Lob Library in the class where you want to use the iOS Client.

```objc
#import "LobLibrary.h"
```

Models
---------
The lob models are all in the Models folder of the iOS Client. All models are created from a dictionary.

```objc
-(LobAddressModel*)createDemoAddress {
  NSDictionary *dict = @{@"name" : @"Harry Zhang", @"email" : @"harry@lob.com",
                         @"phone" : @"5555555555", @"address_line1" : @"123 Test Street",
                         @"address_line2" : @"Unit 199", @"address_city" : @"Mountain View",
                         @"address_state" : @"CA", @"address_zip" : @"94085", @"address_country" : @"US"};
    
    LobAddressModel *addrModel = [LobAddressModel initWithDictionary:dict];
    return addrModel;
}
```

The following models are currently supported with the iOS Client.

```objc
  LobAddressModel, LobBankAccountModel, LobCheckModel, LobCountryModel
  LobJobModel, LobObjectModel, LobPackagingModel, LobPostcardModel
  LobServiceModel, LobSettingModel, LobStateModel, LobVerifyModel
```

Requests
---------
Lob requests are all found in the Requests folder of the iOS client. All requests follow a consistent naming scheme and block based return format. Lob requests should be instantiated with the api key. On list requests, the count and offset can be set as properties on the request object.

```objc
-(void)listAddresses {
  request = [[LobRequest alloc] initWithAPIKey:@""];
  [request listAddressesWithResponse:^(NSArray *addresses, NSError *error) {
        NSLog(@"*** Address List Response ***");
        NSLog(@"HTTP Status Code: %i", request.statusCode);
        NSLog(@"    Addresses: %@",addresses);
    }];
}
```

The following requests are currently supported with the iOS Client.

```objc
/**
 * Address Requests
 */

-(void)listAddressesWithResponse:(void(^) (NSArray *addresses, NSError *error))response;

-(void)createAddressWithModel:(LobAddressModel*)address withResponse:(void(^) (LobAddressModel *addr, NSError *error))response;

-(void)retrieveAddressWithId:(NSString*)addrId withResponse:(void(^) (LobAddressModel *addr, NSError *error))response;

-(void)deleteAddressWithId:(NSString*)addrId withResponse:(void(^) (NSString *message, NSError *error))response;

/**
 * Bank Account Requests
 */

-(void)listBankAccountsWithResponse:(void(^) (NSArray *accounts, NSError *error))response;

-(void)createBankAccountWithModel:(LobBankAccountModel*)bankAccount withResponse:(void(^) (LobBankAccountModel *bankAccount, NSError *error))response;

-(void)retrieveBankAccountWithId:(NSString*)bankId withResponse:(void(^) (LobBankAccountModel *bankAccount, NSError *error))response;

/**
 * Check Requests
 */

-(void)listChecksWithResponse:(void(^) (NSArray *checks, NSError *error))response;

-(void)createCheckWithModel:(LobCheckModel*)check withResponse:(void(^) (LobCheckModel *check, NSError *error))response;

-(void)retrieveCheckWithId:(NSString*)checkId withResponse:(void(^) (LobCheckModel *check, NSError *error))response;

/**
 * Country Requests
 */

-(void)listCountriesWithResponse:(void(^) (NSArray *countries, NSError *error))response;

/**
 * Job Requests
 */

-(void)listJobsWithResponse:(void(^) (NSArray *jobs, NSError *error))response;

-(void)createJobWithModel:(LobJobModel*)job withResponse:(void(^) (LobJobModel *job, NSError *error))response;

-(void)retrieveJobWithId:(NSString*)jobId withResponse:(void(^) (LobJobModel *job, NSError *error))response;

/**
 * Object Requests
 */

-(void)listObjectsWithResponse:(void(^) (NSArray *objects, NSError *error))response;

-(void)createObjectWithModel:(LobObjectModel*)object withResponse:(void(^) (LobObjectModel *object, NSError *error))response;

-(void)retrieveObjectWithId:(NSString*)objectId withResponse:(void(^) (LobObjectModel *object, NSError *error))response;

-(void)deleteObjectWithId:(NSString*)objectId withResponse:(void(^) (NSString *message, NSError *error))response;

/**
 * Packaging Requests
 */

-(void)listPackagingsWithResponse:(void(^) (NSArray *packagings, NSError *error))response;

/**
 * Postcard Requests
 */

-(void)listPostcardsWithResponse:(void(^) (NSArray *postcards, NSError *error))response;

-(void)createPostcardWithModel:(LobPostcardModel*)postcard withResponse:(void(^) (LobPostcardModel *postcard, NSError *error))response;

-(void)retrievePostcardWithId:(NSString*)postcardId withResponse:(void(^) (LobPostcardModel *postcard, NSError *error))response;

/**
 * Service Requests
 */

-(void)listServicesWithResponse:(void(^) (NSArray *services, NSError *error))response;

/**
 * Setting Requests
 */

-(void)listSettingsWithResponse:(void(^) (NSArray *settings, NSError *error))response;

-(void)retrieveSettingWithId:(NSString*)settingId withResponse:(void(^) (LobSettingModel *setting, NSError *error))response;

/**
 * State Requests
 */

-(void)listStatesWithResponse:(void(^) (NSArray *states, NSError *error))response;

/**
 * Verify Requests
 */

-(void)verifyAddressModel:(LobAddressModel*)addr withResponse:(void(^) (LobVerifyModel *validation, NSError *error))response;
```

Tests
---------
To run the iOS Client tests open up the iOS Client project, then build and test. Tests are located in the lob-iosTests folder.


