 //
//  UntechableClass.m
//  Untechable
//
//  Created by RIKSOF Developer on 23/sep/2014
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//
//

#import "CommonFunctions.h"
#import "Common.h"
#import "ContactsCustomizedModal.h"

@implementation CommonFunctions


/**
 * A common function for showing alert
 * Example code: [commonFunctions showAlert:@"Please select any contact to invite !" message:@""];
 */
-(void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

/**
 * Conver dictionary into a json strong 
 * @param: NSMutableDictionary
 * @return: NSString
 */
-(NSString *)convertDicIntoJsonString:(NSMutableDictionary *)value {
    NSError *writeError = nil;
    NSString *jsonString;
    
    if (value.count > 0) {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:&writeError];
    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    }else {
        jsonString = @"";
    }
    return jsonString;
}

-(NSMutableArray *)convertJsonStringIntoCCMArray:(NSString *)customizedContactsString {
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

-(NSString *)convertCCMArrayIntoJsonString:(NSMutableArray *)value_ {
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

-(NSMutableDictionary *)convertJsonStringIntoDictinoary:(NSString *)value {

    NSData* data = [value dataUsingEncoding:NSUTF8StringEncoding];

    NSError *e = nil;
    NSMutableDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
    
    if (!jsonArray) {
        jsonArray = [[NSMutableDictionary alloc] init];
    }
    return jsonArray;
}

-(NSString *)getTimeZoneOffset {
    NSString *timezoneoffset3 = [NSString stringWithFormat:@"%f",([[NSTimeZone systemTimeZone] secondsFromGMT] / 3600.0)];
    
    return timezoneoffset3;
}

- (NSString *)convertNSDateToTimestamp:(NSDate *)nsDate {
    return [NSString stringWithFormat:@"%.0f",[nsDate timeIntervalSince1970]];
}
- (NSDate *)timestampStrToNsDate:(NSString *)timeStamp {
    return [NSDate dateWithTimeIntervalSince1970:[timeStamp integerValue]];
}

- (NSString *)timestampStringToAppDate:(NSString *)timeStamp {
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:DATE_FORMATE_DATE];
    
    NSDate *newDate  =   [self timestampStrToNsDate:timeStamp];
    NSString *newDateStr    =   [dateFormatter1 stringFromDate:newDate];
    return newDateStr;
}

- (NSString *)timestampStringToAppDateTime:(NSString *)timeStamp {
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:DATE_FORMATE_TIME];
    
    NSDate *newDate  =   [self timestampStrToNsDate:timeStamp];
    NSString *newDateStr    =   [dateFormatter1 stringFromDate:newDate];
    return newDateStr;
}


- (NSString *)timestampStrToAppDate:(NSString *)timeStamp {
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:DATE_FORMATE_1];
    
    NSDate *newDate  =   [self timestampStrToNsDate:timeStamp];
    NSString *newDateStr    =   [dateFormatter1 stringFromDate:newDate];
    return newDateStr;
}

-(UIImageView *) navigationGetTitleView {
    return  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
}

- (BOOL)isEndDateGreaterThanStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    
    NSTimeInterval interval = [startDate timeIntervalSinceDate:endDate];
    double secondsInMinute = 60;
    NSInteger secondsBetweenDates = interval / secondsInMinute;
    
    if (secondsBetweenDates == 0)
        return YES;
    else if (secondsBetweenDates < 0)
        return YES;
    else
        return NO;
}

-(NSDate *)getDate:(NSString *)callFor {
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    int length = [self getLength:textField.text];
    
    if(length == 10){
        if(range.length == 0)
            return NO;
    }
    
    if(length == 3) {
        NSString *num = [self formatNumber:textField.text];
        textField.text = [NSString stringWithFormat:@"(%@) ",num];
        if(range.length > 0)
            textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
    }
    else if(length == 6){
        NSString *num = [self formatNumber:textField.text];
        textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
        if(range.length > 0)
            textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
    }
    
    return YES;
}

-(NSString*)formatNumber:(NSString*)mobileNumber {
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = (int)[mobileNumber length];
    if(length > 10) {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
    }
    return mobileNumber;
}


-(int)getLength:(NSString*)mobileNumber {
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = (int)[mobileNumber length];
    
    return length;
}

-(NSString *)formateStringIntoPhoneNumber:(NSString *)unformatted {
    if([unformatted isEqualToString:@""] == NO){
        NSArray *stringComponents = [NSArray arrayWithObjects:[unformatted substringWithRange:NSMakeRange(0, 2)],
                                     [unformatted substringWithRange:NSMakeRange(2, 3)],
                                     [unformatted substringWithRange:NSMakeRange(5, 3)],
                                     [unformatted substringWithRange:NSMakeRange(8, [unformatted length]-8)], nil];
        
        NSString *formattedString = [NSString stringWithFormat:@"%@ (%@) %@-%@", [stringComponents objectAtIndex:0], [stringComponents objectAtIndex:1], [stringComponents objectAtIndex:2],[stringComponents objectAtIndex:3]];
        
        return formattedString;
    } else{
       return unformatted;
    }
}

#pragma mark -  Fb functions
/** 
 * @parm: fbAuthExpiryTs is facebook token expiry date( string of timestamp )
 * @return: facebook token is expired or not
 * Active fb button when fb toke expiry date is greater then current date.
 */
-(BOOL)fbBtnStatus:(NSString *)fbAuthExpiryTs{
    BOOL active = NO;
    if( [fbAuthExpiryTs isEqualToString:@""] == NO ){
        NSDate* startDate = [NSDate date];
        NSDate* endDate = [self timestampStrToNsDate:fbAuthExpiryTs];
        active   = [self isEndDateGreaterThanStartDate:startDate endDate:endDate];
    }
    return active;
}
@end