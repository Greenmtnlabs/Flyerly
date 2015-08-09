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

@synthesize savedOnServer, hasFinished;

+ (NSString *)primaryKey {
    return @"rUId";
}
-(void)setDefault{
    self.rUId = @"1";
    self.eventId= @"";
    self.userId= @"";
    self.paid= @"NO";
    self.timezoneOffset= @"+5";
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
    
    //device base
    self.savedOnServer = @"NO";
    self.hasFinished = @"NO";

}
-(NSMutableDictionary *)getModelDic{
    NSMutableDictionary *dic2= [[NSMutableDictionary alloc] init];
    dic2[@"rUId"] = self.rUId;
    dic2[@"eventId"] = self.eventId;
    dic2[@"userId"] = self.userId;
    dic2[@"paid"] = self.paid;
    dic2[@"timezoneOffset"] = self.timezoneOffset;
    dic2[@"spendingTimeTxt"] = self.spendingTimeTxt;
    dic2[@"startDate"] = self.startDate;
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
    
    //device base
    dic2[@"savedOnServer"] = self.savedOnServer;
    dic2[@"hasFinished"] = self.hasFinished;
    
    return dic2;
}

-(void)setModelDic:(NSMutableDictionary *)dic{
    self.rUId  = ( dic[@"rUId"] ) ? dic[@"rUId"] : @"";
    self.eventId  = ( dic[@"eventId"] ) ? dic[@"eventId"] : @"";
    self.paid  = ([dic[@"paid"] isEqualToString:@"YES"]) ? @"YES" : @"NO";
    self.userId   = ( dic[@"userId"] ) ? dic[@"userId"] : @"";

    //Screen1 vars
    self.timezoneOffset  = ( dic[@"timezoneOffset"] ) ? dic[@"timezoneOffset"] : @"";
    self.spendingTimeTxt = ( dic[@"spendingTimeTxt"] ) ? dic[@"spendingTimeTxt"] : @"";
    self.startDate = ( dic[@"startDate"] ) ? dic[@"startDate"] : @"";
    self.endDate   = ( dic[@"endDate"] ) ? dic[@"endDate"] : @"";
    self.hasEndDate   = ([dic[@"hasEndDate"] isEqualToString:@"NO"]) ? @"YES" : @"NO";
    
    //Screen2 vars
    self.twillioNumber  = ( dic[@"twillioNumber"] ) ? dic[@"twillioNumber"] : @"";
    self.location = ( dic[@"location"] ) ? dic[@"location"] : @"";
    self.customizedContacts = ( dic[@"customizedContacts"] ) ? dic[@"customizedContacts"] : @"";
    
    //Screen3 vars
    self.socialStatus = ( dic[@"socialStatus"] ) ? dic[@"socialStatus"] : @"";
    self.fbAuth = ( dic[@"fbAuth"] ) ? dic[@"fbAuth"] : @"";
    self.fbAuthExpiryTs = ( dic[@"fbAuthExpiryTs"] ) ? dic[@"fbAuthExpiryTs"] : @"";
    self.twitterAuth  = ( dic[@"twitterAuth"] ) ? dic[@"twitterAuth"] : @"";
    self.twOAuthTokenSecret = ( dic[@"twOAuthTokenSecret"] ) ? dic[@"twOAuthTokenSecret"] : @"";
    self.linkedinAuth = ( dic[@"linkedinAuth"] ) ? dic[@"linkedinAuth"] : @"";
    
    
    //Screen3 vars
    self.email  = ( dic[@"email"] ) ? dic[@"email"] : @"";
    self.password  = ( dic[@"password"] ) ? dic[@"password"] : @"";
    self.respondingEmail = ( dic[@"respondingEmail"] ) ? dic[@"respondingEmail"] : @"";
    self.acType = ( dic[@"acType"] ) ? dic[@"acType"] : @"";
    self.iSsl   = ( dic[@"iSsl"] ) ? dic[@"iSsl"] : @"";
    self.oSsl   = ( dic[@"oSsl"] ) ? dic[@"oSsl"] : @"";
    self.imsHostName  = ( dic[@"imsHostName"] ) ? dic[@"imsHostName"] : @"";
    self.imsPort   = ( dic[@"imsPort"] ) ? dic[@"imsPort"] : @"";
    self.omsHostName  = ( dic[@"omsHostName"] ) ? dic[@"omsHostName"] : @"";
    self.omsPort   = ( dic[@"omsPort"] ) ? dic[@"omsPort"] : @"";
    
    
    //SetupGuide First Screen
    self.userName  = ( dic[@"userName"] ) ? dic[@"userName"] : @"";
    self.userPhoneNumber  = ( dic[@"userPhoneNumber"] ) ? dic[@"userPhoneNumber"] : @"";
    
    //device base
    self.savedOnServer  = ([dic[@"savedOnServer"] isEqualToString:@"YES"]) ? @"YES" : @"NO";
    self.hasFinished  = ([dic[@"hasFinished"] isEqualToString:@"YES"]) ? @"YES" : @"NO";
}


@end
