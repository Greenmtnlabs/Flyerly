//
//  FlyrViewController.h
//  Flyr
//
//  Created by Nilesh on 23/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
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
@property(nonatomic,strong) IBOutlet UITableView *tView;
@property(nonatomic,strong) IBOutlet UITextField *searchTextField;

+(NSString *)getFlyerNumberFromPath:(NSString *)imagePath;
-(void)goBack;

@end
