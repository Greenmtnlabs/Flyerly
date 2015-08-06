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
@property (nonatomic, assign) BOOL paid;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *uniqueId;
@property (nonatomic, assign) BOOL savedOnServer;
@property (nonatomic, assign) BOOL hasFinished;


//SetupGuide Screen 1
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userPhoneNumber;

//Screen1
@property (strong, nonatomic) NSString *timezoneOffset, *spendingTimeTxt, *startDate, *endDate;
@property (nonatomic, assign) BOOL hasEndDate;


//Screen2
@property (strong, nonatomic) NSString *customizedContacts;
@property (strong, nonatomic) NSString *twillioNumber, *location;

//Screen3
@property (strong, nonatomic) NSString *socialStatus, *fbAuth, *fbAuthExpiryTs, *twitterAuth, *twOAuthTokenSecret, *linkedinAuth;

//Screen4
@property (strong, nonatomic) NSString *email, *password, *respondingEmail, *acType, *iSsl, *oSsl, *imsHostName, *imsPort,
*omsHostName, *omsPort;


//selected contacts
@property (strong, nonatomic) NSString *selectedContacts;

@property (strong, nonatomic) NSString *customTextForContact;

-(NSString *)primaryKey;

-(NSMutableDictionary *) modelToDictionary;

-(id)initWithDefault;

@end
#endif
