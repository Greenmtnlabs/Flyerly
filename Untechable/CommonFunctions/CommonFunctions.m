 //
//  UntechableClass.m
//  Untechable
//
//  Created by Abdul Rauf on 23/sep/2014
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//
//

#import "CommonFunctions.h"
#import "Common.h"
#import "ContactsCustomizedModal.h"

@implementation CommonFunctions

NSString *currentEnteredUserName;
NSString *currentEnteredPhoneNumber;

-(void)sortDic:inputDic {
    NSMutableDictionary *sortedDic = [[NSMutableDictionary alloc] init];
    NSArray *sortedKeys = [[inputDic allKeys] sortedArrayUsingSelector: @selector(compare:)];
    
    for (NSString *key in sortedKeys) {
        [sortedDic setObject:[inputDic objectForKey: key]  forKey:key];
    }
    
    inputDic = sortedDic;
    
    //return sortedDic;
}

-(void)deleteKeyFromDic:dic delKeyAtIndex:(int)rowNumber {
    NSArray *arrayOfKeys = [[dic allKeys] sortedArrayUsingSelector: @selector(compare:)];
    NSString *key   = [arrayOfKeys objectAtIndex:rowNumber];
    
    //NSLog(@"dic before delete rowNumber: %i, key: %@, dic: %@", rowNumber, key, dic);
    
    [dic removeObjectForKey:key];

   // NSLog(@"dic after delete rowNumber: %i, key: %@, dic: %@", rowNumber, key, dic);

    //return dic;
}

/*
 * Here we get the dictionary of saved untechable
 */
- (NSMutableDictionary *)getUntechable:(int)count UserId:(NSString *)userId
{
    NSMutableDictionary *retDic = nil;
    NSString *userPath = [self getUserPath:userId];
    
    //List of folder names create for this userid
    NSArray *UntechablesList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:userPath error:nil];
    //sort list
    NSArray *sortedList = [UntechablesList sortedArrayUsingFunction:compareDesc_ context:NULL];
    
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
                NSData *data = [NSData dataWithContentsOfFile:piecesF];
                retDic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                //retDic = [[NSMutableDictionary alloc] initWithContentsOfFile:piecesF];
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

//[commonFunctions showAlert:@"Please select any contact to invite !" message:@""];
-(void)showAlert:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
-(NSString *)convertDicIntoJsonString:(NSMutableDictionary *)value
{
    NSError *writeError = nil;
    NSString *jsonString;
    if (value.count > 0) {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:&writeError];
    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"JSON Output: %@", jsonString);
    
    }else {
        jsonString = @"";
    }
    
    return jsonString;
}

-(NSMutableArray *)convertJsonStringIntoCCMArray:(NSString *)customizedContactsString
{
    NSMutableArray *savedCustomContacts = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *customizedContactsModals =  [self convertJsonStringIntoDictinoary:customizedContactsString];
    
    for(int i=0; i<[customizedContactsModals count]; i++) {
        
        NSMutableDictionary *curContactDetails = [[NSMutableDictionary alloc] init];
        curContactDetails = [customizedContactsModals objectForKey:[NSString stringWithFormat:@"%d",i]];
       
        ContactsCustomizedModal *curObj =  [[ContactsCustomizedModal alloc] init];
        curObj.contactName = [curContactDetails objectForKey:@"contactName"];
        curObj.allPhoneNumbers = [curContactDetails objectForKey:@"phoneNumbers"];
        curObj.allEmails = [curContactDetails objectForKey:@"emailAddresses"];
        curObj.customTextForContact = [curContactDetails objectForKey:@"customTextForContact"];
        
        [savedCustomContacts addObject:curObj];
    }
    
    return savedCustomContacts;
}

