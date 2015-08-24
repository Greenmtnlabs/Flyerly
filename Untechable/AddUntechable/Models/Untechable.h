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

- (id)initWithCF;
-(void)goBack:navigationControllerPointer;
-(NSString *)getUniqueId;
-(void)setOrSaveVars:(NSString *)setOrSAve dic2:(NSMutableDictionary *)dic2;
-(BOOL)isUntechableStarted;
-(BOOL)isUntechableExpired;
-(void)sendToApiAfterTask:(void(^)(BOOL,NSString *))callBack;
-(void)saveOrUpdateInDb;
-(void)reSetCustomizedContactsInSession;
-(BOOL)canSkipEmailSetting;

@end