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
@synthesize newImgName;
@synthesize imgView,imgPicker;
@synthesize fontScrollView,colorScrollView,templateScrollView,sizeScrollView,borderScrollView,fontBorderScrollView,symbolScrollView,iconScrollView;
@synthesize msgTextView,finalFlyer;
@synthesize selectedFont,selectedColor,navBar;
@synthesize selectedTemplate,selectedSymbol,selectedIcon;
@synthesize fontTabButton,colorTabButton,sizeTabButton,selectedText,selectedSize,borderTabButton,fontBorderTabButton,addMoreFontTabButton,addMoreIconTabButton,addMorePhotoTabButton,addMoreSymbolTabButton,arrangeLayerTabButton;
@synthesize templateBckgrnd,textBackgrnd,aHUD;
//@synthesize widthScrollView,heightScrollView
@synthesize cameraTabButton,photoTabButton,widthTabButton,heightTabButton,photoImgView,symbolImgView,iconImgView;
@synthesize photoTouchFlag,symbolTouchFlag,iconTouchFlag, lableTouchFlag,lableLocation,warningAlert;
@synthesize moreLayersLabel, moreLayersButton, takePhotoButton, cameraRollButton, takePhotoLabel, cameraRollLabel, imgPickerFlag,finalImgWritePath;

int selectedAddMoreLayerTab = -1;
const int ADD_MORE_TEXT_TAB = 0;
const int ADD_MORE_PHOTO_TAB = 1;
const int ADD_MORE_SYMBOL_TAB = 2;
const int ADD_MORE_ICON_TAB = 3;
const int ARRANGE_LAYER_TAB = 4;
int symbolLayerCount = 0;
int iconLayerCount = 0;
int textLayerCount = 0;
int photoLayerCount = 0;

#pragma mark  View Appear Methods
-(void)viewWillAppear:(BOOL)animated{
	
	[super viewWillAppear:YES];	
	self.navigationController.navigationBarHidden = NO;
	imgPicker = [[UIImagePickerController alloc] init];
	imgPicker.allowsImageEditing = NO;
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
    photoTouchFlag=NO;
	symbolTouchFlag=NO;
    iconTouchFlag = NO;
	lableTouchFlag=NO;

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
    [moreLayersButton addTarget:self action:@selector(callAddMoreLayers) forControlEvents:UIControlEventTouchUpInside];
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
    //[[self photoLayersArray] addObject:photoImgView];

	symbolImgView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 50, 90, 70)];
	[symbolImgView setUserInteractionEnabled:NO];
    //[[self symbolLayersArray] addObject:symbolImgView];
    
	iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(150, 50, 90, 70)];
	[iconImgView setUserInteractionEnabled:NO];
    //[[self iconLayersArray] addObject:iconImgView];
    
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
    //[[self textLabelLayersArray] addObject:msgLabel];

	msgTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 50, 280, 150)];
	msgTextView.delegate = self;
	msgTextView.font = [UIFont fontWithName:@"Arial" size:16];
	msgTextView.textColor = [UIColor blackColor];
	msgTextView.textAlignment = UITextAlignmentCenter;
    //[[self textEditLayersArray] addObject:msgTextView];
	
	fontScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385,320,44)];
	colorScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385,320,44)];
	sizeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385, 320, 44)];
	borderScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385, 320, 44)];
	fontBorderScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385, 320, 44)];
	symbolScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385,320,44)];
	iconScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385,320,44)];
	layerScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385,320,44)];
	//widthScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385,320,44)];
	//heightScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385, 320, 44)];
	
		
    // Add Templates
	NSInteger templateScrollWidth = 60;
	NSInteger templateScrollHeight = 55;
	templateArray = [[NSMutableArray alloc]init];
	NSAutoreleasePool* pool1 = [[NSAutoreleasePool alloc] init];

	for(int i=0;i<67;i++) {

		NSString* templateName = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Template%d",i] ofType:@"jpg"];
		UIImage *templateImg =  [UIImage imageWithContentsOfFile:templateName];
        
		[templateArray addObject:templateImg];
		
		NSString* iconName = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon%d",i] ofType:@"jpg"];
		UIImage *iconImg =   [UIImage  imageWithContentsOfFile:iconName];
		
		UIButton *templateButton = [UIButton  buttonWithType:UIButtonTypeCustom];
		templateButton.frame =CGRectMake(0, 5,templateScrollWidth, templateScrollHeight);
        [templateButton setBackgroundColor:[UIColor whiteColor]];

		UIImageView *img = [[UIImageView alloc]initWithImage:iconImg];
		img.frame  = CGRectMake(templateButton.frame.origin.x+5, templateButton.frame.origin.y-2, templateButton.frame.size.width-10, templateButton.frame.size.height-7);
		[templateButton addSubview:img];
		templateButton.tag = i;
		[templateScrollView addSubview:templateButton];
	}
	[pool1 release];
    
    // Add Symbols
	NSInteger symbolScrollWidth = 60;
	NSInteger symbolScrollHeight = 55;
	symbolArray = [[NSMutableArray alloc]init];
    
	for(int i=1;i<=21;i++) {
        
		NSString* symbolName = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"symbol%d",i] ofType:@"png"];
		UIImage *symbolImg =  [UIImage imageWithContentsOfFile:symbolName];
        
		[symbolArray addObject:symbolImg];
		
		UIButton *symbolButton = [UIButton  buttonWithType:UIButtonTypeCustom];
		symbolButton.frame =CGRectMake(0, 5,symbolScrollWidth, symbolScrollHeight);
        [symbolButton setBackgroundColor:[UIColor whiteColor]];
        
		UIImageView *img = [[UIImageView alloc]initWithImage:symbolImg];
		img.frame  = CGRectMake(symbolButton.frame.origin.x+5, symbolButton.frame.origin.y-2, symbolButton.frame.size.width-10, symbolButton.frame.size.height-7);
		[symbolButton addSubview:img];
		symbolButton.tag = i;
		[symbolScrollView addSubview:symbolButton];
	}
    
    // Add Icons
	NSInteger iconScrollWidth = 60;
	NSInteger iconScrollHeight = 55;
	iconArray = [[NSMutableArray alloc]init];
    
	for(int i=1;i<=21;i++) {
        
		NSString* iconName = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"ricon%d",i] ofType:@"png"];
		UIImage *iconImg =  [UIImage imageWithContentsOfFile:iconName];
        
		[iconArray addObject:iconImg];
		
		UIButton *iconButton = [UIButton  buttonWithType:UIButtonTypeCustom];
		iconButton.frame =CGRectMake(0, 5,iconScrollWidth, iconScrollHeight);
        [iconButton setBackgroundColor:[UIColor whiteColor]];
        
		UIImageView *img = [[UIImageView alloc]initWithImage:iconImg];
		img.frame  = CGRectMake(iconButton.frame.origin.x+5, iconButton.frame.origin.y-2, iconButton.frame.size.width-10, iconButton.frame.size.height-7);
		[iconButton addSubview:img];
		iconButton.tag = i;
		[iconScrollView addSubview:iconButton];
	}
    
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
	
	
	fontScrollWidth = 44;
	fontScrollHeight = 35;
	colorScrollWidth = 44;
	colorScrollHeight = 35;
	NSInteger sizeScrollWidth = 44;
	NSInteger sizeScrollHeight = 35;
    borderScrollWidth = 44;
	borderScrollHeight = 35;
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

    [self addFontsInSubView];
	
	colorArray = 	[[NSArray  alloc] initWithObjects: [UIColor redColor], [UIColor blueColor], [UIColor greenColor], [UIColor blackColor], [UIColor colorWithRed:253.0/255.0 green:191.0/255.0 blue:38.0/224.0 alpha:1], [UIColor whiteColor], [UIColor grayColor], [UIColor magentaColor], [UIColor yellowColor], [UIColor colorWithRed:163.0/255.0 green:25.0/255.0 blue:2.0/224.0 alpha:1], [UIColor colorWithRed:3.0/255.0 green:15.0/255.0 blue:41.0/224.0 alpha:1], [UIColor purpleColor], [UIColor colorWithRed:85.0/255.0 green:86.0/255.0 blue:12.0/224.0 alpha:1], [UIColor orangeColor], [UIColor colorWithRed:98.0/255.0 green:74.0/255.0 blue:9.0/224.0 alpha:1], [UIColor colorWithRed:80.0/255.0 green:7.0/255.0 blue:1.0/224.0 alpha:1], [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:97.0/224.0 alpha:1], [UIColor colorWithRed:111.0/255.0 green:168.0/255.0 blue:100.0/224.0 alpha:1], [UIColor cyanColor], [UIColor colorWithRed:17.0/255.0 green:69.0/255.0 blue:70.0/224.0 alpha:1], [UIColor colorWithRed:173.0/255.0 green:127.0/255.0 blue:251.0/224.0 alpha:1], nil];
	
    [self addColorsInSubView];
    
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
        
        if(i>5 && i<([SIZE_ARRAY count] - 1)){
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

    [self addTextBorderInSubView];
    
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
    
    [symbolScrollView setCanCancelContentTouches:NO];
	symbolScrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
	symbolScrollView.clipsToBounds = YES;
	symbolScrollView.scrollEnabled = YES;
	symbolScrollView.pagingEnabled = NO;
	symbolScrollView.showsHorizontalScrollIndicator = NO;
	symbolScrollView.showsVerticalScrollIndicator = NO;
	symbolScrollView.alpha = ALPHA0;
	[self.view addSubview:symbolScrollView];
	[self layoutScrollImages:symbolScrollView scrollWidth:symbolScrollWidth scrollHeight:symbolScrollHeight];

    [iconScrollView setCanCancelContentTouches:NO];
	iconScrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
	iconScrollView.clipsToBounds = YES;
	iconScrollView.scrollEnabled = YES;
	iconScrollView.pagingEnabled = NO;
	iconScrollView.showsHorizontalScrollIndicator = NO;
	iconScrollView.showsVerticalScrollIndicator = NO;
	iconScrollView.alpha = ALPHA0;
	[self.view addSubview:iconScrollView];
	[self layoutScrollImages:iconScrollView scrollWidth:iconScrollWidth scrollHeight:iconScrollHeight];
    
   
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
    addMoreFontTabButton =[UIButton buttonWithType:UIButtonTypeCustom];
    addMoreIconTabButton =[UIButton buttonWithType:UIButtonTypeCustom];
    addMorePhotoTabButton =[UIButton buttonWithType:UIButtonTypeCustom];
    addMoreSymbolTabButton =[UIButton buttonWithType:UIButtonTypeCustom];
    arrangeLayerTabButton =[UIButton buttonWithType:UIButtonTypeCustom];

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
        addMoreFontTabButton.frame = CGRectMake(-1, 502, 65, 46);
        addMorePhotoTabButton.frame = CGRectMake(64, 502, 65, 46);
        addMoreIconTabButton.frame = CGRectMake(129, 502, 65, 46);
        addMoreSymbolTabButton.frame = CGRectMake(194, 502, 65, 46);
        arrangeLayerTabButton.frame = CGRectMake(259, 502, 65, 46);
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
        addMoreFontTabButton.frame = CGRectMake(-1, 415, 65, 46);
        addMorePhotoTabButton.frame = CGRectMake(64, 415, 65, 46);
        addMoreIconTabButton.frame = CGRectMake(129, 415, 65, 46);
        addMoreSymbolTabButton.frame = CGRectMake(194, 415, 65, 46);
        arrangeLayerTabButton.frame = CGRectMake(259, 415, 65, 46);
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
	 
    // Add more layer tabs
	[addMoreFontTabButton setBackgroundImage:[UIImage imageNamed:@"text_icon"] forState:UIControlStateNormal];
	[addMoreFontTabButton addTarget:self action:@selector(setAddMoreLayerTabAction:) forControlEvents:UIControlEventTouchUpInside];
	addMoreFontTabButton.alpha =  ALPHA0;
	addMoreFontTabButton.tag = 10001;
	[self.view addSubview:addMoreFontTabButton];
	
	[addMorePhotoTabButton setBackgroundImage:[UIImage imageNamed:@"image_icon"] forState:UIControlStateNormal];
	[addMorePhotoTabButton addTarget:self action:@selector(setAddMoreLayerTabAction:) forControlEvents:UIControlEventTouchUpInside];
	addMorePhotoTabButton.alpha =  ALPHA0;
	addMorePhotoTabButton.tag = 10002;
	[self.view addSubview:addMorePhotoTabButton];
	
	[addMoreSymbolTabButton setBackgroundImage:[UIImage imageNamed:@"symbolicon_button"] forState:UIControlStateNormal];
	[addMoreSymbolTabButton addTarget:self action:@selector(setAddMoreLayerTabAction:) forControlEvents:UIControlEventTouchUpInside];
	addMoreSymbolTabButton.alpha =  ALPHA0;
	addMoreSymbolTabButton.tag = 10003;
	[self.view addSubview:addMoreSymbolTabButton];
    
	[addMoreIconTabButton setBackgroundImage:[UIImage imageNamed:@"icon_button"] forState:UIControlStateNormal];
	[addMoreIconTabButton addTarget:self action:@selector(setAddMoreLayerTabAction:) forControlEvents:UIControlEventTouchUpInside];
	addMoreIconTabButton.alpha =  ALPHA0;
	addMoreIconTabButton.tag = 10004;
	[self.view addSubview:addMoreIconTabButton];
    
	[arrangeLayerTabButton setBackgroundImage:[UIImage imageNamed:@"arrangeicon_button"] forState:UIControlStateNormal];
	[arrangeLayerTabButton addTarget:self action:@selector(setAddMoreLayerTabAction:) forControlEvents:UIControlEventTouchUpInside];
	arrangeLayerTabButton.alpha =  ALPHA0;
	arrangeLayerTabButton.tag = 10005;
	[self.view addSubview:arrangeLayerTabButton];
    
	imgPickerFlag =1;
    selectedAddMoreLayerTab = -1;
	[self chooseTemplate];
}

