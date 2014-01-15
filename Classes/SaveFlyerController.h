//
//  SaveFlyerController.h
//  Flyr
//
//  Created by Krunal on 10/27/09.
//  Copyright 2009 iauro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "MyNavigationBar.h"
#import "PhotoController.h"
#import "TwitLogin.h"
#import <MessageUI/MessageUI.h>

@class DraftViewController;
@class FBSession;

@interface SaveFlyerController : UIViewController<MFMailComposeViewControllerDelegate,UIAlertViewDelegate,UIAlertViewDelegate,UITextFieldDelegate> {


	UIImage *flyrImg;
	UIButton *twitterButton;
	UIButton  *mailButton;
	UIButton *faceBookButton;
	FBSession* _session;
	
	UIButton *uploadButton;
	MyNavigationBar *navBar;
	NSString *twitMsg;
	PhotoController *ptController;

	NSString *twitUser;
	NSString *twitPass;
	UIAlertView *twitAlert;
	UIAlertView *facebookAlert;
	BOOL isDraftView;
	DraftViewController *dvController;
	TwitLogin *twitDialog;
	NSData *flyrImgData;
	UITextField *alertTextField ;
	FBRequest *uploadPhotoRequest;
	NSString *imgName;
}
@property(nonatomic,strong)UIImage *flyrImg;
@property (nonatomic, strong) UIButton *twitterButton;
@property (nonatomic, strong) UIButton  *mailButton;
@property (nonatomic, strong) UIButton *faceBookButton;
@property (nonatomic, strong) UIButton *uploadButton;

//@property (nonatomic, strong) MyNavigationBar *navBar;
//@property(nonatomic, strong) OLBTwitpicEngine *twit;
@property(nonatomic, strong) NSString *twitMsg;
@property(nonatomic, strong) PhotoController *ptController;
@property(nonatomic, strong) NSString *twitUser;
@property(nonatomic, strong) NSString *twitPass;
@property(nonatomic, strong)  UIAlertView *twitAlert;
@property(nonatomic, strong)  UIAlertView *facebookAlert;
@property (nonatomic,assign) BOOL isDraftView;
@property (nonatomic,strong) DraftViewController *dvController;
@property (nonatomic,strong) TwitLogin *twitDialog;
@property (nonatomic,strong)  NSData *flyrImgData;
@property (nonatomic,strong)  FBSession* _session;
@property (nonatomic,strong)  UITextField *alertTextField;
@property (nonatomic,strong) NSString *imgName;
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

