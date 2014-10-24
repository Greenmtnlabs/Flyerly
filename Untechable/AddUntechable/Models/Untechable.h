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


//Settings
@property (strong, readonly)  NSMutableDictionary *dic;
@property (strong, nonatomic) NSString *piecesFile;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *uniqueId;
@property (strong, nonatomic) NSString *eventId;
@property (strong, nonatomic) NSString *untechablePath;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

//Screen1
@property (strong, nonatomic) NSString *spendingTimeTxt, *startDate, *endDate;
@property (nonatomic, assign) BOOL hasEndDate;



//Screen2
@property (strong, nonatomic) NSString *forwardingNumber, *emergencyNumbers, *location;
@property (strong, nonatomic) NSMutableDictionary *emergencyContacts;
@property (nonatomic, assign) BOOL hasRecording;

//Screen3
@property (strong, nonatomic) NSString *socialStatus, *fbAuth, *twitterAuth, *linkedinAuth;

//Screen4
@property (strong, nonatomic) NSString *email, *password, *respondingEmail;


-(NSDate *)stringToDate:(NSString *)inputStrFormate dateString:(NSString *)dateString;
-(void)printNavigation:navigationControllerPointer;
-(void)goBack:navigationControllerPointer;


-(NSString *)getNewUntechablePath;
-(NSString *)getRecFilePath;
-(NSString *)getRecFileName;
-(NSString *)getUniqueId;
-(BOOL)initUntechableDirectory;
-(NSMutableDictionary *)getUntechable:(int)count;
-(void)setOrSaveVars:(NSString *)setOrSAve;
-(void)initWithDefValues;

@end