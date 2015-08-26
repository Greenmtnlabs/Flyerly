/*
 *  UserPurchases.h
 *  Untechable
 *
 *  Created on 25/Aug/2015
 *  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
 *
 */
#import <Foundation/Foundation.h>
@interface UserPurchases : NSObject{

}


@property (strong, nonatomic) NSMutableArray *productArray;
+ (id) getInstance;
-(void)loadAllProducts:(void(^)(NSString *))callBack;
- (BOOL)isSubscriptionValid;
-(void)purchaseProductID:(NSString *)productidentifier callBack:(void(^)(NSString *))callBack;
@end

