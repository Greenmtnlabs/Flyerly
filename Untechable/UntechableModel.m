//
//  UntechableModel.m
//  Untechable
//
//  Created by arqam on 27/07/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UntechableModel.h"
#import "CommonFunctions.h"


@implementation UntechableModel{

    CommonFunctions *commonFunctions;
}
@synthesize  pk;

//Settings
@synthesize  paid, userId, uniqueId, eventId, savedOnServer, hasFinished;

//SetupGuide Screen 1 Data
@synthesize userName, userPhoneNumber;

//1-vars for screen1
@synthesize timezoneOffset, spendingTimeTxt, startDate, endDate, hasEndDate;

//2-vars for screen2

@synthesize customizedContacts, twillioNumber, location;

//3-vars for screen3
@synthesize socialStatus, fbAuth, fbAuthExpiryTs, twitterAuth, twOAuthTokenSecret, linkedinAuth;

//4-vars for screen4
@synthesize email, password, respondingEmail,acType, iSsl, oSsl, imsHostName, imsPort, omsHostName, omsPort;

@synthesize selectedContacts;

@synthesize customTextForContact;


-(id)initWithDefault{
    self = [super init];
    NSString *customizedContactsFromSetup = [[NSUserDefaults standardUserDefaults]
                                             stringForKey:@"customizedContactsFromSetup"];
    
    customizedContacts = customizedContactsFromSetup;
    return self;
}


-(NSString *)primaryKey {
    return @"pk";
}



-(NSMutableDictionary *) modelToDictionary {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    commonFunctions = [[CommonFunctions alloc] init];
    
    NSString *customizedContactsFromSetup = [[NSUserDefaults standardUserDefaults]
                                             stringForKey:@"customizedContactsFromSetup"];

    
    dic[@"eventId"]         = eventId ? eventId : @"";
    dic[@"paid"]            = paid ? @"YES" : @"NO";
    dic[@"userId"]          = userId ? userId : @"";
    dic[@"uniqueId"]        = uniqueId ? uniqueId : @"";
    dic[@"savedOnServer"]   = savedOnServer ? @"YES" : @"NO";
    dic[@"hasFinished"]     = hasFinished ? @"YES" : @"NO";
    
    //SetupGuide First Screen
    dic[@"userName"]        = userName ? userName : @"";
    dic[@"userPhoneNumber"] = userPhoneNumber ? userPhoneNumber : @"";
    
    //Screen1 vars
    dic[@"timezoneOffset"]  = [commonFunctions getTimeZoneOffset] ? [commonFunctions getTimeZoneOffset] : @"";
    dic[@"spendingTimeTxt"] = spendingTimeTxt ? spendingTimeTxt : @"";
    dic[@"startDate"]       = startDate ? startDate : @"";
    dic[@"endDate"]         = endDate ? endDate : @"";
    dic[@"hasEndDate"]      = hasEndDate ? @"YES" : @"NO";
    
    //Screen2 vars
    dic[@"twillioNumber"] = twillioNumber ? twillioNumber : @"";
    dic[@"location"] = location ? location : @"";
    
    dic[@"customizedContacts"] =  customizedContactsFromSetup ? customizedContactsFromSetup : @"";
    
    //Screen3 vars
    dic[@"socialStatus"] = socialStatus ? socialStatus : @"";
    dic[@"fbAuth"] = fbAuth ? fbAuth : @"";
    dic[@"fbAuthExpiryTs"] = fbAuthExpiryTs ? fbAuthExpiryTs : @"";
    
    dic[@"twitterAuth"] = twitterAuth ? twitterAuth : @"";
    dic[@"twOAuthTokenSecret"] = twOAuthTokenSecret ? twOAuthTokenSecret : @"";
    
    dic[@"linkedinAuth"] = linkedinAuth ? linkedinAuth : @"";
    
    //Screen4 vars
    dic[@"email"] = email ? email :@"";
    dic[@"password"] = password ? password : @"";
    dic[@"respondingEmail"] = respondingEmail ? respondingEmail : @"";
    dic[@"acType"] = acType ? acType : @"";
    
    dic[@"iSsl"] = iSsl ? iSsl : @"";
    dic[@"oSsl"] = oSsl ? oSsl : @"";
    dic[@"imsHostName"] = imsHostName ? imsHostName : @"";
    dic[@"imsPort"] = imsPort ? imsPort : @"";
    dic[@"omsHostName"] = omsHostName ? omsHostName : @"";
    dic[@"omsPort"] = omsPort ? omsPort : @"";
    
    dic[@"customTextForContact"] = customTextForContact ? customTextForContact : @"";
    
    
    
    return dic;
}







@end