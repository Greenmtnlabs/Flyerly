/*
 *  UserPurchases.h
 *  Untechable
 *
 *  Created on 25/Aug/2015
 *  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
 *
 */
#import "UserPurchases.h"
#import "RMAppReceipt.h"
#import "Common.h"



@implementation UserPurchases



static UserPurchases *sharedSingleton = nil;

/**
 * This method would be called by runtime only once per class, and we are initializing
 * the singleton instance here.
 * Ref: http://stackoverflow.com/a/343191
 */
+ (void)initialize {
    if( !sharedSingleton ){
        sharedSingleton = [[UserPurchases alloc] init];
    }
}

+ (id) getInstance {
    return sharedSingleton;
}

/**
 Check if monthly subscription is valid or not
 **/
-(BOOL)isSubscriptionValid{
    BOOL valid = NO;
    RMAppReceipt* appReceipt = [RMAppReceipt bundleReceipt];
    
    // get monthly subscription validity
    NSString *isMonthlySubValid =[NSString stringWithFormat:@"%i", [appReceipt containsActiveAutoRenewableSubscriptionOfProductIdentifier:PRO_MONTHLY_SUBS forDate:[NSDate date]]];
    
    // get Yearly subscription validity
    NSString *isYearlySubValid =[NSString stringWithFormat:@"%i", [appReceipt containsActiveAutoRenewableSubscriptionOfProductIdentifier:PRO_YEARLY_SUBS forDate:[NSDate date]]];
    
    // check whether one of 'em is valid or not..
    if( [isMonthlySubValid isEqual:@"1"] || [isYearlySubValid isEqualToString:@"1"] ){
        valid = YES;
    }
    NSLog(valid ? @"Has valid subscription": @"No subscription found");
    return valid;
}

@end