-(void)addFontsInSubView{
    
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
            if(![self isFontPurchased:i]){
                UIImageView *lock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lock"]];
                lock.frame = CGRectMake(20, 20, 17, 19);
                [font addSubview:lock];
                font.userInteractionEnabled = NO;
            }
        }
        
		[fontScrollView addSubview:font];
		//[font release];
	}
}

-(void)addColorsInSubView{

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
            if(![self isColorPurchased:i]){
                UIImageView *lock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lock"]];
                lock.frame = CGRectMake(20, 20, 17, 19);
                [color addSubview:lock];
                color.userInteractionEnabled = NO;
            }
        }
        
		[colorScrollView addSubview:color];
		//[color release];
	}
}

-(void)addTextBorderInSubView{
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
            ((CustomLabel*)[[self textLabelLayersArray] lastObject]).font = selectedFont;
			//msgLabel.font =selectedFont;
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
            ((CustomLabel*)[[self textLabelLayersArray] lastObject]).textColor = selectedColor;
			//msgLabel.textColor = selectedColor;
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


-(void)selectSymbol:(id)sender
{
    
    [self plusButtonClick];
    
    if([[self symbolLayersArray] count] > 0){
        
        symbolTouchFlag = YES;
        iconTouchFlag = NO;
        photoTouchFlag = NO;
        
        FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
        appDele.changesFlag = YES;
        UIButton *view = sender;
        selectedSymbol  =  [symbolArray objectAtIndex:(view.tag - 1)];
        CATransition *animation = [CATransition animation];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionMoveIn];
        [animation setDuration:0.4f];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
        UIImageView *lastSymbolLayer = [[self symbolLayersArray] lastObject];
        [[lastSymbolLayer  layer] addAnimation:animation forKey:@"SwitchToView1"];
        [lastSymbolLayer setImage:selectedSymbol];
    }
}

-(void)selectIcon:(id)sender
{
    
    [self plusButtonClick];

    if([[self iconLayersArray] count] > 0){
        
        symbolTouchFlag = NO;
        iconTouchFlag = YES;
        photoTouchFlag = NO;
        
        FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
        appDele.changesFlag = YES;
        UIButton *view = sender;
        selectedIcon  =  [iconArray objectAtIndex:(view.tag - 1)];
        CATransition *animation = [CATransition animation];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionMoveIn];
        [animation setDuration:0.4f];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
        UIImageView *lastIconLayer = [[self iconLayersArray] lastObject];
        [[lastIconLayer  layer] addAnimation:animation forKey:@"SwitchToView1"];
        [lastIconLayer setImage:selectedIcon];
    }
}

int arrangeLayerIndex;

