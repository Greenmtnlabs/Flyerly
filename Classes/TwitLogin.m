//
//  TwitLoginController.m
//  Flyer
//
//  Created by Krunal on 13/10/09.
//  Copyright 2009 iauro. All rights reserved.
//

#import "TwitLogin.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "LoginController.h"
#import "FlyrAppDelegate.h"
#import "MGTwitterEngine.h"
#import "OLBTwitpicEngine.h"
#import "PhotoController.h"
#import "SaveFlyerController.h"

static NSString* kDefaultTitle = @"Connect to Twitter";
static CGFloat kFacebookBlue[4] = {0.42578125, 0.515625, 0.703125, 1.0};
static CGFloat kBorderGray[4] = {0.3, 0.3, 0.3, 0.8};
static CGFloat kBorderBlack[4] = {0.3, 0.3, 0.3, 1};
static CGFloat kBorderBlue[4] = {0.23, 0.35, 0.6, 1.0};

static CGFloat kTransitionDuration = 0.3;
//static CGFloat kTitleMarginX = 8;
//static CGFloat kTitleMarginY = 4;
static CGFloat kPadding = 10;
static CGFloat kBorderWidth = 10;


@implementation TwitLogin

@synthesize lController,netStat,netObj,twit,flyerImage,svController;

- (void)addRoundedRectToPath:(CGContextRef)context rect:(CGRect)rect radius:(float)radius {
	CGContextBeginPath(context);
	CGContextSaveGState(context);
	
	if (radius == 0) {
		CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
		CGContextAddRect(context, rect);
	} else {
		rect = CGRectOffset(CGRectInset(rect, 0.5, 0.5), 0.5, 0.5);
		CGContextTranslateCTM(context, CGRectGetMinX(rect)-0.5, CGRectGetMinY(rect)-0.5);
		CGContextScaleCTM(context, radius, radius);
		float fw = CGRectGetWidth(rect) / radius;
		float fh = CGRectGetHeight(rect) / radius;
		
		CGContextMoveToPoint(context, fw, fh/2);
		CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
		CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
		CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
		CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
	}
	
	CGContextClosePath(context);
	CGContextRestoreGState(context);
}

- (void)drawRect:(CGRect)rect fill:(const CGFloat*)fillColors radius:(CGFloat)radius {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	
	if (fillColors) {
		CGContextSaveGState(context);
		CGContextSetFillColor(context, fillColors);
		if (radius) {
			[self addRoundedRectToPath:context rect:rect radius:radius];
			CGContextFillPath(context);
		} else {
			CGContextFillRect(context, rect);
		}
		CGContextRestoreGState(context);
	}
	
	CGColorSpaceRelease(space);
}

- (void)strokeLines:(CGRect)rect stroke:(const CGFloat*)strokeColor {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	
	CGContextSaveGState(context);
	CGContextSetStrokeColorSpace(context, space);
	CGContextSetStrokeColor(context, strokeColor);
	CGContextSetLineWidth(context, 1.0);
    
	{
		CGPoint points[] = {rect.origin.x+0.5, rect.origin.y-0.5,
		rect.origin.x+rect.size.width, rect.origin.y-0.5};
		CGContextStrokeLineSegments(context, points, 2);
	}
	{
		CGPoint points[] = {rect.origin.x+0.5, rect.origin.y+rect.size.height-0.5,
		rect.origin.x+rect.size.width-0.5, rect.origin.y+rect.size.height-0.5};
		CGContextStrokeLineSegments(context, points, 2);
	}
	{
		CGPoint points[] = {rect.origin.x+rect.size.width-0.5, rect.origin.y,
		rect.origin.x+rect.size.width-0.5, rect.origin.y+rect.size.height};
		CGContextStrokeLineSegments(context, points, 2);
	}
	{
		CGPoint points[] = {rect.origin.x+0.5, rect.origin.y,
		rect.origin.x+0.5, rect.origin.y+rect.size.height};
		CGContextStrokeLineSegments(context, points, 2);
	}
	
	CGContextRestoreGState(context);
	
	CGColorSpaceRelease(space);
}

