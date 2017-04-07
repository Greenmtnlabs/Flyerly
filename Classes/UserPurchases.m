//
//  UserPurchases.m
//  Flyr
//
//  Created by Khurram on 08/05/2014.
//
//

#import "UserPurchases.h"
#import "FlyerUser.h"
#import "RMAppReceipt.h"
#import "Common.h"

@implementation UserPurchases

@synthesize oldPurchases;
@synthesize delegate;

static UserPurchases *sharedSingleton = nil;

/**
 * This method would be called by runtime only once per class, and we are initializing
 * the singleton instance here.
 * Ref: http://stackoverflow.com/a/343191
 */
+ (void)initialize
{
    if(!sharedSingleton)
    {
        sharedSingleton = [[UserPurchases alloc] init];
    }
}

+ (id) getInstance {
    return sharedSingleton;
}

//check old purchase have this product id and this id should not belonge from any kind of subscriptions
-(BOOL) haveProduct:(NSString * )productId{
    NSString *productId_ = [productId stringByReplacingOccurrencesOfString:@"." withString:@""];
    if ( !([productId_ isEqualToString: IN_APP_ID_MONTHLY_SUBSCRIPTION] || [productId_ isEqualToString: IN_APP_ID_YEARLY_SUBSCRIPTION]) && [oldPurchases objectForKey:productId_] ) {
        return YES;
    } else {
        return NO;
    }
}

/*
 * Checks Ads Removal Subscription (for FlyerlyBiz)
 * @params:
 *      productId: NSString
 * @return:
 *      BOOL
 */

-(BOOL) hasAdsRemovalSubscription:(NSString * )productId {
    NSString *productId_ = [productId stringByReplacingOccurrencesOfString:@"." withString:@""];
    oldPurchases = [[NSMutableDictionary alloc]
                    initWithDictionary:[[NSUserDefaults standardUserDefaults]
                                        valueForKey:@"InAppPurchases"]];
    if ( [productId_ isEqualToString: IN_APP_ID_AD_REMOVAL] && [oldPurchases objectForKey:productId_] ) {
        return YES;
    } else {
        return NO;
    }
}

//checkKeyExistsInPurchases
- (BOOL) checkKeyExistsInPurchases : (NSString *)productId {
    if ( [self isSubscriptionValid] ) {
        return YES;
    } else if ( [oldPurchases objectForKey: IN_APP_ID_ALL_DESIGN]  ) {
        return YES;
    } else {
        return [self haveProduct:productId];
    }
}

- (BOOL) checkKeysExistsInPurchases : (NSArray *)productIds {
    BOOL exist = NO;
    for(int i=0; i<productIds.count; i++){
        exist = [self checkKeyExistsInPurchases:productIds[i]];
        
        if(exist){
            break;
        }
    }
    return exist;
}

/**
 * Purpose: check we can create video flyer ?
 * @parm:void 
 * @return:BOOL
 */
- (BOOL)canCreateVideoFlyer {
    if ( [self isSubscriptionValid] ) {
        return YES;
    } else if ( [oldPurchases objectForKey: IN_APP_ID_ALL_DESIGN]  ) {
        return YES;
    } else {
        return [self haveProduct:IN_APP_ID_UNLOCK_VIDEO];
    }
}

