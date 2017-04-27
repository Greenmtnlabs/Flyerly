//
//  lob_iosTests.m
//  lob-iosTests
//
//  Created by Robert Maciej Pieta on 1/3/14.
//  Copyright (c) 2014 Lob. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "LobLibrary.h"

static NSString *testApiKey = @"test_0dc8d51e0acffcb1880e0f19c79b2f5b0cc";

#define Test_Address_Harry @{@"name" : @"HARRY ZHANG", \
                             @"email" : [NSNull null], \
                             @"phone" : [NSNull null], \
                             @"address_line1" : @"1600 AMPHITHEATRE PKWY", \
                             @"address_line2" : @"UNIT 199", \
                             @"address_city" : @"MOUNTAIN VIEW", \
                             @"address_state" : @"CA", \
                             @"address_zip" : @"94085", \
                             @"address_country" : @"US"}

#define Test_Address_Error @{@"name" : @"HARRY ZHANG", \
                            @"address_line2" : @"UNIT 199", \
                            @"address_city" : @"MOUNTAIN VIEW", \
                            @"address_state" : @"CA", \
                            @"address_zip" : @"94085", \
                            @"address_country" : @"US"}

#define Test_BankAddr_Chase @{@"name" : @"Chase Bank", \
                              @"address_line1" : @"55 Edmonds Street", \
                              @"address_city" : @"Palo Alto", \
                              @"address_state" : @"CA", \
                              @"address_zip" : @"90081", \
                              @"address_country" : @"US"}

#define Test_Bank_Chase @{@"routing_number" : @"122100024", \
                          @"account_number" : @"123456789", \
                          @"bank_address" : Test_BankAddr_Chase, \
                          @"signatory" : @"John Doe", \
                          @"account_address" : Test_Address_Harry}

#define Test_Check_Demo @{@"name" : @"Demo Check", \
                          @"to" : Test_Address_Harry, \
                          @"bank_account" : @{@"id" : @"bank_8d71faaa228d866"}, \
                          @"amount" : @"2200", \
                          @"memo" : @"rent"}

@interface lob_iosTests : XCTestCase {
    LobRequest *request;
    dispatch_semaphore_t sem;
}

@end

@implementation lob_iosTests

- (void)setUp
{
    [super setUp];
    request = [[LobRequest alloc] initWithAPIKey:testApiKey];
    sem = dispatch_semaphore_create(0);
}

- (void)tearDown
{
    while (dispatch_semaphore_wait(sem, DISPATCH_TIME_NOW))
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:5]];
    }

    [super tearDown];
    NSLog(@"\n\n\n\n");
}

#pragma mark -
#pragma mark Tests

/**
 * Address Tests
 */

- (void)testAddressList
{
    NSLog(@"Test Address List");
    
    [request listAddressesWithResponse:^(NSArray *addresses, NSError *error)
    {
        NSLog(@"*** Address List Response ***");
        
        XCTAssertEqual(request.statusCode, 200, @"");
        XCTAssertEqual(addresses, @[], @"");
        
        dispatch_semaphore_signal(sem);
    }];
}


- (void)testAddressCreate
{
    NSLog(@"Test Address Create");

    
    LobAddressModel *addrModel = [LobAddressModel initWithDictionary:Test_Address_Harry];
    
    [request createAddressWithModel:addrModel
                       withResponse:^(LobAddressModel *addr, NSError *error)
    {
        NSLog(@"*** Address Create Response ***");
        XCTAssertEqual(request.statusCode, 200, @"");
        [self verifyAddressHarry:addr testOrigin:@"Address create"];
        
        dispatch_semaphore_signal(sem);
    }];
}

- (void)testAddressCreateError
{
    NSLog(@"Test Address Create Error");
    
    
    LobAddressModel *addrModel = [LobAddressModel initWithDictionary:Test_Address_Error];
    
    [request createAddressWithModel:addrModel
                       withResponse:^(LobAddressModel *addr, NSError *error)
     {
         NSLog(@"*** Address Create Response ***");
         XCTAssertEqual(request.statusCode, 422, @"");
         
         dispatch_semaphore_signal(sem);
     }];
}

- (void)testAddressRetrieve
{
    NSLog(@"Test Address Retrieve");

    [request retrieveAddressWithId:@"adr_96fb02d7c04aa446"
                      withResponse:^(LobAddressModel *addr, NSError *error)
    {
        NSLog(@"*** Address Retrieve Response ***");

        XCTAssertEqual(request.statusCode, 200, @"");
        [self verifyAddressHarry:addr testOrigin:@"Address retrieve"];
        
        dispatch_semaphore_signal(sem);
    }];
}

