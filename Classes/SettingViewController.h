//
//  SettingViewController.h
//  Exchange
//
//  Created by krunal on 18/08/09.
//  Copyright 2009 iauro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect/FBConnect.h"
#import <Twitter/Twitter.h>
#import <ObjectiveFlickr.h>
#import "LoadingView.h"

//#import "FBConnect/FBConnect.h"
//#import "TwitLogin.h"
//#import "FBLoginButton.h"
//@class FBSession;

@interface SettingViewController : UIViewController<FBRequestDelegate,FBSessionDelegate,OFFlickrAPIRequestDelegate> {
//@interface SettingViewController : UIViewController <UITextFieldDelegate,FBDialogDelegate, FBSessionDelegate, FBRequestDelegate>{
    /*
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
     */
    IBOutlet UIButton *facebookButton;
	IBOutlet UIButton *twitterButton;
	IBOutlet UIButton *emailButton;
	IBOutlet UIButton *tumblrButton;
	IBOutlet UIButton *flickrButton;
	IBOutlet UIButton *instagramButton;
	IBOutlet UIButton *smsButton;
	IBOutlet UIButton *clipboardButton;

    IBOutlet UIButton *helpTab;

    OFFlickrAPIRequest *flickrRequest;
	LoadingView *loadingView;

}

@property(nonatomic,retain) IBOutlet UIButton *facebookButton;
@property(nonatomic,retain) IBOutlet UIButton *twitterButton;
@property(nonatomic,retain) IBOutlet UIButton *emailButton;
@property(nonatomic,retain) IBOutlet UIButton *tumblrButton;
@property(nonatomic,retain) IBOutlet UIButton *flickrButton;
@property(nonatomic,retain) IBOutlet UIButton *instagramButton;
@property(nonatomic,retain) IBOutlet UIButton *smsButton;
@property(nonatomic,retain) IBOutlet UIButton *clipboardButton;

@property(nonatomic,retain) IBOutlet UIButton *helpTab;
@property (nonatomic, retain) LoadingView *loadingView;

/*
@property(nonatomic,retain) MyNavigationBar *navBar;
@property (nonatomic,retain) IBOutlet UITextField *password;
@property (nonatomic,retain) IBOutlet UITextField *user;
@property(nonatomic,retain)  UIBarButtonItem *doneButton;
@property (nonatomic, retain) IBOutlet UIScrollView * scrollView;
//@property (nonatomic, retain) IBOutlet FBLoginButton *faceBookButton;
@property (nonatomic,retain) TwitLogin *twitDialog;
-(void)initSession;
- (void)registerForKeyboardNotifications;
 */

-(IBAction)onClickFacebookButton;
-(IBAction)onClickTwitterButton;
-(IBAction)onClickInstagramButton;
-(IBAction)onClickEmailButton;
-(IBAction)onClickTumblrButton;
-(IBAction)onClickFlickrButton;
-(IBAction)onClickSMSButton;
-(IBAction)onClickClipboardButton;
-(IBAction)loadHelpController;

@end