//return flag we can show ad or not
-(BOOL)canShowAd{
    BOOL showAdd = YES;
    
    RMAppReceipt* appReceipt = [RMAppReceipt bundleReceipt];
    
    // get monthly subscription validity
    NSString *isMonthlySubValid =[NSString stringWithFormat:@"%i", [appReceipt containsActiveAutoRenewableSubscriptionOfProductIdentifiers:@[BUNDLE_IDENTIFIER_MONTHLY_SUBSCRIPTION, BUNDLE_IDENTIFIER_OLD_MONTHLY_SUBSCRIPTION] forDate:[NSDate date]]]; // Monthly Subscription
    
    // get Yearly subscription validity
    NSString *isYearlySubValid =[NSString stringWithFormat:@"%i", [appReceipt containsActiveAutoRenewableSubscriptionOfProductIdentifiers:@[BUNDLE_IDENTIFIER_YEARLY_SUBSCRIPTION, BUNDLE_IDENTIFIER_OLD_YEARLY_SUBSCRIPTION] forDate:[NSDate date]]]; // Yearly Subscription
    
    
    // check add removal validity
    NSString *isAdRemovalSubValid;
    
    #if defined(FLYERLY)
        // check add removal validity
        isAdRemovalSubValid =[NSString stringWithFormat:@"%i", [appReceipt containsActiveAutoRenewableSubscriptionOfProductIdentifiers:@[BUNDLE_IDENTIFIER_AD_REMOVAL, BUNDLE_IDENTIFIER_OLD_AD_REMOVAL] forDate:[NSDate date]]]; // Ad Removal Subscription
    #else
        isAdRemovalSubValid = [self hasAdsRemovalSubscription:IN_APP_ID_AD_REMOVAL] ? @"1" : @"0";
    #endif
    
    //check have video bundle then don't show ad too
    BOOL haveVideoProduct = [self haveProduct:IN_APP_ID_UNLOCK_VIDEO];
    
    // check whether one of 'em is valid or not..
    if( [isMonthlySubValid isEqual:@"1"] || [isYearlySubValid isEqualToString:@"1"] || [isAdRemovalSubValid isEqualToString:@"1"] || haveVideoProduct ){
        showAdd = NO;
    }
    
    return showAdd;
}

//Return if monthly/yearly subscription is valid
-(BOOL)isSubscriptionValid{
    
    RMAppReceipt* appReceipt = [RMAppReceipt bundleReceipt];
    
    // get monthly subscription validity
    NSString *isMonthlySubValid =[NSString stringWithFormat:@"%i", [appReceipt containsActiveAutoRenewableSubscriptionOfProductIdentifiers:@[BUNDLE_IDENTIFIER_MONTHLY_SUBSCRIPTION, BUNDLE_IDENTIFIER_OLD_MONTHLY_SUBSCRIPTION] forDate:[NSDate date]]]; // Monthly Subscription
    
    // get Yearly subscription validity
    NSString *isYearlySubValid =[NSString stringWithFormat:@"%i", [appReceipt containsActiveAutoRenewableSubscriptionOfProductIdentifiers:@[BUNDLE_IDENTIFIER_YEARLY_SUBSCRIPTION, BUNDLE_IDENTIFIER_OLD_YEARLY_SUBSCRIPTION] forDate:[NSDate date]]]; // Yearly Subscription
    
    // check whether one of 'em is valid or not..
    if( [isMonthlySubValid isEqual:@"1"] || [isYearlySubValid isEqualToString:@"1"] ){
        return YES;
    } else {
        return NO;
    }
}

/*
 * HERE WE GET USER PURCHASES INFO FROM PARSE
 */
- (void)setUserPurcahsesFromParse {
    
    // We assume here that clearPurchases is called on logout, so these do not exist after a user logs out
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"InAppPurchases"]) {
        
        oldPurchases = [[NSMutableDictionary alloc]
                                            initWithDictionary:[[NSUserDefaults standardUserDefaults]
                                                                valueForKey:@"InAppPurchases"]];
        
        if ( delegate != nil ) {
            [delegate userPurchasesLoaded];
        }
        
    } else if ([[PFUser currentUser] sessionToken].length != 0) {
        
        //Getting Current User
        PFUser *user = [PFUser currentUser];
    
        //Create query for get user purchases
        PFQuery *query = [PFQuery queryWithClassName:@"InApp"];
        
        //define criteria
        [query whereKey:@"user" equalTo:user];
        
        //run query on Parse        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (!error) {
                
                if (objects.count >= 1) {
                    //Here we set User purchse details which returned from Parse
                    oldPurchases = [[objects objectAtIndex:0] valueForKey:@"json"];
                    
                    [[NSUserDefaults standardUserDefaults]setValue:oldPurchases forKey:@"InAppPurchases"];
                } else {
                    
                    //Here we set User purchse details which returned from Parse
                    oldPurchases = nil;
                }
                if ( delegate != nil ) {
                    [delegate userPurchasesLoaded];
                }
 
                // The find succeeded. The first 100 objects are available in objects
            } else {
                
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    } else {
        oldPurchases = nil;
    }
}
@end
