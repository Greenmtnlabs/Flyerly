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
#import <Parse/PFUser.h>
#import <Parse/PFFile.h>
#import <Parse/PFObject.h>
#import <Parse/PFQuery.h>
#import "LoadingView.h"
#import "Flurry.h"
#import "SKProduct+LocalPrice.h"

@implementation PhotoController
@synthesize imgView,imgPicker,imageNameNew,msgTextView,finalFlyer;
@synthesize fontScrollView,colorScrollView,templateScrollView,sizeScrollView,borderScrollView,fontBorderScrollView,symbolScrollView,iconScrollView;
@synthesize selectedFont,selectedColor,navBar;
@synthesize selectedTemplate,selectedSymbol,selectedIcon;
@synthesize fontTabButton,colorTabButton,sizeTabButton,selectedText,selectedSize,borderTabButton,fontBorderTabButton,addMoreFontTabButton,addMoreIconTabButton,addMorePhotoTabButton,addMoreSymbolTabButton,arrangeLayerTabButton;
@synthesize templateBckgrnd,textBackgrnd,aHUD;
@synthesize cameraTabButton,photoTabButton,widthTabButton,heightTabButton,photoImgView,symbolImgView,iconImgView;
@synthesize photoTouchFlag,symbolTouchFlag,iconTouchFlag, lableTouchFlag,lableLocation,warningAlert,discardAlert,deleteAlert,editAlert, inAppAlert;
@synthesize moreLayersLabel, moreLayersButton, takePhotoButton, cameraRollButton, takePhotoLabel, cameraRollLabel, imgPickerFlag,finalImgWritePath, addMoreLayerOrSaveFlyerLabel, takeOrAddPhotoLabel,layerScrollView;
@synthesize cpyTextLabelLayersArray,cpyIconLayersArray,cpyPhotoLayersArray,cpySymbolLayersArray;
@synthesize flyerNumber;

int selectedAddMoreLayerTab = -1; // This variable is used as a flag to track selected Tab on Add More Layer screen
int symbolLayerCount = 0; // Symbol layer count to set tag value
int iconLayerCount = 0; // Icon layer count to set tag value
int textLayerCount = 0; // Text layer count to set tag value
int photoLayerCount = 0; // Photo layer count to set tag value

/*
 * This init method is called when editing a flyer is pressed
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil templateParam:(UIImage *)templateParam symbolArrayParam:(NSMutableArray *)symbolArrayParam iconArrayParam:(NSMutableArray *)iconArrayParam photoArrayParam:(NSMutableArray *)photoArrayParam textArrayParam:(NSMutableArray *)textArrayParam flyerNumberParam:(int)flyerNumberParam{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        selectedTemplate = templateParam;
        symbolLayersArray = symbolArrayParam;
        iconLayersArray = iconArrayParam;
        photoLayersArray = photoArrayParam;
        textLabelLayersArray = textArrayParam;
        flyerNumber = flyerNumberParam;
    }
    return self;
}

#pragma mark  View Appear Methods
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg_without_logo2"] forBarMetrics:UIBarMetricsDefault];
    
    // Set template image
	if (globle.NBUimage != nil) {
        imgView.image = globle.NBUimage;
        selectedTemplate = globle.NBUimage;
    }
        self.navigationController.navigationBarHidden = NO;
        imgPicker = [[UIImagePickerController alloc] init];
        imgPicker.allowsEditing = NO;
        imgPicker.delegate =self;
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
   
}

- (void) handleMemoryWarning:(NSNotification *)notification
{
	FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
	[appDele clearCache];
}

-(void)viewDidAppear:(BOOL)animated{
    
    

    
    //NSLog(@"%@",globle.CheckHelpOpen);
    layerallow = 0;
    // Setup buttons and labels
    [moreLayersButton setBackgroundImage:[UIImage imageNamed:@"07_addmore"] forState:UIControlStateNormal];
    [moreLayersButton addTarget:self action:@selector(callAddMoreLayers) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreLayersButton];
    
    [moreLayersLabel setText:@"Add more layers"];
    [moreLayersLabel setBackgroundColor:[UIColor clearColor]];
    [moreLayersLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:13]];
    [moreLayersLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:moreLayersLabel];
    
    [addMoreLayerOrSaveFlyerLabel setText:@"ADD MORE LAYERS OR ADJUST LAYERS BELOW"];    [addMoreLayerOrSaveFlyerLabel setNumberOfLines:2];
    [addMoreLayerOrSaveFlyerLabel setBackgroundColor:[UIColor clearColor]];
    [addMoreLayerOrSaveFlyerLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:16]];
    [addMoreLayerOrSaveFlyerLabel setTextColor:[UIColor grayColor]];
    [addMoreLayerOrSaveFlyerLabel setTextAlignment:UITextAlignmentCenter];
    [self.view addSubview:addMoreLayerOrSaveFlyerLabel];
     [self.addMoreLayerOrSaveFlyerLabel setHidden:YES];
    
    [takeOrAddPhotoLabel setText:@"TAKE OR ADD PHOTO & RESIZE"];
    [takeOrAddPhotoLabel setBackgroundColor:[UIColor clearColor]];
    [takeOrAddPhotoLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:18]];
    [takeOrAddPhotoLabel setTextColor:[UIColor grayColor]];
    [takeOrAddPhotoLabel setTextAlignment:UITextAlignmentCenter];
    [self.view addSubview:takeOrAddPhotoLabel];
    
	photoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 50, 220, 200)];
	[photoImgView setUserInteractionEnabled:NO];
    
	symbolImgView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 50, 90, 70)];
	[symbolImgView setUserInteractionEnabled:NO];
    
	iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(150, 50, 90, 70)];
	[iconImgView setUserInteractionEnabled:NO];
	
	textBackgrnd = [[UIImageView alloc]initWithFrame:CGRectMake(0, 385, 320, 44)];
	[self.view addSubview:textBackgrnd];
	textBackgrnd.alpha = ALPHA0;
    
	msgLabel = [[CustomLabel alloc]initWithFrame:CGRectMake(0, 30, 320, 500)];
	msgLabel.backgroundColor = [UIColor clearColor];
	msgLabel.textColor = [UIColor blackColor];
	msgLabel.textAlignment = UITextAlignmentCenter;
	[self.imgView addSubview:msgLabel];
    
	msgTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 50, 280, 250)];
	msgTextView.delegate = self;
	msgTextView.font = [UIFont fontWithName:@"Arial" size:16];
	msgTextView.textColor = [UIColor blackColor];
	msgTextView.textAlignment = UITextAlignmentCenter;
    
	// setup scroll views
	fontScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385,320,44)];
	colorScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385,320,44)];
	sizeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385, 320, 44)];
	borderScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385, 320, 44)];
	fontBorderScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385, 320, 44)];
	symbolScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385,320,44)];
	iconScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385,320,44)];
	layerScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385,320,44)];

    // Add Symbols
	NSInteger symbolScrollWidth = 60;
	NSInteger symbolScrollHeight = 50;
    [self addSymbolsInSubView];
    /*
	symbolArray = [[NSMutableArray alloc]init];
    
	for(int i=1;i<=113;i++) {
        
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
    */
    // Add Icons
  
    NSInteger iconScrollWidth = 60;
	NSInteger iconScrollHeight = 50;
    [self addFlyerIconInSubView];
  /*
	iconArray = [[NSMutableArray alloc]init];
    
	for(int i=1;i<=94;i++) {
        
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
     */
    // Add icons in scroll view

    
    
    // Create font array
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
	
    // Add fonts in scroll view
    [self addFontsInSubView];
	
    // Create color array
	colorArray = 	[[NSArray  alloc] initWithObjects: [UIColor redColor], [UIColor blueColor], [UIColor greenColor], [UIColor blackColor], [UIColor colorWithRed:253.0/255.0 green:191.0/255.0 blue:38.0/224.0 alpha:1], [UIColor colorWithWhite:1.0f alpha:1.0f], [UIColor grayColor], [UIColor magentaColor], [UIColor yellowColor], [UIColor colorWithRed:163.0/255.0 green:25.0/255.0 blue:2.0/224.0 alpha:1], [UIColor colorWithRed:3.0/255.0 green:15.0/255.0 blue:41.0/224.0 alpha:1], [UIColor purpleColor], [UIColor colorWithRed:85.0/255.0 green:86.0/255.0 blue:12.0/224.0 alpha:1], [UIColor orangeColor], [UIColor colorWithRed:98.0/255.0 green:74.0/255.0 blue:9.0/224.0 alpha:1], [UIColor colorWithRed:80.0/255.0 green:7.0/255.0 blue:1.0/224.0 alpha:1], [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:97.0/224.0 alpha:1], [UIColor colorWithRed:111.0/255.0 green:168.0/255.0 blue:100.0/224.0 alpha:1], [UIColor cyanColor], [UIColor colorWithRed:17.0/255.0 green:69.0/255.0 blue:70.0/224.0 alpha:1], [UIColor colorWithRed:173.0/255.0 green:127.0/255.0 blue:251.0/224.0 alpha:1], nil];
	
    // Add colors in scroll view
    [self addColorsInSubView];
    
    // Create border colors array
    borderArray = 	[[NSArray  alloc] initWithObjects: [UIColor blackColor], [UIColor grayColor], [UIColor darkGrayColor], [UIColor blueColor], [UIColor purpleColor], [UIColor colorWithRed:115.0/255.0 green:134.0/255.0 blue:144.0/255.0 alpha:1], [UIColor orangeColor], [UIColor greenColor], [UIColor redColor], [UIColor colorWithRed:14.0/255.0 green:95.0/255.0 blue:111.0/255.0 alpha:1], [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:149.0/255.0 alpha:1], [UIColor colorWithRed:228.0/255.0 green:128.0/255.0 blue:144.0/255.0 alpha:1], [UIColor colorWithRed:213.0/255.0 green:110.0/255.0 blue:86.0/255.0 alpha:1],[UIColor colorWithRed:156.0/255.0 green:195.0/255.0 blue:233.0/255.0 alpha:1],[UIColor colorWithRed:27.0/255.0 green:70.0/255.0 blue:148.0/255.0 alpha:1],[UIColor colorWithRed:234.0/255.0 green:230.0/255.0 blue:51.0/255.0 alpha:1],[UIColor cyanColor], [UIColor colorWithRed:232.0/255.0 green:236.0/255.0 blue:51.0/224.0 alpha:1],[UIColor magentaColor],[UIColor colorWithRed:57.0/255.0 green:87.0/255.0 blue:13.0/224.0 alpha:1], [UIColor colorWithRed:93.0/255.0 green:97.0/255.0 blue:196.0/224.0 alpha:1],nil];

    
    // Add size in scroll view
	[self addSizeInSubView];
    
    // Add text border in scroll view
    [self addTextBorderInSubView];
    
    // Add flyer border in scroll view
    [self addFlyerBorderInSubView];

    

	
    // Set frame and actions for scrollview data
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
    
    // Setup tab button
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
    
    fontTabButton.showsTouchWhenHighlighted = YES;
    colorTabButton.showsTouchWhenHighlighted = YES;
    sizeTabButton.showsTouchWhenHighlighted = YES;
    borderTabButton.showsTouchWhenHighlighted = YES;
    fontBorderTabButton.showsTouchWhenHighlighted = YES;
    cameraTabButton.showsTouchWhenHighlighted = YES;
    photoTabButton.showsTouchWhenHighlighted = YES;
    widthTabButton.showsTouchWhenHighlighted = YES;
    heightTabButton.showsTouchWhenHighlighted = YES;
    addMoreFontTabButton.showsTouchWhenHighlighted = YES;
    addMorePhotoTabButton.showsTouchWhenHighlighted = YES;
    addMoreIconTabButton.showsTouchWhenHighlighted = YES;
    addMoreSymbolTabButton.showsTouchWhenHighlighted = YES;
    arrangeLayerTabButton.showsTouchWhenHighlighted = YES;

    
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
	[fontTabButton setBackgroundImage:[UIImage imageNamed:@"font_button"] forState:UIControlStateNormal];
	[fontTabButton.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
	[fontTabButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[fontTabButton addTarget:self action:@selector(setStyleTabAction:) forControlEvents:UIControlEventTouchUpInside];
	fontTabButton.alpha =  ALPHA0;
	fontTabButton.tag = 10001;
	[self.view addSubview:fontTabButton];
	
	[colorTabButton setBackgroundImage:[UIImage imageNamed:@"color_button"] forState:UIControlStateNormal];
	[colorTabButton.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
	[colorTabButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[colorTabButton addTarget:self action:@selector(setStyleTabAction:) forControlEvents:UIControlEventTouchUpInside];
	colorTabButton.alpha =  ALPHA0;
	colorTabButton.tag = 10002;
	[self.view addSubview:colorTabButton];
	
	[sizeTabButton setBackgroundImage:[UIImage imageNamed:@"size_button"] forState:UIControlStateNormal];
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
    cameraTabButton.showsTouchWhenHighlighted = YES;
	//[cameraTabButton.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
	//[cameraTabButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[cameraTabButton addTarget:self action:@selector(setCameraTabAction:) forControlEvents:UIControlEventTouchUpInside];
	cameraTabButton.alpha =  ALPHA0;
	cameraTabButton.tag = 10001;
	[self.view addSubview:cameraTabButton];
	
	[photoTabButton setBackgroundImage:[UIImage imageNamed:@"07_roll"] forState:UIControlStateNormal];
	//[photoTabButton.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
	//[photoTabButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[photoTabButton addTarget:self action:@selector(setPhotoTabAction:) forControlEvents:UIControlEventTouchUpInside];
	photoTabButton.alpha =  ALPHA0;
	photoTabButton.tag = 10002;
	[self.view addSubview:photoTabButton];
	
	[widthTabButton setBackgroundImage:[UIImage imageNamed:@"07_width"] forState:UIControlStateNormal];
	//[widthTabButton.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
	//[widthTabButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [widthTabButton addTarget:self action:@selector(selectWidth:) forControlEvents:UIControlEventTouchUpInside];
    [widthTabButton setSelected:YES];
	widthTabButton.alpha =  ALPHA0;
	widthTabButton.tag = 10003;
	[self.view addSubview:widthTabButton];
	
	[heightTabButton setBackgroundImage:[UIImage imageNamed:@"07_height"] forState:UIControlStateNormal];
	//[heightTabButton.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
	//[heightTabButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [heightTabButton addTarget:self action:@selector(selectHeight:) forControlEvents:UIControlEventTouchUpInside];
	heightTabButton.alpha =  ALPHA0;
	heightTabButton.tag = 10004;
	[self.view addSubview:heightTabButton];
    
    // Add more layer tabs
	[addMoreFontTabButton setBackgroundImage:[UIImage imageNamed:@"text_icon"] forState:UIControlStateNormal];
    [addMoreFontTabButton setBackgroundImage:[UIImage imageNamed:@"text_icon_selected"] forState:UIControlStateHighlighted];

	[addMoreFontTabButton addTarget:self action:@selector(setAddMoreLayerTabAction:) forControlEvents:UIControlEventTouchUpInside];
	addMoreFontTabButton.alpha =  ALPHA0;
	addMoreFontTabButton.tag = 10001;
	[self.view addSubview:addMoreFontTabButton];
	
	[addMorePhotoTabButton setBackgroundImage:[UIImage imageNamed:@"image_icon"] forState:UIControlStateNormal];
    [addMorePhotoTabButton setBackgroundImage:[UIImage imageNamed:@"image_icon_selected"] forState:UIControlStateHighlighted];
    
	[addMorePhotoTabButton addTarget:self action:@selector(setAddMoreLayerTabAction:) forControlEvents:UIControlEventTouchUpInside];
	addMorePhotoTabButton.alpha =  ALPHA0;
	addMorePhotoTabButton.tag = 10002;
    addMorePhotoTabButton.titleLabel.text = @"Photo";
	[self.view addSubview:addMorePhotoTabButton];
	
	[addMoreSymbolTabButton setBackgroundImage:[UIImage imageNamed:@"symbolicon_button"] forState:UIControlStateNormal];
    	[addMoreSymbolTabButton setBackgroundImage:[UIImage imageNamed:@"symbolicon_button_selected"] forState:UIControlStateHighlighted];
	[addMoreSymbolTabButton addTarget:self action:@selector(setAddMoreLayerTabAction:) forControlEvents:UIControlEventTouchUpInside];
	addMoreSymbolTabButton.alpha =  ALPHA0;
	addMoreSymbolTabButton.tag = 10003;
	[self.view addSubview:addMoreSymbolTabButton];
    
	[addMoreIconTabButton setBackgroundImage:[UIImage imageNamed:@"icon_button"] forState:UIControlStateNormal];
    
    [addMoreIconTabButton setBackgroundImage:[UIImage imageNamed:@"icon_button_selected"] forState:UIControlStateHighlighted];

	[addMoreIconTabButton addTarget:self action:@selector(setAddMoreLayerTabAction:) forControlEvents:UIControlEventTouchUpInside];
	addMoreIconTabButton.alpha =  ALPHA0;
	addMoreIconTabButton.tag = 10004;
	[self.view addSubview:addMoreIconTabButton];
    
	[arrangeLayerTabButton setBackgroundImage:[UIImage imageNamed:@"arrangeicon_button"] forState:UIControlStateNormal];
    [arrangeLayerTabButton setBackgroundImage:[UIImage imageNamed:@"arrangeicon_button_selected"] forState:UIControlStateHighlighted];
	
    [arrangeLayerTabButton addTarget:self action:@selector(setAddMoreLayerTabAction:) forControlEvents:UIControlEventTouchUpInside];
	arrangeLayerTabButton.alpha =  ALPHA0;
	arrangeLayerTabButton.tag = 10005;
	[self.view addSubview:arrangeLayerTabButton];
    // Changes
    [addMoreFontTabButton setTitle:@"Text" forState:UIControlStateNormal];
    [addMoreFontTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
    addMoreFontTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    
    [addMorePhotoTabButton setTitle:@"Photo" forState:UIControlStateNormal];
    [addMorePhotoTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
    addMorePhotoTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    
    [addMoreSymbolTabButton setTitle:@"Clipart" forState:UIControlStateNormal];
    [addMoreSymbolTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
    addMoreSymbolTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    
    [arrangeLayerTabButton setTitle:@"Edit" forState:UIControlStateNormal];
    [arrangeLayerTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
    arrangeLayerTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    
    [addMoreIconTabButton setTitle:@"Symbols" forState:UIControlStateNormal];
    [addMoreIconTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
    addMoreIconTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
}


-(void)viewDidLoad{
	[super viewDidLoad];
 
    globle = [Singleton RetrieveSingleton];
    [self.view setBackgroundColor:[globle colorWithHexString:@"f5f1de"]];
    navBar.alpha =ALPHA1;


	aHUD = [[HudView alloc]init];
    photoTouchFlag=NO;
	symbolTouchFlag=NO;
    iconTouchFlag = NO;
	lableTouchFlag=NO;
    
    // Set height and width of each element of scroll view
    fontScrollWidth = 44;
	fontScrollHeight = 35;
	colorScrollWidth = 44;
	colorScrollHeight = 35;
	sizeScrollWidth = 44;
	sizeScrollHeight = 35;
    borderScrollWidth = 44;
	borderScrollHeight = 35;
    fontBorderScrollWidth = 44;
	fontBorderScrollHeight = 35;
    
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

    undoCount = 0; // This is to track undo functionality. Set it to 0.
    discardedLayer = NO; // This flag is used to check whether the layer is discarded or editted
    
    // Make copy of layers to undo it later
    [self makeCopyOfLayers:YES];
    
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
    if(!selectedTemplate){
        selectedTemplate  = [UIImage imageNamed:@"main_area_bg"];
    }
	lableLocation = CGPointMake(160,100);
	    
	// Create Main Image View
    if(IS_IPHONE_5){
        templateBckgrnd = [[UIImageView alloc]initWithFrame:CGRectMake(0, 413, 320, 135)];
        moreLayersButton = [[UIButton alloc] initWithFrame:CGRectMake(82, 445, 156, 43)];
        moreLayersLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 445, 156, 43)];
        takePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 373, 135, 40)];
        takePhotoLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 378, 80, 30)];
        cameraRollButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 373, 135, 40)];
        cameraRollLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 378, 80, 30)];
        templateScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 413,320,130)];
        addMoreLayerOrSaveFlyerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 405, 310, 63)];
        takeOrAddPhotoLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 405, 310, 43)];
    }else{
        templateBckgrnd = [[UIImageView alloc]initWithFrame:CGRectMake(0, 395, 320, 65)];
        cameraRollButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 354, 135, 40)];
        moreLayersButton = [[UIButton alloc] initWithFrame:CGRectMake(82, 354, 156, 43)];
        moreLayersLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 354, 156, 43)];
        takePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 354, 135, 40)];
        takePhotoLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 359, 80, 30)];
        cameraRollLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 359, 80, 30)];
        templateScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 395,320,60)];
        addMoreLayerOrSaveFlyerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 354, 310, 63)];
        takeOrAddPhotoLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 354, 310, 43)];
    }
    
    // RESET image view
    [self resetImageview];
    
    [takePhotoButton setBackgroundImage:[UIImage imageNamed:@"take_photo"] forState:UIControlStateNormal];
        takePhotoButton.showsTouchWhenHighlighted = YES;
    [takePhotoButton addTarget:self action:@selector(openCustomCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takePhotoButton];
    [cameraRollButton setBackgroundImage:[UIImage imageNamed:@"camera_roll"] forState:UIControlStateNormal];
    [cameraRollButton addTarget:self action:@selector(loadCustomPhotoLibrary) forControlEvents:UIControlEventTouchUpInside];
      cameraRollButton.showsTouchWhenHighlighted = YES;
    [self.view addSubview:cameraRollButton];

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
    
    //templateBckgrnd.image = [UIImage imageNamed:@"ad_bg_bg"];
   // [self.view addSubview:templateBckgrnd];
	//templateBckgrnd.alpha = ALPHA0;
    
    // Add Templates
	templateScrollWidth = 60;
	templateScrollHeight = 55;
	templateArray = [[NSMutableArray alloc]init];
	//NSAutoreleasePool* pool1 = [[NSAutoreleasePool alloc] init];
	///[pool1 release];

    // Add templates in scroll view
    [self addTemplatesInSubView];
    
	[templateScrollView setCanCancelContentTouches:NO];
	templateScrollView.scrollEnabled = YES;
	templateScrollView.pagingEnabled = NO;
	templateScrollView.showsHorizontalScrollIndicator = NO;
	templateScrollView.showsVerticalScrollIndicator = NO;
	templateScrollView.alpha = ALPHA1;
	[self.view addSubview:templateScrollView];
	[self layoutScrollImages:templateScrollView scrollWidth:templateScrollWidth scrollHeight:templateScrollHeight];
	   
	imgPickerFlag =1;
    selectedAddMoreLayerTab = -1;
    
    // Call choose template
	[self chooseTemplate];

}

