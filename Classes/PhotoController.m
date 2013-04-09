//
//  PhotoController.m
//  Flyer
//
//  Created by Krunal on 12/10/09.
//  Copyright 2009 iauro. All rights reserved.
//

#import "PhotoController.h"
#import <QuartzCore/QuartzCore.h>
#import "Common.h"
#import "LoginController.h"
#import "FlyrAppDelegate.h"
#import "MyNavigationBar.h"
#import  "SaveFlyerController.h"
#import "ImageCache.h"

@implementation PhotoController
@synthesize imgView,imgPicker;
@synthesize fontScrollView,colorScrollView,templateScrollView,sizeScrollView;
@synthesize msgTextView,finalFlyer;
@synthesize selectedFont,selectedColor,navBar;
@synthesize selectedTemplate;
@synthesize fontTabButton,colorTabButton,sizeTabButton,selectedText,selectedSize;
@synthesize templateBckgrnd,textBackgrnd,aHUD;
@synthesize widthScrollView,heightScrollView,photoTabButton,widthTabButton,heightTabButton,photoImgView;
@synthesize photoTouchFlag,lableTouchFlag,lableLocation,warningAlert;



#pragma mark  View Appear Methods
-(void)viewWillAppear:(BOOL)animated{
	
	[super viewWillAppear:YES];	
	imgPicker = [[UIImagePickerController alloc] init];
	imgPicker.allowsImageEditing = NO;
	photoTouchFlag=NO;
	lableTouchFlag=NO;
	imgPicker.delegate =self;
	imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	navBar.alpha =ALPHA1;
}

- (void) handleMemoryWarning:(NSNotification *)notification
{
	FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
	[appDele clearCache];
}

