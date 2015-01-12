//
//  ESStore.m
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 3/2/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import <FlurrySDK/Flurry.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "ESStore.h"
#import "ESBoard.h"
#import "ESAppDelegate.h"
#import "NSManagedObjectContext+ESSaveUtilities.h"

typedef void (^ESStoreRequestProductsCompletionHandler)(BOOL success, NSArray *products);
NSString * ESStoreTransactionsRestoredNotification = @"ESStoreTransactionsRestoredNotification";
NSString * ESStoreTransactionsRestoredNotificationSuccessKey = @"ESStoreTransactionsRestoredNotificationSuccessKey";

@interface ESStore () <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) NSMutableDictionary *productIDCompletionBlockMap;
@property (nonatomic, assign) BOOL hasReceivedProductData;
@property (nonatomic, copy) ESStoreRequestProductsCompletionHandler requestProductsCompletionHandler;

@end

@implementation ESStore

+ (ESStore *) sharedStore
{
    static ESStore *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ESStore alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        self.productIDCompletionBlockMap = [NSMutableDictionary dictionary];
        self.hasReceivedProductData = NO;
    }
    return self;
}

#pragma mark - Helpers
- (NSSet *)allProductIDs
{
    NSArray *boards = [ESBoard allBoards:[[ESAppDelegate sharedAppDelegate] managedObjectContext]];
    NSMutableSet *ids = [NSMutableSet setWithCapacity:[boards count]+1];
    for (ESBoard *board in boards) {
        [ids addObject:board.productID];
    }
    [ids addObject:kESDesignABoardProductID];
    return ids;
}

- (SKProduct *)productForID:(NSString *)productID
{
    NSUInteger index = [self.products indexOfObjectPassingTest:^BOOL(SKProduct *product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productID]) {
            *stop = YES;
            return YES;
        } else {
            return NO;
        }
    }];
    return (NSNotFound == index) ? nil : self.products[index];
}

- (BOOL)isDesignABoardFeatureAvailable
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kESDesignABoardProductID];
}

#pragma mark - Purchasing
- (BOOL)canPurchaseProducts
{
    return [SKPaymentQueue canMakePayments];
}

- (void)purchaseProduct:(NSString *)productID withCompletionHandler:(ESStorePurchaseCompletionHandler)completionBlock
{
    if ([self.productIDCompletionBlockMap objectForKey:productID] != nil) {
        return; //ignore repeated calls
    }
    
    void (^purchaseBlock)() = ^{
        SKProduct *product = [self productForID:productID];
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        
        if (![self canPurchaseProducts] || !product || !payment) {
            completionBlock(NO, productID);
        } else {
            self.productIDCompletionBlockMap[productID] = [completionBlock copy];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        }        
    };
    
    if (self.hasReceivedProductData) {
        purchaseBlock();
    } else {
        [self requestProductDataWithCompletionHandler:^(BOOL success, NSArray *products) {
            purchaseBlock();
        }];
    }
}

- (void)restoreCompletedTransactions
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark - SKProductsRequestDelegate
- (void)requestProductDataWithCompletionHandler:(ESStoreRequestProductsCompletionHandler)completionHandler
{
    self.requestProductsCompletionHandler = completionHandler;
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[self allProductIDs]];
    request.delegate = self;
    [request start];
    [SVProgressHUD showWithStatus:@"Requesting product data"];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    self.products = response.products;
    self.hasReceivedProductData = YES;
//    NSLog(@"App Store didn't recognize product IDs: %@", response.invalidProductIdentifiers);
    [SVProgressHUD dismiss];
    if (self.requestProductsCompletionHandler) {
        self.requestProductsCompletionHandler(YES, response.products);
        self.requestProductsCompletionHandler = nil;
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    [Flurry logError:kESEventTagForStoreKitError
             message:@"Failed to receive product data"
               error:error];
    NSLog(@"Failed to receive product data: %@", error);
    [SVProgressHUD showErrorWithStatus:@"Failed to get product data"];
    if (self.requestProductsCompletionHandler) {
        self.requestProductsCompletionHandler(NO, nil);
        self.requestProductsCompletionHandler = nil;
    }
}

#pragma mark - SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
                [SVProgressHUD showWithStatus:@"Purchasing item"];
                break;
            case SKPaymentTransactionStatePurchased:
                [SVProgressHUD showSuccessWithStatus:@"Board purchased"];
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                if (transaction.error.code == SKErrorPaymentCancelled) {
                    [SVProgressHUD dismiss];
                } else {
                    [SVProgressHUD showSuccessWithStatus:@"Failed to purchase board"];
                }
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [SVProgressHUD dismiss];
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    };
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSDictionary *info = @{ESStoreTransactionsRestoredNotificationSuccessKey : @(NO)};
    [[NSNotificationCenter defaultCenter] postNotificationName:ESStoreTransactionsRestoredNotification
                                                        object:nil
                                                      userInfo:info];    
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSDictionary *info = @{ESStoreTransactionsRestoredNotificationSuccessKey : @(YES)};
    [[NSNotificationCenter defaultCenter] postNotificationName:ESStoreTransactionsRestoredNotification
                                                        object:nil
                                                      userInfo:info];
}

#pragma mark - Managing Transactions
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSString *productID = transaction.payment.productIdentifier;
    BOOL success = [self provideContentForProductIdentifier:productID];
    ESStorePurchaseCompletionHandler handler = self.productIDCompletionBlockMap[productID];
    if (handler) {
        handler(success, productID);
        [self.productIDCompletionBlockMap removeObjectForKey:productID];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSString *productID = transaction.payment.productIdentifier;
    BOOL success = [self provideContentForProductIdentifier:productID];
    ESStorePurchaseCompletionHandler handler = self.productIDCompletionBlockMap[productID];
    if (handler) {
        handler(success, productID);
        [self.productIDCompletionBlockMap removeObjectForKey:productID];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
        [Flurry logError:kESEventTagForStoreKitError
                 message:transaction.error.localizedDescription
                   error:transaction.error];
        
    }
    NSString *productID = transaction.payment.productIdentifier;
    ESStorePurchaseCompletionHandler handler = self.productIDCompletionBlockMap[productID];
    if (handler) {
        handler(NO, productID);
        [self.productIDCompletionBlockMap removeObjectForKey:productID];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (BOOL)provideContentForProductIdentifier:(NSString *)productID
{
    BOOL success = NO;
    NSString *boardTitle;
    if ([productID isEqualToString:kESDesignABoardProductID]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productID];
        [[NSUserDefaults standardUserDefaults] synchronize];
        success = YES;
        boardTitle = @"Design A Board";
    } else {
        NSArray *boards = [ESBoard allBoards:[[ESAppDelegate sharedAppDelegate] managedObjectContext]];
        for (ESBoard *board in boards) {
            if ([productID isEqualToString:board.productID]) {
                board.isAvailable = YES;
                success = [board.managedObjectContext es_saveAndAutomaticallyReportErrors:nil];
                boardTitle = board.title;
                break;
            }
        }
    }
    
    if (success) {
        [Flurry logEvent:kESEventTagForBoardPurchase withParameters:@{@"board" : boardTitle}];
    }
    return success;
}

@end