/*
 * This resets the flyer image view by removing and readding all its subviews
 */
-(void)resetImageview{
    
    // Remo all views inside image view
    NSArray *viewsToRemove = [self.imgView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    // Remove image view from super view
    [imgView removeFromSuperview];
    
	// Create Main Image View
    if(IS_IPHONE_5){
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 65, 310, 309)];
    }else{
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 44, 310, 309)];
    }
    
    // Set template image
	imgView.image = selectedTemplate;
    
    // Setting arrays if in edit mode
    if(symbolLayersArray){
        for(UIImageView *symbolImageView in symbolLayersArray){
            [self.imgView addSubview:symbolImageView];
        }
    }
    if(iconLayersArray){
        for(UIImageView *iconImageView in iconLayersArray){
            [self.imgView addSubview:iconImageView];
        }
    }
    if(photoLayersArray){
        for(UIImageView *photoImageView in photoLayersArray){
            [self.imgView addSubview:photoImageView];
        }
    }
    if(textLabelLayersArray){
        for(CustomLabel *customLabel in textLabelLayersArray){
            [self.imgView addSubview:customLabel];
        }
    }
    
    // Add image view to superview
	[self.view addSubview:imgView];

}

/*
 * Add templates in scroll views
 */
-(void)addTemplatesInSubView{

    BOOL isAllTemplatePurchased = [self isProductPurchased:[PRODUCT_FULL_TEMPLATE stringByReplacingOccurrencesOfString:@"." withString:@""]];
    
    [templateArray removeAllObjects];
    
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
        
        if(i>4){
            if(!isAllTemplatePurchased){
                
                NSString *productToCheck = [[NSString stringWithFormat:@"%@%d",PREFIX_BACKGROUND_PRODUCT,i] stringByReplacingOccurrencesOfString:@"." withString:@""];
                
                if(![self isProductPurchased:productToCheck]){
                    UIImageView *lock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lock"]];
                    lock.frame = CGRectMake(21, 18, 17, 19);
                    [templateButton addSubview:lock];
                    templateButton.userInteractionEnabled = NO;
                }
            }
        }
        
		[templateScrollView addSubview:templateButton];
	}
}

/*
 * Add fonts in scroll views
 */
-(void)addFontsInSubView{
    
    BOOL isAllFontPurchased = [self isProductPurchased:[PRODUCT_FULL_FONT stringByReplacingOccurrencesOfString:@"." withString:@""]];
    
	for (int i = 1; i <=[fontArray count] ; i++)
	{
		UIButton *font = [UIButton buttonWithType:UIButtonTypeCustom];
		font.frame = CGRectMake(0, 0, fontScrollWidth, fontScrollHeight);        
		
		[font setTitle:@"A" forState:UIControlStateNormal];
		UIFont *fontname =fontArray[(i-1)];
		[font.titleLabel setFont: fontname];
		[font setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		font.tag = i;
		[font setBackgroundImage:[UIImage imageNamed:@"a_bg"] forState:UIControlStateNormal];
        
        if(i>5){
            if(!isAllFontPurchased){
                
                NSString *productToCheck = [[NSString stringWithFormat:@"%@%d",PREFIX_FONT_PRODUCT,i] stringByReplacingOccurrencesOfString:@"." withString:@""];
                
                if(![self isProductPurchased:productToCheck]){
                    UIImageView *lock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lock"]];
                    lock.frame = CGRectMake(20, 20, 17, 19);
                    [font addSubview:lock];
                    font.userInteractionEnabled = NO;
                }
            }
        }
        
		[fontScrollView addSubview:font];
	}
}

/*
 * Add sizes in scroll views
 */
-(void)addSizeInSubView{
    
    BOOL isAnyFontPurchased = [self isProductPurchased:[PRODUCT_FONT stringByReplacingOccurrencesOfString:@"." withString:@""]];
    BOOL isFullFontPurchased = [self isProductPurchased:[PRODUCT_FULL_FONT stringByReplacingOccurrencesOfString:@"." withString:@""]];
    if(!isAnyFontPurchased){
        isAnyFontPurchased = isFullFontPurchased;
    }
    
	for (int i = 1; i <=  [SIZE_ARRAY count] ; i++)
	{
		UIButton *size = [UIButton buttonWithType:UIButtonTypeCustom];
		size.frame = CGRectMake(0, 5, sizeScrollWidth, sizeScrollHeight);
		NSString *sizeValue =SIZE_ARRAY[(i-1)];
		[size setBackgroundImage:[UIImage imageNamed:@"a_bg"] forState:UIControlStateNormal];
		[size setTitle:sizeValue forState:UIControlStateNormal];
		[size.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
		[size setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		size.tag = i+60;
		size.alpha = ALPHA1;
        
        if(i>5 && i<([SIZE_ARRAY count] - 1)){
            if(!isAnyFontPurchased){
                UIImageView *lock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lock"]];
                lock.frame = CGRectMake(20, 20, 17, 19);
                [size addSubview:lock];
                size.userInteractionEnabled = NO;
            }
        }
        
		[sizeScrollView addSubview:size];
	}
}

/*
 * Add colors in scroll views
 */
-(void)addColorsInSubView{

    BOOL isAllColorPurchased = [self isProductPurchased:[PRODUCT_FULL_FONT_COLOR stringByReplacingOccurrencesOfString:@"." withString:@""]];
    
	for (int i = 1; i <=  [colorArray count] ; i++)
	{
		UIButton *color = [UIButton buttonWithType:UIButtonTypeCustom];
		color.frame = CGRectMake(0, 5, colorScrollWidth, colorScrollHeight);

        
		id colorName =colorArray[(i-1)];
		UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(color.frame.origin.x+5, color.frame.origin.y, color.frame.size.width, color.frame.size.height)];
		[label setBackgroundColor:colorName];
        label.layer.borderColor = [UIColor grayColor].CGColor;
        label.layer.borderWidth = 1.0;
		[color addSubview:label];
		color.tag = i+30;
        
        if(i>5){
            if(!isAllColorPurchased){
                
                NSString *productToCheck = [[NSString stringWithFormat:@"%@%d",PREFIX_FONT_COLOR_PRODUCT,color.tag] stringByReplacingOccurrencesOfString:@"." withString:@""];

                if(![self isProductPurchased:productToCheck]){
                    UIImageView *lock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lock"]];
                    lock.frame = CGRectMake(color.frame.origin.x-15, 24, 17, 19);
                    [color addSubview:lock];
                    color.userInteractionEnabled = NO;
                }
            }
        }
        
		[colorScrollView addSubview:color];
	}
}

/*
 * Add text borders in scroll views
 */
-(void)addTextBorderInSubView{
    
    BOOL isAllColorBordersPurchased = [self isProductPurchased:[PRODUCT_FULL_FONT_BORDER_COLOR stringByReplacingOccurrencesOfString:@"." withString:@""]];

	for (int i = 1; i <=  [borderArray count] ; i++)
	{
		UIButton *color = [UIButton buttonWithType:UIButtonTypeCustom];
		color.frame = CGRectMake(0, 5, borderScrollWidth, borderScrollHeight);
		UIColor *colorName =borderArray[(i-1)];
		UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(color.frame.origin.x, color.frame.origin.y-3, color.frame.size.width, color.frame.size.height)];
        label.layer.borderColor = colorName.CGColor;
        label.layer.borderWidth = 3.0;
		[color addSubview:label];
		color.tag = i+90;
		color.alpha = ALPHA1;
        
        if(i>5){
            if(!isAllColorBordersPurchased){
                
                NSString *productToCheck = [[NSString stringWithFormat:@"%@%d",PREFIX_TEXT_BORDER_PRODUCT,color.tag] stringByReplacingOccurrencesOfString:@"." withString:@""];
                
                if(![self isProductPurchased:productToCheck]){
                    UIImageView *lock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lock"]];
                    lock.frame = CGRectMake(20, 20, 17, 19);
                    [color addSubview:lock];
                    color.userInteractionEnabled = NO;
                }
            }
        }
        
		[fontBorderScrollView addSubview:color];
	}
}

/*
 * Add flyer borders in scroll views
 */
-(void)addFlyerBorderInSubView{

    BOOL isAllFlyerBorderColorsPurchased = [self isProductPurchased:[PRODUCT_FULL_FLYER_BORDER_COLOR stringByReplacingOccurrencesOfString:@"." withString:@""]];

	for (int i = 1; i <=  [borderArray count] ; i++)
	{
		UIButton *color = [UIButton buttonWithType:UIButtonTypeCustom];
		color.frame = CGRectMake(0, 5, borderScrollWidth, borderScrollHeight);
		UIColor *colorName =borderArray[(i-1)];
		UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(color.frame.origin.x, color.frame.origin.y-3, color.frame.size.width, color.frame.size.height)];
        label.layer.borderColor = colorName.CGColor;
        label.layer.borderWidth = 3.0;
		[color addSubview:label];
		color.tag = i+90;
		color.alpha = ALPHA1;
        
        if(i>5){
            if(!isAllFlyerBorderColorsPurchased){
                
                NSString *productToCheck = [[NSString stringWithFormat:@"%@%d",PREFIX_FLYER_BORDER_PRODUCT,color.tag] stringByReplacingOccurrencesOfString:@"." withString:@""];
                
                if(![self isProductPurchased:productToCheck]){
                    UIImageView *lock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lock"]];
                    lock.frame = CGRectMake(20, 20, 17, 19);
                    [color addSubview:lock];
                    color.userInteractionEnabled = NO;
                }
            }
        }
        
		[borderScrollView addSubview:color];
	}   
}
/*
 * Add flyer Symbols in scroll views
 */
-(void)addSymbolsInSubView{
        BOOL isAllsymbolPurchased = [self isProductPurchased:[PRODUCT_SYMBOL_ALL stringByReplacingOccurrencesOfString:@"." withString:@""]];

	NSInteger symbolScrollWidth = 60;
	NSInteger symbolScrollHeight = 50;

	symbolArray = [[NSMutableArray alloc]init];
    
	for(int i=1;i<=113;i++) {
        
		NSString* symbolName = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"symbol%d",i] ofType:@"png"];
		UIImage *symbolImg =  [UIImage imageWithContentsOfFile:symbolName];
        
		[symbolArray addObject:symbolImg];
		
		UIButton *symbolButton = [UIButton  buttonWithType:UIButtonTypeCustom];
		symbolButton.frame =CGRectMake(0, 5,symbolScrollWidth, symbolScrollHeight);
        [symbolButton setBackgroundColor:[globle colorWithHexString:@"f5f1de"]];
        
		UIImageView *img = [[UIImageView alloc]initWithImage:symbolImg];
		img.frame  = CGRectMake(symbolButton.frame.origin.x+5, symbolButton.frame.origin.y-2, symbolButton.frame.size.width-10, symbolButton.frame.size.height-7);
		[symbolButton addSubview:img];
		symbolButton.tag = i;
        if(i>5){
            if(!isAllsymbolPurchased){
                NSString *productToCheck = [[NSString stringWithFormat:@"%@%d",PREFIX_SYMBOL_PRODUCT,symbolButton.tag] stringByReplacingOccurrencesOfString:@"." withString:@""];
                
                if(![self isProductPurchased:productToCheck]){
                    UIImageView *lock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lock"]];
                    lock.frame = CGRectMake(21, 18, 17, 19);
                    [symbolButton addSubview:lock];
                    symbolButton.userInteractionEnabled = NO;
                }
                
            }
        }
        
		[symbolScrollView addSubview:symbolButton];
	}

}

/*
 * Add flyer Icons in scroll views
 */
-(void)addFlyerIconInSubView{
    BOOL isAlliconPurchased = [self isProductPurchased:[PRODUCT_ICON_ALL stringByReplacingOccurrencesOfString:@"." withString:@""]];
    
    NSInteger iconScrollWidth = 60;
	NSInteger iconScrollHeight = 50;
    
	iconArray = [[NSMutableArray alloc]init];
    
	for(int i=1;i<=94;i++) {
        
		NSString* iconName = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"ricon%d",i] ofType:@"png"];
		UIImage *iconImg =  [UIImage imageWithContentsOfFile:iconName];
        
		[iconArray addObject:iconImg];
		
		UIButton *iconButton = [UIButton  buttonWithType:UIButtonTypeCustom];
		iconButton.frame =CGRectMake(0, 5,iconScrollWidth, iconScrollHeight);
        [iconButton setBackgroundColor:[globle colorWithHexString:@"f5f1de"]];
        
		UIImageView *img = [[UIImageView alloc]initWithImage:iconImg];
		img.frame  = CGRectMake(iconButton.frame.origin.x+5, iconButton.frame.origin.y-2, iconButton.frame.size.width-10, iconButton.frame.size.height-7);
		[iconButton addSubview:img];
		iconButton.tag = i;
        if(i>5){
            if(!isAlliconPurchased){
                
                NSString *productToCheck = [[NSString stringWithFormat:@"%@%d",PREFIX_ICON_PRODUCT,iconButton.tag] stringByReplacingOccurrencesOfString:@"." withString:@""];
                
                if(![self isProductPurchased:productToCheck]){
                    UIImageView *lock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lock"]];
                    lock.frame = CGRectMake(21, 18, 17, 19);
                    [iconButton addSubview:lock];
                    iconButton.userInteractionEnabled = NO;
                }
            }
        }
        
		[iconScrollView addSubview:iconButton];
    }
}


#pragma mark  ScrollView Function & Selection Methods for ScrollView

/*
 * When any font is selected
 */
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
			selectedFont = fontArray[i-1];
			selectedFont = [selectedFont fontWithSize:selectedSize];
			msgTextView.font = selectedFont;
            ((CustomLabel*)[self textLabelLayersArray][arrangeLayerIndex]).font = selectedFont;
		}
		i++;
	}
}

/*
 * When any color is selected
 */
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
			selectedColor = colorArray[i-1];
			msgTextView.textColor = selectedColor;
            ((CustomLabel*)[self textLabelLayersArray][arrangeLayerIndex]).textColor = selectedColor;
		}
		i++;
	}
}

/*
 * When any template is selected
 */
-(void)selectTemplate:(id)sender
{
	FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
	appDele.changesFlag = YES;
	UIButton *view = sender;
	selectedTemplate  =  templateArray[view.tag];
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionPush];
	[animation setSubtype:kCATransitionMoveIn];
	[animation setDuration:0.4f];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.imgView  layer] addAnimation:animation forKey:@"SwitchToView1"];
	[imgView setImage:selectedTemplate];
    
    [Flurry logEvent:@"Background Selected"];
}

/*
 * Called when select a symbol
 */
-(void)selectSymbol:(id)sender
{
    [Flurry logEvent:@"Layer Added"];
    [Flurry logEvent:@"Symbol Added"];

    // If not in delete mode then add a new frame for symbol
    if(!deleteMode){
        [self plusButtonClick];
     }else{
       // deleteMode = NO;
        doStopWobble = NO;
        
        if(rightUndoBarButton){
            [rightUndoBarButton setEnabled:YES];
        }
    }
    
    // else update the selected index of symbol
    if([[self symbolLayersArray] count] > 0){
        
        // reset flags
        symbolTouchFlag = YES;
        iconTouchFlag = NO;
        photoTouchFlag = NO;
        
        // set borders on selected symbol
        FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
        appDele.changesFlag = YES;
        UIButton *view = sender;
        selectedSymbol  =  symbolArray[(view.tag - 1)];
        CATransition *animation = [CATransition animation];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionMoveIn];
        [animation setDuration:0.4f];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];

        // Make copy of layers to undo it later
        [self makeCopyOfLayers];
        
        UIImageView *lastSymbolLayer = [self symbolLayersArray][arrangeLayerIndex];
        [[lastSymbolLayer  layer] addAnimation:animation forKey:@"SwitchToView1"];
        [lastSymbolLayer setImage:selectedSymbol];
    }
}

/*
 * Called when select icon
 */
-(void)selectIcon:(id)sender
{
    
    [Flurry logEvent:@"Layer Added"];
    [Flurry logEvent:@"Clip Art Added"];

    // If not in delete mode then add a new frame for icon
    if(!deleteMode){
        [self plusButtonClick];
    }else{
        //deleteMode = NO;
        doStopWobble = NO;
        
        if(rightUndoBarButton){
            [rightUndoBarButton setEnabled:YES];
        }
    }

    // else update the selected index of icon
    if([[self iconLayersArray] count] > 0){
        
        symbolTouchFlag = NO;
        iconTouchFlag = YES;
        photoTouchFlag = NO;
        
        FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
        appDele.changesFlag = YES;
        UIButton *view = sender;
        selectedIcon  =  iconArray[(view.tag - 1)];
        CATransition *animation = [CATransition animation];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionMoveIn];
        [animation setDuration:0.4f];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
        // Make copy of previous layers
        if(undoCount > 1){
            // Make copy of layers to undo it later
            [self makeCopyOfLayers];
        }

        UIImageView *lastIconLayer = [self iconLayersArray][arrangeLayerIndex];
        [[lastIconLayer  layer] addAnimation:animation forKey:@"SwitchToView1"];
        [lastIconLayer setImage:selectedIcon];
    }
}

int arrangeLayerIndex;

/*
 * When any layer is selected while editing flyer
 */
-(void)selectLayer:(id)sender {
    /*
	UIButton *view = sender;
    UIView *superView = [view superview];
    [self SetMenu];
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
    [l setBorderWidth:3.0];
    UIColor * c = [globle colorWithHexString:@"0197dd"];
    [l setBorderColor:c.CGColor];

    NSString *tag = [NSString stringWithFormat:@"%d",view.tag];
    
    if([tag hasPrefix:@"111"]){
        symbolTouchFlag = NO;
        iconTouchFlag = NO;
        photoTouchFlag = NO;
        lableTouchFlag = YES;
        
        arrangeLayerIndex = [self getIndexFromTag:tag];
        
        [self removeBordersFromAllLayers];
        UILabel *tempLabel = [textLabelLayersArray objectAtIndex:arrangeLayerIndex];
        CALayer * l = [tempLabel layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:10];
        [l setBorderWidth:1.0];
        [l setBorderColor:[[UIColor grayColor] CGColor]];
        [self.imgView bringSubviewToFront:[[self textLabelLayersArray] objectAtIndex:arrangeLayerIndex]];
        
    }else if([tag hasPrefix:@"222"]){
        symbolTouchFlag = NO;
        iconTouchFlag = NO;
        photoTouchFlag = YES;
        lableTouchFlag = NO;
        
        arrangeLayerIndex = [self getIndexFromTag:tag];
        
        [self removeBordersFromAllLayers];
        UIImageView *tempImgView = [photoLayersArray objectAtIndex:arrangeLayerIndex];
        CALayer * l = [tempImgView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:10];
        [l setBorderWidth:1.0];
        [l setBorderColor:[[UIColor grayColor] CGColor]];
        [self.imgView bringSubviewToFront:[[self photoLayersArray] objectAtIndex:arrangeLayerIndex]];
        
    } else if([tag hasPrefix:@"333"]){
        symbolTouchFlag = YES;
        iconTouchFlag = NO;
        photoTouchFlag = NO;
        lableTouchFlag = NO;

        arrangeLayerIndex = [self getIndexFromTag:tag];

        [self removeBordersFromAllLayers];
        UIImageView *tempImgView = [symbolLayersArray objectAtIndex:arrangeLayerIndex];
        CALayer * l = [tempImgView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:10];
        [l setBorderWidth:1.0];
        [l setBorderColor:[[UIColor grayColor] CGColor]];
        [self.imgView bringSubviewToFront:[[self symbolLayersArray] objectAtIndex:arrangeLayerIndex]];
        
    } else if([tag hasPrefix:@"444"]){
        symbolTouchFlag = NO;
        iconTouchFlag = YES;
        photoTouchFlag = NO;
        lableTouchFlag = NO;

        arrangeLayerIndex = [self getIndexFromTag:tag];
        
        [self removeBordersFromAllLayers];
        UIImageView *tempImgView = [iconLayersArray objectAtIndex:arrangeLayerIndex];
        CALayer * l = [tempImgView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:10];
        [l setBorderWidth:1.0];
        [l setBorderColor:[[UIColor grayColor] CGColor]];
        [self.imgView bringSubviewToFront:[[self iconLayersArray] objectAtIndex:arrangeLayerIndex]];        
    }
    
    deleteMode = YES;
    undoCount = undoCount + 1;
    [rightUndoBarButton setEnabled:YES];
    [self makeCopyOfLayers];
     */
}

