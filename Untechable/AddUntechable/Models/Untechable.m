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
@synthesize dic, piecesFile, userId, uniqueId, eventId, untechablePath, dateFormatter;

//0-Phone permissions vars
@synthesize hasFbPermission, hasTwitterPermission, hasLinkedinPermission;

//1-vars for screen1
@synthesize spendingTimeTxt, startDate, endDate, hasEndDate;

//2-vars for screen2
@synthesize forwardingNumber, location, emergencyContacts, emergencyNumbers, hasRecording;

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
        dic[@"hasFbPermission"] = hasFbPermission ? @"YES" : @"NO";
        dic[@"hasTwitterPermission"] = hasTwitterPermission ? @"YES" : @"NO";
        dic[@"hasLinkedinPermission"] = hasLinkedinPermission ? @"YES" : @"NO";
        
        dic[@"spendingTimeTxt"] = spendingTimeTxt;
        dic[@"startDate"] = startDate;
        dic[@"endDate"] = endDate;
        dic[@"hasEndDate"] = hasEndDate ? @"YES" : @"NO";
        

        dic[@"forwardingNumber"] = forwardingNumber;
        dic[@"location"] = location;
        dic[@"emergencyNumbers"] = emergencyNumbers;
        dic[@"emergencyContacts"] = emergencyContacts;
        dic[@"hasRecording"] = hasRecording ? @"YES" : @"NO";

        
        //Here we write the dictionary of .peices files
        [dic writeToFile:piecesFile atomically:YES];

    }
    else if( [setOrSAve isEqualToString:SET] ) {
        
        piecesFile = [untechablePath stringByAppendingString:[NSString stringWithFormat:@"/%@", PIECES_FILE]];
        dic = [[NSMutableDictionary alloc] initWithContentsOfFile:piecesFile];
        
        
        //Settings
        userId = dic[@"userId"];
        uniqueId = dic[@"uniqueId"];
        eventId =   dic[@"eventId"];
        untechablePath = dic[@"untechablePath"];
        hasFbPermission       = ([dic[@"hasFbPermission"] isEqualToString:@"YES"]) ? YES : NO;
        hasTwitterPermission  = ([dic[@"hasTwitterPermission"] isEqualToString:@"YES"]) ? YES : NO;
        hasLinkedinPermission = ([dic[@"hasLinkedinPermission"] isEqualToString:@"YES"]) ? YES : NO;
        
        
        //1-vars for screen1
        spendingTimeTxt =   dic[@"spendingTimeTxt"];
        hasEndDate = ([dic[@"hasEndDate"] isEqualToString:@"YES"]) ? YES : NO;
        
        //2-vars for screen2
        forwardingNumber  = dic[@"forwardingNumber"];
        location   = dic[@"location"];
        emergencyNumbers  = dic[@"emergencyNumbers"];
        emergencyContacts = dic[@"emergencyContacts"];
        hasRecording = ([dic[@"hasRecording"] isEqualToString:@"YES"]) ? YES : NO;
    }
    
    //NSLog(@"dic: %@", dic);
}
-(void)initWithDefValues
{
    //Settings
    uniqueId = [self getUniqueId];
    eventId = @"0";
    untechablePath = [self getNewUntechablePath];
    
    hasFbPermission          = NO;
    hasTwitterPermission     = NO;
    hasLinkedinPermission    = NO;
    
    
    //1-vars for screen1
    spendingTimeTxt = @"";
    /*
    now1 = [[NSDate date] dateByAddingTimeInterval:(60*2)]; //current time + 2mint
    now2 = [[NSDate date] dateByAddingTimeInterval:(60*120)]; //current time + 2hr
    
    startDate = [dateFormatter stringFromDate:now1];
    endDate   = [dateFormatter stringFromDate:now2];
    */
    
    hasEndDate = YES;
    
    //2-vars for screen2
    forwardingNumber  = @"";
    location  = @"";
    emergencyNumbers  = @"";
    emergencyContacts = [[NSMutableDictionary alloc] init];
    hasRecording = NO;
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