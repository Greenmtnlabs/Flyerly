
//  Flyer
//
//  Created by Riksof Pvt. Ltd on 12/10/09.
//
//

#import <Foundation/Foundation.h>
#import <NBUKit/NBUKit.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CustomLabel.h"
#import "ParentViewController.h"
#import "CameraViewController.h"
#import "Flyer.h"
#import "FlyerImageView.h"
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "Common.h"
#import "FlyrAppDelegate.h"
#import "ShareViewController.h"
#import "HelpController.h"
#import "LoadingView.h"
#import "Flurry.h"
#import "SKProduct+LocalPrice.h"
#import "LayerTileButton.h"
#import "InAppViewController.h"
#import "SigninController.h"
#import "LibraryViewController.h"
#import "ResourcesView.h"
#import "UIPlaceHolderTextView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "GADInterstitialDelegate.h"
#import "GADBannerView.h"


#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

//Drawing required files
//#import "DrawingView.h"

//DrawingClass required files
#import "SettingsViewController.h"



@class FlyerlySingleton, Flyer, FlyerImageView, ShareViewController, SigninController,InAppViewController,PrintViewController;
@interface CreateFlyerController :ParentViewController<UITextFieldDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, FlyerImageViewDelegate,UIGestureRecognizerDelegate,InAppPurchasePanelButtonProtocol, UserPurchasesDelegate, GADInterstitialDelegate, GADBannerViewDelegate>

{
    PrintViewController *printViewController;
    InAppViewController *inappviewcontroller;
    UIActivityIndicatorView *uiBusy;
    
    UIScrollView *layerScrollView;
    NSInteger imgPickerFlag;
    
	NSMutableArray *templateArray;
	NSMutableArray *iconArray;
	NSMutableArray *symbolArray;
	NSArray *colorArray;
	NSArray *borderArray;
	NSArray *fontArray;
    int layerXposition;
    
    NSInteger widthValue;
	NSInteger heightValue;
    
    LayerTileButton *editButtonGlobal;
    UIBarButtonItem *rightUndoBarButton;
    UIButton *shareButton;

    UIButton *backButton;
    UIButton *helpButton;
    
    UITextView *lastTextView;
    SigninController *signInController;
    ShareViewController *shareviewcontroller;
    UILabel *titleLabel;
    UIImage *videolastImage;
    BOOL *isPlaying;
    BOOL *isVideoReadyForShare;
    BOOL *panelWillOpen;
    float videoDuration;
    
    //Drawing required vars
    //DrawingView *drawingView;
    //UIImageView *displayView;
    
    //DrawingClass required vars
    CGPoint dw_lastPoint;
    CGFloat dw_red;
    CGFloat dw_green;
    CGFloat dw_blue;
    CGFloat dw_brush;
    NSString *dw_brushType;
    CGFloat dw_opacity;
    NSString *dw_drawingLayerMode;
    BOOL dw_mouseSwiped;
    
    //HANDLER FOR IF WE ADD NEW D/W LAYER AND DIDN'T PERFORM ANY THING AND PRESSED (DONE,BACK) SO delete THAT LAYER
    //IF THAT IS OLD LAYER SO KEEP LAYER BUT DO NOT DELETE LAYER
    BOOL dw_layer_save;
    BOOL dw_isOldLayer;
    
    BOOL bannerAddClosed;
    BOOL bannerShowed; //keep bolean we have rendered banner or not ?
}

@property(nonatomic, strong) GADInterstitial *interstitialAdd;

//-----
@property (nonatomic, strong) ResourcesView *backgroundsView;
@property (nonatomic, strong) ResourcesView *flyerBordersView;
@property (nonatomic, strong) UIView *fontsView;
@property (nonatomic, strong) ResourcesView *colorsView;
@property (nonatomic, strong) ResourcesView *sizesView;
@property (nonatomic, strong) ResourcesView *textBordersView;
@property (nonatomic, strong) ResourcesView *drawingPatternsView;
@property (nonatomic, strong) ResourcesView *drawingEraserMsgView;
//-----

@property (nonatomic,strong)  IBOutlet UILabel *takeOrAddPhotoLabel;
@property (nonatomic,strong)  IBOutlet UILabel *videoLabel;
@property (nonatomic,strong)  IBOutlet UILabel *addMoreLayerOrSaveFlyerLabel;

