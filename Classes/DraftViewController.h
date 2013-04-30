//
//  DraftViewController.h
//  Flyr
//
//  Created by Krunal on 10/24/09.
//  Copyright 2009 iauro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
@class FlyrViewController;
@class SaveFlyerController;
@interface DraftViewController : UIViewController {

	IBOutlet UIImageView *imgView;
	IBOutlet UITextField *titleView;
	IBOutlet UILabel *descriptionView;

	UIImage *selectedFlyerImage;
	NSString *selectedFlyerTitle;
	NSString *selectedFlyerDescription;
	NSString *detailFileName;
	NSString *imageFileName;
    
	MyNavigationBar *navBar;
	FlyrViewController *fvController;
	SaveFlyerController *svController;
}
@property(nonatomic,retain) IBOutlet UILabel *descriptionView;
@property(nonatomic,retain) IBOutlet UITextField *titleView;
@property(nonatomic,retain) IBOutlet UIImageView *imgView;

@property(nonatomic,retain)UIImage *selectedFlyerImage;
@property(nonatomic,retain)NSString *selectedFlyerTitle;
@property(nonatomic,retain)NSString *selectedFlyerDescription;
@property(nonatomic,retain)NSString *detailFileName;
@property(nonatomic,retain)NSString *imageFileName;

@property(nonatomic,retain) MyNavigationBar *navBar;
@property(nonatomic,retain)FlyrViewController *fvController;
@property(nonatomic,retain)SaveFlyerController *svController;
@end
