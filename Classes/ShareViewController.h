
//
// Created by Riksof Pvt. Ltd on 10/24/09.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ShareKit.h"
#import "SHK.h"
#import "SHKSharer.h"
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
#import <QuartzCore/QuartzCore.h>
#import "FlyerlySingleton.h"
#import "ParentViewController.h"
#import "BitlyURLShortener.h"
#import "FlyrViewController.h"
#import "Common.h"
#import "LoadingView.h"
#import "JSON.h"
#import "Flurry.h"
#import "HelpController.h"
#import "Flyer.h"


@class FlyrViewController,FlyerlySingleton;
@class CreateFlyerController;
@class LoadingView;
@class SHKSharer;

@interface ShareViewController : ParentViewController<UIWebViewDelegate,UIDocumentInteractionControllerDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UITextViewDelegate,UITextFieldDelegate, BitlyURLShortenerDelegate,SHKSharerDelegate> {

	UIImage *selectedFlyerImage;
	NSString *selectedFlyerTitle;
	NSString *selectedFlyerDescription;
	NSString *detailFileName;
	NSString *imageFileName;
    FlyerlySingleton *globle;
	FlyrViewController *fvController;
	LoadingView *loadingView;
    UIDocumentInteractionController *dic;
    NSMutableArray  *photoTitles;         // Titles of images
    NSMutableArray  *photoSmallImageData; // Image data (thumbnail)
    NSMutableArray  *photoURLsLargeImage; // URL to larger image
	
    
    NSMutableArray *listOfPlaces;
    
    NSArray *arrayOfAccounts;
    
    SHKSharer *iosSharer;

}

@property(nonatomic,strong) NSMutableArray *listOfPlaces;
@property(nonatomic,strong)  NSString *sharelink;


@property(nonatomic, strong) BitlyURLShortener *bitly;
@property(nonatomic,strong) IBOutlet UIView *networkParentView;
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
@property(nonatomic,strong) IBOutlet UILabel *topTitleLabel;
@property (nonatomic, strong) UIDocumentInteractionController *dic;
@property(nonatomic,strong)UIImage *selectedFlyerImage;
@property(nonatomic,strong)NSString *selectedFlyerTitle;
@property(nonatomic,strong)NSString *selectedFlyerDescription;
@property(nonatomic,strong)NSString *detailFileName;
@property(nonatomic,strong)NSString *imageFileName;
@property(nonatomic,weak)FlyrViewController *fvController;
@property (nonatomic, strong) LoadingView *loadingView;

@property (nonatomic,strong) Flyer *flyer;


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
-(void)singleshareOnMMS;
- (void)uploadImage:(NSData *)imageData isEmail:(BOOL)isEmail;
-(void)shareOnEmail:(NSString *)link;
-(void)shortenURL:(NSString *)url;
-(void)setSocialStatus;

@property (weak, nonatomic) id<SHKSharerDelegate> delegate;
@end
