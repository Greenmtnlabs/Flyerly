//
//  PhotoController.h
//  Flyer
//
//  Created by Riksof Pvt. Ltd on 12/10/09.
//  Copyright 2009 iauro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"
#import "EBPurchase.h"
#import "FlyerlySingleton.h"
#import "ParentViewController.h"
#import "GalleryViewController.h"
#import "CameraViewController.h"


@class FlyerlySingleton,CameraViewController,GalleryViewController;
@interface CreateFlyerController :ParentViewController<UIActionSheetDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, EBPurchaseDelegate>
{
    int layerallow;
    FlyerlySingleton *globle;
	UIImageView *imgView;
	UIImageView *templateBckgrnd;
	UIImageView *textBackgrnd;
	UIImageView *photoImgView;
	UIImageView *symbolImgView;
	UIImageView *iconImgView;

    UIButton *moreLayersButton;
    UILabel *moreLayersLabel;
    UILabel *addMoreLayerOrSaveFlyerLabel;
    UILabel *takeOrAddPhotoLabel;

	UIScrollView *fontScrollView;
	UIScrollView *colorScrollView;
	UIScrollView *sizeScrollView;
	UIScrollView *borderScrollView;
	UIScrollView *fontBorderScrollView;
	UIScrollView *templateScrollView;
    UIScrollView *symbolScrollView;
	UIScrollView *iconScrollView;
    UIScrollView *layerScrollView;

	UITextView *msgTextView;
    UIImageView *newPhotoImgView;
	CustomLabel *msgLabel;
	UIImagePickerController *imgPicker;
	
	NSString *finalImgWritePath;
	NSString *imageNameNew;
	UIFont *selectedFont;
	NSString *selectedText;
	UIImage *selectedTemplate;
	UIImage *selectedSymbol;
	UIImage *selectedIcon;
	NSInteger selectedSize;
	id __weak selectedColor;
	NSInteger selectedWidth;
	NSInteger selectedHeight;
	
	UIActionSheet *alert;
	UIView *distributeView;
	UIImage *finalFlyer;
    EBPurchase *demoPurchase;


	NSInteger imgPickerFlag;
	
	UIButton *addMorePhotoTabButton;
	UIButton *addMoreIconTabButton;
	UIButton *addMoreSymbolTabButton;
	UIButton *arrangeLayerTabButton;

	bool keyboardShown;
	BOOL photoTouchFlag;
	BOOL symbolTouchFlag;
	BOOL iconTouchFlag;
	BOOL lableTouchFlag;
	CGPoint lableLocation;
	
	NSMutableArray *templateArray;
	NSMutableArray *iconArray;
	NSMutableArray *symbolArray;
	NSArray *colorArray;
	NSArray *borderArray;
	NSArray *fontArray;

    NSMutableArray *symbolLayersArray;
    NSMutableArray *iconLayersArray;
    NSMutableArray *photoLayersArray;
    NSMutableArray *textEditLayersArray;
    NSMutableArray *textLabelLayersArray;

    NSMutableArray *cpySymbolLayersArray;
    NSMutableArray *cpyIconLayersArray;
    NSMutableArray *cpyPhotoLayersArray;
    NSMutableArray *cpyTextLabelLayersArray;

	UIAlertView *warningAlert ;
	UIAlertView *discardAlert ;
	UIAlertView *deleteAlert ;
	UIAlertView *editAlert ;
    UIAlertView *inAppAlert ;

    BOOL isPurchased;
    BOOL deleteMode;
    BOOL doStopWobble;
    BOOL discardedLayer;
    int undoCount;
    int flyerNumber;

	NSInteger fontScrollWidth;
	NSInteger fontScrollHeight;
	NSInteger colorScrollWidth;
	NSInteger colorScrollHeight;
    NSInteger borderScrollWidth;
	NSInteger borderScrollHeight;
    NSInteger fontBorderScrollWidth;
	NSInteger fontBorderScrollHeight;
	NSInteger sizeScrollWidth;
	NSInteger sizeScrollHeight;
	NSInteger templateScrollWidth;
	NSInteger templateScrollHeight;

    UIButton *crossButtonGlobal;
    UIButton *editButtonGlobal;    
    UIBarButtonItem *rightUndoBarButton;

    GalleryViewController *nbuGallary;
    CameraViewController *nbuCamera;
}

@property(nonatomic, strong) NSMutableArray *cpyTextLabelLayersArray;
@property(nonatomic, strong) NSMutableArray *cpySymbolLayersArray;
@property(nonatomic, strong) NSMutableArray *cpyIconLayersArray;
@property(nonatomic, strong) NSMutableArray *cpyPhotoLayersArray;
@property (nonatomic,strong)  UIImageView *photoImgView;
@property(nonatomic, strong)  UIImageView *symbolImgView;
@property(nonatomic, strong)  UIImageView *iconImgView;
@property (nonatomic, strong) UIImageView *templateBckgrnd;
@property (nonatomic, strong) UIImageView *textBackgrnd;
@property (nonatomic, strong) UIImagePickerController *imgPicker;
@property (nonatomic, strong) UITextView *msgTextView;