- (void)testAddressDelete
{
    NSLog(@"Test Address Delete");

    [request deleteAddressWithId:@"adr_43769b47aed248c2"
                    withResponse:^(NSString *message, NSError *error)
    {
        NSLog(@"*** Address Delete Response ***");
        
        XCTAssertEqual(request.statusCode, 200, @"");
        
        dispatch_semaphore_signal(sem);
    }];
}

/**
 * Bank Account Tests
 */

- (void)testBankAccountList
{
    NSLog(@"Test Bank Account List");

    [request listBankAccountsWithResponse:^(NSArray *accounts, NSError *error)
    {
        NSLog(@"*** Bank Account List Response ***");

        XCTAssertEqual(request.statusCode, 200, @"");
        XCTAssertEqual(accounts, @[], @"");
        
        dispatch_semaphore_signal(sem);
    }];
}

- (void)testBankAccountCreate
{
    NSLog(@"Test Bank Account Create");

    LobBankAccountModel *bankModel = [LobBankAccountModel initWithDictionary:Test_Bank_Chase];
    [request createBankAccountWithModel:bankModel
                           withResponse:^(LobBankAccountModel *account, NSError *error)
    {
        NSLog(@"*** Bank Account Create Response ***");

        XCTAssertEqual(request.statusCode, 200, @"");
        [self verifyBankChase:account testOrigin:@"Bank account create"];
        
        dispatch_semaphore_signal(sem);
    }];
}

- (void)testBankAccountRetrieve
{
    NSLog(@"Test Bank Account Retrieve");

    [request retrieveBankAccountWithId:@"bank_0c9175a2e7627e0"
                          withResponse:^(LobBankAccountModel *account, NSError *error)
    {
        NSLog(@"*** Bank Account Retrieve Response ***");
        
        XCTAssertEqual(request.statusCode, 200, @"");
        [self verifyBankChase:account testOrigin:@"Bank account retrieve"];
        
        dispatch_semaphore_signal(sem);
    }];
}

/**
 * Check Tests
 */

- (void)testCheckList
{
    NSLog(@"Test Check List");

    [request listChecksWithResponse:^(NSArray *checks, NSError *error)
    {
        NSLog(@"*** Check List Response ***");
        XCTAssertEqual(request.statusCode, 200, @"");
        XCTAssertEqual(checks, @[], @"");
        
        dispatch_semaphore_signal(sem);
    }];
}

- (void)testCheckCreate
{
    NSLog(@"Test Check Create");
    
    LobCheckModel *checkModel = [LobCheckModel initWithDictionary:Test_Check_Demo];
    [request createCheckWithModel:checkModel
                     withResponse:^(LobCheckModel *check, NSError *error)
    {
        NSLog(@"*** Check Create Response ***");

        XCTAssertEqual(request.statusCode, 200, @"");
        [self verifyCheckDemo:check testOrigin:@"Check create"];
        
        dispatch_semaphore_signal(sem);
    }];
}

- (void)testCheckRetrieve
{
    NSLog(@"Test Check Retrieve");

    [request retrieveCheckWithId:@"chk_7ac6cd33853d0f79"
                    withResponse:^(LobCheckModel *check, NSError *error)
    {
        NSLog(@"*** Check Retrieve Response ***");

        XCTAssertEqual(request.statusCode, 200, @"");
        [self verifyCheckDemo:check testOrigin:@"Check retrieve"];
        
        dispatch_semaphore_signal(sem);
    }];
}

/**
 * Country Tests
 */

- (void)testCountryList
{
    NSLog(@"Test Country List");

    [request listCountriesWithResponse:^(NSArray *countries, NSError *error)
    {
        NSLog(@"*** Country List Response ***");
        
        XCTAssertEqual(request.statusCode, 200, @"");
 
        LobCountryModel *us = countries[0];
        XCTAssertNotNil(us, @"");
        XCTAssertEqualObjects(us.name, @"United States", @"Country name failure");
        XCTAssertEqualObjects(us.shortName, @"US", @"Country short name failure");
        
        dispatch_semaphore_signal(sem);
    }];
}

/**
 * Job Tests
 */

