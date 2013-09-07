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
}
@property(nonatomic,retain) PhotoController *ptController;
@property(nonatomic,retain) NSMutableArray *photoArray;
@property(nonatomic,retain) NSMutableArray *photoDetailArray;
@property(nonatomic,retain) NSMutableArray *iconArray;
@property(nonatomic,retain) MyNavigationBar *navBar;
@property(nonatomic,retain) IBOutlet UITableView *tView;
@property(nonatomic,retain) IBOutlet UITextField *searchTextField;

+(NSString *)getFlyerNumberFromPath:(NSString *)imagePath;
-(void)goBack;

- (void) searchTableView;
- (void) searchClick;
- (void)doneSearching_Clicked:(id)sender;

@end
