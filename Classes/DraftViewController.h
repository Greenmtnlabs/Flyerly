//
//  DraftViewController.h
//  Flyr
//
//  Created by Krunal on 10/24/09.
//  Copyright 2009 iauro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "FBConnect/FBConnect.h"
#import <Twitter/Twitter.h>
#import "TumblrUploadr.h"
#import <ObjectiveFlickr.h>
#import <MessageUI/MessageUI.h>
#import "ShareProgressView.h"
#import "OLBTwitpicEngine.h"
#import "BitlyURLShortener.h"
#import "LauchViewController.h"
#import "Singleton.h"

@class FlyrViewController,LauchViewController,Singleton;
@class SaveFlyerController;
@class LoadingView;

@interface DraftViewController : UIViewController<FBRequestDelegate,UIWebViewDelegate,UIDocumentInteractionControllerDelegate,FBSessionDelegate,FBDialogDelegate,FBLoginDialogDelegate,TumblrUploadrDelegate,OFFlickrAPIRequestDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UITextViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,OLBTwitpicEngineDelegate,BitlyURLShortenerDelegate> {

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
	SaveFlyerController *svController;
	LoadingView *loadingView;
    LauchViewController  *launchController;
    UIDocumentInteractionController *dic;
    BOOL showbars;
    NSMutableArray  *photoTitles;         // Titles of images
    NSMutableArray  *photoSmallImageData; // Image data (thumbnail)
    NSMutableArray  *photoURLsLargeImage; // URL to larger image
	//OFFlickrAPIContext *flickrContext;
	OFFlickrAPIRequest *flickrRequest;
    
    BOOL fromPhotoController;
    int countOfSharingNetworks;
	/*IBOutlet UIView *progressView;
    ShareProgressView *facebookPogressView;
    ShareProgressView *twitterPogressView;
    ShareProgressView *tumblrPogressView;
    ShareProgressView *flickrPogressView;*/
    ShareProgressView *instagramPogressView;
    
    OLBTwitpicEngine *twit;
    NSMutableArray *listOfPlaces;
}

@property(nonatomic,retain) NSMutableArray *listOfPlaces;
@property(nonatomic,strong)  NSString *sharelink;

/*@property(nonatomic,retain) IBOutlet UIView *progressView;
@property(nonatomic,retain) ShareProgressView *facebookPogressView;
@property(nonatomic,retain) ShareProgressView *twitterPogressView;
@property(nonatomic,retain) ShareProgressView *tumblrPogressView;
@property(nonatomic,retain) ShareProgressView *flickrPogressView;
@property(nonatomic,retain) ShareProgressView *instagramPogressView;*/

@property(nonatomic,retain) IBOutlet UILabel *saveToCameraRollLabel;
@property(nonatomic,retain) IBOutlet UISwitch *saveToRollSwitch;
@property(nonatomic,retain) IBOutlet UILabel *locationLabel;
@property(nonatomic,retain) IBOutlet UIButton *locationBackground;
@property(nonatomic,retain) IBOutlet UIView *networkParentView;
@property(nonatomic,retain) IBOutlet UIButton *locationButton;

@property(nonatomic,retain) IBOutlet UIScrollView *scrollView;

@property(nonatomic,retain) IBOutlet UITextView *descriptionView;
@property(nonatomic,retain) IBOutlet UITextField *titleView;
@property(nonatomic,retain) IBOutlet UIButton *imgView;

@property(nonatomic,retain) IBOutlet UIButton *facebookButton;
@property(nonatomic,retain) IBOutlet UIButton *twitterButton;
@property(nonatomic,retain) IBOutlet UIButton *emailButton;
@property(nonatomic,retain) IBOutlet UIButton *tumblrButton;
@property(nonatomic,retain) IBOutlet UIButton *flickrButton;
@property(nonatomic,retain) IBOutlet UIButton *instagramButton;
@property(nonatomic,retain) IBOutlet UIButton *smsButton;
@property(nonatomic,retain) IBOutlet UIButton *clipboardButton;
@property(nonatomic,retain) IBOutlet UILabel *clipboardlabel;

@property (nonatomic, retain) UIDocumentInteractionController *dic;

@property(nonatomic,retain)UIImage *selectedFlyerImage;
@property(nonatomic,retain)NSString *selectedFlyerTitle;
@property(nonatomic,retain)NSString *selectedFlyerDescription;
@property(nonatomic,retain)NSString *detailFileName;
@property(nonatomic,retain)NSString *imageFileName;

@property(nonatomic,retain) MyNavigationBar *navBar;
@property(nonatomic,retain)FlyrViewController *fvController;
@property(nonatomic,retain)SaveFlyerController *svController;
@property (nonatomic, retain) LoadingView *loadingView;
@property BOOL fromPhotoController;

@property (nonatomic, retain) OLBTwitpicEngine *twit;
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
