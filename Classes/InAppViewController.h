//
//  InAppViewController.h
//  Flyr
//
//  Created by RIKSOF Developer on 5/21/14.
//
//

@protocol InAppPurchasePanelButtonProtocol

-(void)inAppPanelDismissed;

-(void)inAppPurchasePanelButtonTappedWasPressed:(NSString *)inAppPurchasePanelButtonCurrentTitle;

-(void)inAppPurchasePanelContent;

-(void)productSuccesfullyPurchased:(NSString *)productId;

@end

#import <UIKit/UIKit.h>
#import "CreateFlyerController.h"
#import "InAppPurchaseCell.h"
#import "FreeFeatureCell.h"
#import "FlyrAppDelegate.h"
#import "Flyer.h"
#import "UserPurchases.h"
#import "RMStore.h"
#import "RMStoreKeychainPersistence.h"
#import "ParentViewController.h"
#import "SigninController.h"

@interface InAppViewController : ParentViewController <UITableViewDelegate,UITableViewDataSource,RMStoreObserver>{
    
    NSArray *requestedProducts;
    BOOL cancelRequest;
    UserPurchases *userPurchases;
}


@property (nonatomic, assign) id <InAppPurchasePanelButtonProtocol> buttondelegate;
@property(nonatomic,strong) IBOutlet UITableView *freeFeaturesTview;
@property(nonatomic,strong) IBOutlet UITableView *paidFeaturesTview;
@property(nonatomic,strong) IBOutlet UIButton *loginButton;
@property(nonatomic,strong) IBOutlet UIButton *completeDesignBundleButton;
@property(nonatomic,strong) IBOutlet UIActivityIndicatorView *loadingIndicator;

-(IBAction)hideMe;
-(IBAction)goToTermsAndServiceScreen;
-(IBAction)purchaseCompleteBundle;
-(void) requestProduct;
-(void) inAppDataLoaded;
-(void) restorePurchase;
-(void) updateParse;
-(void) purchaseProductByID:(NSString *) identifier;

@end