@property (nonatomic,strong)  UIButton *moreLayersButton;
@property (nonatomic,strong)  UILabel *moreLayersLabel;
@property (nonatomic,strong)  UILabel *addMoreLayerOrSaveFlyerLabel;
@property (nonatomic,strong)  UILabel *takeOrAddPhotoLabel;

@property (nonatomic, strong) UIScrollView *templateScrollView;
@property (nonatomic, strong) UIScrollView *fontScrollView;
@property (nonatomic, strong) UIScrollView *colorScrollView;
@property (nonatomic, strong) UIScrollView *sizeScrollView;
@property (nonatomic, strong) UIScrollView *borderScrollView;
@property (nonatomic, strong) UIScrollView *fontBorderScrollView;
@property (nonatomic, strong) UIScrollView *layerScrollView;

@property (nonatomic, strong) UIScrollView *iconScrollView;
@property (nonatomic, strong) UIScrollView *symbolScrollView;

@property (nonatomic, strong) NSString *finalImgWritePath;
@property (nonatomic, strong) NSString *imageNameNew;
@property (nonatomic, strong) UIFont *selectedFont;
@property (nonatomic, weak) id selectedColor;
@property (nonatomic, strong) NSString *selectedText;
@property (nonatomic, assign) NSInteger selectedSize;
@property (nonatomic, strong) UIImage *selectedTemplate;
@property (nonatomic, strong) UIImage *selectedSymbol;
@property (nonatomic, strong) UIImage *selectedIcon;


@property (nonatomic, strong) UIImage *finalFlyer;

@property (nonatomic, assign)BOOL photoTouchFlag;
@property (nonatomic, assign)BOOL lableTouchFlag;
@property (nonatomic, assign)BOOL symbolTouchFlag;
@property (nonatomic, assign)BOOL iconTouchFlag;
@property (nonatomic, assign) CGPoint lableLocation;
@property (nonatomic,strong) UIAlertView *warningAlert;
@property (nonatomic,strong) UIAlertView *discardAlert;
@property (nonatomic,strong) UIAlertView *deleteAlert;
@property (nonatomic,strong) UIAlertView *editAlert;
@property (nonatomic,strong) UIAlertView *inAppAlert;

@property (nonatomic, assign) NSInteger imgPickerFlag;
@property (nonatomic, assign) int flyerNumber;


@property(nonatomic, strong) IBOutlet UIImageView *imgView;
@property(nonatomic, strong) IBOutlet UIView *contextView;

// These are ContextViews Library
@property(nonatomic, strong) IBOutlet UIView *libraryContextView;
@property(nonatomic, strong) IBOutlet UIView *libFlyer;
@property(nonatomic, strong) IBOutlet UIView *libBackground;
@property(nonatomic, strong) IBOutlet UIView *libText;
@property(nonatomic, strong) IBOutlet UIView *libPhoto;


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



-(void)loadCustomPhotoLibrary;

-(void) chooseEdit;
-(void) MyEdit;
-(void) SetMenu;
-(void) MyDelete;
-(void) Mycancel;
-(void) choosePhoto;
-(void) DonePhoto;
-(void) saveMyFlyer;
-(void)callSaveAndShare;
-(void)openCustomCamera;
-(BOOL)canAddMoreLayers;

- (void)layoutScrollImages:(UIScrollView*)selectedScrollView scrollWidth:(NSInteger)kScrollObjWidth scrollHeight:(NSInteger)kScrollObjHeight;

-(NSData*)getCurrentFrameAndSaveIt;
-(void)loadPhotoLibrary;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+(UIView *)setTitleViewWithTitle:(NSString *)title rect:(CGRect)rect;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil templateParam:(UIImage *)templateParam symbolArrayParam:(NSMutableArray *)symbolArrayParam iconArrayParam:(NSMutableArray *)iconArrayParam photoArrayParam:(NSMutableArray *)photoArrayParam textArrayParam:(NSMutableArray *)textArrayParam flyerNumberParam:(int)flyerNumberParam;


-(NSMutableDictionary *)getInAppDictionary;
-(void)setInAppDictionary:(NSMutableDictionary *)inAppDict;

-(void)AddScrollView:(id)obj;
-(void)AddBottomTabs:(id)obj;
-(void)AddAllLayersIntoFront;

-(void)AddDonetoRightBarBotton;

-(IBAction)setAddMoreLayerTabAction:(id)sender;
-(IBAction)setlibBackgroundTabAction:(id)sender;
-(IBAction)setStyleTabAction:(id) sender;
-(IBAction)setlibPhotoTabAction:(id) sender;
@end