/*
 * When any size is selected
 */
-(void)selectSize:(id)sender{
	FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
	appDele.changesFlag = YES;
	int  i=1;
	UIButton *view = sender;
	for(UIView *tempView  in [sizeScrollView subviews])
	{
		if(tempView == view)
		{
			NSString *sizeStr = SIZE_ARRAY[i-1];
			selectedSize = [sizeStr intValue];
			selectedFont = [selectedFont fontWithSize:selectedSize];
			msgTextView.font = selectedFont;
            ((CustomLabel*)[self textLabelLayersArray][arrangeLayerIndex]).font =selectedFont;
		}
		i++;
	}
}

/*
 * When any border is selected
 */
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
			UIColor *borderColor = borderArray[i-1];
            
            imgView.layer.borderColor = borderColor.CGColor;
            imgView.layer.borderWidth = 3.0;
		}
		i++;
	}
}

/*
 * When any font border is selected
 */
-(void)selectFontBorder:(id)sender
{
	FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
	appDele.changesFlag = YES;
	int  i=1;
	UIButton *view = sender;
	for(UIView *tempView  in [fontBorderScrollView subviews]) {
		if(tempView == view) {
            
			UIColor *borderColor = borderArray[i-1];
            
            CustomLabel *lastLabel = [self textLabelLayersArray][arrangeLayerIndex];
            lastLabel.borderColor = borderColor;
            lastLabel.lineWidth = 2;
            [lastLabel drawRect:CGRectMake(lastLabel.frame.origin.x, lastLabel.frame.origin.y, lastLabel.frame.size.width, lastLabel.frame.size.height)];
		}
		i++;
	}
}

/*
 * When width is selected
 */
-(void)selectWidth:(id)sender{
    
    [cameraTabButton setBackgroundImage:[UIImage imageNamed:@"07_camera"] forState:UIControlStateNormal];
    [photoTabButton setBackgroundImage:[UIImage imageNamed:@"07_roll"] forState:UIControlStateNormal];
    [widthTabButton setBackgroundImage:[UIImage imageNamed:@"07_width_selected"] forState:UIControlStateNormal];
    [heightTabButton setBackgroundImage:[UIImage imageNamed:@"07_height"] forState:UIControlStateNormal];
    [widthTabButton  setSelected:YES];
    [heightTabButton  setSelected:NO];
    
    UIImageView *lastImgView = [[self photoLayersArray] lastObject];
    lastImgView.frame = CGRectMake(lastImgView.frame.origin.x, lastImgView.frame.origin.y,lastImgView.frame.size.width-10,lastImgView.frame.size.height);
}

/*
 * When height is selected
 */
-(void)selectHeight:(id)sender{
    
    [cameraTabButton setBackgroundImage:[UIImage imageNamed:@"07_camera"] forState:UIControlStateNormal];
    [photoTabButton setBackgroundImage:[UIImage imageNamed:@"07_roll"] forState:UIControlStateNormal];
    [widthTabButton setBackgroundImage:[UIImage imageNamed:@"07_width"] forState:UIControlStateNormal];
    [heightTabButton setBackgroundImage:[UIImage imageNamed:@"07_height_selected"] forState:UIControlStateNormal];
    [widthTabButton  setSelected:NO];
    [heightTabButton  setSelected:YES];

    UIImageView *lastImgView = [[self photoLayersArray] lastObject];
    lastImgView.frame = CGRectMake(lastImgView.frame.origin.x, lastImgView.frame.origin.y,lastImgView.frame.size.width,lastImgView.frame.size.height-10);
}

/*
 * Get index from a view tag
 */
-(int)getIndexFromTag:(NSString *)tag{
    NSString *str = [tag substringWithRange:NSMakeRange(3, [tag length] - 3)];
    return [str integerValue];
}

/*
 * Layout scroll views
 */
- (void)layoutScrollImages:(UIScrollView*)selectedScrollView scrollWidth:(NSInteger)kScrollObjWidth scrollHeight:(NSInteger)kScrollObjHeight {

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
					
                if(view.userInteractionEnabled){
                    [view addTarget:self action:@selector(selectTemplate:) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    view.userInteractionEnabled = YES;
                    [view addTarget:self action:@selector(requestTemplate:) forControlEvents:UIControlEventTouchUpInside];;
                }

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

                if(view.userInteractionEnabled){
                    [view addTarget:self action:@selector(selectColor:) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    view.userInteractionEnabled = YES;
                    [view addTarget:self action:@selector(requestColor:) forControlEvents:UIControlEventTouchUpInside];
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
				
                if(view.userInteractionEnabled){
                    [view addTarget:self action:@selector(selectSize:) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    view.userInteractionEnabled = YES;
                    [view addTarget:self action:@selector(requestSize:) forControlEvents:UIControlEventTouchUpInside];
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
                
                if(view.userInteractionEnabled){
                    [view addTarget:self action:@selector(selectBorder:) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    view.userInteractionEnabled = YES;
                    [view addTarget:self action:@selector(requestFlyerBorder:) forControlEvents:UIControlEventTouchUpInside];
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
                if(view.userInteractionEnabled){
                    [view addTarget:self action:@selector(selectSymbol:) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    view.userInteractionEnabled = YES;
                    [view addTarget:self action:@selector(requestSymbols:) forControlEvents:UIControlEventTouchUpInside];
                }
				
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
                if(view.userInteractionEnabled){
                    [view addTarget:self action:@selector(selectIcon:) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    view.userInteractionEnabled = YES;
                    [view addTarget:self action:@selector(requestIcons:) forControlEvents:UIControlEventTouchUpInside];
                }

				
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

-(void)showLoadingView:(NSString *)message{
    [self showLoadingIndicator];
}

-(void)removeLoadingView{
    [self hideLoadingIndicator];
}

#pragma mark  imagePicker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {
	
	if(imgPickerFlag == 1){
		
		[[picker parentViewController] dismissModalViewControllerAnimated:YES];
		UIImage *testImage = img;
        selectedTemplate = testImage;
		[self.imgView setImage:testImage] ;
	}
	else if(imgPickerFlag == 2){
	
		[[picker parentViewController] dismissModalViewControllerAnimated:YES];
		UIImage *testImage = img;
        
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
    
    nbuGallary = [[GalleryViewController alloc] initWithNibName:@"GalleryViewController" bundle:nil];
    globle.NBUimage = nil;
    [self.navigationController pushViewController:nbuGallary animated:YES];

    
    /*
    customPhotoController = [[CustomPhotoController alloc] initWithNibName:@"CustomPhotoController" bundle:nil];
    customPhotoController.callbackObject = self;    
    customPhotoController.callbackOnComplete = @selector(onCompleteSelectingImage:);
    [self setLatestImageAndLoadPhotoLibrary];

    photoTouchFlag = YES;
    lableTouchFlag = NO;
    symbolTouchFlag= NO;
    iconTouchFlag = NO;

    [self dismissModalViewControllerAnimated:YES];
     */
    
    [Flurry logEvent:@"Custom Background"];
}

-(void)setLatestImageAndLoadPhotoLibrary{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        // Within the group enumeration block, filter to enumerate just photos.
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        // Chooses the photo at the last index. Make sure number of assets is greater than zero.
        if ( [group numberOfAssets] > 0 ) {
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
        }
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
		
		UIImage *testImage = selectedImage;
        selectedTemplate = testImage;
		[self.imgView setImage:testImage] ;
	}
	else if(self.imgPickerFlag == 2){
        
		UIImage *testImage = selectedImage;
        UIImageView *lastPhotoLayer = [[self photoLayersArray] lastObject];
        [lastPhotoLayer setImage:testImage];

		self.photoTouchFlag = YES;
		self.lableTouchFlag = NO;
        symbolTouchFlag= NO;
        iconTouchFlag = NO;
        
        if(selectedImage == nil)
            [self setAddMoreLayerTabAction:addMorePhotoTabButton];

	}
}

-(void)openCustomCamera{

    nbuCamera = [[CameraViewController alloc]initWithNibName:@"CameraViewController" bundle:nil];
    globle.NBUimage = nil;
    [self.navigationController pushViewController:nbuCamera animated:YES];

    /*
    CameraOverlayView *cameraOverlay =[[CameraOverlayView alloc] initWithNibName:@"CameraOverlayView" bundle:nil];
    cameraOverlay.photoController = self;
    self.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imgPicker.cameraOverlayView = cameraOverlay.view;
    self.imgPicker.showsCameraControls = NO;
    [self presentModalViewController:self.imgPicker animated:YES];
    */
    [Flurry logEvent:@"Custom Background"];
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
        
        selectedTemplate = img;
        [self.imgView setImage:img];
        [self dismissViewControllerAnimated:YES completion:nil];
	}
	else if(self.imgPickerFlag == 2){
        
		[picker dismissModalViewControllerAnimated:YES];
		UIImage *testImage = info[UIImagePickerControllerOriginalImage];
        
        UIImageView *lastPhotoLayer = [[self photoLayersArray] lastObject];
        [lastPhotoLayer setImage:testImage];

		self.photoTouchFlag = YES;
		self.lableTouchFlag = NO;
        symbolTouchFlag= NO;
        iconTouchFlag = NO;
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
    if (layerallow == 0) {
        if(alertView == warningAlert && buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
            [Flurry logEvent:@"Flyer Cancelled"];	
        } else if(alertView == discardAlert && buttonIndex == 1) {
        
        if(selectedAddMoreLayerTab == ADD_MORE_TEXTTAB){
            
            textLayerCount--;
            
            [msgTextView resignFirstResponder];
            [msgTextView removeFromSuperview];
            
            // Remove object from array if not in delete mode
            if(!deleteMode)
                [textLabelLayersArray removeLastObject];
            
        } else if(selectedAddMoreLayerTab == ADD_MORE_PHOTOTAB){
            
            photoLayerCount--;
            
            CALayer * lastLayer = [[[self photoLayersArray] lastObject] layer];
            [lastLayer setMasksToBounds:YES];
            [lastLayer setCornerRadius:0];
            [lastLayer setBorderWidth:0];
            [lastLayer setBorderColor:[[UIColor clearColor] CGColor]];
            
            // Remove object from array if not in delete mode
            if(!deleteMode){
                [photoLayersArray[arrangeLayerIndex] removeFromSuperview];
                [photoLayersArray removeLastObject];
            }
            
        } else if(selectedAddMoreLayerTab == ADD_MORE_SYMBOLTAB){
            [symbolLayersArray removeLastObject];
        } else if(selectedAddMoreLayerTab == ADD_MORE_ICONTAB){
            [iconLayersArray removeLastObject];
        }
        
        if(undoCount > 0) {
            undoCount = undoCount - 1;
        }
        
        discardedLayer = YES;
        [self callAddMoreLayers];
        
	} else if(alertView == deleteAlert && buttonIndex == 1) {
    
        [self deleteLayer:crossButtonGlobal overrided:nil];
        [Flurry logEvent:@"Layed Deleted"];
	} else if(alertView == inAppAlert && (buttonIndex == 0 || buttonIndex == 1 || buttonIndex == 2)) {
        
       // NSLog(@"Purchase One Font Selected");
        NSLog(@"%@",(demoPurchase.products)[buttonIndex]);
        if (![demoPurchase purchaseProduct:(demoPurchase.products)[buttonIndex]]){
            
            // Returned NO, so notify user that In-App Purchase is Disabled in their Settings.
            UIAlertView *settingsAlert = [[UIAlertView alloc] initWithTitle:@"Allow Purchases" message:@"You must first enable In-App Purchase in your iOS Settings before making this purchase." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [settingsAlert show];
        }
        
    }
    }else{
        if(alertView == warningAlert && buttonIndex == 1){
            [self setAddMoreLayerTabAction:arrangeLayerTabButton];
            
        }
    }
}

#pragma mark After ViewWillAppear Method Sequence
-(void) callMenu
{
	FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
	if(appDele.changesFlag)
	{
		warningAlert = [[UIAlertView alloc]initWithTitle:@"Unsaved Flyer" message:@"You have not saved your flyer.\nAll progress will be lost if you continue." delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Cancel",nil];
		[warningAlert show];
	}
	else
	{
		[navBar show:@"" left:@"" right:@""];
		[self.view bringSubviewToFront:navBar];
		[navBar.leftButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
		[navBar.rightButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];

		
		[self.navigationController popViewControllerAnimated:YES];
	}
	
	
}

+(UIView *)setTitleViewWithTitle:(NSString *)title rect:(CGRect)rect{
    UILabel *label = [[[UILabel alloc] initWithFrame:rect] autorelease];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:@"Symbol" size:18]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = NSLocalizedString([title uppercaseString], @"");
    [label sizeToFit];

    UIView *titleView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    [titleView addSubview:label];    
    
    return titleView;
}




-(void) chooseEdit{
    //[self resetLayerScrollView];
    // Remove border from layer thumbnail
    for(UIView *subView in [layerScrollView subviews]){
        if([subView isKindOfClass:[UIButton class]]){
            CALayer * lastLayer = [subView layer];
            [lastLayer setMasksToBounds:YES];
            [lastLayer setCornerRadius:0];
            [lastLayer setBorderWidth:0];
            [lastLayer setBorderColor:[[UIColor clearColor] CGColor]];
            [lastLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
        }
    }

    UIView *sView = editButtonGlobal.superview;
    
    FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
	appDele.changesFlag = YES;
    
    // Add border to selected layer thumbnail
    CALayer * l = [sView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10];
    [l setBorderWidth:3.0];
    UIColor * c = [globle colorWithHexString:@"0197dd"];
    [l setBorderColor:c.CGColor];
     NSString *tag = [NSString stringWithFormat:@"%d",sView.tag];
    NSLog(@"%@",tag);
    
    
    if([tag hasPrefix:@"111"]){
        symbolTouchFlag = NO;
        iconTouchFlag = NO;
        photoTouchFlag = NO;
        lableTouchFlag = YES;
        
        arrangeLayerIndex = [self getIndexFromTag:tag];
        
        [self removeBordersFromAllLayers];
        UILabel *tempLabel = textLabelLayersArray[arrangeLayerIndex];
        CALayer * l = [tempLabel layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:10];
        [l setBorderWidth:1.0];
        [l setBorderColor:[[UIColor grayColor] CGColor]];
        [self.imgView bringSubviewToFront:[self textLabelLayersArray][arrangeLayerIndex]];
        
    }else if([tag hasPrefix:@"222"]){
        symbolTouchFlag = NO;
        iconTouchFlag = NO;
        photoTouchFlag = YES;
        lableTouchFlag = NO;
        
        arrangeLayerIndex = [self getIndexFromTag:tag];
        
        [self removeBordersFromAllLayers];
        UIImageView *tempImgView = photoLayersArray[arrangeLayerIndex];
        CALayer * l = [tempImgView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:10];
        [l setBorderWidth:1.0];
        [l setBorderColor:[[UIColor grayColor] CGColor]];
        [self.imgView bringSubviewToFront:[self photoLayersArray][arrangeLayerIndex]];
        
    } else if([tag hasPrefix:@"333"]){
        symbolTouchFlag = YES;
        iconTouchFlag = NO;
        photoTouchFlag = NO;
        lableTouchFlag = NO;
        
        arrangeLayerIndex = [self getIndexFromTag:tag];
        
        [self removeBordersFromAllLayers];
        UIImageView *tempImgView = symbolLayersArray[arrangeLayerIndex];
        CALayer * l = [tempImgView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:10];
        [l setBorderWidth:1.0];
        [l setBorderColor:[[UIColor grayColor] CGColor]];
        [self.imgView bringSubviewToFront:[self symbolLayersArray][arrangeLayerIndex]];
        
    } else if([tag hasPrefix:@"444"]){
        symbolTouchFlag = NO;
        iconTouchFlag = YES;
        photoTouchFlag = NO;
        lableTouchFlag = NO;
        
        arrangeLayerIndex = [self getIndexFromTag:tag];
        
        [self removeBordersFromAllLayers];
        UIImageView *tempImgView = iconLayersArray[arrangeLayerIndex];
        CALayer * l = [tempImgView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:10];
        [l setBorderWidth:1.0];
        [l setBorderColor:[[UIColor grayColor] CGColor]];
        [self.imgView bringSubviewToFront:[self iconLayersArray][arrangeLayerIndex]];
    }
    
    deleteMode = YES;
    undoCount = undoCount + 1;
    [rightUndoBarButton setEnabled:YES];
    [self makeCopyOfLayers];
    
    
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(-65, -6, 50, 50)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"Edit Layer";
    self.navigationItem.titleView = label;
    
    UIButton *cancelButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 4, 60, 33)] autorelease];
    [cancelButton addTarget:self action:@selector(Mycancel) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor clearColor ]];
    [cancelButton setFont:[UIFont fontWithName:TITLE_FONT size:16]];
    [cancelButton setTitleColor:[globle colorWithHexString:@"84c441"]forState:UIControlStateNormal];
    cancelButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];
    
    UIButton *editButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 4, 35, 33)] autorelease];
    [editButton addTarget:self action:@selector(MyEdit) forControlEvents:UIControlEventTouchUpInside];
    [editButton setTitle:@"Edit" forState:UIControlStateNormal];
    [editButton setBackgroundColor:[UIColor clearColor ]];
    [editButton setFont:[UIFont fontWithName:TITLE_FONT size:16]];
    [editButton setTitleColor:[globle colorWithHexString:@"84c441"]forState:UIControlStateNormal];
    editButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarMenuButton = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    
    UIButton *delButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 4, 60, 33)] autorelease];
    [delButton addTarget:self action:@selector(MyDelete) forControlEvents:UIControlEventTouchUpInside];
    [delButton setTitle:@"Delete" forState:UIControlStateNormal];
    [delButton setBackgroundColor:[UIColor clearColor ]];
    [delButton setFont:[UIFont fontWithName:TITLE_FONT size:16]];
    [delButton setTitleColor:[globle colorWithHexString:@"84c441"]forState:UIControlStateNormal];
    delButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarHelpButton = [[UIBarButtonItem alloc] initWithCustomView:delButton];
    
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:leftBarMenuButton,leftBarHelpButton,nil]];

    
}-(void)chooseTemplate{
    
    deleteMode = NO;
    undoCount = 0;
    layerallow = 0;

    //[rightUndoBarButton setEnabled:NO];
    //[self makeCopyOfLayers];
    if(layerEditMessage!=nil){
        [layerEditMessage removeFromSuperview];
        layerEditMessage = nil;
    }


	
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(-65, -6, 50, 50)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"BACKGROUND";
    self.navigationItem.titleView = label;

    //self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Background" rect:CGRectMake(-65, -6, 50, 50)];
    
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
	[nextButton addTarget:self action:@selector(delaytime) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
    nextButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [backButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(callMenu) forControlEvents:UIControlEventTouchUpInside];
    backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarMenuButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [helpButton addTarget:self action:@selector(loadHelpController) forControlEvents:UIControlEventTouchUpInside];
    [helpButton setBackgroundImage:[UIImage imageNamed:@"help_icon"] forState:UIControlStateNormal];
    helpButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarHelpButton = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
    
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:leftBarMenuButton,leftBarHelpButton,nil]];
    

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4f];
	self.templateScrollView.alpha = ALPHA1;
	self.templateBckgrnd.alpha = ALPHA1;
    
    
    if(IS_IPHONE_5){
        symbolScrollView.frame= CGRectMake(-320, 413,320 ,130);
        iconScrollView.frame= CGRectMake(-320, 413,320 ,130);
        layerScrollView.frame= CGRectMake(-320, 413,320 ,130);

        self.templateScrollView.frame= CGRectMake(0, 413,320 ,130);
    }else{
        symbolScrollView.frame= CGRectMake(-320, 395,320 ,60);
        iconScrollView.frame= CGRectMake(-320, 395,320 ,60);
        layerScrollView.frame= CGRectMake(-320, 395,320 ,60);

        self.templateScrollView.frame= CGRectMake(0, 395,320 ,60);
    }
    
    ((CustomLabel *)[[self textLabelLayersArray] lastObject]).alpha = 1;
	textBackgrnd.alpha  =ALPHA0;
	fontTabButton.alpha = ALPHA0;
	colorTabButton.alpha = ALPHA0;
	sizeTabButton.alpha = ALPHA0;
	borderTabButton.alpha = ALPHA0;
	fontBorderTabButton.alpha = ALPHA0;
    
    cameraTabButton.alpha = ALPHA0;
    photoTabButton.alpha = ALPHA0;
    widthTabButton.alpha = ALPHA0;
    heightTabButton.alpha = ALPHA0;
    
    self.addMoreFontTabButton.alpha = ALPHA0;
    self.addMoreIconTabButton.alpha = ALPHA0;
    self.addMorePhotoTabButton.alpha = ALPHA0;
    self.addMoreSymbolTabButton.alpha = ALPHA0;
    self.arrangeLayerTabButton.alpha = ALPHA0;


    photoTouchFlag = NO;
	lableTouchFlag = NO;
    symbolTouchFlag = NO;
    iconTouchFlag = NO;
	imgPickerFlag = 1;
    
    [self hideAddMoreAndSaveLabel];
    [self hideTakeOrAddPhotoLabel];
    [self hideAddMoreButton];
    [self hideAddMoreTab];
    [self showPictureTab];
    
	[msgTextView removeFromSuperview];
	[UIView commitAnimations];
}

