//
//  ParentViewController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd Ali on 9/10/13.
//
//

#import "ParentViewController.h"

@interface ParentViewController ()

@end

@implementation ParentViewController

/**
 * Show a loding indicator in the right bar button.
 */
- (void)showLoadingIndicator {
    // Remember the right bar button item.
    rightBarButtonItem = self.navigationItem.rightBarButtonItem;
    
    UIActivityIndicatorView *uiBusy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    uiBusy.hidesWhenStopped = YES;
    [uiBusy startAnimating];
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:uiBusy];
    [self.navigationItem setRightBarButtonItem:btn animated:NO];
}

/**
 * Hide previously shown indicator.
 */
- (void)hideLoadingIndicator {
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem animated:NO];
}



@end
