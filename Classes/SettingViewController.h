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
#import "LauchViewController.h"
#import "InputViewController.h"
#import "ParentViewController.h"

@class LauchViewController,InputViewController;
@interface SettingViewController : ParentViewController <FBRequestDelegate,FBSessionDelegate,OFFlickrAPIRequestDelegate> {
    IBOutlet UIButton *facebookButton;
	IBOutlet UIButton *twitterButton;
	IBOutlet UIButton *emailButton;
	IBOutlet UIButton *tumblrButton;
	IBOutlet UIButton *flickrButton;
	IBOutlet UIButton *instagramButton;
	IBOutlet UIButton *smsButton;
	IBOutlet UIButton *clipboardButton;
	IBOutlet UILabel *saveToCameraRollLabel;
    IBOutlet UISwitch *saveToRollSwitch;

    IBOutlet UIButton *helpTab;

    OFFlickrAPIRequest *flickrRequest;
	LoadingView *loadingView;
    LauchViewController *launchController;
    InputViewController *input;

}

@property(nonatomic,retain) IBOutlet UIButton *facebookButton;
@property(nonatomic,retain) IBOutlet UIButton *twitterButton;
@property(nonatomic,retain) IBOutlet UIButton *emailButton;
@property(nonatomic,retain) IBOutlet UIButton *tumblrButton;
@property(nonatomic,retain) IBOutlet UIButton *flickrButton;
@property(nonatomic,retain) IBOutlet UIButton *instagramButton;
@property(nonatomic,retain) IBOutlet UIButton *smsButton;
@property(nonatomic,retain) IBOutlet UIButton *clipboardButton;
@property(nonatomic,retain) IBOutlet UILabel *saveToCameraRollLabel;
@property(nonatomic,retain) IBOutlet UISwitch *saveToRollSwitch;

@property(nonatomic,retain) IBOutlet UIButton *helpTab;

-(IBAction)onClickFacebookButton;
-(IBAction)onClickTwitterButton;
-(IBAction)onClickInstagramButton;
-(IBAction)onClickEmailButton;
-(IBAction)onClickTumblrButton;
-(IBAction)onClickFlickrButton;
-(IBAction)onClickSMSButton;
-(IBAction)onClickClipboardButton;
-(IBAction)loadHelpController;
-(IBAction)makeEmail;
-(IBAction)OntwitterComments;
-(IBAction)onClickSaveToCameraRollSwitchButton;
-(void)gohelp;


@end
