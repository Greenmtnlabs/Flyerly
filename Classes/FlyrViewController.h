//
//  FlyrViewController.h
//  Flyr
//
//  Created by Nilesh on 23/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "PhotoController.h"
#import "LauchViewController.h"
#import "Singleton.h"
#import "FlyerOverlayController.h"

@class FlyerOverlayController;
@interface FlyrViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
	NSMutableArray *photoArray;
	NSMutableArray *photoDetailArray;
	NSMutableArray *iconArray;
    NSMutableArray *photoArrayBackup;
	NSMutableArray *photoDetailArrayBackup;
	NSMutableArray *iconArrayBackup;

	MyNavigationBar *navBar;
	IBOutlet UITableView *tView;
    PhotoController *ptController;
    LauchViewController *launchCotroller;
    BOOL searching;
    BOOL letUserSelectRow;
    Singleton *globle;
    FlyerOverlayController *overlayController;
}
@property(nonatomic,strong) PhotoController *ptController;
@property(nonatomic,strong) NSMutableArray *photoArray;
@property(nonatomic,strong) NSMutableArray *photoDetailArray;
@property(nonatomic,strong) NSMutableArray *iconArray;
@property(nonatomic,strong) MyNavigationBar *navBar;
@property(nonatomic,strong) IBOutlet UITableView *tView;
@property(nonatomic,strong) IBOutlet UITextField *searchTextField;

+(NSString *)getFlyerNumberFromPath:(NSString *)imagePath;
-(void)goBack;

- (void) searchTableView;
- (void) searchClick;
- (void)doneSearching_Clicked:(id)sender;

@end
