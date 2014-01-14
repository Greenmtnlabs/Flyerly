//
//  SettingViewController.h
//  Exchange
//
//  Created by krunal on 18/08/09.
//  Copyright 2009 iauro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import "ObjectiveFlickr.h"
#import "LauchViewController.h"
#import "InputViewController.h"
#import "ParentViewController.h"
#import "Singleton.h"

@class LauchViewController,InputViewController,Singleton;
@interface SettingViewController : ParentViewController <OFFlickrAPIRequestDelegate, MFMailComposeViewControllerDelegate> {
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
    Singleton *globle;
    OFFlickrAPIRequest *flickrRequest;
    LauchViewController *launchController;
}

@property(nonatomic,strong) IBOutlet UIButton *facebookButton;
@property(nonatomic,strong) IBOutlet UIButton *twitterButton;
@property(nonatomic,strong) IBOutlet UIButton *emailButton;
@property(nonatomic,strong) IBOutlet UIButton *tumblrButton;
@property(nonatomic,strong) IBOutlet UIButton *flickrButton;
@property(nonatomic,strong) IBOutlet UIButton *instagramButton;
@property(nonatomic,strong) IBOutlet UIButton *smsButton;
@property(nonatomic,strong) IBOutlet UIButton *clipboardButton;
@property(nonatomic,strong) IBOutlet UILabel *saveToCameraRollLabel;
@property(nonatomic,strong) IBOutlet UISwitch *saveToRollSwitch;

@property(nonatomic,strong) IBOutlet UIButton *helpTab;

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
-(IBAction)RateApp:(id)sender;
-(void)gohelp;


@end
