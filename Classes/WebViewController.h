//
//  WebViewController.h
//  Flyr
//
//  Created by rufi on 04/11/2015.
//
//

#import <UIKit/UIKit.h>
#import "UserPurchases.h"


@class InAppViewController;
@interface WebViewController : UIViewController <UIWebViewDelegate, UserPurchasesDelegate>{
    UIButton *btnHome;
    UIButton *btnInAppPurchase;
    UIBarButtonItem *leftBarButton, *rightBarButton;
    UIView *loadingView;
}

@property (nonatomic, strong) UIAlertView *popupAlert;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedButton;

- (IBAction)segmentedControlAction:(id)sender;

@property (nonatomic, copy) void (^shouldShowAdd)(NSString *,BOOL);
@property (nonatomic, copy) void (^onFlyerBack)(NSString *);

@end
