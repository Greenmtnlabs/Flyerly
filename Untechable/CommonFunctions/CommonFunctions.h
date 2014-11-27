//
//  UntechableClass.h
//  Untechable
//
//  Created by Abdul Rauf on 23/sep/2014
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface CommonFunctions: NSObject{
    
}

-(void)sortDic:inputDic;

-(void)deleteKeyFromDic:dic delKeyAtIndex:(int)rowNumber;
-(void)showAlert:(NSString *)title message:(NSString *)message;
-(NSString *)convertDicIntoJsonString:(NSMutableDictionary *)value;
-(NSString *)getTimeZoneOffset;
-(NSString *)nsDateToTimeStampStr:(NSDate *)inpDate;
-(NSDate *)timestampStrToNsDate:(NSString *)timeStamp;
-(NSString *)timestampStrToAppDate:(NSString *)timeStamp;
- (BOOL)date1IsSmallerThenDate2:(NSDate *)date1 date2:(NSDate *)date2;
- ( NSMutableDictionary * )getAnyInCompleteUntechable;
-(UIImageView *) navigationGetTitleView;
-(NSDate *)getDate:(NSString *)callFor;
//fb988650031150166

#pragma mark -  Set number formating functions
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
-(NSString*)formatNumber:(NSString*)mobileNumber;
-(int)getLength:(NSString*)mobileNumber;

-(NSString *)formateStringIntoPhoneNumber:(NSString *)unformatted;
@end