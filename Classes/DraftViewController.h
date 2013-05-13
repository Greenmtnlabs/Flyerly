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

@class FlyrViewController;
@class SaveFlyerController;
@class LoadingView;

@interface DraftViewController : UIViewController<FBRequestDelegate,UIWebViewDelegate,UIDocumentInteractionControllerDelegate,FBSessionDelegate,FBDialogDelegate,FBLoginDialogDelegate,TumblrUploadrDelegate,OFFlickrAPIRequestDelegate> {

	IBOutlet UIImageView *imgView;
	IBOutlet UITextField *titleView;
	IBOutlet UILabel *descriptionView;

    IBOutlet UIButton *facebookButton;
	IBOutlet UIButton *twitterButton;
	IBOutlet UIButton *emailButton;
	IBOutlet UIButton *tumblrButton;
	IBOutlet UIButton *flickrButton;
	IBOutlet UIButton *instagramButton;
	IBOutlet UIButton *smsButton;
	IBOutlet UIButton *clipboardButton;

	UIImage *selectedFlyerImage;
	NSString *selectedFlyerTitle;
	NSString *selectedFlyerDescription;
	NSString *detailFileName;
	NSString *imageFileName;
    
	MyNavigationBar *navBar;
	FlyrViewController *fvController;
	SaveFlyerController *svController;
	LoadingView *loadingView;
    UIDocumentInteractionController *dic;
    
    NSMutableArray  *photoTitles;         // Titles of images
    NSMutableArray  *photoSmallImageData; // Image data (thumbnail)
    NSMutableArray  *photoURLsLargeImage; // URL to larger image
	//OFFlickrAPIContext *flickrContext;
	OFFlickrAPIRequest *flickrRequest;
}
@property(nonatomic,retain) IBOutlet UILabel *descriptionView;
@property(nonatomic,retain) IBOutlet UITextField *titleView;
@property(nonatomic,retain) IBOutlet UIImageView *imgView;

@property(nonatomic,retain) IBOutlet UIButton *facebookButton;
@property(nonatomic,retain) IBOutlet UIButton *twitterButton;
@property(nonatomic,retain) IBOutlet UIButton *emailButton;
@property(nonatomic,retain) IBOutlet UIButton *tumblrButton;
@property(nonatomic,retain) IBOutlet UIButton *flickrButton;
@property(nonatomic,retain) IBOutlet UIButton *instagramButton;
@property(nonatomic,retain) IBOutlet UIButton *smsButton;
@property(nonatomic,retain) IBOutlet UIButton *clipboardButton;
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

-(IBAction)onClickFacebookButton;
-(IBAction)onClickTwitterButton;
-(IBAction)onClickInstagramButton;
-(IBAction)onClickEmailButton;
-(IBAction)onClickTumblrButton;
-(IBAction)onClickFlickrButton;
-(IBAction)onClickSMSButton;
-(IBAction)onClickClipboardButton;

@end
