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
#import "CommonFunctions.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SocialNetworksStatusModal.h"

@interface Untechable : NSObject {
    
}


//Settings
@property (strong, nonatomic) CommonFunctions *commonFunctions;
@property (strong, nonatomic) SocialNetworksStatusModal *socialNetworksStatusModal;
@property (strong, readonly)  NSMutableDictionary *dic;
@property (nonatomic, assign) BOOL paid;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *eventId, *rUId;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, assign) BOOL savedOnServer;
@property (nonatomic, assign) BOOL hasFinished;

// SetupGuide Screen 1
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userPhoneNumber;
@property (strong, nonatomic) NSString *timezoneOffset, *spendingTimeTxt, *startDate, *endDate;
@property (nonatomic, assign) BOOL hasEndDate;

// SetupGuide Screen2
@property (strong, nonatomic) NSString *customizedContacts;
@property (strong, nonatomic) NSString *twillioNumber, *location;
@property (strong, nonatomic) NSMutableArray *customizedContactsForCurrentSession;

// SetupGuide Screen3
@property (strong, nonatomic) NSString *socialStatus, *fbAuth, *fbAuthExpiryTs, *twitterAuth, *twOAuthTokenSecret, *linkedinAuth;

// SetupGuide Screen4
@property (strong, nonatomic) NSString *email, *password, *respondingEmail, *acType, *iSsl, *oSsl, *imsHostName, *imsPort,
                                       *omsHostName, *omsPort;

- (id)initWithCommonFunctions;
-(void)goBack:navigationControllerPointer;
-(NSString *)generateUniqueId;
-(void)addOrUpdateInModel:(NSString *)command dictionary:(NSMutableDictionary *)dictionary;
-(BOOL)isUntechableStarted;
-(BOOL)isUntechableExpired;
-(void)sendToApiAfterTask:(void(^)(BOOL,NSString *))callBack;
-(void)addOrUpdateInDatabase;
-(void)resetCustomizedContactsForCurrentSession;
-(BOOL)canSkipEmailSetting;

-(NSString *) calculateHoursDays:(NSString *) startTime endTime:(NSString *)endTime;
-(void)deleteUntechable:(NSString *)dbRowId callBack:(void(^)(bool))callBack;
@end