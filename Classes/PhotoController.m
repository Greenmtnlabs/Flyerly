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
#import "SaveFlyerController.h"
#import "ImageCache.h"
#import "CameraOverlayView.h"
#import "CustomPhotoController.h"
#import "DraftViewController.h"
#import "HelpController.h"

@implementation PhotoController
@synthesize imgView,imgPicker;
@synthesize fontScrollView,colorScrollView,templateScrollView,sizeScrollView,borderScrollView,fontBorderScrollView;
@synthesize msgTextView,finalFlyer;
@synthesize selectedFont,selectedColor,navBar;
@synthesize selectedTemplate;
@synthesize fontTabButton,colorTabButton,sizeTabButton,selectedText,selectedSize,borderTabButton,fontBorderTabButton;
@synthesize templateBckgrnd,textBackgrnd,aHUD;
//@synthesize widthScrollView,heightScrollView
@synthesize cameraTabButton,photoTabButton,widthTabButton,heightTabButton,photoImgView;
@synthesize photoTouchFlag,lableTouchFlag,lableLocation,warningAlert;
@synthesize moreLayersLabel, moreLayersButton, takePhotoButton, cameraRollButton, takePhotoLabel, cameraRollLabel, imgPickerFlag,finalImgWritePath,newImgName;



#pragma mark  View Appear Methods
-(void)viewWillAppear:(BOOL)animated{
	
	[super viewWillAppear:YES];	
	self.navigationController.navigationBarHidden = NO;
	imgPicker = [[UIImagePickerController alloc] init];
	imgPicker.allowsImageEditing = NO;
	photoTouchFlag=NO;
	lableTouchFlag=NO;
	imgPicker.delegate =self;
	imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	navBar.alpha =ALPHA1;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg"] forBarMetrics:UIBarMetricsDefault];
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
    
    // Create right bar button
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 31, 30)];
    [menuButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu_button"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    [self.navigationItem setRightBarButtonItem:rightBarButton];

	//Default Selection for start
	selectedFont = [UIFont fontWithName:@"Arial" size:16];
	selectedColor = [UIColor blackColor];	
	selectedText = @"";
	selectedSize = 16;
	selectedTemplate  = [UIImage imageNamed:@"main_area_bg"];
	lableLocation = CGPointMake(160,100);
	
	
	// Create Main Image View
    if(IS_IPHONE_5){
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 48, 310, 309)];
        templateBckgrnd = [[UIImageView alloc]initWithFrame:CGRectMake(0, 413, 320, 135)];
        cameraRollButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 365, 135, 40)];
        moreLayersButton = [[UIButton alloc] initWithFrame:CGRectMake(82, 445, 156, 43)];
        moreLayersLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 445, 156, 43)];
        takePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 365, 135, 40)];
        takePhotoLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 370, 80, 30)];
        cameraRollLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 370, 80, 30)];
        templateScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 413,320,130)];
    }else{
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 44, 310, 309)];
        templateBckgrnd = [[UIImageView alloc]initWithFrame:CGRectMake(0, 395, 320, 65)];
        cameraRollButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 354, 135, 40)];
        moreLayersButton = [[UIButton alloc] initWithFrame:CGRectMake(82, 354, 156, 43)];
        moreLayersLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 354, 156, 43)];
        takePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 354, 135, 40)];
        takePhotoLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 359, 80, 30)];
        cameraRollLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 359, 80, 30)];
        templateScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 395,320,60)];
    }
	imgView.image = selectedTemplate;
	[self.view addSubview:imgView];

    [moreLayersButton setBackgroundImage:[UIImage imageNamed:@"07_addmore"] forState:UIControlStateNormal];
    //[moreLayersButton addTarget:self action:@selector(openCustomCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreLayersButton];

    [takePhotoButton setBackgroundImage:[UIImage imageNamed:@"take_photo"] forState:UIControlStateNormal];
    [takePhotoButton addTarget:self action:@selector(openCustomCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takePhotoButton];
    [cameraRollButton setBackgroundImage:[UIImage imageNamed:@"camera_roll"] forState:UIControlStateNormal];
    [cameraRollButton addTarget:self action:@selector(loadCustomPhotoLibrary) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraRollButton];

    [moreLayersLabel setText:@"Add more layers"];
    [moreLayersLabel setBackgroundColor:[UIColor clearColor]];
    [moreLayersLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:13]];
    [moreLayersLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:moreLayersLabel];

    [takePhotoLabel setText:@"Take a Photo"];
    [takePhotoLabel setBackgroundColor:[UIColor clearColor]];
    [takePhotoLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:13]];
    [takePhotoLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:takePhotoLabel];
    [cameraRollLabel setText:@"Camera Roll"];
    [cameraRollLabel setBackgroundColor:[UIColor clearColor]];
    [cameraRollLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:13]];
    [cameraRollLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:cameraRollLabel];
    

	photoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 50, 220, 200)];
	[photoImgView setUserInteractionEnabled:NO];

	//templateBckgrnd.image = [UIImage imageNamed:@"scroll1.png"];
    templateBckgrnd.image = [UIImage imageNamed:@"ad_bg_bg"];
    [self.view addSubview:templateBckgrnd];
	templateBckgrnd.alpha = ALPHA0;
	
	textBackgrnd = [[UIImageView alloc]initWithFrame:CGRectMake(0, 385, 320, 44)];
	//textBackgrnd.image = [UIImage imageNamed:@"scroll2.png"];
	[self.view addSubview:textBackgrnd];
	textBackgrnd.alpha = ALPHA0;

	msgLabel = [[CustomLabel alloc]initWithFrame:CGRectMake(0, 30, 320, 500)];
	msgLabel.backgroundColor = [UIColor clearColor];
	msgLabel.textColor = [UIColor blackColor];
	msgLabel.textAlignment = UITextAlignmentCenter;
	[self.imgView addSubview:msgLabel];
	
	msgTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 50, 280, 150)];
	msgTextView.delegate = self;
	msgTextView.font = [UIFont fontWithName:@"Arial" size:16];
	msgTextView.textColor = [UIColor blackColor];
	msgTextView.textAlignment = UITextAlignmentCenter;
	
	fontScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385,320,44)];
	colorScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385,320,44)];
	sizeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385, 320, 44)];
	borderScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385, 320, 44)];
	fontBorderScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385, 320, 44)];
	//widthScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385,320,44)];
	//heightScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385, 320, 44)];
	
		
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
        [templateButton setBackgroundColor:[UIColor whiteColor]];
		//[templateButton setBackgroundImage:[UIImage imageNamed:@"white_bg_thumbnail"] forState:UIControlStateNormal];
		//[templateButton setBackgroundImage:[UIImage imageNamed:@"button1.png"] forState:UIControlStateNormal];
		
		//UIImageView *img = [[[UIImageView alloc]initWithFrame:CGRectMake(templateButton.frame.origin.x+5, templateButton.frame.origin.y+2, templateButton.frame.size.width-10, templateButton.frame.size.height-14)]autorelease];
		//[img setImage:iconImg];
		UIImageView *img = [[UIImageView alloc]initWithImage:iconImg];
		//[img initWithImage:iconImg];
		img.frame  = CGRectMake(templateButton.frame.origin.x+5, templateButton.frame.origin.y-2, templateButton.frame.size.width-10, templateButton.frame.size.height-7);
		[templateButton addSubview:img];
		//templateButton.alpha = ALPHA1;
		templateButton.tag = i;	
		[templateScrollView addSubview:templateButton];
		//[templateButton release];
	}
	[pool1 release];

    //NSLog(@"Famiy Names: %@", [UIFont familyNames]);
    
	fontArray =[[NSArray  alloc] initWithObjects:
				[UIFont fontWithName:@"Arial" size:27],
				[UIFont fontWithName:@"GoodDog" size:27],
				[UIFont fontWithName:@"GrandHotel-Regular" size:27],
				[UIFont fontWithName:@"Kankin" size:27],
				[UIFont fontWithName:@"Molot" size:27],
				[UIFont fontWithName:@"Nexa Bold" size:27],
				[UIFont fontWithName:@"Quicksand" size:27],
				[UIFont fontWithName:@"StMarie-Thin" size:27],
				[UIFont fontWithName:@"BlackJack" size:27],
				[UIFont fontWithName:@"Comfortaa-Bold" size:27],
				[UIFont fontWithName:@"Swis721 BlkEx BT" size:27], // Missing
				[UIFont fontWithName:@"Algerian" size:27],
				[UIFont fontWithName:@"HelveticaInseratCyr Upright" size:27],
				[UIFont fontWithName:@"Helvetica Rounded LT Std" size:27],
				[UIFont fontWithName:@"Lucida Handwriting" size:27],
				[UIFont fontWithName:@"Anjelika Rose" size:27],
				[UIFont fontWithName:@"BankGothic DB" size:27],
				[UIFont fontWithName:@"Segoe UI" size:27],
				[UIFont fontWithName:@"AvantGarde CE" size:27],
				[UIFont fontWithName:@"BlueNoon" size:27],
				[UIFont fontWithName:@"Daniel Black" size:27],
                nil];
    
				/*
                [UIFont fontWithName:@"Signika-Regular" size:27],
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
				nil];*/
	
	
	NSInteger fontScrollWidth = 44;
	NSInteger fontScrollHeight = 35;
	NSInteger colorScrollWidth = 44;
	NSInteger colorScrollHeight = 35;
	NSInteger sizeScrollWidth = 44;
	NSInteger sizeScrollHeight = 35;
    NSInteger borderScrollWidth = 44;
	NSInteger borderScrollHeight = 35;
    NSInteger fontBorderScrollWidth = 44;
	NSInteger fontBorderScrollHeight = 35;

    if(IS_IPHONE_5){
        fontScrollWidth = 35;
        fontScrollHeight = 35;
        colorScrollWidth = 35;
        colorScrollHeight = 35;
        sizeScrollWidth = 35;
        sizeScrollHeight = 35;
        borderScrollWidth = 35;
        borderScrollHeight = 35;
        fontBorderScrollWidth = 35;
        fontBorderScrollHeight = 35;
    }

	for (int i = 1; i <=[fontArray count] ; i++)
	{
		UIButton *font = [UIButton buttonWithType:UIButtonTypeCustom];
		font.frame = CGRectMake(0, 0, fontScrollWidth, fontScrollHeight);

		
		[font setTitle:@"A" forState:UIControlStateNormal];
		UIFont *fontname =[fontArray objectAtIndex:(i-1)];
		[font.titleLabel setFont: fontname];
		[font setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		font.tag = i;	
		//font.alpha = ALPHA1;
		[font setBackgroundImage:[UIImage imageNamed:@"a_bg"] forState:UIControlStateNormal];
        
        if(i>5){
            UIImageView *lock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lock"]];
            lock.frame = CGRectMake(20, 20, 17, 19);
            [font addSubview:lock];
            font.userInteractionEnabled = NO;
        }

		[fontScrollView addSubview:font];
		//[font release];
	}
	
	colorArray = 	[[NSArray  alloc] initWithObjects: [UIColor redColor], [UIColor blueColor], [UIColor greenColor], [UIColor blackColor], [UIColor colorWithRed:253.0/255.0 green:191.0/255.0 blue:38.0/224.0 alpha:1], [UIColor whiteColor], [UIColor grayColor], [UIColor magentaColor], [UIColor yellowColor], [UIColor colorWithRed:163.0/255.0 green:25.0/255.0 blue:2.0/224.0 alpha:1], [UIColor colorWithRed:3.0/255.0 green:15.0/255.0 blue:41.0/224.0 alpha:1], [UIColor purpleColor], [UIColor colorWithRed:85.0/255.0 green:86.0/255.0 blue:12.0/224.0 alpha:1], [UIColor orangeColor], [UIColor colorWithRed:98.0/255.0 green:74.0/255.0 blue:9.0/224.0 alpha:1], [UIColor colorWithRed:80.0/255.0 green:7.0/255.0 blue:1.0/224.0 alpha:1], [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:97.0/224.0 alpha:1], [UIColor colorWithRed:111.0/255.0 green:168.0/255.0 blue:100.0/224.0 alpha:1], [UIColor cyanColor], [UIColor colorWithRed:17.0/255.0 green:69.0/255.0 blue:70.0/224.0 alpha:1], [UIColor colorWithRed:173.0/255.0 green:127.0/255.0 blue:251.0/224.0 alpha:1], nil];
	
	for (int i = 1; i <=  [colorArray count] ; i++)
	{
		UIButton *color = [UIButton buttonWithType:UIButtonTypeCustom];
		color.frame = CGRectMake(0, 5, colorScrollWidth, colorScrollHeight);
		//[color setBackgroundImage:[UIImage imageNamed:@"button1.png"] forState:UIControlStateNormal];
        color.layer.borderColor = [UIColor grayColor].CGColor;
        color.layer.borderWidth = 1.0;

		id colorName =[colorArray objectAtIndex:(i-1)];
		UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(color.frame.origin.x+5, color.frame.origin.y-1, color.frame.size.width-10, color.frame.size.height-8)];
		[label setBackgroundColor:colorName];
		[color addSubview:label];
		color.tag = i+30;	
		//color.alpha = ALPHA1;
        
        if(i>5){
            UIImageView *lock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lock"]];
            lock.frame = CGRectMake(20, 20, 17, 19);
            [color addSubview:lock];
            color.userInteractionEnabled = NO;
        }
        
		[colorScrollView addSubview:color];
		//[color release];
	}
	
	for (int i = 1; i <=  [SIZE_ARRAY count] ; i++)
	{
		UIButton *size = [UIButton buttonWithType:UIButtonTypeCustom];
		size.frame = CGRectMake(0, 5, sizeScrollWidth, sizeScrollHeight);
		NSString *sizeValue =[SIZE_ARRAY objectAtIndex:(i-1)];
		[size setBackgroundImage:[UIImage imageNamed:@"a_bg"] forState:UIControlStateNormal];
		[size setTitle:sizeValue forState:UIControlStateNormal];
		[size.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
		[size setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		size.tag = i+60;
		size.alpha = ALPHA1;
        
        if(i>5){
            UIImageView *lock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lock"]];
            lock.frame = CGRectMake(20, 20, 17, 19);
            [size addSubview:lock];
            size.userInteractionEnabled = NO;
        }

		[sizeScrollView addSubview:size];
		//[size release];
	}
	
    borderArray = 	[[NSArray  alloc] initWithObjects: [UIColor blackColor], [UIColor grayColor], [UIColor darkGrayColor], [UIColor blueColor], [UIColor purpleColor], [UIColor colorWithRed:115.0/255.0 green:134.0/255.0 blue:144.0/255.0 alpha:1], [UIColor orangeColor], [UIColor greenColor], [UIColor redColor], [UIColor colorWithRed:14.0/255.0 green:95.0/255.0 blue:111.0/255.0 alpha:1], [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:149.0/255.0 alpha:1], [UIColor colorWithRed:228.0/255.0 green:128.0/255.0 blue:144.0/255.0 alpha:1], [UIColor colorWithRed:213.0/255.0 green:110.0/255.0 blue:86.0/255.0 alpha:1],[UIColor colorWithRed:156.0/255.0 green:195.0/255.0 blue:233.0/255.0 alpha:1],[UIColor colorWithRed:27.0/255.0 green:70.0/255.0 blue:148.0/255.0 alpha:1],[UIColor colorWithRed:234.0/255.0 green:230.0/255.0 blue:51.0/255.0 alpha:1],[UIColor cyanColor], [UIColor colorWithRed:232.0/255.0 green:236.0/255.0 blue:51.0/224.0 alpha:1],[UIColor magentaColor],[UIColor colorWithRed:57.0/255.0 green:87.0/255.0 blue:13.0/224.0 alpha:1], [UIColor colorWithRed:93.0/255.0 green:97.0/255.0 blue:196.0/224.0 alpha:1],nil];	

	for (int i = 1; i <=  [borderArray count] ; i++)
	{
		UIButton *color = [UIButton buttonWithType:UIButtonTypeCustom];
		color.frame = CGRectMake(0, 5, borderScrollWidth, borderScrollHeight);
		//[color setBackgroundImage:[UIImage imageNamed:@"button1.png"] forState:UIControlStateNormal];
		UIColor *colorName =[borderArray objectAtIndex:(i-1)];
		UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(color.frame.origin.x, color.frame.origin.y-3, color.frame.size.width, color.frame.size.height)];
        label.layer.borderColor = colorName.CGColor;
        label.layer.borderWidth = 3.0;
		[color addSubview:label];
		color.tag = i+90;
		color.alpha = ALPHA1;
        
        if(i>5){
            UIImageView *lock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lock"]];
            lock.frame = CGRectMake(20, 20, 17, 19);
            [color addSubview:lock];
            color.userInteractionEnabled = NO;
        }

		[borderScrollView addSubview:color];
		//[color release];
	}

	for (int i = 1; i <=  [borderArray count] ; i++)
	{
		UIButton *color = [UIButton buttonWithType:UIButtonTypeCustom];
		color.frame = CGRectMake(0, 5, borderScrollWidth, borderScrollHeight);
		//[color setBackgroundImage:[UIImage imageNamed:@"button1.png"] forState:UIControlStateNormal];
		UIColor *colorName =[borderArray objectAtIndex:(i-1)];
		UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(color.frame.origin.x, color.frame.origin.y-3, color.frame.size.width, color.frame.size.height)];
        label.layer.borderColor = colorName.CGColor;
        label.layer.borderWidth = 3.0;
		[color addSubview:label];
		color.tag = i+90;
		color.alpha = ALPHA1;
        
        if(i>5){
            UIImageView *lock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lock"]];
            lock.frame = CGRectMake(20, 20, 17, 19);
            [color addSubview:lock];
            color.userInteractionEnabled = NO;
        }
        
		[fontBorderScrollView addSubview:color];
		//[color release];
	}
    
	/*NSInteger widthScrollWidth = 44;
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
	}*/
	
	
	/*NSInteger heightScrollWidth = 44;
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
	}*/
	
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
	
	[borderScrollView setCanCancelContentTouches:NO];
	borderScrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
	borderScrollView.clipsToBounds = YES;
	borderScrollView.scrollEnabled = YES;
	borderScrollView.pagingEnabled = NO;
	borderScrollView.showsHorizontalScrollIndicator = NO;
	borderScrollView.showsVerticalScrollIndicator = NO;
	borderScrollView.alpha = ALPHA0;
	[self.view addSubview:borderScrollView];
	[self layoutScrollImages:borderScrollView scrollWidth:borderScrollWidth scrollHeight:borderScrollHeight];

	[fontBorderScrollView setCanCancelContentTouches:NO];
	fontBorderScrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
	fontBorderScrollView.clipsToBounds = YES;
	fontBorderScrollView.scrollEnabled = YES;
	fontBorderScrollView.pagingEnabled = NO;
	fontBorderScrollView.showsHorizontalScrollIndicator = NO;
	fontBorderScrollView.showsVerticalScrollIndicator = NO;
	fontBorderScrollView.alpha = ALPHA0;
	[self.view addSubview:fontBorderScrollView];
	[self layoutScrollImages:fontBorderScrollView scrollWidth:fontBorderScrollWidth scrollHeight:fontBorderScrollHeight];
    
	/*[widthScrollView setCanCancelContentTouches:NO];
	widthScrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
	widthScrollView.clipsToBounds = YES;	
	widthScrollView.scrollEnabled = YES;
	widthScrollView.pagingEnabled = NO;
	widthScrollView.showsHorizontalScrollIndicator = NO;
	widthScrollView.showsVerticalScrollIndicator = NO;
	widthScrollView.alpha = ALPHA0;
	[self.view addSubview:widthScrollView];
	[self layoutScrollImages:widthScrollView scrollWidth:widthScrollWidth scrollHeight:widthScrollHeight];*/
	
	/*[heightScrollView setCanCancelContentTouches:NO];
	heightScrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
	heightScrollView.clipsToBounds = YES;	
	heightScrollView.scrollEnabled = YES;
	heightScrollView.pagingEnabled = NO;
	heightScrollView.showsHorizontalScrollIndicator = NO;
	heightScrollView.showsVerticalScrollIndicator = NO;
	heightScrollView.alpha = ALPHA0;
	[self.view addSubview:heightScrollView];
	[self layoutScrollImages:heightScrollView scrollWidth:heightScrollWidth scrollHeight:heightScrollHeight];*/
	 
    fontTabButton =[UIButton buttonWithType:UIButtonTypeCustom];
    colorTabButton =[UIButton buttonWithType:UIButtonTypeCustom];
    sizeTabButton =[UIButton buttonWithType:UIButtonTypeCustom];
    fontBorderTabButton =[UIButton buttonWithType:UIButtonTypeCustom];
    borderTabButton =[UIButton buttonWithType:UIButtonTypeCustom];
	photoTabButton =[UIButton buttonWithType:UIButtonTypeCustom];
	cameraTabButton =[UIButton buttonWithType:UIButtonTypeCustom];
	widthTabButton =[UIButton buttonWithType:UIButtonTypeCustom];
	heightTabButton =[UIButton buttonWithType:UIButtonTypeCustom];

	if(IS_IPHONE_5){
        fontTabButton.frame = CGRectMake(-1, 502, 65, 46);
        colorTabButton.frame = CGRectMake(64, 502, 65, 46);
        sizeTabButton.frame = CGRectMake(129, 502, 65, 46);
        borderTabButton.frame = CGRectMake(194, 502, 65, 46);
        fontBorderTabButton.frame = CGRectMake(259, 502, 65, 46);
        cameraTabButton.frame = CGRectMake(-1, 502, 80, 46);
        photoTabButton.frame = CGRectMake(79, 502, 80, 46);
        widthTabButton.frame = CGRectMake(159, 502, 80, 46);
        heightTabButton.frame = CGRectMake(239, 502, 80, 46);
    }else{
        fontTabButton.frame = CGRectMake(-1, 415, 65, 46);
        colorTabButton.frame = CGRectMake(64, 415, 65, 46);
        sizeTabButton.frame = CGRectMake(129, 415, 65, 46);
        borderTabButton.frame = CGRectMake(194, 415, 65, 46);
        fontBorderTabButton.frame = CGRectMake(259, 415, 65, 46);
        cameraTabButton.frame = CGRectMake(-1, 415, 80, 46);
        photoTabButton.frame = CGRectMake(79, 415, 80, 46);
        widthTabButton.frame = CGRectMake(159, 415, 80, 46);
        heightTabButton.frame = CGRectMake(239, 415, 81, 46);
    }
    
	//fontTabButton.frame = CGRectMake(-1, 429, 107, 32);
	//[fontTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
	//[fontTabButton setTitle:@"Font" forState:UIControlStateNormal];
	[fontTabButton setBackgroundImage:[UIImage imageNamed:@"font_button"] forState:UIControlStateNormal];
	[fontTabButton.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
	[fontTabButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[fontTabButton addTarget:self action:@selector(setStyleTabAction:) forControlEvents:UIControlEventTouchUpInside];
	fontTabButton.alpha =  ALPHA0;
	fontTabButton.tag = 10001;
	[self.view addSubview:fontTabButton];
	
	[colorTabButton setBackgroundImage:[UIImage imageNamed:@"color_button"] forState:UIControlStateNormal];
	//colorTabButton.frame = CGRectMake(106, 429, 109, 32);
	//[colorTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
	//[colorTabButton setTitle:@"Color" forState:UIControlStateNormal];
	[colorTabButton.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
	[colorTabButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[colorTabButton addTarget:self action:@selector(setStyleTabAction:) forControlEvents:UIControlEventTouchUpInside];
	colorTabButton.alpha =  ALPHA0;
	colorTabButton.tag = 10002;
	[self.view addSubview:colorTabButton];
	
	//sizeTabButton.frame = CGRectMake(107+107, 429, 107, 32);
	//[sizeTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
	[sizeTabButton setBackgroundImage:[UIImage imageNamed:@"size_button"] forState:UIControlStateNormal];
	//[sizeTabButton setTitle:@"Size" forState:UIControlStateNormal];
	[sizeTabButton.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
	[sizeTabButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[sizeTabButton addTarget:self action:@selector(setStyleTabAction:) forControlEvents:UIControlEventTouchUpInside];
	sizeTabButton.alpha =  ALPHA0;
	sizeTabButton.tag = 10003;
	[self.view addSubview:sizeTabButton];

	[borderTabButton setBackgroundImage:[UIImage imageNamed:@"outline_button"] forState:UIControlStateNormal];
	[borderTabButton.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
	[borderTabButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[borderTabButton addTarget:self action:@selector(setStyleTabAction:) forControlEvents:UIControlEventTouchUpInside];
	borderTabButton.alpha =  ALPHA0;
	borderTabButton.tag = 10004;
	[self.view addSubview:borderTabButton];
    
	[fontBorderTabButton setBackgroundImage:[UIImage imageNamed:@"background_button"] forState:UIControlStateNormal];
	[fontBorderTabButton.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
	[fontBorderTabButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[fontBorderTabButton addTarget:self action:@selector(setStyleTabAction:) forControlEvents:UIControlEventTouchUpInside];
	fontBorderTabButton.alpha =  ALPHA0;
	fontBorderTabButton.tag = 10005;
	[self.view addSubview:fontBorderTabButton];
    
	[cameraTabButton setBackgroundImage:[UIImage imageNamed:@"07_camera"] forState:UIControlStateNormal];
	//[cameraTabButton setTitle:@"Camera" forState:UIControlStateNormal];
	[cameraTabButton.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
	[cameraTabButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[cameraTabButton addTarget:self action:@selector(setPhotoTabAction:) forControlEvents:UIControlEventTouchUpInside];
	cameraTabButton.alpha =  ALPHA0;
	cameraTabButton.tag = 10001;
	[self.view addSubview:cameraTabButton];
	
	[photoTabButton setBackgroundImage:[UIImage imageNamed:@"07_roll"] forState:UIControlStateNormal];
	//[photoTabButton setTitle:@"Photo" forState:UIControlStateNormal];
	[photoTabButton.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
	[photoTabButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[photoTabButton addTarget:self action:@selector(setPhotoTabAction:) forControlEvents:UIControlEventTouchUpInside];
	photoTabButton.alpha =  ALPHA0;
	photoTabButton.tag = 10002;
	[self.view addSubview:photoTabButton];
	
	[widthTabButton setBackgroundImage:[UIImage imageNamed:@"07_width"] forState:UIControlStateNormal];
	//[widthTabButton setTitle:@"Width" forState:UIControlStateNormal];
	[widthTabButton.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
	[widthTabButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [widthTabButton addTarget:self action:@selector(selectWidth:) forControlEvents:UIControlEventTouchUpInside];
	//[widthTabButton addTarget:self action:@selector(setPhotoTabAction:) forControlEvents:UIControlEventTouchUpInside];
	widthTabButton.alpha =  ALPHA0;
	widthTabButton.tag = 10003;
	[self.view addSubview:widthTabButton];
	
	[heightTabButton setBackgroundImage:[UIImage imageNamed:@"07_height"] forState:UIControlStateNormal];
	//[heightTabButton setTitle:@"Height" forState:UIControlStateNormal];
	[heightTabButton.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
	[heightTabButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [heightTabButton addTarget:self action:@selector(selectHeight:) forControlEvents:UIControlEventTouchUpInside];
    //[heightTabButton addTarget:self action:@selector(setPhotoTabAction:) forControlEvents:UIControlEventTouchUpInside];
	heightTabButton.alpha =  ALPHA0;
	heightTabButton.tag = 10004;
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
			//msgLabel.frame = CGRectMake(0, 10, 320,500 );
		}
		i++;	
	}
}

-(void)selectBorder:(id)sender
{
	FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
	appDele.changesFlag = YES;
	int  i=1;
	UIButton *view = sender;
	for(UIView *tempView  in [borderScrollView subviews])
	{
		if(tempView == view)
		{
			UIColor *borderColor = [borderArray objectAtIndex:i-1];
            
            imgView.layer.borderColor = borderColor.CGColor;
            imgView.layer.borderWidth = 3.0;
		}
		i++;
	}
}

-(void)selectFontBorder:(id)sender
{
	FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
	appDele.changesFlag = YES;
	int  i=1;
	UIButton *view = sender;
	for(UIView *tempView  in [fontBorderScrollView subviews]) {
		if(tempView == view) {
            
			UIColor *borderColor = [borderArray objectAtIndex:i-1];
            
            msgLabel.borderColor = borderColor;
            msgLabel.lineWidth = 2;
            [msgLabel drawRect:CGRectMake(msgLabel.frame.origin.x, msgLabel.frame.origin.y, msgLabel.frame.size.width, msgLabel.frame.size.height)];
		}
		i++;
	}
}

-(void)selectWidth:(id)sender{
    
	/*FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
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
	}*/
    
    [cameraTabButton setBackgroundImage:[UIImage imageNamed:@"07_camera"] forState:UIControlStateNormal];
    [photoTabButton setBackgroundImage:[UIImage imageNamed:@"07_roll"] forState:UIControlStateNormal];
    [widthTabButton setBackgroundImage:[UIImage imageNamed:@"07_width_selected"] forState:UIControlStateNormal];
    [heightTabButton setBackgroundImage:[UIImage imageNamed:@"07_height"] forState:UIControlStateNormal];
    [widthTabButton  setSelected:YES];
    [heightTabButton  setSelected:NO];
    
    photoImgView.frame = CGRectMake(photoImgView.frame.origin.x, photoImgView.frame.origin.y,photoImgView.frame.size.width-10,photoImgView.frame.size.height);
}

-(void)selectHeight:(id)sender{
    
	/*FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
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
	}*/
    
    [cameraTabButton setBackgroundImage:[UIImage imageNamed:@"07_camera"] forState:UIControlStateNormal];
    [photoTabButton setBackgroundImage:[UIImage imageNamed:@"07_roll"] forState:UIControlStateNormal];
    [widthTabButton setBackgroundImage:[UIImage imageNamed:@"07_width"] forState:UIControlStateNormal];
    [heightTabButton setBackgroundImage:[UIImage imageNamed:@"07_height_selected"] forState:UIControlStateNormal];
    [widthTabButton  setSelected:NO];
    [heightTabButton  setSelected:YES];

    photoImgView.frame = CGRectMake(photoImgView.frame.origin.x, photoImgView.frame.origin.y,photoImgView.frame.size.width,photoImgView.frame.size.height-10);
}

- (void)layoutScrollImages:(UIScrollView*)selectedScrollView scrollWidth:(NSInteger)kScrollObjWidth scrollHeight:(NSInteger)kScrollObjHeight
{
	//FlyrAppDelegate *appDele = [[UIApplication sharedApplication]delegate];

	if (selectedScrollView == templateScrollView)
	{
		UIButton *view = nil;
		NSArray *subviews = [templateScrollView subviews];
		CGFloat curXLoc = 0;
		CGFloat curYLoc = 5;

        if(IS_IPHONE_5)
            curYLoc = 10;
        
		for (view in subviews)
		{
			if ([view isKindOfClass:[UIButton class]] )
			{
				CGRect frame = view.frame;
				frame.origin = CGPointMake(curXLoc, curYLoc);
				view.frame = frame;
				curXLoc += (kScrollObjWidth)+5;
				
				imgPickerFlag =1;
				//if(view.tag == 0)
				//	[view addTarget:self action:@selector(loadPhotoLibrary) forControlEvents:UIControlEventTouchUpInside];
				//else
					[view addTarget:self action:@selector(selectTemplate:) forControlEvents:UIControlEventTouchUpInside];
				
                if(IS_IPHONE_5){
                    if(curXLoc >= 320){
                        curXLoc = 0;
                        curYLoc = curYLoc + kScrollObjHeight + 7;
                    }
                }
			}
		}
        
        if(IS_IPHONE_5){
            [templateScrollView setContentSize:CGSizeMake(320, curYLoc + kScrollObjHeight)];
        } else {
            [templateScrollView setContentSize:CGSizeMake(([templateArray count]*(kScrollObjWidth+5)), [templateScrollView bounds].size.height)];
        }
	}
	else if(selectedScrollView == fontScrollView)
	{
		
		UIButton *view = nil;
		NSArray *subviews = [fontScrollView subviews];
		
		CGFloat curXLoc = 0;
		CGFloat curYLoc = 5;
        int increment = 5;

        if(IS_IPHONE_5){
            curYLoc = 10;
            increment = 8;
        }
        
		for (view in subviews)
		{
			if ([view isKindOfClass:[UIButton class]] )
			{
				CGRect frame = view.frame;
				frame.origin = CGPointMake(curXLoc, curYLoc);
				view.frame = frame;
				curXLoc += (kScrollObjWidth)+increment;
				[view addTarget:self action:@selector(selectFont:) forControlEvents:UIControlEventTouchUpInside];
			
                if(IS_IPHONE_5){
                    if(curXLoc >= 300){
                        curXLoc = 0;
                        curYLoc = curYLoc + kScrollObjHeight + 7;
                    }
                }
            }
		}
        
        if(IS_IPHONE_5){
            [fontScrollView setContentSize:CGSizeMake(320, curYLoc)];
        } else {
            [fontScrollView setContentSize:CGSizeMake((  [fontArray count]*(kScrollObjWidth+5)), [fontScrollView bounds].size.height)];
        }
	}
	else if (selectedScrollView == colorScrollView)
	{
		UIButton *view = nil;
		NSArray *subviews = [colorScrollView subviews];
		
		CGFloat curXLoc = 0;
		CGFloat curYLoc = 5;
        int increment = 5;
        
        if(IS_IPHONE_5){
            curYLoc = 10;
            increment = 8;
        }
        
		for (view in subviews)
		{
			if ([view isKindOfClass:[UIButton class]] )
			{
				CGRect frame = view.frame;
				frame.origin = CGPointMake(curXLoc, curYLoc);
				view.frame = frame;
				curXLoc += (kScrollObjWidth)+increment;
				[view addTarget:self action:@selector(selectColor:) forControlEvents:UIControlEventTouchUpInside];
				
                if(IS_IPHONE_5){
                    if(curXLoc >= 300){
                        curXLoc = 0;
                        curYLoc = curYLoc + kScrollObjHeight + 7;
                    }
                }

			}
		}
        
        if(IS_IPHONE_5){
            [colorScrollView setContentSize:CGSizeMake(320, curYLoc)];
        } else {
            [colorScrollView setContentSize:CGSizeMake((  [colorArray count]*(kScrollObjWidth+5)), [colorScrollView bounds].size.height)];
        }
	}
	else if (selectedScrollView == sizeScrollView)
	{
		UIButton *view = nil;
		NSArray *subviews = [sizeScrollView subviews];
		
		CGFloat curXLoc = 0;
		CGFloat curYLoc = 5;
        int increment = 5;

        if(IS_IPHONE_5){
            curYLoc = 10;
            increment = 8;
        }

		for (view in subviews)
		{
			if ([view isKindOfClass:[UIButton class]])
			{
				CGRect frame = view.frame;
				frame.origin = CGPointMake(curXLoc, curYLoc);
				view.frame = frame;
				curXLoc += (kScrollObjWidth)+increment;
				[view addTarget:self action:@selector(selectSize:) forControlEvents:UIControlEventTouchUpInside];
				
                if(IS_IPHONE_5){
                    if(curXLoc >= 300){
                        curXLoc = 0;
                        curYLoc = curYLoc + kScrollObjHeight + 7;
                    }
                }

			}
		}
        
        if(IS_IPHONE_5){
            [sizeScrollView setContentSize:CGSizeMake(320, curYLoc)];
        } else {
            [sizeScrollView setContentSize:CGSizeMake((  [SIZE_ARRAY count]*(kScrollObjWidth+5)), [sizeScrollView bounds].size.height)];
        }
	}
    else if (selectedScrollView == borderScrollView)
	{
		UIButton *view = nil;
		NSArray *subviews = [borderScrollView subviews];
		
		CGFloat curXLoc = 0;
		CGFloat curYLoc = 5;
        int increment = 5;

        if(IS_IPHONE_5){
            curYLoc = 10;
            increment = 8;
        }
        
		for (view in subviews)
		{
			if ([view isKindOfClass:[UIButton class]])
			{
				CGRect frame = view.frame;
				frame.origin = CGPointMake(curXLoc, curYLoc);
				view.frame = frame;
				curXLoc += (kScrollObjWidth)+increment;
				[view addTarget:self action:@selector(selectBorder:) forControlEvents:UIControlEventTouchUpInside];
				
                if(IS_IPHONE_5){
                    if(curXLoc >= 300){
                        curXLoc = 0;
                        curYLoc = curYLoc + kScrollObjHeight + 7;
                    }
                }

			}
		}
        
        if(IS_IPHONE_5){
            [borderScrollView setContentSize:CGSizeMake(320, curYLoc)];
        } else {
            [borderScrollView setContentSize:CGSizeMake((  [borderArray count]*(kScrollObjWidth+5)), [borderScrollView bounds].size.height)];
        }
	}
    else if (selectedScrollView == fontBorderScrollView)
	{
		UIButton *view = nil;
		NSArray *subviews = [fontBorderScrollView subviews];
		
		CGFloat curXLoc = 0;
		CGFloat curYLoc = 5;
        int increment = 5;
        
        if(IS_IPHONE_5){
            curYLoc = 10;
            increment = 8;
        }
        
		for (view in subviews)
		{
			if ([view isKindOfClass:[UIButton class]])
			{
				CGRect frame = view.frame;
				frame.origin = CGPointMake(curXLoc, curYLoc);
				view.frame = frame;
				curXLoc += (kScrollObjWidth)+increment;
				[view addTarget:self action:@selector(selectFontBorder:) forControlEvents:UIControlEventTouchUpInside];
				
                if(IS_IPHONE_5){
                    if(curXLoc >= 300){
                        curXLoc = 0;
                        curYLoc = curYLoc + kScrollObjHeight + 7;
                    }
                }
                
			}
		}
        
        if(IS_IPHONE_5){
            [fontBorderScrollView setContentSize:CGSizeMake(320, curYLoc)];
        } else {
            [fontBorderScrollView setContentSize:CGSizeMake((  [borderArray count]*(kScrollObjWidth+5)), [fontBorderScrollView bounds].size.height)];
        }
	}
    
    /*else if (selectedScrollView == widthScrollView)
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
	}*/
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
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
	if(imgPickerFlag == 2){
		photoTouchFlag = YES;
		lableTouchFlag = NO;
	}
}

-(void)loadCustomPhotoLibrary{
    
    customPhotoController = [[CustomPhotoController alloc] initWithNibName:@"CustomPhotoController" bundle:nil];
    customPhotoController.callbackObject = self;    
    customPhotoController.callbackOnComplete = @selector(onCompleteSelectingImage:);
    [self setLatestImageAndLoadPhotoLibrary];

    photoTouchFlag = YES;
    lableTouchFlag = NO;

    [self dismissModalViewControllerAnimated:YES];
}

-(void)setLatestImageAndLoadPhotoLibrary{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        // Within the group enumeration block, filter to enumerate just photos.
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        // Chooses the photo at the last index
        [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:([group numberOfAssets] - 1)] options:0 usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
            
            // The end of the enumeration is signaled by asset == nil.
            if (alAsset) {
                ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                UIImage *latestPhoto = [UIImage imageWithCGImage:[representation fullScreenImage]];
                
                if([latestPhoto isKindOfClass:[UIImageView class]]){
                }
                // Do something interesting with the AV asset.
                customPhotoController.image = latestPhoto;
                [self.navigationController pushViewController:customPhotoController animated:YES];
                [customPhotoController release];
            }
        }];
    } failureBlock: ^(NSError *error) {
        // Typically you should handle an error more gracefully than this.
        NSLog(@"No groups");
    }];
}

-(void)loadPhotoLibrary{
	
    self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self presentModalViewController:self.imgPicker animated:YES];
	if(imgPickerFlag == 2){
		photoTouchFlag = YES;
		lableTouchFlag = NO;
	}
}

/**
 * Completed image.
 */
- (void) onCompleteSelectingImage:(UIImage *)selectedImage {
    
	if(self.imgPickerFlag == 1){
		
		//[[self.imgPicker parentViewController] dismissModalViewControllerAnimated:YES];
		UIImage *testImage = [selectedImage retain];
		[self.imgView setImage:testImage] ;
	}
	else if(self.imgPickerFlag == 2){
        
		//[[self.imgPicker parentViewController] dismissModalViewControllerAnimated:YES];
		UIImage *testImage = [selectedImage retain];
		[self.photoImgView setImage:testImage] ;
		self.photoTouchFlag = YES;
		self.lableTouchFlag = NO;
	}
}

-(void)openCustomCamera{
    CameraOverlayView *cameraOverlay =[[CameraOverlayView alloc] initWithNibName:@"CameraOverlayView" bundle:nil];
    cameraOverlay.photoController = self;
    self.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imgPicker.cameraOverlayView = cameraOverlay.view;
    self.imgPicker.showsCameraControls = NO;
    [self presentModalViewController:self.imgPicker animated:YES];
}

-(void)openCamera{
    self.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentModalViewController:self.imgPicker animated:YES];
	if(imgPickerFlag == 2){
		photoTouchFlag = YES;
		lableTouchFlag = NO;
	}
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

	if(self.imgPickerFlag == 1){

        //[self.imgView setImage:info[UIImagePickerControllerOriginalImage]];
        UIImage *image = info[UIImagePickerControllerOriginalImage];

        if(IS_IPHONE_5){
            image = [PhotoController imageWithImage:image scaledToSize:CGSizeMake(320, 568)];
        }else{
            image = [PhotoController imageWithImage:image scaledToSize:CGSizeMake(320, 480)];
        }
        
        CGRect rect;
        if(IS_IPHONE_5){
            rect = CGRectMake(45,
                              110,
                              550, 750);
        }else{
            rect = CGRectMake(5,
                              50,
                              310, 342);
        }
        
        // Create bitmap image from original image data,
        // using rectangle to specify desired crop area
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
        UIImage *img = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        [self.imgView setImage:img];
        [self dismissViewControllerAnimated:YES completion:nil];
	}
	else if(self.imgPickerFlag == 2){
        
		[picker dismissModalViewControllerAnimated:YES];
		UIImage *testImage = [info[UIImagePickerControllerOriginalImage] retain];
		[self.photoImgView setImage:testImage] ;
		self.photoTouchFlag = YES;
		self.lableTouchFlag = NO;
        //[self dismissViewControllerAnimated:YES completion:nil];
		//[self dismissModalViewControllerAnimated:YES];
	}
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(alertView == warningAlert && buttonIndex == 1) {
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
		warningAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"You have not saved your flyer.\nAll progress will be lost if you continue." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue",nil];
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

+(UILabel *)setTitleViewWithTitle:(NSString *)title{
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.textAlignment = NSTextAlignmentCenter;
    //label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    //label.textColor = [MyCustomCell colorWithHexString:@"008ec0"];
    label.textColor = [UIColor darkGrayColor];
    label.text = NSLocalizedString([title uppercaseString], @"");
    [label sizeToFit];

    return label;
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
	
    //UILabel *addBackgroundLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 50)];
    //[addBackgroundLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:8.5]];
    //[addBackgroundLabel setTextColor:[MyCustomCell colorWithHexString:@"008ec0"]];
    //[addBackgroundLabel setBackgroundColor:[UIColor clearColor]];
    //[addBackgroundLabel setText:@"Add Background"];
    //UIBarButtonItem *barLabel = [[UIBarButtonItem alloc] initWithCustomView:addBackgroundLabel];
    self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Add Background"];
    
    UIButton *textButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 29)];
    [textButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [textButton setBackgroundImage:[UIImage imageNamed:@"t_button"] forState:UIControlStateNormal];
	[textButton addTarget:self action:@selector(callWrite) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:textButton];
    
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 31, 30)];
    [menuButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu_button"] forState:UIControlStateNormal];
	[menuButton addTarget:self action:@selector(callMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarMenuButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 13, 16)];
    [helpButton addTarget:self action:@selector(loadHelpController) forControlEvents:UIControlEventTouchUpInside];
    [helpButton setBackgroundImage:[UIImage imageNamed:@"help_icon"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarHelpButton = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
    
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:leftBarMenuButton,leftBarHelpButton,nil]];
    
    [self hideAddMoreTab];
    [self showPictureTab];

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4f];
	templateScrollView.alpha = ALPHA1;
	templateBckgrnd.alpha = ALPHA1;
	[self.templateBckgrnd bringSubviewToFront:templateScrollView];
    if(IS_IPHONE_5){
        templateScrollView.frame= CGRectMake(0, 413,320 ,130);
    }else{
        templateScrollView.frame= CGRectMake(0, 395,320 ,60);
    }
	msgLabel.alpha= 1;
	textBackgrnd.alpha  =ALPHA0;
	fontTabButton.alpha = ALPHA0;
	colorTabButton.alpha = ALPHA0;
	sizeTabButton.alpha = ALPHA0;
	borderTabButton.alpha = ALPHA0;
	fontBorderTabButton.alpha = ALPHA0;
	[msgTextView removeFromSuperview];
	[UIView commitAnimations];

}

-(void)loadHelpController{
    HelpController *helpController = [[HelpController alloc]initWithNibName:@"HelpController" bundle:nil];
    [self.navigationController pushViewController:helpController animated:NO];
}

-(void)callKeyboard{
		[msgTextView becomeFirstResponder];
}

-(void)hidePictureTab{
    [self.cameraRollButton setHidden:YES];
    [self.cameraRollLabel setHidden:YES];
    [self.takePhotoLabel setHidden:YES];
    [self.takePhotoButton setHidden:YES];
}
-(void)showPictureTab{
    [self.cameraRollButton setHidden:NO];
    [self.cameraRollLabel setHidden:NO];
    [self.takePhotoLabel setHidden:NO];
    [self.takePhotoButton setHidden:NO];
}
-(void)hideAddMoreTab{
    [self.moreLayersButton setHidden:YES];
    [self.moreLayersLabel setHidden:YES];
}
-(void)showAddMoreTab{
    [self.moreLayersButton setHidden:NO];
    [self.moreLayersLabel setHidden:NO];
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
	
    //UILabel *addBackgroundLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 55, 50)];
    //[addBackgroundLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:8.5]];
    //[addBackgroundLabel setTextColor:[MyCustomCell colorWithHexString:@"008ec0"]];
    //[addBackgroundLabel setBackgroundColor:[UIColor clearColor]];
    //[addBackgroundLabel setText:@"Add Text"];
    //UIBarButtonItem *barLabel = [[UIBarButtonItem alloc] initWithCustomView:addBackgroundLabel];
    self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Add Text"];

    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
	[nextButton addTarget:self action:@selector(callStyle) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
	[backButton addTarget:self action:@selector(chooseTemplate) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];

    [self hidePictureTab];
    [self hideAddMoreTab];

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

    if(IS_IPHONE_5){
        templateScrollView.frame= CGRectMake(-320, 413,320 ,130);
        fontScrollView.frame = CGRectMake(-320, 385, 320, 130);
        colorScrollView.frame = CGRectMake(-320, 385, 320, 130);
        sizeScrollView.frame = CGRectMake(-320, 385, 320, 130);
        borderScrollView.frame = CGRectMake(-320, 385, 320, 130);
        fontBorderScrollView.frame = CGRectMake(-320, 385, 320, 130);
    }else{
        templateScrollView.frame= CGRectMake(-320, 395,320 ,60);
        fontScrollView.frame = CGRectMake(-320, 385, 320, 44);
        colorScrollView.frame = CGRectMake(-320, 385, 320, 44);
        sizeScrollView.frame = CGRectMake(-320, 385, 320, 44);
        borderScrollView.frame = CGRectMake(-320, 385, 320, 44);
        fontBorderScrollView.frame = CGRectMake(-320, 385, 320, 44);
    }
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
	
    // Create right bar button
    //UILabel *addBackgroundLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    //[addBackgroundLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:8.5]];
    //[addBackgroundLabel setTextColor:[MyCustomCell colorWithHexString:@"008ec0"]];
    //[addBackgroundLabel setBackgroundColor:[UIColor clearColor]];
    //[addBackgroundLabel setText:@"Add Text"];
    //UIBarButtonItem *barLabel = [[UIBarButtonItem alloc] initWithCustomView:addBackgroundLabel];
    self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Add Text"];

    UIButton *photoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
	[photoButton addTarget:self action:@selector(choosePhoto) forControlEvents:UIControlEventTouchUpInside];
    [photoButton setBackgroundImage:[UIImage imageNamed:@"photo_button"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:photoButton];
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [backButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	[backButton addTarget:self action:@selector(callWrite) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];

    [self hidePictureTab];
    [self hideAddMoreTab];

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4f];
    
    if(IS_IPHONE_5){
        fontScrollView.frame = CGRectMake(10, 354, 320, 130);
        colorScrollView.frame = CGRectMake(10, 354, 320, 130);
        sizeScrollView.frame = CGRectMake(10, 354, 320, 130);
        borderScrollView.frame = CGRectMake(10, 354, 320, 130);
        fontBorderScrollView.frame = CGRectMake(10, 354, 320, 130);
    }else{
        fontScrollView.frame = CGRectMake(0, 360, 320, 44);
        colorScrollView.frame = CGRectMake(0, 360, 320, 44);
        sizeScrollView.frame = CGRectMake(0, 360, 320, 44);
        borderScrollView.frame = CGRectMake(0, 360, 320, 44);
        fontBorderScrollView.frame = CGRectMake(0, 360, 320, 44);
    }
	textBackgrnd.alpha = ALPHA1;
	fontScrollView.alpha = ALPHA1;
	colorScrollView.alpha = ALPHA0;
	sizeScrollView.alpha = ALPHA0;
    borderScrollView.alpha = ALPHA0;
    fontBorderScrollView.alpha = ALPHA0;

	[fontTabButton setBackgroundImage:[UIImage imageNamed:@"font_button_selected"] forState:UIControlStateNormal];
	//[fontTabButton setBackgroundImage:[UIImage imageNamed:@"selTab.png"] forState:UIControlStateNormal];
	//[colorTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
    [colorTabButton setBackgroundImage:[UIImage imageNamed:@"color_button"] forState:UIControlStateNormal];
    //[sizeTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
    [sizeTabButton setBackgroundImage:[UIImage imageNamed:@"size_button"] forState:UIControlStateNormal];
    [borderTabButton setBackgroundImage:[UIImage imageNamed:@"outline_button"] forState:UIControlStateNormal];
    [fontBorderTabButton setBackgroundImage:[UIImage imageNamed:@"background_button"] forState:UIControlStateNormal];
	fontTabButton.alpha = ALPHA1;
	colorTabButton.alpha = ALPHA1;
	sizeTabButton.alpha = ALPHA1;
	borderTabButton.alpha = ALPHA1;
	fontBorderTabButton.alpha = ALPHA1;
	msgLabel.alpha=1;
	
	
	cameraTabButton.alpha = ALPHA0;
	photoTabButton.alpha = ALPHA0;
	widthTabButton.alpha = ALPHA0;
	heightTabButton.alpha = ALPHA0;
	//widthScrollView.frame = CGRectMake(-320, 385, 320, 44);
	//heightScrollView.frame = CGRectMake(-320, 385, 320, 44);
	//widthScrollView.alpha = ALPHA0;
	//heightScrollView.alpha = ALPHA0;
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
		
    //UILabel *saveShareLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 55, 50)];
    //[saveShareLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:8.5]];
    //[saveShareLabel setTextColor:[MyCustomCell colorWithHexString:@"008ec0"]];
    //[saveShareLabel setBackgroundColor:[UIColor clearColor]];
    //[saveShareLabel setText:@"Add photo"];
    //UIBarButtonItem *barLabel = [[UIBarButtonItem alloc] initWithCustomView:saveShareLabel];
    self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Add photo"];

    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    shareButton.titleLabel.font = [UIFont fontWithName:@"Signika-Semibold" size:13];
    [shareButton setTitle:@"Save" forState:UIControlStateNormal];
	[shareButton addTarget:self action:@selector(callSaveAndShare) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"crop_button"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];

    // Create right bar button
    //UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Save/Share" style:UIBarButtonItemStylePlain target:self action:@selector(callSaveAndShare)];
    //[self.navigationItem setRightBarButtonItem:rightBarButton];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [backButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	[backButton addTarget:self action:@selector(callStyle) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];

    [self hidePictureTab];
    [self showAddMoreTab];

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
	borderTabButton.alpha = ALPHA0;
	fontBorderTabButton.alpha = ALPHA0;

    if(IS_IPHONE_5){
        fontScrollView.frame = CGRectMake(-320, 385, 320, 130);
        colorScrollView.frame = CGRectMake(-320, 385, 320, 130);
        sizeScrollView.frame = CGRectMake(-320, 385, 320, 130);
        borderScrollView.frame = CGRectMake(-320, 385, 320, 130);
        fontBorderScrollView.frame = CGRectMake(-320, 385, 320, 130);
    }else{
        fontScrollView.frame = CGRectMake(-320, 385, 320, 44);
        colorScrollView.frame = CGRectMake(-320, 385, 320, 44);
        sizeScrollView.frame = CGRectMake(-320, 385, 320, 44);
        borderScrollView.frame = CGRectMake(-320, 385, 320, 44);
        fontBorderScrollView.frame = CGRectMake(-320, 385, 320, 44);
    }

	msgLabel.alpha=1;
	[cameraTabButton setBackgroundImage:[UIImage imageNamed:@"07_camera"] forState:UIControlStateNormal];
	[photoTabButton setBackgroundImage:[UIImage imageNamed:@"07_roll"] forState:UIControlStateNormal];
	[widthTabButton setBackgroundImage:[UIImage imageNamed:@"07_width_selected"] forState:UIControlStateNormal];
	[heightTabButton setBackgroundImage:[UIImage imageNamed:@"07_height"] forState:UIControlStateNormal];
    [widthTabButton setSelected:YES];
    [heightTabButton setSelected:NO];
    
	cameraTabButton.alpha = ALPHA1;
	photoTabButton.alpha = ALPHA1;
	widthTabButton.alpha = ALPHA1;
	heightTabButton.alpha = ALPHA1;
	//widthScrollView.frame = CGRectMake(0, 385, 320, 44);
	//heightScrollView.frame = CGRectMake(0, 385, 320, 44);
	//widthScrollView.alpha = ALPHA1;
	//heightScrollView.alpha = ALPHA0;
	textBackgrnd.alpha = ALPHA1;
	[UIView commitAnimations];
	
    UIPinchGestureRecognizer *twoFingerPinch =
    [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerPinch:)] autorelease];
    [[self view] addGestureRecognizer:twoFingerPinch];
    
	lableTouchFlag = NO;
	photoTouchFlag = YES;
	[self.imgView sendSubviewToBack:photoImgView];
	[self.imgView bringSubviewToFront:msgLabel];
}

CGRect initialBounds;

- (void)twoFingerPinch:(UIPinchGestureRecognizer *)gestureRecognizer
{
    //NSLog(@"Pinch scale: %f", gestureRecognizer.scale);
        
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        initialBounds = photoImgView.bounds;
    }
    CGFloat factor = [(UIPinchGestureRecognizer *)gestureRecognizer scale];
    
    CGAffineTransform zt;
    
    if([widthTabButton isSelected]){
        zt = CGAffineTransformScale(CGAffineTransformIdentity, factor, 1);
    } else if([heightTabButton isSelected]){
        zt = CGAffineTransformScale(CGAffineTransformIdentity, 1, factor);
    }

    photoImgView.bounds = CGRectApplyAffineTransform(initialBounds, zt);
}

CGPoint CGPointDistance(CGPoint point1, CGPoint point2)
{
    return CGPointMake(point2.x - point1.x, point2.y - point1.y);
};


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
	
    // Create right bar button
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(callMenu)];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    [self hidePictureTab];
    [self hideAddMoreTab];

	fontTabButton.alpha = ALPHA0;
	colorTabButton.alpha = ALPHA0;
	sizeTabButton.alpha = ALPHA0;
	borderTabButton.alpha = ALPHA0;
	fontBorderTabButton.alpha = ALPHA0;
	textBackgrnd.alpha = ALPHA0;
    
    if(IS_IPHONE_5){
        fontScrollView.frame = CGRectMake(-320, 385, 320, 130);
        colorScrollView.frame = CGRectMake(-320, 385, 320, 130);
        sizeScrollView.frame = CGRectMake(-320, 385, 320, 130);
        borderScrollView.frame = CGRectMake(-320, 385, 320, 130);
        fontBorderScrollView.frame = CGRectMake(-320, 385, 320, 130);
    }else{
        fontScrollView.frame = CGRectMake(-320, 385, 320, 44);
        colorScrollView.frame = CGRectMake(-320, 385, 320, 44);
        sizeScrollView.frame = CGRectMake(-320, 385, 320, 44);
        borderScrollView.frame = CGRectMake(-320, 385, 320, 44);
        fontBorderScrollView.frame = CGRectMake(-320, 385, 320, 44);
    }
	msgLabel.alpha=1;

    FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
    NSData *data = [self getCurrentFrameAndSaveIt];
    [self showHUD];
    appDele.changesFlag = NO;
    
    DraftViewController *draftViewController = [[DraftViewController alloc] initWithNibName:@"DraftViewController" bundle:nil];
    draftViewController.fromPhotoController = YES;
    draftViewController.selectedFlyerImage = [UIImage imageWithData:data];
    draftViewController.selectedFlyerTitle = @"Title";
    draftViewController.selectedFlyerDescription = msgTextView.text;
    draftViewController.imageFileName = finalImgWritePath;
    draftViewController.detailFileName = [finalImgWritePath stringByReplacingOccurrencesOfString:@".jpg" withString:@".txt"];
    [self.navigationController pushViewController:draftViewController animated:YES];
    [draftViewController release];
    
	//[self saveMyFlyer];
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

	cameraTabButton.alpha = ALPHA0;
	photoTabButton.alpha = ALPHA0;
	widthTabButton.alpha = ALPHA0;
	heightTabButton.alpha = ALPHA0;
	//widthScrollView.frame = CGRectMake(-320, 385, 320, 44);
	//heightScrollView.frame = CGRectMake(-320, 385, 320, 44);
	//widthScrollView.alpha = ALPHA0;
	//heightScrollView.alpha = ALPHA0;
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
		[borderScrollView setAlpha:ALPHA0];
		[fontBorderScrollView setAlpha:ALPHA0];
		[fontTabButton setBackgroundImage:[UIImage imageNamed:@"font_button_selected"] forState:UIControlStateNormal];
		//[fontTabButton setBackgroundImage:[UIImage imageNamed:@"selTab.png"] forState:UIControlStateNormal];
		//[colorTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
		[colorTabButton setBackgroundImage:[UIImage imageNamed:@"color_button"] forState:UIControlStateNormal];
		//[sizeTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
		[sizeTabButton setBackgroundImage:[UIImage imageNamed:@"size_button"] forState:UIControlStateNormal];
		[borderTabButton setBackgroundImage:[UIImage imageNamed:@"outline_button"] forState:UIControlStateNormal];
		[fontBorderTabButton setBackgroundImage:[UIImage imageNamed:@"background_button"] forState:UIControlStateNormal];
		[UIView commitAnimations];
	}
	else if(selectedButton == colorTabButton)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4f];
		[fontScrollView setAlpha:ALPHA0];
		[colorScrollView setAlpha:ALPHA1];
		[sizeScrollView setAlpha:ALPHA0];
		[borderScrollView setAlpha:ALPHA0];
		[fontBorderScrollView setAlpha:ALPHA0];
		[fontTabButton setBackgroundImage:[UIImage imageNamed:@"font_button"] forState:UIControlStateNormal];
		//[fontTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
		//[colorTabButton setBackgroundImage:[UIImage imageNamed:@"selTab.png"] forState:UIControlStateNormal];
		[colorTabButton setBackgroundImage:[UIImage imageNamed:@"color_button_selected"] forState:UIControlStateNormal];
		//[sizeTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
		[sizeTabButton setBackgroundImage:[UIImage imageNamed:@"size_button"] forState:UIControlStateNormal];
		[borderTabButton setBackgroundImage:[UIImage imageNamed:@"outline_button"] forState:UIControlStateNormal];
		[fontBorderTabButton setBackgroundImage:[UIImage imageNamed:@"background_button"] forState:UIControlStateNormal];
		[UIView commitAnimations];
	}
	else if(selectedButton == sizeTabButton)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4f];
		[fontScrollView setAlpha:ALPHA0];
		[colorScrollView setAlpha:ALPHA0];
		[sizeScrollView setAlpha:ALPHA1];
		[borderScrollView setAlpha:ALPHA0];
		[fontBorderScrollView setAlpha:ALPHA0];
		[fontTabButton setBackgroundImage:[UIImage imageNamed:@"font_button"] forState:UIControlStateNormal];
		//[fontTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
		[colorTabButton setBackgroundImage:[UIImage imageNamed:@"color_button"] forState:UIControlStateNormal];
		//[sizeTabButton setBackgroundImage:[UIImage imageNamed:@"selTab.png"] forState:UIControlStateNormal];
		[sizeTabButton setBackgroundImage:[UIImage imageNamed:@"size_button_selected"] forState:UIControlStateNormal];
		[borderTabButton setBackgroundImage:[UIImage imageNamed:@"outline_button"] forState:UIControlStateNormal];
		[fontBorderTabButton setBackgroundImage:[UIImage imageNamed:@"background_button"] forState:UIControlStateNormal];
		[UIView commitAnimations];
	}
	else if(selectedButton == borderTabButton)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4f];
		[fontScrollView setAlpha:ALPHA0];
		[colorScrollView setAlpha:ALPHA0];
		[sizeScrollView setAlpha:ALPHA0];
		[borderScrollView setAlpha:ALPHA0];
		[fontBorderScrollView setAlpha:ALPHA1];
		[fontTabButton setBackgroundImage:[UIImage imageNamed:@"font_button"] forState:UIControlStateNormal];
		//[fontTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
		[colorTabButton setBackgroundImage:[UIImage imageNamed:@"color_button"] forState:UIControlStateNormal];
		//[sizeTabButton setBackgroundImage:[UIImage imageNamed:@"selTab.png"] forState:UIControlStateNormal];
		[sizeTabButton setBackgroundImage:[UIImage imageNamed:@"size_button"] forState:UIControlStateNormal];
		[borderTabButton setBackgroundImage:[UIImage imageNamed:@"outline_button_selected"] forState:UIControlStateNormal];
		[fontBorderTabButton setBackgroundImage:[UIImage imageNamed:@"background_button"] forState:UIControlStateNormal];
		[UIView commitAnimations];
	}
	else if(selectedButton == fontBorderTabButton)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4f];
		[fontScrollView setAlpha:ALPHA0];
		[colorScrollView setAlpha:ALPHA0];
		[sizeScrollView setAlpha:ALPHA0];
		[borderScrollView setAlpha:ALPHA1];
		[fontBorderScrollView setAlpha:ALPHA0];
		[fontTabButton setBackgroundImage:[UIImage imageNamed:@"font_button"] forState:UIControlStateNormal];
		//[fontTabButton setBackgroundImage:[UIImage imageNamed:@"tabButton.png"] forState:UIControlStateNormal];
		[colorTabButton setBackgroundImage:[UIImage imageNamed:@"color_button"] forState:UIControlStateNormal];
		//[sizeTabButton setBackgroundImage:[UIImage imageNamed:@"selTab.png"] forState:UIControlStateNormal];
		[sizeTabButton setBackgroundImage:[UIImage imageNamed:@"size_button"] forState:UIControlStateNormal];
		[borderTabButton setBackgroundImage:[UIImage imageNamed:@"outline_button"] forState:UIControlStateNormal];
		[fontBorderTabButton setBackgroundImage:[UIImage imageNamed:@"background_button_selected"] forState:UIControlStateNormal];
		[UIView commitAnimations];
	}
}


