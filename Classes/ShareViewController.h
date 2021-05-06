
//
// Created by Riksof Pvt. Ltd on 10/24/09.
//

#import <UIKit/UIKit.h>
//#import "GTLYouTube.h"
#import "VideoData.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "YouTubeUploadVideo.h"

#import "ShareKit.h"
#import "SHK.h"
#import "SHKSharer.h"
#import "SHKMail.h"
#import <SHKTwitter.h>
#import <SHKiOSTwitter.h>
#import "SHKTextMessage.h"
#import "SHKInstagram.h"
#import <Twitter/Twitter.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import "FlyerlySingleton.h"
#import "ParentViewController.h"
#import "FlyrViewController.h"
#import "Common.h"
#import "Flurry.h"
#import "HelpController.h"
#import "Flyer.h"
#import "SHKActivityIndicator.h"
#import "UIPlaceHolderTextView.h"
#import "YouTubeSubClass.h"
#import "CreateFlyerController.h"
#import <FBSDKShareKit/FBSDKSharing.h>
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>

#import "CreateFlyerController.h"
#import "FlyerlyMainScreen.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

//#import <UserReport/UserReport-Swift.h>

//@import UserReport;

@class FlyrViewController,FlyerlySingleton, CreateFlyerController, FlyerlyMainScreen;
@class SHKSharer;
@class SHKActivityIndicator;

@interface ShareViewController : UIViewController<FBSDKSharingDelegate, UIWebViewDelegate,UIDocumentInteractionControllerDelegate,UITextViewDelegate,UITextFieldDelegate, MFMailComposeViewControllerDelegate,YouTubeUploadVideoDelegate, UITextFieldDelegate, SHKSharerDelegate, MFMessageComposeViewControllerDelegate> {

    FlyerlySingleton *globle;
    NSArray *arrayOfAccounts;
    SHKSharer *iosSharer;
    
    BOOL hasSavedInGallary;//have we called saved in gallary from share screen

}

//@property (nonatomic, retain) GTLServiceYouTube *youtubeService;
@property(nonatomic, strong) YouTubeUploadVideo *uploadVideo;

@property(nonatomic,strong) IBOutlet UIPlaceHolderTextView *descriptionView;
@property (strong, nonatomic) IBOutlet UIImageView *titlePlaceHolderImg;
@property(nonatomic,strong) IBOutlet UITextField *titleView;
@property (strong, nonatomic) IBOutlet UIImageView *descTextAreaImg;


@property(nonatomic,strong) IBOutlet UIButton *facebookButton;
@property(nonatomic,strong) IBOutlet UIButton *twitterButton;
@property(nonatomic,strong) IBOutlet UIButton *emailButton;
@property(nonatomic,strong) IBOutlet UIButton *messengerButton;
@property(nonatomic,strong) IBOutlet UIButton *saveButton;
@property(nonatomic,strong) IBOutlet UIButton *printFlyerButton;
@property(nonatomic,strong) IBOutlet UIButton *instagramButton;
@property(nonatomic,strong) IBOutlet UIButton *smsButton;
@property(nonatomic,strong) IBOutlet UIButton *youTubeButton;
@property(nonatomic,strong) IBOutlet UIButton *clipboardButton;
@property(nonatomic,strong) IBOutlet UILabel *clipboardlabel;
@property(nonatomic,strong) IBOutlet UILabel *topTitleLabel;
@property(nonatomic,strong) NSString *Yvalue;
@property(nonatomic,strong) UIBarButtonItem *rightUndoBarButton;
@property(nonatomic,strong) UIButton *shareButton;
@property(nonatomic,strong) UIButton *backButton, *helpButton;

@property(nonatomic,strong) IBOutlet UIButton *flyerShareType;
@property(nonatomic,strong) IBOutlet UIButton *star1;
@property(nonatomic,strong) IBOutlet UIButton *star2;
@property(nonatomic,strong) IBOutlet UIButton *star3;
@property(nonatomic,strong) IBOutlet UIButton *star4;
@property(nonatomic,strong) IBOutlet UIButton *star5;


@property (nonatomic, retain) UIDocumentInteractionController *dicController;
@property (nonatomic,strong)UIImage *selectedFlyerImage;
@property (nonatomic,strong)NSString *selectedFlyerDescription;
@property (nonatomic,strong)NSString *imageFileName;
@property (nonatomic,weak)FlyrViewController *fvController;
@property (nonatomic,weak) CreateFlyerController *cfController;
@property (strong, nonatomic) SHKActivityIndicator *activityIndicator;
@property (nonatomic,strong) Flyer *flyer;
@property (weak, nonatomic) id<SHKSharerDelegate> delegate;
@property (nonatomic, assign) BOOL saveToGallaryReqBeforeSharing;

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) IBOutlet UITextView *tempTxtArea;

@property (nonatomic,weak) FlyerlyMainScreen *fmController;

@property (nonatomic,assign) NSInteger *indexRow;

- (IBAction)onClickMessengerButton:(id)sender;

-(IBAction)onClickFacebookButton;
-(IBAction)onClickTwitterButton;
-(IBAction)onClickInstagramButton;
-(IBAction)onClickEmailButton;
-(IBAction)onClickSaveButton;
-(IBAction)onPrintFlyerButton;
-(IBAction)onClickSMSButton;
-(IBAction)onClickClipboardButton;
-(IBAction)hideMe;
-(IBAction)clickOnStarRate:(id)sender;
-(IBAction)clickOnFlyerType:(id)sender;

-(IBAction)uploadOnYoutube:(id)sender;

-(void)shareOnInstagram;
-(void)setSocialStatus;
-(void)haveVideoLinkEnableAllShareOptions:(BOOL)enable;
-(void)enableShareOptions:(BOOL) enable;
-(void)saveButtonSelected:(BOOL)enable;
-(void)setStarsofShareScreen :(NSString *)rate;

-(void)setAllButtonSelected:(BOOL)selected;

@end
