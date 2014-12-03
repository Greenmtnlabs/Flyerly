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

//1-vars for screen1
@synthesize timezoneOffset, spendingTimeTxt, startDate, endDate, hasEndDate;

//2-vars for screen2
@synthesize twillioNumber, location, emergencyContacts, emergencyNumber, hasRecording;

//3-vars for screen3
@synthesize socialStatus, fbAuth, fbAuthExpiryTs, twitterAuth, twOAuthTokenSecret, linkedinAuth;

//4-vars for screen4
@synthesize email, password, respondingEmail;


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
        

        //Screen1 vars
        dic[@"timezoneOffset"]  = timezoneOffset;
        dic[@"spendingTimeTxt"] = spendingTimeTxt;
        dic[@"startDate"]       = startDate;
        dic[@"endDate"]         = endDate;
        dic[@"hasEndDate"]      = hasEndDate ? @"YES" : @"NO";
        
        //Screen2 vars
        dic[@"twillioNumber"] = twillioNumber;
        dic[@"location"] = location;
        dic[@"emergencyNumber"] = emergencyNumber;
        dic[@"emergencyContacts"] = emergencyContacts;
        dic[@"hasRecording"] = hasRecording ? @"YES" : @"NO";

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
        dic[@"hasFinished"] = hasFinished ? @"YES" : @"NO";
        
        //Here we write the dictionary of .peices files
        [dic writeToFile:piecesFile atomically:YES];

    }
    else if( [setOrSAve isEqualToString:RESET] ) {
        
        piecesFile = [untechablePath stringByAppendingString:[NSString stringWithFormat:@"/%@", PIECES_FILE]];
        dic = [[NSMutableDictionary alloc] initWithContentsOfFile:piecesFile];
        
        
        //Settings
        eventId        = ( dic[@"eventId"] ) ? dic[@"eventId"] : @"";
        paid           = ([dic[@"paid"] isEqualToString:@"YES"]) ? YES : NO;
        userId         = ( dic[@"userId"] ) ? dic[@"userId"] : @"";
        uniqueId       = ( dic[@"uniqueId"] ) ? dic[@"uniqueId"] : [self getUniqueId];
        untechablePath = ( dic[@"untechablePath"] ) ? dic[@"untechablePath"] : [self getNewUntechablePath];
        savedOnServer  = ([dic[@"savedOnServer"] isEqualToString:@"YES"]) ? YES : NO;
        
        //Screen1 vars
        timezoneOffset  = ( dic[@"timezoneOffset"] ) ? dic[@"timezoneOffset"] : [commonFunctions getTimeZoneOffset];
        spendingTimeTxt = ( dic[@"spendingTimeTxt"] ) ? dic[@"spendingTimeTxt"] : @"";
        startDate       = ( dic[@"startDate"] ) ? dic[@"startDate"] : [commonFunctions nsDateToTimeStampStr: [NSDate date] ]; //start now
        endDate         = ( dic[@"endDate"] ) ? dic[@"endDate"] : [commonFunctions nsDateToTimeStampStr: [[NSDate date] dateByAddingTimeInterval:(60*120)] ]; //current time +2hr
        hasEndDate      = ([dic[@"hasEndDate"] isEqualToString:@"NO"]) ? NO : YES;
        
        //Screen2 vars
        twillioNumber     = ( dic[@"twillioNumber"] ) ? dic[@"twillioNumber"] : @"";
        location          = ( dic[@"location"] ) ? dic[@"location"] : @"";
        emergencyNumber   = ( dic[@"emergencyNumber"] ) ? dic[@"emergencyNumber"] : @"";
        emergencyContacts = ( dic[@"emergencyContacts"] ) ? dic[@"emergencyContacts"] : @"";
        hasRecording      = ([dic[@"hasRecording"] isEqualToString:@"YES"]) ? YES : NO;
        
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
        hasFinished     = ([dic[@"hasFinished"] isEqualToString:@"YES"]) ? YES : NO;
        
    }
    
    //NSLog(@"dic: %@", dic);
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
    
    //Screen1
    timezoneOffset  = [commonFunctions getTimeZoneOffset];
    spendingTimeTxt = @"";
    startDate = [commonFunctions nsDateToTimeStampStr: [NSDate date] ]; //start now
    endDate   = [commonFunctions nsDateToTimeStampStr: [[NSDate date] dateByAddingTimeInterval:(60*120)] ]; //current time +2hr
    hasEndDate = YES;
    
    //Screen2
    twillioNumber  = @"";
    location  = @"";
    emergencyNumber  = @"";
    emergencyContacts = [[NSMutableDictionary alloc] init];
    hasRecording = NO;
    
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


