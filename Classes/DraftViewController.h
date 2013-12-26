//
//  DraftViewController.h
//  Flyr
//
//  Created by Krunal on 10/24/09.
//  Copyright 2009 iauro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareKit.h"
#import "SHK.h"
#import "SHKMail.h"
#import "SHKFacebook.h"
#import "SHKTwitter.h"
#import "SHKInstagram.h"
#import "SHKFlickr.h"
#import "SHKTumblr.h"

#import "MyNavigationBar.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Twitter/Twitter.h>
#import "TumblrUploadr.h"
#import "ObjectiveFlickr.h"
#import <MessageUI/MessageUI.h>
#import "ShareProgressView.h"
#import "OLBTwitpicEngine.h"
#import "BitlyURLShortener.h"
#import "LauchViewController.h"
#import "Singleton.h"
#import "ParentViewController.h"
#import "FlyerOverlayController.h"

@class FlyrViewController,LauchViewController,Singleton;
@class SaveFlyerController,PhotoController;
@class LoadingView;

@interface DraftViewController : ParentViewController<UIWebViewDelegate,UIDocumentInteractionControllerDelegate,TumblrUploadrDelegate,OFFlickrAPIRequestDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UITextViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,OLBTwitpicEngineDelegate,BitlyURLShortenerDelegate, UIActionSheetDelegate> {

	IBOutlet UIScrollView *scrollView;

	IBOutlet UIButton *imgView;
	IBOutlet UITextField *titleView;
	IBOutlet UITextView *descriptionView;

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
	IBOutlet UIButton *locationBackground;
	IBOutlet UIButton *locationButton;
	IBOutlet UILabel *locationLabel;
	IBOutlet UIView *networkParentView;

	UIImage *selectedFlyerImage;
	NSString *selectedFlyerTitle;
	NSString *selectedFlyerDescription;
	NSString *detailFileName;
	NSString *imageFileName;
    Singleton *globle;
	MyNavigationBar *navBar;
	FlyrViewController *fvController;
    FlyerOverlayController *overlayController;
	SaveFlyerController *svController;
	LoadingView *loadingView;
    LauchViewController  *launchController;
    UIDocumentInteractionController *dic;
    BOOL showbars;
    NSMutableArray  *photoTitles;         // Titles of images
    NSMutableArray  *photoSmallImageData; // Image data (thumbnail)
    NSMutableArray  *photoURLsLargeImage; // URL to larger image
	OFFlickrAPIRequest *flickrRequest;
    
    BOOL fromPhotoController;
    int countOfSharingNetworks;
    ShareProgressView *instagramPogressView;
    
    OLBTwitpicEngine *twit;
    NSMutableArray *listOfPlaces;
    
    NSArray *arrayOfAccounts;
}

@property(nonatomic,strong) NSMutableArray *listOfPlaces;
@property(nonatomic,strong)  NSString *sharelink;

/*@property(nonatomic,retain) IBOutlet UIView *progressView;
@property(nonatomic,retain) ShareProgressView *facebookPogressView;
@property(nonatomic,retain) ShareProgressView *twitterPogressView;
@property(nonatomic,retain) ShareProgressView *tumblrPogressView;
@property(nonatomic,retain) ShareProgressView *flickrPogressView;
@property(nonatomic,retain) ShareProgressView *instagramPogressView;*/

@property(nonatomic,strong) IBOutlet UILabel *saveToCameraRollLabel;
@property(nonatomic,strong) IBOutlet UISwitch *saveToRollSwitch;
@property(nonatomic,strong) IBOutlet UILabel *locationLabel;
@property(nonatomic,strong) IBOutlet UIButton *locationBackground;
@property(nonatomic,strong) IBOutlet UIView *networkParentView;
@property(nonatomic,strong) IBOutlet UIButton *locationButton;

@property(nonatomic,strong) IBOutlet UIScrollView *scrollView;

@property(nonatomic,strong) IBOutlet UITextView *descriptionView;
@property(nonatomic,strong) IBOutlet UITextField *titleView;
@property(nonatomic,strong) IBOutlet UIButton *imgView;

@property(nonatomic,strong) IBOutlet UIButton *facebookButton;
@property(nonatomic,strong) IBOutlet UIButton *twitterButton;
@property(nonatomic,strong) IBOutlet UIButton *emailButton;
@property(nonatomic,strong) IBOutlet UIButton *tumblrButton;
@property(nonatomic,strong) IBOutlet UIButton *flickrButton;
@property(nonatomic,strong) IBOutlet UIButton *instagramButton;
@property(nonatomic,strong) IBOutlet UIButton *smsButton;
@property(nonatomic,strong) IBOutlet UIButton *clipboardButton;
@property(nonatomic,strong) IBOutlet UILabel *clipboardlabel;

@property (nonatomic, strong) UIDocumentInteractionController *dic;

@property(nonatomic,strong)UIImage *selectedFlyerImage;
@property(nonatomic,strong)NSString *selectedFlyerTitle;
@property(nonatomic,strong)NSString *selectedFlyerDescription;
@property(nonatomic,strong)NSString *detailFileName;
@property(nonatomic,strong)NSString *imageFileName;

@property(nonatomic,strong) MyNavigationBar *navBar;
@property(nonatomic,strong)FlyrViewController *fvController;
@property(nonatomic,strong)SaveFlyerController *svController;
@property (nonatomic, strong) LoadingView *loadingView;
@property BOOL fromPhotoController;

@property (nonatomic, strong) OLBTwitpicEngine *twit;
@property(nonatomic, strong) BitlyURLShortener *bitly;

-(IBAction)onClickFacebookButton;
-(IBAction)onClickTwitterButton;
-(IBAction)onClickInstagramButton;
-(IBAction)onClickEmailButton;
-(IBAction)onClickTumblrButton;
-(IBAction)onClickFlickrButton;
-(IBAction)onClickSMSButton;
-(IBAction)onClickClipboardButton;
-(IBAction)searchNearByLocations;

- (BOOL)uploadImageStream:(NSInputStream *)inImageStream suggestedFilename:(NSString *)inFilename MIMEType:(NSString *)inType arguments:(NSDictionary *)inArguments;

-(IBAction)goback;
-(void)share;
-(void)shareOnInstagram;

-(void)updateSocialStates;

-(void)showFacebookProgressRow;
-(void)showTwitterProgressRow;
-(void)showTumblrProgressRow;
-(void)showFlickrProgressRow;
-(void)showInstagramProgressRow;
-(void)showclipBdProgressRow;
-(void)showsmsProgressRow;
-(void)showemailProgressRow;
-(void)onclipBdSuccess;
-(void)onemailSuccess;
-(void)onemailFailed;
-(void)onsmsSuccess;
-(void)SingleshareOnMMS;
-(void)onsmsFailed;
-(void)openInstagramSuccess;
-(void)openInstagramFailed;
-(void)fillErrorStatus:(ShareProgressView *)shareView;
-(void)fillSuccessStatus:(ShareProgressView *)shareView;
-(void)closeSharingProgressSuccess:(NSNotification *)notification;
- (void)uploadImage:(NSData *)imageData isEmail:(BOOL)isEmail;
- (void)uploadImageByboth:(NSData *)imageData;

-(void)shareOnEmail:(NSString *)link;
-(void)shortenURL:(NSString *)url;
@end