-(void)loadHelpController{
    [self hideAddMoreTab];
    HelpController *helpController = [[HelpController alloc]initWithNibName:@"HelpController" bundle:nil];
    [self.navigationController pushViewController:helpController animated:NO];
    [self chooseTemplate];
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
    addMoreFontTabButton.hidden = YES;
}
-(void)showAddMoreTab{
    [self.addMoreFontTabButton setHidden:NO];
    [self.addMorePhotoTabButton setHidden:NO];
    [self.addMoreSymbolTabButton setHidden:NO];
    [self.addMoreIconTabButton setHidden:NO];
    [self.arrangeLayerTabButton setHidden:NO];
}
-(void)hideAddMoreAndSaveLabel{
    [self.addMoreLayerOrSaveFlyerLabel setHidden:YES];
}
-(void)showAddMoreAndSaveLabel{
    [self.addMoreLayerOrSaveFlyerLabel setHidden:NO];
}

-(void)hideTakeOrAddPhotoLabel{
    [self.takeOrAddPhotoLabel setHidden:YES];
}
-(void)showTakeOrAddPhotoLabel{
    [self.takeOrAddPhotoLabel setHidden:NO];
}

-(void)cancelLayer{
    
    if(layerEditMessage!=nil){
        [layerEditMessage removeFromSuperview];
        layerEditMessage = nil;
    }

    discardAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Do you want to go back? You will lose unsaved changes" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES" ,nil];
    [discardAlert show];
}

-(void)callWrite{
    
    if(layerEditMessage!=nil){
        [layerEditMessage removeFromSuperview];
        layerEditMessage = nil;
    }

	photoTouchFlag=NO;
	lableTouchFlag=NO;
    symbolTouchFlag= NO;
    iconTouchFlag = NO;

    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(-45, -6, 50, 50)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"ADD TEXT";
    self.navigationItem.titleView = label;
    //self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Add Text" rect:CGRectMake(-45, -6, 50, 50)];

    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
	[nextButton addTarget:self action:@selector(callStyle) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
    nextButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
	[backButton addTarget:self action:@selector(cancelLayer) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
     backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];

    [self hidePictureTab];
    [self hideAddMoreButton];
    [self hideAddMoreAndSaveLabel];
    [self hideTakeOrAddPhotoLabel];
    [self hideAddMoreTab];

    UITextView *lastTextView = msgTextView;
	lastTextView.font = [UIFont fontWithName:@"Arial" size:16];
	lastTextView.textColor = [UIColor blackColor];

    // Make copy of layers to undo it later
    [self makeCopyOfLayers];
    
    CustomLabel *lastLabelView = [self textLabelLayersArray][arrangeLayerIndex];
    
    selectedColor = lastLabelView.textColor;

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
   // lastTextView.frame = CGRectMake(lastLabelView.frame.origin.x, lastLabelView.frame.origin.y,  lastLabelView.frame.size.width,  lastLabelView.frame.size.height);
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
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(-45, -6, 50, 50)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"ADD TEXT";
    self.navigationItem.titleView = label;
    //self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Add Text" rect:CGRectMake(-45, -6, 50, 50)];

    if(selectedAddMoreLayerTab == -1){
        UIButton *photoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        [photoButton addTarget:self action:@selector(choosePhoto) forControlEvents:UIControlEventTouchUpInside];
        [photoButton setBackgroundImage:[UIImage imageNamed:@"photo_button"] forState:UIControlStateNormal];
        photoButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:photoButton];
        
        [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];
    } else {
        UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
 //       doneButton.titleLabel.font = [UIFont fontWithName:@"Signika-Semibold" size:13];
//        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(callAddMoreLayers) forControlEvents:UIControlEventTouchUpInside];
        [doneButton addTarget:self action:@selector(logLayerAddedEvent) forControlEvents:UIControlEventTouchUpInside];
        [doneButton addTarget:self action:@selector(logTextAddedEvent) forControlEvents:UIControlEventTouchUpInside];
        [doneButton setBackgroundImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
         doneButton.showsTouchWhenHighlighted = YES;
        [doneButton setBackgroundColor:[UIColor clearColor ]];
        [doneButton setFont:[UIFont fontWithName:TITLE_FONT size:16]];
        [doneButton setTitleColor:[globle colorWithHexString:@"84c441"]forState:UIControlStateNormal];
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
        [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];
    } 
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [backButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	[backButton addTarget:self action:@selector(callWrite) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
     backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];

    [self hidePictureTab];
    [self hideAddMoreButton];
    [self hideAddMoreAndSaveLabel];
    [self hideTakeOrAddPhotoLabel];

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
    CustomLabel *lastLabelView = [self textLabelLayersArray][arrangeLayerIndex];
	lastLabelView.alpha=1;	
	cameraTabButton.alpha = ALPHA0;
	photoTabButton.alpha = ALPHA0;
	widthTabButton.alpha = ALPHA0;
	heightTabButton.alpha = ALPHA0;
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
	  
//	lableLocation = CGPointMake(lastLabelView.frame.origin.x,lastLabelView.frame.origin.y);
	lastLabelView.frame = CGRectMake(lastLabelView.frame.origin.x, lastLabelView.frame.origin.y, lastLabelView.frame.size.width, lastLabelView.frame.size.height);
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
    if(layerEditMessage!=nil){
        [layerEditMessage removeFromSuperview];
        layerEditMessage = nil;
    }
    //self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Add photo" rect:CGRectMake(-45, -6, 50, 50)];
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(-45, -6, 50, 50)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"ADD PHOTO";
    self.navigationItem.titleView = label;
    

    
    if(selectedAddMoreLayerTab == -1){
        UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
        shareButton.titleLabel.font = [UIFont fontWithName:@"Signika-Semibold" size:13];
        [shareButton addTarget:self action:@selector(callSaveAndShare) forControlEvents:UIControlEventTouchUpInside];
        [shareButton setBackgroundImage:[UIImage imageNamed:@"share_button"] forState:UIControlStateNormal];
        shareButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
        [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];
    } else {
        UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
        //doneButton.titleLabel.font = [UIFont fontWithName:@"Signika-Semibold" size:13];
        //[doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(callAddMoreLayers) forControlEvents:UIControlEventTouchUpInside];
        [doneButton addTarget:self action:@selector(logLayerAddedEvent) forControlEvents:UIControlEventTouchUpInside];
        [doneButton addTarget:self action:@selector(logPhotoAddedEvent) forControlEvents:UIControlEventTouchUpInside];
        [doneButton setBackgroundImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
        [doneButton setBackgroundColor:[UIColor clearColor ]];
        [doneButton setFont:[UIFont fontWithName:TITLE_FONT size:16]];
        [doneButton setTitleColor:[globle colorWithHexString:@"84c441"]forState:UIControlStateNormal];
        doneButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
        [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];
    }

    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [backButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	[backButton addTarget:self action:@selector(cancelLayer) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
     backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];

    // Make Copy of layers
    if(undoCount > 1){
        // Make copy of layers to undo it later
        [self makeCopyOfLayers];
    }

    [self hidePictureTab];
    [self hideAddMoreButton];
    [self hideAddMoreAndSaveLabel];
    [self hideAddMoreTab];
    [self showTakeOrAddPhotoLabel];

    CALayer * l = [[self  photoLayersArray][arrangeLayerIndex] layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10];
    [l setBorderWidth:1.0];
    [l setBorderColor:[[UIColor grayColor] CGColor]];
    [self.imgView addSubview:[self  photoLayersArray][arrangeLayerIndex]];
	
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
	textBackgrnd.alpha = ALPHA1;
	[UIView commitAnimations];
	
    UIPinchGestureRecognizer *twoFingerPinch =
    [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerPinch:)] autorelease];
    [[self view] addGestureRecognizer:twoFingerPinch];
    
	lableTouchFlag = NO;
	photoTouchFlag = YES;
    symbolTouchFlag= NO;
    iconTouchFlag = NO;
    [self.imgView sendSubviewToBack:[self  photoLayersArray][arrangeLayerIndex]];
	[self.imgView bringSubviewToFront:[[self textLabelLayersArray] lastObject]];
}

/*
 * Make copy of layers to undo it later
 */
-(void)makeCopyOfLayers{
    // Make copy of previous layers
    if(flyerNumber == -1 && undoCount == 1){
        // 1) If flyerNumber is -1 (i.e. no flyerNumber is assigned and this is a new flyer)
        // 2) Undo is done for the first time
        [self makeCopyOfLayers:YES];
    } else if(undoCount > 1){
        // Make copy of previous layers
        //[self makeCopyOfLayers:YES];
    }
}

/*
 * Make copy of layers to undo it later
 */
-(void)makeCopyOfLayers:(BOOL)forceCopy{
    
    if(!self.cpyTextLabelLayersArray){
        self.cpyTextLabelLayersArray = [[NSMutableArray alloc] init];
    }
    if(!self.cpyIconLayersArray){
        self.cpyIconLayersArray = [[NSMutableArray alloc] init];
    }
    if(!self.cpyPhotoLayersArray){
        self.cpyPhotoLayersArray = [[NSMutableArray alloc] init];
    }
    if(!self.cpySymbolLayersArray){
        self.cpySymbolLayersArray = [[NSMutableArray alloc] init];
    }
    
    [self.cpyTextLabelLayersArray removeAllObjects];
    [self.cpyIconLayersArray removeAllObjects];
    [self.cpyPhotoLayersArray removeAllObjects];
    [self.cpySymbolLayersArray removeAllObjects];
    

    for(CustomLabel *label in textLabelLayersArray){
        [self.cpyTextLabelLayersArray addObject:[NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:label]]];
     }

    for(UIImageView *symbolImage in symbolLayersArray){
        [self.cpySymbolLayersArray addObject:[NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:symbolImage]]];
    }
    for(UIImageView *iconImage in iconLayersArray){
        [self.cpyIconLayersArray addObject:[NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:iconImage]]];
    }
    for(UIImageView *photoImage in photoLayersArray){
        [self.cpyPhotoLayersArray addObject:[NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:photoImage]]];
    }
}

-(void)undo:(UIButton *)undoButton{
    
    [textLabelLayersArray removeAllObjects];
    [symbolLayersArray removeAllObjects];
    [iconLayersArray removeAllObjects];
    [photoLayersArray removeAllObjects];

    for(CustomLabel *label in self.cpyTextLabelLayersArray){
        [textLabelLayersArray addObject:[NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:label]]];
    }
    for(UIImageView *symbolImage in self.cpySymbolLayersArray){
        [symbolLayersArray addObject:[NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:symbolImage]]];
    }
    for(UIImageView *iconImage in self.cpyIconLayersArray){
        [iconLayersArray addObject:[NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:iconImage]]];
    }
    for(UIImageView *photoImage in self.cpyPhotoLayersArray){
        [photoLayersArray addObject:[NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:photoImage]]];
    }
    
    if(undoCount >= 1){
        [rightUndoBarButton setEnabled:NO];
        undoCount = 0;
    }
    
    // RESET image view
    [self resetImageview];

    // RESET layers scroll view to show the undo layer again
    [self resetLayerScrollView];
    
    [Flurry logEvent:@"Undone"];

}

/*
 * This method is called when:
 * 1) Next is pressed from select template screen
 * 2) When any layer is Edited or Discard Editing
 */
-(void)delaytime{
    [NSTimer scheduledTimerWithTimeInterval:0.6
                                     target:self
                                   selector:@selector(callAddMoreLayers)
                                   userInfo:nil
                                    repeats:NO];
}