-(NSString *)convertCCMArrayIntoJsonString:(NSMutableArray *)value_
{
    NSMutableDictionary *customizedContactsArray = [[NSMutableDictionary alloc] init];
    for(int i=0;i<[value_ count]; i++) {
        
        NSMutableDictionary *curContactDetails = [[NSMutableDictionary alloc] init];
        ContactsCustomizedModal *curObj =  [value_ objectAtIndex:i];
        [curContactDetails setValue:curObj.contactName forKey:@"contactName"];
        NSMutableArray *filterdPhoneNumbers = [[NSMutableArray alloc] init];
        for(int i=0; i<curObj.allPhoneNumbers.count; i++){
            if( curObj.allPhoneNumbers[i][2] || curObj.allPhoneNumbers[i][3] )
            [filterdPhoneNumbers addObject:curObj.allPhoneNumbers[i]];
        }
        [curContactDetails setValue:filterdPhoneNumbers forKey:@"phoneNumbers"];
        
        [curContactDetails setValue:curObj.allEmails forKey:@"emailAddresses"];
        [curContactDetails setValue:curObj.customTextForContact forKey:@"customTextForContact"];
        [customizedContactsArray setValue:curContactDetails forKey:[NSString stringWithFormat:@"%i",i]];
        
    }
    
    return [self convertDicIntoJsonString:customizedContactsArray];
}

-(NSMutableDictionary *)convertJsonStringIntoDictinoary:(NSString *)value
{

    NSData* data = [value dataUsingEncoding:NSUTF8StringEncoding];

    NSError *e = nil;
    NSMutableDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
    
    if (!jsonArray) {
        NSLog(@"Error parsing JSON: %@", e);
        jsonArray = [[NSMutableDictionary alloc] init];
    } else {
        for(NSDictionary *item in jsonArray) {
            NSLog(@"Item: %@", item);
        }
    }
    
    return jsonArray;
    
    /*if ( [value isEqualToString:@""] ){
        return nil;
    }
    return [value componentsSeparatedByCharactersInSet:
            [NSCharacterSet characterSetWithCharactersInString:DEF_ARAY_SPLITER]
            ];*/
}

-(NSString *)getTimeZoneOffset
{
    NSString *timezoneoffset3 = [NSString stringWithFormat:@"%f",([[NSTimeZone systemTimeZone] secondsFromGMT] / 3600.0)];
    NSLog(@"timezoneoffset3 %@", timezoneoffset3);
    
    return timezoneoffset3;
}

- (NSString *)nsDateToTimeStampStr:(NSDate *)inpDate
{
    return [NSString stringWithFormat:@"%.0f",[inpDate timeIntervalSince1970]];
}
- (NSDate *)timestampStrToNsDate:(NSString *)timeStamp
{
    return [NSDate dateWithTimeIntervalSince1970:[timeStamp integerValue]];
}

- (NSString *)timestampStringToAppDate:(NSString *)timeStamp
{
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:DATE_FORMATE_DATE];
    
    NSDate *newDate  =   [self timestampStrToNsDate:timeStamp];
    NSString *newDateStr    =   [dateFormatter1 stringFromDate:newDate];
    NSLog(@"newDateStr: %@", newDateStr);
    return newDateStr;
}

- (NSString *)timestampStringToAppDateTime:(NSString *)timeStamp
{
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:DATE_FORMATE_TIME];
    
    NSDate *newDate  =   [self timestampStrToNsDate:timeStamp];
    NSString *newDateStr    =   [dateFormatter1 stringFromDate:newDate];
    NSLog(@"newDateStr: %@", newDateStr);
    return newDateStr;
}


- (NSString *)timestampStrToAppDate:(NSString *)timeStamp
{
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:DATE_FORMATE_1];
    
    NSDate *newDate  =   [self timestampStrToNsDate:timeStamp];
    NSString *newDateStr    =   [dateFormatter1 stringFromDate:newDate];
    NSLog(@"newDateStr: %@", newDateStr);
    return newDateStr;
}

-(UIImageView *) navigationGetTitleView
{
    /*
     titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
     titleLabel.backgroundColor = [UIColor clearColor];
     titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_FONT_SIZE];
     titleLabel.textAlignment = NSTextAlignmentCenter;
     titleLabel.textColor = defGreen;
     titleLabel.text = APP_NAME;
     self.navigationItem.titleView = titleLabel; //Center title ___________
     */
    return  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
}