-(void)selectLayer:(id)sender {
    
	UIButton *view = sender;
    UIView *superView = [view superview];
    
    // Remove border from layer thumbnail
    for(UIView *subView in [superView subviews]){
        if([subView isKindOfClass:[UIButton class]]){
            CALayer * lastLayer = [subView layer];
            [lastLayer setMasksToBounds:YES];
            [lastLayer setCornerRadius:0];
            [lastLayer setBorderWidth:0];
            [lastLayer setBorderColor:[[UIColor clearColor] CGColor]];
            [lastLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
        }
    }
	
    FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
	appDele.changesFlag = YES;
    
    // Add border to selected layer thumbnail
    CALayer * l = [view layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10];
    [l setBorderWidth:1.0];
    [l setBorderColor:[[UIColor blueColor] CGColor]];

    NSString *tag = [NSString stringWithFormat:@"%d",view.tag];
    
    if([tag hasPrefix:@"111"]){
        symbolTouchFlag = NO;
        iconTouchFlag = NO;
        photoTouchFlag = NO;
        lableTouchFlag = YES;
        
        NSString *str = [tag substringWithRange:NSMakeRange(3, [tag length] - 3)];
        arrangeLayerIndex = [str integerValue];
        
        [self removeBordersFromAllLayers];
        UILabel *tempLabel = [textLabelLayersArray objectAtIndex:arrangeLayerIndex];
        CALayer * l = [tempLabel layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:10];
        [l setBorderWidth:1.0];
        [l setBorderColor:[[UIColor grayColor] CGColor]];
        //[tempLabel setBackgroundColor:[ UIColor colorWithWhite:1 alpha:0.4f]];
        [self.imgView bringSubviewToFront:[[self textLabelLayersArray] objectAtIndex:arrangeLayerIndex]];

        NSLog(@"Text Index: %@", str);
        
    }else if([tag hasPrefix:@"222"]){
        symbolTouchFlag = NO;
        iconTouchFlag = NO;
        photoTouchFlag = YES;
        lableTouchFlag = NO;
        
        NSString *str = [tag substringWithRange:NSMakeRange(3, [tag length] - 3)];
        arrangeLayerIndex = [str integerValue];
        
        [self removeBordersFromAllLayers];
        UIImageView *tempImgView = [photoLayersArray objectAtIndex:arrangeLayerIndex];
        CALayer * l = [tempImgView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:10];
        [l setBorderWidth:1.0];
        [l setBorderColor:[[UIColor grayColor] CGColor]];
        //[tempImgView setBackgroundColor:[ UIColor colorWithWhite:1 alpha:0.4f]];
        [self.imgView bringSubviewToFront:[[self photoLayersArray] objectAtIndex:arrangeLayerIndex]];

        NSLog(@"Photo Index: %@", str);
        
    } else if([tag hasPrefix:@"333"]){
        symbolTouchFlag = YES;
        iconTouchFlag = NO;
        photoTouchFlag = NO;
        lableTouchFlag = NO;

        NSString *str = [tag substringWithRange:NSMakeRange(3, [tag length] - 3)];
        arrangeLayerIndex = [str integerValue];

        [self removeBordersFromAllLayers];
        UIImageView *tempImgView = [symbolLayersArray objectAtIndex:arrangeLayerIndex];
        CALayer * l = [tempImgView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:10];
        [l setBorderWidth:1.0];
        [l setBorderColor:[[UIColor grayColor] CGColor]];
        //[tempImgView setBackgroundColor:[ UIColor colorWithWhite:1 alpha:0.4f]];
        [self.imgView bringSubviewToFront:[[self symbolLayersArray] objectAtIndex:arrangeLayerIndex]];

        NSLog(@"Symbol Index: %@", str);
        
    } else if([tag hasPrefix:@"444"]){
        symbolTouchFlag = NO;
        iconTouchFlag = YES;
        photoTouchFlag = NO;
        lableTouchFlag = NO;

        NSString *str = [tag substringWithRange:NSMakeRange(3, [tag length] - 3)];
        arrangeLayerIndex = [str integerValue];
        
        [self removeBordersFromAllLayers];
        UIImageView *tempImgView = [iconLayersArray objectAtIndex:arrangeLayerIndex];
        CALayer * l = [tempImgView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:10];
        [l setBorderWidth:1.0];
        [l setBorderColor:[[UIColor grayColor] CGColor]];
        //[tempImgView setBackgroundColor:[ UIColor colorWithWhite:1 alpha:0.4f]];
        [self.imgView bringSubviewToFront:[[self iconLayersArray] objectAtIndex:arrangeLayerIndex]];

        NSLog(@"Icon Index: %@", str);
        
    }
    
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
			//msgLabel.font =selectedFont;
            ((CustomLabel*)[[self textLabelLayersArray] lastObject]).font =selectedFont;
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
            
            CustomLabel *lastLabel = [[self textLabelLayersArray] lastObject];
            lastLabel.borderColor = borderColor;
            lastLabel.lineWidth = 2;
            [lastLabel drawRect:CGRectMake(lastLabel.frame.origin.x, lastLabel.frame.origin.y, lastLabel.frame.size.width, lastLabel.frame.size.height)];
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
    
    UIImageView *lastImgView = [[self photoLayersArray] lastObject];
    lastImgView.frame = CGRectMake(lastImgView.frame.origin.x, lastImgView.frame.origin.y,lastImgView.frame.size.width-10,lastImgView.frame.size.height);
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

    UIImageView *lastImgView = [[self photoLayersArray] lastObject];
    lastImgView.frame = CGRectMake(lastImgView.frame.origin.x, lastImgView.frame.origin.y,lastImgView.frame.size.width,lastImgView.frame.size.height-10);
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
                
                //[view addTarget:self action:@selector(selectFont:) forControlEvents:UIControlEventTouchUpInside];
                if(view.userInteractionEnabled){
                    [view addTarget:self action:@selector(selectFont:) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    view.userInteractionEnabled = YES;
                    [view addTarget:self action:@selector(requestFont:) forControlEvents:UIControlEventTouchUpInside];
                }
			
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

                /*if(view.userInteractionEnabled){
                    [view addTarget:self action:@selector(selectColor:) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    view.userInteractionEnabled = YES;
                    [view addTarget:self action:@selector(requestColor:) forControlEvents:UIControlEventTouchUpInside];
                }*/
				
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
                
                if(view.userInteractionEnabled){
                    [view addTarget:self action:@selector(selectFontBorder:) forControlEvents:UIControlEventTouchUpInside];
                 }else{
                     view.userInteractionEnabled = YES;
                     [view addTarget:self action:@selector(requestFontBorder:) forControlEvents:UIControlEventTouchUpInside];
                 }
				
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
    else if (selectedScrollView == symbolScrollView)
	{
		UIButton *view = nil;
		NSArray *subviews = [symbolScrollView subviews];
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
                [view addTarget:self action:@selector(selectSymbol:) forControlEvents:UIControlEventTouchUpInside];
				
                if(IS_IPHONE_5){
                    if(curXLoc >= 320){
                        curXLoc = 0;
                        curYLoc = curYLoc + kScrollObjHeight + 7;
                    }
                }
			}
		}
        
        if(IS_IPHONE_5){
            [symbolScrollView setContentSize:CGSizeMake(320, curYLoc + kScrollObjHeight)];
        } else {
            [symbolScrollView setContentSize:CGSizeMake(([symbolArray count]*(kScrollObjWidth+5)), [symbolScrollView bounds].size.height)];
        }
	}
    else if (selectedScrollView == iconScrollView)
	{
		UIButton *view = nil;
		NSArray *subviews = [iconScrollView subviews];
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
                [view addTarget:self action:@selector(selectIcon:) forControlEvents:UIControlEventTouchUpInside];
				
                if(IS_IPHONE_5){
                    if(curXLoc >= 320){
                        curXLoc = 0;
                        curYLoc = curYLoc + kScrollObjHeight + 7;
                    }
                }
			}
		}
        
        if(IS_IPHONE_5){
            [iconScrollView setContentSize:CGSizeMake(320, curYLoc + kScrollObjHeight)];
        } else {
            [iconScrollView setContentSize:CGSizeMake(([iconArray count]*(kScrollObjWidth+5)), [iconScrollView bounds].size.height)];
        }
	}
    else if (selectedScrollView == layerScrollView)
	{
		UIButton *view = nil;
		NSArray *subviews = [layerScrollView subviews];
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
                [view addTarget:self action:@selector(selectLayer:) forControlEvents:UIControlEventTouchUpInside];
				
                if(IS_IPHONE_5){
                    if(curXLoc >= 320){
                        curXLoc = 0;
                        curYLoc = curYLoc + kScrollObjHeight + 7;
                    }
                }
			}
		}
        
        if(IS_IPHONE_5){
            [layerScrollView setContentSize:CGSizeMake(320, curYLoc + kScrollObjHeight)];
        } else {
            [layerScrollView setContentSize:CGSizeMake(([self getLayerCounts]*(kScrollObjWidth+5)), [layerScrollView bounds].size.height)];
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
		//[self.photoImgView setImage:testImage] ;
        
        UIImageView *lastPhotoLayer = [[self photoLayersArray] lastObject];
        [lastPhotoLayer setImage:testImage];

		photoTouchFlag = YES;
		lableTouchFlag = NO;
        symbolTouchFlag= NO;
        iconTouchFlag = NO;
	}
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
	if(imgPickerFlag == 2){
		photoTouchFlag = YES;
		lableTouchFlag = NO;
        symbolTouchFlag= NO;
        iconTouchFlag = NO;
	}
}

