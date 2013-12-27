//
//  TwitLoginController.h
//  Flyer
//
//  Created by Krunal on 13/10/09.
//  Copyright 2009 iauro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNetworkController.h"

@class MGTwitterEngine;
@class MGTwitterEngineGlobalHeader;
@class LoginController;
@class PhotoController;
@class SaveFlyerController;

@interface TwitLogin: UIView <UITextFieldDelegate>{
	UIView* _loginView;
	UIActivityIndicatorView* _spinner;
	UILabel* _titleLabel;
	UIButton* _closeButton;
	UIDeviceOrientation _orientation;
	BOOL _showingKeyboard;
	UIImageView* _iconView;
	
	LoginController *lController;
	
	UIButton *cancelButton;
	UIButton * loginButton;
	UITextField  *loginField;
	UITextField  * passwordField;
	UISwitch *rememberSwitch;
	BOOL _remember;
	BOOL  _notificationFlag;
	UIAlertView *netStat; 
	MyNetworkController *netObj;
	UIImage *flyerImage;
	SaveFlyerController *svController;
}

@property(nonatomic,retain) LoginController *lController;
@property(retain, nonatomic) UIAlertView *netStat;
@property(retain, nonatomic) MyNetworkController *netObj;
@property(nonatomic, retain) UIImage *flyerImage;
@property(nonatomic, retain)SaveFlyerController *svController;
- (void)postDismissCleanup;
- (void)dismiss:(BOOL)animated;
-(void)sendStatusCode:(NSInteger)statusCode;

-(void)callLoginFromLoginController;
//-(void)sendStatusCode:(NSInteger)statusCode;
-(void)show;
@end
