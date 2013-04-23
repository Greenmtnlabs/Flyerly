//
//  SettingViewController.h
//  Exchange
//
//  Created by krunal on 18/08/09.
//  Copyright 2009 iauro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"

#import "FBConnect/FBConnect.h"
#import "TwitLogin.h"
//#import "FBLoginButton.h"

@class FBSession;
@interface SettingViewController : UIViewController <UITextFieldDelegate,FBDialogDelegate, FBSessionDelegate, FBRequestDelegate>{
	UITextField *password;
	UITextField *user;
	UIBarButtonItem *doneButton;
	bool keyboardShown;
	UIScrollView * scrollView;
	UITextField * activeField;
	MyNavigationBar *navBar;
	//IBOutlet FBLoginButton *faceBookButton;
	FBSession* _session;
	TwitLogin *twitDialog;
}
@property(nonatomic,retain) MyNavigationBar *navBar;
@property (nonatomic,retain) IBOutlet UITextField *password;
@property (nonatomic,retain) IBOutlet UITextField *user;
@property(nonatomic,retain)  UIBarButtonItem *doneButton;
@property (nonatomic, retain) IBOutlet UIScrollView * scrollView;
//@property (nonatomic, retain) IBOutlet FBLoginButton *faceBookButton;
@property (nonatomic,retain) TwitLogin *twitDialog;
-(void)initSession;
- (void)registerForKeyboardNotifications;
@end