- (void)testJobList
{
    NSLog(@"Test Job List");

    [request listJobsWithResponse:^(NSArray *jobs, NSError *error)
    {
        NSLog(@"*** Job List Response ***");
        
        XCTAssertEqual(request.statusCode, 200, @"");
        XCTAssertEqual(jobs, @[], @"");
        
        dispatch_semaphore_signal(sem);
    }];
}

- (void)testJobCreate
{
    NSLog(@"Test Job Create");

    NSDictionary *objectDict = @{@"name" : @"Go Blue",
                                 @"setting" : @{@"id" : @"100"},
                                 @"file" : @"https://www.lob.com/goblue.pdf"};
    
    NSDictionary *jobDict = @{@"name" : @"Michigan fan letter",
                              @"to" : Test_Address_Harry,
                              @"from" : Test_Address_Harry,
                              @"objects" : @[@{@"id" : @"obj_7ca5f80b42b6dfca"},
                                             @{@"id" : @"obj_12128d3aad2aa98f"},
                                               objectDict]};
    
    LobJobModel *jobModel = [LobJobModel initWithDictionary:jobDict];
    [request createJobWithModel:jobModel
                   withResponse:^(LobJobModel *job, NSError *error)
    {
        NSLog(@"*** Job Create Response ***");

        XCTAssertEqual(request.statusCode, 200, @"");
        [self verifyJob:job testOrigin:@"Job create"];
        
        dispatch_semaphore_signal(sem);
    }];
}

- (void)testJobRetrieve
{
    NSLog(@"Test Job Retrieve");

    [request retrieveJobWithId:@"job_a32073ac3664e085"
                  withResponse:^(LobJobModel *job, NSError *error)
    {
        NSLog(@"*** Job Retrieve Response ***");
        
        XCTAssertEqual(request.statusCode, 200, @"");
        [self verifyJob:job testOrigin:@"Job create"];
        
        dispatch_semaphore_signal(sem);
    }];
}

/**
 * Object Tests
 */

- (void)testObjectList
{
    NSLog(@"Test Object List");

    [request listObjectsWithResponse:^(NSArray *objects, NSError *error)
    {
        NSLog(@"*** Object List Response ***");
        
        XCTAssertEqual(request.statusCode, 200, @"");
        XCTAssertEqual(objects, @[], @"");
        
        dispatch_semaphore_signal(sem);
    }];
}

- (void)testObjectCreate
{
    NSLog(@"Test Object Create");
    
    
    
    NSDictionary *objectDict = @{@"name" : @"Go Blue",
                                 @"setting" : @{@"id" : @"100"},
                                 @"file" : @"https://www.lob.com/goblue.pdf"};
    
    LobObjectModel *objectModel = [LobObjectModel initWithDictionary:objectDict];
//    [request createObjectWithModel:objectModel
//                      withResponse:^(LobObjectModel *object, NSError *error)
    {
        NSLog(@"*** Object Create Response ***");

        XCTAssertEqual(request.statusCode, 200, @"");
        [self verifyObject:object testOrigin:@"Object create"];
        
        dispatch_semaphore_signal(sem);
    }];
}

- (void)testObjectLocalCreate
{
    NSLog(@"Test Object Local Create");
    
    NSString *zaPDFPath = @"";
    for (NSBundle *bundle in [NSBundle allBundles]) {
        NSString *path = [bundle pathForResource:@"zalogo" ofType:@"pdf"];
        if (path)
        {
            zaPDFPath = path;
        }
    }
    
    NSDictionary *objectDict = @{@"name" : @"Go Blue",
                                 @"setting" : @{@"id" : @"100"},
                                 @"file" : zaPDFPath};
    
    LobObjectModel *objectModel = [LobObjectModel initWithDictionary:objectDict];
    objectModel.localFilePath = YES;
    
//    [request createObjectWithModel:objectModel
//                      withResponse:^(LobObjectModel *object, NSError *error)
     {
         NSLog(@"*** Object Create Local Response ***");
         
         XCTAssertEqual(request.statusCode, 200, @"");
         [self verifyObject:object testOrigin:@"Object create local"];
         
         dispatch_semaphore_signal(sem);
     }];
}

- (void)testObjectRetrieve
{
    NSLog(@"Test Object Retrieve");

    [request retrieveObjectWithId:@"obj_7530eea3b78a78a7"
                     withResponse:^(LobObjectModel *object, NSError *error)
    {
        NSLog(@"*** Object Retrieve Response ***");

        XCTAssertEqual(request.statusCode, 200, @"");
        [self verifyObject:object testOrigin:@"Object retrieve"];
        
        dispatch_semaphore_signal(sem);
    }];
}