@property (nonatomic, strong) UIScrollView *layerScrollView;
@property (nonatomic, strong) UIFont *selectedFont;
@property (nonatomic, weak) id selectedColor;
@property (nonatomic, assign) NSInteger selectedSize;
@property (nonatomic, strong) UIImage *selectedTemplate;
@property (nonatomic, strong) UIAlertView *deleteAlert;
@property (nonatomic, strong) UIAlertView *signInAlert;
@property (nonatomic, strong) UIAlertView *waterMarkPurchasingAlert;
@property (nonatomic, strong) UIAlertView *spaceUnavailableAlert;
@property (nonatomic, assign) NSInteger imgPickerFlag;
@property (nonatomic, strong) NSString *flyerPath;
@property (nonatomic, strong) IBOutlet FlyerImageView *flyimgView;
@property (nonatomic, strong) UIView *sharePanel;

@property (weak, nonatomic) IBOutlet GADBannerView *bannerAdsView;

@property (nonatomic, retain) UIDocumentInteractionController *dicController;

// These are ContextViews Library
@property(nonatomic, strong) IBOutlet UIView *contextView;
@property(nonatomic, strong) IBOutlet UIView *libraryContextView;
@property(nonatomic, strong) IBOutlet UIView *libFlyer;
@property(nonatomic, strong) IBOutlet UIView *libBackground;
@property(nonatomic, strong) IBOutlet UIView *libText;
@property(nonatomic, strong) IBOutlet UIView *libArts;
@property(nonatomic, strong) IBOutlet UIView *libPhoto;
@property(nonatomic, strong) IBOutlet UIView *libEmpty;
@property(nonatomic, strong) IBOutlet UIView *playerView;
@property(nonatomic, strong) IBOutlet UIView *playerToolBar;
@property(nonatomic, strong) IBOutlet UIView *libDrawing;

//--------
@property(nonatomic, strong) IBOutlet UIView *tempelateView;
//---------

// These are LibFlyer
@property (nonatomic, strong)IBOutlet UIButton *addMoreFontTabButton;
@property (nonatomic, strong)IBOutlet UIButton *addMorePhotoTabButton;
@property (nonatomic, strong)IBOutlet UIButton *addVideoTabButton;
@property (nonatomic, strong)IBOutlet UIButton *addArtsTabButton;
@property (nonatomic, strong)IBOutlet UIButton *backgroundTabButton;


//These are LibBackground
@property (nonatomic, strong)IBOutlet UIButton *backtemplates;
@property (nonatomic, strong)IBOutlet UIButton *cameraTakePhoto;
@property (nonatomic, strong)IBOutlet UIButton *cameraRoll;
@property (nonatomic, strong)IBOutlet UIButton *flyerBorder;
@property (nonatomic, strong)IBOutlet UIButton *giphyBgBtn;

//These are LibText
@property (nonatomic, strong)IBOutlet UIButton *fontTabButton;
@property (nonatomic, strong)IBOutlet UIButton *colorTabButton;
@property (nonatomic, strong)IBOutlet UIButton *sizeTabButton;
@property (nonatomic, strong)IBOutlet UIButton *fontBorderTabButton;
@property (nonatomic, strong)IBOutlet UIButton *fontEditButton;

//These are drawing tab buttons
@property (nonatomic, strong)IBOutlet UIButton *drawingColorTabButton;
@property (nonatomic, strong)IBOutlet UIButton *drawingPatternTabButton;
@property (nonatomic, strong)IBOutlet UIButton *drawingSizeTabButton;
@property (nonatomic, strong)IBOutlet UIButton *drawingEraserTabButton;

//Lables in xib for eraser(drawing sub tab) 
@property (nonatomic, strong)IBOutlet UITextView *drawingEraserMsg;


//These are Art Tab Buttons
@property (nonatomic, strong)IBOutlet UIButton *clipArtTabButton;
@property (nonatomic, strong)IBOutlet UIButton *emoticonsTabButton;
@property (nonatomic, strong)IBOutlet UIButton *drawingMenueButton;
@property (nonatomic, strong)IBOutlet UIButton *artsColorTabButton;
@property (nonatomic, strong)IBOutlet UIButton *artsSizeTabButton;

