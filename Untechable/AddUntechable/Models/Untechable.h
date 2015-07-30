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
#import "CommonFunctions.h"
#import "UntechableModel.h"
#import <FacebookSDK/FacebookSDK.h>

@interface Untechable : NSObject {
    
}

// new Untechable model
@property (strong, nonatomic) UntechableModel *untechableModel;

//Array of selected contacts for Untechable
@property (strong, nonatomic) NSMutableArray *selectedContacts;


//Settings
@property (strong, nonatomic) CommonFunctions *commonFunctions;
@property (strong, readonly)  NSMutableDictionary *dic;
@property (strong, nonatomic) NSString *piecesFile;
@property (nonatomic, assign) BOOL paid;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *uniqueId;
@property (strong, nonatomic) NSString *eventId;
@property (strong, nonatomic) NSString *untechablePath;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, assign) BOOL savedOnServer;
@property (nonatomic, assign) BOOL hasFinished;

//SetupGuide Screen 1
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userPhoneNumber;

//Screen1
@property (strong, nonatomic) NSString *timezoneOffset, *spendingTimeTxt, *startDate, *endDate;
@property (nonatomic, assign) BOOL hasEndDate;



//Screen2
//@property (strong, nonatomic) NSMutableArray *customizedContacts;
@property (strong, nonatomic) NSString *customizedContacts;
//@property (strong, nonatomic) NSString *twillioNumber, *emergencyNumber, *location;
@property (strong, nonatomic) NSString *twillioNumber, *location;
//@property (strong, nonatomic) NSMutableDictionary *emergencyContacts;
//@property (nonatomic, assign) BOOL hasRecording;
@property (strong, nonatomic) NSMutableArray *customizedContactsForCurrentSession;

//Screen3
@property (strong, nonatomic) NSString *socialStatus, *fbAuth, *fbAuthExpiryTs, *twitterAuth, *twOAuthTokenSecret, *linkedinAuth;

//Screen4
@property (strong, nonatomic) NSString *email, *password, *respondingEmail, *acType, *iSsl, *oSsl, *imsHostName, *imsPort,
                                       *omsHostName, *omsPort;

- (id)initAll;

-(NSDate *)stringToDate:(NSString *)inputStrFormate dateString:(NSString *)dateString;
-(void)goBack:navigationControllerPointer;


-(NSString *)getNewUntechablePath;
-(NSString *)getRecFilePath;
-(NSString *)getRecFileName;
-(NSString *)getUniqueId;
-(BOOL)initUntechableDirectory;
-(void)setOrSaveVars:(NSString *)setOrSAve;
-(void)initWithDefValues;
-(NSString *)timestampStrToAppDate:(NSString *)timeStamp;

-(BOOL)isUntechableStarted;
-(BOOL)isUntechableExpired;

#pragma mark -  Facebook functions
- (void)fbSessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
-(void)fbFlushFbData;

#pragma mark -  Twitter functions
-(void)twFlushData;
-(void)twUpdateData:(NSString *)oAuthToken oAuthTokenSecret:(NSString * )oAuthTokenSecret;

#pragma mark -  LinkedIn functions
-(void)linkedInFlushData;
-(void)linkedInUpdateData:(NSString *)linkedInAccessToken;

#pragma mark - current Date method
-(NSDate *)getCurrentDate;

-(void)sendToApiAfterTask:(void(^)(BOOL,NSString *))callBack;
-(void)setDefaultUntechable:(int)timeDuration timeInString:(NSString *)timeInString;
@end