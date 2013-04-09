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

	UIImage *selectedFlyerImage;
	UIImageView *imgView;
	MyNavigationBar *navBar;
	FlyrViewController *fvController;
	SaveFlyerController *svController;
}
@property(nonatomic,retain)UIImage *selectedFlyerImage;
@property(nonatomic,retain)UIImageView *imgView;
@property(nonatomic,retain) MyNavigationBar *navBar;
@property(nonatomic,retain)FlyrViewController *fvController;
@property(nonatomic,retain)SaveFlyerController *svController;
@end
