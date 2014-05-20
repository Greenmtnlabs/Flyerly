    //
//  UserPurchases.m
//  Flyr
//
//  Created by Khurram on 08/05/2014.
//
//

#import "UserPurchases.h"
#import "FlyerUser.h"

@implementation UserPurchases

@synthesize oldPurchases;
@synthesize delegate;

- (BOOL) checkKeyExistsInPurchases : (NSString *)productId {

    if ( [oldPurchases objectForKey:@"comflyerlyAllDesignBundle"] ) {
        return true;
    }else {
    
        NSString *productId_ = [productId stringByReplacingOccurrencesOfString:@"." withString:@""];
        if ([oldPurchases objectForKey:productId_]) {
            return true;
        }else {
            return false;
        }
    }
    

}

/*
 * HERE WE GET USER PURCHASES INFO FROM PARSE
 */
- (void)setUserPurcahsesFromParse {
    
    if ([[PFUser currentUser] sessionToken].length != 0) {
        
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
                    
                }
                
                if ( delegate != nil /*&& [delegate respondsToSelector:@selector(userPurchasesLoaded:)]*/ ) {
                    [delegate userPurchasesLoaded];
                }

                
                // The find succeeded. The first 100 objects are available in objects
            } else {
                
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }else {
        oldPurchases = nil;
    }
    
}




@end