-(void)loadCustomPhotoLibrary{
    
    customPhotoController = [[CustomPhotoController alloc] initWithNibName:@"CustomPhotoController" bundle:nil];
    customPhotoController.callbackObject = self;    
    customPhotoController.callbackOnComplete = @selector(onCompleteSelectingImage:);
    [self setLatestImageAndLoadPhotoLibrary];

    photoTouchFlag = YES;
    lableTouchFlag = NO;
    symbolTouchFlag= NO;
    iconTouchFlag = NO;

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
        symbolTouchFlag= NO;
        iconTouchFlag = NO;
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
		//[self.photoImgView setImage:testImage] ;
        UIImageView *lastPhotoLayer = [[self photoLayersArray] lastObject];
        [lastPhotoLayer setImage:testImage];

		self.photoTouchFlag = YES;
		self.lableTouchFlag = NO;
        symbolTouchFlag= NO;
        iconTouchFlag = NO;
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
        symbolTouchFlag= NO;
        iconTouchFlag = NO;
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
		//[self.photoImgView setImage:testImage] ;
        
        UIImageView *lastPhotoLayer = [[self photoLayersArray] lastObject];
        [lastPhotoLayer setImage:testImage];

		self.photoTouchFlag = YES;
		self.lableTouchFlag = NO;
        symbolTouchFlag= NO;
        iconTouchFlag = NO;
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
    symbolTouchFlag= NO;
    iconTouchFlag = NO;
	imgPickerFlag = 1;
	
    self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Add Background"];
    
    /*UIButton *textButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 29)];
    [textButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [textButton setBackgroundImage:[UIImage imageNamed:@"t_button"] forState:UIControlStateNormal];
	//[textButton addTarget:self action:@selector(callWrite) forControlEvents:UIControlEventTouchUpInside];
	[textButton addTarget:self action:@selector(callAddMoreLayers) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:textButton];
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];*/

    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
	[nextButton addTarget:self action:@selector(callAddMoreLayers) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
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
    
    [self hideAddMoreButton];
    [self showPictureTab];
    [self hideAddMoreTab];


	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4f];
	templateScrollView.alpha = ALPHA1;
	templateBckgrnd.alpha = ALPHA1;
	[self.templateBckgrnd bringSubviewToFront:templateScrollView];
    
    if(IS_IPHONE_5){
        symbolScrollView.frame= CGRectMake(-320, 413,320 ,130);
        iconScrollView.frame= CGRectMake(-320, 413,320 ,130);
        layerScrollView.frame= CGRectMake(-320, 413,320 ,130);

        templateScrollView.frame= CGRectMake(0, 413,320 ,130);
    }else{
        symbolScrollView.frame= CGRectMake(-320, 395,320 ,60);
        iconScrollView.frame= CGRectMake(-320, 395,320 ,60);
        layerScrollView.frame= CGRectMake(-320, 395,320 ,60);

        templateScrollView.frame= CGRectMake(0, 395,320 ,60);
    }
    
	//msgLabel.alpha= 1;
    ((CustomLabel *)[[self textLabelLayersArray] lastObject]).alpha = 1;
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
-(void)hideAddMoreButton{
    [self.moreLayersButton setHidden:YES];
    [self.moreLayersLabel setHidden:YES];
}
-(void)showAddMoreButton{
    [self.moreLayersButton setHidden:NO];
    [self.moreLayersLabel setHidden:NO];
}
-(void)hideAddMoreTab{
    [self.addMoreFontTabButton setHidden:YES];
    [self.addMorePhotoTabButton setHidden:YES];
    [self.addMoreSymbolTabButton setHidden:YES];
    [self.addMoreIconTabButton setHidden:YES];
    [self.arrangeLayerTabButton setHidden:YES];
}
-(void)showAddMoreTab{
    [self.addMoreFontTabButton setHidden:NO];
    [self.addMorePhotoTabButton setHidden:NO];
    [self.addMoreSymbolTabButton setHidden:NO];
    [self.addMoreIconTabButton setHidden:NO];
    [self.arrangeLayerTabButton setHidden:NO];
}

-(void)cancelLayer{

    if(selectedAddMoreLayerTab == ADD_MORE_TEXT_TAB){
        
        textLayerCount--;
        
        [msgTextView resignFirstResponder];
        [msgTextView removeFromSuperview];

        [textLabelLayersArray removeLastObject];
    
    } else if(selectedAddMoreLayerTab == ADD_MORE_PHOTO_TAB){
        
        photoLayerCount--;
        
        CALayer * lastLayer = [[[self photoLayersArray] lastObject] layer];
        [lastLayer setMasksToBounds:YES];
        [lastLayer setCornerRadius:0];
        [lastLayer setBorderWidth:0];
        [lastLayer setBorderColor:[[UIColor clearColor] CGColor]];

        [photoLayersArray removeLastObject];

    } else if(selectedAddMoreLayerTab == ADD_MORE_SYMBOL_TAB){
        [symbolLayersArray removeLastObject];
    } else if(selectedAddMoreLayerTab == ADD_MORE_ICON_TAB){
        [iconLayersArray removeLastObject];
    }
    
    [self callAddMoreLayers];
}

-(void)callWrite{
	photoTouchFlag=NO;
	lableTouchFlag=NO;
    symbolTouchFlag= NO;
    iconTouchFlag = NO;

    self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Add Text"];

    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
	[nextButton addTarget:self action:@selector(callStyle) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
	//[backButton addTarget:self action:@selector(chooseTemplate) forControlEvents:UIControlEventTouchUpInside];
	[backButton addTarget:self action:@selector(cancelLayer) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];

    [self hidePictureTab];
    [self hideAddMoreButton];
    [self hideAddMoreTab];

    UITextView *lastTextView = msgTextView;
	lastTextView.font = [UIFont fontWithName:@"Arial" size:16];
	lastTextView.textColor = [UIColor blackColor];

    CustomLabel *lastLabelView = [[self textLabelLayersArray]lastObject];

	lastTextView.backgroundColor = [ UIColor colorWithWhite:1 alpha:0.3f];
	lastLabelView.alpha =ALPHA0;
 	lastTextView.text = lastLabelView.text ;
	[NSTimer scheduledTimerWithTimeInterval:0.001f target:self selector:@selector(callKeyboard) userInfo:nil repeats:NO];
	
	CALayer * l = [lastTextView layer];
	[l setMasksToBounds:YES];
	[l setCornerRadius:10];
	[l setBorderWidth:1.0];
	[l setBorderColor:[[UIColor grayColor] CGColor]];
	[self.view addSubview:lastTextView];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4f];
	lastTextView.frame = CGRectMake(20, 50, 280, 150);
	templateBckgrnd.alpha = ALPHA0;

    if(IS_IPHONE_5){
        templateScrollView.frame= CGRectMake(-320, 413,320 ,130);
        fontScrollView.frame = CGRectMake(-320, 385, 320, 130);
        colorScrollView.frame = CGRectMake(-320, 385, 320, 130);
        sizeScrollView.frame = CGRectMake(-320, 385, 320, 130);
        borderScrollView.frame = CGRectMake(-320, 385, 320, 130);
        fontBorderScrollView.frame = CGRectMake(-320, 385, 320, 130);
        symbolScrollView.frame= CGRectMake(-320, 413,320 ,130);
        iconScrollView.frame= CGRectMake(-320, 413,320 ,130);
        layerScrollView.frame= CGRectMake(-320, 413,320 ,130);
    }else{
        templateScrollView.frame= CGRectMake(-320, 395,320 ,60);
        fontScrollView.frame = CGRectMake(-320, 385, 320, 44);
        colorScrollView.frame = CGRectMake(-320, 385, 320, 44);
        sizeScrollView.frame = CGRectMake(-320, 385, 320, 44);
        borderScrollView.frame = CGRectMake(-320, 385, 320, 44);
        fontBorderScrollView.frame = CGRectMake(-320, 385, 320, 44);
        symbolScrollView.frame= CGRectMake(-320, 395,320 ,60);
        iconScrollView.frame= CGRectMake(-320, 395,320 ,60);
        layerScrollView.frame= CGRectMake(-320, 395,320 ,60);
    }
	[UIView commitAnimations];

}

-(void)callStyle
{

    self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Add Text"];

    if(selectedAddMoreLayerTab == -1){
        UIButton *photoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        [photoButton addTarget:self action:@selector(choosePhoto) forControlEvents:UIControlEventTouchUpInside];
        [photoButton setBackgroundImage:[UIImage imageNamed:@"photo_button"] forState:UIControlStateNormal];
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:photoButton];
        [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];
    } else {
        UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        doneButton.titleLabel.font = [UIFont fontWithName:@"Signika-Semibold" size:13];
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(callAddMoreLayers) forControlEvents:UIControlEventTouchUpInside];
        [doneButton setBackgroundImage:[UIImage imageNamed:@"crop_button"] forState:UIControlStateNormal];
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
        [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];
    }
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [backButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	[backButton addTarget:self action:@selector(callWrite) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];

    [self hidePictureTab];
    [self hideAddMoreButton];

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
    [colorTabButton setBackgroundImage:[UIImage imageNamed:@"color_button"] forState:UIControlStateNormal];
    [sizeTabButton setBackgroundImage:[UIImage imageNamed:@"size_button"] forState:UIControlStateNormal];
    [borderTabButton setBackgroundImage:[UIImage imageNamed:@"outline_button"] forState:UIControlStateNormal];
    [fontBorderTabButton setBackgroundImage:[UIImage imageNamed:@"background_button"] forState:UIControlStateNormal];
	fontTabButton.alpha = ALPHA1;
	colorTabButton.alpha = ALPHA1;
	sizeTabButton.alpha = ALPHA1;
	borderTabButton.alpha = ALPHA1;
	fontBorderTabButton.alpha = ALPHA1;
    
    UITextView *lastTextView = msgTextView;
    CustomLabel *lastLabelView = [[self textLabelLayersArray]lastObject];
	lastLabelView.alpha=1;
	
	
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
	
	[lastTextView setTextColor:selectedColor];
	[lastLabelView setTextColor:selectedColor];
	CALayer * l = [lastTextView layer];
	[l setMasksToBounds:YES];
	[l setCornerRadius:0];
	[l setBorderWidth:0];
	[l setBorderColor:[[UIColor clearColor] CGColor]];
	selectedText = lastTextView.text;
	
	//msgLabel.frame = CGRectMake(lableLocation.x,lableLocation.y,msgLabel.frame.size.width, msgTextView.contentSize.height);
	lableLocation = CGPointMake(160,100);
	lastLabelView.center = lableLocation;
	lastLabelView.numberOfLines = 40;
	lastLabelView.text = lastTextView.text;
	[lastTextView resignFirstResponder];
	[lastTextView removeFromSuperview];
    
	lableTouchFlag = YES;
	photoTouchFlag = NO;
    symbolTouchFlag= NO;
    iconTouchFlag = NO;

}

-(void)choosePhoto
{

    //selectedAddMoreLayerTab = -1;
    self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Add photo"];

    if(selectedAddMoreLayerTab == -1){
        UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        shareButton.titleLabel.font = [UIFont fontWithName:@"Signika-Semibold" size:13];
        [shareButton setTitle:@"Save" forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(callSaveAndShare) forControlEvents:UIControlEventTouchUpInside];
        [shareButton setBackgroundImage:[UIImage imageNamed:@"crop_button"] forState:UIControlStateNormal];
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
        [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];
    } else {
        UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        doneButton.titleLabel.font = [UIFont fontWithName:@"Signika-Semibold" size:13];
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(callAddMoreLayers) forControlEvents:UIControlEventTouchUpInside];
        [doneButton setBackgroundImage:[UIImage imageNamed:@"crop_button"] forState:UIControlStateNormal];
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
        [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];
    }

    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [backButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	//[backButton addTarget:self action:@selector(callStyle) forControlEvents:UIControlEventTouchUpInside];
	[backButton addTarget:self action:@selector(cancelLayer) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];

    [self hidePictureTab];
    //[self showAddMoreButton];
    [self hideAddMoreButton];
    [self hideAddMoreTab];

    CALayer * l = [[[self  photoLayersArray] lastObject] layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10];
    [l setBorderWidth:1.0];
    [l setBorderColor:[[UIColor grayColor] CGColor]];
    [self.imgView addSubview:[[self  photoLayersArray] lastObject]];

	/*CALayer * l = [photoImgView layer];
	[l setMasksToBounds:YES];
	[l setCornerRadius:10];
	[l setBorderWidth:1.0];
	[l setBorderColor:[[UIColor grayColor] CGColor]];
	//[photoImgView setBackgroundColor:[ UIColor colorWithWhite:1 alpha:0.4f]];
	[self.imgView addSubview:photoImgView];*/
	
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
        symbolScrollView.frame = CGRectMake(-320, 385, 320, 130);
        iconScrollView.frame = CGRectMake(-320, 385, 320, 130);
        layerScrollView.frame = CGRectMake(-320, 385, 320, 130);
    }else{
        fontScrollView.frame = CGRectMake(-320, 385, 320, 44);
        colorScrollView.frame = CGRectMake(-320, 385, 320, 44);
        sizeScrollView.frame = CGRectMake(-320, 385, 320, 44);
        borderScrollView.frame = CGRectMake(-320, 385, 320, 44);
        fontBorderScrollView.frame = CGRectMake(-320, 385, 320, 44);
        symbolScrollView.frame = CGRectMake(-320, 385, 320, 60);
        iconScrollView.frame = CGRectMake(-320, 385, 320, 60);
        layerScrollView.frame = CGRectMake(-320, 385, 320, 60);
    }

	//msgLabel.alpha=1;
    ((CustomLabel *)[[self textLabelLayersArray] lastObject]).alpha = 1;
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
    symbolTouchFlag= NO;
    iconTouchFlag = NO;
	//[self.imgView sendSubviewToBack:photoImgView];
    [self.imgView sendSubviewToBack:[[self  photoLayersArray] lastObject]];
	[self.imgView bringSubviewToFront:[[self textLabelLayersArray] lastObject]];
}

