//
//  SaveFlyerController.h
//  Flyr
//
//  Created by Krunal on 10/27/09.
//  Copyright 2009 iauro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "FBConnect/FBConnect.h"
#import "MyNavigationBar.h"
#import "OLBTwitpicEngine.h"
#import "PhotoController.h"
#import "TwitLogin.h"
#import <MessageUI/MessageUI.h>
#import "HudView.h"

@class DraftViewController;
@class FBSession;

@interface SaveFlyerController : UIViewController<MFMailComposeViewControllerDelegate,FBDialogDelegate, FBSessionDelegate, FBRequestDelegate,UIAlertViewDelegate,UIAlertViewDelegate,UITextFieldDelegate> {


	UIImage *flyrImg;
	UIButton *twitterButton;
	UIButton  *mailButton;
	UIButton *faceBookButton;
	FBSession* _session;
	
	UIButton *uploadButton;
	MyNavigationBar *navBar;
	OLBTwitpicEngine *twit;
	NSString *twitMsg;
	PhotoController *ptController;

	NSString *twitUser;
	NSString *twitPass;
	UIAlertView *twitAlert;
	UIAlertView *facebookAlert;
	HudView *aHUD;
	BOOL isDraftView;
	DraftViewController *dvController;
	TwitLogin *twitDialog;
	NSData *flyrImgData;
	UITextField *alertTextField ;
	FBRequest *uploadPhotoRequest;
	NSString *imgName;
}
@property(nonatomic,retain)UIImage *flyrImg;
@property (nonatomic, retain) UIButton *twitterButton;
@property (nonatomic, retain) UIButton  *mailButton;
@property (nonatomic, retain) UIButton *faceBookButton;
@property (nonatomic, retain) UIButton *uploadButton;
@property (nonatomic, retain) MyNavigationBar *navBar;
@property(nonatomic, retain) OLBTwitpicEngine *twit;
@property(nonatomic, retain) NSString *twitMsg;
@property(nonatomic, retain) PhotoController *ptController;
@property(nonatomic, retain) NSString *twitUser;
@property(nonatomic, retain) NSString *twitPass;
@property(nonatomic, retain)  UIAlertView *twitAlert;
@property(nonatomic, retain)  UIAlertView *facebookAlert;
@property (nonatomic,retain) HudView *aHUD;
@property (nonatomic,assign) BOOL isDraftView;
@property (nonatomic,retain) DraftViewController *dvController;
@property (nonatomic,retain) TwitLogin *twitDialog;
@property (nonatomic,retain)  NSData *flyrImgData;
@property (nonatomic,retain)  FBSession* _session;
@property (nonatomic,retain)  UITextField *alertTextField;
@property (nonatomic,retain) NSString *imgName;
- (void)showHUD;
- (void)killHUD;

-(void)callTwitAlert;
-(void)callFacebookAlert;
-(void)uploadPhoto;
- (void)dismissNavBar:(BOOL)animated;
-(IBAction)disableBack;
-(void)enableBack;
//-(IBAction)createTwitLogin:(id)sender;
@end

