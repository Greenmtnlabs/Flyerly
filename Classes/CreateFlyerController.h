
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
#import "DrawingView.h"

@class FlyerlySingleton, Flyer, FlyerImageView, ShareViewController, SigninController,InAppViewController,PrintViewController;
@interface CreateFlyerController :ParentViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, FlyerImageViewDelegate,UIGestureRecognizerDelegate,InAppPurchasePanelButtonProtocol, UserPurchasesDelegate, GADInterstitialDelegate, GADBannerViewDelegate>

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
    
    DrawingView *drawingView;
    UIImageView *displayView;
    
}

@property(nonatomic, strong) GADInterstitial *interstitialAdd;
@property(nonatomic, strong) GADBannerView *bannerAdd;

@property(nonatomic, strong) IBOutlet UIView *bannerAddView;

@property (nonatomic, strong)IBOutlet UIButton *bannerAddDismissButton;


//-----
@property (nonatomic, strong) ResourcesView *backgroundsView;
@property (nonatomic, strong) ResourcesView *flyerBordersView;
@property (nonatomic, strong) UIView *fontsView;
@property (nonatomic, strong) ResourcesView *colorsView;
@property (nonatomic, strong) ResourcesView *sizesView;
@property (nonatomic, strong) ResourcesView *textBordersView;
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
@property (nonatomic, strong) UIAlertView *spaceUnavailableAlert;
@property (nonatomic, assign) NSInteger imgPickerFlag;
@property (nonatomic, strong) NSString *flyerPath;
@property (nonatomic, strong) IBOutlet FlyerImageView *flyimgView;
@property (nonatomic, strong) UIView *sharePanel;

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

@property (strong,nonatomic) IBOutlet   DrawingView *drawingView;
@property (strong,nonatomic) IBOutlet   UIImageView *displayView;

//--------
@property(nonatomic, strong) IBOutlet UIView *tempelateView;
//---------

// These are LibFlyer
@property (nonatomic, strong)IBOutlet UIButton *addMoreFontTabButton;
@property (nonatomic, strong)IBOutlet UIButton *addMorePhotoTabButton;
@property (nonatomic, strong)IBOutlet UIButton *addVideoTabButton;
@property (nonatomic, strong)IBOutlet UIButton *addArtsTabButton;
@property (nonatomic, strong)IBOutlet UIButton *backgroundTabButton;
@property (nonatomic, strong)IBOutlet UIButton *drawingMenueButton;


//These are LibBackground
@property (nonatomic, strong)IBOutlet UIButton *backtemplates;
@property (nonatomic, strong)IBOutlet UIButton *cameraTakePhoto;
@property (nonatomic, strong)IBOutlet UIButton *cameraRoll;
@property (nonatomic, strong)IBOutlet UIButton *flyerBorder;

//These are LibText
@property (nonatomic, strong)IBOutlet UIButton *fontTabButton;
@property (nonatomic, strong)IBOutlet UIButton *colorTabButton;
@property (nonatomic, strong)IBOutlet UIButton *sizeTabButton;
@property (nonatomic, strong)IBOutlet UIButton *fontBorderTabButton;
@property (nonatomic, strong)IBOutlet UIButton *fontEditButton;

//These are Art Tab Buttons
@property (nonatomic, strong)IBOutlet UIButton *clipArtTabButton;
@property (nonatomic, strong)IBOutlet UIButton *emoticonsTabButton;
@property (nonatomic, strong)IBOutlet UIButton *artsColorTabButton;
@property (nonatomic, strong)IBOutlet UIButton *drawingTabButton;
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


@property (nonatomic,strong)MPMoviePlayerController *player;

@property (nonatomic,strong) Flyer *flyer;
@property(strong,nonatomic) NSString *currentLayer;
@property(strong,nonatomic) NSMutableDictionary *layersDic;
@property (nonatomic, copy) void (^onFlyerBack)(NSString *);
@property (nonatomic, copy) void (^shouldShowAdd)(NSString *);

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
-(IBAction)setlibBackgroundTabAction:(id)sender;
-(IBAction)setStyleTabAction:(id) sender;
-(IBAction)selectBorder:(id)sender;
-(IBAction)selectSize:(id)sender;
-(IBAction)selectColor:(id)sender;
-(IBAction)selectIcon:(id)sender;
-(IBAction)selectEmoticon:(id)sender;
-(IBAction)selectFontBorder:(id)sender;
-(IBAction)setlibPhotoTabAction:(id) sender;
-(IBAction)play:(id)sender;
-(IBAction)slide:(id)sender;

-(IBAction)dissmisBannerAdd:(id)sender;

@end
