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
    self.rUId = @"";
    self.eventId= @"";
    self.userId= @"";
    self.paid= @"";
    self.timezoneOffset= @"";
    self.spendingTimeTxt= @"";
    self.startDate= @"";
    self.endDate= @"";
    self.hasEndDate= @"";
    self.location= @"";
    self.twillioNumber= @"";
    self.socialStatus= @"";
    self.fbAuth= @"";
    self.fbAuthExpiryTs= @"";
    self.twitterAuth= @"";
    self.twOAuthTokenSecret= @"";
    self.linkedinAuth= @"";
    self.acType= @"";
    self.email= @"";
    self.password= @"";
    self.respondingEmail= @"";
    self.iSsl= @"";
    self.imsHostName= @"";
    self.imsPort= @"";
    self.oSsl= @"";
    self.omsHostName= @"";
    self.omsPort= @"";
    self.customizedContacts= @"";
    self.userName= @"";
    self.userPhoneNumber= @"";
}
-(NSMutableDictionary *)getModelDic{
    NSMutableDictionary *dic2= [[NSMutableDictionary alloc] init];
    dic2[@"rUId"] = self.rUId;
    dic2[@"eventId"] = self.eventId;
    dic2[@"userId"] = self.userId;
    dic2[@"paid"] = self.paid;
    dic2[@"timezoneOffset"] = self.timezoneOffset;
    dic2[@"spendingTimeTxt"] = self.spendingTimeTxt;
    dic2[@"spendingTimeTxt"] = self.startDate;
    dic2[@"endDate"] = self.endDate;
    dic2[@"hasEndDate"] = self.hasEndDate;
    dic2[@"location"] = self.location;
    dic2[@"twillioNumber"] = self.twillioNumber;
    dic2[@"socialStatus"] = self.socialStatus;
    dic2[@"fbAuth"] = self.fbAuth;
    dic2[@"fbAuthExpiryTs"] = self.fbAuthExpiryTs;
    dic2[@"twitterAuth"] = self.twitterAuth;
    dic2[@"twOAuthTokenSecret"] = self.twOAuthTokenSecret;
    dic2[@"linkedinAuth"] = self.linkedinAuth;
    dic2[@"acType"] = self.acType;
    dic2[@"email"] = self.email;
    dic2[@"password"] = self.password;
    dic2[@"respondingEmail"] = self.respondingEmail;
    dic2[@"iSsl"] = self.iSsl;
    dic2[@"imsHostName"] = self.imsHostName;
    dic2[@"imsPort"] = self.imsPort;
    dic2[@"oSsl"] = self.oSsl;
    dic2[@"omsHostName"] = self.omsHostName;
    dic2[@"omsPort"] = self.omsPort;
    dic2[@"customizedContacts"] = self.customizedContacts;
    dic2[@"userName"] = self.userName;
    dic2[@"userPhoneNumber"] = self.userPhoneNumber;
    return dic2;
}


@end