-(void)callAddMoreLayers {
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(-30, -6, 50, 50)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"LAYERS";
    self.navigationItem.titleView = label;
    //self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"layers" rect:CGRectMake(-30, -6, 50, 50)];
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    saveButton.titleLabel.font = [UIFont fontWithName:@"Signika-Semibold" size:13];
	[saveButton addTarget:self action:@selector(callSaveAndShare) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"share_button"] forState:UIControlStateNormal];
    saveButton.showsTouchWhenHighlighted = YES;
    UIButton *undoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    undoButton.titleLabel.font = [UIFont fontWithName:@"Signika-Semibold" size:13];
	[undoButton addTarget:self action:@selector(undo:) forControlEvents:UIControlEventTouchUpInside];
    [undoButton setBackgroundImage:[UIImage imageNamed:@"undo"] forState:UIControlStateNormal];
    undoButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    rightUndoBarButton = [[UIBarButtonItem alloc] initWithCustomView:undoButton];
    if(undoCount <= 0){
        [rightUndoBarButton setEnabled:NO];
        undoCount = 0;
    }

    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,rightUndoBarButton,nil]];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [backButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	[backButton addTarget:self action:@selector(chooseTemplate) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
     backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    
    [self showAddMoreTab];
    [self showAddMoreAndSaveLabel];
    [self hidePictureTab];
    [self hideAddMoreButton];
    [self hideTakeOrAddPhotoLabel];

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
    
    // Changes
    [addMoreFontTabButton setTitle:@"Text" forState:UIControlStateNormal];
    [addMoreFontTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
    addMoreFontTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    
    [addMorePhotoTabButton setTitle:@"Photo" forState:UIControlStateNormal];
    [addMorePhotoTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
    addMorePhotoTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    
    [addMoreSymbolTabButton setTitle:@"Clipart" forState:UIControlStateNormal];
    [addMoreSymbolTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
    addMoreSymbolTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    
    [arrangeLayerTabButton setTitle:@"Edit" forState:UIControlStateNormal];
    [arrangeLayerTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
    arrangeLayerTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    
    [addMoreIconTabButton setTitle:@"Symbols" forState:UIControlStateNormal];
    [addMoreIconTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
    addMoreIconTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    
    [cameraTabButton setTitle:@"Camera" forState:UIControlStateNormal];
    [cameraTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
    cameraTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    [cameraTabButton.titleLabel setTextColor:[UIColor whiteColor]];
    
    [photoTabButton setTitle:@"Gallery" forState:UIControlStateNormal];
    [photoTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
    photoTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    photoTabButton.titleLabel.textColor = [UIColor whiteColor];

    [widthTabButton setTitle:@"Width" forState:UIControlStateNormal];
    [widthTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
    widthTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    [widthTabButton.titleLabel setTextColor:[UIColor whiteColor]];
    
    [heightTabButton setTitle:@"Height" forState:UIControlStateNormal];
    [heightTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
    heightTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    [heightTabButton.titleLabel setTextColor:[UIColor whiteColor]];
    

    [addMorePhotoTabButton setBackgroundImage:[UIImage imageNamed:@"image_icon_selected"] forState:UIControlStateHighlighted];
    [addMoreFontTabButton setBackgroundImage:[UIImage imageNamed:@"text_icon_selected"] forState:UIControlStateHighlighted];
    [addMoreSymbolTabButton setBackgroundImage:[UIImage imageNamed:@"symbolicon_button_selected"] forState:UIControlStateHighlighted];
    
    [addMoreIconTabButton setBackgroundImage:[UIImage imageNamed:@"icon_button_selected"] forState:UIControlStateHighlighted];
    
    [arrangeLayerTabButton setBackgroundImage:[UIImage imageNamed:@"arrangeicon_button_selected"] forState:UIControlStateHighlighted];

    
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

    [symbolScrollView setAlpha:ALPHA0];
    [iconScrollView setAlpha:ALPHA0];
    [layerScrollView setAlpha:ALPHA0];

    addMoreFontTabButton.alpha = ALPHA1;
	addMorePhotoTabButton.alpha = ALPHA1;
	addMoreSymbolTabButton.alpha = ALPHA1;
	addMoreIconTabButton.alpha = ALPHA1;
	arrangeLayerTabButton.alpha = ALPHA1;

    selectedAddMoreLayerTab = ADD_MORE_TEXTTAB;
    discardedLayer = NO;

    [UIView commitAnimations];    
}

CGRect initialBounds;

- (void)twoFingerPinch:(UIPinchGestureRecognizer *)gestureRecognizer
{
    
    UIImageView *lastImgView = [self photoLayersArray][arrangeLayerIndex];
    
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
    if(layerEditMessage!=nil){
        [layerEditMessage removeFromSuperview];
        layerEditMessage = nil;
    }

    [Flurry logEvent:@"Saved Flyer"];

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
   // UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(callMenu)];
    //[self.navigationItem setRightBarButtonItem:rightBarButton];
    [self hidePictureTab];
    [self hideAddMoreButton];
    [self hideAddMoreAndSaveLabel];
    [self hideTakeOrAddPhotoLabel];

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
    ((CustomLabel *)[[self textLabelLayersArray] lastObject]).alpha = 1;

    FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
     
    NSData *data = [self getCurrentFrameAndSaveIt];
    [self showHUD];
    appDele.changesFlag = NO;

    DraftViewController *draftViewController = [[DraftViewController alloc] initWithNibName:@"DraftViewController" bundle:nil];
    draftViewController.fromPhotoController = YES;
    draftViewController.selectedFlyerImage = [UIImage imageWithData:data];
    draftViewController.selectedFlyerTitle = globle.FlyerName;
    if([[self textLabelLayersArray] count] > 0){
        draftViewController.selectedFlyerDescription = ((CustomLabel*)[self textLabelLayersArray][0]).text;
    }else{
        draftViewController.selectedFlyerDescription = @"";
    }

    draftViewController.imageFileName = finalImgWritePath;
    draftViewController.detailFileName = [finalImgWritePath stringByReplacingOccurrencesOfString:@".jpg" withString:@".txt"];
    [self.navigationController pushViewController:draftViewController animated:YES];
    [draftViewController release];    
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
	[svController release];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSLog(@"Purchase One Font Selected");
    
    if (![demoPurchase purchaseProduct:(demoPurchase.products)[buttonIndex]]){
        
        // Returned NO, so notify user that In-App Purchase is Disabled in their Settings.
        UIAlertView *settingsAlert = [[UIAlertView alloc] initWithTitle:@"Allow Purchases" message:@"You must first enable In-App Purchase in your iOS Settings before making this purchase." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [settingsAlert show];        
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
		[colorTabButton setBackgroundImage:[UIImage imageNamed:@"color_button"] forState:UIControlStateNormal];
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
        [borderTabButton setBackgroundImage:[UIImage imageNamed:@"outline_button"] forState:UIControlStateNormal];
		[fontTabButton setBackgroundImage:[UIImage imageNamed:@"font_button"] forState:UIControlStateNormal];
		[colorTabButton setBackgroundImage:[UIImage imageNamed:@"color_button_selected"] forState:UIControlStateNormal];
		[sizeTabButton setBackgroundImage:[UIImage imageNamed:@"size_button"] forState:UIControlStateNormal];
	
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
		[colorTabButton setBackgroundImage:[UIImage imageNamed:@"color_button"] forState:UIControlStateNormal];
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
		[colorTabButton setBackgroundImage:[UIImage imageNamed:@"color_button"] forState:UIControlStateNormal];
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
		[colorTabButton setBackgroundImage:[UIImage imageNamed:@"color_button"] forState:UIControlStateNormal];
		[sizeTabButton setBackgroundImage:[UIImage imageNamed:@"size_button"] forState:UIControlStateNormal];
		[borderTabButton setBackgroundImage:[UIImage imageNamed:@"outline_button"] forState:UIControlStateNormal];
		[fontBorderTabButton setBackgroundImage:[UIImage imageNamed:@"background_button_selected"] forState:UIControlStateNormal];
		[UIView commitAnimations];
	}
}

-(void) setAddMoreLayerTabAction:(id) sender {
    layerallow = 0;
    
    if(layerEditMessage!=nil){
        [layerEditMessage removeFromSuperview];
        layerEditMessage = nil;
    }

	UIButton *selectedButton = (UIButton*)sender;

    // Set wobble and delete mode to NO when tab other then arrange layer is selected
    //if(selectedButton != arrangeLayerTabButton){
    //    doStopWobble = NO;
    //    deleteMode = NO;
    //}

    // If layers are wobbling and arrange layer tab is selected then stop layer wobbling
    if(doStopWobble && deleteMode && selectedButton == arrangeLayerTabButton){
        //NSLog(@"Un Wobble All Layers !");
        
        //[self unWobbleAll];
        //return;
    }
    
    if(undoCount >= 1){
        [rightUndoBarButton setEnabled:YES];
    }

	if(selectedButton == addMoreFontTabButton)
	{
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(-30, -6, 50, 50)] autorelease];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:TITLE_FONT size:18];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = @"LAYERS";
        self.navigationItem.titleView = label;
        [self SetMenu];

        //self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"layers" rect:CGRectMake(-30, -6, 50, 50)];
        selectedAddMoreLayerTab = ADD_MORE_TEXTTAB;
        [self hideAddMoreAndSaveLabel];
        [self hideTakeOrAddPhotoLabel];

        symbolTouchFlag= NO;
        photoTouchFlag = NO;
        iconTouchFlag = NO;
        lableTouchFlag = YES;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4f];
        
        [addMorePhotoTabButton setBackgroundImage:[UIImage imageNamed:@"image_icon_selected"] forState:UIControlStateHighlighted];
        [addMoreFontTabButton setBackgroundImage:[UIImage imageNamed:@"text_icon_selected"] forState:UIControlStateNormal];
        [addMoreSymbolTabButton setBackgroundImage:[UIImage imageNamed:@"symbolicon_button_selected"] forState:UIControlStateHighlighted];
        
        [addMoreIconTabButton setBackgroundImage:[UIImage imageNamed:@"icon_button_selected"] forState:UIControlStateHighlighted];
        
        [arrangeLayerTabButton setBackgroundImage:[UIImage imageNamed:@"arrangeicon_button_selected"] forState:UIControlStateHighlighted];

        [addMorePhotoTabButton setBackgroundImage:[UIImage imageNamed:@"image_icon"] forState:UIControlStateNormal];
        [addMoreSymbolTabButton setBackgroundImage:[UIImage imageNamed:@"symbolicon_button"] forState:UIControlStateNormal];
        [addMoreIconTabButton setBackgroundImage:[UIImage imageNamed:@"icon_button"] forState:UIControlStateNormal];
        [arrangeLayerTabButton setBackgroundImage:[UIImage imageNamed:@"arrangeicon_button"] forState:UIControlStateNormal];
        
        // Changes
        [addMoreFontTabButton setTitle:@"Text" forState:UIControlStateNormal];
        [addMoreFontTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
        addMoreFontTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        
        [addMorePhotoTabButton setTitle:@"Photo" forState:UIControlStateNormal];
        [addMorePhotoTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
        addMorePhotoTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        
        [addMoreSymbolTabButton setTitle:@"Clipart" forState:UIControlStateNormal];
        [addMoreSymbolTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
        addMoreSymbolTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        
        [arrangeLayerTabButton setTitle:@"Edit" forState:UIControlStateNormal];
        [arrangeLayerTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
        arrangeLayerTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        
        [addMoreIconTabButton setTitle:@"Symbols" forState:UIControlStateNormal];
        [addMoreIconTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
        addMoreIconTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;


        [UIView commitAnimations];
        
        [self plusButtonClick];
	}
	else if(selectedButton == addMorePhotoTabButton)
	{
        //self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"layers" rect:CGRectMake(-30, -6, 50, 50)];
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(-30, -6, 50, 50)] autorelease];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:TITLE_FONT size:18];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = @"LAYERS";
        self.navigationItem.titleView = label;
        [self SetMenu];
        selectedAddMoreLayerTab = ADD_MORE_PHOTOTAB;
        [self hideAddMoreAndSaveLabel];
        if ([self canAddMoreLayers]) {
            [self showTakeOrAddPhotoLabel];
        }

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
        [addMorePhotoTabButton setBackgroundImage:[UIImage imageNamed:@"image_icon_selected"] forState:UIControlStateNormal];
        [addMoreFontTabButton setBackgroundImage:[UIImage imageNamed:@"text_icon_selected"] forState:UIControlStateHighlighted];
        [addMoreSymbolTabButton setBackgroundImage:[UIImage imageNamed:@"symbolicon_button_selected"] forState:UIControlStateHighlighted];
        
        [addMoreIconTabButton setBackgroundImage:[UIImage imageNamed:@"icon_button_selected"] forState:UIControlStateHighlighted];
        
        [arrangeLayerTabButton setBackgroundImage:[UIImage imageNamed:@"arrangeicon_button_selected"] forState:UIControlStateHighlighted];


        [addMoreFontTabButton setBackgroundImage:[UIImage imageNamed:@"text_icon"] forState:UIControlStateNormal];
        
        [addMoreSymbolTabButton setBackgroundImage:[UIImage imageNamed:@"symbolicon_button"] forState:UIControlStateNormal];
        [addMoreIconTabButton setBackgroundImage:[UIImage imageNamed:@"icon_button"] forState:UIControlStateNormal];
        [arrangeLayerTabButton setBackgroundImage:[UIImage imageNamed:@"arrangeicon_button"] forState:UIControlStateNormal];
        // Changes
        [addMoreFontTabButton setTitle:@"Text" forState:UIControlStateNormal];
        [addMoreFontTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
        addMoreFontTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        
        [addMorePhotoTabButton setTitle:@"Photo" forState:UIControlStateNormal];
        [addMorePhotoTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
        addMorePhotoTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        
        [addMoreSymbolTabButton setTitle:@"Clipart" forState:UIControlStateNormal];
        [addMoreSymbolTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
        addMoreSymbolTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        
        [arrangeLayerTabButton setTitle:@"Edit" forState:UIControlStateNormal];
        [arrangeLayerTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
        arrangeLayerTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        
        [addMoreIconTabButton setTitle:@"Symbols" forState:UIControlStateNormal];
        [addMoreIconTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
        addMoreIconTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;


		[UIView commitAnimations];
        
        [self plusButtonClick];

		//[self loadCustomPhotoLibrary];
	}
	else if(selectedButton == addMoreSymbolTabButton)
	{
        //self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"layers" rect:CGRectMake(-30, -6, 50, 50)];
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(-30, -6, 50, 50)] autorelease];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:TITLE_FONT size:18];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = @"LAYERS";
        self.navigationItem.titleView = label;
        [self SetMenu];
        selectedAddMoreLayerTab = ADD_MORE_SYMBOLTAB;
        [self hideAddMoreAndSaveLabel];
        [self hideTakeOrAddPhotoLabel];

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
        
        [addMorePhotoTabButton setBackgroundImage:[UIImage imageNamed:@"image_icon_selected"] forState:UIControlStateNormal];
        [addMoreFontTabButton setBackgroundImage:[UIImage imageNamed:@"text_icon_selected"] forState:UIControlStateHighlighted];
        
        [addMoreSymbolTabButton setBackgroundImage:[UIImage imageNamed:@"symbolicon_button_selected"] forState:UIControlStateNormal];
        
        [addMoreIconTabButton setBackgroundImage:[UIImage imageNamed:@"icon_button_selected"] forState:UIControlStateHighlighted];
        
        [arrangeLayerTabButton setBackgroundImage:[UIImage imageNamed:@"arrangeicon_button_selected"] forState:UIControlStateHighlighted];


        [addMoreFontTabButton setBackgroundImage:[UIImage imageNamed:@"text_icon"] forState:UIControlStateNormal];
        [addMoreFontTabButton setTitle:@"TEXT" forState:UIControlStateNormal];

        [addMorePhotoTabButton setBackgroundImage:[UIImage imageNamed:@"image_icon"] forState:UIControlStateNormal];
        [addMoreIconTabButton setBackgroundImage:[UIImage imageNamed:@"icon_button"] forState:UIControlStateNormal];
        [arrangeLayerTabButton setBackgroundImage:[UIImage imageNamed:@"arrangeicon_button"] forState:UIControlStateNormal];
        
        // Changes
        [addMoreFontTabButton setTitle:@"Text" forState:UIControlStateNormal];
        [addMoreFontTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
        addMoreFontTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        
        [addMorePhotoTabButton setTitle:@"Photo" forState:UIControlStateNormal];
        [addMorePhotoTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
        addMorePhotoTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        
        [addMoreSymbolTabButton setTitle:@"Clipart" forState:UIControlStateNormal];
        [addMoreSymbolTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
        addMoreSymbolTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        
        [arrangeLayerTabButton setTitle:@"Edit" forState:UIControlStateNormal];
        [arrangeLayerTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
        arrangeLayerTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        
        [addMoreIconTabButton setTitle:@"Symbols" forState:UIControlStateNormal];
        [addMoreIconTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
        addMoreIconTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;


		[UIView commitAnimations];
	}
	else if(selectedButton == addMoreIconTabButton)
	{
        //self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"layers" rect:CGRectMake(-30, -6, 50, 50)];
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(-30, -6, 50, 50)] autorelease];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:TITLE_FONT size:18];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = @"LAYERS";
        self.navigationItem.titleView = label;
        [self SetMenu];

        selectedAddMoreLayerTab = ADD_MORE_ICONTAB;
        [self hideAddMoreAndSaveLabel];
        [self hideTakeOrAddPhotoLabel];

        lableTouchFlag = NO;
        symbolTouchFlag= NO;
        //photoTouchFlag= NO;
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
        
        [addMorePhotoTabButton setBackgroundImage:[UIImage imageNamed:@"image_icon_selected"] forState:UIControlStateHighlighted];
        [addMoreFontTabButton setBackgroundImage:[UIImage imageNamed:@"text_icon_selected"] forState:UIControlStateHighlighted];
        [addMoreSymbolTabButton setBackgroundImage:[UIImage imageNamed:@"symbolicon_button_selected"] forState:UIControlStateHighlighted];
        
        [addMoreIconTabButton setBackgroundImage:[UIImage imageNamed:@"icon_button_selected"] forState:UIControlStateNormal];
        
        [arrangeLayerTabButton setBackgroundImage:[UIImage imageNamed:@"arrangeicon_button_selected"] forState:UIControlStateHighlighted];


        [addMoreFontTabButton setBackgroundImage:[UIImage imageNamed:@"text_icon"] forState:UIControlStateNormal];
        [addMoreFontTabButton setTitle:@"TEXT" forState:UIControlStateNormal];
        [addMorePhotoTabButton setBackgroundImage:[UIImage imageNamed:@"image_icon"] forState:UIControlStateNormal];
        [addMoreSymbolTabButton setBackgroundImage:[UIImage imageNamed:@"symbolicon_button"] forState:UIControlStateNormal];
        [arrangeLayerTabButton setBackgroundImage:[UIImage imageNamed:@"arrangeicon_button"] forState:UIControlStateNormal];
        
        // Changes
        [addMoreFontTabButton setTitle:@"Text" forState:UIControlStateNormal];
        [addMoreFontTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
        addMoreFontTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        
        [addMorePhotoTabButton setTitle:@"Photo" forState:UIControlStateNormal];
        [addMorePhotoTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
        addMorePhotoTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        
        [addMoreSymbolTabButton setTitle:@"Clipart" forState:UIControlStateNormal];
        [addMoreSymbolTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
        addMoreSymbolTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        
        [arrangeLayerTabButton setTitle:@"Edit" forState:UIControlStateNormal];
        [arrangeLayerTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
        arrangeLayerTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        
        [addMoreIconTabButton setTitle:@"Symbols" forState:UIControlStateNormal];
        [addMoreIconTabButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 12.0]];
        addMoreIconTabButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;

        
		[UIView commitAnimations];
	}
	else if(selectedButton == arrangeLayerTabButton)
	{
        [self SetMenu];
        layerallow = 0 ;
        [arrangeLayerTabButton setBackgroundImage:[UIImage imageNamed:@"arrangeicon_button_selected"] forState:UIControlStateNormal];
        [addMoreFontTabButton setBackgroundImage:[UIImage imageNamed:@"text_icon"] forState:UIControlStateNormal];
        [addMorePhotoTabButton setBackgroundImage:[UIImage imageNamed:@"image_icon"] forState:UIControlStateNormal];
        [addMoreSymbolTabButton setBackgroundImage:[UIImage imageNamed:@"symbolicon_button"] forState:UIControlStateNormal];
        [addMoreIconTabButton setBackgroundImage:[UIImage imageNamed:@"icon_button"] forState:UIControlStateNormal];

        // Layer handling message
        
        if(layerEditMessage==nil){
            layerEditMessage = [[NSBundle mainBundle] loadNibNamed:@"ShareProgressView" owner:self options:nil][0];
            [layerEditMessage setFrame:CGRectMake(layerEditMessage.frame.origin.x, 320, layerEditMessage.frame.size.width, layerEditMessage.frame.size.height+2)];
        
            // border radius
            [layerEditMessage setAlpha:0.8];
              globle = [Singleton RetrieveSingleton];
            [layerEditMessage setBackgroundColor:[globle colorWithHexString:@"84c341 "]];
        
            [layerEditMessage.statusText setBounds:CGRectMake(layerEditMessage.frame.origin.x, 321, layerEditMessage.frame.size.width-55, layerEditMessage.frame.size.height-1)];
            [layerEditMessage.statusText setTextColor:[UIColor whiteColor]];
            [layerEditMessage.statusText setTextAlignment:NSTextAlignmentCenter];
            [layerEditMessage.statusText setLineBreakMode:NSLineBreakByWordWrapping];
            [layerEditMessage.statusText setNumberOfLines:0];
            [layerEditMessage.statusText setText:@"ADJUST, EDIT OR DELETE LAYERS HERE."];
            
            [layerEditMessage.networkIcon removeFromSuperview];
            [layerEditMessage.statusIcon removeFromSuperview];
            [layerEditMessage.refreshIcon removeFromSuperview];
        
            [self.view addSubview:layerEditMessage];
        }
        
        //self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"layers" rect:CGRectMake(-30, -6, 50, 50)];
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(-30, -6, 50, 50)] autorelease];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:TITLE_FONT size:18];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = @"LAYERS";
        self.navigationItem.titleView = label;

        selectedAddMoreLayerTab = ARRANGE_LAYERTAB;
        [self removeBordersFromAllLayers];
        [self hideAddMoreAndSaveLabel];
        [self hideTakeOrAddPhotoLabel];

        lableTouchFlag = NO;
        symbolTouchFlag= NO;
        iconTouchFlag = NO;
        photoTouchFlag = NO;
        
        if(layerScrollView){
            [layerScrollView removeFromSuperview];
        }
        layerScrollView = nil;
        layerScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-320, 385,320,44)];

        NSInteger layerScrollWidth = 60;
        NSInteger layerScrollHeight = 55;
        
        if(textLabelLayersArray){
            //NSLog(@"Text Layers %d", [textLabelLayersArray count]);

            for(int text=0; text<[textLabelLayersArray count]; text++){
                
                UILabel *label1 = (UILabel *) textLabelLayersArray[text];
                UILabel *label = [[UILabel alloc] initWithFrame:label1.frame];
                label.text = label1.text;
                
                UIButton *layerButton = [UIButton  buttonWithType:UIButtonTypeCustom];
                layerButton.frame =CGRectMake(0, 5,layerScrollWidth, layerScrollHeight);
                [layerButton setBackgroundColor:[UIColor clearColor]];
                
                label.frame  = CGRectMake(layerButton.frame.origin.x+5, layerButton.frame.origin.y-2, layerButton.frame.size.width-10, layerButton.frame.size.height-7);
                [layerButton addSubview:label];
                layerButton.tag = [[NSString stringWithFormat:@"%@%d",@"111",text] integerValue];
                
                // Add long press gesture on thie layer
               // UILongPressGestureRecognizer* longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
                //[layerButton addGestureRecognizer:longPressRecognizer];
                
 
                
                UIImage *image = [UIImage imageNamed:@"cross"];
                image = [PhotoController imageWithImage:image scaledToSize:CGSizeMake(30, 29)];
                UIImage *pencilImage = [UIImage imageNamed:@"pencil_blue"];
                pencilImage = [PhotoController imageWithImage:pencilImage scaledToSize:CGSizeMake(19, 19)];

                UIButton *crossButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
                [crossButton setImage:image forState:UIControlStateNormal];
                [crossButton addTarget:self action:@selector(deleteLayer:) forControlEvents:UIControlEventTouchUpInside];
                [crossButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
                [crossButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                
                UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(layerButton.frame.origin.x, 0, 30, 50)];
                [editButton setImage:pencilImage forState:UIControlStateNormal];
                [editButton addTarget:self action:@selector(editLayer:) forControlEvents:UIControlEventTouchUpInside];
                [editButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
                [editButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
                 editButton.showsTouchWhenHighlighted = YES;

                // If delete mode is enabled then show cross button an wobble
                if(deleteMode){
                   // [crossButton setHidden:NO];
                    [editButton setHidden:NO];
                   // [self wobble:layerButton];
                }else{
                    [crossButton setHidden:YES];
                    [editButton setHidden:NO];
                }
                
               // crossButton.tag = layerButton.tag;
               // [layerButton addSubview:crossButton];
                editButton.tag = layerButton.tag;
                [layerButton addSubview:editButton];

                [layerScrollView addSubview:layerButton];
            }
        }

        if(photoLayersArray){
            //NSLog(@"Photo Layers %d", [photoLayersArray count]);
            
            for(int photo=0; photo<[photoLayersArray count]; photo++){
                
                UIImageView *img1 = (UIImageView *) photoLayersArray[photo];
                UIImageView *img = [[UIImageView alloc] initWithImage:img1.image];
                
                UIButton *layerButton = [UIButton  buttonWithType:UIButtonTypeCustom];
                layerButton.frame =CGRectMake(0, 5,layerScrollWidth, layerScrollHeight);
                [layerButton setBackgroundColor:[UIColor clearColor]];
                
                img.frame  = CGRectMake(layerButton.frame.origin.x+5, layerButton.frame.origin.y-2, layerButton.frame.size.width-10, layerButton.frame.size.height-7);
                [layerButton addSubview:img];
                layerButton.tag = [[NSString stringWithFormat:@"%@%d",@"222",photo] integerValue];
                
                // Add long press gesture on thie layer
                UILongPressGestureRecognizer* longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
                [layerButton addGestureRecognizer:longPressRecognizer];
                
                UIImage *image = [UIImage imageNamed:@"cross"];
                image = [PhotoController imageWithImage:image scaledToSize:CGSizeMake(30, 29)];
                UIImage *pencilImage = [UIImage imageNamed:@"pencil_blue"];
                pencilImage = [PhotoController imageWithImage:pencilImage scaledToSize:CGSizeMake(19, 19)];

                UIButton *crossButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
                [crossButton setImage:image forState:UIControlStateNormal];
                [crossButton addTarget:self action:@selector(deleteLayer:) forControlEvents:UIControlEventTouchUpInside];
                [crossButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
                [crossButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];

                UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(layerButton.frame.origin.x, 0, layerButton.frame.size.width, 50)];
                [editButton setImage:pencilImage forState:UIControlStateNormal];
                [editButton addTarget:self action:@selector(editLayer:) forControlEvents:UIControlEventTouchUpInside];
                [editButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
                [editButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
                 editButton.showsTouchWhenHighlighted = YES;
                // If delete mode is enabled then show cross button an wobble
                if(deleteMode){
                    //[crossButton setHidden:NO];
                    [editButton setHidden:NO];
                   // [self wobble:layerButton];
                }else{
                    [crossButton setHidden:YES];
                    [editButton setHidden:NO];
                }

               // crossButton.tag = layerButton.tag;
                //[layerButton addSubview:crossButton];
                editButton.tag = layerButton.tag;
                [layerButton addSubview:editButton];

                [layerScrollView addSubview:layerButton];
            }
        }
        if(symbolLayersArray){
            //NSLog(@"Symbol Layers %d", [symbolLayersArray count]);
            for(int symbol=0; symbol<[symbolLayersArray count]; symbol++){
                
                UIImageView *img1 = (UIImageView *) symbolLayersArray[symbol];
                UIImageView *img = [[UIImageView alloc] initWithImage:img1.image];
                
                UIButton *layerButton = [UIButton  buttonWithType:UIButtonTypeCustom];
                layerButton.frame =CGRectMake(0, 5,layerScrollWidth, layerScrollHeight);
                [layerButton setBackgroundColor:[UIColor clearColor]];
                
                img.frame  = CGRectMake(layerButton.frame.origin.x+5, layerButton.frame.origin.y-2, layerButton.frame.size.width-10, layerButton.frame.size.height-7);
                [layerButton addSubview:img];
                layerButton.tag = [[NSString stringWithFormat:@"%@%d",@"333",symbol] integerValue];
                
                // Add long press gesture on thie layer
                UILongPressGestureRecognizer* longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
                [layerButton addGestureRecognizer:longPressRecognizer];
                
                UIImage *image = [UIImage imageNamed:@"cross"];
                image = [PhotoController imageWithImage:image scaledToSize:CGSizeMake(30, 29)];
                UIImage *pencilImage = [UIImage imageNamed:@"pencil_blue"];
                pencilImage = [PhotoController imageWithImage:pencilImage scaledToSize:CGSizeMake(19, 19)];

                UIButton *crossButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
                [crossButton setImage:image forState:UIControlStateNormal];
                [crossButton addTarget:self action:@selector(deleteLayer:) forControlEvents:UIControlEventTouchUpInside];
                [crossButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
                [crossButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                
                UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(layerButton.frame.origin.x, 0, layerButton.frame.size.width, 50)];
                [editButton setImage:pencilImage forState:UIControlStateNormal];
                [editButton addTarget:self action:@selector(editLayer:) forControlEvents:UIControlEventTouchUpInside];
                [editButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
                [editButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
                 editButton.showsTouchWhenHighlighted = YES;
                // If delete mode is enabled then show cross button an wobble
                if(deleteMode){
                    //[crossButton setHidden:NO];
                    [editButton setHidden:NO];
                   // [self wobble:layerButton];
                }else{
                    [crossButton setHidden:YES];
                    [editButton setHidden:NO];
                }
                
                //crossButton.tag = layerButton.tag;
                //[layerButton addSubview:crossButton];
                editButton.tag = layerButton.tag;
                [layerButton addSubview:editButton];

                [layerScrollView addSubview:layerButton];
            }
        }
        if(iconLayersArray){
            //NSLog(@"Icon Layers %d", [iconLayersArray count]);
            for(int icon=0; icon<[iconLayersArray count]; icon++){
                
                UIImageView *img1 = (UIImageView *) iconLayersArray[icon];
                UIImageView *img = [[UIImageView alloc] initWithImage:img1.image];
                
                UIButton *layerButton = [UIButton  buttonWithType:UIButtonTypeCustom];
                layerButton.frame =CGRectMake(0, 5,layerScrollWidth, layerScrollHeight);
                [layerButton setBackgroundColor:[UIColor clearColor]];
                
                img.frame  = CGRectMake(layerButton.frame.origin.x+5, layerButton.frame.origin.y-2, layerButton.frame.size.width-10, layerButton.frame.size.height-7);
                [layerButton addSubview:img];
                layerButton.tag = [[NSString stringWithFormat:@"%@%d",@"444",icon] integerValue];
                
                // Add long press gesture on thie layer
                UILongPressGestureRecognizer* longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
                [layerButton addGestureRecognizer:longPressRecognizer];
                
                
                UIImage *image = [UIImage imageNamed:@"cross"];
                image = [PhotoController imageWithImage:image scaledToSize:CGSizeMake(30, 29)];
                UIImage *pencilImage = [UIImage imageNamed:@"pencil_blue"];
                pencilImage = [PhotoController imageWithImage:pencilImage scaledToSize:CGSizeMake(19, 19)];
                
                UIButton *crossButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
                [crossButton setImage:image forState:UIControlStateNormal];
                [crossButton addTarget:self action:@selector(deleteLayer:) forControlEvents:UIControlEventTouchUpInside];
                [crossButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
                [crossButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                
                UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(layerButton.frame.origin.x, 0, layerButton.frame.size.width, 50)];
                [editButton setImage:pencilImage forState:UIControlStateNormal];
                [editButton addTarget:self action:@selector(editLayer:) forControlEvents:UIControlEventTouchUpInside];
                [editButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
                [editButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
                 editButton.showsTouchWhenHighlighted = YES;
                
                // If delete mode is enabled then show cross button an wobble
                if(deleteMode){
                    //[crossButton setHidden:NO];
                    [editButton setHidden:NO];
                   // [self wobble:layerButton];
                }else{
                    [crossButton setHidden:YES];
                    [editButton setHidden:NO];
                }
                
                //crossButton.tag = layerButton.tag;
                //[layerButton addSubview:crossButton];
                editButton.tag = layerButton.tag;
                [layerButton addSubview:editButton];
                

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
    deleteMode = NO;
    doStopWobble = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [layerScrollView addGestureRecognizer:singleTap];

}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    [self SetMenu];
    //CGPoint touchPoint=[gesture locationInView:layerScrollView];
    // [self unWobbleAll];
}

-(void)resetLayerScrollView{

    doStopWobble = YES;
    
    [self setAddMoreLayerTabAction:arrangeLayerTabButton];
}

-(void) MyEdit{
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [backButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(cancelLayer) forControlEvents:UIControlEventTouchUpInside];
    backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarMenuButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [helpButton addTarget:self action:@selector(loadHelpController) forControlEvents:UIControlEventTouchUpInside];
    [helpButton setBackgroundImage:[UIImage imageNamed:@"help_icon"] forState:UIControlStateNormal];
    helpButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarHelpButton = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
    
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:leftBarMenuButton,leftBarHelpButton,nil]];
 [self editLayer:editButtonGlobal overrided:nil];
}

-(void)editLayer:(UIButton *)editButton{
    
    editButtonGlobal = editButton;
    crossButtonGlobal = editButton;
    //[editButtonGlobal setImage:[UIImage imageNamed:@"pencil_icon"] forState:UIControlStateNormal];
    [self chooseEdit];
  

    //[self editLayer:editButtonGlobal overrided:nil];

    //editAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Edit this layer?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK" ,nil];
    //[editAlert show];

}

-(void)editLayer:(UIButton *)editButton overrided:(BOOL)overrided{

    // Since we are editting we should enable the deleteNode On
    undoCount = undoCount + 1;
    NSLog(@"Edit Layer Tag: %d", editButton.tag);
    NSString *tag = [NSString stringWithFormat:@"%d", editButton.tag];
    int index = [self getIndexFromTag:tag];
    
    if([tag hasPrefix:@"111"])
    {
        // Set index
        arrangeLayerIndex = index;
        
        //
        selectedAddMoreLayerTab = ADD_MORE_TEXTTAB;
        
        // Call Write
        [self callWrite];
    }
    else if([tag hasPrefix:@"222"])
    {
        // Set index
        arrangeLayerIndex = index;
        
        // Call Photo
        [self choosePhoto];
    }
    else if([tag hasPrefix:@"333"])
    {
        // Set index
        arrangeLayerIndex = index;
        
        // Call Symbol
        [self setAddMoreLayerTabAction:addMoreSymbolTabButton];
    }
    else if([tag hasPrefix:@"444"])
    {
        // Set index
        arrangeLayerIndex = index;
        
        // Call Icon
        [self setAddMoreLayerTabAction:addMoreIconTabButton];
    }
     deleteMode = YES;
}
-(void) Mycancel{
    [self SetMenu];

}

-(void) SetMenu{
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(-30, -6, 50, 50)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"LAYERS";
    self.navigationItem.titleView = label;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [backButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(chooseTemplate) forControlEvents:UIControlEventTouchUpInside];
    backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarMenuButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [helpButton addTarget:self action:@selector(loadHelpController) forControlEvents:UIControlEventTouchUpInside];
    [helpButton setBackgroundImage:[UIImage imageNamed:@"help_icon"] forState:UIControlStateNormal];
    helpButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarHelpButton = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
    
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:leftBarMenuButton,leftBarHelpButton,nil]];
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    saveButton.titleLabel.font = [UIFont fontWithName:@"Signika-Semibold" size:13];
	[saveButton addTarget:self action:@selector(callSaveAndShare) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"share_button"] forState:UIControlStateNormal];
    saveButton.showsTouchWhenHighlighted = YES;
    UIButton *undoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    undoButton.titleLabel.font = [UIFont fontWithName:@"Signika-Semibold" size:13];
	[undoButton addTarget:self action:@selector(undo:) forControlEvents:UIControlEventTouchUpInside];
    [undoButton setBackgroundImage:[UIImage imageNamed:@"undo"] forState:UIControlStateNormal];
    undoButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    rightUndoBarButton = [[UIBarButtonItem alloc] initWithCustomView:undoButton];
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,rightUndoBarButton,nil]];
    if(undoCount == 0){
        [rightUndoBarButton setEnabled:NO];
    }
}

-(void)MyDelete{
    /*
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 29, 25)];
    [backButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(chooseTemplate) forControlEvents:UIControlEventTouchUpInside];
    backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarMenuButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 16, 21)];
    [helpButton addTarget:self action:@selector(loadHelpController) forControlEvents:UIControlEventTouchUpInside];
    [helpButton setBackgroundImage:[UIImage imageNamed:@"help_icon"] forState:UIControlStateNormal];
    helpButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarHelpButton = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
    
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:leftBarMenuButton,leftBarHelpButton,nil]];
    [self callAddMoreLayers];*/
    deleteAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Delete this layer?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK" ,nil];
    [deleteAlert show];
    

}

-(void)deleteLayer:(UIButton *)crossButton{

    crossButtonGlobal = crossButton;
    
    deleteAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Delete this layer?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK" ,nil];
    [deleteAlert show];
}

-(void)deleteLayer:(UIButton *)crossButton overrided:(BOOL)overrided{
    
    deleteMode = YES;
    undoCount = undoCount + 1;
    
    NSLog(@"Delete Layer Tag: %d", crossButton.tag);
    NSString *tag = [NSString stringWithFormat:@"%d", crossButton.tag];
    int index = [self getIndexFromTag:tag];
    
    // Make copy of layers to undo it later
    [self makeCopyOfLayers];
    
    if([tag hasPrefix:@"111"])
    {
        // Remove layer
        CustomLabel *label = textLabelLayersArray[index];
        [label removeFromSuperview];
        
        // Remove from Array
        [textLabelLayersArray removeObjectAtIndex:index];
        
        // Update remaining indexes
        for(int updateIndex=0; updateIndex<[textLabelLayersArray count]; updateIndex++){
            UIButton *layerButton = textLabelLayersArray[updateIndex];
            layerButton.tag = [[NSString stringWithFormat:@"%@%d",@"111",updateIndex] integerValue];
            
            [textLabelLayersArray removeObjectAtIndex:updateIndex];
            [textLabelLayersArray insertObject:layerButton atIndex:updateIndex];
        }
        
        // Remove layer thumbnail
        UIButton *layerThumbnail = (UIButton *) [crossButton superview];
        [layerThumbnail removeFromSuperview];
        
        // Update layer scroll view
        [self resetLayerScrollView];
        
    }
    else if([tag hasPrefix:@"222"])
    {
        // Remove layer
        UIImageView *photo = photoLayersArray[index];
        [photo removeFromSuperview];
        
        // Remove from Array
        [photoLayersArray removeObjectAtIndex:index];
        
        // Update remaining indexes
        for(int updateIndex=0; updateIndex<[photoLayersArray count]; updateIndex++){
            UIButton *layerButton = photoLayersArray[updateIndex];
            layerButton.tag = [[NSString stringWithFormat:@"%@%d",@"222",updateIndex] integerValue];
            
            [photoLayersArray removeObjectAtIndex:updateIndex];
            [photoLayersArray insertObject:layerButton atIndex:updateIndex];
        }
        
        // Remove layer thumbnail
        UIButton *layerThumbnail = (UIButton *) [crossButton superview];
        [layerThumbnail removeFromSuperview];
        
        // Update layer scroll view
        [self resetLayerScrollView];
    }
    else if([tag hasPrefix:@"333"])
    {
        // Remove layer
        UIImageView *symbol = symbolLayersArray[index];
        [symbol removeFromSuperview];
        
        // Remove from Array
        [symbolLayersArray removeObjectAtIndex:index];
        
        // Update remaining indexes
        for(int updateIndex=0; updateIndex<[symbolLayersArray count]; updateIndex++){
            UIButton *layerButton = symbolLayersArray[updateIndex];
            layerButton.tag = [[NSString stringWithFormat:@"%@%d",@"333",updateIndex] integerValue];
            
            [symbolLayersArray removeObjectAtIndex:updateIndex];
            [symbolLayersArray insertObject:layerButton atIndex:updateIndex];
        }
        
        // Remove layer thumbnail
        UIButton *layerThumbnail = (UIButton *) [crossButton superview];
        [layerThumbnail removeFromSuperview];
        
        // Update layer scroll view
        [self resetLayerScrollView];
    }
    else if([tag hasPrefix:@"444"])
    {
        // Remove layer
        UIImageView *icon = iconLayersArray[index];
        [icon removeFromSuperview];
        
        // Remove from Array
        [iconLayersArray removeObjectAtIndex:index];
        
        // Update remaining indexes
        for(int updateIndex=0; updateIndex<[iconLayersArray count]; updateIndex++){
            UIButton *layerButton = iconLayersArray[updateIndex];
            layerButton.tag = [[NSString stringWithFormat:@"%@%d",@"444",updateIndex] integerValue];
            
            [iconLayersArray removeObjectAtIndex:updateIndex];
            [iconLayersArray insertObject:layerButton atIndex:updateIndex];
        }
        
        // Remove layer thumbnail
        UIButton *layerThumbnail = (UIButton *) [crossButton superview];
        [layerThumbnail removeFromSuperview];
        
        // Update layer scroll view
        [self resetLayerScrollView];
        [self SetMenu];
    }
}

-(void)onLongPress:(UILongPressGestureRecognizer*)pGesture
{
    /*
    // Get button
    UIButton *button = (UIButton *) pGesture.view;
    NSLog(@"Layer Tag: %d", button.tag);
    
    // Enable delete mode
    deleteMode = YES;

    if(layerScrollView){
        
        // Get layer thumbnail from scroll view
        for(UIView *layerThumbnail in [layerScrollView subviews]){
            if([layerThumbnail isKindOfClass:[UIButton class]]){
                
                // Get cross button from layer thumbnail
                for(UIView *editButton in [layerThumbnail subviews]){
                    if([editButton isKindOfClass:[UIButton class]]){
                        
                        // Enable cross button
                        //[crossButton setHidden:NO];
                        //[editButton setHidden:NO];
                        //break;
                    }
                }
                
                // Wobble layer thumbnail
                [self wobble:pGesture.view];
            }
        }
    }
     */
}

-(void)wobble:(UIView *)view{

    CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-3));
    CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(3));
    
    view.transform = leftWobble;  // starting point
    
    [UIView beginAnimations:@"wobble" context:(__bridge void *)(view)];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:INFINITY]; // adjustable
    [UIView setAnimationDelegate:self];
    view.transform = rightWobble; // end here & auto-reverse
    [UIView commitAnimations];
}

-(void)unWobbleAll{

    // Get layer thumbnail from scroll view
    for(UIView *layerThumbnail in [layerScrollView subviews]){
        if([layerThumbnail isKindOfClass:[UIButton class]]){
            
            // Get cross button from layer thumbnail
            for(UIView *crossButton in [layerThumbnail subviews]){
                if([crossButton isKindOfClass:[UIButton class]]){
                    
                    // Enable cross button
                    [crossButton setHidden:YES];
                    //break;
                }
            }
            
            CALayer *currentLayer = layerThumbnail.layer.presentationLayer;
            [layerThumbnail.layer removeAllAnimations];
            layerThumbnail.layer.transform = currentLayer.transform;
            CATransform3D newTransform = CATransform3DIdentity;
            
            [UIView animateWithDuration:1.0
                                  delay:0.0
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 layerThumbnail.layer.transform = newTransform;
                             }
                             completion:NULL];
            /*
            // Wobble layer thumbnail
            CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-3));
            CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(3));
            
            layerThumbnail.transform = leftWobble;  // starting point
            
            [UIView beginAnimations:@"wobble" context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.1];
            layerThumbnail.transform = rightWobble; // end here & auto-reverse
            [UIView commitAnimations];
             */
        }
    }
    
    deleteMode = NO;

}

-(void) setCameraTabAction:(id) sender{
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

-(void) setPhotoTabAction:(id) sender{
    imgPickerFlag =2;
    [self loadCustomPhotoLibrary];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4f];
    textBackgrnd.alpha = ALPHA0;
    [cameraTabButton setBackgroundImage:[UIImage imageNamed:@"07_camera"] forState:UIControlStateNormal];
    [photoTabButton setBackgroundImage:[UIImage imageNamed:@"07_roll_selected"] forState:UIControlStateNormal];
    [widthTabButton setBackgroundImage:[UIImage imageNamed:@"07_width"] forState:UIControlStateNormal];
    [heightTabButton setBackgroundImage:[UIImage imageNamed:@"07_height"] forState:UIControlStateNormal];
    [UIView commitAnimations];
}

/*
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
*/
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
        if(selectedAddMoreLayerTab == ADD_MORE_TEXTTAB){
            
            /*UITextView *newMsgTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 50, 280, 150)];
             newMsgTextView.delegate = self;
             newMsgTextView.font = [UIFont fontWithName:@"Arial" size:16];
             newMsgTextView.textColor = [UIColor blackColor];
             newMsgTextView.textAlignment = UITextAlignmentCenter;
             [[self textEditLayersArray] addObject:newMsgTextView];*/
            
            //CustomLabel *newMsgLabel = [[CustomLabel alloc]initWithFrame:CGRectMake(0, 30, 320, 150)];
            CustomLabel *newMsgLabel = [[CustomLabel alloc]initWithFrame:CGRectMake(20, 50, 280, 280)];

            newMsgLabel.backgroundColor = [UIColor clearColor];
            newMsgLabel.textColor = [UIColor blackColor];
            newMsgLabel.borderColor = [UIColor clearColor];
            newMsgLabel.textAlignment = UITextAlignmentCenter;
            newMsgLabel.adjustsFontSizeToFitWidth = YES;
            //newMsgLabel.adjustsLetterSpacingToFitWidth = YES;
            newMsgLabel.lineBreakMode = UILineBreakModeClip;
            //[newMsgLabel.text]
            //newMsgLabel.numberOfLines = 0;
            //
            //newMsgLabel.tag = textLayerCount++;
            [self.imgView addSubview:newMsgLabel];

            arrangeLayerIndex = [[self textLabelLayersArray] count];
            [[self textLabelLayersArray] addObject:newMsgLabel];

            // set delete mode to NO when clicked on text tab
            deleteMode = NO;
            [self callWrite];
            
        } else if(selectedAddMoreLayerTab == ADD_MORE_SYMBOLTAB){

            CALayer * lastLayer = [[[self symbolLayersArray] lastObject] layer];
            [lastLayer setMasksToBounds:YES];
            [lastLayer setCornerRadius:0];
            [lastLayer setBorderWidth:0];
            [lastLayer setBorderColor:[[UIColor clearColor] CGColor]];
            
            UIImageView *newSymbolImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 90, 70)];
            newSymbolImgView.tag = symbolLayerCount++;
            arrangeLayerIndex = [[self symbolLayersArray] count];

            CALayer * l = [newSymbolImgView layer];
            [l setMasksToBounds:YES];
            [l setCornerRadius:10];
            [l setBorderWidth:1.0];
            [l setBorderColor:[[UIColor grayColor] CGColor]];
            [self.imgView addSubview:newSymbolImgView];
            
            [[self symbolLayersArray] addObject:newSymbolImgView];
            
            
            
        } else if(selectedAddMoreLayerTab == ADD_MORE_ICONTAB){
            CALayer * lastLayer = [[[self iconLayersArray] lastObject] layer];
            [lastLayer setMasksToBounds:YES];
            [lastLayer setCornerRadius:0];
            [lastLayer setBorderWidth:0];
            [lastLayer setBorderColor:[[UIColor clearColor] CGColor]];
            
            UIImageView *newIconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 90, 70)];
            newIconImgView.tag = iconLayerCount++;
            arrangeLayerIndex = [[self iconLayersArray] count];

            CALayer * l = [newIconImgView layer];
            [l setMasksToBounds:YES];
            [l setCornerRadius:10];
            [l setBorderWidth:1.0];
            [l setBorderColor:[[UIColor grayColor] CGColor]];
            [self.imgView addSubview:newIconImgView];
            
            [[self iconLayersArray] addObject:newIconImgView];
            
        } else if(selectedAddMoreLayerTab == ADD_MORE_PHOTOTAB){
            photoTouchFlag = YES;
            
            CALayer * lastLayer = [[[self photoLayersArray] lastObject] layer];
            [lastLayer setMasksToBounds:YES];
            [lastLayer setCornerRadius:0];
            [lastLayer setBorderWidth:0];
            [lastLayer setBorderColor:[[UIColor clearColor] CGColor]];
            
            UIImageView *newPhotoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 220, 200)];
            newPhotoImgView.tag = photoLayerCount++;
            arrangeLayerIndex = [[self photoLayersArray] count];

            CALayer * l = [newPhotoImgView layer];
            [l setMasksToBounds:YES];
            [l setCornerRadius:10];
            [l setBorderWidth:1.0];
            [l setBorderColor:[[UIColor grayColor] CGColor]];
            //[newPhotoImgView setBackgroundColor:[ UIColor colorWithWhite:1 alpha:0.4f]];
            [self.imgView addSubview:newPhotoImgView];
            
            [[self photoLayersArray] addObject:newPhotoImgView];
            
            // set delete mode to NO when clicked on photo tab
            deleteMode = NO;

            [self choosePhoto];
        }
    
    } else {
        layerallow = 1;
        warningAlert = [[UIAlertView alloc]initWithTitle:@"You can add a total of 10 layers." message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Edit Layers" ,nil];
		[warningAlert show];
    }
}

-(void)removeBordersFromAllLayers{

    for(int text=0; text<[textLabelLayersArray count]; text++){
        
        CALayer * lastLayer = [textLabelLayersArray[text] layer];
        [lastLayer setMasksToBounds:YES];
        [lastLayer setCornerRadius:0];
        [lastLayer setBorderWidth:0];
        [lastLayer setBorderColor:[[UIColor clearColor] CGColor]];
        [lastLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    }
    
    for(int photo=0; photo<[photoLayersArray count]; photo++){
        
        CALayer * lastLayer = [photoLayersArray[photo] layer];
        [lastLayer setMasksToBounds:YES];
        [lastLayer setCornerRadius:0];
        [lastLayer setBorderWidth:0];
        [lastLayer setBorderColor:[[UIColor clearColor] CGColor]];
    }

    for(int symbol=0; symbol<[symbolLayersArray count]; symbol++){
        
        CALayer * lastLayer = [symbolLayersArray[symbol] layer];
        [lastLayer setMasksToBounds:YES];
        [lastLayer setCornerRadius:0];
        [lastLayer setBorderWidth:0];
        [lastLayer setBorderColor:[[UIColor clearColor] CGColor]];
    }
    
    for(int icon=0; icon<[iconLayersArray count]; icon++){
        
        CALayer * lastLayer = [iconLayersArray[icon] layer];
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
    //[rightUndoBarButton setEnabled:YES];
	NSValue *touchPointValue = [NSValue valueWithCGPoint:touchPoint] ;
	[UIView beginAnimations:nil context:(__bridge void *)(touchPointValue)];
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
            if(selectedAddMoreLayerTab == ARRANGE_LAYERTAB){
                //[self.imgView sendSubviewToBack:[[self photoLayersArray] objectAtIndex:arrangeLayerIndex]];
                [self.imgView bringSubviewToFront:[self textLabelLayersArray][arrangeLayerIndex]];            
            } else{
                //[self.imgView sendSubviewToBack:[[self photoLayersArray] lastObject]];
                //[self.imgView bringSubviewToFront:[[self textLabelLayersArray] objectAtIndex:arrangeLayerIndex]];
                [self.imgView bringSubviewToFront:[[self textLabelLayersArray] lastObject]];
            }

			for (UITouch *touch in touches) {
				//[self dispatchFirstTouchAtPoint:msgLabel point:[touch locationInView:self.view] forEvent:nil];
                if(selectedAddMoreLayerTab == ARRANGE_LAYERTAB){
                    [self dispatchFirstTouchAtPoint:[[self textLabelLayersArray] lastObject] point:[touch locationInView:self.imgView] forEvent:nil];
                }else{
                    [self dispatchFirstTouchAtPoint:[[self textLabelLayersArray] lastObject] point:[touch locationInView:self.imgView] forEvent:nil];
                }
			}
          
		}
		//else if (CGRectContainsPoint([photoImgView frame], [touch locationInView:self.imgView]) && photoTouchFlag)
		else if (loc.y <= (imgView.frame.size.height-(((UIImageView *)[[self photoLayersArray] lastObject]).frame.size.height/2)) && photoTouchFlag
                 && loc.x <= (imgView.frame.size.width-(((UIImageView *)[[self photoLayersArray] lastObject]).frame.size.width/2))
                 && loc.x >= ((((UIImageView *)[[self photoLayersArray] lastObject]).frame.size.width/2)))
		{
            if(selectedAddMoreLayerTab == ARRANGE_LAYERTAB){
                [self.imgView bringSubviewToFront:[self photoLayersArray][arrangeLayerIndex]];
                //[self.imgView bringSubviewToFront:[[self textLabelLayersArray] lastObject]];
            }else{
                [self.imgView bringSubviewToFront:[[self photoLayersArray] lastObject]];
                //[self.imgView bringSubviewToFront:[[self textLabelLayersArray] lastObject]];
            }

			for (UITouch *touch in touches) {
                if(selectedAddMoreLayerTab == ARRANGE_LAYERTAB){
                    [self dispatchFirstTouchAtPoint:[self photoLayersArray][arrangeLayerIndex] point:[touch locationInView:self.imgView] forEvent:nil];
                }else{
                    [self dispatchFirstTouchAtPoint:[[self photoLayersArray] lastObject] point:[touch locationInView:self.imgView] forEvent:nil];
                }
				//[self dispatchFirstTouchAtPoint:photoImgView point:[touch locationInView:self.view] forEvent:nil];
			}
		}
        else if (loc.y <= (imgView.frame.size.height-(symbolImgView.frame.size.height/2)) && symbolTouchFlag)
		{
            if(selectedAddMoreLayerTab == ARRANGE_LAYERTAB){
                [self.imgView bringSubviewToFront:[self symbolLayersArray][arrangeLayerIndex]];
                //[self.imgView bringSubviewToFront:[[self textLabelLayersArray] lastObject]];
            }else{
                [self.imgView bringSubviewToFront:[[self symbolLayersArray] lastObject]];
                //[self.imgView bringSubviewToFront:[[self textLabelLayersArray] lastObject]];
            }

			for (UITouch *touch in touches) {
                if(selectedAddMoreLayerTab == ARRANGE_LAYERTAB){
                    [self dispatchFirstTouchAtPoint:[self symbolLayersArray][arrangeLayerIndex] point:[touch locationInView:self.imgView] forEvent:nil];
                }else{
                    [self dispatchFirstTouchAtPoint:[[self symbolLayersArray] lastObject] point:[touch locationInView:self.imgView] forEvent:nil];
                }
				//[self dispatchFirstTouchAtPoint:photoImgView point:[touch locationInView:self.view] forEvent:nil];
			}
		}
        else if (loc.y <= (imgView.frame.size.height-(iconImgView.frame.size.height/2)) && iconTouchFlag)
		{
            if(selectedAddMoreLayerTab == ARRANGE_LAYERTAB){
                [self.imgView bringSubviewToFront:[self iconLayersArray][arrangeLayerIndex]];
                //[self.imgView bringSubviewToFront:[[self textLabelLayersArray] lastObject]];
            }else{
                [self.imgView bringSubviewToFront:[[self iconLayersArray] lastObject]];
                //[self.imgView bringSubviewToFront:[[self textLabelLayersArray] lastObject]];
            }

			for (UITouch *touch in touches) {
                if(selectedAddMoreLayerTab == ARRANGE_LAYERTAB){
                    [self dispatchFirstTouchAtPoint:[self iconLayersArray][arrangeLayerIndex] point:[touch locationInView:self.imgView] forEvent:nil];
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
    //[self SetMenu];
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
            
            if(selectedAddMoreLayerTab == ARRANGE_LAYERTAB){
                [self dispatchTouchEvent:[self textLabelLayersArray][arrangeLayerIndex] toPosition:[touch locationInView:self.imgView]];
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
            
            if(selectedAddMoreLayerTab == ARRANGE_LAYERTAB){
                [self dispatchTouchEvent:[self photoLayersArray][arrangeLayerIndex] toPosition:[touch locationInView:self.imgView]];
            }else{
                [self dispatchTouchEvent:[[self photoLayersArray] lastObject] toPosition:[touch locationInView:self.imgView]];
            }
			//[self dispatchTouchEvent:photoImgView toPosition:[touch locationInView:self.view]];
		}
	}
    else if (loc.y <= (imgView.frame.size.height-(symbolImgView.frame.size.height/2)) && symbolTouchFlag)
	{
		for (UITouch *touch in touches){
            if(selectedAddMoreLayerTab == ARRANGE_LAYERTAB){
                [self dispatchTouchEvent:[self symbolLayersArray][arrangeLayerIndex] toPosition:[touch locationInView:self.imgView]];
            }else{
                [self dispatchTouchEvent:[[self symbolLayersArray] lastObject] toPosition:[touch locationInView:self.imgView]];
            }
			//[self dispatchTouchEvent:photoImgView toPosition:[touch locationInView:self.view]];
		}
	}
    else if (loc.y <= (imgView.frame.size.height-(iconImgView.frame.size.height/2)) && iconTouchFlag)
	{
		for (UITouch *touch in touches){
            if(selectedAddMoreLayerTab == ARRANGE_LAYERTAB){
                [self dispatchTouchEvent:[self iconLayersArray][arrangeLayerIndex] toPosition:[touch locationInView:self.imgView]];
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

    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];

	NSString *homeDirectoryPath = NSHomeDirectory();
	NSString *usernamePath = [homeDirectoryPath stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@/",appDelegate.loginId]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:usernamePath isDirectory:NULL]) {
        NSError *error;
		[[NSFileManager defaultManager] createDirectoryAtPath:usernamePath withIntermediateDirectories:YES attributes:nil error:&error];
	}

	NSString *MyFlyerPath = [usernamePath stringByAppendingString:[NSString stringWithFormat:@"Flyr/"]];
	NSString *folderPath = [NSString pathWithComponents:@[[NSString stringWithString:[MyFlyerPath stringByStandardizingPath]]]];
	NSInteger imgCount;
	NSInteger largestImgCount=-1;
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
	
	NSString *finalImgDetailWritePath;

	/************************ CREATE UNIQUE NAME FOR IMAGE ***********************************/
    
    // Not -1 means it is in Edit mode and we already have flyer number
    if(flyerNumber != -1){
    
        finalImgWritePath = [folderPath stringByAppendingString:[NSString stringWithFormat:@"/IMG_%d.jpg", flyerNumber]];
        finalImgDetailWritePath = [folderPath stringByAppendingString:[NSString stringWithFormat:@"/IMG_%d.txt", flyerNumber]];
        largestImgCount = flyerNumber;
        
        imageNameNew = [NSString stringWithFormat:@"/IMG_%d.jpg",largestImgCount];

    } else {
    
        if(files == nil)
        {
            finalImgWritePath = [folderPath stringByAppendingString:@"/IMG_0.jpg"];
            finalImgDetailWritePath = [folderPath stringByAppendingString:@"/IMG_0.txt"];
            
        }
        else
        {
           
            for(int i = 0 ; i < [files count];i++)
            {
                NSString *lastFileName = files[i];
                NSLog(@"%@",lastFileName);
                lastFileName = [lastFileName stringByReplacingOccurrencesOfString:@".jpg" withString:@""];
                lastFileName = [lastFileName stringByReplacingOccurrencesOfString:@"IMG_" withString:@""];
                imgCount = [lastFileName intValue];
                if(imgCount > largestImgCount){
                    largestImgCount = imgCount;
                }
                
            }
            imageNameNew = [NSString stringWithFormat:@"/IMG_%d.jpg",++largestImgCount];
            finalImgWritePath = [folderPath stringByAppendingString:imageNameNew];
            NSString *newImgDetailName = [NSString stringWithFormat:@"/IMG_%d.txt",largestImgCount];
            finalImgDetailWritePath = [folderPath stringByAppendingString:newImgDetailName];
            
        }
    }
	/************************ END OF CREATE UNIQUE NAME FOR IMAGE ***********************************/

	NSString *imgPath = [NSString pathWithComponents:@[[NSString stringWithString:[finalImgWritePath stringByExpandingTildeInPath]]]];
	if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:NULL]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error];
	}
    
    // Save flyer in pieces to make it editable later
    [self saveFlyerInPieces:finalImgDetailWritePath flyerFolder:folderPath flyerNumberParam:largestImgCount];
	
    // Save flyer details
    [self saveFlyerDetails:finalImgDetailWritePath];
	
    // Save states of all supported social media
    if(files){
        [self saveSocialStates:folderPath imageName:imageNameNew];
    }else{
        [self saveSocialStates:folderPath imageName:@"/IMG_0.jpg"];
    }
    
    [aHUD.loadingLabel setText:@"Saved"];
	[NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(killHUD) userInfo:nil repeats:NO];

	NSData *imgData = UIImagePNGRepresentation(screenImage);
	[[NSFileManager defaultManager] createFileAtPath:imgPath contents:imgData attributes:nil];
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"saveToCameraRollSetting"]){
        UIImageWriteToSavedPhotosAlbum(screenImage, nil, nil, nil);
    }

	return imgData;
}

-(void)createDirectoryAtPath:(NSString *)directory{
	if (![[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:NULL]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
	}
}

/*
 *Save flyer in pieces to make it editable later
 */
-(void)saveFlyerInPieces:(NSString *)filePath flyerFolder:(NSString *)flyerFolder flyerNumberParam:(int)flyerNumberParam{
    
    if(flyerNumberParam == -1)
        flyerNumberParam = 0;
    
    NSString *piecesFile = [filePath stringByReplacingOccurrencesOfString:@".txt" withString:@".pieces"];
    NSMutableDictionary *detailDictionary = [[NSMutableDictionary alloc] init];

    // Create Template direcrory if not created
    NSString *templateFolderPath = [NSString stringWithFormat:@"%@/Template/", flyerFolder];
    NSString *templateIndexFolderPath = [NSString stringWithFormat:@"%@/%d", templateFolderPath, flyerNumberParam];
    [self createDirectoryAtPath:templateFolderPath];
    [self createDirectoryAtPath:templateIndexFolderPath];
        
    // Create Photo direcrory if not created
    NSString *photoFolderPath = [NSString stringWithFormat:@"%@/Photo/", flyerFolder];
    NSString *photoIndexFolderPath = [NSString stringWithFormat:@"%@/%d", photoFolderPath, flyerNumberParam];
    [self createDirectoryAtPath:photoFolderPath];
    [self createDirectoryAtPath:photoIndexFolderPath];

    // Create Symbol direcrory if not created
    NSString *symbolFolderPath = [NSString stringWithFormat:@"%@/Symbol/", flyerFolder];
    NSString *symbolIndexFolderPath = [NSString stringWithFormat:@"%@/%d", symbolFolderPath, flyerNumberParam];
    [self createDirectoryAtPath:symbolFolderPath];
    [self createDirectoryAtPath:symbolIndexFolderPath];
    
    // Create Icon direcrory if not created
    NSString *iconFolderPath = [NSString stringWithFormat:@"%@/Icon/", flyerFolder];
    NSString *iconIndexFolderPath = [NSString stringWithFormat:@"%@/%d", iconFolderPath, flyerNumberParam];
    [self createDirectoryAtPath:iconFolderPath];
    [self createDirectoryAtPath:iconIndexFolderPath];
    

    // Store selected template
    NSMutableDictionary *templateDetailDictionary = [[NSMutableDictionary alloc] init];
    
    NSString *finalTemplatePath = [templateIndexFolderPath stringByAppendingString:[NSString stringWithFormat:@"/template.jpg"]];
    NSData *imgData = UIImagePNGRepresentation(selectedTemplate);
    [[NSFileManager defaultManager] createFileAtPath:finalTemplatePath contents:imgData attributes:nil];
    
    templateDetailDictionary[@"image"] = finalTemplatePath;
    detailDictionary[[NSString stringWithFormat:@"Template"]] = templateDetailDictionary;

    int index = 0;
    // Get and Save label information
    for(CustomLabel *labelToStore in [self textLabelLayersArray]){
        
        CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0,wht = 0.0;

        [labelToStore.textColor getRed:&red green:&green blue:&blue alpha:&alpha];
        if (red == 0 && green == 0 && blue ==0) {
            [labelToStore.textColor getWhite:&wht alpha:&alpha];
        }

        CGFloat borderRed = 0.0, borderGreen = 0.0, borderBlue = 0.0, borderAlpha = 0.0,bwht = 0.0;
        UIColor* borderColor;
        borderColor = labelToStore.borderColor;
        [borderColor getRed:&borderRed green:&borderGreen blue:&borderBlue alpha:&borderAlpha];
        
        if (borderRed == 0 && borderGreen == 0 && borderBlue ==0) {
            [labelToStore.borderColor getWhite:&bwht alpha:&borderAlpha];
        }
        
        NSMutableDictionary *textDetailDictionary = [[NSMutableDictionary alloc] init];
        textDetailDictionary[@"text"] = labelToStore.text;
        textDetailDictionary[@"fontname"] = labelToStore.font.fontName;
        textDetailDictionary[@"fontsize"] = [NSString stringWithFormat:@"%f", labelToStore.font.pointSize];
        textDetailDictionary[@"textcolor"] = [NSString stringWithFormat:@"%f, %f, %f", red, green, blue];
        textDetailDictionary[@"textWhitecolor"] = [NSString stringWithFormat:@"%f, %f", wht, alpha];
        textDetailDictionary[@"textborderWhite"] = [NSString stringWithFormat:@"%f, %f", bwht, borderAlpha];
        textDetailDictionary[@"textbordercolor"] = [NSString stringWithFormat:@"%f, %f, %f", borderRed, borderGreen, borderBlue];
        textDetailDictionary[@"x"] = [NSString stringWithFormat:@"%f", labelToStore.frame.origin.x];
        textDetailDictionary[@"y"] = [NSString stringWithFormat:@"%f", labelToStore.frame.origin.y];
        textDetailDictionary[@"width"] = [NSString stringWithFormat:@"%f", labelToStore.frame.size.width];
        textDetailDictionary[@"height"] = [NSString stringWithFormat:@"%f", labelToStore.frame.size.height];
        
        detailDictionary[[NSString stringWithFormat:@"Text-%d", index++]] = textDetailDictionary;
    }

    index = 0;
    // Get and Save photo information
    for(UIImageView *photoToStore in [self photoLayersArray]){
        
        NSMutableDictionary *photoDetailDictionary = [[NSMutableDictionary alloc] init];
        
		NSString *finalPhotoPath = [photoIndexFolderPath stringByAppendingString:[NSString stringWithFormat:@"/%d.jpg", index]];
        NSData *imgData = UIImageJPEGRepresentation(photoToStore.image, 100);
        [[NSFileManager defaultManager] createFileAtPath:finalPhotoPath contents:imgData attributes:nil];

        photoDetailDictionary[@"image"] = finalPhotoPath;
        photoDetailDictionary[@"x"] = [NSString stringWithFormat:@"%f", photoToStore.frame.origin.x];
        photoDetailDictionary[@"y"] = [NSString stringWithFormat:@"%f", photoToStore.frame.origin.y];
        photoDetailDictionary[@"width"] = [NSString stringWithFormat:@"%f", photoToStore.frame.size.width];
        photoDetailDictionary[@"height"] = [NSString stringWithFormat:@"%f", photoToStore.frame.size.height];
        
        detailDictionary[[NSString stringWithFormat:@"Photo-%d", index++]] = photoDetailDictionary;
    }
    
    index = 0;
    // Get and Save symbol information
    for(UIImageView *symbolToStore in [self symbolLayersArray]){
        
        NSMutableDictionary *symbolDetailDictionary = [[NSMutableDictionary alloc] init];
        
		NSString *finalSymbolPath = [symbolIndexFolderPath stringByAppendingString:[NSString stringWithFormat:@"/%d.jpg", index]];
        NSData *imgData = UIImagePNGRepresentation(symbolToStore.image);
        [[NSFileManager defaultManager] createFileAtPath:finalSymbolPath contents:imgData attributes:nil];
        
        symbolDetailDictionary[@"image"] = finalSymbolPath;
        symbolDetailDictionary[@"x"] = [NSString stringWithFormat:@"%f", symbolToStore.frame.origin.x];
        symbolDetailDictionary[@"y"] = [NSString stringWithFormat:@"%f", symbolToStore.frame.origin.y];
        symbolDetailDictionary[@"width"] = [NSString stringWithFormat:@"%f", symbolToStore.frame.size.width];
        symbolDetailDictionary[@"height"] = [NSString stringWithFormat:@"%f", symbolToStore.frame.size.height];
        
        detailDictionary[[NSString stringWithFormat:@"Symbol-%d", index++]] = symbolDetailDictionary;
    }
    
    index = 0;
    // Get and Save icon information
    for(UIImageView *iconToStore in [self iconLayersArray]){
        
        NSMutableDictionary *iconDetailDictionary = [[NSMutableDictionary alloc] init];

		NSString *finalIconPath = [iconIndexFolderPath stringByAppendingString:[NSString stringWithFormat:@"/%d.jpg", index]];
        NSData *imgData = UIImagePNGRepresentation(iconToStore.image);
        [[NSFileManager defaultManager] createFileAtPath:finalIconPath contents:imgData attributes:nil];
        
        iconDetailDictionary[@"image"] = finalIconPath;
        iconDetailDictionary[@"x"] = [NSString stringWithFormat:@"%f", iconToStore.frame.origin.x];
        iconDetailDictionary[@"y"] = [NSString stringWithFormat:@"%f", iconToStore.frame.origin.y];
        iconDetailDictionary[@"width"] = [NSString stringWithFormat:@"%f", iconToStore.frame.size.width];
        iconDetailDictionary[@"height"] = [NSString stringWithFormat:@"%f", iconToStore.frame.size.height];
        
        detailDictionary[[NSString stringWithFormat:@"Icon-%d", index++]] = iconDetailDictionary;
    }

    //NSLog(@"DetailDictionary: %@", detailDictionary);
    //NSLog(@"Folder: %@", piecesFile);
    [detailDictionary writeToFile:piecesFile atomically:YES];
}

/*
 *Save flyer details
 */
-(void)saveFlyerDetails:(NSString *)finalImgDetailWritePath{

    NSArray *OldDetail = [[NSArray alloc] initWithContentsOfFile:finalImgDetailWritePath];
   // NSLog(@"%@",OldDetail);
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    if ([OldDetail count] > 0) {

        [array addObject:OldDetail[0]];
        globle.FlyerName = OldDetail[0];
    }else{
        [array addObject:@""];
         globle.FlyerName =@"";
    }
    
    if([[self textLabelLayersArray] count] > 0){
        //NSLog(@"%@", ((CustomLabel*)[[self textLabelLayersArray] objectAtIndex:0]).text);
        [array addObject:((CustomLabel*)[self textLabelLayersArray][0]).text];
    }else{
        [array addObject:@""];
    }
   // NSLog(@"%@",array);
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:FlyerDateFormat];
    NSString *dateString = [dateFormat stringFromDate:date];
    [array addObject:dateString];
    
    [array writeToFile:finalImgDetailWritePath atomically:YES];
}

/*
 *Save states of all supported social media
 */
-(void)saveSocialStates:(NSString *)directory imageName:(NSString *)imageName{

	NSMutableArray *socialArray = [[[NSMutableArray alloc] init] autorelease];
    [socialArray addObject:@"0"]; //Facebook
    [socialArray addObject:@"0"]; //Twitter
    [socialArray addObject:@"0"]; //Email
    [socialArray addObject:@"0"]; //Tumblr
    [socialArray addObject:@"0"]; //Flickr
    [socialArray addObject:@"0"]; //Instagram
    [socialArray addObject:@"0"]; //SMS
    [socialArray addObject:@"0"]; //Clipboard
    
	NSString *socialFlyerPath = [NSString stringWithFormat:@"%@/Social/", directory];
    
    NSString *str = [imageName stringByReplacingOccurrencesOfString:@".jpg" withString:@".soc"];
	NSString *finalImageWritePath = [socialFlyerPath stringByAppendingString:str];
   
	if (![[NSFileManager defaultManager] fileExistsAtPath:socialFlyerPath isDirectory:NULL]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:socialFlyerPath withIntermediateDirectories:YES attributes:nil error:&error];
	}
    
    [socialArray writeToFile:finalImageWritePath atomically:YES];
}

#pragma mark - InappPurchase

-(void)showFontPurchaseSheet:(int)tag productList:(NSArray *)productList{
    
    // Show alert that no more matches are left. First buy
    inAppAlert = [[UIAlertView alloc] initWithTitle:@"Purchase Products"
                                                    message:@""
                                                   delegate:self cancelButtonTitle:nil
                                          otherButtonTitles:nil ,nil];
    alert.tag = tag;
    for( SKProduct *product in productList)  {
        [inAppAlert addButtonWithTitle: [NSString stringWithFormat:@"%@ - %@", product.localizedTitle, product.priceAsString]];
    }
    [inAppAlert addButtonWithTitle:@"Cancel"];
    inAppAlert.cancelButtonIndex = [productList count];

    [inAppAlert show];
}

-(BOOL)fontPackAvailable{

    PFQuery *query = [PFQuery queryWithClassName:TABLE_JSON];
    [query whereKey:COLUMN_USER equalTo:[PFUser currentUser]];
    
    NSError *error;
    NSArray *postArray = [query findObjects:&error];
    
    if(!postArray){
        return NO;
    }
    
    if (!error) {
        
        PFObject *post = postArray.lastObject;
        if(!post){
            return NO;
            
        } else {
            
            NSString *remainingFontCount = post[COLUMN_REMINING_FONT_COUNT];
            if(!remainingFontCount){
                return NO;
            }else{
                
                if(remainingFontCount > 0){
                    return YES;
                } else {
                    return NO;
                }
            }
        }
    }
    
    return NO;
}

-(BOOL)anyFontPurchased{
    
    PFQuery *query = [PFQuery queryWithClassName:TABLE_JSON];
    [query whereKey:COLUMN_USER equalTo:[PFUser currentUser]];
    
    NSError *error;
    NSArray *postArray = [query findObjects:&error];
    
    if(!postArray){
        return NO;
    }

    PFObject *post = postArray.lastObject;
    if(!post){
        return NO;
        
    } else {
        
        NSDictionary *json = post[COLUMN_JSON];
        if(!json){
            return NO;
        } else {
            
            NSString *key1 = [PRODUCT_FONT stringByReplacingOccurrencesOfString:@"." withString:@""];
            NSString *key2 = [PRODUCT_FOUR_PACK_FONT stringByReplacingOccurrencesOfString:@"." withString:@""];
            NSString *key3 = [PRODUCT_FULL_FONT stringByReplacingOccurrencesOfString:@"." withString:@""];
            
            if(json[key1] || json[key2] || json[key3]){
                return YES;
            }else{
                return NO;
            }
        }
    }
    
    return NO;
}

-(void)requestSize:(UIButton *)button{
    
    UIAlertView *settingsAlert = [[UIAlertView alloc] initWithTitle:@"Reminder" message:@"Purchase any (1) font and all font sizes will be unlocked." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [settingsAlert show];
}

-(void)showAlert:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}


-(void)requestTemplate:(UIButton *)button{
    
    //[self showLoadingView:nil];
    if([AddFriendsController connected]){
        // Create an instance of EBPurchase (Inapp purchase).
        [demoPurchase release];
        demoPurchase = nil;
        demoPurchase = [[EBPurchase alloc] init];
        demoPurchase.delegate = self;
        demoPurchase.customIndex = button.tag;
        isPurchased = NO;
        [demoPurchase requestProduct:@[PRODUCT_TEMPLATE, PRODUCT_FULL_TEMPLATE,
                                  PRODUCT_ALL_BUNDLE]];
    }else{
        [self showAlert:@"You're not connected to the internet. Please connect and retry." message:@""];
    }

}


-(void)requestSymbols:(UIButton *)button{
    
      if([AddFriendsController connected]){
          //[self showLoadingView:nil];
          // Create an instance of EBPurchase (Inapp purchase).
          [demoPurchase release];
          demoPurchase = nil;
          demoPurchase = [[EBPurchase alloc] init];
          demoPurchase.delegate = self;
          demoPurchase.customIndex = button.tag;
          isPurchased = NO;
    
          [demoPurchase requestProduct:@[PRODUCT_SYMBOL_SELETED,PRODUCT_SYMBOL_ALL,PRODUCT_ALL_BUNDLE]];
      }else{
          [self showAlert:@"You're not connected to the internet. Please connect and retry." message:@""];
      }
    
}


-(void)requestIcons:(UIButton *)button{
    
    if([AddFriendsController connected]){
        //[self showLoadingView:nil];
    
        // Create an instance of EBPurchase (Inapp purchase).
        [demoPurchase release];
        demoPurchase = nil;
        demoPurchase = [[EBPurchase alloc] init];
        demoPurchase.delegate = self;
        demoPurchase.customIndex = button.tag;
        isPurchased = NO;
        [demoPurchase requestProduct:@[PRODUCT_ICON_SELETED,PRODUCT_ICON_ALL,PRODUCT_ALL_BUNDLE]];
    }else{
        [self showAlert:@"You're not connected to the internet. Please connect and retry." message:@""];
    }
    
}

-(void)requestFont:(UIButton *)button{
    
    if([AddFriendsController connected]){
        //[self showLoadingView:nil];
        // Create an instance of EBPurchase (Inapp purchase).
        [demoPurchase release];
        demoPurchase = nil;
        demoPurchase = [[EBPurchase alloc] init];
        demoPurchase.delegate = self;
        demoPurchase.customIndex = button.tag;
        isPurchased = NO;

        [demoPurchase requestProduct:@[PRODUCT_FONT, PRODUCT_FULL_FONT, PRODUCT_ALL_BUNDLE]];
    }else{
        [self showAlert:@"You're not connected to the internet. Please connect and retry." message:@""];
    }
 
}

-(void)requestColor:(UIButton *)button{
    
    if([AddFriendsController connected]){
        // [self showLoadingView:nil];

        // Create an instance of EBPurchase (Inapp purchase).
        [demoPurchase release];
        demoPurchase = nil;
        demoPurchase = [[EBPurchase alloc] init];
        demoPurchase.delegate = self;
        demoPurchase.customIndex = button.tag;
        isPurchased = NO;

        [demoPurchase requestProduct:@[PRODUCT_FONT_COLOR, PRODUCT_FULL_FONT_COLOR,
                                  PRODUCT_ALL_BUNDLE]];
    }else{
        [self showAlert:@"You're not connected to the internet. Please connect and retry." message:@""];
    }
}

-(void)requestFontBorder:(UIButton *)button{

     if([AddFriendsController connected]){
         //[self showLoadingView:nil];

         // Create an instance of EBPurchase (Inapp purchase).
         [demoPurchase release];
         demoPurchase = nil;
         demoPurchase = [[EBPurchase alloc] init];
         demoPurchase.delegate = self;
         demoPurchase.customIndex = button.tag;
         isPurchased = NO;
         [demoPurchase requestProduct:@[PRODUCT_FONT_BORDER_COLOR, PRODUCT_FULL_FONT_BORDER_COLOR,
                                  PRODUCT_ALL_BUNDLE]];
     }else{
         [self showAlert:@"You're not connected to the internet. Please connect and retry." message:@""];
     }
}

-(void)requestFlyerBorder:(UIButton *)button{
    
     if([AddFriendsController connected]){
         // [self showLoadingView:nil];

         // Create an instance of EBPurchase (Inapp purchase).
         [demoPurchase release];
         demoPurchase = nil;
         demoPurchase = [[EBPurchase alloc] init];
         demoPurchase.delegate = self;
         demoPurchase.customIndex = button.tag;
         isPurchased = NO;

         [demoPurchase requestProduct:@[PRODUCT_FLYER_BORDER_COLOR,
                                  PRODUCT_FULL_FLYER_BORDER_COLOR, PRODUCT_ALL_BUNDLE]];
     }else{
         [self showAlert:@"You're not connected to the internet. Please connect and retry." message:@""];
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

-(void) requestedProduct:(EBPurchase*)ebp identifier:(NSString*)productId name:(NSString*)productName price:(NSString*)productPrice description:(NSString*)productDescription {
    
    NSLog(@"ProductId: %@", productId);
    // First, ensure that the SKProduct that was requested by
    // the EBPurchase requestProduct method in the viewWillAppear
    // event is valid before trying to purchase it.
    
    //if user want to buy 1 match
    if (demoPurchase.products != nil) {
        
       // [self removeLoadingView];

        [self showFontPurchaseSheet:ebp.customIndex productList:demoPurchase.products];
    }
}

-(NSMutableDictionary *)getInAppDictionary{
    
    NSMutableDictionary *inAppDictionary = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:IN_APP_DICTIONARY_KEY] mutableCopy];
    
    if(!inAppDictionary){
        
        NSMutableDictionary *newInAppDictionary = nil;
        
        if ( [PFUser currentUser] == nil ) {
            NSLog(@"User is null!");
        }
        
        PFQuery *query = [PFQuery queryWithClassName:TABLE_JSON];
        [query whereKey:COLUMN_USER equalTo:[PFUser currentUser]];
        
        NSError *error;
        NSArray *postArray = [query findObjects:&error];
        
        if(!postArray){
            
            newInAppDictionary = [[NSMutableDictionary alloc] init];
            [self setInAppDictionary:newInAppDictionary];
            return [self getInAppDictionary];
        }
        
        PFObject *post = postArray.lastObject;
        if(!post){
        
            newInAppDictionary = [[NSMutableDictionary alloc] init];
            [self setInAppDictionary:newInAppDictionary];
            return [self getInAppDictionary];

        } else {
            
            newInAppDictionary = post[COLUMN_JSON];
        }
        
        if(!newInAppDictionary){
            
            NSMutableDictionary *newInAppDictionary = [[NSMutableDictionary alloc] init];
            [self setInAppDictionary:newInAppDictionary];
            return [self getInAppDictionary];
            
        } else {
            [self setInAppDictionary:newInAppDictionary];
            return newInAppDictionary;
        }

    } else {
        return inAppDictionary;
    }
    
    return inAppDictionary;
}

-(void)setInAppDictionary:(NSMutableDictionary *)inAppDict{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:inAppDict forKey:IN_APP_DICTIONARY_KEY];
    [prefs synchronize];
}

- (void)removeAllViewsFromScrollview:(UIScrollView *)scrollView {
    NSArray *subviews = scrollView.subviews;
    
    for ( UIView *v in subviews ) {
        [v removeFromSuperview];
    }
}

-(void) successfulPurchase:(EBPurchase*)ebp restored:(bool)isRestore identifier:(NSString*)productId receipt:(NSData*)transactionReceipt
{
   
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
        
        // handle post purchase functionality
        if([productId isEqualToString:PRODUCT_FONT] || [productId isEqualToString:PRODUCT_FULL_FONT]){
            
            [self updatePurchaseRecord:ebp.customIndex identifier:productId productPrefix:PREFIX_FONT_PRODUCT];

            // START Update view with no lock
            // Remove all subview from the scrollview first.
            [self removeAllViewsFromScrollview:sizeScrollView];
            [self addSizeInSubView];
            [self layoutScrollImages:sizeScrollView scrollWidth:sizeScrollWidth scrollHeight:sizeScrollHeight];
            
            [self removeAllViewsFromScrollview:fontScrollView];
            [self addFontsInSubView];
            [self layoutScrollImages:fontScrollView scrollWidth:fontScrollWidth scrollHeight:fontScrollHeight];

            // END Update view with no lock

        } else if([productId isEqualToString:PRODUCT_FONT_COLOR] || [productId isEqualToString:PRODUCT_FULL_FONT_COLOR]){
           
            [self updatePurchaseRecord:ebp.customIndex identifier:productId productPrefix:PREFIX_FONT_COLOR_PRODUCT];
            
            // START Update view with no lock
            [self removeAllViewsFromScrollview:colorScrollView];
            [self addColorsInSubView];
            [self layoutScrollImages:colorScrollView scrollWidth:colorScrollWidth scrollHeight:colorScrollHeight];
            // END Update view with no lock            
        
        } else if([productId isEqualToString:PRODUCT_FONT_BORDER_COLOR] || [productId isEqualToString:PRODUCT_FULL_FONT_BORDER_COLOR]){
            
            [self updatePurchaseRecord:ebp.customIndex identifier:productId productPrefix:PREFIX_TEXT_BORDER_PRODUCT];
            
            // START Update view with no lock
            [self removeAllViewsFromScrollview:fontBorderScrollView];
            [self addTextBorderInSubView];
            [self layoutScrollImages:fontBorderScrollView scrollWidth:fontBorderScrollWidth scrollHeight:fontBorderScrollHeight];
            // END Update view with no lock
            
        } else if([productId isEqualToString:PRODUCT_FLYER_BORDER_COLOR] || [productId isEqualToString:PRODUCT_FULL_FLYER_BORDER_COLOR]){
            
            [self updatePurchaseRecord:ebp.customIndex identifier:productId productPrefix:PREFIX_FLYER_BORDER_PRODUCT];
            
            // START Update view with no lock
            [self removeAllViewsFromScrollview:borderScrollView];
            [self addFlyerBorderInSubView];
            [self layoutScrollImages:borderScrollView scrollWidth:borderScrollWidth scrollHeight:borderScrollHeight];
            // END Update view with no lock
            
        } else if([productId isEqualToString:PRODUCT_TEMPLATE] || [productId isEqualToString:PRODUCT_FULL_TEMPLATE]){
            
            [self updatePurchaseRecord:ebp.customIndex identifier:productId productPrefix:PREFIX_BACKGROUND_PRODUCT];
            
            // START Update view with no lock
            [self removeAllViewsFromScrollview:templateScrollView];
            [self addTemplatesInSubView];
            [self layoutScrollImages:templateScrollView scrollWidth:templateScrollWidth scrollHeight:templateScrollHeight];
            // END Update view with no lock
        } else if([productId isEqualToString:PRODUCT_ICON_SELETED] || [productId isEqualToString:PRODUCT_ICON_ALL]){
            
            [self updatePurchaseRecord:ebp.customIndex identifier:productId productPrefix:PREFIX_ICON_PRODUCT];
            
            // START Update view with no lock
            [self removeAllViewsFromScrollview:iconScrollView];
            [self addFlyerIconInSubView];
            NSInteger iconScrollWidth = 60;
            NSInteger iconScrollHeight = 50;
            [self layoutScrollImages:iconScrollView scrollWidth:iconScrollWidth scrollHeight:iconScrollHeight];
            // END Update view with no lock

        } else if([productId isEqualToString:PRODUCT_SYMBOL_SELETED] || [productId isEqualToString:PRODUCT_SYMBOL_ALL]){
            
            [self updatePurchaseRecord:ebp.customIndex identifier:productId productPrefix:PREFIX_SYMBOL_PRODUCT];
            
            // START Update view with no lock
            [self removeAllViewsFromScrollview:symbolScrollView];
            [self addSymbolsInSubView];
            NSInteger symbolScrollWidth = 60;
            NSInteger symbolScrollHeight = 50;
            [self layoutScrollImages:symbolScrollView scrollWidth:symbolScrollWidth scrollHeight:symbolScrollHeight];
            // END Update view with no lock
        } else if ( [productId isEqualToString:PRODUCT_ALL_BUNDLE] ) {
            
            // This is as if we have bought all the products.
            [self updatePurchaseRecord:ebp.customIndex identifier:PRODUCT_FULL_FONT
                         productPrefix:PREFIX_FONT_PRODUCT];
            [self updatePurchaseRecord:ebp.customIndex identifier:PRODUCT_FULL_FONT_COLOR
                         productPrefix:PREFIX_FONT_COLOR_PRODUCT];
            [self updatePurchaseRecord:ebp.customIndex identifier:PRODUCT_FULL_FONT_BORDER_COLOR
                         productPrefix:PREFIX_TEXT_BORDER_PRODUCT];
            [self updatePurchaseRecord:ebp.customIndex identifier:PRODUCT_FULL_FLYER_BORDER_COLOR
                         productPrefix:PREFIX_FLYER_BORDER_PRODUCT];
            [self updatePurchaseRecord:ebp.customIndex identifier:PRODUCT_FULL_TEMPLATE
                         productPrefix:PREFIX_BACKGROUND_PRODUCT];
            [self updatePurchaseRecord:ebp.customIndex identifier:PRODUCT_SYMBOL_ALL
                         productPrefix:PREFIX_SYMBOL_PRODUCT];
            [self updatePurchaseRecord:ebp.customIndex identifier:PRODUCT_ICON_ALL
                         productPrefix:PREFIX_ICON_PRODUCT];
            
            // START Update view with no lock
            // Remove all subview from the scrollview first.
            [self removeAllViewsFromScrollview:sizeScrollView];
            [self addSizeInSubView];
            [self layoutScrollImages:sizeScrollView scrollWidth:sizeScrollWidth scrollHeight:sizeScrollHeight];
            
            [self removeAllViewsFromScrollview:fontScrollView];
            [self addFontsInSubView];
            [self layoutScrollImages:fontScrollView scrollWidth:fontScrollWidth scrollHeight:fontScrollHeight];
            
            [self removeAllViewsFromScrollview:colorScrollView];
            [self addColorsInSubView];
            [self layoutScrollImages:colorScrollView scrollWidth:colorScrollWidth scrollHeight:colorScrollHeight];
            
            [self removeAllViewsFromScrollview:fontBorderScrollView];
            [self addTextBorderInSubView];
            [self layoutScrollImages:fontBorderScrollView scrollWidth:fontBorderScrollWidth scrollHeight:fontBorderScrollHeight];

            [self removeAllViewsFromScrollview:borderScrollView];
            [self addFlyerBorderInSubView];
            [self layoutScrollImages:borderScrollView scrollWidth:borderScrollWidth scrollHeight:borderScrollHeight];
            
            [self removeAllViewsFromScrollview:templateScrollView];
            [self addTemplatesInSubView];
            [self layoutScrollImages:templateScrollView scrollWidth:templateScrollWidth scrollHeight:templateScrollHeight];
            
            [self removeAllViewsFromScrollview:symbolScrollView];
            [self addSymbolsInSubView];
            NSInteger symbolScrollWidth = 60;
            NSInteger symbolScrollHeight = 50;
            [self layoutScrollImages:symbolScrollView scrollWidth:symbolScrollWidth scrollHeight:symbolScrollHeight];
            // START Update view with no lock
            [self removeAllViewsFromScrollview:iconScrollView];
            [self addFlyerIconInSubView];
            NSInteger iconScrollWidth = 60;
            NSInteger iconScrollHeight = 50;
            [self layoutScrollImages:iconScrollView scrollWidth:iconScrollWidth scrollHeight:iconScrollHeight];
            // END Update view with no lock
            
            // END Update view with no lock
            
        }
    }
}

/*
 * handle post purchase functionality
 */
-(void)updatePurchaseRecord:(int)index identifier:(NSString*)productId productPrefix:(NSString *)productPrefix{
    NSString *alertMessage;
    
    NSLog(@"ProductId to Store: %@", [[NSString stringWithFormat:@"%@%d", productPrefix, index] stringByReplacingOccurrencesOfString:@"." withString:@""]);
    
    // UPDATE RECORD IN NSUserDefaults
    NSMutableDictionary *inAppDictionary = [self getInAppDictionary];
    inAppDictionary[[productId stringByReplacingOccurrencesOfString:@"." withString:@""]] = @"1";
    inAppDictionary[[[NSString stringWithFormat:@"%@%d", productPrefix, index] stringByReplacingOccurrencesOfString:@"." withString:@""]] = @"1";
    [self setInAppDictionary:inAppDictionary];
    
    // UPDATE RECORD to PARSE
    [self updateParseDB:productId];
    
    // Show message
    alertMessage = [NSString stringWithFormat:@"Your purchase was successful. %@ is unlocked now.", productId];
    
    UIAlertView *updatedAlert = [[UIAlertView alloc] initWithTitle:@"Thank You!" message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [updatedAlert show];
}

-(void)productRequestFailed:(NSError *)error{
    // Purchase or Restore request failed or was cancelled, so notify the user.
    
    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:@"Purchase Stopped" message:@"Either you cancelled the request or Apple reported a transaction error. Please try again later, or contact the app's customer support for assistance." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [failedAlert show];
    
   // [self removeLoadingView];
}

-(void) failedPurchase:(EBPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage {
    // Purchase or Restore request failed or was cancelled, so notify the user.
    
    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:@"Purchase Stopped" message:@"Either you cancelled the request or Apple reported a transaction error. Please try again later, or contact the app's customer support for assistance." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [failedAlert show];
    
  //  [self removeLoadingView];
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
    
    //[self removeLoadingView];
}

-(void) failedRestore:(EBPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage
{
    NSLog(@"ViewController failedRestore");
    
    // Restore request failed or was cancelled, so notify the user.
    
    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:@"Restore Stopped" message:@"Either you cancelled the request or your prior purchase could not be restored. Please try again later, or contact the app's customer support for assistance." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [failedAlert show];
    
    //[self removeLoadingView];
}

-(void) cancelPurchase {
   // [self removeLoadingView];
}

/*
 * Check for product if purchased or not
 */
-(BOOL)isProductPurchased:(NSString *)productToCheck{
    NSMutableDictionary *inAppDictionary = [self getInAppDictionary];
    if(inAppDictionary[productToCheck]){
        return YES;
    }
    
    return NO;
}

- (void)updateParseDB:(NSString *)productId{
    NSMutableDictionary *dict = [self getInAppDictionary];
    [self purchase:TABLE_JSON keyValuePair:dict productId:productId];
}

-(void)purchase:(NSString *)class keyValuePair:(NSMutableDictionary *)keyValuePair productId:(NSString *)productId{
    
    PFQuery *query = [PFQuery queryWithClassName:class];
    [query whereKey:COLUMN_USER equalTo:[PFUser currentUser]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            NSLog(@"Product Purchased");

            NSArray *postArray = objects;
            PFObject *post = postArray.lastObject;
            if(!post){
                post = [PFObject objectWithClassName:class];
                
                PFUser *user = [PFUser currentUser];
                post[COLUMN_USER] = user;
            }

            post[COLUMN_JSON] = keyValuePair;
            [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"Product Purchased");
                }else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
    }];
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
    [layerScrollView release];    
    
}

-(void) logLayerAddedEvent{
    [Flurry logEvent:@"Layer Added"];
}

-(void) logPhotoAddedEvent{
    [Flurry logEvent:@"Photo Added"];
}

-(void) logTextAddedEvent{
    [Flurry logEvent:@"Text Added"];
}
@end