-(void)viewDidLoad{
	[super viewDidLoad];
	aHUD = [[HudView alloc]init];
	FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
	appDele.changesFlag = YES;

	[[NSNotificationCenter defaultCenter] addObserver:[[UIApplication sharedApplication] delegate]
											 selector:@selector(handleMemoryWarning:)
												 name:@"UIApplicationMemoryWarningNotification"
											   object:nil];
	

	
	navBar= [[MyNavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
	[self.view addSubview:navBar];

	//Default Selection for start
	selectedFont = [UIFont fontWithName:@"Arial" size:16];
	selectedColor = [UIColor blackColor];	
	selectedText = @"";
	selectedSize = 16;
	selectedTemplate  = [UIImage imageNamed:@"Default.png"];
	lableLocation = CGPointMake(160,100);
	
	
	// Create Main Image View
	imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
	imgView.image = selectedTemplate;
	[self.view addSubview:imgView];

	photoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 50, 220, 200)];
	[photoImgView setUserInteractionEnabled:NO];

	templateBckgrnd = [[UIImageView alloc]initWithFrame:CGRectMake(0, 395, 320, 65)];
	templateBckgrnd.image = [UIImage imageNamed:@"scroll1.png"];
	[self.view addSubview:templateBckgrnd];
	templateBckgrnd.alpha = ALPHA0;
	
	textBackgrnd = [[UIImageView alloc]initWithFrame:CGRectMake(0, 385, 320, 44)];
	textBackgrnd.image = [UIImage imageNamed:@"scroll2.png"];
	[self.view addSubview:textBackgrnd];
	textBackgrnd.alpha = ALPHA0;

	msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 320, 500)];
	msgLabel.backgroundColor = [UIColor clearColor];
	msgLabel.textColor = [UIColor blackColor];
	msgLabel.textAlignment = UITextAlignmentCenter;
	[self.imgView addSubview:msgLabel];
	
	msgTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 50, 280, 150)];
	msgTextView.delegate = self;
	msgTextView.font = [UIFont fontWithName:@"Arial" size:16];
	msgTextView.textColor = [UIColor blackColor];
	msgTextView.textAlignment = UITextAlignmentCenter;
	
	templateScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 395,320,60)];
	fontScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385,320,44)];
	colorScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385,320,44)];
	sizeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385, 320, 44)];
	widthScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385,320,44)];
	heightScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385, 320, 44)];
	
		
	NSInteger templateScrollWidth = 60;
	NSInteger templateScrollHeight = 55;
		
	//FlyrAppDelegate *appDele = [[UIApplication sharedApplication]delegate];

	templateArray = [[NSMutableArray alloc]init];
	//appDele.iconArray = [[NSMutableArray alloc]init];
	NSAutoreleasePool* pool1 = [[NSAutoreleasePool alloc] init];

	for(int i=0;i<67;i++)
	{

		NSString* templateName = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Template%d",i] ofType:@"jpg"];
		UIImage *templateImg =  [UIImage imageWithContentsOfFile:templateName];
		[templateArray addObject:templateImg];
		
		NSString* iconName = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon%d",i] ofType:@"jpg"];
		UIImage *iconImg =   [UIImage  imageWithContentsOfFile:iconName];
		//UIImage *iconImg = [appDele.iconArray objectAtIndex:i];
		//[appDele.iconArray addObject:iconImg];
		//UIImage *templateImg = [appDele.templateArray objectAtIndex:i];
		
		
		UIButton *templateButton = [UIButton  buttonWithType:UIButtonTypeCustom];
		templateButton.frame =CGRectMake(0, 5,templateScrollWidth, templateScrollHeight);
		[templateButton setBackgroundImage:[UIImage imageNamed:@"button1.png"] forState:UIControlStateNormal];
		
		//UIImageView *img = [[[UIImageView alloc]initWithFrame:CGRectMake(templateButton.frame.origin.x+5, templateButton.frame.origin.y+2, templateButton.frame.size.width-10, templateButton.frame.size.height-14)]autorelease];
		//[img setImage:iconImg];
		UIImageView *img = [[UIImageView alloc]initWithImage:iconImg];
		//[img initWithImage:iconImg];
		img.frame  = CGRectMake(templateButton.frame.origin.x+5, templateButton.frame.origin.y+2, templateButton.frame.size.width-10, templateButton.frame.size.height-14);
		[templateButton addSubview:img];
		//templateButton.alpha = ALPHA1;
		templateButton.tag = i;	
		[templateScrollView addSubview:templateButton];
		//[templateButton release];
	}
	[pool1 release];

	fontArray =[[NSArray  alloc] initWithObjects: 
				[UIFont fontWithName:@"Courier" size:16],
				[UIFont fontWithName:@"Courier-BoldOblique" size:16],
				[UIFont fontWithName:@"Courier-Oblique" size:16],
				[UIFont fontWithName:@"Courier-Bold" size:16],
				[UIFont fontWithName:@"ArialMT" size:16],
				[UIFont fontWithName:@"Arial-BoldMT" size:16],
				[UIFont fontWithName:@"Arial-BoldItalicMT" size:16],
				[UIFont fontWithName:@"Arial-ItalicMT" size:16],
				[UIFont fontWithName:@"STHeitiTC-Light" size:16],
				[UIFont fontWithName:@"AppleGothic" size:16],
				[UIFont fontWithName:@"CourierNewPS-BoldMT" size:16],
				[UIFont fontWithName:@"CourierNewPS-ItalicMT" size:16],
				[UIFont fontWithName:@"Zapfino" size:16],
				[UIFont fontWithName:@"TimesNewRomanPSMT" size:16],
				[UIFont fontWithName:@"Verdana-Italic" size:16],
				[UIFont fontWithName:@"Verdana" size:16],
				[UIFont fontWithName:@"Georgia" size:16],
				[UIFont fontWithName:@"Georgia-BoldItalic" size:16],
				[UIFont fontWithName:@"Georgia-Italic" size:16],
				[UIFont fontWithName:@"TrebuchetMS" size:16],
				[UIFont fontWithName:@"Trebuchet-BoldItalic" size:16],
				[UIFont fontWithName:@"Helvetica" size:16],
				[UIFont fontWithName:@"Helvetica-Oblique" size:16],
				[UIFont fontWithName:@"Helvetica-Bold" size:16],
				[UIFont fontWithName:@"AmericanTypewriter" size:16],
				[UIFont fontWithName:@"AmericanTypewriter-Bold" size:16],
				[UIFont fontWithName:@"ArialUnicodeMS" size:16],
				[UIFont fontWithName:@"HiraKakuProN-W6" size:16],
				nil];
	
	
	NSInteger fontScrollWidth = 44;
	NSInteger fontScrollHeight = 35;
	for (int i = 1; i <=[fontArray count] ; i++)
	{
		UIButton *font = [UIButton buttonWithType:UIButtonTypeCustom];
		font.frame = CGRectMake(0, 5, fontScrollWidth, fontScrollHeight);

		
		[font setTitle:@"A" forState:UIControlStateNormal];
		UIFont *fontname =[fontArray objectAtIndex:(i-1)];
		[font.titleLabel setFont: fontname];
		[font setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		font.tag = i;	
		font.alpha = ALPHA1;
		[font setBackgroundImage:[UIImage imageNamed:@"button1.png"] forState:UIControlStateNormal];
		[fontScrollView addSubview:font];
		//[font release];
	}
	
	colorArray = 	[[NSArray  alloc] initWithObjects: [UIColor whiteColor], [UIColor darkGrayColor], [UIColor grayColor], [UIColor orangeColor], [UIColor blackColor], [UIColor blueColor], [UIColor redColor], [UIColor greenColor], [UIColor purpleColor], [UIColor yellowColor], [UIColor brownColor], [UIColor cyanColor], [UIColor magentaColor],nil];
	
	NSInteger colorScrollWidth = 44;
	NSInteger colorScrollHeight = 35;
	for (int i = 1; i <=  [colorArray count] ; i++)
	{
		UIButton *color = [UIButton buttonWithType:UIButtonTypeCustom];
		color.frame = CGRectMake(0, 5, colorScrollWidth, colorScrollHeight);
		[color setBackgroundImage:[UIImage imageNamed:@"button1.png"] forState:UIControlStateNormal];
		id colorName =[colorArray objectAtIndex:(i-1)];
		UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(color.frame.origin.x+5, color.frame.origin.y-1, color.frame.size.width-10, color.frame.size.height-8)];
		[label setBackgroundColor:colorName];
		[color addSubview:label];
		color.tag = i+30;	
		color.alpha = ALPHA1;
		[colorScrollView addSubview:color];
		//[color release];
	}
	
	NSInteger sizeScrollWidth = 44;
	NSInteger sizeScrollHeight = 35;
	for (int i = 1; i <=  [SIZE_ARRAY count] ; i++)
	{
		UIButton *size = [UIButton buttonWithType:UIButtonTypeCustom];
		size.frame = CGRectMake(0, 5, sizeScrollWidth, sizeScrollHeight);
		NSString *sizeValue =[SIZE_ARRAY objectAtIndex:(i-1)];
		[size setBackgroundImage:[UIImage imageNamed:@"button1.png"] forState:UIControlStateNormal];
		[size setTitle:sizeValue forState:UIControlStateNormal];
		[size.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
		[size setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		size.tag = i+60;	
		size.alpha = ALPHA1;
		[sizeScrollView addSubview:size];
		//[size release];
	}
	
	
	NSInteger widthScrollWidth = 44;
	NSInteger widthScrollHeight = 35;
	for (int i = 1; i <=[WIDTH_ARRAY count] ; i++)
	{
		UIButton *width = [UIButton buttonWithType:UIButtonTypeCustom];
		width.frame = CGRectMake(0, 5, widthScrollWidth, widthScrollHeight);
		NSString *sizeValue =[WIDTH_ARRAY objectAtIndex:(i-1)];
		[width setBackgroundImage:[UIImage imageNamed:@"button1.png"] forState:UIControlStateNormal];
		[width setTitle:sizeValue forState:UIControlStateNormal];
		[width setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		width.tag = i+60;
		width.alpha = ALPHA1;
		[width.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
		[widthScrollView addSubview:width];
		//[width release];
	}
	
	
	NSInteger heightScrollWidth = 44;
	NSInteger heightScrollHeight = 35;
	for (int i = 1; i <=[HEIGHT_ARRAY count] ; i++)
	{
		UIButton *height = [UIButton buttonWithType:UIButtonTypeCustom];
		height.frame = CGRectMake(0, 5, heightScrollWidth, heightScrollHeight);
		NSString *sizeValue =[HEIGHT_ARRAY objectAtIndex:(i-1)];
		[height setBackgroundImage:[UIImage imageNamed:@"button1.png"] forState:UIControlStateNormal];
		[height setTitle:sizeValue forState:UIControlStateNormal];
		[height setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		height.tag = i+60;	
		[height.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
		height.alpha = ALPHA1;
		[heightScrollView addSubview:height];
	//	[height release];
	}
	
	[templateScrollView setCanCancelContentTouches:NO];
	templateScrollView.scrollEnabled = YES;
	templateScrollView.pagingEnabled = NO;
	templateScrollView.showsHorizontalScrollIndicator = NO;
	templateScrollView.showsVerticalScrollIndicator = NO;
	templateScrollView.alpha = ALPHA1;
	[self.view addSubview:templateScrollView];
	[self layoutScrollImages:templateScrollView scrollWidth:templateScrollWidth scrollHeight:templateScrollHeight];
	
	[fontScrollView setCanCancelContentTouches:NO];
	fontScrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
	fontScrollView.clipsToBounds = YES;	
	fontScrollView.scrollEnabled = YES;
	fontScrollView.pagingEnabled = NO;
	fontScrollView.showsHorizontalScrollIndicator = NO;
	fontScrollView.showsVerticalScrollIndicator = NO;
	fontScrollView.alpha = ALPHA0;
	[self.view addSubview:fontScrollView];
	[self layoutScrollImages:fontScrollView scrollWidth:fontScrollWidth scrollHeight:fontScrollHeight];
	
	[colorScrollView setCanCancelContentTouches:NO];
	colorScrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
	colorScrollView.clipsToBounds = YES;	
	colorScrollView.scrollEnabled = YES;
	colorScrollView.pagingEnabled = NO;
	colorScrollView.showsHorizontalScrollIndicator = NO;
	colorScrollView.showsVerticalScrollIndicator = NO;
	colorScrollView.alpha = ALPHA0;
	[self.view addSubview:colorScrollView];
	[self layoutScrollImages:colorScrollView scrollWidth:colorScrollWidth scrollHeight:colorScrollHeight];
	
	
	[sizeScrollView setCanCancelContentTouches:NO];
	sizeScrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
	sizeScrollView.clipsToBounds = YES;	
	sizeScrollView.scrollEnabled = YES;
	sizeScrollView.pagingEnabled = NO;
	sizeScrollView.showsHorizontalScrollIndicator = NO;
	sizeScrollView.showsVerticalScrollIndicator = NO;
	sizeScrollView.alpha = ALPHA0;
	[self.view addSubview:sizeScrollView];
	[self layoutScrollImages:sizeScrollView scrollWidth:sizeScrollWidth scrollHeight:sizeScrollHeight];
	
	[widthScrollView setCanCancelContentTouches:NO];
	widthScrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
	widthScrollView.clipsToBounds = YES;	
	widthScrollView.scrollEnabled = YES;
	widthScrollView.pagingEnabled = NO;
	widthScrollView.showsHorizontalScrollIndicator = NO;
	widthScrollView.showsVerticalScrollIndicator = NO;
	widthScrollView.alpha = ALPHA0;
	[self.view addSubview:widthScrollView];
	[self layoutScrollImages:widthScrollView scrollWidth:widthScrollWidth scrollHeight:widthScrollHeight];
	
	[heightScrollView setCanCancelContentTouches:NO];
	heightScrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
	heightScrollView.clipsToBounds = YES;	
	heightScrollView.scrollEnabled = YES;
	heightScrollView.pagingEnabled = NO;
	heightScrollView.showsHorizontalScrollIndicator = NO;
	heightScrollView.showsVerticalScrollIndicator = NO;
	heightScrollView.alpha = ALPHA0;
	[self.view addSubview:heightScrollView];
	[self layoutScrollImages:heightScrollView scrollWidth:heightScrollWidth scrollHeight:heightScrollHeight];
	 
	
	fontTabButton =[UIButton buttonWithType:UIButtonTypeCustom];
	fontTabButton.frame = CGRectMake(-1, 429, 107, 32);
	[fontTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
	[fontTabButton setTitle:@"Font" forState:UIControlStateNormal];
	[fontTabButton.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
	[fontTabButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[fontTabButton addTarget:self action:@selector(setStyleTabAction:) forControlEvents:UIControlEventTouchUpInside];
	fontTabButton.alpha =  ALPHA0;
	fontTabButton.tag = 10001;
	[self.view addSubview:fontTabButton];
	
	colorTabButton =[UIButton buttonWithType:UIButtonTypeCustom];
	colorTabButton.frame = CGRectMake(106, 429, 109, 32);
	[colorTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
	[colorTabButton setTitle:@"Color" forState:UIControlStateNormal];
	[colorTabButton.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
	[colorTabButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[colorTabButton addTarget:self action:@selector(setStyleTabAction:) forControlEvents:UIControlEventTouchUpInside];
	colorTabButton.alpha =  ALPHA0;
	colorTabButton.tag = 10002;
	[self.view addSubview:colorTabButton];
	
	sizeTabButton =[UIButton buttonWithType:UIButtonTypeCustom];
	sizeTabButton.frame = CGRectMake(107+107, 429, 107, 32);
	[sizeTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
	[sizeTabButton setTitle:@"Size" forState:UIControlStateNormal];
	[sizeTabButton.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
	[sizeTabButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[sizeTabButton addTarget:self action:@selector(setStyleTabAction:) forControlEvents:UIControlEventTouchUpInside];
	sizeTabButton.alpha =  ALPHA0;
	sizeTabButton.tag = 10003;
	[self.view addSubview:sizeTabButton];

	photoTabButton =[UIButton buttonWithType:UIButtonTypeCustom];
	photoTabButton.frame = CGRectMake(-1, 429, 107, 32);
	[photoTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
	[photoTabButton setTitle:@"Photo" forState:UIControlStateNormal];
	[photoTabButton.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
	[photoTabButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[photoTabButton addTarget:self action:@selector(setPhotoTabAction:) forControlEvents:UIControlEventTouchUpInside];
	photoTabButton.alpha =  ALPHA0;
	photoTabButton.tag = 10001;
	[self.view addSubview:photoTabButton];
	
	widthTabButton =[UIButton buttonWithType:UIButtonTypeCustom];
	widthTabButton.frame = CGRectMake(106, 429, 107, 32);
	[widthTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
	[widthTabButton setTitle:@"Width" forState:UIControlStateNormal];
	[widthTabButton.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
	[widthTabButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[widthTabButton addTarget:self action:@selector(setPhotoTabAction:) forControlEvents:UIControlEventTouchUpInside];
	widthTabButton.alpha =  ALPHA0;
	widthTabButton.tag = 10003;
	[self.view addSubview:widthTabButton];
	
	heightTabButton =[UIButton buttonWithType:UIButtonTypeCustom];
	heightTabButton.frame = CGRectMake(107+107, 429, 107, 32);
	[heightTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
	[heightTabButton setTitle:@"Height" forState:UIControlStateNormal];
	[heightTabButton.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
	[heightTabButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[heightTabButton addTarget:self action:@selector(setPhotoTabAction:) forControlEvents:UIControlEventTouchUpInside];
	heightTabButton.alpha =  ALPHA0;
	heightTabButton.tag = 10002;
	[self.view addSubview:heightTabButton];
	 

	imgPickerFlag =1;
	[self chooseTemplate];
}


#pragma mark  ScrollView Function & Selection Methods for ScrollView
-(void)selectFont:(id)sender
{
	FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
	appDele.changesFlag = YES;
	int  i=1;
	UIButton *view = sender;
	for(UIView *tempView  in [fontScrollView subviews]) 
	{
		if(tempView == view)
		{
			selectedFont = [fontArray objectAtIndex:i-1];
			selectedFont = [selectedFont fontWithSize:selectedSize];
			msgTextView.font = selectedFont;
			msgLabel.font =selectedFont;
		}
		i++;
	}
}

-(void)selectColor:(id)sender
{
	FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
	appDele.changesFlag = YES;
	int  i=1;
	UIButton *view = sender;
	for(UIView *tempView  in [colorScrollView subviews]) 
	{
		if(tempView == view)
		{
			selectedColor = [colorArray objectAtIndex:i-1];
			msgTextView.textColor = selectedColor;
			msgLabel.textColor = selectedColor;
		}
		i++;
	}
}

-(void)selectTemplate:(id)sender
{
	FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
	appDele.changesFlag = YES;
	UIButton *view = sender;
	selectedTemplate  =  [templateArray objectAtIndex:view.tag];
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionPush];
	[animation setSubtype:kCATransitionMoveIn];
	[animation setDuration:0.4f];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.imgView  layer] addAnimation:animation forKey:@"SwitchToView1"];
	[imgView setImage:selectedTemplate];
}



-(void)selectSize:(id)sender{
	FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
	appDele.changesFlag = YES;
	int  i=1;
	UIButton *view = sender;
	for(UIView *tempView  in [sizeScrollView subviews]) 
	{
		if(tempView == view)
		{
			NSString *sizeStr = [SIZE_ARRAY objectAtIndex:i-1];
			selectedSize = [sizeStr intValue];
			selectedFont = [selectedFont fontWithSize:selectedSize];
			msgTextView.font = selectedFont;
			msgLabel.font =selectedFont;
			//msgLabel.frame = CGRectMake(lableLocation.x,lableLocation.y,msgTextView.frame.size.width, msgTextView.contentSize.height);
			//msgLabel.frame = CGRectMake(0,44,320,msgTextView.contentSize.height);
			msgLabel.frame = CGRectMake(0, 10, 320,500 );
		}
		i++;	
	}
}


-(void)selectWidth:(id)sender{
	FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
	appDele.changesFlag = YES;
	int  i=1;
	UIButton *view = sender;
	for(UIView *tempView  in [widthScrollView subviews]) 
	{
		if(tempView == view)
		{
			NSString *sizeStr = [WIDTH_ARRAY objectAtIndex:i-1];
			selectedWidth = [sizeStr intValue];
			photoImgView.frame = CGRectMake(photoImgView.frame.origin.x, photoImgView.frame.origin.y,selectedWidth,photoImgView.frame.size.height);
		}
		i++;	
	}
}

-(void)selectHeight:(id)sender{
	FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
	appDele.changesFlag = YES;
	int  i=1;
	UIButton *view = sender;
	for(UIView *tempView  in [heightScrollView subviews]) 
	{
		if(tempView == view)
		{
			NSString *sizeStr = [HEIGHT_ARRAY objectAtIndex:i-1];
			selectedHeight = [sizeStr intValue];
			photoImgView.frame = CGRectMake(photoImgView.frame.origin.x, photoImgView.frame.origin.y,photoImgView.frame.size.width,selectedHeight);
		}
		i++;	
	}
}

- (void)layoutScrollImages:(UIScrollView*)selectedScrollView scrollWidth:(NSInteger)kScrollObjWidth scrollHeight:(NSInteger)kScrollObjHeight
{
	//FlyrAppDelegate *appDele = [[UIApplication sharedApplication]delegate];

	if (selectedScrollView == templateScrollView)
	{
		UIButton *view = nil;
		NSArray *subviews = [templateScrollView subviews];
		CGFloat curXLoc = 0;
		for (view in subviews)
		{
			if ([view isKindOfClass:[UIButton class]] )
			{
				CGRect frame = view.frame;
				frame.origin = CGPointMake(curXLoc, 5);
				view.frame = frame;
				curXLoc += (kScrollObjWidth)+5;
				
				imgPickerFlag =1;
				if(view.tag == 0)
					[view addTarget:self action:@selector(loadPhotoLibrary) forControlEvents:UIControlEventTouchUpInside];
				else
					[view addTarget:self action:@selector(selectTemplate:) forControlEvents:UIControlEventTouchUpInside];
				
			}
		}
		[templateScrollView setContentSize:CGSizeMake(([templateArray count]*(kScrollObjWidth+5)), [templateScrollView bounds].size.height)];
	}
	else if(selectedScrollView == fontScrollView)
	{
		
		UIButton *view = nil;
		NSArray *subviews = [fontScrollView subviews];
		
		CGFloat curXLoc = 0;
		for (view in subviews)
		{
			if ([view isKindOfClass:[UIButton class]] )
			{
				CGRect frame = view.frame;
				frame.origin = CGPointMake(curXLoc, 5);
				view.frame = frame;
				curXLoc += (kScrollObjWidth)+5;
				[view addTarget:self action:@selector(selectFont:) forControlEvents:UIControlEventTouchUpInside];
			}
		}
		[fontScrollView setContentSize:CGSizeMake((  [fontArray count]*(kScrollObjWidth+5)), [fontScrollView bounds].size.height)];
	}
	else if (selectedScrollView == colorScrollView)
	{
		UIButton *view = nil;
		NSArray *subviews = [colorScrollView subviews];
		
		CGFloat curXLoc = 0;
		for (view in subviews)
		{
			if ([view isKindOfClass:[UIButton class]] )
			{
				CGRect frame = view.frame;
				frame.origin = CGPointMake(curXLoc, 5);
				view.frame = frame;
				curXLoc += (kScrollObjWidth)+5;
				[view addTarget:self action:@selector(selectColor:) forControlEvents:UIControlEventTouchUpInside];
				
			}
		}
		[colorScrollView setContentSize:CGSizeMake((  [colorArray count]*(kScrollObjWidth+5)), [colorScrollView bounds].size.height)];
	}
	else if (selectedScrollView == sizeScrollView)
	{
		UIButton *view = nil;
		NSArray *subviews = [sizeScrollView subviews];
		
		CGFloat curXLoc = 0;
		for (view in subviews)
		{
			if ([view isKindOfClass:[UIButton class]])
			{
				CGRect frame = view.frame;
				frame.origin = CGPointMake(curXLoc, 5);
				view.frame = frame;
				curXLoc += (kScrollObjWidth)+5;
				[view addTarget:self action:@selector(selectSize:) forControlEvents:UIControlEventTouchUpInside];
				
			}
		}
		[sizeScrollView setContentSize:CGSizeMake((  [SIZE_ARRAY count]*(kScrollObjWidth+5)), [sizeScrollView bounds].size.height)];
	}
	else if (selectedScrollView == widthScrollView)
	{
		UIButton *view = nil;
		NSArray *subviews = [widthScrollView subviews];
		
		CGFloat curXLoc = 0;
		for (view in subviews)
		{
			if ([view isKindOfClass:[UIButton class]])
			{
				CGRect frame = view.frame;
				frame.origin = CGPointMake(curXLoc, 5);
				view.frame = frame;
				curXLoc += (kScrollObjWidth)+5;
				[view addTarget:self action:@selector(selectWidth:) forControlEvents:UIControlEventTouchUpInside];
				
			}
		}
		[widthScrollView setContentSize:CGSizeMake((  [SIZE_ARRAY count]*(kScrollObjWidth+5)), [widthScrollView bounds].size.height)];
	}
	else if (selectedScrollView == heightScrollView)
	{
		UIButton *view = nil;
		NSArray *subviews = [heightScrollView subviews];
		
		CGFloat curXLoc = 0;
		for (view in subviews)
		{
			if ([view isKindOfClass:[UIButton class]])
			{
				CGRect frame = view.frame;
				frame.origin = CGPointMake(curXLoc, 5);
				view.frame = frame;
				curXLoc += (kScrollObjWidth)+5;
				[view addTarget:self action:@selector(selectHeight:) forControlEvents:UIControlEventTouchUpInside];
				
			}
		}
		[heightScrollView setContentSize:CGSizeMake((  [SIZE_ARRAY count]*(kScrollObjWidth+5)), [heightScrollView bounds].size.height)];
	}
}

#pragma mark  HUD Method
- (void) killHUD
{
	[aHUD removeHud:self.view];
	[aHUD.loadingView removeFromSuperview];
}

- (void) showHUD
{
	[aHUD loadingViewInView:self.view text:@"Saving..."];
}


#pragma mark  imagePicker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {
	
	if(imgPickerFlag == 1){
		
		[[picker parentViewController] dismissModalViewControllerAnimated:YES];
		UIImage *testImage = [img retain];
		[self.imgView setImage:testImage] ;
	}
	else if(imgPickerFlag == 2){
	
		[[picker parentViewController] dismissModalViewControllerAnimated:YES];
		UIImage *testImage = [img retain];
		[self.photoImgView setImage:testImage] ;
		photoTouchFlag = YES;
		lableTouchFlag = NO;
	}
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
	if(imgPickerFlag == 2){
		photoTouchFlag = YES;
		lableTouchFlag = NO;
	}
}

-(void)loadPhotoLibrary{
	
	[self presentModalViewController:self.imgPicker animated:YES];
	if(imgPickerFlag == 2){
		photoTouchFlag = YES;
		lableTouchFlag = NO;
	}
}

#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(alertView == warningAlert && buttonIndex == 1)
	{
		[navBar show:@"" left:@"" right:@""];
		[self.view bringSubviewToFront:navBar];
		[navBar.leftButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
		[navBar.rightButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
		[self.navigationController popToRootViewControllerAnimated:YES];
	}
}

#pragma mark After ViewWillAppear Method Sequence 
-(void) callMenu
{
	FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
	if(appDele.changesFlag)
	{
		warningAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"You have not saved your Flyr. All progress will be lost." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue",nil];
		[warningAlert show];
	}
	else
	{
		[navBar show:@"" left:@"" right:@""];
		[self.view bringSubviewToFront:navBar];
		[navBar.leftButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
		[navBar.rightButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
		
		[self.navigationController popToRootViewControllerAnimated:YES];	
	}
	
	
}

-(void)chooseTemplate{
	photoTouchFlag=NO;
	lableTouchFlag=NO;
	imgPickerFlag = 1;
	
	[navBar show:@"Select Template" left:@"Menu" right:@"Text"];
	[self.view bringSubviewToFront:navBar];
	[navBar.leftButton removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	[navBar.rightButton removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	
	[navBar.leftButton addTarget:self action:@selector(callMenu) forControlEvents:UIControlEventTouchUpInside];
	[navBar.rightButton addTarget:self action:@selector(callWrite) forControlEvents:UIControlEventTouchUpInside];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4f];
	templateScrollView.alpha = ALPHA1;
	templateBckgrnd.alpha = ALPHA1;
	[self.templateBckgrnd bringSubviewToFront:templateScrollView];
	templateScrollView.frame= CGRectMake(0, 395,320 ,60);
	msgLabel.alpha= 1;
	textBackgrnd.alpha  =ALPHA0;
	fontTabButton.alpha = ALPHA0;
	colorTabButton.alpha = ALPHA0;
	sizeTabButton.alpha = ALPHA0;
	[msgTextView removeFromSuperview];
	[UIView commitAnimations];

}

-(void)callKeyboard{
		[msgTextView becomeFirstResponder];
}


-(void)callWrite{
	photoTouchFlag=NO;
	lableTouchFlag=NO;
	[navBar show:@"Enter Text" left:@"Template" right:@"Style"];
	[self.view bringSubviewToFront:navBar];
	
	[navBar.leftButton removeTarget:self action:@selector(callMenu) forControlEvents:UIControlEventTouchUpInside];
	[navBar.rightButton removeTarget:self action:@selector(callWrite) forControlEvents:UIControlEventTouchUpInside];
	
	[navBar.leftButton addTarget:self action:@selector(chooseTemplate) forControlEvents:UIControlEventTouchUpInside];
	[navBar.rightButton addTarget:self action:@selector(callStyle) forControlEvents:UIControlEventTouchUpInside];
	
	msgTextView.backgroundColor = [ UIColor colorWithWhite:1 alpha:0.3f];
	msgLabel.alpha =ALPHA0;
 	msgTextView.text = msgLabel.text ;
	[NSTimer scheduledTimerWithTimeInterval:0.001f target:self selector:@selector(callKeyboard) userInfo:nil repeats:NO];
	
	CALayer * l = [msgTextView layer];
	[l setMasksToBounds:YES];
	[l setCornerRadius:10];
	[l setBorderWidth:1.0];
	[l setBorderColor:[[UIColor grayColor] CGColor]];
	[self.view addSubview:msgTextView];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4f];
	msgTextView.frame = CGRectMake(20, 50, 280, 150);
	templateBckgrnd.alpha = ALPHA0;

	templateScrollView.frame= CGRectMake(-320, 395,320 ,60);
	fontScrollView.frame = CGRectMake(-320, 385, 320, 44);
	colorScrollView.frame = CGRectMake(-320, 385, 320, 44);
	sizeScrollView.frame = CGRectMake(-320, 385, 320, 44);
	[UIView commitAnimations];

}

-(void)callStyle
{
	[navBar show:@"Style Text" left:@"Text" right:@"Photo"];
	[self.view bringSubviewToFront:navBar];
	
	[navBar.leftButton removeTarget:self action:@selector(chooseTemplate) forControlEvents:UIControlEventTouchUpInside];
	[navBar.rightButton removeTarget:self action:@selector(callStyle) forControlEvents:UIControlEventTouchUpInside];
	
	[navBar.leftButton addTarget:self action:@selector(callWrite) forControlEvents:UIControlEventTouchUpInside];
	[navBar.rightButton addTarget:self action:@selector(choosePhoto) forControlEvents:UIControlEventTouchUpInside];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4f];
	fontScrollView.frame = CGRectMake(0, 385, 320, 44);
	colorScrollView.frame = CGRectMake(0, 385, 320, 44);
	sizeScrollView.frame = CGRectMake(0, 385, 320, 44);
	textBackgrnd.alpha = ALPHA1;
	fontScrollView.alpha = ALPHA1;
	colorScrollView.alpha = ALPHA0;
	sizeScrollView.alpha = ALPHA0;
	
	[fontTabButton setBackgroundImage:[UIImage imageNamed:@"selTab.png"] forState:UIControlStateNormal];
	[colorTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
	[sizeTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
	fontTabButton.alpha = ALPHA1;
	colorTabButton.alpha = ALPHA1;
	sizeTabButton.alpha = ALPHA1;
	msgLabel.alpha=1;
	
	
	photoTabButton.alpha = ALPHA0;
	widthTabButton.alpha = ALPHA0;
	heightTabButton.alpha = ALPHA0;
	widthScrollView.frame = CGRectMake(-320, 385, 320, 44);
	heightScrollView.frame = CGRectMake(-320, 385, 320, 44);
	widthScrollView.alpha = ALPHA0;
	heightScrollView.alpha = ALPHA0;
	textBackgrnd.alpha = ALPHA1;
	
	[UIView commitAnimations];
	
	[msgTextView setTextColor:selectedColor];
	[msgLabel setTextColor:selectedColor];
	CALayer * l = [msgTextView layer];
	[l setMasksToBounds:YES];
	[l setCornerRadius:0];
	[l setBorderWidth:0];
	[l setBorderColor:[[UIColor clearColor] CGColor]];
	selectedText = msgTextView.text;
	
	//msgLabel.frame = CGRectMake(lableLocation.x,lableLocation.y,msgLabel.frame.size.width, msgTextView.contentSize.height);
	msgLabel.center = lableLocation;
	msgLabel.numberOfLines = 40;
	msgLabel.text = msgTextView.text;
	[msgTextView resignFirstResponder];
	[msgTextView removeFromSuperview];
	lableTouchFlag = YES;
	photoTouchFlag = NO;

}

-(void)choosePhoto
{

	[navBar show:@"Choose Photo" left:@"Style" right:@"Save/Share"];
	[self.view bringSubviewToFront:navBar];
	
	[navBar.leftButton removeTarget:self action:@selector(chooseTemplate) forControlEvents:UIControlEventTouchUpInside];
	[navBar.rightButton removeTarget:self action:@selector(callWrite) forControlEvents:UIControlEventTouchUpInside];
	
	[navBar.leftButton addTarget:self action:@selector(callStyle) forControlEvents:UIControlEventTouchUpInside];
	[navBar.rightButton addTarget:self action:@selector(callSaveAndShare) forControlEvents:UIControlEventTouchUpInside];
		
	CALayer * l = [photoImgView layer];
	[l setMasksToBounds:YES];
	[l setCornerRadius:10];
	[l setBorderWidth:1.0];
	[l setBorderColor:[[UIColor grayColor] CGColor]];
	[photoImgView setBackgroundColor:[ UIColor colorWithWhite:1 alpha:0.4f]];
	[self.imgView addSubview:photoImgView];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4f];
	fontTabButton.alpha = ALPHA0;
	colorTabButton.alpha = ALPHA0;
	sizeTabButton.alpha = ALPHA0;
	fontScrollView.frame = CGRectMake(-320, 385, 320, 44);
	colorScrollView.frame = CGRectMake(-320, 385, 320, 44);
	sizeScrollView.frame = CGRectMake(-320, 385, 320, 44);
	msgLabel.alpha=1;
	[photoTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
	[widthTabButton setBackgroundImage:[UIImage imageNamed:@"selTab.png"] forState:UIControlStateNormal];
	[heightTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
	photoTabButton.alpha = ALPHA1;
	widthTabButton.alpha = ALPHA1;
	heightTabButton.alpha = ALPHA1;
	widthScrollView.frame = CGRectMake(0, 385, 320, 44);
	heightScrollView.frame = CGRectMake(0, 385, 320, 44);
	widthScrollView.alpha = ALPHA1;
	heightScrollView.alpha = ALPHA0;
	textBackgrnd.alpha = ALPHA1;
	[UIView commitAnimations];
	
	lableTouchFlag = NO;
	photoTouchFlag = YES;
	[self.imgView sendSubviewToBack:photoImgView];
	[self.imgView bringSubviewToFront:msgLabel];
}



-(void)callSaveAndShare
{
	CALayer * l = [photoImgView layer];
	[l setMasksToBounds:YES];
	[l setCornerRadius:10];
	[l setBorderWidth:1.0];
	[l setBorderColor:[[UIColor clearColor] CGColor]];
	[photoImgView setBackgroundColor:[ UIColor clearColor]];
	
	lableTouchFlag = NO;
	photoTouchFlag = NO;
	photoImgView.userInteractionEnabled = NO;
	[navBar show:@"Save/Share" left:@"Style" right:@"Menu"];
	[self.view bringSubviewToFront:navBar];
	[navBar.leftButton removeTarget:self action:@selector(callStyle) forControlEvents:UIControlEventTouchUpInside];
	[navBar.rightButton removeTarget:self action:@selector(callSaveAndShare) forControlEvents:UIControlEventTouchUpInside];
	
	[navBar.leftButton addTarget:self action:@selector(callStyle) forControlEvents:UIControlEventTouchUpInside];
	[navBar.rightButton addTarget:self action:@selector(callMenu) forControlEvents:UIControlEventTouchUpInside];
	
	fontTabButton.alpha = ALPHA0;
	colorTabButton.alpha = ALPHA0;
	sizeTabButton.alpha = ALPHA0;
	textBackgrnd.alpha = ALPHA0;
	fontScrollView.frame = CGRectMake(-320, 385, 320, 44);
	colorScrollView.frame = CGRectMake(-320, 385, 320, 44);
	sizeScrollView.frame = CGRectMake(-320, 385, 320, 44);
	msgLabel.alpha=1;
	[self saveMyFlyer];
}


-(void)saveMyFlyer
{
	alert = [[UIActionSheet alloc] 
			 initWithTitle: @"Save The Flyr " 
			 delegate:self
			 cancelButtonTitle:@"Cancel"
			 destructiveButtonTitle:nil
			 otherButtonTitles:@"Save",@"Save & Distribute",nil];
	
	[alert showInView:self.view];
	[alert release];
}


-(void)loadDistributeView
{
	
	SaveFlyerController *svController = [[SaveFlyerController alloc]initWithNibName:@"SaveFlyerController" bundle:nil];
	svController.flyrImg = finalFlyer;
	svController.ptController = self;
	[self.navigationController pushViewController:svController animated:YES];
	//[self.navigationController initWithRootViewController: svController];
	//[self.navigationController presentModalViewController:svController animated:YES];
	[svController release];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];

	photoTabButton.alpha = ALPHA0;
	widthTabButton.alpha = ALPHA0;
	heightTabButton.alpha = ALPHA0;
	widthScrollView.frame = CGRectMake(-320, 385, 320, 44);
	heightScrollView.frame = CGRectMake(-320, 385, 320, 44);
	widthScrollView.alpha = ALPHA0;
	heightScrollView.alpha = ALPHA0;
	textBackgrnd.alpha = ALPHA0;
	
	if(buttonIndex == 0)
	{
		[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getCurrentFrameAndSaveIt) userInfo:nil repeats:NO];

		[self showHUD];
		appDele.changesFlag = NO;
	}
	else if(buttonIndex == 1)
	{
		//[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getCurrentFrameAndSaveIt) userInfo:nil repeats:NO];
		NSData *data = [self getCurrentFrameAndSaveIt];
		
		finalFlyer = [UIImage imageWithData:data];
		//[self loadDistributeView];
		SaveFlyerController *svController = [[SaveFlyerController alloc]initWithNibName:@"SaveFlyerController" bundle:nil];
		svController.flyrImg = finalFlyer;
		svController.flyrImgData = data;
		svController.ptController = self;
		[self.navigationController pushViewController:svController animated:YES];
		[svController release];
		appDele.changesFlag = NO;
	}
	else if(buttonIndex == 2)
	{
		[self choosePhoto];
	}
}

#pragma mark  TEXTVIEW delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{

}

- (void)textViewDidEndEditing:(UITextView *)textView
{

}

-(void) setStyleTabAction:(id) sender
{
	UIButton *selectedButton = (UIButton*)sender;
	if(selectedButton == fontTabButton)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4f];
		[fontScrollView setAlpha:ALPHA1];
		[colorScrollView setAlpha:ALPHA0];
		[sizeScrollView setAlpha:ALPHA0];
		[fontTabButton setBackgroundImage:[UIImage imageNamed:@"selTab.png"] forState:UIControlStateNormal];
		[colorTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
		[sizeTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
		[UIView commitAnimations];
	}
	else if(selectedButton == colorTabButton)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4f];
		[fontScrollView setAlpha:ALPHA0];
		[colorScrollView setAlpha:ALPHA1];
		[sizeScrollView setAlpha:ALPHA0];
		[fontTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
		[colorTabButton setBackgroundImage:[UIImage imageNamed:@"selTab.png"] forState:UIControlStateNormal];
		[sizeTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
		[UIView commitAnimations];
	}
	else if(selectedButton == sizeTabButton)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4f];
		[fontScrollView setAlpha:ALPHA0];
		[colorScrollView setAlpha:ALPHA0];
		[sizeScrollView setAlpha:ALPHA1];
		[fontTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
		[colorTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
		[sizeTabButton setBackgroundImage:[UIImage imageNamed:@"selTab.png"] forState:UIControlStateNormal];
		[UIView commitAnimations];
	}
}


-(void) setPhotoTabAction:(id) sender{
	UIButton *selectedButton = (UIButton*)sender;
	if(selectedButton == photoTabButton)
	{
		imgPickerFlag =2;
		[self loadPhotoLibrary];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4f];
		textBackgrnd.alpha = ALPHA0;
		widthScrollView.frame = CGRectMake(-320, 385, 320, 44);
		heightScrollView.frame = CGRectMake(-320, 385, 320, 44);
		[photoTabButton setBackgroundImage:[UIImage imageNamed:@"selTab.png"] forState:UIControlStateNormal];
		[widthTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
		[heightTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
		[UIView commitAnimations];
	}
	else if(selectedButton ==widthTabButton)
	{
		[widthScrollView setAlpha:ALPHA1];
		[heightScrollView setAlpha:ALPHA0];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4f];
		textBackgrnd.alpha = ALPHA1;
		widthScrollView.frame = CGRectMake(0, 385, 320, 44);
		heightScrollView.frame = CGRectMake(-320, 385, 320, 44);
		[photoTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
		[widthTabButton setBackgroundImage:[UIImage imageNamed:@"selTab.png"] forState:UIControlStateNormal];
		[heightTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
		[UIView commitAnimations];
	}
	else if(selectedButton == heightTabButton)
	{
		[widthScrollView setAlpha:ALPHA0];
		[heightScrollView setAlpha:ALPHA1];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4f];
		textBackgrnd.alpha = ALPHA1;
		widthScrollView.frame = CGRectMake(-320, 385, 320, 44);
		heightScrollView.frame = CGRectMake(0, 385, 320, 44);
		[photoTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
		[widthTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
		[heightTabButton setBackgroundImage:[UIImage imageNamed:@"selTab.png"] forState:UIControlStateNormal];
		[UIView commitAnimations];
		
	}
}

/************************************************************************************************/
#pragma mark  ALL TOUCH FUNCTIONS

- (void)animateFirstTouchAtPoint:(CGPoint)touchPoint forView:(UIView *)theView 
{
	NSValue *touchPointValue = [NSValue valueWithCGPoint:touchPoint] ;
	[UIView beginAnimations:nil context:touchPointValue];
	[UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS];
	CGAffineTransform transform = CGAffineTransformMakeScale(1.07,1.07);
	theView.transform = transform;
	[UIView commitAnimations];
}

- (void)animateView:(UIView *)theView toPosition:(CGPoint) thePosition
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:SHRINK_ANIMATION_DURATION_SECONDS];
	theView.center = thePosition;
	theView.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];	
}

-(void) dispatchFirstTouchAtPoint:(UIView *)theView point:(CGPoint)touchPoint forEvent:(UIEvent *)event
{
	if (CGRectContainsPoint([theView frame], touchPoint)) {
		[self animateFirstTouchAtPoint:touchPoint forView:theView];
	}
}

-(void) dispatchTouchEvent:(UIView *)theView toPosition:(CGPoint)position
{
	if(lableTouchFlag){
		lableLocation = position;
	}
	if (CGRectContainsPoint([theView frame], position)) {
		theView.center = position;
	} 
}	

-(void) dispatchTouchEndEvent:(UIView *)theView toPosition:(CGPoint)position
{   
	if (CGRectContainsPoint([photoImgView frame], position)&& photoTouchFlag) {
		[self animateView:photoImgView toPosition: position];
	} 
	else if(CGRectContainsPoint([msgLabel frame], position)&& lableTouchFlag){
		[self animateView:msgLabel toPosition: position];
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
	[super touchesBegan:touches withEvent:event];
	UITouch *touch = [touches anyObject];
	NSInteger numTaps = [touch tapCount];

	if(numTaps == 1)
	{
		if (CGRectContainsPoint([msgLabel frame], [touch locationInView:self.view]) && lableTouchFlag )
		{
			[self.imgView sendSubviewToBack:photoImgView];
			[self.imgView bringSubviewToFront:msgLabel];

			for (UITouch *touch in touches) {
				[self dispatchFirstTouchAtPoint:msgLabel point:[touch locationInView:self.view] forEvent:nil];
			}
		}	
		else if (CGRectContainsPoint([photoImgView frame], [touch locationInView:self.view]) && photoTouchFlag)
		{
			[self.imgView sendSubviewToBack:photoImgView];
			[self.imgView bringSubviewToFront:msgLabel];
			for (UITouch *touch in touches) {
				[self dispatchFirstTouchAtPoint:photoImgView point:[touch locationInView:self.view] forEvent:nil];
			}
		}	
	}
	else if(numTaps == 2)
	{
		NSLog(@"nothing");
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{  
	UITouch *touch = [touches anyObject];

		
	if (CGRectContainsPoint([msgLabel frame], [touch locationInView:self.view]) && lableTouchFlag)
	{
		
		for (UITouch *touch in touches){
			lableLocation = [touch locationInView:self.imgView];
			[self dispatchTouchEvent:msgLabel toPosition:[touch locationInView:self.view]];
		}
		
	}
	else if (CGRectContainsPoint([photoImgView frame], [touch locationInView:self.view]) && photoTouchFlag)
	{
		for (UITouch *touch in touches){
			[self dispatchTouchEvent:photoImgView toPosition:[touch locationInView:self.view]];
		}
	}
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	[self dispatchTouchEndEvent:msgLabel toPosition:[touch locationInView:self.view]];
	[self dispatchTouchEndEvent:photoImgView toPosition:[touch locationInView:self.view]];
	if (!CGRectContainsPoint([msgLabel frame], [touch locationInView:self.view])&& lableTouchFlag)
	{
		[self.view bringSubviewToFront:msgLabel];
		for (UITouch *touch in touches) {
			[self dispatchFirstTouchAtPoint:msgLabel point:[touch locationInView:self.view] forEvent:nil];
		}
	}
	else if (!CGRectContainsPoint([photoImgView frame], [touch locationInView:self.view]) && photoTouchFlag)
	{
		for (UITouch *touch in touches){
			[self dispatchFirstTouchAtPoint:photoImgView point:[touch locationInView:self.view] forEvent:nil];
		}
	}
}
/************************************************************************************************/

#pragma mark Save Flyer image and write to Documents/Flyr folder 

-(NSData*)getCurrentFrameAndSaveIt
{
	
	CGSize size = CGSizeMake(self.imgView.bounds.size.width,self.imgView.bounds.size.height );
	UIGraphicsBeginImageContext(size);
	[self.imgView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	NSString *homeDirectoryPath = NSHomeDirectory();
	NSString *MyFlyerPath = [homeDirectoryPath stringByAppendingString:@"/Documents/Flyr/"];
	NSString *folderPath = [NSString pathWithComponents:[NSArray arrayWithObjects:[NSString stringWithString:[MyFlyerPath stringByStandardizingPath]],nil]];
	NSString *finalImgWritePath;
	NSInteger imgCount;
	NSInteger largestImgCount=-1;
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
	
	/************************ CREATE UNIQUE NAME FOR IMAGE ***********************************/
	if(files == nil)
	{
		finalImgWritePath = [folderPath stringByAppendingString:@"/IMG_0.jpg"];
		
	}
	else
	{
		NSAutoreleasePool* ap = [[NSAutoreleasePool alloc] init];
		for(int i = 0 ; i < [files count];i++)
		{
			NSString *lastFileName = [files objectAtIndex:i];
			NSLog(lastFileName);
			lastFileName = [lastFileName stringByReplacingOccurrencesOfString:@".jpg" withString:@""];
			lastFileName = [lastFileName stringByReplacingOccurrencesOfString:@"IMG_" withString:@""];
			imgCount = [lastFileName intValue];
			if(imgCount > largestImgCount){
				largestImgCount = imgCount;
			}
			
		}
		[ap release];
		NSString *newImgName = [NSString stringWithFormat:@"/IMG_%d.jpg",++largestImgCount];
		finalImgWritePath = [folderPath stringByAppendingString:newImgName];
	}
	/************************ END OF CREATE UNIQUE NAME FOR IMAGE ***********************************/

	NSString *imgPath = [NSString pathWithComponents:[NSArray arrayWithObjects:[NSString stringWithString:[finalImgWritePath stringByExpandingTildeInPath]], nil]];
	if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:NULL]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:folderPath attributes:nil];
	}

	[aHUD.loadingLabel setText:@"Saved"];
	[NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(killHUD) userInfo:nil repeats:NO];

	
	NSData *imgData = UIImagePNGRepresentation(screenImage);
	//[imgData writeToFile:imgPath atomically:YES];
	//(BOOL)createFileAtPath:(NSString *)path contents:(NSData *)data attributes:(NSDictionary *)attr
	[[NSFileManager defaultManager] createFileAtPath:imgPath contents:imgData attributes:nil];
	//UIImage *tempImage = [[UIImage alloc]initWithData:imgData];
	return imgData;
}

#pragma mark  View Disappear Methods
- (void)postDismissCleanup {
		[imgPicker release];
	
}

- (void)dismissNavBar:(BOOL)animated {
	
	
	if (animated) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(postDismissCleanup)];
		navBar.alpha = ALPHA0;
		[UIView commitAnimations];
	} else {
		[self postDismissCleanup];
	}
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self dismissNavBar:YES];
}



- (void)didReceiveMemoryWarning {
	NSLog(@"didReceiveMemoryWarning");
	FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
	[appDele clearCache];
		[super didReceiveMemoryWarning];
}
- (void)viewDidUnload {
	NSLog(@"ViewDidUnload");
	FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
	[appDele clearCache];
}

- (void)dealloc 
{
	NSLog(@"Dealloc");
	[aHUD release];
	[templateScrollView release];
	//FlyrAppDelegate *appDele = [[UIApplication sharedApplication]delegate];
	[templateArray release];
	//[navBar removeFromSuperview];
	[navBar release];
	[msgTextView release];
	[msgLabel release];
	[colorScrollView release];
	[sizeScrollView release];
	[fontScrollView release];
	
    [super dealloc];
}

@end
