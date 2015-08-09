//
//  RUntechable.h
//  Untechable
//
//  Created by Abdul Rauf on 08/08/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <Realm/Realm.h>

@interface RUntechable : RLMObject
@property NSString *rUId;
@property NSString *eventId;
@property NSString *userId;
@property NSString *paid;
@property NSString *timezoneOffset;
@property NSString *spendingTimeTxt;
@property NSString *startDate;
@property NSString *endDate;
@property NSString *hasEndDate;
@property NSString *location;
@property NSString *twillioNumber;
@property NSString *socialStatus;
@property NSString *fbAuth;
@property NSString *fbAuthExpiryTs;
@property NSString *twitterAuth;
@property NSString *twOAuthTokenSecret;
@property NSString *linkedinAuth;
@property NSString *acType;
@property NSString *email;
@property NSString *password;
@property NSString *respondingEmail;
@property NSString *iSsl;
@property NSString *imsHostName;
@property NSString *imsPort;
@property NSString *oSsl;
@property NSString *omsHostName;
@property NSString *omsPort;
@property NSString *customizedContacts;
@property NSString *userName;
@property NSString *userPhoneNumber;

@property NSString *savedOnServer, *hasFinished;

-(void)setDefault;
-(NSMutableDictionary *)getModelDic;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<RUntechable>
RLM_ARRAY_TYPE(RUntechable)