/*
 *Here we sort Array in Desending order for Exact Render of Flyer
 * as last saved.
 */
NSInteger compareDesc_(id stringLeft, id stringRight, void *context) {
    
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
 * Here we get the dictionary of dictionaries of saved untechable
 */
- ( NSMutableArray * )getAllUntechables :(NSString *)userId
{
    
    NSMutableArray *totalUntechables = [[NSMutableArray alloc] init];
    NSMutableDictionary *retDic;
    NSString *userPath = [self getUserPath:userId];
    
    //List of folder names create for this userid
    NSArray *UntechablesList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:userPath error:nil];
    //sort list
    NSArray *sortedList = [UntechablesList sortedArrayUsingFunction:compareDesc_ context:NULL];
    
    NSString *uniqueId_temp,*untechablePath_temp;
    
    for(int i = 0 ; i < sortedList.count ;i++)
    {
        uniqueId_temp = sortedList[i];
        untechablePath_temp = [NSString stringWithFormat:@"%@/%@",userPath,uniqueId_temp];
        
        retDic =   [[NSMutableDictionary alloc] init];
        
        //Checking For Integer Dir Names Only
        if ([[NSScanner scannerWithString:uniqueId_temp] scanInt:nil]) {
            NSString *piecesF =[untechablePath_temp stringByAppendingString:[NSString stringWithFormat:@"/%@", PIECES_FILE]];
            NSData *data = [NSData dataWithContentsOfFile:piecesF];
            retDic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            //retDic = [[NSMutableDictionary alloc] initWithContentsOfFile:piecesF];
            [retDic setValue:uniqueId_temp forKey:@"uniqueId"];
            [retDic setValue:untechablePath_temp forKey:@"untechablePath"];
        }
        
        if ( [[retDic objectForKey:@"hasFinished"] boolValue] ){
            [totalUntechables addObject:retDic];
        }
    }
    return totalUntechables;
}

-(NSString *)getUserPath :userId
{
    //Getting Home Directory
    NSString *homeDirectoryPath = NSHomeDirectory();
    return [homeDirectoryPath stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@/Untechable",userId]];
}


/*
 * Here we get the dictionary of saved untechable
 */
- ( NSMutableDictionary * )getAnyInCompleteUntechable :(NSString *)userId
{
    NSMutableDictionary *retDic;
    NSString *userPath = [self getUserPath:userId];
    
    //List of folder names create for this userid
    NSArray *UntechablesList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:userPath error:nil];
    //sort list
    NSArray *sortedList = [UntechablesList sortedArrayUsingFunction:compareDesc_ context:NULL];
    
    NSString *uniqueId_temp,*untechablePath_temp;
    
    for(int i = 0 ; i < sortedList.count ;i++)
    {
        uniqueId_temp = sortedList[i];
        untechablePath_temp = [NSString stringWithFormat:@"%@/%@",userPath,uniqueId_temp];
        
        retDic =   [[NSMutableDictionary alloc] init];
        
        //Checking For Integer Dir Names Only
        if ([[NSScanner scannerWithString:uniqueId_temp] scanInt:nil]) {
            NSString *piecesF =[untechablePath_temp stringByAppendingString:[NSString stringWithFormat:@"/%@", PIECES_FILE]];
            NSData *data = [NSData dataWithContentsOfFile:piecesF];
            retDic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            //retDic = [[NSMutableDictionary alloc] initWithContentsOfFile:piecesF];
            [retDic setValue:uniqueId_temp forKey:@"uniqueId"];
            [retDic setValue:untechablePath_temp forKey:@"untechablePath"];
            
            if ( ![[retDic objectForKey:@"hasFinished"] boolValue] ){
                return retDic;
            }
            //[retDic setValue:[NSString stringWithFormat:@"%@/%@%@", untechablePath_temp,uniqueId_temp,REC_FORMATE] forKey:@"recFileURL"];
        }
    }
    return nil;
}

