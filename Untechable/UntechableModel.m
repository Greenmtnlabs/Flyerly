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


-(NSString *)primaryKey {
    return @"pk";
}


-(NSMutableDictionary *) modelToDictionary {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    commonFunctions = [[CommonFunctions alloc] init];
    
    NSString *customizedContactsFromSetup = [[NSUserDefaults standardUserDefaults]
                                             stringForKey:@"customizedContactsFromSetup2"];

    
    dic[@"eventId"]         = @"";
    dic[@"paid"]            = paid ? @"YES" : @"NO";
    dic[@"userId"]          = @"";
    dic[@"uniqueId"]        = @"";
    dic[@"savedOnServer"]   = savedOnServer ? @"YES" : @"NO";
    dic[@"hasFinished"]     = hasFinished ? @"YES" : @"NO";
    
    //SetupGuide First Screen
    dic[@"userName"]        = @"";
    dic[@"userPhoneNumber"] = @"";
    
    //Screen1 vars
    dic[@"timezoneOffset"]  = [commonFunctions getTimeZoneOffset];
    dic[@"spendingTimeTxt"] = @"";
    dic[@"startDate"]       = [commonFunctions nsDateToTimeStampStr: [NSDate date] ];
    dic[@"endDate"]         = [commonFunctions nsDateToTimeStampStr: [[NSDate date] dateByAddingTimeInterval:(60*60*24)]];
    dic[@"hasEndDate"]      = hasEndDate ? @"YES" : @"NO";
    
    //Screen2 vars
    dic[@"twillioNumber"] = twillioNumber;
    dic[@"location"] = location;
    
    dic[@"customizedContacts"] =  customizedContactsFromSetup;
    
    //Screen3 vars
    dic[@"socialStatus"] = socialStatus;
    dic[@"fbAuth"] = fbAuth;
    dic[@"fbAuthExpiryTs"] = [commonFunctions nsDateToTimeStampStr:[commonFunctions getDate:@"PAST_1_MONTH"]];
    
    dic[@"twitterAuth"] = twitterAuth;
    dic[@"twOAuthTokenSecret"] = twOAuthTokenSecret;
    
    dic[@"linkedinAuth"] = linkedinAuth;
    
    //Screen4 vars
    dic[@"email"] = email;
    dic[@"password"] = password;
    dic[@"respondingEmail"] = respondingEmail;
    dic[@"acType"] = acType;
    
    dic[@"iSsl"] = iSsl;
    dic[@"oSsl"] = oSsl;
    dic[@"imsHostName"] = imsHostName;
    dic[@"imsPort"] = imsPort;
    dic[@"omsHostName"] = omsHostName;
    dic[@"omsPort"] = omsPort;
    
    dic[@"customTextForContact"] = customTextForContact;
    
    
    
    return dic;
}




@end