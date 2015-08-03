//
//  UntechableModel.m
//  Untechable
//
//  Created by arqam on 27/07/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UntechableModel.h"

@implementation UntechableModel

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






@end