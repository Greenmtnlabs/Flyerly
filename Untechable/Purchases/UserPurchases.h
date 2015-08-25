/*
 *  UserPurchases.h
 *  Untechable
 *
 *  Created on 25/Aug/2015
 *  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
 *
 */
#import <Foundation/Foundation.h>
@interface UserPurchases : NSObject


+ (id) getInstance;
- (BOOL) isSubscriptionValid;
@end

