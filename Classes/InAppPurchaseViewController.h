//
//  InAppPurchaseViewController.h
//  Flyr
//
//  Created by Khurram on 02/05/2014.
//
//

/*
@protocol inAppPurchasePanelButtonProtocol

-(void)inAppPurchasePanelButtonTappedWasPressed:(NSString *)inAppPurchasePanelButtonCurrentTitle;

-(void)inAppPurchasePanelContent;

-(void)productSuccesfullyPurchased:(NSString *)productId;

//-(void)purchaseProductAtIndex:(int)index;

@end
*/

#import <UIKit/UIKit.h>
#import "CreateFlyerController.h"
#import "InAppPurchaseCell.h"
#import "InAppPurchaseViewController.h"
#import "FlyrAppDelegate.h"
#import "Flyer.h"
#import "UserPurchases.h"
#import "RMStore.h"
#import "RMStoreKeychainPersistence.h"
#import "ParentViewController.h"
#import "SigninController.h"

@class InAppPurchaseCell,SigninController,UserPurchases;
@interface InAppPurchaseViewController : ParentViewController <UITableViewDelegate,UITableViewDataSource,RMStoreObserver> {

    NSArray *requestedProducts;
    BOOL cancelRequest;
    
    UserPurchases *userPurchases;
}

@property(nonatomic,strong) IBOutlet UITableView *tView;
@property(nonatomic,strong) IBOutlet UIButton *sliderBtn;
@property(nonatomic,strong) IBOutlet UIActivityIndicatorView *contentLoaderIndicatorView;
@property(nonatomic,strong) IBOutlet UIButton *inAppPurchasePanelButton;
@property(nonatomic,strong) NSString *Yvalue;
@property (nonatomic, assign) id <inAppPurchasePanelButtonProtocol> buttondelegate;


-(IBAction)hideMe;
-(void) inAppDataLoaded;
-(void) requestProduct;
-(void) restorePurchase;
@end