- (BOOL)date1IsSmallerThenDate2:(NSDate *)date1 date2:(NSDate *)date2
{
    NSTimeInterval distanceBetweenDates = [date1 timeIntervalSinceDate:date2];
    double secondsInMinute = 60;
    NSInteger secondsBetweenDates = distanceBetweenDates / secondsInMinute;
    
    if (secondsBetweenDates == 0)
        return YES;
    else if (secondsBetweenDates < 0)
        return YES;
    else
        return NO;
}

-(NSDate *)getDate:(NSString *)callFor
{
    NSDate *today = [NSDate date];
    
    if( [callFor isEqual:@"PAST_1_DAY"]){
        today = [today dateByAddingTimeInterval: -86400.0];
    }
    else if( [callFor isEqual:@"PAST_1_WEEK"]){
        today = [today dateByAddingTimeInterval: -1209600.0];
    }
    else if( [callFor isEqual:@"PAST_1_MONTH"]){
        today = [today dateByAddingTimeInterval: -5259487.66];
    }
    
    return today;
}

#pragma mark -  Set number formating functions
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    int length = [self getLength:textField.text];
    //NSLog(@"Length  =  %d ",length);
    
    if(length == 10)
    {
        if(range.length == 0)
            return NO;
    }
    
    if(length == 3)
    {
        NSString *num = [self formatNumber:textField.text];
        textField.text = [NSString stringWithFormat:@"(%@) ",num];
        if(range.length > 0)
            textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
    }
    else if(length == 6)
    {
        NSString *num = [self formatNumber:textField.text];
        //NSLog(@"%@",[num  substringToIndex:3]);
        //NSLog(@"%@",[num substringFromIndex:3]);
        textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
        if(range.length > 0)
            textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
    }
    
    return YES;
}

-(NSString*)formatNumber:(NSString*)mobileNumber
{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSLog(@"%@", mobileNumber);
    
    int length = [mobileNumber length];
    if(length > 10)
    {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
        NSLog(@"%@", mobileNumber);
        
    }
    
    
    return mobileNumber;
}


-(int)getLength:(NSString*)mobileNumber
{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = [mobileNumber length];
    
    return length;
}

-(NSString *)formateStringIntoPhoneNumber:(NSString *)unformatted
{
    if([unformatted isEqualToString:@""] == NO){
        NSArray *stringComponents = [NSArray arrayWithObjects:[unformatted substringWithRange:NSMakeRange(0, 2)],
                                     [unformatted substringWithRange:NSMakeRange(2, 3)],
                                     [unformatted substringWithRange:NSMakeRange(5, 3)],
                                     [unformatted substringWithRange:NSMakeRange(8, [unformatted length]-8)], nil];
        
        NSString *formattedString = [NSString stringWithFormat:@"%@ (%@) %@-%@", [stringComponents objectAtIndex:0], [stringComponents objectAtIndex:1], [stringComponents objectAtIndex:2],[stringComponents objectAtIndex:3]];
        NSLog(@"Formatted Phone Number: %@", formattedString);
        
        return formattedString;
    } else{
       return unformatted;
    }
}

#pragma mark UIView Changes base on Iphone Screen Sizes
-(void)setNavigationTopBarViewForScreens:(UIImageView *) topNavigationView {
    
    if( IS_IPHONE_4 || IS_IPHONE_5 ) {
        
        topNavigationView.frame = CGRectMake( 93, 77, 126, 28 );
    }
}

//Active fb button when fb toke expiry date is greater then current date.
-(BOOL)fbBtnStatus:(NSString *)fbAuthExpiryTs{
    NSDate* date1 = [NSDate date];
    NSDate* date2 = [self timestampStrToNsDate:fbAuthExpiryTs];
    BOOL active   = [self date1IsSmallerThenDate2:date1 date2:date2];
    return active;
}
@end