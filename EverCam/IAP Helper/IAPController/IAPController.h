/*========================================
 
 - Instafun -
 
 made by FV iMAGINATION ©2015
 All rights reserved
 
 ========================================*/


#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Configs.h"
#import <StoreKit/StoreKit.h>

BOOL iapMade;
MBProgressHUD *hud;



@interface IAPController : UIViewController
<
SKProductsRequestDelegate,
SKPaymentTransactionObserver
>


// InApp Purchase Properties  =========
@property (strong, nonatomic) SKProduct *product;

@property (strong, nonatomic) NSArray *validProducts;

// Buttons
@property (weak, nonatomic) IBOutlet UIButton *buyOutlet;
@property (weak, nonatomic) IBOutlet UIButton *restorePurchaseOutlet;

// Labels
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *descTxt;


@end
