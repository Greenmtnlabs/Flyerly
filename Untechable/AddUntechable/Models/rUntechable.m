//
//  RUntechable.m
//  Untechable
//
//  Created by Abdul Rauf on 08/08/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "RUntechable.h"

@implementation RUntechable
@synthesize rUId,eventId,userId,paid,timezoneOffset,spendingTimeTxt,startDate,endDate,hasEndDate,location,twillioNumber,socialStatus,fbAuth,fbAuthExpiryTs,twitterAuth,twOAuthTokenSecret,linkedinAuth,acType,email,password,respondingEmail,iSsl,imsHostName,imsPort,oSsl,omsHostName,omsPort,customizedContacts,userName,userPhoneNumber;

+ (NSString *)primaryKey {
    return @"rUId";
}
-(void)setDefault{
    rUId = @"";
    eventId= @"";
    userId= @"";
    paid= @"";
    timezoneOffset= @"";
    spendingTimeTxt= @"";
    startDate= @"";
    endDate= @"";
    hasEndDate= @"";
    location= @"";
    twillioNumber= @"";
    socialStatus= @"";
    fbAuth= @"";
    fbAuthExpiryTs= @"";
    twitterAuth= @"";
    twOAuthTokenSecret= @"";
    linkedinAuth= @"";
    acType= @"";
    email= @"";
    password= @"";
    respondingEmail= @"";
    iSsl= @"";
    imsHostName= @"";
    imsPort= @"";
    oSsl= @"";
    omsHostName= @"";
    omsPort= @"";
    customizedContacts= @"";
    userName= @"";
    userPhoneNumber= @"";
}
-(NSMutableDictionary *)getModelDic{
    NSMutableDictionary *dic2= [[NSMutableDictionary alloc] init];
    dic2[@"rUId"] = rUId;
    dic2[@"eventId"] = eventId;
    dic2[@"userId"] = userId;
    dic2[@"paid"] = paid;
    dic2[@"timezoneOffset"] = timezoneOffset;
    dic2[@"spendingTimeTxt"] = spendingTimeTxt;
    dic2[@"spendingTimeTxt"] = startDate;
    dic2[@"endDate"] = endDate;
    dic2[@"hasEndDate"] = hasEndDate;
    dic2[@"location"] = location;
    dic2[@"twillioNumber"] = twillioNumber;
    dic2[@"socialStatus"] = socialStatus;
    dic2[@"fbAuth"] = fbAuth;
    dic2[@"fbAuthExpiryTs"] = fbAuthExpiryTs;
    dic2[@"twitterAuth"] = twitterAuth;
    dic2[@"twOAuthTokenSecret"] = twOAuthTokenSecret;
    dic2[@"linkedinAuth"] = linkedinAuth;
    dic2[@"acType"] = acType;
    dic2[@"email"] = email;
    dic2[@"password"] = password;
    dic2[@"respondingEmail"] = respondingEmail;
    dic2[@"iSsl"] = iSsl;
    dic2[@"imsHostName"] = imsHostName;
    dic2[@"imsPort"] = imsPort;
    dic2[@"oSsl"] = oSsl;
    dic2[@"omsHostName"] = omsHostName;
    dic2[@"omsPort"] = omsPort;
    dic2[@"customizedContacts"] = customizedContacts;
    dic2[@"userName"] = userName;
    dic2[@"userPhoneNumber"] = userPhoneNumber;
    return dic2;
}

@end
