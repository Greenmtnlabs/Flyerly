 //
//  UntechableClass.m
//  Untechable
//
//  Created by RIKSOF Developer on 23/sep/2014
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//
//

#import "Untechable.h"
#import "Common.h"
#import "RSetUntechable.h"

@implementation Untechable

//Settings
@synthesize socialNetworksStatusModal, commonFunctions, dic, paid, userId, rUId, eventId, dateFormatter, savedOnServer, hasFinished;

//SetupGuide Screen 1 Data
@synthesize userName, userPhoneNumber;

//1-vars for screen1
@synthesize timezoneOffset, spendingTimeTxt, startDate, endDate, hasEndDate;

//2-vars for screen2
@synthesize customizedContacts, twillioNumber, location ,customizedContactsForCurrentSession;

//3-vars for screen3
@synthesize socialStatus, fbAuth, fbAuthExpiryTs, twitterAuth, twOAuthTokenSecret, linkedinAuth;

//4-vars for screen4
@synthesize email, password, respondingEmail,acType, iSsl, oSsl, imsHostName, imsPort, omsHostName, omsPort;

/*
 * Initialize untechable object with required models initialization
 */
- (id)initWithCommonFunctions{
    self = [super init];
    commonFunctions = [[CommonFunctions alloc] init];
    socialNetworksStatusModal = [SocialNetworksStatusModal sharedInstance];
    return self;
}

/**
 * Common function for going back to previous screen
 */
