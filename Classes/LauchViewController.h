//
//  LauchViewController.h
//  Flyer
//
//  Created by Krunal on 13/10/09.
//  Copyright 2009 iauro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect/FBConnect.h"

@class FlyrViewController;
@class SettingViewController;
@class PhotoController ;
@class LoadingView;
@class FBSession;




@interface LauchViewController : UIViewController {
	PhotoController *ptController;
	FlyrViewController *tpController;
	SettingViewController *spController;
	LoadingView *loadingView;
	IBOutlet FBLoginButton *faceBookButton;
	BOOL loadingViewFlag;
}
@property(nonatomic,retain) PhotoController *ptController;
@property (nonatomic, retain) LoadingView *loadingView;
@property(nonatomic,retain) FlyrViewController *tpController;
@property(nonatomic,retain) SettingViewController *spController;
@property (nonatomic, retain) IBOutlet FBLoginButton *faceBookButton;
-(IBAction)doNew:(id)sender;
-(IBAction)doOpen:(id)sender;
-(IBAction)doAbout:(id)sender;
@end
