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
#import "AFNetworking.h"

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
    [self setUserData];
    
    return self;
}

/*
 * Initialize untechable object with required models initialization
 */
- (id)initWithSettingUntechable{
    self = [super init];
    commonFunctions = [[CommonFunctions alloc] init];
    socialNetworksStatusModal = [SocialNetworksStatusModal sharedInstance];
    
    RLMResults *unsortedSetObjects = [RSetUntechable objectsWhere:@"rUId == '1'"];
    RSetUntechable *rSetUntechable = unsortedSetObjects[0];
    [self addOrUpdateInModel:UPDATE dictionary:[rSetUntechable getModelDic]];
    [self setUserData];
    
    return self;
}

/**
 * Variable we must need in model, for testing we can use these vars
 */

-(void) setUserData{
    self.userId   = TEST_UID;
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
    
        
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:API_SAVE]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:API_SAVE parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *returnData = responseObject;
        
        BOOL errorOnFinish = NO;
        NSString *message = @"";
        
        if( returnData != nil ){
            
            if( [[returnData valueForKey:@"status"] isEqualToString:@"OK"] ) {
                
                twillioNumber = [returnData valueForKey:@"twillioNumber"];
                eventId = [returnData valueForKey:@"eventId"];
                savedOnServer = YES;
                hasFinished = YES;
                [self addOrUpdateInDatabase];
                
            } else{
                message = [returnData valueForKey:@"message"];
                if( !([[returnData valueForKey:@"eventId"] isEqualToString:@"0"]) ) {
                    eventId = [returnData valueForKey:@"eventId"];
                    [self addOrUpdateInDatabase];
                }
                errorOnFinish = YES;
            }
        }
        else{
            errorOnFinish = YES;
            message = NSLocalizedString(@"Error occurred, please try again later.", nil);
        }
        
        callBack(errorOnFinish, message);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       
        NSString *message = NSLocalizedString(@"Error occurred, please try again later.", nil);
        BOOL errorOnFinish = YES;
        callBack(errorOnFinish, message);
        
    }];
    
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
    int oneMinute = 60;
    int oneHour =  60 * 60;
    int oneDay  =  60 * 60 * 24;
    double diff = fabs(end  - start);
    
    totalHoursDays = floor(diff/oneHour);
    totalMinutes = round((round(diff/oneHour) - (diff/oneHour)) * oneMinute);
    
    // calculating remaining minutes
    
    if(totalMinutes<=59){
        remainingMinutes = totalMinutes;
    } else if(totalMinutes<=120) {
        remainingMinutes = totalMinutes%60;
    } else {
        remainingMinutes = totalMinutes%(totalHoursDays*60);
    }
    
    if(totalHoursDays>=24) {
        
        totalHoursDays = round(diff/oneDay + 0.1);
        
        if( totalHoursDays == 1 ) {
            daysOrHoursToBeShown = [NSString stringWithFormat:@"%i day", totalHoursDays];
        } else {
            daysOrHoursToBeShown = [NSString stringWithFormat:@"%i days", totalHoursDays];
        }
    } else {
        
        NSString *minutes;
        if(remainingMinutes>1) {
            minutes = NSLocalizedString(@"minutes", nil);
        } else if(remainingMinutes==1) {
            minutes = NSLocalizedString(@"minute", nil);
        }
        
        if(totalHoursDays>1){
            if(remainingMinutes>0) {
                daysOrHoursToBeShown = [NSString stringWithFormat:NSLocalizedString(@"%i hours and %i %@", nil) ,totalHoursDays, remainingMinutes, minutes];
            } else {
                daysOrHoursToBeShown = [NSString stringWithFormat:NSLocalizedString(@"%i hours", nil) ,totalHoursDays];
            }
        } else if(totalHoursDays==1) {
            if(remainingMinutes>0) {
                daysOrHoursToBeShown = [NSString stringWithFormat:NSLocalizedString(@"%i hour and %i %@", nil) ,totalHoursDays, remainingMinutes, minutes];
            } else {
                daysOrHoursToBeShown = [NSString stringWithFormat:NSLocalizedString(@"%i hour", nil) ,totalHoursDays];
            }
        } else if(totalHoursDays<1) {
            daysOrHoursToBeShown = [NSString stringWithFormat:NSLocalizedString(@"%i minutes", nil), remainingMinutes];
        }
    }
    
    NSLog(@"Number of days or hours: %@", daysOrHoursToBeShown);
    return daysOrHoursToBeShown;
}

/**
 * Delete untechable from datebase
 */
-(void)deleteUntechable:(NSString *)dbRowId callBack:(void(^)(bool))callBack{
    RLMRealm *realm = RLMRealm.defaultRealm;
    RLMResults *untechableToBeDeleted = [RUntechable objectsInRealm:realm where:@"rUId == %@", dbRowId];
    if( untechableToBeDeleted.count ){
        [realm beginWriteTransaction];
        [realm deleteObjects:untechableToBeDeleted];
        [realm commitWriteTransaction];
        
        callBack(YES);
    } else{
        callBack(YES);
    }
}
@end