-(void)callAddMoreLayers {
    
    self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Add layers"];
    [self showAddMoreTab];
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    saveButton.titleLabel.font = [UIFont fontWithName:@"Signika-Semibold" size:13];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
	[saveButton addTarget:self action:@selector(callSaveAndShare) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"crop_button"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:saveButton];

    UIButton *plusButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 30)];
    [plusButton setBackgroundImage:[UIImage imageNamed:@"plus_button"] forState:UIControlStateNormal];
	[plusButton addTarget:self action:@selector(plusButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightPlusBarButton = [[UIBarButtonItem alloc] initWithCustomView:plusButton];

    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [backButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	//[backButton addTarget:self action:@selector(choosePhoto) forControlEvents:UIControlEventTouchUpInside];
	[backButton addTarget:self action:@selector(chooseTemplate) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    
    [self hidePictureTab];
    [self hideAddMoreButton];
    
    /*
	CALayer * l = [photoImgView layer];
	[l setMasksToBounds:YES];
	[l setCornerRadius:10];
	[l setBorderWidth:1.0];
	[l setBorderColor:[[UIColor grayColor] CGColor]];
	[photoImgView setBackgroundColor:[ UIColor colorWithWhite:1 alpha:0.4f]];
	[self.imgView addSubview:photoImgView];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4f];
    */

    if(IS_IPHONE_5){
        templateScrollView.frame= CGRectMake(-320, 413,320 ,130);
        fontScrollView.frame = CGRectMake(-320, 385, 320, 130);
        colorScrollView.frame = CGRectMake(-320, 385, 320, 130);
        sizeScrollView.frame = CGRectMake(-320, 385, 320, 130);
        borderScrollView.frame = CGRectMake(-320, 385, 320, 130);
        fontBorderScrollView.frame = CGRectMake(-320, 385, 320, 130);
        symbolScrollView.frame= CGRectMake(-320, 413,320 ,130);
        iconScrollView.frame= CGRectMake(-320, 413,320 ,130);
        layerScrollView.frame = CGRectMake(-320, 344, 320, 130);
    }else{
        templateScrollView.frame= CGRectMake(-320, 395,320 ,60);
        fontScrollView.frame = CGRectMake(-320, 385, 320, 44);
        colorScrollView.frame = CGRectMake(-320, 385, 320, 44);
        sizeScrollView.frame = CGRectMake(-320, 385, 320, 44);
        borderScrollView.frame = CGRectMake(-320, 385, 320, 44);
        fontBorderScrollView.frame = CGRectMake(-320, 385, 320, 44);
        symbolScrollView.frame= CGRectMake(-320, 395,320 ,60);
        iconScrollView.frame= CGRectMake(-320, 395,320 ,60);
        layerScrollView.frame = CGRectMake(-320, 350, 320, 60);
    }
    templateBckgrnd.alpha = ALPHA0;
    
    if(IS_IPHONE_5){
        symbolScrollView.frame = CGRectMake(0, 357, 320, 130);
        iconScrollView.frame = CGRectMake(0, 357, 320, 130);
    }else{
        symbolScrollView.frame = CGRectMake(0, 350, 320, 60);
        iconScrollView.frame = CGRectMake(0, 350, 320, 60);
    }

	[addMoreFontTabButton setBackgroundImage:[UIImage imageNamed:@"text_icon"] forState:UIControlStateNormal];
	[addMorePhotoTabButton setBackgroundImage:[UIImage imageNamed:@"image_icon"] forState:UIControlStateNormal];
	[addMoreSymbolTabButton setBackgroundImage:[UIImage imageNamed:@"symbolicon_button"] forState:UIControlStateNormal];
	[addMoreIconTabButton setBackgroundImage:[UIImage imageNamed:@"icon_button"] forState:UIControlStateNormal];
	[arrangeLayerTabButton setBackgroundImage:[UIImage imageNamed:@"arrangeicon_button"] forState:UIControlStateNormal];
    
	//msgLabel.alpha=1;
    ((CustomLabel *)[[self textLabelLayersArray] lastObject]).alpha = 1;
    photoImgView.alpha=0;
    symbolImgView.alpha = 0;
    iconImgView.alpha = 0;
	fontTabButton.alpha = ALPHA0;
	colorTabButton.alpha = ALPHA0;
	sizeTabButton.alpha = ALPHA0;
	borderTabButton.alpha = ALPHA0;
	fontBorderTabButton.alpha = ALPHA0;
	cameraTabButton.alpha = ALPHA0;
	photoTabButton.alpha = ALPHA0;
	widthTabButton.alpha = ALPHA0;
	heightTabButton.alpha = ALPHA0;
	textBackgrnd.alpha = ALPHA0;

    addMoreFontTabButton.alpha = ALPHA1;
	addMorePhotoTabButton.alpha = ALPHA1;
	addMoreSymbolTabButton.alpha = ALPHA1;
	addMoreIconTabButton.alpha = ALPHA1;
	arrangeLayerTabButton.alpha = ALPHA1;

    selectedAddMoreLayerTab = ADD_MORE_TEXT_TAB;

    [UIView commitAnimations];
    
}

CGRect initialBounds;

- (void)twoFingerPinch:(UIPinchGestureRecognizer *)gestureRecognizer
{
    //NSLog(@"Pinch scale: %f", gestureRecognizer.scale);
    
    UIImageView *lastImgView = [[self photoLayersArray] lastObject];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        initialBounds = lastImgView.bounds;
    }
    CGFloat factor = [(UIPinchGestureRecognizer *)gestureRecognizer scale];
    
    CGAffineTransform zt;
    
    if([widthTabButton isSelected]){
        zt = CGAffineTransformScale(CGAffineTransformIdentity, factor, 1);
    } else if([heightTabButton isSelected]){
        zt = CGAffineTransformScale(CGAffineTransformIdentity, 1, factor);
    }

    lastImgView.bounds = CGRectApplyAffineTransform(initialBounds, zt);
}

CGPoint CGPointDistance(CGPoint point1, CGPoint point2)
{
    return CGPointMake(point2.x - point1.x, point2.y - point1.y);
};


-(void)callSaveAndShare
{
    [self removeBordersFromAllLayers];

	lableTouchFlag = NO;
	photoTouchFlag = NO;
    symbolTouchFlag= NO;
    iconTouchFlag = NO;
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
    [self hideAddMoreButton];

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
	//msgLabel.alpha=1;
    ((CustomLabel *)[[self textLabelLayersArray] lastObject]).alpha = 1;

    FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
    NSData *data = [self getCurrentFrameAndSaveIt];
    [self showHUD];
    appDele.changesFlag = NO;
    
    DraftViewController *draftViewController = [[DraftViewController alloc] initWithNibName:@"DraftViewController" bundle:nil];
    draftViewController.fromPhotoController = YES;
    draftViewController.selectedFlyerImage = [UIImage imageWithData:data];
    draftViewController.selectedFlyerTitle = @"";
    
    if([[self textLabelLayersArray] count] > 0){
        draftViewController.selectedFlyerDescription = ((CustomLabel*)[[self textLabelLayersArray] objectAtIndex:0]).text;
    }else{
        draftViewController.selectedFlyerDescription = @"";
    }

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

-(void) setAddMoreLayerTabAction:(id) sender {
    
	UIButton *selectedButton = (UIButton*)sender;
	if(selectedButton == addMoreFontTabButton)
	{
        self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Add layers"];
        selectedAddMoreLayerTab = ADD_MORE_TEXT_TAB;

        symbolTouchFlag= NO;
        photoTouchFlag = NO;
        iconTouchFlag = NO;
        lableTouchFlag = YES;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4f];

        [addMoreFontTabButton setBackgroundImage:[UIImage imageNamed:@"text_icon"] forState:UIControlStateNormal];
        [addMorePhotoTabButton setBackgroundImage:[UIImage imageNamed:@"image_icon"] forState:UIControlStateNormal];
        [addMoreSymbolTabButton setBackgroundImage:[UIImage imageNamed:@"symbolicon_button"] forState:UIControlStateNormal];
        [addMoreIconTabButton setBackgroundImage:[UIImage imageNamed:@"icon_button"] forState:UIControlStateNormal];
        [arrangeLayerTabButton setBackgroundImage:[UIImage imageNamed:@"arrangeicon_button"] forState:UIControlStateNormal];

        [UIView commitAnimations];
        
        [self plusButtonClick];
	}
	else if(selectedButton == addMorePhotoTabButton)
	{
        self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Add layers"];
        selectedAddMoreLayerTab = ADD_MORE_PHOTO_TAB;

        symbolTouchFlag= NO;
        iconTouchFlag = NO;
        photoTouchFlag = YES;
        lableTouchFlag = NO;
		imgPickerFlag =2;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4f];
        
        /*CALayer * l = [[[self  photoLayersArray] lastObject] layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:10];
        [l setBorderWidth:1.0];
        [l setBorderColor:[[UIColor grayColor] CGColor]];
        [self.imgView addSubview:[[self  photoLayersArray] lastObject]];*/
                
		textBackgrnd.alpha = ALPHA0;

        [addMoreFontTabButton setBackgroundImage:[UIImage imageNamed:@"text_icon"] forState:UIControlStateNormal];
        [addMorePhotoTabButton setBackgroundImage:[UIImage imageNamed:@"image_icon"] forState:UIControlStateNormal];
        [addMoreSymbolTabButton setBackgroundImage:[UIImage imageNamed:@"symbolicon_button"] forState:UIControlStateNormal];
        [addMoreIconTabButton setBackgroundImage:[UIImage imageNamed:@"icon_button"] forState:UIControlStateNormal];
        [arrangeLayerTabButton setBackgroundImage:[UIImage imageNamed:@"arrangeicon_button"] forState:UIControlStateNormal];

		[UIView commitAnimations];
        
        [self plusButtonClick];

		//[self loadCustomPhotoLibrary];
	}
	else if(selectedButton == addMoreSymbolTabButton)
	{
        self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Add layers"];
        selectedAddMoreLayerTab = ADD_MORE_SYMBOL_TAB;

        symbolTouchFlag= YES;
        photoTouchFlag= NO;
        lableTouchFlag = NO;
        iconTouchFlag = NO;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4f];
        
        /*CALayer * l = [[[self  symbolLayersArray] lastObject] layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:10];
        [l setBorderWidth:1.0];
        [l setBorderColor:[[UIColor grayColor] CGColor]];
        [[[self  symbolLayersArray] lastObject] setBackgroundColor:[ UIColor colorWithWhite:1 alpha:0.4f]];
        [self.imgView addSubview:[[self  symbolLayersArray] lastObject]];*/

		[symbolScrollView setAlpha:ALPHA1];
		[iconScrollView setAlpha:ALPHA0];
		[layerScrollView setAlpha:ALPHA0];

        [addMoreFontTabButton setBackgroundImage:[UIImage imageNamed:@"text_icon"] forState:UIControlStateNormal];
        [addMorePhotoTabButton setBackgroundImage:[UIImage imageNamed:@"image_icon"] forState:UIControlStateNormal];
        [addMoreSymbolTabButton setBackgroundImage:[UIImage imageNamed:@"symbolicon_button"] forState:UIControlStateNormal];
        [addMoreIconTabButton setBackgroundImage:[UIImage imageNamed:@"icon_button"] forState:UIControlStateNormal];
        [arrangeLayerTabButton setBackgroundImage:[UIImage imageNamed:@"arrangeicon_button"] forState:UIControlStateNormal];

		[UIView commitAnimations];
	}
	else if(selectedButton == addMoreIconTabButton)
	{
        self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Add layers"];
        selectedAddMoreLayerTab = ADD_MORE_ICON_TAB;

        lableTouchFlag = NO;
        symbolTouchFlag= NO;
        iconTouchFlag = YES;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4f];
        
        /*CALayer * l = [iconImgView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:10];
        [l setBorderWidth:1.0];
        [l setBorderColor:[[UIColor grayColor] CGColor]];
        [[[self  iconLayersArray] lastObject] setBackgroundColor:[ UIColor colorWithWhite:1 alpha:0.4f]];
        [self.imgView addSubview:[[self  iconLayersArray] lastObject]];*/

		[symbolScrollView setAlpha:ALPHA0];
		[iconScrollView setAlpha:ALPHA1];
        [layerScrollView setAlpha:ALPHA0];

        [addMoreFontTabButton setBackgroundImage:[UIImage imageNamed:@"text_icon"] forState:UIControlStateNormal];
        [addMorePhotoTabButton setBackgroundImage:[UIImage imageNamed:@"image_icon"] forState:UIControlStateNormal];
        [addMoreSymbolTabButton setBackgroundImage:[UIImage imageNamed:@"symbolicon_button"] forState:UIControlStateNormal];
        [addMoreIconTabButton setBackgroundImage:[UIImage imageNamed:@"icon_button"] forState:UIControlStateNormal];
        [arrangeLayerTabButton setBackgroundImage:[UIImage imageNamed:@"arrangeicon_button"] forState:UIControlStateNormal];
        
		[UIView commitAnimations];
	}
	else if(selectedButton == arrangeLayerTabButton)
	{

        self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Arrange layers"];
        selectedAddMoreLayerTab = ARRANGE_LAYER_TAB;
        [self removeBordersFromAllLayers];

        lableTouchFlag = NO;
        symbolTouchFlag= NO;
        iconTouchFlag = NO;
        photoTouchFlag = NO;
        layerScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385,320,44)];

        NSInteger layerScrollWidth = 60;
        NSInteger layerScrollHeight = 55;
        
        //if(IS_IPHONE_5){
        //    layerScrollWidth = 35;
        //    layerScrollHeight = 35;
        //}

        if(textLabelLayersArray){
            NSLog(@"Text Layers %d", [textLabelLayersArray count]);

            for(int text=0; text<[textLabelLayersArray count]; text++){
                
                UILabel *label1 = (UILabel *) [textLabelLayersArray objectAtIndex:text];
                UILabel *label = [[UILabel alloc] initWithFrame:label1.frame];
                label.text = label1.text;
                
                UIButton *layerButton = [UIButton  buttonWithType:UIButtonTypeCustom];
                layerButton.frame =CGRectMake(0, 5,layerScrollWidth, layerScrollHeight);
                [layerButton setBackgroundColor:[UIColor whiteColor]];
                
                label.frame  = CGRectMake(layerButton.frame.origin.x+5, layerButton.frame.origin.y-2, layerButton.frame.size.width-10, layerButton.frame.size.height-7);
                [layerButton addSubview:label];
                layerButton.tag = [[NSString stringWithFormat:@"%@%d",@"111",text] integerValue];
                
                NSLog(@"%d", layerButton.tag);
                
                [layerScrollView addSubview:layerButton];
            }
        }

        if(photoLayersArray){
            NSLog(@"Photo Layers %d", [photoLayersArray count]);
            
            for(int photo=0; photo<[photoLayersArray count]; photo++){
                
                UIImageView *img1 = (UIImageView *) [photoLayersArray objectAtIndex:photo];
                UIImageView *img = [[UIImageView alloc] initWithImage:img1.image];
                
                UIButton *layerButton = [UIButton  buttonWithType:UIButtonTypeCustom];
                layerButton.frame =CGRectMake(0, 5,layerScrollWidth, layerScrollHeight);
                [layerButton setBackgroundColor:[UIColor whiteColor]];
                
                img.frame  = CGRectMake(layerButton.frame.origin.x+5, layerButton.frame.origin.y-2, layerButton.frame.size.width-10, layerButton.frame.size.height-7);
                [layerButton addSubview:img];
                layerButton.tag = [[NSString stringWithFormat:@"%@%d",@"222",photo] integerValue];
                [layerScrollView addSubview:layerButton];
            }
        }
        if(symbolLayersArray){
            NSLog(@"Symbol Layers %d", [symbolLayersArray count]);
            for(int symbol=0; symbol<[symbolLayersArray count]; symbol++){
                
                UIImageView *img1 = (UIImageView *) [symbolLayersArray objectAtIndex:symbol];
                UIImageView *img = [[UIImageView alloc] initWithImage:img1.image];
                
                UIButton *layerButton = [UIButton  buttonWithType:UIButtonTypeCustom];
                layerButton.frame =CGRectMake(0, 5,layerScrollWidth, layerScrollHeight);
                [layerButton setBackgroundColor:[UIColor whiteColor]];
                
                img.frame  = CGRectMake(layerButton.frame.origin.x+5, layerButton.frame.origin.y-2, layerButton.frame.size.width-10, layerButton.frame.size.height-7);
                [layerButton addSubview:img];
                layerButton.tag = [[NSString stringWithFormat:@"%@%d",@"333",symbol] integerValue];
                [layerScrollView addSubview:layerButton];
            }
        }
        if(iconLayersArray){
            NSLog(@"Icon Layers %d", [iconLayersArray count]);
            for(int icon=0; icon<[iconLayersArray count]; icon++){
                
                UIImageView *img1 = (UIImageView *) [iconLayersArray objectAtIndex:icon];
                UIImageView *img = [[UIImageView alloc] initWithImage:img1.image];
                
                UIButton *layerButton = [UIButton  buttonWithType:UIButtonTypeCustom];
                layerButton.frame =CGRectMake(0, 5,layerScrollWidth, layerScrollHeight);
                [layerButton setBackgroundColor:[UIColor whiteColor]];
                
                img.frame  = CGRectMake(layerButton.frame.origin.x+5, layerButton.frame.origin.y-2, layerButton.frame.size.width-10, layerButton.frame.size.height-7);
                [layerButton addSubview:img];
                layerButton.tag = [[NSString stringWithFormat:@"%@%d",@"444",icon] integerValue];
                [layerScrollView addSubview:layerButton];
            }
        }

        if(IS_IPHONE_5){
            layerScrollView.frame = CGRectMake(0, 357, 320, 130);
        }else{
            layerScrollView.frame = CGRectMake(0, 350, 320, 60);
        }
        
        [layerScrollView setCanCancelContentTouches:NO];
        layerScrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        layerScrollView.clipsToBounds = YES;
        layerScrollView.scrollEnabled = YES;
        layerScrollView.pagingEnabled = NO;
        layerScrollView.showsHorizontalScrollIndicator = NO;
        layerScrollView.showsVerticalScrollIndicator = NO;
        layerScrollView.alpha = ALPHA0;
        [self.view addSubview:layerScrollView];
        [self layoutScrollImages:layerScrollView scrollWidth:layerScrollWidth scrollHeight:layerScrollHeight];

        [symbolScrollView setAlpha:ALPHA0];
		[iconScrollView setAlpha:ALPHA0];
		[layerScrollView setAlpha:ALPHA1];
	}
}

