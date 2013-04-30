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

@interface FlyrViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>{
	NSMutableArray *photoArray;
	NSMutableArray *photoDetailArray;
	NSMutableArray *iconArray;
	MyNavigationBar *navBar;
	IBOutlet UITableView *tView;
    PhotoController *ptController;
}
@property(nonatomic,retain) PhotoController *ptController;
@property(nonatomic,retain) NSMutableArray *photoArray;
@property(nonatomic,retain) NSMutableArray *photoDetailArray;
@property(nonatomic,retain) NSMutableArray *iconArray;
@property(nonatomic,retain) MyNavigationBar *navBar;
@property(nonatomic,retain) IBOutlet UITableView *tView;
@end
