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
- (NSDate *)convertTimestampToNSDate:(NSString *)timestamp {
    return [NSDate dateWithTimeIntervalSince1970:[timestamp integerValue]];
}

- (NSString *)convertTimestampToAppDateTime:(NSString *)timestamp {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_FORMATE_TIME];
    
    NSDate *newDate  =   [self convertTimestampToNSDate:timestamp];
    NSString *newDateStr    =   [dateFormatter stringFromDate:newDate];
    return newDateStr;
}


- (NSString *)convertTimestampToAppDate:(NSString *)timestamp {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_FORMATE_DATE];
    
    NSDate *newDate  =   [self convertTimestampToNSDate:timestamp];
    NSString *newDateStr    =   [dateFormatter stringFromDate:newDate];
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

#pragma mark -  Number formatting functions
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

-(NSString *)standarizePhoneNumber:(NSString *)phoneNumber {
    if([phoneNumber isEqualToString:@""] == NO){
        NSArray *stringComponents = [NSArray arrayWithObjects:[phoneNumber substringWithRange:NSMakeRange(0, 2)],
                                     [phoneNumber substringWithRange:NSMakeRange(2, 3)],
                                     [phoneNumber substringWithRange:NSMakeRange(5, 3)],
                                     [phoneNumber substringWithRange:NSMakeRange(8, [phoneNumber length]-8)], nil];
        
        NSString *standarizedPhoneNumber = [NSString stringWithFormat:@"%@ (%@) %@-%@", [stringComponents objectAtIndex:0], [stringComponents objectAtIndex:1], [stringComponents objectAtIndex:2],[stringComponents objectAtIndex:3]];
        
        return standarizedPhoneNumber;
    } else{
       return phoneNumber;
    }
}

#pragma mark -  Fb functions
/** 
 * @parm: fbAuthExpiryTs is Facebook token expiry date( timestamp string )
 * @return: BOOL (whether Facebook token is expired or not)
 * Shows fb button active when fb token expiry date is greater than current date.
 */
-(BOOL)isFacebookLoggedIn:(NSString *)fbAuthExpiryTs{
    BOOL active = NO;
    if( [fbAuthExpiryTs isEqualToString:@""] == NO ){
        NSDate* startDate = [NSDate date];
        NSDate* endDate = [self convertTimestampToNSDate:fbAuthExpiryTs];
        active   = [self isEndDateGreaterThanStartDate:startDate endDate:endDate];
    }
    return active;
}

/*
 * This method checks if there are any Email, SMS and Call
 * @params:
 *      customizedContactsForCurrentSession: NSMutableArray
 * @return:
 *      array: NSMutableArray
 */
-(NSMutableArray *)checkCallSMSEmail:(NSMutableArray *)customizedContactsForCurrentSession{
    
    BOOL email = NO;
    BOOL call = NO;
    BOOL sms = NO;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for(int i=0; i<customizedContactsForCurrentSession.count; i++){
        ContactsCustomizedModal *tempModal = [customizedContactsForCurrentSession objectAtIndex:i];

        for(int j=0; j<tempModal.allEmails.count; j++){
            if(!email){
                email = ([[tempModal.allEmails[j] objectAtIndex:1] isEqualToString:@"1"]);
                break;
            }
        }
        
        for(int j=0; j<tempModal.allPhoneNumbers.count; j++){
            
            if(!call){
                call = ([[tempModal.allPhoneNumbers[j] objectAtIndex:3] isEqualToString:@"1"]);
            }
            if(!sms){
                sms = ([[tempModal.allPhoneNumbers[j] objectAtIndex:2] isEqualToString:@"1"]);
            }
            if(call && sms){
                break;
            }
        }
        
        
        if(email && call && sms){
            break;
        }
    }
    
    array[0] = email ? @"YES" : @"NO";
    array[1] = call ? @"YES" : @"NO";
    array[2] = sms ? @"YES" : @"NO";
    
    return  array;

}

/**
 * Count sms/call
 * @param customizedContactsForCurrentSession
 *           customizedContactsForCurrentSession: Array of contacts
 * @param breakIfFound
 *           dont count all, just return if any one found
 *
 * @return
 *           Array of [callsCount, smsCount ]
 */

-(NSMutableArray *)countCallAndSms:(NSMutableArray *)customizedContactsForCurrentSession breakIfFound:(BOOL)breakIfFound{
    NSMutableArray *callAndSmsStatus = [NSMutableArray arrayWithArray:@[@0, @0 ]];
    for(int i=0; i<customizedContactsForCurrentSession.count; i++){
        ContactsCustomizedModal *tempModal = [customizedContactsForCurrentSession objectAtIndex:i];
        BOOL needToSendCall = NO;
        BOOL needToSendSms = NO;
        for(int j=0; j<tempModal.allPhoneNumbers.count; j++){
            needToSendCall = ([[tempModal.allPhoneNumbers[j] objectAtIndex:2] isEqualToString:@"1"]);
            needToSendSms = ([[tempModal.allPhoneNumbers[j] objectAtIndex:3] isEqualToString:@"1"]);
            
            if( needToSendCall )
                callAndSmsStatus[0] = [[NSNumber alloc]initWithInt:([callAndSmsStatus[0] integerValue]+1)];

            if( needToSendSms )
                callAndSmsStatus[1] = [[NSNumber alloc]initWithInt:([callAndSmsStatus[1] integerValue]+1)];
            
            if( (needToSendCall || needToSendSms) && breakIfFound ){
                break;
            }
            
        }
        
        if( (needToSendCall || needToSendSms) && breakIfFound ){
            break;
        }
    }
    return callAndSmsStatus;
}


/**
 * Check user want to notify his contact using sms and call service
 */
-(BOOL)haveCallOrSms:(NSMutableArray *)customizedContactsForCurrentSession{
    BOOL have = NO;
    NSMutableArray *callAndSmsStatus = [self countCallAndSms:customizedContactsForCurrentSession breakIfFound:YES];
    if( [callAndSmsStatus[0] integerValue] > 0 || [callAndSmsStatus[1] integerValue] > 0){
        have = YES;
    }
    return have;
}

/**
 * For creating free untechable, delete all calls and phone numbers status
 */
-(void)delCallAndSmsStatus:(NSMutableArray *)customizedContactsForCurrentSession{
    
    for(int i=(customizedContactsForCurrentSession.count-1); i >= 0; i--){
        ContactsCustomizedModal *tempModal = [customizedContactsForCurrentSession objectAtIndex:i];
        for(int j=(tempModal.allPhoneNumbers.count-1); j>=0; j--){
            [tempModal.allPhoneNumbers removeObjectAtIndex:j];
        }
        
        if( tempModal.allEmails.count > 0 ){
            [customizedContactsForCurrentSession replaceObjectAtIndex:i withObject:tempModal];
        } else{
            [customizedContactsForCurrentSession removeObjectAtIndex:i];
        }
    }
}
@end