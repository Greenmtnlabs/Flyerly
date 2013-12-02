//
//  LoginController.h
//  Flyer
//
//
//  Created by Krunal on 05/10/09.
//  Copyright 2009 iauro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGTwitterEngineGlobalHeader.h"
#import "MyNetworkController.h"
#import "OLBTwitpicEngine.h"

@class MGTwitterEngine;
@class MGTwitterEngineGlobalHeader;

@interface LoginController : UIViewController <UITextFieldDelegate,OLBTwitpicEngineDelegate>

{
	/*IBOutlet UILabel* _label;
	IBOutlet UIButton* _permissionButton;
	IBOutlet UIButton* _feedButton;
	IBOutlet FBLoginButton* _loginButton;
	FBSession* _session;*/
	

	UIAlertView *netStat; 
	MyNetworkController *netObj;
	NSString *userName;
	NSString *passWord;
	
	IBOutlet id rememberSwitch;
	IBOutlet id iconView;
	BOOL _modal;
	BOOL _remember;
	OLBTwitpicEngine *twit;
	UIImage *flyerImg;
	
}

@property(strong, nonatomic) UIAlertView *netStat;
@property(strong, nonatomic) MyNetworkController *netObj;
@property(strong, nonatomic) NSString *userName;
@property(strong, nonatomic) NSString *passWord;
@property(nonatomic, strong) OLBTwitpicEngine *twit;
@property(nonatomic, strong) UIImage *flyerImg;

-(id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle modal:(BOOL)modal;

+ (void)showModal:(UINavigationController*)parentController;
+ (void)showModeless:(UINavigationController*)parentController animated:(BOOL)anim;
- (void)login:(NSString*)user password:(NSString*)pass;

/*@property(nonatomic,readonly) UILabel* label;

- (IBAction)askPermission:(id)target;
- (IBAction)publishFeed:(id)target;
*/
- (IBAction)cancel:(id)sender; 
-(void)sendStatusCode:(NSInteger)statusCode;
@end