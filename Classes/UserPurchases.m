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

- (BOOL) checkKeyExistsInPurchases : (NSString *)productId {
    
    #if defined(FLYERLY)
        inAppPurchaseKeys = FLYERLY_IN_APP_PURCHASE_KEYS;
    #else
        inAppPurchaseKeys = FLYERLY_BIZ_IN_APP_PURCHASE_KEYS;
    #endif

    if ( [oldPurchases objectForKey:[inAppPurchaseKeys objectAtIndex:0]] && [self isSubscriptionValid] ) {
        return YES;
    } else {
        
        NSString *productId_ = [productId stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        if ( !([productId_ isEqualToString: [inAppPurchaseKeys objectAtIndex:4]] || [productId_ isEqualToString: [inAppPurchaseKeys objectAtIndex:5]]) && [oldPurchases objectForKey:productId_] ) {
            return YES;
        }
    }
    return NO;
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

/**
 Check if monthly subscription is valid or not
 **/
-(BOOL)isSubscriptionValid{
    
    NSArray *selectedInAppIDs;

    
    #if defined(FLYERLY)
        selectedInAppIDs = FLYERLY_IN_APP_PRODUCT_SELECTED_IDENTIFIERS;
    #else
        selectedInAppIDs = FLYERLYBIZ_IN_APP_PRODUCT_SELECTED_IDENTIFIERS;
    #endif
    
    RMAppReceipt* appReceipt = [RMAppReceipt bundleReceipt];
    
    // get monthly subscription validity
    NSString *isMonthlySubValid =[NSString stringWithFormat:@"%i", [appReceipt containsActiveAutoRenewableSubscriptionOfProductIdentifier:[selectedInAppIDs objectAtIndex:0] forDate:[NSDate date]]]; // Monthly Subscription
    
    // get Yearly subscription validity
    NSString *isYearlySubValid =[NSString stringWithFormat:@"%i", [appReceipt containsActiveAutoRenewableSubscriptionOfProductIdentifier:[selectedInAppIDs objectAtIndex:1] forDate:[NSDate date]]]; // Yearly Subscription
    
    // get Yearly subscription validity
    NSString *isAdRemovalSubValid =[NSString stringWithFormat:@"%i", [appReceipt containsActiveAutoRenewableSubscriptionOfProductIdentifier:[selectedInAppIDs objectAtIndex:2] forDate:[NSDate date]]]; // Ad Removal Subscription
    
    // check whether one of 'em is valid or not..
    if( [isMonthlySubValid isEqual:@"1"] || [isYearlySubValid isEqualToString:@"1"] || [isAdRemovalSubValid isEqualToString:@"1"] ){
        return YES;
    } else {
        return NO;
    }
}

@end