-(void)goBack:navigationControllerPointer{
    [navigationControllerPointer popViewControllerAnimated:YES];
    // Remove observers
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *
 * @return: Unique Id in the form of string
 */
- (NSString *)generateUniqueId {
    static int randomNumber = 0;
    
    // Generates Unique ID even within a second
    int timestamp = [[NSDate date] timeIntervalSince1970];
    randomNumber = (randomNumber + 1) % 100;
    
    NSString *uniqId = [NSString stringWithFormat:@"%u%02u", timestamp, randomNumber];
    return uniqId;
}

/**
 * addOrUpdateInModel saves and updates in model (Untechable)
 * if command is SAVE, dictionary is not required (i.e. pass nil)
 * if command is UPDATE, dictionary is required
 */
-(void)addOrUpdateInModel:(NSString *)command dictionary:(NSMutableDictionary *)dictionary{

    if( [command isEqualToString:SAVE] ) {
        dic = [[NSMutableDictionary alloc] init];
        dic[@"rUId"]            = rUId;
        dic[@"eventId"]         = eventId;
        dic[@"paid"]            = paid ? @"YES" : @"NO";
        dic[@"userId"]          = userId;
        dic[@"savedOnServer"]   = savedOnServer ? @"YES" : @"NO";
        dic[@"hasFinished"]     = hasFinished ? @"YES" : @"NO";        
        
        //SetupGuide First Screen
        dic[@"userName"]        = userName;
        dic[@"userPhoneNumber"] = userPhoneNumber;

        //Screen1 vars
        dic[@"timezoneOffset"]  = timezoneOffset;
        dic[@"spendingTimeTxt"] = spendingTimeTxt;
        dic[@"startDate"]       = startDate;
        dic[@"endDate"]         = endDate;
        dic[@"hasEndDate"]      = hasEndDate ? @"YES" : @"NO";
        
        //Screen2 vars
        dic[@"twillioNumber"] = twillioNumber;
        dic[@"location"] = location;
        
        dic[@"customizedContacts"] = [commonFunctions convertCCMArrayIntoJsonString:customizedContactsForCurrentSession];
        customizedContacts = ( dic[@"customizedContacts"] ) ? dic[@"customizedContacts"] : @"";
        customizedContactsForCurrentSession = [commonFunctions convertJsonStringIntoCCMArray:customizedContacts];
        
        //Screen3 vars
        dic[@"socialStatus"] = socialStatus;
        dic[@"fbAuth"] = fbAuth;
        dic[@"fbAuthExpiryTs"] = fbAuthExpiryTs;
        
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
    }
    else if( [command isEqualToString:UPDATE] ) {
        dic = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
       
        //Settings
        rUId        = ( dic[@"rUId"] ) ? dic[@"rUId"] : @"";
        eventId        = ( dic[@"eventId"] ) ? dic[@"eventId"] : @"";
        paid           = ([dic[@"paid"] isEqualToString:@"YES"]) ? YES : NO;
        userId         = ( dic[@"userId"] ) ? dic[@"userId"] : @"";
        savedOnServer  = ([dic[@"savedOnServer"] isEqualToString:@"YES"]) ? YES : NO;
        hasFinished     = ([dic[@"hasFinished"] isEqualToString:@"YES"]) ? YES : NO;
        
        //SetupGuide First Screen
        userName        = ( dic[@"userName"] ) ? dic[@"userName"] : @"";
        userPhoneNumber        = ( dic[@"userPhoneNumber"] ) ? dic[@"userPhoneNumber"] : @"";
        
        //Screen1 vars
        timezoneOffset  = ( dic[@"timezoneOffset"] ) ? dic[@"timezoneOffset"] : [commonFunctions getTimeZoneOffset];
        spendingTimeTxt = ( dic[@"spendingTimeTxt"] ) ? dic[@"spendingTimeTxt"] : @"";
        startDate       = ( dic[@"startDate"] ) ? dic[@"startDate"] : [commonFunctions convertNSDateToTimestamp: [NSDate date] ]; //start now
        endDate         = ( dic[@"endDate"] ) ? dic[@"endDate"] : [commonFunctions convertNSDateToTimestamp: [[NSDate date] dateByAddingTimeInterval:(60*60*24)] ]; //current time +1 day
        hasEndDate      = ([dic[@"hasEndDate"] isEqualToString:@"NO"]) ? NO : YES;
        
        //Screen2 vars
        twillioNumber     = ( dic[@"twillioNumber"] ) ? dic[@"twillioNumber"] : @"";
        location          = ( dic[@"location"] ) ? dic[@"location"] : @"";
    
        customizedContacts = ( dic[@"customizedContacts"] ) ? dic[@"customizedContacts"] : @"";
        customizedContactsForCurrentSession = [commonFunctions convertJsonStringIntoCCMArray:customizedContacts];
    
        //Screen3 vars
        socialStatus = ( dic[@"socialStatus"] ) ? dic[@"socialStatus"] : @"";
        fbAuth       = ( dic[@"fbAuth"] ) ? dic[@"fbAuth"] : @"";
        fbAuthExpiryTs = ( dic[@"fbAuthExpiryTs"] ) ? dic[@"fbAuthExpiryTs"] : [commonFunctions convertNSDateToTimestamp:[commonFunctions getDate:@"PAST_1_MONTH"] ];
        
        twitterAuth  = ( dic[@"twitterAuth"] ) ? dic[@"twitterAuth"] : @"";
        twOAuthTokenSecret = ( dic[@"twOAuthTokenSecret"] ) ? dic[@"twOAuthTokenSecret"] : @"";
        linkedinAuth = ( dic[@"linkedinAuth"] ) ? dic[@"linkedinAuth"] : @"";

        //set in social media model
        socialNetworksStatusModal.mFbAuth = fbAuth;
        socialNetworksStatusModal.mFbAuthExpiryTs = fbAuthExpiryTs;
        socialNetworksStatusModal.mTwitterAuth = twitterAuth;
        socialNetworksStatusModal.mTwOAuthTokenSecret = twOAuthTokenSecret;
        socialNetworksStatusModal.mLinkedinAuth = linkedinAuth;        

        
        //Screen3 vars
        email           = ( dic[@"email"] ) ? dic[@"email"] : @"";
        password        = ( dic[@"password"] ) ? dic[@"password"] : @"";
        respondingEmail = ( dic[@"respondingEmail"] ) ? dic[@"respondingEmail"] : @"";
        acType          = ( dic[@"acType"] ) ? dic[@"acType"] : @"";
        iSsl            = ( dic[@"iSsl"] ) ? dic[@"iSsl"] : @"";
        oSsl            = ( dic[@"oSsl"] ) ? dic[@"oSsl"] : @"";
        imsHostName     = ( dic[@"imsHostName"] ) ? dic[@"imsHostName"] : @"";
        imsPort         = ( dic[@"imsPort"] ) ? dic[@"imsPort"] : @"";
        omsHostName     = ( dic[@"omsHostName"] ) ? dic[@"omsHostName"] : @"";
        omsPort         = ( dic[@"omsPort"] ) ? dic[@"omsPort"] : @"";
    }

}

/**
 * Reset contacts into session contact variable
 */
-(void) resetCustomizedContactsForCurrentSession {
    customizedContactsForCurrentSession = [commonFunctions convertJsonStringIntoCCMArray:customizedContacts];
}

/**
 * @return: BOOL ( whether current untechable is started)
 */
- (BOOL)isUntechableStarted {
    BOOL started = NO;
    
    NSDate* _startDate = [commonFunctions convertTimestampToNSDate:startDate];
    if( [commonFunctions isEndDateGreaterThanStartDate: _startDate endDate:[NSDate date]]){
        started = YES;
    }
    
    return started;
}

/**
 * @return: BOOL ( whether current untechable is started)
 */
- (BOOL)isUntechableExpired {
    BOOL expired = NO;
    
    if( expired == NO ){
        NSDate* date1 = [commonFunctions convertTimestampToNSDate:endDate];
        if( [commonFunctions isEndDateGreaterThanStartDate:date1 endDate:[NSDate date]]){
            expired = YES;
        }
    }
    return expired;
}

#pragma mark - Save in realm
/**
 * Add or Update running instance variable into realm database
 */
-(void)addOrUpdateInDatabase{
    [[RLMRealm defaultRealm] transactionWithBlock:^{
        [self addOrUpdateInModel:SAVE dictionary:nil];
        if([rUId isEqualToString:@"1"])
        [RSetUntechable createOrUpdateInDefaultRealmWithValue:self.dic];
        else
        [RUntechable createOrUpdateInDefaultRealmWithValue:self.dic];
    }];
}

#pragma mark - Send to Server
/**
 * Send untechable to server
 * 1- Save into database
 * 2- Send to server
 * @Callback: 3- callback function will be invoked when we got response from api
 */
-(void)sendToApiAfterTask:(void(^)(BOOL,NSString *))callBack{

    [self addOrUpdateInDatabase];
    
    //During testing dont send untechable to server, just create in device and go t thankyou screen
    if( [UNT_ENVIRONMENT isEqualToString:TESTING] ){
        callBack(NO, @"Thankyou");
        return;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:API_SAVE]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSArray *stringVarsAry = [[NSArray alloc] initWithObjects:@"eventId", @"userId", @"paid",
                              @"timezoneOffset", @"spendingTimeTxt", @"startDate", @"endDate", @"hasEndDate"
                              , @"location",@"twillioNumber"
                              ,@"socialStatus", @"fbAuth", @"fbAuthExpiryTs" , @"twitterAuth",@"twOAuthTokenSecret",   @"linkedinAuth"
                              ,@"acType", @"email", @"password", @"respondingEmail", @"iSsl", @"imsHostName", @"imsPort", @"oSsl", @"omsHostName", @"omsPort",@"customizedContacts",@"userName", @"userPhoneNumber"
                              ,nil];

    for (NSString* key in dic) {
        BOOL sendIt =   NO;
        id value    =   [dic objectForKey:key];
        
        if( sendIt || [stringVarsAry containsObject:key]){
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
    }//for
    
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    BOOL errorOnFinish = NO;
    NSString *message = @"";
    
    if( returnData != nil ){
        
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
        
        if( [[dict valueForKey:@"status"] isEqualToString:@"OK"] ) {
            
            twillioNumber = [dict valueForKey:@"twillioNumber"];
            eventId = [dict valueForKey:@"eventId"];
            savedOnServer = YES;
            hasFinished = YES;
            [self addOrUpdateInDatabase];
            
        } else{
            message = [dict valueForKey:@"message"];
            if( !([[dict valueForKey:@"eventId"] isEqualToString:@"0"]) ) {
                eventId = [dict valueForKey:@"eventId"];
                [self addOrUpdateInDatabase];
            }
            
            errorOnFinish = YES;
        }
    }
    else{
        errorOnFinish = YES;
        message = @"Error occurred, please try again later.";        
    }
    
    callBack(errorOnFinish, message);
}

/**
 * @return: When we have all neccessory data required for sending email then we can show skip button,
            on email setting related screens
 */
-(BOOL)canSkipEmailSetting{
    BOOL showSkip = NO;
    BOOL hasEmailAndPassword = !( [email isEqualToString:@""] || [password isEqualToString:@""]);
    BOOL isOtherAcType = [acType isEqualToString:@"OTHER"];
    BOOL hasAllOtherAcInfo = !( [iSsl isEqualToString:@""] || [oSsl isEqualToString:@""] || [imsHostName isEqualToString:@""] || [imsPort isEqualToString:@""] || [omsHostName isEqualToString:@""] || [omsPort isEqualToString:@""] );
    
    if( ( !isOtherAcType && hasEmailAndPassword ) || ( isOtherAcType && hasEmailAndPassword && hasAllOtherAcInfo) ){
        showSkip = YES;
    }
    return showSkip;
}

#pragma mark - timeStamp to days or hours coverter
-(NSString *) calculateHoursDays:(NSString *) startTime endTime:(NSString *)endTime {
    
    int totalMinutes;
    int totalHoursDays;
    int remainingMinutes;
    double start = [startTime doubleValue];
    double end = [endTime doubleValue];
    
    NSString *daysOrHoursToBeShown;
    int OneMinute = 60;
    int OneHour =  60 * 60;
    int OneDay  =  60 * 60 * 24;
    double diff = fabs(end  - start);
    
    totalHoursDays = round(diff/OneHour);
    totalMinutes = round(((diff/OneHour) * OneMinute));
    
    // calculating remaining minutes
    
    if(totalMinutes<=59){
        remainingMinutes = totalMinutes;
    } else if(totalMinutes<=120) {
        remainingMinutes = totalMinutes%60;
    } else {
        remainingMinutes = totalMinutes%(totalHoursDays*60);
    }
    
    if(totalHoursDays>=24) {
        
        totalHoursDays = round(diff/OneDay + 0.1);
        
        if( totalHoursDays == 1 ) {
            daysOrHoursToBeShown = [NSString stringWithFormat:@"%i day", totalHoursDays];
        } else {
            daysOrHoursToBeShown = [NSString stringWithFormat:@"%i days", totalHoursDays];
        }
    } else {
        
        NSString *minutes;
        if(remainingMinutes>1) {
            minutes = @"minutes";
        } else if(remainingMinutes==1) {
            minutes = @"minute";
        }
        
        if(totalHoursDays>1){
            if(remainingMinutes>0) {
                daysOrHoursToBeShown = [NSString stringWithFormat:@"%i hours and %i %@" ,totalHoursDays, remainingMinutes, minutes];
            } else {
                daysOrHoursToBeShown = [NSString stringWithFormat:@"%i hours" ,totalHoursDays];
            }
        } else if(totalHoursDays==1) {
            if(remainingMinutes>0) {
                daysOrHoursToBeShown = [NSString stringWithFormat:@"%i hour and %i %@" ,totalHoursDays, remainingMinutes, minutes];
            } else {
                daysOrHoursToBeShown = [NSString stringWithFormat:@"%i hour" ,totalHoursDays];
            }
        } else if(totalHoursDays<1) {
            daysOrHoursToBeShown = [NSString stringWithFormat:@"%i minutes", remainingMinutes];
        }
    }
    
    NSLog(@"Number of days or hours: %@", daysOrHoursToBeShown);
    return daysOrHoursToBeShown;
}
@end