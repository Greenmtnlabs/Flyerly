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

@interface Untechable : NSObject{
    
}

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

//0-Phone permissions vars
@property (nonatomic, assign) BOOL hasFbPermission, hasTwitterPermission, hasLinkedinPermission;


//1-vars for screen1
@property (strong, nonatomic) NSString *spendingTimeTxt, *startDate, *endDate;
@property (nonatomic, assign) BOOL hasEndDate;



//2-vars for screen2
@property (strong, nonatomic)  NSString *forwardingNumber, *emergencyNumbers;
@property (strong, nonatomic)  NSMutableDictionary *emergencyContacts;


-(void)initObj;
-(NSDate *)stringToDate:(NSString *)inputStrFormate dateString:(NSString *)dateString;
-(void)printNavigation:navigationControllerPointer;
-(void)goBack:navigationControllerPointer;
@end