- (BOOL)shouldRotateToOrientation:(UIDeviceOrientation)orientation {
	if (orientation == _orientation) {
		return NO;
	} else {
		return orientation == UIDeviceOrientationLandscapeLeft
		|| orientation == UIDeviceOrientationLandscapeRight
		|| orientation == UIDeviceOrientationPortrait
		|| orientation == UIDeviceOrientationPortraitUpsideDown;
	}
}

- (CGAffineTransform)transformForOrientation {
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (orientation == UIInterfaceOrientationLandscapeLeft) {
		return CGAffineTransformMakeRotation(M_PI*1.5);
	} else if (orientation == UIInterfaceOrientationLandscapeRight) {
		return CGAffineTransformMakeRotation(M_PI/2);
	} else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
		return CGAffineTransformMakeRotation(-M_PI);
	} else {
		return CGAffineTransformIdentity;
	}
}

- (void)sizeToFitOrientation:(BOOL)transform {
	if (transform) {
		self.transform = CGAffineTransformIdentity;
	}
	
	CGRect frame = [UIScreen mainScreen].applicationFrame;
	CGPoint center = CGPointMake(
								 frame.origin.x + ceil(frame.size.width/2),
								 frame.origin.y + ceil(frame.size.height/2));
	
	CGFloat width = frame.size.width - kPadding * 2;
	CGFloat height = frame.size.height - kPadding * 2;
	
	_orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (UIInterfaceOrientationIsLandscape(_orientation)) {
		self.frame = CGRectMake(kPadding, kPadding, height, width);
	} else {
		self.frame = CGRectMake(kPadding, kPadding, width, height);
	}
	self.center = center;
	
	if (transform) {
		self.transform = [self transformForOrientation];
	}
}


- (void)bounce1AnimationStopped {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kTransitionDuration/2];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
	self.transform = CGAffineTransformScale([self transformForOrientation], 0.9, 0.9);
	[UIView commitAnimations];
}

- (void)bounce2AnimationStopped {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kTransitionDuration/2];
	self.transform = [self transformForOrientation];
	[UIView commitAnimations];
}


- (void)cancel {
	//[self dismissWithSuccess:NO animated:YES];
}



- (void)drawRect:(CGRect)rect {
	CGRect grayRect = CGRectOffset(rect, -0.5, -0.5);
	[self drawRect:grayRect fill:kBorderGray radius:1];
	
	CGRect headerRect = CGRectMake(
								   ceil(rect.origin.x + kBorderWidth), ceil(rect.origin.y + kBorderWidth),
								   rect.size.width - kBorderWidth*2, _titleLabel.frame.size.height);
	[self drawRect:headerRect fill:kFacebookBlue radius:0];
	[self strokeLines:headerRect stroke:kBorderBlue];
	
	CGRect webRect = CGRectMake(
								ceil(rect.origin.x + kBorderWidth), headerRect.origin.y + headerRect.size.height,
								rect.size.width - kBorderWidth*2, _loginView.frame.size.height+1);
	[self strokeLines:webRect stroke:kBorderBlack];
}


-(void)doTweet:(NSString*)twitUser password:(NSString*)twitPassword
{
	//UIImage *img = [self getCurrentFrameAndSaveIt];
	twit = [[OLBTwitpicEngine alloc]initWithDelegate:self];
	[twit uploadImageToTwitpic:flyerImage withMessage:nil username:twitUser password:twitPassword];
}

- (void)twitpicEngine:(OLBTwitpicEngine *)engine didUploadImageWithResponse:(NSString *)response{
	NSLog(response);
}


