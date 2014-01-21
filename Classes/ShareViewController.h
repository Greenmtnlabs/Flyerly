//
//  DraftViewController.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd on 10/24/09.
//  Copyright 2009 iauro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareKit.h"
#import "SHK.h"
#import "SHKMail.h"
#import "SHKFacebook.h"
#import "SHKTwitter.h"
#import "SHKTextMessage.h"
#import "SHKInstagram.h"
#import "SHKFlickr.h"
#import "SHKTumblr.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Twitter/Twitter.h>
#import <MessageUI/MessageUI.h>
#import "FlyerlySingleton.h"
#import "ParentViewController.h"
#import "BitlyURLShortener.h"

@class FlyrViewController,FlyerlySingleton;
@class SaveFlyerController,CreateFlyerController;
@class LoadingView;

@interface ShareViewController : ParentViewController<UIWebViewDelegate,UIDocumentInteractionControllerDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UITextViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate, BitlyURLShortenerDelegate,UIActionSheetDelegate> {

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
    FlyerlySingleton *globle;
	FlyrViewController *fvController;
	SaveFlyerController *svController;
	LoadingView *loadingView;
    UIDocumentInteractionController *dic;
    BOOL showbars;
    NSMutableArray  *photoTitles;         // Titles of images
    NSMutableArray  *photoSmallImageData; // Image data (thumbnail)
    NSMutableArray  *photoURLsLargeImage; // URL to larger image
	OFFlickrAPIRequest *flickrRequest;
    
    int countOfSharingNetworks;
    
    NSMutableArray *listOfPlaces;
    
    NSArray *arrayOfAccounts;
}

@property(nonatomic,strong) NSMutableArray *listOfPlaces;
@property(nonatomic,strong)  NSString *sharelink;


@property(nonatomic, strong) BitlyURLShortener *bitly;
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

@property(nonatomic,strong)FlyrViewController *fvController;
@property(nonatomic,strong)SaveFlyerController *svController;
@property (nonatomic, strong) LoadingView *loadingView;


-(IBAction)onClickFacebookButton;
-(IBAction)onClickTwitterButton;
-(IBAction)onClickInstagramButton;
-(IBAction)onClickEmailButton;
-(IBAction)onClickTumblrButton;
-(IBAction)onClickFlickrButton;
-(IBAction)onClickSMSButton;
-(IBAction)onClickClipboardButton;


-(IBAction)goback;
-(void)shareOnInstagram;

-(void)updateSocialStates;

-(void)SingleshareOnMMS;
- (void)uploadImage:(NSData *)imageData isEmail:(BOOL)isEmail;
- (void)uploadImageByboth:(NSData *)imageData;

-(void)shareOnEmail:(NSString *)link;
-(void)shortenURL:(NSString *)url;
@end
