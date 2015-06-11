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
    
    if ( [oldPurchases objectForKey:@"comflyerlyAllDesignBundle"] || [self isSubscriptionValid] ) {
        
        return YES;
        
    } else {
    
        NSString *productId_ = [productId stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        if ( ![productId_ isEqualToString:@"comflyerlyMonthlySubscription"] && [oldPurchases objectForKey:productId_] ) {
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
    
    RMAppReceipt* appReceipt = [RMAppReceipt bundleReceipt];
    
    NSLog(@"Is subscription is valid?, Valid: %d", [appReceipt containsActiveAutoRenewableSubscriptionOfProductIdentifier:@"com.flyerly.MonthlySubscription" forDate:[NSDate date]]);
    
    NSString *isValid =[NSString stringWithFormat:@"%hhd", [appReceipt containsActiveAutoRenewableSubscriptionOfProductIdentifier:@"com.flyerly.MonthlySubscription" forDate:[NSDate date]]];
    if( [isValid isEqual:@"0"] ){
        return NO;
    } else {
        return YES;
    }
}

@end

