//
//  PhotoController.h
//  Flyer
//
//  Created by Krunal on 12/10/09.
//  Copyright 2009 iauro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "FlyrAppDelegate.h"
#import "HudView.h"
#import "CustomLabel.h"
#import "CustomPhotoController.h"
#import "EBPurchase.h"

@interface PhotoController : UIViewController<UIActionSheetDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, EBPurchaseDelegate>
{
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

	UIScrollView *fontScrollView;
	UIScrollView *colorScrollView;
	UIScrollView *sizeScrollView;
	UIScrollView *borderScrollView;
	UIScrollView *fontBorderScrollView;
	UIScrollView *templateScrollView;
	//UIScrollView *heightScrollView;
	//UIScrollView *widthScrollView;

    UIScrollView *symbolScrollView;
	UIScrollView *iconScrollView;

	UITextView *msgTextView;
	CustomLabel *msgLabel;
	UIImagePickerController *imgPicker;
	
	bool keyboardShown;
	
	NSString *finalImgWritePath;
	NSString *newImgName;
	UIFont *selectedFont;
	NSString *selectedText;
	UIImage *selectedTemplate;
	UIImage *selectedSymbol;
	UIImage *selectedIcon;
	NSInteger selectedSize;
	id selectedColor;
	NSInteger selectedWidth;
	NSInteger selectedHeight;
	
	UIActionSheet *alert;
	UIView *distributeView;

	UIImage *finalFlyer;
	
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

	BOOL photoTouchFlag;
	BOOL symbolTouchFlag;
	BOOL iconTouchFlag;
	BOOL lableTouchFlag;
	CGPoint lableLocation;
	
	NSMutableArray *templateArray;
	NSMutableArray *iconArray;
	NSMutableArray *symbolArray;

    NSMutableArray *symbolLayersArray;
    NSMutableArray *iconLayersArray;
    NSMutableArray *photoLayersArray;
    NSMutableArray *textEditLayersArray;
    NSMutableArray *textLabelLayersArray;

	NSArray *colorArray;
	NSArray *borderArray;
	NSArray *fontArray;
	UIAlertView *warningAlert ;
    
    EBPurchase *demoPurchase;
    BOOL isPurchased;
    
	NSInteger fontScrollWidth;
	NSInteger fontScrollHeight;
	NSInteger colorScrollWidth;
	NSInteger colorScrollHeight;
    NSInteger borderScrollWidth;
	NSInteger borderScrollHeight;
}

@property (nonatomic, retain) MyNavigationBar *navBar;
@property (nonatomic,retain) HudView *aHUD;

@property(nonatomic, retain)  UIImageView *imgView;
@property (nonatomic,retain)  UIImageView *photoImgView;
@property(nonatomic, retain)  UIImageView *symbolImgView;
@property(nonatomic, retain)  UIImageView *iconImgView;
@property (nonatomic, retain)UIImageView *templateBckgrnd;
@property (nonatomic, retain)UIImageView *textBackgrnd;
@property (nonatomic, retain) UIImagePickerController *imgPicker;
@property (nonatomic, retain) UITextView *msgTextView;

@property (nonatomic,retain)  UIButton *takePhotoButton;
@property (nonatomic,retain)  UIButton *cameraRollButton;
@property (nonatomic,retain)  UILabel *takePhotoLabel;
@property (nonatomic,retain)  UILabel *cameraRollLabel;
@property (nonatomic,retain)  UIButton *moreLayersButton;
@property (nonatomic,retain)  UILabel *moreLayersLabel;
@property (nonatomic,retain)  UILabel *addMoreLayerOrSaveFlyerLabel;

@property (nonatomic, retain) UIScrollView *templateScrollView;
@property (nonatomic, retain) UIScrollView *fontScrollView;
@property (nonatomic, retain) UIScrollView *colorScrollView;
@property (nonatomic, retain) UIScrollView *sizeScrollView;
@property (nonatomic, retain) UIScrollView *borderScrollView;
@property (nonatomic, retain) UIScrollView *fontBorderScrollView;
//@property (nonatomic,retain) UIScrollView *heightScrollView;
//@property (nonatomic,retain) UIScrollView *widthScrollView;

@property (nonatomic, retain) UIScrollView *iconScrollView;
@property (nonatomic, retain) UIScrollView *symbolScrollView;

@property (nonatomic, retain) NSString *finalImgWritePath;
@property (nonatomic, retain) NSString *newImgName;
@property (nonatomic, retain) UIFont *selectedFont;
@property (nonatomic, assign) id selectedColor;
@property (nonatomic, retain) NSString *selectedText;
@property (nonatomic, assign) NSInteger selectedSize;
@property (nonatomic, retain) UIImage *selectedTemplate;
@property (nonatomic, retain) UIImage *selectedSymbol;
@property (nonatomic, retain) UIImage *selectedIcon;

@property (nonatomic, retain) UIButton *fontTabButton;
@property (nonatomic, retain) UIButton *colorTabButton;
@property (nonatomic, retain) UIButton *sizeTabButton;
@property (nonatomic, retain) UIButton *borderTabButton;
@property (nonatomic, retain) UIButton *fontBorderTabButton;
@property (nonatomic, retain) UIImage *finalFlyer;

@property (nonatomic,retain) UIButton *cameraTabButton;
@property (nonatomic,retain) UIButton *photoTabButton;
@property (nonatomic,retain) UIButton *widthTabButton;
@property (nonatomic,retain) UIButton *heightTabButton;

@property (nonatomic, retain) UIButton *addMoreFontTabButton;
@property (nonatomic, retain) UIButton *addMorePhotoTabButton;
@property (nonatomic, retain) UIButton *addMoreIconTabButton;
@property (nonatomic, retain) UIButton *addMoreSymbolTabButton;
@property (nonatomic, retain) UIButton *arrangeLayerTabButton;

@property (nonatomic, assign)BOOL photoTouchFlag;
@property (nonatomic, assign)BOOL lableTouchFlag;
@property (nonatomic, assign)BOOL symbolTouchFlag;
@property (nonatomic, assign)BOOL iconTouchFlag;
@property (nonatomic, assign) CGPoint lableLocation;
@property (nonatomic,retain) UIAlertView *warningAlert;

@property (nonatomic, assign) NSInteger imgPickerFlag;

- (void)showHUD;
- (void)killHUD;
-(void) chooseTemplate;
-(void) choosePhoto;
-(void) saveMyFlyer;
- (void)layoutScrollImages:(UIScrollView*)selectedScrollView scrollWidth:(NSInteger)kScrollObjWidth scrollHeight:(NSInteger)kScrollObjHeight;
-(NSData*)getCurrentFrameAndSaveIt;
-(void)loadPhotoLibrary;
-(void)setPhotoTabAction:(id) sender;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+(UILabel *)setTitleViewWithTitle:(NSString *)title;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil templateParam:(UIImage *)templateParam symbolArrayParam:(NSMutableArray *)symbolArrayParam iconArrayParam:(NSMutableArray *)iconArrayParam photoArrayParam:(NSMutableArray *)photoArrayParam textArrayParam:(NSMutableArray *)textArrayParam;

@end
