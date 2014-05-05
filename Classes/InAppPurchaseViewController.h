//
//  InAppPurchaseViewController.h
//  Flyr
//
//  Created by Khurram on 02/05/2014.
//
//

#import <UIKit/UIKit.h>
#import "CreateFlyerController.h"
#import "InAppPurchaseCell.h"
#import "InAppPurchaseViewController.h"
#import "FlyrAppDelegate.h"
#import "Flyer.h"
#import "RMStore.h"
#import "RMStoreKeychainPersistence.h"
#import "ParentViewController.h"

@class InAppPurchaseCell;

@interface InAppPurchaseViewController : ParentViewController <UITableViewDelegate,UITableViewDataSource,RMStoreObserver> {

    NSArray *requestedProducts;
    BOOL lockFlyer;

}


@property(nonatomic,strong) IBOutlet UITableView *tView;
@property(nonatomic,strong) IBOutlet UIButton *button;
@property(nonatomic,strong) NSString *Yvalue;

-(IBAction)hideMe;

-(void)purchaseProductID:(NSString *)pid;

@end
