//
//  SaveFlyerController.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd on 10/27/09.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "CreateFlyerController.h"
#import <MessageUI/MessageUI.h>

@class ShareViewController;
@class FBSession;

@interface SaveFlyerController : UIViewController<MFMailComposeViewControllerDelegate,UIAlertViewDelegate,UIAlertViewDelegate,UITextFieldDelegate> {


	UIImage *flyrImg;
	UIButton *twitterButton;
	UIButton  *mailButton;
	UIButton *faceBookButton;
	FBSession* _session;
	
	UIButton *uploadButton;
	NSString *twitMsg;
	CreateFlyerController *ptController;

	NSString *twitUser;
	NSString *twitPass;
	UIAlertView *twitAlert;
	UIAlertView *facebookAlert;
	BOOL isDraftView;
	ShareViewController *dvController;
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

@property(nonatomic, strong) NSString *twitMsg;
@property(nonatomic, strong) CreateFlyerController *ptController;
@property(nonatomic, strong) NSString *twitUser;
@property(nonatomic, strong) NSString *twitPass;
@property(nonatomic, strong)  UIAlertView *twitAlert;
@property(nonatomic, strong)  UIAlertView *facebookAlert;
@property (nonatomic,assign) BOOL isDraftView;
@property (nonatomic,strong) ShareViewController *dvController;
@property (nonatomic,strong)  NSData *flyrImgData;
@property (nonatomic,strong)  FBSession* _session;
@property (nonatomic,strong)  UITextField *alertTextField;
@property (nonatomic,strong) NSString *imgName;

-(void)callTwitAlert;
-(void)callFacebookAlert;
-(void)uploadPhoto;

@end

