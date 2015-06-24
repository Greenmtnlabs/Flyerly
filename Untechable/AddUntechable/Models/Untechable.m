 //
//  UntechableClass.m
//  Untechable
//
//  Created by Abdul Rauf on 23/sep/2014
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//
//

#import "Untechable.h"
#import "Common.h"


@implementation Untechable

//Settings
@synthesize commonFunctions, dic, piecesFile, paid, userId, uniqueId, eventId, untechablePath, dateFormatter, savedOnServer, hasFinished;

//SetupGuide Screen 1 Data
@synthesize userName, userPhoneNumber;

//1-vars for screen1
@synthesize timezoneOffset, spendingTimeTxt, startDate, endDate, hasEndDate;

//2-vars for screen2
//@synthesize customizedContacts,twillioNumber, location, emergencyContacts, emergencyNumber, hasRecording,customizedContactsForCurrentSession;

@synthesize customizedContacts, twillioNumber, location ,customizedContactsForCurrentSession;

//3-vars for screen3
@synthesize socialStatus, fbAuth, fbAuthExpiryTs, twitterAuth, twOAuthTokenSecret, linkedinAuth;

//4-vars for screen4
@synthesize email, password, respondingEmail,acType, iSsl, oSsl, imsHostName, imsPort, omsHostName, omsPort;


-(NSDate *)stringToDate:(NSString *)inputStrFormate dateString:(NSString *)dateString{
        NSLog(@"dateString is %@", dateString);
    NSDateFormatter *dateFormatterTemp = [[NSDateFormatter alloc] init];

    if( [inputStrFormate  isEqual:DATE_FORMATE_1] ){
        dateFormatterTemp.dateFormat = inputStrFormate;

        NSDate *dateFrmString = [dateFormatterTemp dateFromString:dateString];

        NSString *formattedDateString = [dateFormatterTemp stringFromDate:dateFrmString];
        NSLog(@"Date in new format is %@", formattedDateString);
        
        
        return dateFrmString;
    }
    
    return [NSDate date];//default
}
-(void)printNavigation:navigationControllerPointer
{

    // Pop the current view, and push the crop view.
    //NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[navigationControllerPointer viewControllers]];
    //NSLog(@"NSMutableArray *viewControllers = %@", viewControllers);
    
    
    
    /*
    [viewControllers removeLastObject];
    [viewControllers removeLastObject];
    [viewControllers addObject:nbuCrop];
    [[self navigationController] setViewControllers:viewControllers animated:YES];
     */
}