-(void)sendStatusCode:(NSInteger)statusCode
{
	printf("status:%d",statusCode);
	if(statusCode == 200)
	{
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		
		[defaults setObject:passwordField.text forKey:@"tpass_pref"];
		[defaults setObject:loginField.text forKey:@"tuser_pref"];
		
		
		//[self.navigationController dismissModalViewControllerAnimated:YES];
		//[self.navigationController popViewControllerAnimated:YES];
		[self dismiss:YES];
		//svController.twitUser = loginField.text;
		//svController.twitPass = passwordField.text;
		//svController.uploadButton.alpha = 1;
		//[svController callTwitAlert];
		//[svController.uploadButton addTarget:svController action:@selector(callTwitAlert) forControlEvents:UIControlEventTouchUpInside];
		//[self doTweet:loginField.text password:passwordField.text];
		NSLog(@"200");
	}
	else
	{
		UIAlertView *fail = [[UIAlertView alloc]initWithTitle:@"Twitter" message:@"Authentication failed: Wrong username or password combination." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[fail show];
	}
}

-(void)callLoginFromLoginController
{
	if([loginField.text isEqualToString:@""] || loginField.text == nil )
	{
		loginField.text = @"";
		passwordField.text=@"";
	//	[[NSNotificationCenter defaultCenter] removeObserver:self];
	}
	
	
	[loginField resignFirstResponder];
	[passwordField resignFirstResponder];
	NSString *userName = loginField.text ;
	NSString *passWord=passwordField.text;
	
	
	MGTwitterEngine *mte = [[MGTwitterEngine alloc]initWithDelegate:self];
	[MGTwitterEngine setUsername:userName password:passWord remember:[rememberSwitch isOn]];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"AccountChanged" object:nil 
													  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:userName, @"login", passWord, @"password", nil]];
	

	mte.twitLoginView =self;
	[mte showHUD];
	NSString *temp = [mte checkUserCredentials];
	NSLog(temp);
	//[lController login:loginField.text password:passwordField.text];
}

-(void)callCancelFromLoginController
{

	[UIView beginAnimations:@"temp" context:nil];
	[UIView setAnimationDuration:1];
	//[self removeFromSuperview];
	
	//self.frame = CGRectMake(160, 220, 0,0);
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(releaseSelf)];
	[UIView commitAnimations];
}

- (void)show {

	[self sizeToFitOrientation:YES];
	
	CGFloat innerWidth = self.frame.size.width - (kBorderWidth+1)*2;  
	[_iconView sizeToFit];
	[_titleLabel sizeToFit];
	[_closeButton sizeToFit];
	
	/*_titleLabel.frame = CGRectMake(
								   kBorderWidth + kTitleMarginX + _iconView.frame.size.width + kTitleMarginX,
								   kBorderWidth,
								   innerWidth - (_titleLabel.frame.size.height + _iconView.frame.size.width + kTitleMarginX*2),
								   _titleLabel.frame.size.height + kTitleMarginY*2);
	*/
	_titleLabel.frame = CGRectMake(20,10,200,30);
	_iconView.frame = CGRectMake(70,10,150,40);
	
	_closeButton.frame = CGRectMake(
									self.frame.size.width - (_titleLabel.frame.size.height + kBorderWidth),
									kBorderWidth,
									_titleLabel.frame.size.height,
									_titleLabel.frame.size.height);
	
	_loginView.frame = CGRectMake(
								kBorderWidth+1,
								kBorderWidth + _titleLabel.frame.size.height,
								innerWidth,
								self.frame.size.height - (_titleLabel.frame.size.height + 1 + kBorderWidth*2));
	
	[_spinner sizeToFit];
	[_spinner startAnimating];
	_spinner.center = _loginView.center;
	
	UIWindow* window = [UIApplication sharedApplication].keyWindow;
	if (!window) {
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	}
	self.frame = CGRectMake(0,44, 321, 417);
	[window addSubview:self];

	
	UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 100, 85, 30)];
	loginLabel.text = @"Username:";
	loginLabel.numberOfLines = 2;
	loginLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	loginLabel.backgroundColor = [UIColor clearColor];
	[self addSubview:loginLabel];
	
	UILabel *passLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 135, 85, 30)];
	passLabel.text = @"Password:";
	passLabel.backgroundColor = [UIColor clearColor];
	passLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	[self addSubview:passLabel];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString  *passStr = [defaults objectForKey:@"tpass_pref"];
	NSString *userStr = [defaults objectForKey:@"tuser_pref"];	
	
	loginField = [[UITextField alloc]initWithFrame: CGRectMake(90, 100, 190, 30)];
	loginField.placeholder = @"Username";
	loginField.text = userStr;
	loginField.borderStyle = UITextBorderStyleRoundedRect;
	loginField.autocorrectionType = UITextAutocorrectionTypeNo;
	[self addSubview:loginField];
	
	
	passwordField = [[UITextField alloc]initWithFrame: CGRectMake(90, 135, 190, 30)];
	passwordField.placeholder = @"Password";
	passwordField.text = passStr;
	passwordField.borderStyle = UITextBorderStyleRoundedRect;
	passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
	passwordField.secureTextEntry = YES;
	[self addSubview:passwordField];
	
	
	loginField.delegate = self;
	passwordField.delegate = self;
	
	//[loginField setText:[MGTwitterEngine username]];
	//[passwordField setText:[MGTwitterEngine password]];
	
	loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	loginButton.frame = CGRectMake(90, 180, 150, 30);
	[loginButton setTitle:@"Sign In" forState:UIControlStateNormal];
	[loginButton setBackgroundImage:[UIImage imageNamed:@"signin.png"] forState:UIControlStateNormal];
	[loginButton addTarget:self action:@selector(callLoginFromLoginController) forControlEvents:UIControlEventTouchUpInside];
          [self addSubview:loginButton];
		[_loginView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"twitBack.png"]]];
	[_closeButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
	

	
	self.transform = CGAffineTransformScale([self transformForOrientation], 0.001, 0.001);
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kTransitionDuration/1.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
	self.transform = CGAffineTransformScale([self transformForOrientation], 1.1, 1.1);
	[UIView commitAnimations];


	
	
	passwordField.text = passStr;
	loginField.text = userStr;
}

