//
//  FlyrViewController.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 22/Jan/2014.
//

#import <UIKit/UIKit.h>
#import "CreateFlyerController.h"
#import "SaveFlyerCell.h"
#import "Common.h"
#import "ShareViewController.h"
#import "HelpController.h"
#import "FlyrAppDelegate.h"
#import "Flyer.h"
#import "RMStore.h"
#import "ParentViewController.h"

@class SaveFlyerCell,Flyer;
@interface FlyrViewController : ParentViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate,RMStoreObserver>{

    CreateFlyerController *createFlyer;
    BOOL searching;
    BOOL lockFlyer;
    BOOL sheetAlreadyOpen;
    Flyer *flyer;
    NSMutableArray *flyerPaths;
    NSMutableArray *searchFlyerPaths;
    NSArray *requestedProducts;
    


}

@property(nonatomic,strong) IBOutlet UITableView *tView;
@property(nonatomic,strong) IBOutlet UITextField *searchTextField;



-(void)goBack;

-(NSMutableArray *)getFlyersPaths;

-(IBAction)createFlyer:(id)sender;

-(void)requestProduct;
-(void)purchaseProductID:(NSString *)pid;

-(void)restorePurchase;


@end