-(void)goBack:navigationControllerPointer{
    [navigationControllerPointer popViewControllerAnimated:YES];
    // Remove observers
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/******************** ******************** ******************** ******************** ********************/

/**
 * getUniqueId
 *
 * This method ensures a unique ID is assigned to each element.
 */
- (NSString *)getUniqueId
{
    static int randomNumber = 0;
    
    // Create Unique ID even within a second
    int timestamp = [[NSDate date] timeIntervalSince1970];
    randomNumber = (randomNumber + 1) % 100;
    
    NSString *uniqId = [NSString stringWithFormat:@"%u%02u", timestamp, randomNumber];
    return uniqId;
}

-(NSString *)getUserPath
{
    //Getting Home Directory
	NSString *homeDirectoryPath = NSHomeDirectory();
    return [homeDirectoryPath stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@/Untechable",userId]];
}

/*
 * Get path of recording file
 */
-(NSString *)getRecFilePath
{
    return [NSString stringWithFormat:@"%@/%@",untechablePath, [self getRecFileName]];
}
-(NSString *)getRecFileName
{
    return [NSString stringWithFormat:@"%@_%@%@",userId,uniqueId, REC_FORMATE];
}

/*
 * Here we Getting Path for new Untechable
 */
-(NSString *)getNewUntechablePath
{
	NSString *userPath = [self getUserPath];
    NSString *retUntechablePath = [userPath stringByAppendingString:[NSString stringWithFormat:@"/%@_%@", userId, uniqueId]];
    
    return retUntechablePath;
}

/*
    Check untechablePath ( folder ) exist in device, if not then create and return the directory url
 */
-(BOOL)initUntechableDirectory
{
    BOOL hasInit = NO;
    BOOL isDir;
    NSFileManager *fm = [NSFileManager defaultManager];

    if(![fm fileExistsAtPath:untechablePath isDirectory:&isDir])
    {
        if([fm createDirectoryAtPath:untechablePath withIntermediateDirectories:YES attributes:nil error:nil]){
            NSLog(@"New Directory Created");
            
           [self setOrSaveVars:SAVE];
            
            hasInit = YES;
        }
        else{
            NSLog(@"Directory Creation Failed");
        }
    }
    else {
        NSLog(@"Directory Already Exist");
       [self setOrSaveVars:RESET];
        hasInit = YES;
    }
    
    return hasInit;
}

/*
    if setOrSAve: SAVE
    save instance variables into dic, then save that dic into .piecs file
 
    else if setOrSAve: SAVE
    get dic( must have untechablePath ) , then update instance variables a/c .pieces file
 */
-(void)setOrSaveVars:(NSString *)setOrSAve
{
    
    if( [setOrSAve isEqualToString:SAVE] ) {
        
        piecesFile = [untechablePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", PIECES_FILE]];
        
        dic = [[NSMutableDictionary alloc] init];

        dic[@"eventId"]         = eventId;
        dic[@"paid"]            = paid ? @"YES" : @"NO";
        dic[@"userId"]          = userId;
        dic[@"uniqueId"]        = uniqueId;
        dic[@"untechablePath"]  = untechablePath;
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
        //dic[@"emergencyNumber"] = emergencyNumber;
        //dic[@"emergencyContacts"] = emergencyContacts;
        //dic[@"hasRecording"] = hasRecording ? @"YES" : @"NO";
        
        dic[@"customizedContacts"] = [commonFunctions convertCCMArrayIntoJsonString:customizedContactsForCurrentSession];
        customizedContacts = dic[@"customizedContacts"];
        customizedContactsForCurrentSession = [commonFunctions convertJsonStringIntoCCMArray:dic[@"customizedContacts"]];
        
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
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
        [data writeToFile:piecesFile atomically:YES];
        //Here we write the dictionary of .peices files
        //[dic writeToFile:piecesFile atomically:YES];

    }
    else if( [setOrSAve isEqualToString:RESET] ) {
        
        piecesFile = [untechablePath stringByAppendingString:[NSString stringWithFormat:@"/%@", PIECES_FILE]];
        NSData *data = [NSData dataWithContentsOfFile:piecesFile];
        dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        //dic = [[NSMutableDictionary alloc] initWithContentsOfFile:piecesFile];
        
        
        //Settings
        eventId        = ( dic[@"eventId"] ) ? dic[@"eventId"] : @"";
        paid           = ([dic[@"paid"] isEqualToString:@"YES"]) ? YES : NO;
        userId         = ( dic[@"userId"] ) ? dic[@"userId"] : @"";
        uniqueId       = ( dic[@"uniqueId"] ) ? dic[@"uniqueId"] : [self getUniqueId];
        untechablePath = ( dic[@"untechablePath"] ) ? dic[@"untechablePath"] : [self getNewUntechablePath];
        savedOnServer  = ([dic[@"savedOnServer"] isEqualToString:@"YES"]) ? YES : NO;
        hasFinished     = ([dic[@"hasFinished"] isEqualToString:@"YES"]) ? YES : NO;
        
        //SetupGuide First Screen
        userName        = ( dic[@"userName"] ) ? dic[@"userName"] : @"";
        userPhoneNumber        = ( dic[@"userPhoneNumber"] ) ? dic[@"userPhoneNumber"] : @"";
        
        //Screen1 vars
        timezoneOffset  = ( dic[@"timezoneOffset"] ) ? dic[@"timezoneOffset"] : [commonFunctions getTimeZoneOffset];
        spendingTimeTxt = ( dic[@"spendingTimeTxt"] ) ? dic[@"spendingTimeTxt"] : @"";
        startDate       = ( dic[@"startDate"] ) ? dic[@"startDate"] : [commonFunctions nsDateToTimeStampStr: [NSDate date] ]; //start now
        endDate         = ( dic[@"endDate"] ) ? dic[@"endDate"] : [commonFunctions nsDateToTimeStampStr: [[NSDate date] dateByAddingTimeInterval:(60*60*24)] ]; //current time +1 day
        hasEndDate      = ([dic[@"hasEndDate"] isEqualToString:@"NO"]) ? NO : YES;
        
        //Screen2 vars
        twillioNumber     = ( dic[@"twillioNumber"] ) ? dic[@"twillioNumber"] : @"";
        location          = ( dic[@"location"] ) ? dic[@"location"] : @"";
        //emergencyNumber   = ( dic[@"emergencyNumber"] ) ? dic[@"emergencyNumber"] : @"";
        //emergencyContacts = ( dic[@"emergencyContacts"] ) ? dic[@"emergencyContacts"] : @"";
        //hasRecording      = ([dic[@"hasRecording"] isEqualToString:@"YES"]) ? YES : NO;
    
        customizedContacts = ( dic[@"customizedContacts"] ) ? dic[@"customizedContacts"] : @"";
        customizedContactsForCurrentSession = [commonFunctions convertJsonStringIntoCCMArray:customizedContacts];
    
        //Screen3 vars
        socialStatus = ( dic[@"socialStatus"] ) ? dic[@"socialStatus"] : @"";
        fbAuth       = ( dic[@"fbAuth"] ) ? dic[@"fbAuth"] : @"";
        fbAuthExpiryTs = ( dic[@"fbAuthExpiryTs"] ) ? dic[@"fbAuthExpiryTs"] : [commonFunctions nsDateToTimeStampStr:[commonFunctions getDate:@"PAST_1_MONTH"] ];
        
        twitterAuth  = ( dic[@"twitterAuth"] ) ? dic[@"twitterAuth"] : @"";
        twOAuthTokenSecret = ( dic[@"twOAuthTokenSecret"] ) ? dic[@"twOAuthTokenSecret"] : @"";
        linkedinAuth = ( dic[@"linkedinAuth"] ) ? dic[@"linkedinAuth"] : @"";

        
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
    
    //NSLog(@"dic: %@", dic);
}

/**
 Get the current date of device
 **/
-(NSDate *)getCurrentDate{
    NSDate *date = [NSDate date];
    return date;
}

/*
 Set default values for new event
 */
-(void)initWithDefValues
{
    //Settings
    eventId  = @"";
    paid     = NO;
    uniqueId = [self getUniqueId];
    untechablePath = [self getNewUntechablePath];
    savedOnServer = NO;
    hasFinished   = NO;
    
    //Setup Guide First Screen
    userName = @"";
    userPhoneNumber = @"";
    
    //Screen1
    timezoneOffset  = [commonFunctions getTimeZoneOffset];
    spendingTimeTxt = @"";
    startDate = [commonFunctions nsDateToTimeStampStr: [NSDate date] ]; //start now
    endDate   = [commonFunctions nsDateToTimeStampStr: [[NSDate date] dateByAddingTimeInterval:(60*60*24)] ]; //current time +1 Day
    hasEndDate = YES;
    
    //Screen2
    twillioNumber  = @"";
    location  = @"";
    //emergencyNumber  = @"";
    //emergencyContacts = [[NSMutableDictionary alloc] init];
    //hasRecording = NO;
    customizedContactsForCurrentSession = [[NSMutableArray alloc] init];
    customizedContacts = @"";

    //Screen3
    socialStatus = @"";
    fbAuth       = @"";
    fbAuthExpiryTs = [commonFunctions nsDateToTimeStampStr:[commonFunctions getDate:@"PAST_1_MONTH"] ];
    twitterAuth  = @"";
    twOAuthTokenSecret = @"";
    linkedinAuth = @"";
    
    //Screen4
    email           = @"";
    password        = @"";
    respondingEmail = @"";
    iSsl = @"";
    oSsl = @"";
    acType = imsHostName = imsPort = omsHostName = omsPort= @"";
}

/*
 *Here we sort Array in Desending order for Exact Render of Flyer
 * as last saved.
 */
NSInteger compareDesc(id stringLeft, id stringRight, void *context) {
    
    // Convert both strings to integers
    long long intLeft = [stringLeft longLongValue];
    long long intRight = [stringRight longLongValue];
    
    if (intLeft < intRight)
        return NSOrderedDescending;
    else if (intLeft > intRight)
        return NSOrderedAscending;
    else
        return NSOrderedSame;
}

- (BOOL)isUntechableStarted
{
    BOOL started = NO;
    
    NSDate* date1 = [commonFunctions timestampStrToNsDate:startDate];
    if( [commonFunctions date1IsSmallerThenDate2:date1 date2:[NSDate date]]){
        started = YES;
    }
    
    return started;
}

- (BOOL)isUntechableExpired
{
    BOOL expired = NO;
    
    
    if( hasEndDate == NO ){
        //expired = YES;
    }
    
    if( expired == NO ){
        NSDate* date1 = [commonFunctions timestampStrToNsDate:endDate];
        if( [commonFunctions date1IsSmallerThenDate2:date1 date2:[NSDate date]]){
            expired = YES;
        }
    }
    
    return expired;
}

#pragma mark -  Twitter functions
//Update data base for fb data
-(void)twFlushData
{
    [self twUpdateData:@"" oAuthTokenSecret:@"" ];
}

@end