//
//  UntechableClass.h
//  Untechable
//
//  Created by RIKSOF Developer on 23/sep/2014
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface CommonFunctions: NSObject{
    
}

-(void)showAlert:(NSString *)title message:(NSString *)message;
-(NSString *)convertDicIntoJsonString:(NSMutableDictionary *)value;
-(NSString *)convertCCMArrayIntoJsonString:(NSMutableArray *)value;
-(NSMutableArray *)convertJsonStringIntoCCMArray:(NSString *)customizedContactsString;
-(NSMutableDictionary *)convertJsonStringIntoDictinoary:(NSString *)value;
-(NSString *)getTimeZoneOffset;
-(NSString *)convertNSDateToTimestamp:(NSDate *) nsDate;
-(NSDate *)convertTimestampToNSDate:(NSString *)timestamp;

-(NSString *)convertTimestampToAppDate:(NSString *)timestamp;
- (NSString *)convertTimestampToAppDateTime:(NSString *)timeStam;

- (BOOL)isEndDateGreaterThanStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

-(UIImageView *) navigationGetTitleView;
-(NSDate *)getDate:(NSString *)callFor;
//fb988650031150166

#pragma mark -  Set number formating functions
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
-(NSString*)formatNumber:(NSString*)mobileNumber;
-(int)getLength:(NSString*)mobileNumber;

-(NSString *)standarizePhoneNumber:(NSString *)phoneNumber;

-(BOOL)isFacebookLoggedIn:(NSString *)fbAuthExpiryTs;

-(NSMutableArray *)countCallAndSms:(NSMutableArray *)customizedContactsForCurrentSession breakIfFound:(BOOL)breakIfFound;
-(BOOL)haveCallOrSms:(NSMutableArray *)customizedContactsForCurrentSession;

-(void)delCallAndSmsStatus:(NSMutableArray *)customizedContactsForCurrentSession;
@end