//
//  ParentViewController.h
//  Flyr
//
//  Created by Khurram Ali on 9/10/13.
//
//

#import <UIKit/UIKit.h>

@interface ParentViewController : UIViewController {
    UIBarButtonItem  *rightBarButtonItem;
}

- (void)showLoadingIndicator;
- (void)hideLoadingIndicator;

@end
