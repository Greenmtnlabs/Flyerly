//
//  UntechableTests.m
//  UntechableTests
//
//  Created by ABDUL RAUF on 24/09/2014.
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SingleContactDetailsModal.h"


@interface UntechableTests : XCTestCase{
    SingleContactDetailsModal *singleContactModal;
}




@end

@implementation UntechableTests



- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    singleContactModal = [[SingleContactDetailsModal alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


-(void)testSingleContactModal_checkName{
    
    NSString *name = @"Tester";
    singleContactModal.name = name;
    
    XCTAssertEqual(singleContactModal.name, name, @"Result was not correct!");
}


-(void)testSingleContactModal_checkAllPhoneNumber{
    
    NSString *name = @"Tester";
    singleContactModal.name = name;
    
    NSMutableArray *phones = [[NSMutableArray alloc] init];
    [phones addObject:@"Mobile"];
    [phones addObject:@"03001234567"];
    [phones addObject:@"0"];
    [phones addObject:@"0"];
    
    [singleContactModal.allPhoneNumbers addObject:phones];
    
    XCTAssertEqual([singleContactModal.allPhoneNumbers[0] count], phones.count, @"Result was not correct!");
}


-(void)testSingleContactModal_checkAllEmails{
    
    NSMutableArray *emails = [[NSMutableArray alloc] init];
    [emails addObject:@"abc@dom.com"];
    [emails addObject:@"0"];
    
    [singleContactModal.allEmails addObject:emails];
   
    XCTAssertEqual([singleContactModal.allEmails[0] count], emails.count, @"Result was not correct!");
}

-(void)testSingleContactModal_checkMethod_checkContacts_YES{
    
    NSString *name = @"Tester";
    singleContactModal.name = name;
   
    NSMutableArray *phones = [[NSMutableArray alloc] init];
    NSMutableArray *emails = [[NSMutableArray alloc] init];
    
    
    BOOL expectedFlag = YES;
    BOOL estimatedFlag = singleContactModal.checkContacts;
    
    XCTAssertEqual(expectedFlag, estimatedFlag, @"Result was not correct!");
}


-(void)testSingleContactModal_checkMethod_checkContacts_NO{
    
    NSString *name = @"Tester";
    singleContactModal.name = name;
    
    NSMutableArray *phones = [[NSMutableArray alloc] init];
    [phones addObject:@"Mobile"];
    [phones addObject:@"03001234567"];
    [phones addObject:@"1"];
    [phones addObject:@"0"];
    
    NSMutableArray *emails = [[NSMutableArray alloc] init];
    [emails addObject:@"abc@dom.com"];
    [emails addObject:@"1"];
    
    [singleContactModal.allPhoneNumbers addObject:phones];
    [singleContactModal.allEmails addObject:emails];
    
    BOOL expectedFlag = NO;
    BOOL estimatedFlag = singleContactModal.checkContacts;
   
    XCTAssertEqual(expectedFlag, estimatedFlag, @"Result was not correct!");
}



@end