//These are LibPhoto
@property (nonatomic,strong)IBOutlet UIButton *cameraTabButton;
@property (nonatomic,strong)IBOutlet UIButton *photoTabButton;
@property (nonatomic,strong)IBOutlet UIButton *widthTabButton;
@property (nonatomic,strong)IBOutlet UIButton *heightTabButton;
@property (nonatomic,strong)IBOutlet UIButton *playButton;
@property (nonatomic,strong)IBOutlet UISlider *playerSlider;
@property (nonatomic,strong)IBOutlet UILabel *durationLabel;
@property (nonatomic,strong)IBOutlet UILabel *durationChange;

- (IBAction)onClickBtnBannerAdsDismiss:(id)sender;

//Outlets form zoom
@property (strong, nonatomic) IBOutlet UIScrollView *zoomScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *zoomScreenShot;
@property (strong, nonatomic) IBOutlet UIImageView *zoomMagnifyingGlass;
@property (strong, nonatomic) IBOutlet UIImageView *zoomScreenShotForVideo;
@property (weak, nonatomic) IBOutlet UIButton *btnBannerAdsDismiss;


@property (assign) BOOL sharingPannelIsHidden;


@property (nonatomic,strong)AVPlayerViewController *player;
@property (nonatomic,strong) AVPlayer *avPlayer;
@property (nonatomic,strong) Flyer *flyer;
@property (nonatomic,strong) NSString *tasksAfterGiphySelect;
@property(strong,nonatomic) NSString *currentLayer;
@property(strong,nonatomic) NSMutableDictionary *layersDic;
@property (nonatomic, copy) void (^onFlyerBack)(NSString *);
@property (nonatomic, copy) void (^shouldShowAdd)(NSString *,BOOL);

-(void) callDeleteLayer;
-(void) choosePhoto;
-(void) donePhoto;
-(void) share;
-(void)printFlyer;

-(NSString *)getImagePathByTag :(NSString *)imgName;
-(NSString *)getImagePathforPhoto :(UIImage *)img;
-(void)copyImageToTemplate :(UIImage *)img;



-(void)addScrollView:(id)obj;
-(void)addBottomTabs:(id)obj;
-(void)deleteSubviewsFromScrollView;

-(void)addDonetoRightBarBotton;

-(void)renderFlyer;
-(void)undoFlyer;
-(void)setUndoStatus;
-(void)videoMergeProcess;
-(void)enableHome:(BOOL)enable;


-(UIImage *)getFlyerSnapShot;


-(IBAction)setAddMoreLayerTabAction:(id)sender;
-(IBAction)addDrawingLayer:(id) sender;
-(IBAction)setlibBackgroundTabAction:(id)sender;
-(IBAction)setStyleTabAction:(id) sender;
-(IBAction)drawingSetStyleTabAction:(id) sender;
-(IBAction)selectBorder:(id)sender;
-(IBAction)selectSize:(id)sender;
-(IBAction)selectColor:(id)sender;
-(IBAction)selectIcon:(id)sender;
-(IBAction)selectEmoticon:(id)sender;
-(IBAction)selectFontBorder:(id)sender;
-(IBAction)setlibPhotoTabAction:(id) sender;
-(IBAction)play:(id)sender;
-(IBAction)slide:(id)sender;
-(IBAction)selectDrawingLine:(id)sender;




//Drawing required vars
//@property (strong,nonatomic) IBOutlet   DrawingView *drawingView;
//@property (strong,nonatomic) IBOutlet   UIImageView *displayView;

//DrawingClass required vars
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *tempDrawImage;

//DrawingClass required functions
//- (IBAction)pencilPressed:(id)sender;
//- (IBAction)eraserPressed:(id)sender;
//- (IBAction)reset:(id)sender;
//- (IBAction)settings:(id)sender;
//- (IBAction)save:(id)sender;

- (IBAction)zoom:(id)sender;


-(void)tasksOnCreateNewFlyer;

-(IBAction)openPanel:(id)sender;
//premium button for premium backgrounds / borders / clipart / Emoticons / fonts
@property (nonatomic,strong)IBOutlet UIButton *premiumBtnBg, *premiumBtnBgBorder, *premiumBtnEmoticons, *premiumBtnCliparts, *premiumBtnFonts;
@property (nonatomic,strong)IBOutlet UIImageView *premiumImgBg, *premiumImgBgBorder, *premiumImgEmoticons, *premiumImgCliparts, *premiumImgFonts;

//This variable was needed because When comming from cropview render flyer relaocating video flyer
@property (assign) BOOL enableRenderFlyer;
-(void)enableNavigation:(BOOL)enable;
//-(void)selectGiphy:(id)sender;

@end
