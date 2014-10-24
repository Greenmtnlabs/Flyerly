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
@synthesize commonFunctions, dic, piecesFile, userId, uniqueId, eventId, untechablePath, dateFormatter;

//1-vars for screen1
@synthesize timezoneOffset, spendingTimeTxt, startDate, endDate, hasEndDate;

//2-vars for screen2
@synthesize twillioNumber, location, emergencyContacts, emergencyNumber, hasRecording;

//3-vars for screen3
@synthesize socialStatus, fbAuth, twitterAuth, linkedinAuth;

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
       [self setOrSaveVars:SET];
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

        dic[@"userId"] = userId;
        dic[@"uniqueId"]    =   uniqueId;
        dic[@"eventId"]    =   eventId;
        dic[@"untechablePath"]  =   untechablePath;

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
        dic[@"twitterAuth"] = twitterAuth;
        dic[@"linkedinAuth"] = linkedinAuth;
        
        //Screen4 vars
        dic[@"email"] = email;
        dic[@"password"] = password;
        dic[@"respondingEmail"] = respondingEmail;
        
        //Here we write the dictionary of .peices files
        [dic writeToFile:piecesFile atomically:YES];

    }
    else if( [setOrSAve isEqualToString:SET] ) {
        
        piecesFile = [untechablePath stringByAppendingString:[NSString stringWithFormat:@"/%@", PIECES_FILE]];
        dic = [[NSMutableDictionary alloc] initWithContentsOfFile:piecesFile];
        
        
        //Settings
        userId         = dic[@"userId"];
        uniqueId       = dic[@"uniqueId"];
        eventId        = dic[@"eventId"];
        untechablePath = dic[@"untechablePath"];
        
        
        //Screen1 vars
        timezoneOffset  = dic[@"timezoneOffset"];
        spendingTimeTxt = dic[@"spendingTimeTxt"];
        startDate       = dic[@"startDate"];
        endDate         = dic[@"endDate"];
        hasEndDate      = ([dic[@"hasEndDate"] isEqualToString:@"YES"]) ? YES : NO;
        
        //Screen2 vars
        twillioNumber     = dic[@"twillioNumber"];
        location          = dic[@"location"];
        emergencyNumber   = dic[@"emergencyNumber"];
        emergencyContacts = dic[@"emergencyContacts"];
        hasRecording      = ([dic[@"hasRecording"] isEqualToString:@"YES"]) ? YES : NO;
        
        //Screen3 vars
        socialStatus = dic[@"socialStatus"];
        fbAuth       = dic[@"fbAuth"];
        twitterAuth  = dic[@"twitterAuth"];
        linkedinAuth = dic[@"linkedinAuth"];

        
        //Screen3 vars
        email           = dic[@"email"];
        password        = dic[@"password"];
        respondingEmail = dic[@"respondingEmail"];
        
    }
    
    //NSLog(@"dic: %@", dic);
}
-(void)initWithDefValues
{
    //Settings
    uniqueId = [self getUniqueId];
    untechablePath = [self getNewUntechablePath];
    
    //Screen1
    timezoneOffset  = [commonFunctions getTimeZoneOffset];
    spendingTimeTxt = @"";
    startDate = [commonFunctions nsDateToTimeStampStr: [[NSDate date] dateByAddingTimeInterval:(60*60)] ];  //current time +60mint
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
    twitterAuth  = @"";
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

/*
 * Here we get the dictionary of saved untechable
 */
- (NSMutableDictionary *)getUntechable:(int)count
{
    NSMutableDictionary *retDic;
	NSString *userPath = [self getUserPath];
    
    
    //List of folder names create for this userid
    NSArray *UntechablesList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:userPath error:nil];
    //sort list
    NSArray *sortedList = [UntechablesList sortedArrayUsingFunction:compareDesc context:NULL];
    
    NSString *uniqueId_temp,*untechablePath_temp;
    
    for(int i = 0 ; i < sortedList.count ;i++)
    {
        uniqueId_temp = sortedList[i];
        untechablePath_temp = [NSString stringWithFormat:@"%@/%@",userPath,uniqueId_temp];

        if ( count == i ) {
            retDic =   [[NSMutableDictionary alloc] init];
            
            //Checking For Integer Dir Names Only
            if ([[NSScanner scannerWithString:uniqueId_temp] scanInt:nil]) {
                NSString *piecesF =[untechablePath_temp stringByAppendingString:[NSString stringWithFormat:@"/%@", PIECES_FILE]];
                retDic = [[NSMutableDictionary alloc] initWithContentsOfFile:piecesF];
                [retDic setValue:uniqueId_temp forKey:@"uniqueId"];
                [retDic setValue:untechablePath_temp forKey:@"untechablePath"];
                //[retDic setValue:[NSString stringWithFormat:@"%@/%@%@", untechablePath_temp,uniqueId_temp,REC_FORMATE] forKey:@"recFileURL"];
                
            }
            break;
        }
    }
    
    //NSLog(@"in fn getUntechable retDic: %@",retDic);
    
    return retDic;
}
@end