#pragma mark -  Facebook functions
// This method will handle ALL the session state changes in the app
- (void)fbSessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        
        // Show the user the logged-in UI
        [self fbUserLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self fbUserLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self fbShowMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self fbShowMessage:alertText withTitle:alertTitle];
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self fbShowMessage:alertText withTitle:alertTitle];
            }
        }
        
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // Show the user the logged-out UI
        [self fbUserLoggedOut];
    }
}

// Show the user the logged-out UI
- (void)fbUserLoggedOut
{
    // Set the button title as "Log in with Facebook"
    //----//UIButton *loginButton = [self.customLoginViewController loginButton];
    //----//[loginButton setTitle:@"Log in with Facebook" forState:UIControlStateNormal];
    
    // Confirm logout message
    //----// [self fbShowMessage:@"You're now logged out" withTitle:@""];

    [self fbFlushFbData];
}


// Show the user the logged-in UI
- (void)fbUserLoggedIn
{
    
    NSString *fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];

    NSDate *expirationDate = [[[FBSession activeSession] accessTokenData] expirationDate];

    [self fbUpdateFbData:fbAccessToken fbAuthExpD:expirationDate];
    
    // Set the button title as "Log out"
    //----// UIButton *loginButton = self.customLoginViewController.loginButton;
    //----// [loginButton setTitle:@"Log out" forState:UIControlStateNormal];
    
    // Welcome message
    //----// [self fbShowMessage:@"You're now logged in" withTitle:@"Welcome!"];
    
}

// Show an alert message
- (void)fbShowMessage:(NSString *)text withTitle:(NSString *)title
{
    NSLog(@"in fbShowMessage: title=%@, text=%@", title, text);
    
  /*
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
   */
}

//Update data base for fb data
-(void)fbFlushFbData
{
    [self fbUpdateFbData:@"" fbAuthExpD:[commonFunctions getDate:@"PAST_1_MONTH"] ];
}

//Update data base for fb data
-(void)fbUpdateFbData:(NSString *)fbA fbAuthExpD:(NSDate * )fbAuthExpD
{
    NSLog(@"expirationDate=%@",fbAuthExpD);
    NSLog(@"fbAccessToken=%@",fbA);
    
    fbAuth = fbA;
    fbAuthExpiryTs = [commonFunctions nsDateToTimeStampStr:fbAuthExpD ];
    
    [self setOrSaveVars:SAVE];
}

#pragma mark -  Twitter functions
//Update data base for fb data
-(void)twFlushData
{
    [self twUpdateData:@"" oAuthTokenSecret:@"" ];
}

//Update data base for fb data
-(void)twUpdateData:(NSString *)oAuthToken oAuthTokenSecret:(NSString * )oAuthTokenSecret
{
    NSLog(@"oAuthToken=%@",oAuthToken);
    NSLog(@"oAuthTokenSecret=%@",oAuthTokenSecret);
    
    twitterAuth =   oAuthToken;
    twOAuthTokenSecret =   oAuthTokenSecret;

    [self setOrSaveVars:SAVE];
}

#pragma mark -  LinkedIn functions
//Update data base for fb data
-(void)linkedInFlushData
{
    [self linkedInUpdateData:@""];
}

//Update data base for fb data
-(void)linkedInUpdateData:(NSString *)linkedInAccessToken
{
    NSLog(@"linkedInAccessToken=%@",linkedInAccessToken);
    linkedinAuth = linkedInAccessToken;
    
    [self setOrSaveVars:SAVE];
}
@end