- (void)testObjectDelete
{
    NSLog(@"Test Object Delete");

    [request deleteObjectWithId:@"obj_4241a46e01b4f892"
                   withResponse:^(NSString *message, NSError *error)
    {
        NSLog(@"*** Object Delete Response ***");
        
        XCTAssertEqual(request.statusCode, 200, @"");
        
        dispatch_semaphore_signal(sem);
    }];
}

/**
 * Packaging Tests
 */

- (void)testPackagingList
{
    NSLog(@"Test Packaging List");

    [request listPackagingsWithResponse:^(NSArray *packagings, NSError *error)
    {
        NSLog(@"*** Packaging List Response ***");

        XCTAssertEqual(request.statusCode, 200, @"");
        
        LobPackagingModel *smartPackage = packagings[0];
        XCTAssertNotNil(smartPackage, @"");
        XCTAssertEqualObjects(smartPackage.name, @"Smart Packaging", @"Packaging name failure");
        
        dispatch_semaphore_signal(sem);
    }];
}

/**
 * Postcard Tests
 */

- (void)testPostcardList
{
    NSLog(@"Test Postcard List");

    [request listPostcardsWithResponse:^(NSArray *postcards, NSError *error)
    {
        NSLog(@"*** Postcard List Response ***");
        
        XCTAssertEqual(request.statusCode, 200, @"");
        XCTAssertEqual(postcards, @[], @"");
        
        dispatch_semaphore_signal(sem);
    }];
}

- (void)testPostcardCreate
{
    NSLog(@"Test Postcard Create");
    
    NSDictionary *postcardDict = @{@"name" : @"Demo Postcard",
                                   @"front" : @"https://www.lob.com/postcardfront.pdf",
                                   @"back" : @"https://www.lob.com/postcardback.pdf",
                                   @"to" : Test_Address_Harry,
                                   @"from" : Test_Address_Harry};
   
    LobPostcardModel *postcardModel = [LobPostcardModel initWithDictionary:postcardDict];
    [request createPostcardWithModel:postcardModel
                        withResponse:^(LobPostcardModel *postcard, NSError *error)
    {
        NSLog(@"*** Postcard Create Response ***");
        
        XCTAssertEqual(request.statusCode, 200, @"");
        XCTAssertEqualObjects(postcard.name, @"Demo Postcard", @"Postcard retrieve name create");
        XCTAssertEqualObjects(postcard.message, [NSNull null], @"Postcard retrieve message create");
        XCTAssertEqualObjects(postcard.status, @"processed", @"Postcard retrieve status create");
        [self verifyAddressHarry:postcard.toAddress testOrigin:@"Postcard create"];
        [self verifyAddressHarry:postcard.fromAddress testOrigin:@"Postcard create"];
        
        dispatch_semaphore_signal(sem);
    }];
}

- (void)testPostcardRetrieve
{
    NSLog(@"Test Postcard Retrieve");

    [request retrievePostcardWithId:@"psc_17e6425ae08576ce"
                       withResponse:^(LobPostcardModel *postcard, NSError *error)
    {
        NSLog(@"*** Postcard Retrieve Response ***");
        
        XCTAssertEqual(request.statusCode, 200, @"");
        XCTAssertEqualObjects(postcard.name, @"Demo Postcard", @"Postcard retrieve name failure");
        XCTAssertEqualObjects(postcard.message, [NSNull null], @"Postcard retrieve message failure");
        XCTAssertEqualObjects(postcard.status, @"processed", @"Postcard retrieve status failure");
        [self verifyAddressHarry:postcard.toAddress testOrigin:@"Postcard retrieve"];
        [self verifyAddressHarry:postcard.fromAddress testOrigin:@"Postcard retrieve"];
        
        XCTAssertEqualObjects(postcard.price, @"1.00", @"Postcard retrieve");
        
        dispatch_semaphore_signal(sem);
    }];
}

/**
 * Service Tests
 */

- (void)testServiceList
{
    NSLog(@"Test Service List");

    [request listServicesWithResponse:^(NSArray *services, NSError *error)
    {
        NSLog(@"*** Service List Response ***");

        XCTAssertEqual(request.statusCode, 200, @"");
        
        LobServiceModel *certified = services[0];
        XCTAssertNotNil(certified, @"");
        
        XCTAssertEqualObjects(certified.name, @"Registered Mail", @"Service name failure");
        
        dispatch_semaphore_signal(sem);
    }];
}

