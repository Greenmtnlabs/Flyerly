//
//  FlurryLogging.m
//  Untechable
//
//  Created by RIKSOF on 29/01/2016.
//  Copyright (c) 2016 Green MTN Labs Inc. All rights reserved.
//

#import "FlurryLogging.h"

@implementation FlurryLogging{
}

/*
 * Method to log Flurry events on Creation
 * @params:
 *      untechType: NSString
 * @return:
 *      void
 */
-(void)untechCreationFlurryLog: (NSString *) untechType untechableModel:(Untechable *)untechableModel{
    
    untechable = [[Untechable alloc] init];
    untechable = [[Untechable alloc] initWithCommonFunctions];
    
    NSString *fbSharing = ([untechableModel.fbAuth isEqualToString:@""] && [untechableModel.fbAuthExpiryTs isEqualToString:@""]) ? @"NO" : @"YES";
    NSString *twitterSharing = ([untechableModel.twitterAuth isEqualToString:@""] && [untechableModel.twOAuthTokenSecret isEqualToString:@""]) ? @"NO" : @"YES";
    NSString *linkedInSharing = [untechableModel.linkedinAuth isEqualToString:@""] ? @"NO" : @"YES";
    
    NSString *duration = [untechable calculateHoursDays:untechableModel.startDate  endTime: untechableModel.endDate];
    
    NSMutableArray *arr = [untechable.commonFunctions checkCallSMSEmail:untechableModel.customizedContactsForCurrentSession];
    
    NSMutableDictionary *untechParams = [[NSMutableDictionary alloc] init];
    
    [untechParams setValue:untechType forKey:@"Type"];
    
    [untechParams setValue:untechableModel.eventId forKey:@"Event_ID"];
    [untechParams setValue:untechableModel.userName forKey:@"User_Name"];
    [untechParams setValue:untechableModel.userPhoneNumber forKey:@"User_PhoneNumber"];
    [untechParams setValue:untechableModel.email forKey:@"User_Email"];
    
    [untechParams setValue:untechableModel.spendingTimeTxt forKey:@"Title"];
    [untechParams setValue:[untechable.commonFunctions convertTimestampToNSDate:untechableModel.startDate] forKey:@"Start_DateTime"];
    [untechParams setValue:[untechable.commonFunctions convertTimestampToNSDate:untechableModel.endDate] forKey:@"End_DateTime"];
    
    [untechParams setValue:arr[0] forKey:@"Send_Email"];
    [untechParams setValue:arr[1] forKey:@"Send_Call"];
    [untechParams setValue:arr[2] forKey:@"Send_SMS"];
    
    [untechParams setValue:fbSharing forKey:@"Facebook_Sharing"];
    [untechParams setValue:twitterSharing forKey:@"Twitter_Sharing"];
    [untechParams setValue:linkedInSharing forKey:@"LinkedIn_Sharing"];
    
    [untechParams setValue:[NSDate date] forKey:@"Creation_Time"];
    
    [untechParams setValue:duration forKey:@"Untech_Duration"];
    
    [Flurry logEvent:@"Untech_Creation_Details" withParameters:untechParams];
}

/*
 * Method to log Flurry events on Deletion
 * @params:
 *      untechType: NSString
 * @return:
 *      void
 */
-(void)untechDeletionFlurryLog:(Untechable *)untechableModel{
    
    untechable = [[Untechable alloc] init];
    untechable = [[Untechable alloc] initWithCommonFunctions];
    
    NSString *fbSharing = ([untechableModel.fbAuth isEqualToString:@""] && [untechableModel.fbAuthExpiryTs isEqualToString:@""]) ? @"NO" : @"YES";
    NSString *twitterSharing = ([untechableModel.twitterAuth isEqualToString:@""] && [untechableModel.twOAuthTokenSecret isEqualToString:@""]) ? @"NO" : @"YES";
    NSString *linkedInSharing = [untechableModel.linkedinAuth isEqualToString:@""] ? @"NO" : @"YES";
    
    NSString *duration = [untechable calculateHoursDays:untechableModel.startDate  endTime: untechableModel.endDate];
    
    NSMutableArray *arr = [untechable.commonFunctions checkCallSMSEmail:untechableModel.customizedContactsForCurrentSession];
    
    NSMutableDictionary *untechParams = [[NSMutableDictionary alloc] init];
    
    [untechParams setValue:untechableModel.eventId forKey:@"Event_ID"];
    [untechParams setValue:untechableModel.userName forKey:@"User_Name"];
    [untechParams setValue:untechableModel.userPhoneNumber forKey:@"User_PhoneNumber"];
    [untechParams setValue:untechableModel.email forKey:@"User_Email"];
    
    [untechParams setValue:untechableModel.spendingTimeTxt forKey:@"Title"];
    [untechParams setValue:[untechable.commonFunctions convertTimestampToNSDate:untechableModel.startDate] forKey:@"Start_DateTime"];
    [untechParams setValue:[untechable.commonFunctions convertTimestampToNSDate:untechableModel.endDate] forKey:@"End_DateTime"];
    
    [untechParams setValue:arr[0] forKey:@"Send_Email"];
    [untechParams setValue:arr[1] forKey:@"Send_Call"];
    [untechParams setValue:arr[2] forKey:@"Send_SMS"];
    
    [untechParams setValue:fbSharing forKey:@"Facebook_Sharing"];
    [untechParams setValue:twitterSharing forKey:@"Twitter_Sharing"];
    [untechParams setValue:linkedInSharing forKey:@"LinkedIn_Sharing"];
    
    [untechParams setValue:[NSDate date] forKey:@"Deletion_Time"];
    
    [untechParams setValue:duration forKey:@"Untech_Duration"];
    
    [Flurry logEvent:@"Untech_Deletion_Details" withParameters:untechParams];
}


@end
