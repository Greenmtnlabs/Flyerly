
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
#import "FlyerlySingleton.h"
#import "ParentViewController.h"
#import "CameraViewController.h"
#import "Flyer.h"
#import "FlyerImageView.h"
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "Common.h"
#import "FlyrAppDelegate.h"
#import "SaveFlyerController.h"
#import "ShareViewController.h"
#import "HelpController.h"
#import "LoadingView.h"
#import "Flurry.h"
#import "SKProduct+LocalPrice.h"
#import "LayerTileButton.h"
#import "LibraryViewController.h"
#import "UIPlaceHolderTextView.h"
#import <MediaPlayer/MediaPlayer.h>


@class FlyerlySingleton,CameraViewController,Flyer,FlyerImageView;
@interface CreateFlyerController :ParentViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, FlyerImageViewDelegate,UIGestureRecognizerDelegate >
{
   
    FlyerlySingleton *globle;
    UILabel *addMoreLayerOrSaveFlyerLabel;
    UILabel *takeOrAddPhotoLabel;
    UILabel *videoLabel;
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

    FlyerImageView *flyerImageView;
    
    UITextView *lastTextView;

    ShareViewController *shareviewcontroller;
    UILabel *titleLabel;
    UIImage *videolastImage;
    BOOL *isPlaying;
    BOOL *isVideoReadyForShare;
    BOOL *panelWillOpen;
    float videoDuration;
    
}


@property (nonatomic, strong) UIImageView *textBackgrnd;
@property (nonatomic,strong)  UILabel *addMoreLayerOrSaveFlyerLabel;
@property (nonatomic,strong)  UILabel *takeOrAddPhotoLabel;
@property (nonatomic, strong) UIScrollView *layerScrollView;
@property (nonatomic, strong) UIFont *selectedFont;
@property (nonatomic, weak) id selectedColor;
@property (nonatomic, assign) NSInteger selectedSize;
@property (nonatomic, strong) UIImage *selectedTemplate;
@property (nonatomic,strong) UIAlertView *deleteAlert;
@property (nonatomic, assign) NSInteger imgPickerFlag;
@property (nonatomic, strong) NSString *flyerPath;
@property(nonatomic, strong) IBOutlet FlyerImageView *flyimgView;
@property (nonatomic, strong) UIView *sharePanel;

// These are ContextViews Library
@property(nonatomic, strong) IBOutlet UIView *contextView;
@property(nonatomic, strong) IBOutlet UIView *libraryContextView;
@property(nonatomic, strong) IBOutlet UIView *libFlyer;
@property(nonatomic, strong) IBOutlet UIView *libBackground;
@property(nonatomic, strong) IBOutlet UIView *libText;
@property(nonatomic, strong) IBOutlet UIView *libPhoto;
@property(nonatomic, strong) IBOutlet UIView *libEmpty;
@property(nonatomic, strong) IBOutlet UIView *playerView;
@property(nonatomic, strong) IBOutlet UIView *playerToolBar;



// These are LibFlyer
@property (nonatomic, strong) IBOutlet UIButton *addMoreFontTabButton;
@property (nonatomic, strong)IBOutlet UIButton *addMorePhotoTabButton;
@property (nonatomic, strong)IBOutlet UIButton *addMoreIconTabButton;
@property (nonatomic, strong)IBOutlet UIButton *addMoreSymbolTabButton;
@property (nonatomic, strong)IBOutlet UIButton *backgroundTabButton;

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


-(void)loadCustomPhotoLibrary :(NSString *)videoAllow;

-(void)openCustomCamera;

-(void) callDeleteLayer;
-(void) choosePhoto;
-(void) donePhoto;
-(void)share;

-(NSString *)getImagePathByTag :(NSString *)imgName;
-(NSString *)getImagePathforPhoto :(UIImage *)img;
-(void)copyImageToTemplate :(UIImage *)img;



-(void)addScrollView:(id)obj;
-(void)addBottomTabs:(id)obj;
-(void)addAllLayersIntoScrollView;
-(void)deleteSubviewsFromScrollView;

-(void)addDonetoRightBarBotton;

-(void)renderFlyer;
-(void)undoFlyer;
-(void)setUndoStatus;

-(UIImage *)getFlyerSnapShot;


-(IBAction)setAddMoreLayerTabAction:(id)sender;
-(IBAction)setlibBackgroundTabAction:(id)sender;
-(IBAction)setStyleTabAction:(id) sender;
-(IBAction)setlibPhotoTabAction:(id) sender;
-(IBAction)play:(id)sender;
-(IBAction)slide:(id)sender;

@end