- (void)postDismissCleanup {
	//[svController enableBack];
	[self removeFromSuperview];
}

- (void)dismiss:(BOOL)animated {
	
	
	if (animated) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:kTransitionDuration];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(postDismissCleanup)];
		self.alpha = 0;
		[UIView commitAnimations];
	} else {
		[self postDismissCleanup];
	}
}
- (id)initWithFrame:(CGRect)frame 
{
	
	
    if (self = [super initWithFrame:CGRectZero]) {
		_notificationFlag = NO;
		_orientation = UIDeviceOrientationUnknown;
		_showingKeyboard = NO;
		
		self.backgroundColor = [UIColor clearColor];
		self.autoresizesSubviews = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.contentMode = UIViewContentModeRedraw;
		
	        UIImage* closeImage = [UIImage imageNamed:@"close.png"];
		
		UIColor* color = [UIColor colorWithRed:167.0/255 green:184.0/255 blue:216.0/255 alpha:1];
		_closeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[_closeButton setImage:closeImage forState:UIControlStateNormal];
		[_closeButton setTitleColor:color forState:UIControlStateNormal];
		[_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
		[_closeButton addTarget:self action:@selector(cancel)
			   forControlEvents:UIControlEventTouchUpInside];
		_closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
		_closeButton.showsTouchWhenHighlighted = YES;
		_closeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
		| UIViewAutoresizingFlexibleBottomMargin;
		[self addSubview:_closeButton];
		
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_titleLabel.text = kDefaultTitle;
		_titleLabel.backgroundColor = [UIColor clearColor];
		_titleLabel.textColor = [UIColor whiteColor];
		_titleLabel.font = [UIFont boldSystemFontOfSize:14];
		_titleLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin
		| UIViewAutoresizingFlexibleBottomMargin;
		[self addSubview:_titleLabel];
		
		_loginView = [[UIView alloc] initWithFrame:CGRectZero];
		_loginView.backgroundColor = [UIColor whiteColor];
		_loginView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubview:_loginView];
		
		
		
		UIImage* iconImage = [UIImage imageNamed:@"logo.png"];
		
		_iconView = [[UIImageView alloc] initWithImage:iconImage];
		[_loginView addSubview:_iconView];
		
		//_spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
					//UIActivityIndicatorViewStyleWhiteLarge];
		//_spinner.autoresizingMask =
		//UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
		//| UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
		//[self addSubview:_spinner];
	}
	    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	//textField.returnKeyType = UIReturnKeyDone;
	//textField.keyboardType = UIKeyboardTypeDefault;
	if(textField == loginField)
	{
		[loginField resignFirstResponder];
		[passwordField becomeFirstResponder];
	}
	else{

		[passwordField resignFirstResponder];
	}
	
	return NO;
}



- (void)dealloc {
    [super dealloc];
}


@end
