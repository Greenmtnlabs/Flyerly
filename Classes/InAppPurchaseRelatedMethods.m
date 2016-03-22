//
//  InAppPurchaseRelatedMethods.m
//  Flyr
//
//  Created by RIKSOF Team SQA on 3/22/16.
//
//

#import "InAppPurchaseRelatedMethods.h"

@implementation InAppPurchaseRelatedMethods




/*
 * Opens InAppPurchase Panel
 */
+(void)openInAppPurchasePanel : (UIViewController *) viewController {
    if ([FlyerlySingleton connected]) {
        InAppViewController *inAppViewController;
        if( IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ){
            inAppViewController = [[InAppViewController alloc] initWithNibName:@"InAppViewController" bundle:nil];
        }else {
            inAppViewController = [[InAppViewController alloc] initWithNibName:@"InAppViewController-iPhone4" bundle:nil];
        }
        [viewController presentViewController:inAppViewController animated:YES completion:nil];
        [inAppViewController requestProduct];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You're not connected to the internet. Please connect and retry." message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