UIScrollView *layerScrollView = nil;

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

-(NSMutableArray *)photoLayersArray{
    
    if(photoLayersArray){
        return photoLayersArray;
    } else {
        
        photoLayersArray = [[NSMutableArray alloc] init];
        return photoLayersArray;
    }
}

-(NSMutableArray *)symbolLayersArray{

    if(symbolLayersArray){
        return symbolLayersArray;
    } else {
    
        symbolLayersArray = [[NSMutableArray alloc] init];
        //[symbolLayersArray addObject:symbolImgView];
        return symbolLayersArray;
    }
}

-(NSMutableArray *)iconLayersArray{
    
    if(iconLayersArray){
        return iconLayersArray;
    } else {
        
        iconLayersArray = [[NSMutableArray alloc] init];
        //[iconLayersArray addObject:iconImgView];
        return iconLayersArray;
    }
}

/*-(NSMutableArray *)textEditLayersArray{
    
    if(textEditLayersArray){
        return textEditLayersArray;
    } else {
        
        textEditLayersArray = [[NSMutableArray alloc] init];
        return textEditLayersArray;
    }
}*/

-(NSMutableArray *)textLabelLayersArray{
    
    if(textLabelLayersArray){
        return textLabelLayersArray;
    } else {
        
        textLabelLayersArray = [[NSMutableArray alloc] init];
        return textLabelLayersArray;
    }
}

-(BOOL)canAddMoreLayers{

    if([self getLayerCounts] < 10){
        return YES;
    } else {
        return NO;
    }
}

-(int)getLayerCounts{
 
    int layerCounts = 0;
    
    if(textLabelLayersArray){
        layerCounts = layerCounts + [textLabelLayersArray count];
    }
    if(photoLayersArray){
        layerCounts = layerCounts + [photoLayersArray count];
    }
    if(symbolLayersArray){
        layerCounts = layerCounts + [symbolLayersArray count];
    }
    if(iconLayersArray){
        layerCounts = layerCounts + [iconLayersArray count];
    }
    
    return layerCounts;
}

