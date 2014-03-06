
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
#import "FlyrViewController.h"
#import "Common.h"
#import "JSON.h"
#import "Flurry.h"
#import "HelpController.h"
#import "Flyer.h"
#import "SHKActivityIndicator.h"


@class FlyrViewController,FlyerlySingleton;
@class SHKSharer;
@class SHKActivityIndicator;

@interface ShareViewController : UIViewController<UIWebViewDelegate,UIDocumentInteractionControllerDelegate,UITextViewDelegate,UITextFieldDelegate, SHKSharerDelegate> {

    FlyerlySingleton *globle;
    NSArray *arrayOfAccounts;
    SHKSharer *iosSharer;

}


@property(nonatomic,strong) IBOutlet UITextView *descriptionView;
@property(nonatomic,strong) IBOutlet UITextField *titleView;
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
@property(nonatomic,strong) NSString *Yvalue;
@property(nonatomic,strong) UIBarButtonItem *rightUndoBarButton;
@property (nonatomic, strong) UIDocumentInteractionController *dicController;
@property(nonatomic,strong)UIImage *selectedFlyerImage;
@property(nonatomic,strong)NSString *selectedFlyerDescription;
@property(nonatomic,strong)NSString *imageFileName;
@property(nonatomic,weak)FlyrViewController *fvController;
@property (strong, nonatomic) SHKActivityIndicator *activityIndicator;
@property (nonatomic,strong) Flyer *flyer;
@property (weak, nonatomic) id<SHKSharerDelegate> delegate;

-(IBAction)onClickFacebookButton;
-(IBAction)onClickTwitterButton;
-(IBAction)onClickInstagramButton;
-(IBAction)onClickEmailButton;
-(IBAction)onClickTumblrButton;
-(IBAction)onClickFlickrButton;
-(IBAction)onClickSMSButton;
-(IBAction)onClickClipboardButton;
-(IBAction)hideMe;


-(void)shareOnInstagram;
-(void)setSocialStatus;





@end
