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

@interface PhotoController : UIViewController<UIActionSheetDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
	MyNavigationBar *navBar;
	HudView *aHUD;
	
	UIImageView *imgView;				
	UIImageView *templateBckgrnd;
	UIImageView *textBackgrnd;
	UIImageView *photoImgView;

    UIButton *takePhotoButton;
	UIButton *cameraRollButton;
    UILabel *takePhotoLabel;
	UILabel *cameraRollLabel;

	UIScrollView *fontScrollView;
	UIScrollView *colorScrollView;
	UIScrollView *sizeScrollView;
	UIScrollView *templateScrollView;
	UIScrollView *heightScrollView;
	UIScrollView *widthScrollView;
	
	UITextView *msgTextView;
	UILabel *msgLabel;
	UIImagePickerController *imgPicker;
	
	bool keyboardShown;
	
	UIFont *selectedFont;
	NSString *selectedText;
	UIImage *selectedTemplate;
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

	UIButton *photoTabButton;
	UIButton *widthTabButton;
	UIButton *heightTabButton;
	NSInteger imgPickerFlag;
	
	BOOL photoTouchFlag;
	BOOL lableTouchFlag;
	CGPoint lableLocation;
	
	NSMutableArray *templateArray;
	NSMutableArray *iconArray;

	NSArray *colorArray;
	NSArray *fontArray;
	UIAlertView *warningAlert ;
}
@property (nonatomic, retain) MyNavigationBar *navBar;
@property (nonatomic,retain) HudView *aHUD;

@property(nonatomic, retain)  UIImageView *imgView;
@property (nonatomic,retain)  UIImageView *photoImgView;
@property (nonatomic, retain)UIImageView *templateBckgrnd;
@property (nonatomic, retain)UIImageView *textBackgrnd;
@property (nonatomic, retain) UIImagePickerController *imgPicker;
@property (nonatomic, retain) UITextView *msgTextView;

@property (nonatomic,retain)  UIButton *takePhotoButton;
@property (nonatomic,retain)  UIButton *cameraRollButton;
@property (nonatomic,retain)  UILabel *takePhotoLabel;
@property (nonatomic,retain)  UILabel *cameraRollLabel;

@property (nonatomic, retain) UIScrollView *templateScrollView;
@property (nonatomic, retain) UIScrollView *fontScrollView;
@property (nonatomic, retain) UIScrollView *colorScrollView;
@property (nonatomic, retain) UIScrollView *sizeScrollView;
@property (nonatomic,retain) UIScrollView *heightScrollView;
@property (nonatomic,retain) UIScrollView *widthScrollView;

@property (nonatomic, retain) UIFont *selectedFont;
@property (nonatomic, assign) id selectedColor;
@property (nonatomic, retain) NSString *selectedText;
@property (nonatomic, assign) NSInteger selectedSize;
@property (nonatomic, retain) UIImage *selectedTemplate;

@property (nonatomic, retain) UIButton *fontTabButton;
@property (nonatomic, retain) UIButton *colorTabButton;
@property (nonatomic, retain) UIButton *sizeTabButton;
@property (nonatomic, retain) UIImage *finalFlyer;

@property (nonatomic,retain) UIButton *photoTabButton;
@property (nonatomic,retain) UIButton *widthTabButton;
@property (nonatomic,retain) UIButton *heightTabButton;

@property (nonatomic, assign)BOOL photoTouchFlag;
@property (nonatomic, assign)BOOL lableTouchFlag;
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
@end