/**
 * Setting Tests
 */

- (void)testSettingList
{
    NSLog(@"Test Setting List");

    [request listSettingsWithResponse:^(NSArray *settings, NSError *error)
    {
        NSLog(@"*** Setting List Response ***");

        XCTAssertEqual(request.statusCode, 200, @"");

        LobSettingModel *bwSetting = settings[1];
        XCTAssertNotNil(bwSetting, @"");
        
        XCTAssertEqualObjects(bwSetting.type, @"documents", @"Setting type failure");
        XCTAssertEqualObjects(bwSetting.paper, @"20lb paper standard", @"Setting paper description failure");
        XCTAssertEqualObjects(bwSetting.width, @"8.500", @"Setting width failure");
        XCTAssertEqualObjects(bwSetting.length, @"11.000", @"Setting length failure");
        XCTAssertEqualObjects(bwSetting.color, @"black and white", @"Setting color failure");
        XCTAssertEqualObjects(bwSetting.notes, @"12 cents per extra page", @"Settings notes failure");
        
        dispatch_semaphore_signal(sem);
    }];
}

- (void)testSettingRetrieve
{
    NSLog(@"Test Setting Retrieve");

    [request retrieveSettingWithId:@"101"
                      withResponse:^(LobSettingModel *setting, NSError *error)
    {
        NSLog(@"*** Setting Retrieve Response ***");
        
        XCTAssertEqual(request.statusCode, 200, @"");
        XCTAssertEqualObjects(setting.type, @"documents", @"Setting type failure");
        XCTAssertEqualObjects(setting.paper, @"20lb paper standard", @"Setting paper description failure");
        XCTAssertEqualObjects(setting.width, @"8.500", @"Setting width failure");
        XCTAssertEqualObjects(setting.length, @"11.000", @"Setting length failure");
        XCTAssertEqualObjects(setting.color, @"color", @"Setting color failure");
        XCTAssertEqualObjects(setting.notes, @"50 cents per extra page", @"Settings notes failure");
        
        
        dispatch_semaphore_signal(sem);
    }];
}

/**
 * State Tests
 */

- (void)testStateList
{
    NSLog(@"Test State List");

    [request listStatesWithResponse:^(NSArray *states, NSError *error)
    {
        NSLog(@"*** State List Response ***");

        XCTAssertEqual(request.statusCode, 200, @"");
        
        LobStateModel *alabama = states[0];
        XCTAssertNotNil(alabama, @"");
        
        XCTAssertEqualObjects(alabama.name, @"Alabama", @"State name failure");
        XCTAssertEqualObjects(alabama.shortName, @"AL", @"State short name failure");
        
        dispatch_semaphore_signal(sem);
    }];
}


/**
 * Verify Tests
 */

- (void)testVerify
{
    NSLog(@"Test Verify Address");

    LobAddressModel *model = [[LobAddressModel alloc] initWithDictionary:@{
                    @"address_line1" : Test_Address_Harry[@"address_line1"],
                    @"address_city" : Test_Address_Harry[@"address_city"],
                    @"address_state" : Test_Address_Harry[@"address_state"],
                    @"address_zip" : Test_Address_Harry[@"address_zip"]}];
    
    [request verifyAddressModel:model
                   withResponse:^(LobVerifyModel *validation, NSError *error)
    {
        NSLog(@"*** Verify Address Response ***");

        XCTAssertEqual(request.statusCode, 200, @"");

        XCTAssertEqualObjects(validation.address.addressLine1, @"1600 AMPHITHEATRE PKWY", @"Verify address line 1 failure");
        XCTAssertEqualObjects(validation.address.addressCity, @"MOUNTAIN VIEW", @"Verify city failure");
        XCTAssertEqualObjects(validation.address.addressState, @"CA", @"Verify state failure");
        XCTAssertEqualObjects(validation.address.addressZip, @"94043-1351", @"Verify zip failure");
        XCTAssertEqualObjects(validation.address.addressCountry, @"US", @"Verify country failure");
        
        dispatch_semaphore_signal(sem);
    }];
}

#pragma mark -
#pragma mark Verify Methods

