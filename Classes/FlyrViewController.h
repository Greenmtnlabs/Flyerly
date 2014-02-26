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
#import "Common.h"
#import "HelpController.h"
#import "FlyrAppDelegate.h"
#import "Flyer.h"

@class SaveFlyerCell,Flyer;
@interface FlyrViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{

    CreateFlyerController *createFlyer;
    BOOL searching;
    Flyer *flyer;
    NSMutableArray *flyerPaths;
    NSMutableArray *searchFlyerPaths;

}
@property(nonatomic,strong) NSMutableArray *photoArray;
@property(nonatomic,strong) NSMutableArray *photoDetailArray;
@property(nonatomic,strong) NSMutableArray *iconArray;
@property(nonatomic,strong) IBOutlet UITableView *tView;
@property(nonatomic,strong) IBOutlet UITextField *searchTextField;

+(NSString *)getFlyerNumberFromPath:(NSString *)imagePath;
-(void)goBack;

-(NSMutableArray *)getFlyersPaths;

-(IBAction)createFlyer:(id)sender;

@end
