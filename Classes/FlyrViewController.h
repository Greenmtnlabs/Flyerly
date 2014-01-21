//
//  FlyrViewController.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 22/Jan/2014.
//

#import <UIKit/UIKit.h>
#import "CreateFlyerController.h"
#import "FlyerlySingleton.h"
#import "SaveFlyerCell.h"
#import "Common.h"
#import "ShareViewController.h"
#import "Common.h"
#import "HelpController.h"
#import "FlyrAppDelegate.h"

@class SaveFlyerCell;
@interface FlyrViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
	NSMutableArray *photoArray;
	NSMutableArray *photoDetailArray;
	NSMutableArray *iconArray;
    NSMutableArray *photoArrayBackup;
	NSMutableArray *photoDetailArrayBackup;
	NSMutableArray *iconArrayBackup;

	IBOutlet UITableView *tView;
    CreateFlyerController *ptController;
    BOOL searching;
    BOOL letUserSelectRow;
    FlyerlySingleton *globle;

}
@property(nonatomic,strong) CreateFlyerController *ptController;
@property(nonatomic,strong) NSMutableArray *photoArray;
@property(nonatomic,strong) NSMutableArray *photoDetailArray;
@property(nonatomic,strong) NSMutableArray *iconArray;
@property(nonatomic,strong) IBOutlet UITableView *tView;
@property(nonatomic,strong) IBOutlet UITextField *searchTextField;

+(NSString *)getFlyerNumberFromPath:(NSString *)imagePath;
-(void)goBack;

@end