-(void) setPhotoTabAction:(id) sender{
	UIButton *selectedButton = (UIButton*)sender;
	if(selectedButton == cameraTabButton)
	{
		imgPickerFlag =2;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4f];
		textBackgrnd.alpha = ALPHA0;
		[cameraTabButton setBackgroundImage:[UIImage imageNamed:@"07_camera_selected"] forState:UIControlStateNormal];
		[photoTabButton setBackgroundImage:[UIImage imageNamed:@"07_roll"] forState:UIControlStateNormal];
		[widthTabButton setBackgroundImage:[UIImage imageNamed:@"07_width"] forState:UIControlStateNormal];
		[heightTabButton setBackgroundImage:[UIImage imageNamed:@"07_height"] forState:UIControlStateNormal];
		[UIView commitAnimations];

		[self openCustomCamera];
	}
    else if(selectedButton == photoTabButton)
	{
		imgPickerFlag =2;
		[self loadCustomPhotoLibrary];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4f];
		textBackgrnd.alpha = ALPHA0;
		//widthScrollView.frame = CGRectMake(-320, 385, 320, 44);
		//heightScrollView.frame = CGRectMake(-320, 385, 320, 44);
		[cameraTabButton setBackgroundImage:[UIImage imageNamed:@"07_camera"] forState:UIControlStateNormal];
		[photoTabButton setBackgroundImage:[UIImage imageNamed:@"07_roll_selected"] forState:UIControlStateNormal];
		[widthTabButton setBackgroundImage:[UIImage imageNamed:@"07_width"] forState:UIControlStateNormal];
		[heightTabButton setBackgroundImage:[UIImage imageNamed:@"07_height"] forState:UIControlStateNormal];
		[UIView commitAnimations];
	}
	else if(selectedButton ==widthTabButton)
	{
		//[widthScrollView setAlpha:ALPHA1];
		//[heightScrollView setAlpha:ALPHA0];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4f];
		textBackgrnd.alpha = ALPHA1;
		//widthScrollView.frame = CGRectMake(0, 385, 320, 44);
		//heightScrollView.frame = CGRectMake(-320, 385, 320, 44);
		[cameraTabButton setBackgroundImage:[UIImage imageNamed:@"07_camera"] forState:UIControlStateNormal];
		[photoTabButton setBackgroundImage:[UIImage imageNamed:@"07_roll"] forState:UIControlStateNormal];
		[widthTabButton setBackgroundImage:[UIImage imageNamed:@"07_width_selected"] forState:UIControlStateNormal];
		[heightTabButton setBackgroundImage:[UIImage imageNamed:@"07_height"] forState:UIControlStateNormal];

        [widthTabButton setSelected:YES];
        [heightTabButton setSelected:NO];
		[UIView commitAnimations];
	}
	else if(selectedButton == heightTabButton)
	{
		//[widthScrollView setAlpha:ALPHA0];
		//[heightScrollView setAlpha:ALPHA1];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4f];
		textBackgrnd.alpha = ALPHA1;
		//widthScrollView.frame = CGRectMake(-320, 385, 320, 44);
		//heightScrollView.frame = CGRectMake(0, 385, 320, 44);
		[cameraTabButton setBackgroundImage:[UIImage imageNamed:@"07_camera"] forState:UIControlStateNormal];
		[photoTabButton setBackgroundImage:[UIImage imageNamed:@"07_roll"] forState:UIControlStateNormal];
		[widthTabButton setBackgroundImage:[UIImage imageNamed:@"07_width"] forState:UIControlStateNormal];
		[heightTabButton setBackgroundImage:[UIImage imageNamed:@"07_height_selected"] forState:UIControlStateNormal];
        
        [widthTabButton setSelected:NO];
        [heightTabButton setSelected:YES];
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

    CGPoint loc = [touch locationInView:self.imgView];
    
	if(numTaps == 1)
	{
		//if (CGRectContainsPoint([self.imgView frame], [touch locationInView:self.imgView]) && lableTouchFlag )
        if (loc.y <= imgView.frame.size.height && lableTouchFlag )
		{
			[self.imgView sendSubviewToBack:photoImgView];
			[self.imgView bringSubviewToFront:msgLabel];

			for (UITouch *touch in touches) {
				//[self dispatchFirstTouchAtPoint:msgLabel point:[touch locationInView:self.view] forEvent:nil];
				[self dispatchFirstTouchAtPoint:msgLabel point:[touch locationInView:self.imgView] forEvent:nil];
			}
		}	
		//else if (CGRectContainsPoint([photoImgView frame], [touch locationInView:self.imgView]) && photoTouchFlag)
		else if (loc.y <= (imgView.frame.size.height-(photoImgView.frame.size.height/2)) && photoTouchFlag)
		{
			[self.imgView sendSubviewToBack:photoImgView];
			[self.imgView bringSubviewToFront:msgLabel];
			for (UITouch *touch in touches) {
				[self dispatchFirstTouchAtPoint:photoImgView point:[touch locationInView:self.imgView] forEvent:nil];
				//[self dispatchFirstTouchAtPoint:photoImgView point:[touch locationInView:self.view] forEvent:nil];
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
    CGPoint loc = [touch locationInView:self.imgView];
		
	//if (CGRectContainsPoint([msgLabel frame], [touch locationInView:self.view]) && lableTouchFlag)
    //if (CGRectContainsPoint([self.imgView frame], [touch locationInView:self.imgView]) && lableTouchFlag)
    if (loc.y <= imgView.frame.size.height && lableTouchFlag)
	{
		
		for (UITouch *touch in touches){
			lableLocation = [touch locationInView:self.imgView];
			[self dispatchTouchEvent:msgLabel toPosition:[touch locationInView:self.imgView]];
			//[self dispatchTouchEvent:msgLabel toPosition:[touch locationInView:self.view]];
		}
		
	}
	//else if (CGRectContainsPoint([photoImgView frame], [touch locationInView:self.view]) && photoTouchFlag)
	//else if (CGRectContainsPoint([photoImgView frame], [touch locationInView:self.imgView]) && photoTouchFlag)
	else if (loc.y <= (imgView.frame.size.height-(photoImgView.frame.size.height/2)) && photoTouchFlag)
	{
		for (UITouch *touch in touches){
			[self dispatchTouchEvent:photoImgView toPosition:[touch locationInView:self.imgView]];
			//[self dispatchTouchEvent:photoImgView toPosition:[touch locationInView:self.view]];
		}
	}
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    /*
	UITouch *touch = [touches anyObject];
	[self dispatchTouchEndEvent:msgLabel toPosition:[touch locationInView:self.imgView]];
	[self dispatchTouchEndEvent:photoImgView toPosition:[touch locationInView:self.imgView]];
	//[self dispatchTouchEndEvent:msgLabel toPosition:[touch locationInView:self.view]];
	//[self dispatchTouchEndEvent:photoImgView toPosition:[touch locationInView:self.view]];
	if (!CGRectContainsPoint([msgLabel frame], [touch locationInView:self.imgView])&& lableTouchFlag)
	{
	//if (!CGRectContainsPoint([msgLabel frame], [touch locationInView:self.view])&& lableTouchFlag)
	//{
		[self.view bringSubviewToFront:msgLabel];
		for (UITouch *touch in touches) {
			//[self dispatchFirstTouchAtPoint:msgLabel point:[touch locationInView:self.view] forEvent:nil];
			[self dispatchFirstTouchAtPoint:msgLabel point:[touch locationInView:self.imgView] forEvent:nil];
		}
	}
	else if (!CGRectContainsPoint([photoImgView frame], [touch locationInView:self.imgView]) && photoTouchFlag)
	//else if (!CGRectContainsPoint([photoImgView frame], [touch locationInView:self.view]) && photoTouchFlag)
	{
		for (UITouch *touch in touches){
			[self dispatchFirstTouchAtPoint:photoImgView point:[touch locationInView:self.imgView] forEvent:nil];
			//[self dispatchFirstTouchAtPoint:photoImgView point:[touch locationInView:self.view] forEvent:nil];
		}
	}
     */
}
/************************************************************************************************/

#pragma mark Save Flyer image and write to Documents/Flyr folder 

-(NSData*)getCurrentFrameAndSaveIt
{
	CGSize size = CGSizeMake(self.imgView.bounds.size.width,self.imgView.bounds.size.height );
    //if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        //UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
        UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    //} else {
    //    UIGraphicsBeginImageContext(size);
    //}
	[self.imgView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	NSString *homeDirectoryPath = NSHomeDirectory();
	NSString *MyFlyerPath = [homeDirectoryPath stringByAppendingString:@"/Documents/Flyr/"];
	NSString *folderPath = [NSString pathWithComponents:[NSArray arrayWithObjects:[NSString stringWithString:[MyFlyerPath stringByStandardizingPath]],nil]];
	NSInteger imgCount;
	NSInteger largestImgCount=-1;
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
	
	NSString *finalImgDetailWritePath;

	/************************ CREATE UNIQUE NAME FOR IMAGE ***********************************/
	if(files == nil)
	{
		finalImgWritePath = [folderPath stringByAppendingString:@"/IMG_0.jpg"];
        finalImgDetailWritePath = [folderPath stringByAppendingString:@"/IMG_0.txt"];

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
		newImgName = [NSString stringWithFormat:@"/IMG_%d.jpg",++largestImgCount];
		finalImgWritePath = [folderPath stringByAppendingString:newImgName];
		NSString *newImgDetailName = [NSString stringWithFormat:@"/IMG_%d.txt",largestImgCount];
		finalImgDetailWritePath = [folderPath stringByAppendingString:newImgDetailName];

	}
	/************************ END OF CREATE UNIQUE NAME FOR IMAGE ***********************************/

	NSString *imgPath = [NSString pathWithComponents:[NSArray arrayWithObjects:[NSString stringWithString:[finalImgWritePath stringByExpandingTildeInPath]], nil]];
	if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:NULL]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:folderPath attributes:nil];
	}
    
	NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    [array addObject:@"Title"];
    [array addObject:msgTextView.text];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:FlyerDateFormat];
    NSString *dateString = [dateFormat stringFromDate:date];
    [array addObject:dateString];
    
    [array writeToFile:finalImgDetailWritePath atomically:YES];
	
    // Save states of all supported social media
	NSMutableArray *socialArray = [[[NSMutableArray alloc] init] autorelease];
    [socialArray addObject:@"0"]; //Facebook
    [socialArray addObject:@"0"]; //Twitter
    [socialArray addObject:@"0"]; //Email
    [socialArray addObject:@"0"]; //Tumblr
    [socialArray addObject:@"0"]; //Flickr
    [socialArray addObject:@"0"]; //Instagram
    [socialArray addObject:@"0"]; //SMS
    [socialArray addObject:@"0"]; //Clipboard
    
    if(files){
        [self saveSocialStates:folderPath imageName:newImgName stateArray:socialArray];
    }else{
        [self saveSocialStates:folderPath imageName:@"/IMG_0.jpg" stateArray:socialArray];
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

-(void)saveSocialStates:(NSString *)directory imageName:(NSString *)imageName stateArray:(NSArray *)stateArray{

	NSString *socialFlyerPath = [NSString stringWithFormat:@"%@/Social/", directory];
	//NSString *folderPath = [NSString pathWithComponents:[NSArray arrayWithObjects:[NSString stringWithString:[socialFlyerPath stringByStandardizingPath]],nil]];
    
    NSString *str = [imageName stringByReplacingOccurrencesOfString:@".jpg" withString:@".soc"];
	NSString *finalImgWritePath = [socialFlyerPath stringByAppendingString:str];
   
	//NSString *imgPath = [NSString pathWithComponents:[NSArray arrayWithObjects:[NSString stringWithString:[finalImgWritePath stringByExpandingTildeInPath]], nil]];
	if (![[NSFileManager defaultManager] fileExistsAtPath:socialFlyerPath isDirectory:NULL]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:socialFlyerPath attributes:nil];
	}
    
    [stateArray writeToFile:finalImgWritePath atomically:YES];
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
	[borderScrollView release];
	[fontBorderScrollView release];
	[fontScrollView release];
	//[newImgName release];
    
    [super dealloc];
}

@end