-(void)plusButtonClick{
    
    if([self canAddMoreLayers]){
        if(selectedAddMoreLayerTab == ADD_MORE_TEXT_TAB){
            
            /*UITextView *newMsgTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 50, 280, 150)];
             newMsgTextView.delegate = self;
             newMsgTextView.font = [UIFont fontWithName:@"Arial" size:16];
             newMsgTextView.textColor = [UIColor blackColor];
             newMsgTextView.textAlignment = UITextAlignmentCenter;
             [[self textEditLayersArray] addObject:newMsgTextView];*/
            
            CustomLabel *newMsgLabel = [[CustomLabel alloc]initWithFrame:CGRectMake(0, 30, 320, 500)];
            newMsgLabel.backgroundColor = [UIColor clearColor];
            newMsgLabel.textColor = [UIColor blackColor];
            newMsgLabel.textAlignment = UITextAlignmentCenter;
            [self.imgView addSubview:newMsgLabel];
            [[self textLabelLayersArray] addObject:newMsgLabel];
            
            [self callWrite];
            
        } else if(selectedAddMoreLayerTab == ADD_MORE_SYMBOL_TAB){
            
            CALayer * lastLayer = [[[self symbolLayersArray] lastObject] layer];
            [lastLayer setMasksToBounds:YES];
            [lastLayer setCornerRadius:0];
            [lastLayer setBorderWidth:0];
            [lastLayer setBorderColor:[[UIColor clearColor] CGColor]];
            
            UIImageView *newSymbolImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 90, 70)];
            newSymbolImgView.tag = symbolLayerCount++;
            
            CALayer * l = [newSymbolImgView layer];
            [l setMasksToBounds:YES];
            [l setCornerRadius:10];
            [l setBorderWidth:1.0];
            [l setBorderColor:[[UIColor grayColor] CGColor]];
            //[newSymbolImgView setBackgroundColor:[ UIColor colorWithWhite:1 alpha:0.4f]];
            [self.imgView addSubview:newSymbolImgView];
            
            [[self symbolLayersArray] addObject:newSymbolImgView];
            
        } else if(selectedAddMoreLayerTab == ADD_MORE_ICON_TAB){
            
            CALayer * lastLayer = [[[self iconLayersArray] lastObject] layer];
            [lastLayer setMasksToBounds:YES];
            [lastLayer setCornerRadius:0];
            [lastLayer setBorderWidth:0];
            [lastLayer setBorderColor:[[UIColor clearColor] CGColor]];
            
            UIImageView *newIconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 90, 70)];
            newIconImgView.tag = iconLayerCount++;
            
            CALayer * l = [newIconImgView layer];
            [l setMasksToBounds:YES];
            [l setCornerRadius:10];
            [l setBorderWidth:1.0];
            [l setBorderColor:[[UIColor grayColor] CGColor]];
            //[newIconImgView setBackgroundColor:[ UIColor colorWithWhite:1 alpha:0.4f]];
            [self.imgView addSubview:newIconImgView];
            
            [[self iconLayersArray] addObject:newIconImgView];
            
        } else if(selectedAddMoreLayerTab == ADD_MORE_PHOTO_TAB){
            
            photoTouchFlag = YES;
            
            CALayer * lastLayer = [[[self photoLayersArray] lastObject] layer];
            [lastLayer setMasksToBounds:YES];
            [lastLayer setCornerRadius:0];
            [lastLayer setBorderWidth:0];
            [lastLayer setBorderColor:[[UIColor clearColor] CGColor]];
            
            UIImageView *newPhotoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 220, 200)];
            newPhotoImgView.tag = photoLayerCount++;
            
            CALayer * l = [newPhotoImgView layer];
            [l setMasksToBounds:YES];
            [l setCornerRadius:10];
            [l setBorderWidth:1.0];
            [l setBorderColor:[[UIColor grayColor] CGColor]];
            //[newPhotoImgView setBackgroundColor:[ UIColor colorWithWhite:1 alpha:0.4f]];
            [self.imgView addSubview:newPhotoImgView];
            
            [[self photoLayersArray] addObject:newPhotoImgView];
            
            [self choosePhoto];
        }
    
    } else {

        warningAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Cannot add more than 10 layers." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ,nil];
		[warningAlert show];

    }
}

