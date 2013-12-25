//
//  PhotoController.h
//  Flyer
//
//  Created by Krunal on 12/10/09.
//  Copyright 2009 iauro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "HudView.h"
#import "CustomLabel.h"
#import "CustomPhotoController.h"
#import "EBPurchase.h"
#import "ShareProgressView.h"
#import "Singleton.h"
#import "ParentViewController.h"



@class Singleton,LauchViewController;
@interface PhotoController :ParentViewController<UIActionSheetDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, EBPurchaseDelegate>
{
    int layerallow;
    Singleton *globle;
	MyNavigationBar *navBar;
	HudView *aHUD;
    CustomPhotoController *customPhotoController;
	UIImageView *imgView;
	UIImageView *templateBckgrnd;
	UIImageView *textBackgrnd;
	UIImageView *photoImgView;
	UIImageView *symbolImgView;
	UIImageView *iconImgView;

    UIButton *takePhotoButton;
	UIButton *cameraRollButton;
    UILabel *takePhotoLabel;
	UILabel *cameraRollLabel;
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

	UIButton *fontTabButton;
	UIButton *colorTabButton;
	UIButton *sizeTabButton;
	UIButton *borderTabButton;
	UIButton *fontBorderTabButton;

	UIButton *cameraTabButton;
	UIButton *photoTabButton;
	UIButton *widthTabButton;
	UIButton *heightTabButton;
	NSInteger imgPickerFlag;
	
	UIButton *addMoreFontTabButton;
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
    ShareProgressView *layerEditMessage;
}

@property(nonatomic, strong) NSMutableArray *cpyTextLabelLayersArray;
@property(nonatomic, strong) NSMutableArray *cpySymbolLayersArray;
@property(nonatomic, strong) NSMutableArray *cpyIconLayersArray;
@property(nonatomic, strong) NSMutableArray *cpyPhotoLayersArray;

@property (nonatomic, strong) MyNavigationBar *navBar;
@property (nonatomic,strong) HudView *aHUD;

@property(nonatomic, strong)  UIImageView *imgView;
@property (nonatomic,strong)  UIImageView *photoImgView;
@property(nonatomic, strong)  UIImageView *symbolImgView;
@property(nonatomic, strong)  UIImageView *iconImgView;
@property (nonatomic, strong) UIImageView *templateBckgrnd;
@property (nonatomic, strong) UIImageView *textBackgrnd;
@property (nonatomic, strong) UIImagePickerController *imgPicker;
@property (nonatomic, strong) UITextView *msgTextView;

@property (nonatomic,strong)  UIButton *takePhotoButton;
@property (nonatomic,strong)  UIButton *cameraRollButton;
@property (nonatomic,strong)  UILabel *takePhotoLabel;
@property (nonatomic,strong)  UILabel *cameraRollLabel;
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

@property (nonatomic, strong) UIButton *fontTabButton;
@property (nonatomic, strong) UIButton *colorTabButton;
@property (nonatomic, strong) UIButton *sizeTabButton;
@property (nonatomic, strong) UIButton *borderTabButton;
@property (nonatomic, strong) UIButton *fontBorderTabButton;
@property (nonatomic, strong) UIImage *finalFlyer;

@property (nonatomic,strong) UIButton *cameraTabButton;
@property (nonatomic,strong) UIButton *photoTabButton;
@property (nonatomic,strong) UIButton *widthTabButton;
@property (nonatomic,strong) UIButton *heightTabButton;

@property (nonatomic, strong) UIButton *addMoreFontTabButton;
@property (nonatomic, strong) UIButton *addMorePhotoTabButton;
@property (nonatomic, strong) UIButton *addMoreIconTabButton;
@property (nonatomic, strong) UIButton *addMoreSymbolTabButton;
@property (nonatomic, strong) UIButton *arrangeLayerTabButton;

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


-(void)loadCustomPhotoLibrary;
- (void)showHUD;
- (void)killHUD;
-(void) chooseTemplate;
-(void) chooseEdit;
-(void) MyEdit;
-(void) SetMenu;
-(void) MyDelete;
-(void) Mycancel;
-(void)delaytime;
-(void) choosePhoto;
-(void) saveMyFlyer;
-(void)callSaveAndShare;
-(void)openCustomCamera;
-(BOOL)canAddMoreLayers;
- (void)layoutScrollImages:(UIScrollView*)selectedScrollView scrollWidth:(NSInteger)kScrollObjWidth scrollHeight:(NSInteger)kScrollObjHeight;
-(NSData*)getCurrentFrameAndSaveIt;
-(void)loadPhotoLibrary;
-(void)setPhotoTabAction:(id) sender;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+(UIView *)setTitleViewWithTitle:(NSString *)title rect:(CGRect)rect;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil templateParam:(UIImage *)templateParam symbolArrayParam:(NSMutableArray *)symbolArrayParam iconArrayParam:(NSMutableArray *)iconArrayParam photoArrayParam:(NSMutableArray *)photoArrayParam textArrayParam:(NSMutableArray *)textArrayParam flyerNumberParam:(int)flyerNumberParam;


-(NSMutableDictionary *)getInAppDictionary;
-(void)setInAppDictionary:(NSMutableDictionary *)inAppDict;
@end
