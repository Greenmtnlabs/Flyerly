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



@implementation CommonFunctions


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


//[commonFunctions showAlert:@"Please select any contact to invite !" message:@""];
-(void)showAlert:(NSString *)title message:(NSString *)message{
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
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:&writeError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"JSON Output: %@", jsonString);
    return jsonString;
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
    return [NSDate dateWithTimeIntervalSince1970:[timeStamp floatValue]];
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

@end