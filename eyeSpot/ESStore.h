//
//  ESStore.h
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 3/2/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import <StoreKit/StoreKit.h>

FOUNDATION_EXPORT NSString * ESStoreTransactionsRestoredNotification;
FOUNDATION_EXPORT NSString * ESStoreTransactionsRestoredNotificationSuccessKey;
@class ESBoard;
typedef void (^ESStorePurchaseCompletionHandler)(BOOL wasPurchased, NSString *productID);

@interface ESStore : NSObject

+ (ESStore *) sharedStore;

- (void)purchaseProduct:(NSString *)productID withCompletionHandler:(ESStorePurchaseCompletionHandler)completionBlock;
- (BOOL)canPurchaseProducts;

- (void)restoreCompletedTransactions;
- (BOOL)isDesignABoardFeatureAvailable;
@end
