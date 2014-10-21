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
@synthesize dic, piecesFile, userId, uniqueId, untechablePath, dateFormatter;

//0-Phone permissions vars
@synthesize hasFbPermission, hasTwitterPermission, hasLinkedinPermission;

//1-vars for screen1
@synthesize spendingTimeTxt, startDate, endDate, hasEndDate;

//2-vars for screen2
@synthesize forwardingNumber, emergencyContacts, emergencyNumbers,recPath;


-(void)initObj{
    self.hasFbPermission          = NO;
    self.hasTwitterPermission     = NO;
    self.hasLinkedinPermission    = NO;

    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:DATE_FORMATE_1];
    //[self.dateFormatter setDateStyle:NSDateFormatterShortStyle];    // show short-style date format
    //[self.dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
}

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
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[navigationControllerPointer viewControllers]];
    NSLog(@"NSMutableArray *viewControllers = %@", viewControllers);
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
 *Here we Getting Path of new Untechable
 */
-(NSString *)getNewUntechablePath
{
    
    //PFUser *user = [PFUser currentUser];
    //NSString *username = [user objectForKey:@"username"]

    NSError *error;

	NSString *userPath = [self getUserPath];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:userPath isDirectory:NULL])
        [[NSFileManager defaultManager] createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSString *retUntechablePath = [userPath stringByAppendingString:[NSString stringWithFormat:@"/%@", uniqueId]];
    
    return retUntechablePath;
}


-(NSURL *)getEventDirectoryUrl
{
    NSURL *outputFileURL;
    NSMutableDictionary *_1Untechable = [self getUntechable:0];
    if( YES && _1Untechable != nil){

        outputFileURL = [NSURL fileURLWithPath:[_1Untechable objectForKey:@"recFileURL"]];
    }
    else {
    
        NSString *dirName = untechablePath;
        
        BOOL isDir;
        NSFileManager *fm = [NSFileManager defaultManager];
        if(![fm fileExistsAtPath:dirName isDirectory:&isDir])
        {
            if([fm createDirectoryAtPath:dirName withIntermediateDirectories:YES attributes:nil error:nil]){
                NSLog(@"Directory Created");
               [self addEditDicForUntechable:ADD_UNTECHABLE];
            }
            else{
                NSLog(@"Directory Creation Failed");
            }
        }
        else {
            NSLog(@"Directory Already Exist");
           [self addEditDicForUntechable:EDIT_UNTECHABLE];
        }
        
        
        
        
        NSString *fileName = [NSString stringWithFormat:@"%@%@", uniqueId, REC_FORMATE];

        // Set the audio file
        NSArray *pathComponents = [NSArray arrayWithObjects:
                                   untechablePath,
                                   fileName,
                                   nil];
        outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    }
    return outputFileURL;
}


-(void)addEditDicForUntechable:(NSString *)addEdit{
    
    if( [addEdit isEqualToString:ADD_UNTECHABLE] ) {
        
        piecesFile = [untechablePath stringByAppendingPathComponent:@"/untechable.pieces"];
        
        
        dic = [[NSMutableDictionary alloc] init];

        
        //Create Dictionary for this untechable
        NSMutableDictionary *imageDetailDictionary = [[NSMutableDictionary alloc] init];
        imageDetailDictionary[@"userId"] = userId;
        imageDetailDictionary[@"spendingTimeTxt"] = spendingTimeTxt;
        imageDetailDictionary[@"startDate"] = startDate;
        imageDetailDictionary[@"endDate"] = endDate;
        imageDetailDictionary[@"hasEndDate"] = hasEndDate ? @"YES" : @"NO";
        
        imageDetailDictionary[@"forwardingNumber"] = forwardingNumber;
        imageDetailDictionary[@"emergencyNumbers"] = emergencyNumbers;
        imageDetailDictionary[@"emergencyContacts"] = emergencyContacts;
        
        [dic setValue:imageDetailDictionary forKey:@"dic"];
        
        //Here we write the dictionary of .peices files
        [dic writeToFile:piecesFile atomically:YES];
        
        
        NSLog(@"%@",[dic objectForKey:@"dic"]);
        
        NSLog(@"%@",[dic objectForKey:@"dic"]);
        

    }
    else if( [addEdit isEqualToString:EDIT_UNTECHABLE] ) {
        piecesFile = [untechablePath stringByAppendingString:[NSString stringWithFormat:@"/untechable.pieces"]];
        dic = [[NSMutableDictionary alloc] initWithContentsOfFile:piecesFile];

    }
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
 * Here we Getting flyer directories which name are timestamp
 * return
 *      Decending Sorted Array
 */
- (NSMutableDictionary *)getUntechable:(int)count{
    
    NSMutableDictionary *retDic;

	NSString *userPath = [self getUserPath];
    
    
    //List of folder names create for this userid
    NSArray *UntechablesList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:userPath error:nil];
    
    NSArray *sortedFlyersList = [UntechablesList sortedArrayUsingFunction:compareDesc context:NULL];
    
    NSString *folderName,*folderPath;
   // NSMutableArray *recentFlyers = [[NSMutableArray alloc] init];
    
    
    for(int i = 0 ; i < sortedFlyersList.count ;i++)
    {
        folderName = sortedFlyersList[i];
        folderPath = [NSString stringWithFormat:@"%@/%@",userPath,folderName];

        if ( count == i ) {
            retDic =   [[NSMutableDictionary alloc] init];
            
            //Checking For Integer Dir Names Only
            if ([[NSScanner scannerWithString:folderName] scanInt:nil]) {
                NSString *piecesF =[folderPath stringByAppendingString:[NSString stringWithFormat:@"/untechable.pieces"]];
                retDic = [[NSMutableDictionary alloc] initWithContentsOfFile:piecesF];
                [retDic setValue:folderName forKey:@"folderName"];
                [retDic setValue:folderPath forKey:@"folderPath"];
                [retDic setValue:[NSString stringWithFormat:@"%@/%@%@", folderPath,folderName,REC_FORMATE] forKey:@"recFileURL"];
                
            }
            
            NSLog(@"lastFileName: %@",folderName);

            break;
        }
        
    }
    
    return retDic;
}


@end