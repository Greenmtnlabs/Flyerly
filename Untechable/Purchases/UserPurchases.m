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
#import "RMStore.h"
#import "SKProduct+LocalPrice.h"
#import "Common.h"



@implementation UserPurchases{
    
}

static UserPurchases *sharedSingleton = nil;
@synthesize productArray;

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

/*
 * load all products from store 
 */
-(void)loadAllProducts:(void(^)(NSString *))callBack{
    
    //Check For Crash Maintain
    NSArray *productIdentifiersAry = @[PRO_MONTHLY_SUBS, PRO_YEARLY_SUBS];
    //These are over Products on App Store
    NSSet *productIdentifiers = [NSSet setWithArray:productIdentifiersAry];
    
    [[RMStore defaultStore] requestProducts:productIdentifiers success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
        
        productArray = [[NSMutableArray alloc] init];
        
        for(NSString *identifier in productIdentifiersAry){
            for(SKProduct *product in products)
            {
                if( [identifier isEqualToString:product.productIdentifier]){
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                          product.localizedTitle,@"packagename",
                                          product.priceAsString,@"packageprice" ,
                                          product.localizedDescription,@"packagedesciption",
                                          product.productIdentifier,@"productidentifier" , nil];
                    
                    [productArray addObject:dict];
                    break;
                }
            }
        }
        
        if( callBack != nil )
        callBack(@"");
        
    } failure:^(NSError *error) {
        if( callBack != nil )
        callBack(@"Something went wrong, while loading products.");
    }];
}

/*
 HERE WE PURCHASE PRODUCT FROM APP STORE
 When user tap on product for purchase
 */
-(void)purchaseProductID:(NSString *)productidentifier callBack:(void(^)(NSString *))callBack{
    
    [[RMStore defaultStore] addPayment:productidentifier success:^(SKPaymentTransaction *transaction) {
        callBack(SUCCESS);
    } failure:^(SKPaymentTransaction *transaction, NSError *error) {
        if( error != nil){
            if( error.code == 2 ){
                callBack( CANCEL );
            } else {
                callBack( error.description );
            }
        } else{
            callBack(@"Something went wrong");
        }
    }];
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