-(void)removeBordersFromAllLayers{

    for(int text=0; text<[textLabelLayersArray count]; text++){
        
        CALayer * lastLayer = [[textLabelLayersArray objectAtIndex:text] layer];
        [lastLayer setMasksToBounds:YES];
        [lastLayer setCornerRadius:0];
        [lastLayer setBorderWidth:0];
        [lastLayer setBorderColor:[[UIColor clearColor] CGColor]];
        [lastLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    }
    
    for(int photo=0; photo<[photoLayersArray count]; photo++){
        
        CALayer * lastLayer = [[photoLayersArray objectAtIndex:photo] layer];
        [lastLayer setMasksToBounds:YES];
        [lastLayer setCornerRadius:0];
        [lastLayer setBorderWidth:0];
        [lastLayer setBorderColor:[[UIColor clearColor] CGColor]];
    }

    for(int symbol=0; symbol<[symbolLayersArray count]; symbol++){
        
        CALayer * lastLayer = [[symbolLayersArray objectAtIndex:symbol] layer];
        [lastLayer setMasksToBounds:YES];
        [lastLayer setCornerRadius:0];
        [lastLayer setBorderWidth:0];
        [lastLayer setBorderColor:[[UIColor clearColor] CGColor]];
    }
    
    for(int icon=0; icon<[iconLayersArray count]; icon++){
        
        CALayer * lastLayer = [[iconLayersArray objectAtIndex:icon] layer];
        [lastLayer setMasksToBounds:YES];
        [lastLayer setCornerRadius:0];
        [lastLayer setBorderWidth:0];
        [lastLayer setBorderColor:[[UIColor clearColor] CGColor]];
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
	if (CGRectContainsPoint([[[self photoLayersArray] lastObject] frame], position)&& photoTouchFlag) {
		[self animateView:[[self photoLayersArray] lastObject] toPosition: position];
	} 
	else if(CGRectContainsPoint([[[self textLabelLayersArray] lastObject] frame], position)&& lableTouchFlag){
		[self animateView:[[self textLabelLayersArray] lastObject] toPosition: position];
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
            if(selectedAddMoreLayerTab == ARRANGE_LAYER_TAB){
                //[self.imgView sendSubviewToBack:[[self photoLayersArray] objectAtIndex:arrangeLayerIndex]];
                [self.imgView bringSubviewToFront:[[self textLabelLayersArray] objectAtIndex:arrangeLayerIndex]];            
            } else{
                //[self.imgView sendSubviewToBack:[[self photoLayersArray] lastObject]];
                [self.imgView bringSubviewToFront:[[self textLabelLayersArray] objectAtIndex:arrangeLayerIndex]];
            }

			for (UITouch *touch in touches) {
				//[self dispatchFirstTouchAtPoint:msgLabel point:[touch locationInView:self.view] forEvent:nil];
                if(selectedAddMoreLayerTab == ARRANGE_LAYER_TAB){
                    [self dispatchFirstTouchAtPoint:[[self textLabelLayersArray] lastObject] point:[touch locationInView:self.imgView] forEvent:nil];
                }else{
                    [self dispatchFirstTouchAtPoint:[[self textLabelLayersArray] lastObject] point:[touch locationInView:self.imgView] forEvent:nil];
                }
			}
		}
		//else if (CGRectContainsPoint([photoImgView frame], [touch locationInView:self.imgView]) && photoTouchFlag)
		else if (
                 loc.y <= (imgView.frame.size.height-(((UIImageView *)[[self photoLayersArray] lastObject]).frame.size.height/2))
                 && photoTouchFlag
                 && loc.x <= (imgView.frame.size.width-(((UIImageView *)[[self photoLayersArray] lastObject]).frame.size.width/2))
                 && loc.x >= ((((UIImageView *)[[self photoLayersArray] lastObject]).frame.size.width/2)))
		{
            if(selectedAddMoreLayerTab == ARRANGE_LAYER_TAB){
                [self.imgView bringSubviewToFront:[[self photoLayersArray] objectAtIndex:arrangeLayerIndex]];
                //[self.imgView bringSubviewToFront:[[self textLabelLayersArray] lastObject]];
            }else{
                [self.imgView bringSubviewToFront:[[self photoLayersArray] lastObject]];
                //[self.imgView bringSubviewToFront:[[self textLabelLayersArray] lastObject]];
            }

			for (UITouch *touch in touches) {
                if(selectedAddMoreLayerTab == ARRANGE_LAYER_TAB){
                    [self dispatchFirstTouchAtPoint:[[self photoLayersArray] objectAtIndex:arrangeLayerIndex] point:[touch locationInView:self.imgView] forEvent:nil];
                }else{
                    [self dispatchFirstTouchAtPoint:[[self photoLayersArray] lastObject] point:[touch locationInView:self.imgView] forEvent:nil];
                }
				//[self dispatchFirstTouchAtPoint:photoImgView point:[touch locationInView:self.view] forEvent:nil];
			}
		}
        else if (loc.y <= (imgView.frame.size.height-(symbolImgView.frame.size.height/2)) && symbolTouchFlag)
		{
            if(selectedAddMoreLayerTab == ARRANGE_LAYER_TAB){
                [self.imgView bringSubviewToFront:[[self symbolLayersArray] objectAtIndex:arrangeLayerIndex]];
                //[self.imgView bringSubviewToFront:[[self textLabelLayersArray] lastObject]];
            }else{
                [self.imgView bringSubviewToFront:[[self symbolLayersArray] lastObject]];
                //[self.imgView bringSubviewToFront:[[self textLabelLayersArray] lastObject]];
            }

			for (UITouch *touch in touches) {
                if(selectedAddMoreLayerTab == ARRANGE_LAYER_TAB){
                    [self dispatchFirstTouchAtPoint:[[self symbolLayersArray] objectAtIndex:arrangeLayerIndex] point:[touch locationInView:self.imgView] forEvent:nil];
                }else{
                    [self dispatchFirstTouchAtPoint:[[self symbolLayersArray] lastObject] point:[touch locationInView:self.imgView] forEvent:nil];
                }
				//[self dispatchFirstTouchAtPoint:photoImgView point:[touch locationInView:self.view] forEvent:nil];
			}
		}
        else if (loc.y <= (imgView.frame.size.height-(iconImgView.frame.size.height/2)) && iconTouchFlag)
		{
            if(selectedAddMoreLayerTab == ARRANGE_LAYER_TAB){
                [self.imgView bringSubviewToFront:[[self iconLayersArray] objectAtIndex:arrangeLayerIndex]];
                //[self.imgView bringSubviewToFront:[[self textLabelLayersArray] lastObject]];
            }else{
                [self.imgView bringSubviewToFront:[[self iconLayersArray] lastObject]];
                //[self.imgView bringSubviewToFront:[[self textLabelLayersArray] lastObject]];
            }

			for (UITouch *touch in touches) {
                if(selectedAddMoreLayerTab == ARRANGE_LAYER_TAB){
                    [self dispatchFirstTouchAtPoint:[[self iconLayersArray] objectAtIndex:arrangeLayerIndex] point:[touch locationInView:self.imgView] forEvent:nil];
                }else{
                    [self dispatchFirstTouchAtPoint:[[self iconLayersArray] lastObject] point:[touch locationInView:self.imgView] forEvent:nil];
                }
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
            
            if(selectedAddMoreLayerTab == ARRANGE_LAYER_TAB){
                [self dispatchTouchEvent:[[self textLabelLayersArray] objectAtIndex:arrangeLayerIndex] toPosition:[touch locationInView:self.imgView]];
            }else{
                [self dispatchTouchEvent:[[self textLabelLayersArray] lastObject] toPosition:[touch locationInView:self.imgView]];
            }
			//[self dispatchTouchEvent:msgLabel toPosition:[touch locationInView:self.view]];
		}
		
	}
	//else if (CGRectContainsPoint([photoImgView frame], [touch locationInView:self.view]) && photoTouchFlag)
	//else if (CGRectContainsPoint([photoImgView frame], [touch locationInView:self.imgView]) && photoTouchFlag)
	else if (loc.y <= (imgView.frame.size.height-(((UIImageView *)[[self photoLayersArray] lastObject]).frame.size.height/2))
             && photoTouchFlag
             && loc.x <= (imgView.frame.size.width-(((UIImageView *)[[self photoLayersArray] lastObject]).frame.size.width/2))
             && loc.x >= ((((UIImageView *)[[self photoLayersArray] lastObject]).frame.size.width/2)))
	{
		for (UITouch *touch in touches){
            
            if(selectedAddMoreLayerTab == ARRANGE_LAYER_TAB){
                [self dispatchTouchEvent:[[self photoLayersArray] objectAtIndex:arrangeLayerIndex] toPosition:[touch locationInView:self.imgView]];
            }else{
                [self dispatchTouchEvent:[[self photoLayersArray] lastObject] toPosition:[touch locationInView:self.imgView]];
            }
			//[self dispatchTouchEvent:photoImgView toPosition:[touch locationInView:self.view]];
		}
	}
    else if (loc.y <= (imgView.frame.size.height-(symbolImgView.frame.size.height/2)) && symbolTouchFlag)
	{
		for (UITouch *touch in touches){
            if(selectedAddMoreLayerTab == ARRANGE_LAYER_TAB){
                [self dispatchTouchEvent:[[self symbolLayersArray] objectAtIndex:arrangeLayerIndex] toPosition:[touch locationInView:self.imgView]];
            }else{
                [self dispatchTouchEvent:[[self symbolLayersArray] lastObject] toPosition:[touch locationInView:self.imgView]];
            }
			//[self dispatchTouchEvent:photoImgView toPosition:[touch locationInView:self.view]];
		}
	}
    else if (loc.y <= (imgView.frame.size.height-(iconImgView.frame.size.height/2)) && iconTouchFlag)
	{
		for (UITouch *touch in touches){
            if(selectedAddMoreLayerTab == ARRANGE_LAYER_TAB){
                [self dispatchTouchEvent:[[self iconLayersArray] objectAtIndex:arrangeLayerIndex] toPosition:[touch locationInView:self.imgView]];
            }else{
                [self dispatchTouchEvent:[[self iconLayersArray] lastObject] toPosition:[touch locationInView:self.imgView]];
            }
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
    [array addObject:@""];
    if([[self textLabelLayersArray] count] > 0){
        NSLog(@"%@", ((CustomLabel*)[[self textLabelLayersArray] objectAtIndex:0]).text);
        [array addObject:((CustomLabel*)[[self textLabelLayersArray] objectAtIndex:0]).text];
    }else{
        [array addObject:@""];
    }
    
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

#pragma mark - InappPurchase

-(void)requestFont:(UIButton *)button{
    // Create an instance of EBPurchase (Inapp purchase).
    demoPurchase = [[EBPurchase alloc] init];
    demoPurchase.delegate = self;
    
    [demoPurchase requestProduct:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@%d",FONT_PRODUCT_PREFIX,button.tag],nil]];
}

-(void)requestFontBorder:(UIButton *)button{
    // Create an instance of EBPurchase (Inapp purchase).
    demoPurchase = [[EBPurchase alloc] init];
    demoPurchase.delegate = self;
    
    [demoPurchase requestProduct:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@%d",TEXT_BORDER_PRODUCT_PREFIX,button.tag],nil]];
}

-(IBAction)purchaseProduct:(NSString *)productId{
    
    NSLog(@"ProductId: %@", productId);
    // First, ensure that the SKProduct that was requested by
    // the EBPurchase requestProduct method in the viewWillAppear
    // event is valid before trying to purchase it.
    
    //if user want to buy 1 match
    if (demoPurchase.products != nil)
    {
        //loadingView.hidden = NO;
        
        if (![demoPurchase purchaseProduct:[demoPurchase.products objectAtIndex:0]])
        {
            // Returned NO, so notify user that In-App Purchase is Disabled in their Settings.
            UIAlertView *settingsAlert = [[UIAlertView alloc] initWithTitle:@"Allow Purchases" message:@"You must first enable In-App Purchase in your iOS Settings before making this purchase." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [settingsAlert show];
        }
    }
}

-(IBAction)restorePurchase
{
    // Restore a customer's previous non-consumable or subscription In-App Purchase.
    // Required if a user reinstalled app on same device or another device.
    
    // Call restore method.
    if (![demoPurchase restorePurchase]) {
        // Returned NO, so notify user that In-App Purchase is Disabled in their Settings.
        UIAlertView *settingsAlert = [[UIAlertView alloc] initWithTitle:@"Allow Purchases" message:@"You must first enable In-App Purchase in your iOS Settings before restoring a previous purchase." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [settingsAlert show];
        
    }
}

#pragma mark EBPurchaseDelegate Methods

-(void) requestedProduct:(EBPurchase*)ebp identifier:(NSString*)productId name:(NSString*)productName price:(NSString*)productPrice description:(NSString*)productDescription
{
    NSLog(@"ViewController requestedProduct");
    
    [self purchaseProduct:productId];
    /*if(loadingView.hidden == NO) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [self exportHighlights:nil];
        loadingView.hidden = YES;
        return;
    }*/
    
}

-(void) successfulPurchase:(EBPurchase*)ebp restored:(bool)isRestore identifier:(NSString*)productId receipt:(NSData*)transactionReceipt
{
    NSLog(@"ViewController successfulPurchase");
    
    // Purchase or Restore request was successful, so...
    // 1 - Unlock the purchased content for your new customer!
    // 2 - Notify the user that the transaction was successful.
    
    if (!isPurchased)
    {
        // If paid status has not yet changed, then do so now. Checking
        // isPurchased boolean ensures user is only shown Thank You message
        // once even if multiple transaction receipts are successfully
        // processed (such as past subscription renewals).
        
        isPurchased = YES;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *alertMessage;
        
        if([productId isEqualToString:FONT6_PRODUCT_ID]) {
            
            [prefs setInteger:1 forKey:FONT6_PRODUCT_ID];
            [prefs synchronize];
            
            [fontScrollView removeFromSuperview];
            fontScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385,320,44)];
            if(IS_IPHONE_5){
                fontScrollView.frame = CGRectMake(10, 354, 320, 130);
            }else{
                fontScrollView.frame = CGRectMake(0, 360, 320, 44);
            }
            // Update view with no lock
            [self addFontsInSubView];
            [self.view addSubview:fontScrollView];
            [self layoutScrollImages:fontScrollView scrollWidth:35 scrollHeight:35];

            alertMessage = [NSString stringWithFormat:@"Your purchase was successful. %@ is unlocked now.", productId];
            
        } else if([productId isEqualToString:FONT7_PRODUCT_ID]) {
            
            [prefs setInteger:1 forKey:FONT7_PRODUCT_ID];
            [prefs synchronize];
            
            [fontScrollView removeFromSuperview];
            fontScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385,320,44)];
            if(IS_IPHONE_5){
                fontScrollView.frame = CGRectMake(10, 354, 320, 130);
            }else{
                fontScrollView.frame = CGRectMake(0, 360, 320, 44);
            }
            // Update view with no lock
            [self addFontsInSubView];
            [self.view addSubview:fontScrollView];
            [self layoutScrollImages:fontScrollView scrollWidth:35 scrollHeight:35];
            
            alertMessage = [NSString stringWithFormat:@"Your purchase was successful. %@ is unlocked now.", productId];
        }
        
        //-------------------------------------
        
        // 1 - Unlock the purchased content and update the app's stored settings.
        
        //-------------------------------------
        
        // 2 - Notify the user that the transaction was successful.
        
        UIAlertView *updatedAlert = [[UIAlertView alloc] initWithTitle:@"Thank You!" message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [updatedAlert show];
        
    }
    
    //loadingView.hidden = YES;
}

-(void) failedPurchase:(EBPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage {
    // Purchase or Restore request failed or was cancelled, so notify the user.
    
    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:@"Purchase Stopped" message:@"Either you cancelled the request or Apple reported a transaction error. Please try again later, or contact the app's customer support for assistance." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [failedAlert show];
    
    //loadingView.hidden = YES;
    
}

-(void) incompleteRestore:(EBPurchase*)ebp
{
    NSLog(@"ViewController incompleteRestore");
    
    // Restore queue did not include any transactions, so either the user has not yet made a purchase
    // or the user's prior purchase is unavailable, so notify user to make a purchase within the app.
    // If the user previously purchased the item, they will NOT be re-charged again, but it should
    // restore their purchase.
    
    UIAlertView *restoreAlert = [[UIAlertView alloc] initWithTitle:@"Restore Issue" message:@"A prior purchase transaction could not be found. To restore the purchased product, tap the Buy button. Paid customers will NOT be charged again, but the purchase will be restored." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [restoreAlert show];
    
    //loadingView.hidden = YES;
    
}

-(void) failedRestore:(EBPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage
{
    NSLog(@"ViewController failedRestore");
    
    // Restore request failed or was cancelled, so notify the user.
    
    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:@"Restore Stopped" message:@"Either you cancelled the request or your prior purchase could not be restored. Please try again later, or contact the app's customer support for assistance." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [failedAlert show];
    
    //loadingView.hidden = YES;
    
}

-(void) cancelPurchase {
    //loadingView.hidden = YES;
}

-(BOOL)isFontPurchased:(int)index{

    if(index == 6){
        if([[NSUserDefaults standardUserDefaults] objectForKey:FONT6_PRODUCT_ID]){
            return YES;
        }
    } else if(index == 7){
        if([[NSUserDefaults standardUserDefaults] objectForKey:FONT7_PRODUCT_ID]){
            return YES;
        }
    }
    
    return NO;
}

-(BOOL)isColorPurchased:(int)index{
    return NO;
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
	[templateArray release];
	[navBar release];
	[msgTextView release];
	[msgLabel release];
	[colorScrollView release];
	[sizeScrollView release];
	[borderScrollView release];
	[fontBorderScrollView release];
	[fontScrollView release];
	[symbolScrollView release];
	[iconScrollView release];
    
    [super dealloc];
}

@end
