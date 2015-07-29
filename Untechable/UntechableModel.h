//
//  UntechableModel.h
//  Untechable
//
//  Created by arqam on 27/07/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#ifndef Untechable_UntechableModel_h
#define Untechable_UntechableModel_h

#import "RealmModel.h"


@interface UntechableModel : RealmModel{
    NSString *eventId;
    NSInteger pk;
}


@property (nonatomic, assign) NSInteger pk;
@property (strong, nonatomic) NSString *eventId;


//Settings
@property (strong, nonatomic) NSString *paid;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *uniqueId;
@property (strong, nonatomic) NSString *savedOnServer;
@property (strong, nonatomic) NSString *hasFinished;


//SetupGuide Screen 1
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userPhoneNumber;

//Screen1
@property (strong, nonatomic) NSString *timezoneOffset, *spendingTimeTxt, *startDate, *endDate;
@property (strong, nonatomic) NSString *hasEndDate;


//Screen2
@property (strong, nonatomic) NSString *customizedContacts;
@property (strong, nonatomic) NSString *twillioNumber, *location;
@property (strong, nonatomic) NSString *customizedContactsForCurrentSession;

//Screen3
@property (strong, nonatomic) NSString *socialStatus, *fbAuth, *fbAuthExpiryTs, *twitterAuth, *twOAuthTokenSecret, *linkedinAuth;

//Screen4
@property (strong, nonatomic) NSString *email, *password, *respondingEmail, *acType, *iSsl, *oSsl, *imsHostName, *imsPort,
*omsHostName, *omsPort;





@end
#endif