-(void)verifyAddressHarry:(LobAddressModel*)addr testOrigin:(NSString*)testOrigin {
    XCTAssertEqualObjects(addr.name, @"HARRY ZHANG", @"Addr name failure: %@", testOrigin);
    XCTAssertEqualObjects(addr.email, [NSNull null], @"Addr email failure: %@", testOrigin);
    XCTAssertEqualObjects(addr.phone, [NSNull null], @"Addr phone failure: %@", testOrigin);
    XCTAssertEqualObjects(addr.addressLine1, @"1600 AMPHITHEATRE PKWY", @"Addr address line 1 failure: %@", testOrigin);
    XCTAssertEqualObjects(addr.addressLine2, @"UNIT 199", @"Addr address line 2 failure: %@", testOrigin);
    XCTAssertEqualObjects(addr.addressCity, @"MOUNTAIN VIEW", @"Addr city failure: %@", testOrigin);
    XCTAssertEqualObjects(addr.addressState, @"California", @"Addr state failure: %@", testOrigin);
    XCTAssertEqualObjects(addr.addressZip, @"94085", @"Addr zip failure: %@", testOrigin);
    XCTAssertEqualObjects(addr.addressCountry, @"United States", @"Addr country failure: %@", testOrigin);
}

-(void)verifyBankChase:(LobBankAccountModel*)bank testOrigin:(NSString*)testOrigin {
    XCTAssertEqualObjects(bank.routingNumber, @"122100024", @"Bank routing number failure: %@", testOrigin);
    XCTAssertEqualObjects(bank.accountNumber, @"123456789", @"Bank account number failure: %@", testOrigin);
    
    [self verifyAddressHarry:bank.accountAddress testOrigin:testOrigin];
    [self verifyBankAddrChase:bank.bankAddress testOrigin:testOrigin];
}

-(void)verifyBankAddrChase:(LobAddressModel*)addr testOrigin:(NSString*)testOrigin {
    XCTAssertEqualObjects(addr.name, @"Chase Bank", @"Bank addr name failure: %@", testOrigin);
    XCTAssertEqualObjects(addr.email, [NSNull null], @"Bank addr email failure: %@", testOrigin);
    XCTAssertEqualObjects(addr.phone, [NSNull null], @"Bank addr phone failure: %@", testOrigin);
    XCTAssertEqualObjects(addr.addressLine1, @"55 Edmonds Street", @"Bank addr line 1 failure: %@", testOrigin);
    XCTAssertEqualObjects(addr.addressLine2, [NSNull null], @"Bank addr line 2 failure: %@", testOrigin);
    XCTAssertEqualObjects(addr.addressCity, @"Palo Alto", @"Bank addr city failure: %@", testOrigin);
    XCTAssertEqualObjects(addr.addressState, @"California", @"Bank addr state failure: %@", testOrigin);
    XCTAssertEqualObjects(addr.addressZip, @"90081", @"Bank addr zip failure: %@", testOrigin);
    XCTAssertEqualObjects(addr.addressCountry, @"United States", @"Bank addr country failure: %@", testOrigin);
}

-(void)verifyCheckDemo:(LobCheckModel*)check testOrigin:(NSString*)testOrigin {
    XCTAssertEqualObjects(check.name, @"Demo Check", @"Check name failure: %@", testOrigin);
    XCTAssertEqualObjects(check.memo, @"rent", @"Check memo failure: %@", testOrigin);
    XCTAssertEqualObjects(check.amount, @"2200.00", @"Check amount failure: %@", testOrigin);

    [self verifyAddressHarry:check.toAddress testOrigin:testOrigin];
    [self verifyBankChase:check.bank testOrigin:testOrigin];
    
}

-(void)verifyJob:(LobJobModel*)job testOrigin:(NSString*)testOrigin {
    XCTAssertEqualObjects(job.name, @"Michigan fan letter", @"Job name failure: %@", testOrigin);
    
    [self verifyAddressHarry:job.toAddress testOrigin:testOrigin];
    [self verifyAddressHarry:job.fromAddress testOrigin:testOrigin];
}

-(void)verifyObject:(LobObjectModel*)object testOrigin:(NSString*)testOrigin {
    XCTAssertEqualObjects(object.name, @"Go Blue", @"Object name failure: %@", testOrigin);
    XCTAssertEqualObjects(object.quantity, @1, @"Object quantity failure: %@", testOrigin);
    XCTAssertFalse(object.fullBleed, @"Object full bleed failure: %@", testOrigin);
    XCTAssertFalse(object.doubleSided, @"Object double sided failure: %@", testOrigin);
}

@end
