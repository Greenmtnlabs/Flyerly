/*========================================
 
 - Instafun -
 
 made by FV iMAGINATION ©2015
 All rights reserved
 
 ========================================*/


#import "IAPController.h"
#import "Configs.h"
#import "HomeVC.h"


@interface IAPController ()
@end

@implementation IAPController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    NSLog(@"IAP MADE: %d", iapMade);
    
    if (!iapMade) {  _buyOutlet.hidden = false;
    } else {         _buyOutlet.hidden = true;   }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ADD PROGRESS HUD ================
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    [hud show:true];
    
    
    // Set Texts
    _titleLabel.text = NSLocalizedString(@"EverCam Premium", @"");
    [_buyOutlet setTitle:NSLocalizedString(@"Get Premium Now", @"") forState:UIControlStateNormal];
    [_restorePurchaseOutlet setTitle:NSLocalizedString(@"Restore Purchase", @"") forState:UIControlStateNormal];
    

    // Fetch available IAP products
    [self fetchAvailableProducts];
}





#pragma mark - BUY PREMIUM VERSION BUTTON
- (IBAction)buyButt:(id)sender {
    SKPayment *payment = [SKPayment paymentWithProduct: _product];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
    //[hud show:true];
}


#pragma mark - RESTORE PURCHASE BUTTON
- (IBAction)restorePurchaseButt:(id)sender {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    [hud show:true];
}





#pragma mark - IAP METHODS ----------------------------------------------
-(void)fetchAvailableProducts {
    
    if([SKPaymentQueue canMakePayments]){
        NSLog(@"User can make payments");
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:IAP_PRODUCT]];
        productsRequest.delegate = self;
        [productsRequest start];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: APP_NAME
        message:@"Purchases are diabled on this device!"
        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }

}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSUInteger count = response.products.count;
    SKProduct *validProduct = nil;
    if(count > 0){
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        _product = validProduct;
        
        _descTxt.text = [NSString stringWithFormat:@"%@ \nfor just %@", _product.localizedDescription, _product.price];
        _descTxt.font = [UIFont fontWithName:@"Titillium-Semibold" size: 17];
        _descTxt.textColor = [UIColor whiteColor];
        _descTxt.textAlignment = NSTextAlignmentCenter;
        
        
        // Product id is not valid, this shouldn't be called unless that happens.
    } else if(!validProduct) { NSLog(@"No products available");  }
    
    // Hide HUD
    [hud hide:true];
}


-(void)purchaseMyProduct:(SKProduct *)product {
    SKPayment *payment = [SKPayment paymentWithProduct: product];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    
    for(SKPaymentTransaction *transaction in transactions){
        switch(transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"Transaction state -> Purchasing");
                [hud show:true];
                break;
                
            case SKPaymentTransactionStatePurchased:
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];

                [self purchaseResults];
                
                NSLog(@"Transaction state -> Purchased");
                break;
                
            case SKPaymentTransactionStateRestored:
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Transaction state -> Restored");
                [self purchaseResults];
                
                break;
                
            case SKPaymentTransactionStateFailed:
                if(transaction.error.code == SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled");
                    // The user cancelled the payment ;(
                    [hud hide:true];
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateDeferred:
                [hud hide:true];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}


-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    [self purchaseResults];
}


-(void)purchaseResults {
    // BOOL iapMade = TRUE, save and store it forever
    iapMade = true;
    [[NSUserDefaults standardUserDefaults] setBool:iapMade forKey:@"iapMade"];
    NSLog(@"%d", iapMade);
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: APP_NAME
    message: [NSString stringWithFormat:@"You've unlocked %@ Premium!", APP_NAME]
    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    [self dismissViewControllerAnimated:true completion:nil];
    [hud hide:true];
}






#pragma mark -  DISMISS BUTTON
- (IBAction)dimissButt:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}





- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
