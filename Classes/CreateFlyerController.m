
//  Flyer
//
//  Created by Riksof Pvt. Ltd on 12/10/09.
//
//

#import "CreateFlyerController.h"

@implementation CreateFlyerController
@synthesize flyimgView,imgView,imageNameNew,finalFlyer;
@synthesize selectedFont,selectedColor;
@synthesize selectedTemplate,selectedSymbol,selectedIcon;
@synthesize fontTabButton,colorTabButton,sizeTabButton,fontEditButton,selectedText,selectedSize,fontBorderTabButton,addMoreIconTabButton,addMorePhotoTabButton,addMoreSymbolTabButton;
@synthesize templateBckgrnd,textBackgrnd;
@synthesize cameraTabButton,photoTabButton,widthTabButton,heightTabButton,photoImgView,symbolImgView,iconImgView;
@synthesize warningAlert,deleteAlert;
@synthesize  imgPickerFlag,finalImgWritePath, addMoreLayerOrSaveFlyerLabel, takeOrAddPhotoLabel,layerScrollView;
@synthesize flyerNumber,flyerPath,flyer;

//Version 3 Change
@synthesize contextView,libraryContextView,libFlyer,backgroundTabButton,addMoreFontTabButton;
@synthesize libText,libBackground,libPhoto,libEmpty,backtemplates,cameraTakePhoto,cameraRoll,flyerBorder;
@synthesize currentLayer,layersDic;

int selectedAddMoreLayerTab = -1; // This variable is used as a flag to track selected Tab on Add More


#pragma mark  View Appear Methods

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:YES];
    
    //Here we Set Top Bar Item
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:TITLE_FONT size:18];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];
    titleLabel.text = [flyer getFlyerTitle];
    self.navigationItem.titleView = titleLabel;
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    
    [addMoreLayerOrSaveFlyerLabel setText:@"CREATE YOUR FLYER WITH THE FEATURES BELOW THEN SHARE WITH THE WORLD"];    [addMoreLayerOrSaveFlyerLabel setNumberOfLines:2];
    [addMoreLayerOrSaveFlyerLabel setBackgroundColor:[UIColor clearColor]];
    [addMoreLayerOrSaveFlyerLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:16]];
    [addMoreLayerOrSaveFlyerLabel setTextColor:[UIColor grayColor]];
    [addMoreLayerOrSaveFlyerLabel setTextAlignment:UITextAlignmentCenter];

    
    [takeOrAddPhotoLabel setText:@"TAKE OR ADD PHOTO & RESIZE"];
    [takeOrAddPhotoLabel setBackgroundColor:[UIColor clearColor]];
    [takeOrAddPhotoLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:18]];
    [takeOrAddPhotoLabel setTextColor:[UIColor grayColor]];
    [takeOrAddPhotoLabel setTextAlignment:UITextAlignmentCenter];
 
	photoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 50, 220, 200)];
	[photoImgView setUserInteractionEnabled:NO];
    
	symbolImgView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 50, 90, 70)];
	[symbolImgView setUserInteractionEnabled:NO];
    
	iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(150, 50, 90, 70)];
	[iconImgView setUserInteractionEnabled:NO];
	
	textBackgrnd = [[UIImageView alloc]initWithFrame:CGRectMake(0, 385, 320, 44)];
	[self.view addSubview:textBackgrnd];
	textBackgrnd.alpha = ALPHA0;
    
    
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
	
 
	
    // Create color array
	colorArray = 	[[NSArray  alloc] initWithObjects: [UIColor redColor], [UIColor blueColor], [UIColor greenColor], [UIColor blackColor], [UIColor colorWithRed:253.0/255.0 green:191.0/255.0 blue:38.0/224.0 alpha:1], [UIColor colorWithWhite:1.0f alpha:1.0f], [UIColor grayColor], [UIColor magentaColor], [UIColor yellowColor], [UIColor colorWithRed:163.0/255.0 green:25.0/255.0 blue:2.0/224.0 alpha:1], [UIColor colorWithRed:3.0/255.0 green:15.0/255.0 blue:41.0/224.0 alpha:1], [UIColor purpleColor], [UIColor colorWithRed:85.0/255.0 green:86.0/255.0 blue:12.0/224.0 alpha:1], [UIColor orangeColor], [UIColor colorWithRed:98.0/255.0 green:74.0/255.0 blue:9.0/224.0 alpha:1], [UIColor colorWithRed:80.0/255.0 green:7.0/255.0 blue:1.0/224.0 alpha:1], [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:97.0/224.0 alpha:1], [UIColor colorWithRed:111.0/255.0 green:168.0/255.0 blue:100.0/224.0 alpha:1], [UIColor cyanColor], [UIColor colorWithRed:17.0/255.0 green:69.0/255.0 blue:70.0/224.0 alpha:1], [UIColor colorWithRed:173.0/255.0 green:127.0/255.0 blue:251.0/224.0 alpha:1], nil];
	
    
    // Create border colors array
    borderArray = 	[[NSArray  alloc] initWithObjects: [UIColor blackColor], [UIColor grayColor], [UIColor darkGrayColor], [UIColor blueColor], [UIColor purpleColor], [UIColor colorWithRed:115.0/255.0 green:134.0/255.0 blue:144.0/255.0 alpha:1], [UIColor orangeColor], [UIColor greenColor], [UIColor redColor], [UIColor colorWithRed:14.0/255.0 green:95.0/255.0 blue:111.0/255.0 alpha:1], [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:149.0/255.0 alpha:1], [UIColor colorWithRed:228.0/255.0 green:128.0/255.0 blue:144.0/255.0 alpha:1], [UIColor colorWithRed:213.0/255.0 green:110.0/255.0 blue:86.0/255.0 alpha:1],[UIColor colorWithRed:156.0/255.0 green:195.0/255.0 blue:233.0/255.0 alpha:1],[UIColor colorWithRed:27.0/255.0 green:70.0/255.0 blue:148.0/255.0 alpha:1],[UIColor colorWithRed:234.0/255.0 green:230.0/255.0 blue:51.0/255.0 alpha:1],[UIColor cyanColor], [UIColor colorWithRed:232.0/255.0 green:236.0/255.0 blue:51.0/224.0 alpha:1],[UIColor magentaColor],[UIColor colorWithRed:57.0/255.0 green:87.0/255.0 blue:13.0/224.0 alpha:1], [UIColor colorWithRed:93.0/255.0 green:97.0/255.0 blue:196.0/224.0 alpha:1],nil];




    //Setting Tags
	fontTabButton.tag = 10001;
	colorTabButton.tag = 10002;
    sizeTabButton.tag = 10003;
	fontBorderTabButton.tag = 10004; //tag Change 5 to 4    //borderTabButton.tag = 10004;
   
    //Setting LibPhoto tabs tag
	cameraTabButton.tag = 10001;
	photoTabButton.tag = 10002;
	widthTabButton.tag = 10003;
	heightTabButton.tag = 10004;
	
    // Add more layer tabs
	addMoreFontTabButton.tag = 10001;
	
    [addMorePhotoTabButton setBackgroundImage:[UIImage imageNamed:@"image_icon_selected"] forState:UIControlStateHighlighted];
	addMorePhotoTabButton.tag = 10002;
	
    [addMoreSymbolTabButton setBackgroundImage:[UIImage imageNamed:@"symbolicon_button_selected"] forState:UIControlStateHighlighted];
	addMoreSymbolTabButton.tag = 10003;
    
    [addMoreIconTabButton setBackgroundImage:[UIImage imageNamed:@"icon_button_selected"] forState:UIControlStateHighlighted];
    addMoreIconTabButton.tag = 10004;
    

}


-(void)viewDidLoad{
	[super viewDidLoad];
    
    //Render Flyer
    [self renderFlyer];
 
    globle = [FlyerlySingleton RetrieveSingleton];
    [self.view setBackgroundColor:[globle colorWithHexString:@"f5f1de"]];
    [self.contextView setBackgroundColor:[globle colorWithHexString:@"f5f1de"]];

    sharePanel = [[UIView alloc] initWithFrame:CGRectMake(320, 64, 290,480 )];
    shareviewcontroller = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
    sharePanel = shareviewcontroller.view;
    sharePanel.hidden = YES;
    [self.view addSubview:sharePanel];
    

    
    // Set height and width of each element of scroll view
    layerXposition =0;
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

    
    
	//Default Selection for start
	selectedFont = [UIFont fontWithName:@"Arial" size:16];
	selectedColor = [UIColor blackColor];	
	selectedText = @"";
	selectedSize = 16;
    
    
    //Set Initial Background Image For Flyer New or Edit
    if(!selectedTemplate){
        selectedTemplate  = [UIImage imageNamed:@"main_area_bg"];
    }
    
    
    imgView.image = selectedTemplate;
    
    
    //layerTile Button
    editButtonGlobal = [[LayerTileButton alloc]init];
    editButtonGlobal.uid = @"";
    
    // Create Main Image View
    templateBckgrnd = [[UIImageView alloc]initWithFrame:CGRectMake(0, 413, 320, 135)];
    
    // Main Scroll Views Initialize
    layerScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,320,130)];
    layersDic = [[NSMutableDictionary alloc] init];

    
    //Setting ScrollView
    /*
    [layerScrollView setCanCancelContentTouches:NO];
    layerScrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    layerScrollView.clipsToBounds = YES;
    layerScrollView.scrollEnabled = YES;
    layerScrollView.pagingEnabled = NO;
    layerScrollView.showsHorizontalScrollIndicator = YES;
    layerScrollView.showsVerticalScrollIndicator = YES;*/
  
    
    //all Labels Intialize
    //for Using in ContextView
    takeOrAddPhotoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 310, 43)];
    addMoreLayerOrSaveFlyerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 310, 63)];
    
	templateArray = [[NSMutableArray alloc]init];
    
	imgPickerFlag =1;
    selectedAddMoreLayerTab = -1;
    
    //Right ShareButton
    shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    shareButton.titleLabel.font = [UIFont fontWithName:@"Signika-Semibold" size:13];
	[shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"share_button"] forState:UIControlStateNormal];

    shareButton.showsTouchWhenHighlighted = YES;
    
    //Right UndoButton
    UIButton *undoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    undoButton.titleLabel.font = [UIFont fontWithName:@"Signika-Semibold" size:13];
	[undoButton addTarget:self action:@selector(undoFlyer) forControlEvents:UIControlEventTouchUpInside];
    [undoButton setBackgroundImage:[UIImage imageNamed:@"undo"] forState:UIControlStateNormal];
    undoButton.showsTouchWhenHighlighted = YES;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    rightUndoBarButton = [[UIBarButtonItem alloc] initWithCustomView:undoButton];
    
    
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,rightUndoBarButton,nil]];
    
    //Set Undo Bar Status
    [self setUndoStatus];
    
    //Left BackButton
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [backButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	[backButton addTarget:self action:@selector(callMenu) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    //Left HelpButton
    UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [helpButton addTarget:self action:@selector(loadHelpController) forControlEvents:UIControlEventTouchUpInside];
    [helpButton setBackgroundImage:[UIImage imageNamed:@"help_icon"] forState:UIControlStateNormal];
    helpButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarHelpButton = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
    
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:backBarButton,leftBarHelpButton,nil]];
    
    //Set Context View
    [self addAllLayersIntoScrollView ];
    
    //Set Context Tabs
    [self addBottomTabs:libFlyer];
    
    currentLayer = @"";

}

/*
 * This resets the flyer image view by removing and readding all its subviews
 */
-(void)renderFlyer {

    // Remove all Subviews inside image view
    NSArray *viewsToRemove = [self.flyimgView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    NSArray *flyerPiecesKeys = [flyer allKeys];
    
    for (int i = 0 ; i < flyerPiecesKeys.count; i++) {
        
        //Getting Layers Detail from Master Dictionary
        NSMutableDictionary *dic = [flyer getLayerFromMaster:[flyerPiecesKeys objectAtIndex:i]];
        
        //Create Subview from dictionary
        [self.flyimgView renderLayer:[flyerPiecesKeys objectAtIndex:i] layerDictionary:dic];
        
    }
    
}

/*
 * Add templates in scroll views
 */
-(void)addTemplatesInSubView{

    templateScrollWidth = 60;
	templateScrollHeight = 55;
    
    imgPickerFlag =1;
    
    [templateArray removeAllObjects];
    
    //Delete SubViews From ScrollView
    [self deleteSubviewsFromScrollView];
    
    CGFloat curXLoc = 0;
    CGFloat curYLoc = 5;
    
    if(IS_IPHONE_5)
        curYLoc = 10;
    
    //Getting Last Image Tag for highlight
    NSString *LastTag = [flyer getImageTag:@"Template"];
    
	for(int i=0;i<67;i++) {
        
		NSString* templateName = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Template%d",i] ofType:@"jpg"];
		UIImage *templateImg =  [UIImage imageWithContentsOfFile:templateName];
        
		[templateArray addObject:templateImg];
		
		NSString* iconName = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon%d",i] ofType:@"jpg"];
		UIImage *iconImg =   [UIImage  imageWithContentsOfFile:iconName];
		
		UIButton *templateButton = [UIButton  buttonWithType:UIButtonTypeCustom];
		templateButton.frame =CGRectMake(0, 5,templateScrollWidth, templateScrollHeight);
        [templateButton addTarget:self action:@selector(selectTemplate:) forControlEvents:UIControlEventTouchUpInside];

        [templateButton setBackgroundColor:[UIColor whiteColor]];
        
		UIImageView *img = [[UIImageView alloc]initWithImage:iconImg];
		img.frame  = CGRectMake(templateButton.frame.origin.x+5, templateButton.frame.origin.y-2, templateButton.frame.size.width-10, templateButton.frame.size.height-7);
		[templateButton addSubview:img];
		templateButton.tag = i;
        
        CGRect frame = templateButton.frame;
        frame.origin = CGPointMake(curXLoc, curYLoc);
        templateButton.frame = frame;
        curXLoc += (templateScrollWidth)+5;
        
        if(IS_IPHONE_5){
            if(curXLoc >= 320){
                curXLoc = 0;
                curYLoc = curYLoc + templateScrollHeight + 7;
            }
        }
        
        //Here we Hightlight Last Selected Image
        if (![LastTag isEqualToString:@""] && LastTag != nil) {
            
            if ([LastTag intValue] == i ) {
                
                // Add border to selected layer thumbnail
                [templateButton.layer setCornerRadius:8];
                [templateButton.layer setBorderWidth:3.0];
                UIColor * c = [globle colorWithHexString:@"0197dd"];
                [templateButton.layer setBorderColor:c.CGColor];
            }
            
        }
        
		[layerScrollView addSubview:templateButton];
        
	}// Loop
    
    if(IS_IPHONE_5){
        [layerScrollView setContentSize:CGSizeMake(320, curYLoc + templateScrollHeight)];
    } else {
        [layerScrollView setContentSize:CGSizeMake(([templateArray count]*(templateScrollWidth+5)), [layerScrollView bounds].size.height)];
    }
    
    [layerScrollView flashScrollIndicators];

}

/*
 * Add fonts in scroll views
 */
-(void)addFontsInSubView{
    
    
    [self deleteSubviewsFromScrollView];
    
    CGFloat curXLoc = 0;
    CGFloat curYLoc = 5;
    int increment = 5;
    
    if(IS_IPHONE_5){
         curXLoc = 13;
        curYLoc = 10;
        increment = 8;
    }

    NSMutableDictionary *textLayer;
    NSString *textFamily;
    
   //Getting Last Info of Text Layer
    if (![currentLayer isEqualToString:@""]) {
        textLayer = [flyer getLayerFromMaster:currentLayer];
        textFamily = [textLayer objectForKey:@"fontname"];
    }
    
	for (int i = 1; i <=[fontArray count] ; i++)
	{
		UIButton *font = [UIButton buttonWithType:UIButtonTypeCustom];
		font.frame = CGRectMake(0, 0, fontScrollWidth, fontScrollHeight);
        
        [font addTarget:self action:@selector(selectFont:) forControlEvents:UIControlEventTouchUpInside];
		
		[font setTitle:@"A" forState:UIControlStateNormal];
		UIFont *fontname =fontArray[(i-1)];
		[font.titleLabel setFont: fontname];
		[font setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		font.tag = i;
		[font setBackgroundImage:[UIImage imageNamed:@"a_bg"] forState:UIControlStateNormal];
        
        //SET BUTTON POSITION ON SCROLLVIEW
        CGRect frame = font.frame;
        frame.origin = CGPointMake(curXLoc, curYLoc);
        font.frame = frame;
        curXLoc += (fontScrollWidth)+increment;
        
        if(IS_IPHONE_5){
            if(curXLoc >= 300){
                curXLoc = 13;
                curYLoc = curYLoc + fontScrollWidth + 7;
            }
        }
        
        
        //Here we Highlight Last Font Selected
        if (textLayer) {
            
            NSString *fontFamily = [fontname familyName];
            
            if ([textFamily isEqualToString:fontFamily]) {
                
                // Add border to selected layer thumbnail
                [font.layer setBorderWidth:3.0];
                [font.layer setCornerRadius:8];
                UIColor * c = [globle colorWithHexString:@"0197dd"];
                [font.layer setBorderColor:c.CGColor];
            }
            
        }

        
        [layerScrollView addSubview:font];
        
	}
    
    if(IS_IPHONE_5){
        [layerScrollView setContentSize:CGSizeMake(320, curYLoc)];
    } else {
        [layerScrollView setContentSize:CGSizeMake((  [fontArray count]*(fontScrollWidth+5)), [layerScrollView bounds].size.height)];
    }

    [layerScrollView flashScrollIndicators];
}

/*
 * Add sizes in scroll views
 */
-(void)addSizeInSubView{
    
    //DELETE SUBVIEWS
    [self deleteSubviewsFromScrollView];
    
    CGFloat curXLoc = 0;
    CGFloat curYLoc = 5;
    int increment = 5;
    
    if(IS_IPHONE_5){
        curXLoc = 13;
        curYLoc = 10;
        increment = 8;
    }

    NSMutableDictionary *textLayer;
    NSString *textSize;

    
    //Getting Last Info of Text Layer
    if (![currentLayer isEqualToString:@""]) {
        textLayer = [flyer getLayerFromMaster:currentLayer];
        textSize = [textLayer objectForKey:@"fontsize"];
    }
    
	for (int i = 1; i <=  [SIZE_ARRAY count] ; i++)
	{
		UIButton *size = [UIButton buttonWithType:UIButtonTypeCustom];
        [size addTarget:self action:@selector(selectSize:) forControlEvents:UIControlEventTouchUpInside];

		size.frame = CGRectMake(0, 0, sizeScrollWidth, sizeScrollHeight);
		NSString *sizeValue =SIZE_ARRAY[(i-1)];
		[size setBackgroundImage:[UIImage imageNamed:@"a_bg"] forState:UIControlStateNormal];
		[size setTitle:sizeValue forState:UIControlStateNormal];
		[size.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
		[size setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		size.tag = i+60;
		size.alpha = ALPHA1;
        
        CGRect frame = size.frame;
        frame.origin = CGPointMake(curXLoc, curYLoc);
        size.frame = frame;
        curXLoc += (sizeScrollWidth)+increment;
        
        if(IS_IPHONE_5){
            if(curXLoc >= 300){
                curXLoc = 13;
                curYLoc = curYLoc + sizeScrollHeight + 7;
            }
        }

        
        //Here we Highlight Last Size Selected
        if (textLayer) {
            
            NSString *tsize = [NSString stringWithFormat:@"%f", [sizeValue floatValue]];
            
            if ([textSize isEqualToString:tsize]) {
                
                // Add border to selected layer thumbnail
                [size.layer setBorderWidth:3.0];
                [size.layer setCornerRadius:8];
                UIColor * c = [globle colorWithHexString:@"0197dd"];
                [size.layer setBorderColor:c.CGColor];
            }
            
        }


		[layerScrollView addSubview:size];
	}
    
    if(IS_IPHONE_5){
        [layerScrollView setContentSize:CGSizeMake(320, curYLoc)];
    } else {
        [layerScrollView setContentSize:CGSizeMake((  [SIZE_ARRAY count]*(sizeScrollWidth+5)), [layerScrollView bounds].size.height)];
    }
    
    [layerScrollView flashScrollIndicators];

}

/*
 * Add colors in scroll views
 */
-(void)addColorsInSubView{
    
    //Delete Subviews
    [self deleteSubviewsFromScrollView];
    
    CGFloat curXLoc = 0;
    CGFloat curYLoc = 5;
    int increment = 5;
    
    if(IS_IPHONE_5){
        curXLoc = 13;
        curYLoc = 10;
        increment = 8;
    }
    
    NSMutableDictionary *textLayer;
    NSString *textColor;
    NSString *textWhiteColor;
    
    //Getting Last Info of Text Layer
    if (![currentLayer isEqualToString:@""]) {
        textLayer = [flyer getLayerFromMaster:currentLayer];
        textColor = [textLayer objectForKey:@"textcolor"];
        textWhiteColor = [textLayer objectForKey:@"textWhitecolor"];
    }
    
	for (int i = 1; i <=  [colorArray count] ; i++)
	{
		UIButton *color = [UIButton buttonWithType:UIButtonTypeCustom];
		color.frame = CGRectMake(0, 0, colorScrollWidth, colorScrollHeight);
        [color addTarget:self action:@selector(selectColor:) forControlEvents:UIControlEventTouchUpInside];

		id colorName = colorArray[(i-1)];
		UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(color.frame.origin.x, color.frame.origin.y, color.frame.size.width, color.frame.size.height)];
		[label setBackgroundColor:colorName];
        label.layer.borderColor = [UIColor grayColor].CGColor;
        label.layer.borderWidth = 1.0;
		[color addSubview:label];
		color.tag = i + 30;

        CGRect frame = color.frame;
        frame.origin = CGPointMake(curXLoc, curYLoc);
        color.frame = frame;
        curXLoc += (colorScrollWidth)+increment;
        
        if(IS_IPHONE_5){
            if(curXLoc >= 300){
                curXLoc = 13;
                curYLoc = curYLoc + colorScrollHeight + 7;
            }
        }

        
        //Here we Highlight Last Color Selected
        if (textLayer) {
            
            NSString *tcolor;
            NSString *twhite;
            CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0,wht = 0.0;
            
            UILabel *labelToStore = [[UILabel alloc]init];
            labelToStore.textColor = colorName;
            
            //Getting RGB Color Code
            [labelToStore.textColor getRed:&red green:&green blue:&blue alpha:&alpha];
            
            tcolor = [NSString stringWithFormat:@"%f, %f, %f", red, green, blue];
            
            [labelToStore.textColor getWhite:&wht alpha:&alpha];
            twhite = [NSString stringWithFormat:@"%f, %f", wht, alpha];
            
            if ([textColor isEqualToString:tcolor] && [textWhiteColor isEqualToString:twhite] ) {
                
                // Add border to selected layer thumbnail
                [color.layer setBorderWidth:3.0];
                [color.layer setCornerRadius:8];
                UIColor * c = [globle colorWithHexString:@"0197dd"];
                [color.layer setBorderColor:c.CGColor];
            }
            
        }
        
        
        [layerScrollView addSubview:color];
	
    }//Loop
    
    if(IS_IPHONE_5){
        [layerScrollView setContentSize:CGSizeMake(320, curYLoc)];
    } else {
        [layerScrollView setContentSize:CGSizeMake((  [colorArray count]*(colorScrollWidth+5)), [layerScrollView bounds].size.height)];
    }
    
    [layerScrollView flashScrollIndicators];
}

/*
 * Add text borders in scroll views
 */
-(void)addTextBorderInSubView{
    
    //Delete subview from ScrollView
    [self deleteSubviewsFromScrollView ];
    
    CGFloat curXLoc = 0;
    CGFloat curYLoc = 5;
    int increment = 5;
    
    if(IS_IPHONE_5){
        curXLoc = 13;
        curYLoc = 10;
        increment = 8;
    }
    
    NSMutableDictionary *textLayer;
    NSString *textColor;
    NSString *textWhiteColor;
    
    //Getting Last Info of Text Layer
    if (![currentLayer isEqualToString:@""]) {
        textLayer = [flyer getLayerFromMaster:currentLayer];
        textColor = [textLayer objectForKey:@"textbordercolor"];
        textWhiteColor = [textLayer objectForKey:@"textborderWhite"];
    }
    
	for (int i = 1; i <=  [borderArray count] ; i++)
	{
		UIButton *color = [UIButton buttonWithType:UIButtonTypeCustom];
		color.frame = CGRectMake(0, 0, borderScrollWidth, borderScrollHeight);
         [color addTarget:self action:@selector(selectFontBorder:) forControlEvents:UIControlEventTouchUpInside];
		UIColor *colorName =borderArray[(i-1)];
		UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(color.frame.origin.x, color.frame.origin.y, color.frame.size.width, color.frame.size.height)];
        label.layer.borderColor = colorName.CGColor;
        label.layer.borderWidth = 3.0;
		[color addSubview:label];
		color.tag = i+90;
		color.alpha = ALPHA1;

        
        CGRect frame = color.frame;
        frame.origin = CGPointMake(curXLoc, curYLoc);
        color.frame = frame;
        curXLoc += (borderScrollWidth)+increment;
        
        if(IS_IPHONE_5){
            if(curXLoc >= 300){
                curXLoc = 13;
                curYLoc = curYLoc + borderScrollHeight + 7;
            }
        }
        
        //Here we Highlight Last Color Selected
        if (textLayer) {
            
            NSString *tcolor;
            NSString *twhite;
            CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0,wht = 0.0;
            
            UILabel *labelToStore = [[UILabel alloc]init];
            labelToStore.textColor = colorName;
            
            //Getting RGB Color Code
            [labelToStore.textColor getRed:&red green:&green blue:&blue alpha:&alpha];
            
            tcolor = [NSString stringWithFormat:@"%f, %f, %f", red, green, blue];
            
            [labelToStore.textColor getWhite:&wht alpha:&alpha];
            twhite = [NSString stringWithFormat:@"%f, %f", wht, alpha];
            
            if ([textColor isEqualToString:tcolor] && [textWhiteColor isEqualToString:twhite] ) {
                // Add border to selected layer thumbnail
                color.backgroundColor = [globle colorWithHexString:@"0197dd"];
            }
            
        }
        
		[layerScrollView addSubview:color];
        
	}// Loop
    
    if(IS_IPHONE_5){
        [layerScrollView setContentSize:CGSizeMake(320, curYLoc)];
    } else {
        [layerScrollView setContentSize:CGSizeMake((  [borderArray count]*(borderScrollWidth+5)), [layerScrollView bounds].size.height)];
    }
    
    [layerScrollView flashScrollIndicators];

}

/*
 * Add flyer borders in scroll views
 */
-(void)addFlyerBorderInSubView {
    
    //Delete Subviews From ScrollView
    [self deleteSubviewsFromScrollView];
    
    CGFloat curXLoc = 0;
    CGFloat curYLoc = 5;
    int increment = 5;
    
    if(IS_IPHONE_5){
        curXLoc = 13;
        curYLoc = 10;
        increment = 8;
    }
    
    NSMutableDictionary *templateDic;
    NSString *textColor;
    NSString *textWhiteColor;
    
    //Getting Last Info of Text Layer
    templateDic = [flyer getLayerFromMaster:@"Template"];
    textColor = [templateDic objectForKey:@"bordercolor"];
    textWhiteColor = [templateDic objectForKey:@"bordercolorWhite"];

	for (int i = 1; i <=  [borderArray count] ; i++)
	{
		UIButton *color = [UIButton buttonWithType:UIButtonTypeCustom];
		color.frame = CGRectMake(0, 0, borderScrollWidth, borderScrollHeight);
        [color addTarget:self action:@selector(selectBorder:) forControlEvents:UIControlEventTouchUpInside];
		UIColor *colorName =borderArray[(i-1)];
		UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(color.frame.origin.x, color.frame.origin.y, color.frame.size.width, color.frame.size.height)];
        label.layer.borderColor = colorName.CGColor;
        label.layer.borderWidth = 3.0;
		[color addSubview:label];
		color.tag = i+90;
		color.alpha = ALPHA1;
        
        CGRect frame = color.frame;
        frame.origin = CGPointMake(curXLoc, curYLoc);
        color.frame = frame;
        curXLoc += (borderScrollWidth)+increment;
        
        if(IS_IPHONE_5){
            if(curXLoc >= 300){
                curXLoc = 13;
                curYLoc = curYLoc + borderScrollHeight + 7;
            }
        }
        
        //Here we Highlight Last Color Selected
        if (textColor != nil) {
            
            NSString *tcolor;
            NSString *twhite;
            CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0,wht = 0.0;
            
            UILabel *labelToStore = [[UILabel alloc]init];
            labelToStore.textColor = colorName;
            
            //Getting RGB Color Code
            [labelToStore.textColor getRed:&red green:&green blue:&blue alpha:&alpha];
            
            tcolor = [NSString stringWithFormat:@"%f, %f, %f", red, green, blue];
            
            [labelToStore.textColor getWhite:&wht alpha:&alpha];
            twhite = [NSString stringWithFormat:@"%f, %f", wht, alpha];
            
            if ([textColor isEqualToString:tcolor] && [textWhiteColor isEqualToString:twhite] ) {
                // Add border to selected layer thumbnail
                color.backgroundColor = [globle colorWithHexString:@"0197dd"];
            }
            
        }

        
		[layerScrollView addSubview:color];
        
	}//Loop
    
    if(IS_IPHONE_5){
        [layerScrollView setContentSize:CGSizeMake(320, curYLoc)];
    } else {
        [layerScrollView setContentSize:CGSizeMake((  [borderArray count]*(borderScrollWidth+5)), [layerScrollView bounds].size.height)];
    }
    
    [layerScrollView flashScrollIndicators];

}
/*
 * Add flyer Symbols in scroll views
 */
-(void)addSymbolsInSubView{

	NSInteger symbolScrollWidth = 60;
	NSInteger symbolScrollHeight = 50;

	symbolArray = [[NSMutableArray alloc]init];
    
    //Delete Subviews of ScrollViews
    [self deleteSubviewsFromScrollView];
    
    CGFloat curXLoc = 0;
    CGFloat curYLoc = 5;
    
    //Getting Last Image Tag for highlight
    NSString *LastTag = [flyer getImageTag:currentLayer];
    
	for(int i=1;i<=113;i++) {
        
		NSString* symbolName = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"symbol%d",i] ofType:@"png"];
		UIImage *symbolImg =  [UIImage imageWithContentsOfFile:symbolName];
        
		[symbolArray addObject:symbolImg];
		
		UIButton *symbolButton = [UIButton  buttonWithType:UIButtonTypeCustom];
		symbolButton.frame =CGRectMake(0, 0,symbolScrollWidth, symbolScrollHeight);
        
        [symbolButton addTarget:self action:@selector(selectSymbol:) forControlEvents:UIControlEventTouchUpInside];
        
        [symbolButton setBackgroundColor:[globle colorWithHexString:@"f5f1de"]];
        
		UIImageView *img = [[UIImageView alloc]initWithImage:symbolImg];
		img.frame  = CGRectMake(symbolButton.frame.origin.x+5, symbolButton.frame.origin.y-2, symbolButton.frame.size.width-10, symbolButton.frame.size.height-7);
		[symbolButton addSubview:img];
		symbolButton.tag = i;
        
        
        CGRect frame = symbolButton.frame;
        frame.origin = CGPointMake(curXLoc, curYLoc);
        symbolButton.frame = frame;
        curXLoc += (symbolScrollWidth)+5;
        
        if(IS_IPHONE_5){
            if(curXLoc >= 320){
                curXLoc = 0;
                curYLoc = curYLoc + symbolScrollHeight + 7;
            }
        }
        
        //Here we Hightlight Last Selected Image
        if (![LastTag isEqualToString:@""]) {
            
            if ([LastTag intValue] == i ) {
                
                // Add border to selected layer thumbnail
                [symbolButton.layer setCornerRadius:8];
                [symbolButton.layer setBorderWidth:3.0];
                UIColor * c = [globle colorWithHexString:@"0197dd"];
                [symbolButton.layer setBorderColor:c.CGColor];
            }
            
        }
        
		[layerScrollView addSubview:symbolButton];
        
	}//loop
    
    if(IS_IPHONE_5){
        [layerScrollView setContentSize:CGSizeMake(320, curYLoc + symbolScrollHeight)];
    } else {
        [layerScrollView setContentSize:CGSizeMake(([symbolArray count]*(symbolScrollWidth+5)), [layerScrollView bounds].size.height)];
    }
    
    [layerScrollView flashScrollIndicators];


}

/*
 * Add flyer Icons in scroll views
 */
-(void)addFlyerIconInSubView{
    
    NSInteger iconScrollWidth = 60;
	NSInteger iconScrollHeight = 50;
    
	iconArray = [[NSMutableArray alloc]init];
    
    //Delete SubViews from ScrollView
    [self deleteSubviewsFromScrollView];
    
    CGFloat curXLoc = 0;
    CGFloat curYLoc = 5;
    
    if(IS_IPHONE_5)
        curYLoc = 10;
    
    //Getting Last Image Tag for highlight
    NSString *LastTag = [flyer getImageTag:currentLayer];
    
	for(int i=1;i<=94;i++) {
        
		NSString* iconName = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"ricon%d",i] ofType:@"png"];
		UIImage *iconImg =  [UIImage imageWithContentsOfFile:iconName];
        
		[iconArray addObject:iconImg];
		
		UIButton *iconButton = [UIButton  buttonWithType:UIButtonTypeCustom];
		iconButton.frame =CGRectMake(0, 5,iconScrollWidth, iconScrollHeight);
        [iconButton addTarget:self action:@selector(selectIcon:) forControlEvents:UIControlEventTouchUpInside];

        [iconButton setBackgroundColor:[globle colorWithHexString:@"f5f1de"]];
        
		UIImageView *img = [[UIImageView alloc]initWithImage:iconImg];
		img.frame  = CGRectMake(iconButton.frame.origin.x+5, iconButton.frame.origin.y-2, iconButton.frame.size.width-10, iconButton.frame.size.height-7);
		[iconButton addSubview:img];
		iconButton.tag = i;
        
        
        CGRect frame = iconButton.frame;
        frame.origin = CGPointMake(curXLoc, curYLoc);
        iconButton.frame = frame;
        curXLoc += (iconScrollWidth)+5;
        
        if(IS_IPHONE_5){
            if(curXLoc >= 320){
                curXLoc = 0;
                curYLoc = curYLoc + iconScrollHeight + 7;
            }
        }

        //Here we Hightlight Last Selected Image
        if (![LastTag isEqualToString:@""]) {
            
            if ([LastTag intValue] == i ) {
                
                // Add border to selected layer thumbnail
                [iconButton.layer setCornerRadius:8];
                [iconButton.layer setBorderWidth:3.0];
                UIColor * c = [globle colorWithHexString:@"0197dd"];
                [iconButton.layer setBorderColor:c.CGColor];
            }
            
        }
        
		[layerScrollView addSubview:iconButton];
        
    }//loop
    
    if(IS_IPHONE_5){
        [layerScrollView setContentSize:CGSizeMake(320, curYLoc + iconScrollHeight)];
    } else {
        [layerScrollView setContentSize:CGSizeMake(([iconArray count]*(iconScrollWidth+5)), [layerScrollView bounds].size.height)];
    }
    
    [layerScrollView flashScrollIndicators];

}


/*
 * When any font is selected
 */
-(void)selectFont:(id)sender
{
	FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
	appDele.changesFlag = YES;
	int  i=1;
	UIButton *view = sender;
	for(UIView *tempView  in [layerScrollView subviews])
	{
        // Add border to Un-select layer thumbnail
        CALayer * l = [tempView layer];

        [l setBorderWidth:1];
        [l setCornerRadius:8];
        UIColor * c = [UIColor clearColor];
        [l setBorderColor:c.CGColor];

		if(tempView == view)
		{
			selectedFont = fontArray[i-1];
			selectedFont = [selectedFont fontWithSize:selectedSize];
            
            //Here we set Font
            [flyer setFlyerTextFont:currentLayer FontName:[NSString stringWithFormat:@"%@",[selectedFont familyName]]];
            
            //Here we call Render Layer on View
            [flyimgView renderLayer:currentLayer layerDictionary:[flyer getLayerFromMaster:currentLayer]];
            
            
            // Add border to selected layer thumbnail
            CALayer * l = [tempView layer];
            [l setBorderWidth:3.0];
            
            UIColor * c = [globle colorWithHexString:@"0197dd"];
            [l setBorderColor:c.CGColor];
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
	for(UIView *tempView  in [layerScrollView subviews])
	{
        // Add border to Un-select layer thumbnail
        CALayer * l = [tempView layer];
        [l setBorderWidth:1];
        [l setCornerRadius:8];
        UIColor * c = [UIColor clearColor];
        [l setBorderColor:c.CGColor];
        
		if(tempView == view)
		{
			selectedColor = colorArray[i-1];
            
            [flyer setFlyerTextColor:currentLayer RGBColor:selectedColor];
            
            //Here we call Render Layer on View
            [flyimgView renderLayer:currentLayer layerDictionary:[flyer getLayerFromMaster:currentLayer]];
            
            // Add border to selected layer thumbnail
            CALayer * l = [tempView layer];
            [l setBorderWidth:3.0];
            UIColor * c = [globle colorWithHexString:@"0197dd"];
            [l setBorderColor:c.CGColor];
		}
		i++;
	}
}

/*
 * When any size is selected
 */
-(void)selectSize:(id)sender{
	FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
	appDele.changesFlag = YES;
	int  i=1;
	UIButton *view = sender;
	for(UIView *tempView  in [layerScrollView subviews])
	{
        // Add border to Un-select layer thumbnail
        CALayer * l = [tempView layer];
        [l setBorderWidth:1];
        [l setCornerRadius:8];
        UIColor * c = [UIColor clearColor];
        [l setBorderColor:c.CGColor];
        
		if(tempView == view)
		{
			NSString *sizeStr = SIZE_ARRAY[i-1];
			selectedSize = [sizeStr intValue];
			selectedFont = [selectedFont fontWithSize:selectedSize];
            
            [flyer setFlyerTextSize:currentLayer Size:selectedFont];
            
            //Here we call Render Layer on View
            [flyimgView renderLayer:currentLayer layerDictionary:[flyer getLayerFromMaster:currentLayer]];
            
            // Add border to selected layer thumbnail
            CALayer * l = [tempView layer];
            [l setBorderWidth:3.0];
            UIColor * c = [globle colorWithHexString:@"0197dd"];
            [l setBorderColor:c.CGColor];
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
	for(UIView *tempView  in [layerScrollView subviews]) {
        
        // Add border to Un-select layer thumbnail
        tempView.backgroundColor = [UIColor clearColor];
        
		if( tempView == view ) {
            
			UIColor *borderColor = borderArray[i-1];
            
            [flyer setFlyerTextBorderColor:currentLayer Color:borderColor ];
            
            //Here we call Render Layer on View
            [flyimgView renderLayer:currentLayer layerDictionary:[flyer getLayerFromMaster:currentLayer]];
            
            // Add border to selected layer thumbnail
            tempView.backgroundColor = [globle colorWithHexString:@"0197dd"];

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
    
    //Handling Select Unselect
    for(UIView *tempView  in [layerScrollView subviews])
    {
        // Add border to Un-select layer thumbnail
        CALayer * l = [tempView layer];
        [l setBorderWidth:1];
        UIColor * c = [UIColor clearColor];
        [l setBorderColor:c.CGColor];
        
        if(tempView == view)
        {
            
            int lstTag = 500;
            NSString *lastTag = [flyer getImageTag:@"Template"];
            
            if (![lastTag isEqualToString:@""]) lstTag = [lastTag intValue];
            
            if (lstTag != view.tag) {
                
                //Getting Image Path
                NSString *imgPath = [self getImagePathByTag:[NSString stringWithFormat:@"Template%d",view.tag]];
            
                //set template Image
                [self.flyimgView setTemplate:imgPath];
                
                //Set Image Tag
                [flyer setImageTag:@"Template" Tag:[NSString stringWithFormat:@"%d",view.tag]];

            }
            
            // Add border to selected layer thumbnail
            CALayer * l = [tempView layer];
            [l setBorderWidth:3.0];
            UIColor * c = [globle colorWithHexString:@"0197dd"];
            [l setBorderColor:c.CGColor];
        }
        
    }
    
    

    
    [Flurry logEvent:@"Background Selected"];
}


/*
 *Here we Copy Image to Template Directory
 */
-(void)copyImageToTemplate :(UIImage *)img{
    
    // Create Symbol direcrory if not created
    NSString* currentpath  =   [[NSFileManager defaultManager] currentDirectoryPath];
    
    NSString *FolderPath = [NSString stringWithFormat:@"%@/Template/template.jpg", currentpath];
    
    NSData *imgData = UIImagePNGRepresentation(img);
    
    //Create a Image Copy to Current Flyer Folder
    [[NSFileManager defaultManager] createFileAtPath:FolderPath contents:imgData attributes:nil];

}

-(NSString *)getImagePathforPhoto :(UIImage *)img{
    
    // Create Symbol direcrory if not created
    NSString* currentpath  =   [[NSFileManager defaultManager] currentDirectoryPath];
    
    NSString *FolderPath;
    NSString *dicPath;

    FolderPath = [NSString stringWithFormat:@"%@/Photo", currentpath];
    dicPath = @"Photo";
    
    //Create Unique Id for Image
    int timestamp = [[NSDate date] timeIntervalSince1970];
    
    NSString *imageFolderPath = [NSString stringWithFormat:@"%@/%d.jpg", FolderPath,timestamp];
    
    dicPath = [dicPath stringByAppendingString:[NSString stringWithFormat:@"/%d.jpg",timestamp]];
    
    NSData *imgData = UIImagePNGRepresentation(img);
    
    //Create a Image Copy to Current Flyer Folder
    [[NSFileManager defaultManager] createFileAtPath:imageFolderPath contents:imgData attributes:nil];
    
    
    return dicPath;
}


-(NSString *)getImagePathByTag :(NSString *)imgName{

    // Create Symbol direcrory if not created
    NSString* currentpath  =   [[NSFileManager defaultManager] currentDirectoryPath];
    
    NSString *FolderPath;
    NSString *dicPath;
    
    //when we create Symbols
    if ([imgName rangeOfString:@"symbol"].location == NSNotFound) {
        NSLog(@"sub string doesnt exist");
    } else {
        FolderPath = [NSString stringWithFormat:@"%@/Symbol", currentpath];
        dicPath = @"Symbol";
    }
    
    //when we create Icon
    if ([imgName rangeOfString:@"ricon"].location == NSNotFound) {
        NSLog(@"sub string doesnt exist");
    } else {
        FolderPath = [NSString stringWithFormat:@"%@/Icon", currentpath];
        dicPath = @"Icon";
    }
    
    //when we set BackGround
    if ([imgName rangeOfString:@"Template"].location == NSNotFound) {
        NSLog(@"sub string doesnt exist");
    } else {
        FolderPath = [NSString stringWithFormat:@"%@/Template", currentpath];
        dicPath = @"Template";
    }
    
    
    NSString *imageFolderPath ;
    NSString *existImagePath ;
    
    if ([dicPath isEqualToString:@"Template"]) {

        imageFolderPath = [NSString stringWithFormat:@"%@/template.jpg", FolderPath];
        dicPath = [dicPath stringByAppendingString:[NSString stringWithFormat:@"/template.jpg"]];

        //Getting Image From Bundle
        existImagePath =[[NSBundle mainBundle] pathForResource:imgName ofType:@"jpg"];

    } else {
        
        //Create Unique Id for Image
        int timestamp = [[NSDate date] timeIntervalSince1970];
        
        imageFolderPath = [NSString stringWithFormat:@"%@/%d.jpg", FolderPath,timestamp];
        dicPath = [dicPath stringByAppendingString:[NSString stringWithFormat:@"/%d.jpg",timestamp]];

        //Getting Image From Bundle
        existImagePath =[[NSBundle mainBundle] pathForResource:imgName ofType:@"png"];

    }
    
    UIImage *realImage =  [UIImage imageWithContentsOfFile:existImagePath];
    NSData *imgData = UIImagePNGRepresentation(realImage);
    
    //Create a Image Copy to Current Flyer Folder
    [[NSFileManager defaultManager] createFileAtPath:imageFolderPath contents:imgData attributes:nil];

    
    return dicPath;

}


/*
 * Called when select a symbol
 */
-(void)selectSymbol:(id)sender
{
    
    UIButton *view = sender;
    [Flurry logEvent:@"Layer Added"];
    [Flurry logEvent:@"Symbol Added"];
    
    int lstTag = 500;
    NSString *lastTag = [flyer getImageTag:currentLayer];

    if (![lastTag isEqualToString:@""]) lstTag = [lastTag intValue];
    
    if (lstTag != view.tag) {
        NSString *imgPath = [self getImagePathByTag:[NSString stringWithFormat:@"symbol%d",view.tag]];
    
        //Set Image Path
        [flyer setImagePath:currentLayer ImgPath:imgPath];
    
        //Set Image Tag
        [flyer setImageTag:currentLayer Tag:[NSString stringWithFormat:@"%d",view.tag]];

    
        [self.flyimgView renderLayer:currentLayer layerDictionary:[flyer getLayerFromMaster:currentLayer]];
        
        //Here we Highlight The ImageView
        [self.flyimgView layerIsBeingEdited:currentLayer];
    }
    
    //Handling Select Unselect
    for(UIView *tempView  in [layerScrollView subviews])
    {
        // Add border to Un-select layer thumbnail
        CALayer * l = [tempView layer];
        [l setBorderWidth:1];
        [l setCornerRadius:8];
        UIColor * c = [UIColor clearColor];
        [l setBorderColor:c.CGColor];
        
        if(tempView == view)
        {
            // Add border to selected layer thumbnail
            CALayer * l = [tempView layer];
            [l setBorderWidth:3.0];
            UIColor * c = [globle colorWithHexString:@"0197dd"];
            [l setBorderColor:c.CGColor];
        }
        
    }
    
}




/*
 * Called when select icon
 */
-(void)selectIcon:(id)sender
{
    
    UIButton *view = sender;
    
    [Flurry logEvent:@"Layer Added"];
    [Flurry logEvent:@"Clip Art Added"];

    int lstTag = 500;
    NSString *lastTag = [flyer getImageTag:currentLayer];
    
    if (![lastTag isEqualToString:@""]) lstTag = [lastTag intValue];
    
    if (lstTag != view.tag) {
        
        NSString *imgPath = [self getImagePathByTag:[NSString stringWithFormat:@"ricon%d",view.tag]];
    
        //Set Symbol Image
        [flyer setImagePath:currentLayer ImgPath:imgPath];
        
        //Set Image Tag
        [flyer setImageTag:currentLayer Tag:[NSString stringWithFormat:@"%d",view.tag]];
    
        [self.flyimgView renderLayer:currentLayer layerDictionary:[flyer getLayerFromMaster:currentLayer]];
        
        //Here we Highlight The ImageView
        [self.flyimgView layerIsBeingEdited:currentLayer];
    }
    
    
    //Handling Select Unselect
    for(UIView *tempView  in [layerScrollView subviews])
    {
        // Add border to Un-select layer thumbnail
        CALayer * l = [tempView layer];
        [l setBorderWidth:1];
        [l setCornerRadius:8];
        UIColor * c = [UIColor clearColor];
        [l setBorderColor:c.CGColor];
        
        if(tempView == view)
        {
            // Add border to selected layer thumbnail
            [l setBorderWidth:3.0];
            UIColor * c = [globle colorWithHexString:@"0197dd"];
            [l setBorderColor:c.CGColor];
            
            
        }
        
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
	for(UIView *tempView  in [layerScrollView subviews])
	{
        
        // Add border to Un-select layer thumbnail
        tempView.backgroundColor = [UIColor clearColor];
        
		if(tempView == view)
		{
            
            UIColor *borderColor = borderArray[i-1];
            currentLayer = @"Template";
            [flyer setFlyerBorder:currentLayer RGBColor:borderColor];
            
            //Here we call Render Layer on View
            [flyimgView setTemplateBorder:[flyer getLayerFromMaster:currentLayer]];
            
            // Add border to selected layer thumbnail
            tempView.backgroundColor = [globle colorWithHexString:@"0197dd"];
		}
		i++;
	}
}



-(void)showLoadingView:(NSString *)message{
    [self showLoadingIndicator];
}

-(void)removeLoadingView{
    [self hideLoadingIndicator];
}



-(void)loadCustomPhotoLibrary{
    
    nbuGallary = [[LibraryViewController alloc] initWithNibName:@"LibraryViewController" bundle:nil];
    
    if ( imgPickerFlag == 2 ) {
        NSDictionary *dict = [flyer getLayerFromMaster:currentLayer];
        nbuGallary.desiredImageSize = CGSizeMake( [[dict valueForKey:@"width"] floatValue],
                                                [[dict valueForKey:@"height"] floatValue]);
    } else {
        nbuGallary.desiredImageSize = CGSizeMake( 300,  300 );
    }
    

    [nbuGallary setOnImageTaken:^(UIImage *img) {
        
        dispatch_async( dispatch_get_main_queue(), ^{
            // Do any UI operation here (render layer).
            if (imgPickerFlag == 2) {
                
                NSString *imgPath = [self getImagePathforPhoto:img];
                
                //Set Image to dictionary
                [flyer setImagePath:currentLayer ImgPath:imgPath];
                
                //Here we Create ImageView Layer
                [self.flyimgView renderLayer:currentLayer layerDictionary:[flyer getLayerFromMaster:currentLayer]];
                
                [self.flyimgView layerStoppedEditing:currentLayer];
                
                imgPickerFlag = 1;
            }else{
                
                //Create Copy of Image
                [self copyImageToTemplate:img];
                
                //set template Image
                [self.flyimgView setTemplate:@"Template/template.jpg"];
                
            }
        });
    }];
    
    [self.navigationController pushViewController:nbuGallary animated:YES];
    [Flurry logEvent:@"Custom Background"];
}



-(void)openCustomCamera{

    nbuCamera = [[CameraViewController alloc]initWithNibName:@"CameraViewController" bundle:nil];
    
    if ( imgPickerFlag == 2 ) {
        NSDictionary *dict = [flyer getLayerFromMaster:currentLayer];
        nbuCamera.desiredImageSize = CGSizeMake( [[dict valueForKey:@"width"] floatValue],
                                                 [[dict valueForKey:@"height"] floatValue]);
    } else {
        nbuCamera.desiredImageSize = CGSizeMake( 300,  300 );
    }
    
    // Callback once image is selected.
    [nbuCamera setOnImageTaken:^(UIImage *img) {
        
        dispatch_async( dispatch_get_main_queue(), ^{
            // Do any UI operation here (render layer).
            
            if (imgPickerFlag == 2) {
                
                NSString *imgPath = [self getImagePathforPhoto:img];
                
                //Set Image to dictionary
                [flyer setImagePath:currentLayer ImgPath:imgPath];
                
                //Here we Create ImageView Layer
                [self.flyimgView renderLayer:currentLayer layerDictionary:[flyer getLayerFromMaster:currentLayer]];
                
                [self.flyimgView layerStoppedEditing:currentLayer];
                
                imgPickerFlag = 1;
            }else{
                
                //Create Copy of Image
                [self copyImageToTemplate:img];
                
                //set template Image
                [self.flyimgView setTemplate:@"Template/template.jpg"];
            }
        });
    }];
    
    
    [self.navigationController pushViewController:nbuCamera animated:YES];

    [Flurry logEvent:@"Custom Background"];
}



#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView == deleteAlert && buttonIndex == 1) {
        
        editButtonGlobal.uid = currentLayer;
        [self deleteLayer:editButtonGlobal overrided:nil];
        [Flurry logEvent:@"Layed Deleted"];
	}

  }

#pragma mark After ViewWillAppear Method Sequence
-(void) callMenu
{
    
    if (![currentLayer isEqualToString:@""]) [self.flyimgView layerStoppedEditing:currentLayer];
        
    
    //Here we take Snap shot of Flyer
    UIGraphicsBeginImageContextWithOptions(self.flyimgView.bounds.size, YES, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.flyimgView.layer renderInContext:context];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //Save OnBack
    [flyer saveFlyer:snapshotImage];
    
    // Update Recent Flyer List
    [flyer setRecentFlyer];
    
    [self.navigationController popViewControllerAnimated:YES];
}



/*
 * When any layer is selected while editing flyer
 * its Also Call editLayer Method
 */
-(void)selectLayer:(id)sender {
    
    UIView *sView = editButtonGlobal;
    
    NSString *tag = [NSString stringWithFormat:@"%d",sView.tag];
    NSLog(@"%@",tag);
    
}


/*
 * When any Layer Tap for Edit its Call 
 * and Here we manage all Layers
 */
-(void)editLayer:(LayerTileButton *)editButton{
    
    
    editButtonGlobal = editButton;
    currentLayer =  editButton.uid;
    editButtonGlobal.uid = currentLayer;
    
    [self.flyimgView layerIsBeingEdited:currentLayer];
    

    //when tap on Text Box
    NSString *btnText = [flyer getText:currentLayer];

    if (![btnText isEqualToString:@""] && btnText != nil) {
        
        lastTextView = [[UITextView  alloc] init];
        lastTextView.text = btnText;
        
        //For Immediate Showing Delete button
        [self callStyle];
    }
    
    
    //when tap on Image Box
    NSString *imgName = [flyer getImageName:currentLayer];
    
    if (![imgName isEqualToString:@""] && imgName != nil) {
        
        //when we tap on Symbols
        if ([imgName rangeOfString:@"Symbol"].location == NSNotFound) {
            NSLog(@"sub string doesnt exist");
        } else {
            // Call Icon
            [self setAddMoreLayerTabAction:addMoreIconTabButton];
        }
        
        //when we tap on icon
        if ([imgName rangeOfString:@"Icon"].location == NSNotFound) {
            NSLog(@"sub string doesnt exist");
        } else {
            
            // Call Symbol
            [self setAddMoreLayerTabAction:addMoreSymbolTabButton];
        }
        
        //when we tap on icon
        if ([imgName rangeOfString:@"Photo"].location == NSNotFound) {
            NSLog(@"sub string doesnt exist");
        } else {
            
            // Call Photo Tab
            [self setAddMoreLayerTabAction:addMorePhotoTabButton];
        }
    }
    
}



-(void)loadHelpController{

    HelpController *helpController = [[HelpController alloc]initWithNibName:@"HelpController" bundle:nil];
    [self.navigationController pushViewController:helpController animated:NO];
    [self callAddMoreLayers];
}




/*
 * Here we Create Text Box for Getting Text And
 * and Set Menu for Text Layer
 */
-(void)callWrite{

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];;
    label.text = @"TEXT";
    self.navigationItem.titleView = label;


    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
	[nextButton addTarget:self action:@selector(callStyle) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
    nextButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
	[backButton addTarget:self action:@selector(callMenu) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
     backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];

    
    //Add Context Library
    [self addBottomTabs:libText];
    
    // Get current layer properties.
    NSDictionary *detail = [flyer getLayerFromMaster:currentLayer];
    
    // Prepare a new text layer.
    lastTextView = [[UITextView alloc] initWithFrame:CGRectMake([[detail valueForKey:@"x"] floatValue], [[detail valueForKey:@"y"] floatValue], [[detail valueForKey:@"width"] floatValue], [[detail valueForKey:@"height"] floatValue])];
    
    // Set the text.
    lastTextView.text = [detail valueForKey:@"text"];
    
    // Set the font.
    lastTextView.font = [UIFont fontWithName:[detail valueForKey:@"fontname"] size:[[detail valueForKey:@"fontsize"] floatValue]];
    
    // Set the text color.
    if ([[detail valueForKey:@"textcolor"] isEqualToString:@"0.000000, 0.000000, 0.000000"]) {
        if ([detail valueForKey:@"textWhitecolor"]  != nil) {
            NSArray *rgb = [[detail valueForKey:@"textWhitecolor"]  componentsSeparatedByString:@","];
            lastTextView.textColor = [UIColor colorWithWhite:[rgb[0] floatValue] alpha:[rgb[1] floatValue]];
        }
    }else{
        NSArray *rgb = [[detail valueForKey:@"textcolor"] componentsSeparatedByString:@","];
        
        lastTextView.textColor = [UIColor colorWithRed:[rgb[0] floatValue] green:[rgb[1] floatValue] blue:[rgb[2] floatValue] alpha:1];
        
    }
    
    lastTextView.textAlignment = UITextAlignmentCenter;
	lastTextView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3f];

	CALayer * l = [lastTextView layer];
	[l setMasksToBounds:YES];
	[l setCornerRadius:10];
	[l setBorderWidth:1.0];
	[l setBorderColor:[[UIColor grayColor] CGColor]];
	[self.flyimgView addSubview:lastTextView];
    
    // Temporarily remove the layer if it was previously rendered.
    [self.flyimgView deleteLayer:currentLayer];
	
    // Show the keyboard.
	[lastTextView becomeFirstResponder];
}


/*
 * Here we Set ScrollView and Bottom Tabs
 * after getting Text
 */
-(void)callStyle
{

    // Done Bar Button
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [doneButton addTarget:self action:@selector(callAddMoreLayers) forControlEvents:UIControlEventTouchUpInside];
    [doneButton addTarget:self action:@selector(logLayerAddedEvent) forControlEvents:UIControlEventTouchUpInside];
    [doneButton addTarget:self action:@selector(logTextAddedEvent) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
         doneButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *DoneBarButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
        
    //Delete Button
    UIButton *delButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 45, 42)];
    [delButton addTarget:self action:@selector(callDeleteLayer) forControlEvents:UIControlEventTouchUpInside];
    [delButton setBackgroundImage:[UIImage imageNamed:@"delete_button"] forState:UIControlStateNormal];
    delButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *delBarButton = [[UIBarButtonItem alloc] initWithCustomView:delButton];
        
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:DoneBarButton,delBarButton,nil]];
    
    //Checking Empty String
    if ([lastTextView.text isEqualToString:@""] ) {
        
        [lastTextView resignFirstResponder];
        [lastTextView removeFromSuperview];
        lastTextView = nil;

        [self callAddMoreLayers];
        return;
    }
    
    
    //Set Text of Layer
    [flyer setFlyerText:currentLayer text:lastTextView.text ];
    
    //Here we call Render Layer on View
    [flyimgView renderLayer:currentLayer layerDictionary:[flyer getLayerFromMaster:currentLayer]];
    
    //Here we Highlight The ImageView
    [self.flyimgView layerIsBeingEdited:currentLayer];
    
    //here we Update Flyer Description if Empty
    NSString *desp = [flyer getFlyerDescription];
    
    if ([desp isEqualToString:@""]) {
        [flyer setFlyerDescription:lastTextView.text];
    }
    
	textBackgrnd.alpha = ALPHA1;

    // SET BOTTOM BAR
    [self setStyleTabAction:fontTabButton];

	[lastTextView resignFirstResponder];
	[lastTextView removeFromSuperview];
    lastTextView = nil;
}

-(void) donePhoto{
    
    [self callAddMoreLayers];
    [self logLayerAddedEvent];
    [self logPhotoAddedEvent];
    
}


-(void)choosePhoto
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-45, -6, 50, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];;
    label.text = @"PHOTO";
    self.navigationItem.titleView = label;
    
    //Delete Bar Button
    UIButton *delButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 45, 42)];
    [delButton addTarget:self action:@selector(callDeleteLayer) forControlEvents:UIControlEventTouchUpInside];
    [delButton setBackgroundImage:[UIImage imageNamed:@"delete_button"] forState:UIControlStateNormal];
    delButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *delBarButton = [[UIBarButtonItem alloc] initWithCustomView:delButton];

    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [doneButton addTarget:self action:@selector(donePhoto) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
    doneButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:doneBarButton,delBarButton,nil]];
 
    //Add Context Library
    [self addBottomTabs:libPhoto];

}



/*
 * Here we Replace Current Flyer Folder From History of Last Generated
 */
-(void)undoFlyer{
    
    //Stop Edit Mode for remove Layer Border if Selected
    [self.flyimgView layerStoppedEditing:currentLayer];
    
    //Here we take Snap shot of Flyer
    UIImage *snapshotImage = [self getFlyerSnapShot];
    
    //First we Save Current flyer in history
    [flyer saveFlyer:snapshotImage];
    
    //Add Flyer in Histor if any Change Exists
    [flyer addToHistory];
    
    //Here we send Request to Model for Move Back
    [flyer replaceFromHistory];
        
    //set Undo Bar Button Status
    [self setUndoStatus];
    
    //Here we Re-Initialize Flyer Instance
    NSString* currentPath  =   [[NSFileManager defaultManager] currentDirectoryPath];
    self.flyer = [[Flyer alloc]initWithPath:currentPath];
    
    //Here we Remove all Object from Controller Dictionary
    [self.flyimgView.layers removeAllObjects];
    
    //Here we Render Flyer
    [self renderFlyer];
    
    //Here we Load Current Layer in ScrollView
    [self addAllLayersIntoScrollView];
    
    [Flurry logEvent:@"Undone"];

}


/*
 * Here we Just Check History is Available in flyer Folder so Undo Bar Button Enable
 * other wise we Disable Undo Bar Button
 */
-(void)setUndoStatus {

    //Getting Current Flyer folder Path
    NSString* currentPath  =   [[NSFileManager defaultManager] currentDirectoryPath];
    
    NSString* historyDestinationpath  =  [NSString stringWithFormat:@"%@/History",currentPath];
    
    NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:historyDestinationpath error:nil];
    
    if (fileList.count >= 1) {
        
        [rightUndoBarButton setEnabled:YES];
        
    } else {
    
        [rightUndoBarButton setEnabled:NO];
    }
    
}


-(void)callAddMoreLayers {
    
    titleLabel.text = [flyer getFlyerTitle];
    
     //ShareButton
    [shareButton setBackgroundImage:[UIImage imageNamed:@"share_button"] forState:UIControlStateNormal];

    
    //UndoButton
    UIButton *undoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    undoButton.titleLabel.font = [UIFont fontWithName:@"Signika-Semibold" size:13];
	[undoButton addTarget:self action:@selector(undoFlyer) forControlEvents:UIControlEventTouchUpInside];
    [undoButton setBackgroundImage:[UIImage imageNamed:@"undo"] forState:UIControlStateNormal];
    undoButton.showsTouchWhenHighlighted = YES;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    rightUndoBarButton = [[UIBarButtonItem alloc] initWithCustomView:undoButton];
    

    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,rightUndoBarButton,nil]];
    
    [self addBottomTabs:libFlyer];
    
    //Set here Un-Selected State of HIGHT & WIDTH Buttons IF selected 
    [widthTabButton setSelected:NO];
    [heightTabButton setSelected:NO];


    
    //Empty Layer Delete
    if (currentLayer != nil && ![currentLayer isEqualToString:@""]) {
        
        
        
        NSString *flyerImg = [flyer getImageName:currentLayer];
        NSString *flyertext = [flyer getText:currentLayer];
        
        if ([flyerImg isEqualToString:@""]) {
            [flyer deleteLayer:currentLayer];
            [self.flyimgView deleteLayer:currentLayer];
        }
        
        if ([flyertext isEqualToString:@""]) {
            [flyer deleteLayer:currentLayer];
            [self.flyimgView deleteLayer:currentLayer];
        }
    }
    
    [self.flyimgView layerStoppedEditing:currentLayer];
    
    //Here we take Snap shot of Flyer
    UIImage *snapshotImage = [self getFlyerSnapShot];
    
    //Here we Save Flyer
    [flyer saveFlyer:snapshotImage];
    
    //Here we Create One History BackUp for Future Undo Request
    [flyer addToHistory];

    //Here we Set Undo Bar Button Status
    [self setUndoStatus];
    
    // Here we Start Animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4f];
        //Here we Add All Generated Layers add into ScrollView
        [self addAllLayersIntoScrollView ];
    [UIView commitAnimations];
    //End Animation
    
    
    currentLayer = @"";
   
}


-(void)share
{
    float xValue = sharePanel.frame.origin.x;
    
    if (xValue == 30) {
        
        [shareviewcontroller.titleView resignFirstResponder];
        [shareviewcontroller.descriptionView resignFirstResponder];

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4f];
        [sharePanel setFrame:CGRectMake(320, 64, 290,480 )];
        
        [UIView commitAnimations];
  
        [shareButton setBackgroundImage:[UIImage imageNamed:@"share_button"] forState:UIControlStateNormal];

        
    } else {
        
        sharePanel.hidden = NO;
        [shareButton setBackgroundImage:[UIImage imageNamed:@"share_button_selected"] forState:UIControlStateNormal];
        NSString *shareImagePath = [flyer getImageForShare];
        UIImage *shareImage =  [UIImage imageWithContentsOfFile:shareImagePath];
        //[self getCurrentFrameAndSaveIt];

        shareviewcontroller.selectedFlyerImage = shareImage;
        shareviewcontroller.flyer = self.flyer;
        shareviewcontroller.imageFileName = shareImagePath;
        shareviewcontroller.detailFileName = [finalImgWritePath stringByReplacingOccurrencesOfString:@".jpg" withString:@".txt"];
        shareviewcontroller.titleView.text = [flyer getFlyerTitle];
        shareviewcontroller.descriptionView.text = [flyer getFlyerDescription];
        shareviewcontroller.selectedFlyerDescription = [flyer getFlyerDescription];
        shareviewcontroller.topTitleLabel = titleLabel;
        
        [shareviewcontroller setSocialStatus];

        [sharePanel setFrame:CGRectMake(320, 64, 290,480 )];
    
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4f];
            [sharePanel setFrame:CGRectMake(30, 64, 290,480 )];
        [UIView commitAnimations];
        
    }
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
}


-(void)loadDistributeView
{
	
	SaveFlyerController *svController = [[SaveFlyerController alloc]initWithNibName:@"SaveFlyerController" bundle:nil];
	svController.flyrImg = finalFlyer;
	svController.ptController = self;
	[self.navigationController pushViewController:svController animated:YES];
}



/*
 * When we click on Text Tab
 * This Method Manage Text SubTabs
 */
-(IBAction)setStyleTabAction:(id) sender
{
    
    [self addBottomTabs:libText];
    
    [fontTabButton setSelected:NO];
    [colorTabButton setSelected:NO];
    [sizeTabButton setSelected:NO];
    [fontBorderTabButton setSelected:NO];
    [fontEditButton setSelected:NO];
    
	UIButton *selectedButton = (UIButton*)sender;
	if(selectedButton == fontTabButton)
	{
        
        // Here we Start Animation
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4f];
            //Create ScrollView
            [self addFontsInSubView ];
        [UIView commitAnimations];
		//End Animation
        
         //Add ContextView
        [self addScrollView:layerScrollView];
        
		[fontTabButton setSelected:YES];
	}
	else if(selectedButton == colorTabButton)
	{
        // Here we Start Animation
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4f];
            //Create ScrollView
            [self addColorsInSubView];
        [UIView commitAnimations];
		//End Animation
        
        
        //Add ContextView
        [self addScrollView:layerScrollView];
        [colorTabButton setSelected:YES];
        
	}
	else if(selectedButton == sizeTabButton)
	{

        // Here we Start Animation
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4f];
            //Create ScrollView
            [self addSizeInSubView];
        [UIView commitAnimations];
		//End Animation
        
        //Add ContextView
        [self addScrollView:layerScrollView];
        
		[sizeTabButton setSelected:YES];
	}
	else if(selectedButton == fontBorderTabButton)
	{
        
        // Here we Start Animation
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4f];
            //Create ScrollView
            [self addTextBorderInSubView];
        [UIView commitAnimations];
		//End Animation
        
        //Add ContextView
        [self addScrollView:layerScrollView];
        
		[fontBorderTabButton setSelected:YES];
	}
    else if(selectedButton == fontEditButton)
	{
        [fontEditButton setSelected:YES];
        [self callWrite];
	}
    
}


/*
 * When we click on Background Tab
 * This Method Manage Background SubTabs
 */
-(IBAction)setlibBackgroundTabAction:(id)sender{
    UIButton *selectedButton = (UIButton*)sender;
    
    //Uns Selected State of All Buttons
    [backtemplates setSelected:NO];
    [cameraTakePhoto setSelected:NO];
    [cameraRoll setSelected:NO];
    [flyerBorder setSelected:NO];
    
    
    if( selectedButton == backtemplates )
	{
        [backtemplates setBackgroundImage:[UIImage imageNamed:@"addbg_library_selected"] forState:UIControlStateNormal];
        
        // Here we Start Animation
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4f];
            //Create ScrollView
            [self addTemplatesInSubView];
        [UIView commitAnimations];
		//End Animation

        
        //Add ContextView
        [self addScrollView:layerScrollView];
        [backtemplates setSelected:YES];
    }
    else if(selectedButton == cameraTakePhoto)
    {
        [cameraTakePhoto setSelected:YES];
        [self openCustomCamera];
    }
    else if(selectedButton == cameraRoll)
    {
        [cameraRoll setSelected:YES];
        [self loadCustomPhotoLibrary];
    }
    else if(selectedButton == flyerBorder)
    {
        [flyerBorder setSelected:YES];
        
        // Here we Start Animation
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4f];
            //Create ScrollView
            [self addFlyerBorderInSubView];
        [UIView commitAnimations];
		//End Animation
        
        
        //Add ContextView
        [self addScrollView:layerScrollView];
    
    }

}




/*
 * When we click on Photo Tab
 * This Method Manage Photo SubTabs
 */
-(IBAction)setlibPhotoTabAction:(id) sender{
    
    UIButton *selectedButton = (UIButton*)sender;
    
    
    if( selectedButton == cameraTabButton )
	{
        imgPickerFlag =2;
        textBackgrnd.alpha = ALPHA0;
        [self openCustomCamera];

    }
    else if( selectedButton == photoTabButton )
	{
        imgPickerFlag =2;
        [self loadCustomPhotoLibrary];
        textBackgrnd.alpha = ALPHA0;
    }
    else if( selectedButton == widthTabButton )
	{
        if (widthTabButton.isSelected == YES) {
            
            //Set here Un-Selected
            [widthTabButton setSelected:NO];
        
        } else {
            //FOR PINCH
            [widthTabButton  setSelected:YES];
            [heightTabButton setSelected:NO];

        }
        
    }
    else if( selectedButton == heightTabButton )
	{
        
        if (heightTabButton.isSelected == YES) {
            
            //Set here Un-Selected State
            [heightTabButton setSelected:NO];
        
        } else {
            //FOR PINCH
            [heightTabButton  setSelected:YES];
            [widthTabButton setSelected:NO];

        }
    }
}



/* Main Bottom Tab Botton Handler
 * When we click any Tab
 * This Method Manage SubTabs
 */
-(IBAction) setAddMoreLayerTabAction:(id) sender {
    
	UIButton *selectedButton = (UIButton*)sender;
    
    //Set Unselected All
    [addMoreFontTabButton setSelected:NO];
    [addMorePhotoTabButton setSelected:NO];
    [addMoreSymbolTabButton setSelected:NO];
    [addMoreIconTabButton setSelected:NO];
    [backgroundTabButton setSelected:NO];


	if(selectedButton == addMoreFontTabButton)
	{

        selectedAddMoreLayerTab = ADD_MORE_TEXTTAB;

        
        [addMoreFontTabButton setSelected:YES];
        
        if ([currentLayer isEqualToString:@""]) {
            currentLayer = [flyer addText];
            editButtonGlobal.uid = currentLayer;
        }
        [self callWrite];
	}
	else if(selectedButton == addMorePhotoTabButton)
	{
        selectedAddMoreLayerTab = ADD_MORE_PHOTOTAB;
        

        if ([currentLayer isEqualToString:@""]) {
            currentLayer = [flyer addImage];
            
            CGRect imageFrame  = CGRectMake(100,10,200,200);
            [flyer setImageFrame:currentLayer :imageFrame];
            NSMutableDictionary *dic = [flyer getLayerFromMaster:currentLayer];
            [self.flyimgView renderLayer:currentLayer layerDictionary:dic];
           
        }
        
        //Here we Highlight The ImageView
        [self.flyimgView layerIsBeingEdited:currentLayer];
        
        //Here we Add Some Text In ScrolView
        [self addScrollView:takeOrAddPhotoLabel];
	    
        [self choosePhoto];
		imgPickerFlag =2;
        [addMorePhotoTabButton setSelected:YES];
        

	}
	else if(selectedButton == addMoreSymbolTabButton)
	{
        selectedAddMoreLayerTab = ADD_MORE_SYMBOLTAB;

        if ([currentLayer isEqualToString:@""]) {
            currentLayer = [flyer addImage];
        }

        [addMoreSymbolTabButton setSelected:YES];
        [self addDonetoRightBarBotton];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4f];
            //Create ScrollView
            [self addFlyerIconInSubView];
        [UIView commitAnimations];
        

        //Add Context
        [self addScrollView:layerScrollView];
        
        //Add Bottom Tab
        [self addBottomTabs:libEmpty];
        
	}
	else if(selectedButton == addMoreIconTabButton)
	{
        selectedAddMoreLayerTab = ADD_MORE_ICONTAB;
        
        [addMoreIconTabButton setSelected:YES];
        
        if ([currentLayer isEqualToString:@""]) {
            currentLayer = [flyer addImage];
        }
        
        //Add right Bar button
        [self addDonetoRightBarBotton];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4f];
            //Create ScrollView
            [self addSymbolsInSubView];
        [UIView commitAnimations];

        
        //Add ContextView
        [self addScrollView:layerScrollView];
        
        //Add Bottom Tab
        [self addBottomTabs:libEmpty];

	}
    else if(selectedButton == backgroundTabButton)
	{
        
        [backgroundTabButton setSelected:YES];
        //Add right Bar button
        [self addDonetoRightBarBotton];
        
        [self setlibBackgroundTabAction:backtemplates];

        //Add ContextView
        [self addBottomTabs:libBackground];
       

    }
}

/*
 * Here we Delete Button From Scrollview
 */
-(void)resetLayerScrollView :(NSString *)udid{

    
    NSArray *ChildViews = [self.layerScrollView subviews];
    
    for (LayerTileButton *child in ChildViews) {
        
        if (child.uid == udid) {
            
            //Remove From ScrollView
            [child removeFromSuperview];

        }
    }
    


}

-(void)resetLayerScrollView{

}





-(void) callDeleteLayer{
    
    deleteAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Delete this layer?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK" ,nil];
    [deleteAlert show];
    

}

-(void)deleteLayer:(UIButton *)crossButton{

    
    deleteAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Delete this layer?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK" ,nil];
    [deleteAlert show];
}

-(void)deleteLayer:(LayerTileButton *)layerButton overrided:(BOOL)overrided{
    
    
     //Delete From Master Dictionary
    [flyer deleteLayer:layerButton.uid];
    
    //Delete From View
    [flyimgView deleteLayer:layerButton.uid];
    
    NSLog(@"Delete Layer Tag: %d", layerButton.tag);
    
    //Set Main View On Screen
    [self callAddMoreLayers];
}



#pragma mark Save Flyer image and write to Documents/Flyr folder

-(NSData*)getCurrentFrameAndSaveIt
{
    return nil;//Temporary
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


    PFUser *user = [PFUser currentUser];
    
	NSString *homeDirectoryPath = NSHomeDirectory();
	NSString *usernamePath = [homeDirectoryPath stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@/",user.username]];
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
    

	
    // Save flyer details
    [self saveFlyerDetails:finalImgDetailWritePath];
	
    // Save states of all supported social media
    if(files){
        [self saveSocialStates:folderPath imageName:imageNameNew];
    }else{
        [self saveSocialStates:folderPath imageName:@"/IMG_0.jpg"];
    }

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
 *Save flyer details
 */
-(void)saveFlyerDetails:(NSString *)finalImgDetailWritePath{

    NSArray *OldDetail = [[NSArray alloc] initWithContentsOfFile:finalImgDetailWritePath];
   // NSLog(@"%@",OldDetail);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if ([OldDetail count] > 0) {

        [array addObject:OldDetail[0]];
        globle.flyerName = OldDetail[0];
    }else{
        [array addObject:@""];
         globle.flyerName =@"";
    }
    
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

	NSMutableArray *socialArray = [[NSMutableArray alloc] init];
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

#pragma mark  View Disappear Methods

-(void) logLayerAddedEvent{
    [Flurry logEvent:@"Layer Added"];
}

-(void) logPhotoAddedEvent{
    [Flurry logEvent:@"Photo Added"];
}

-(void) logTextAddedEvent{
    [Flurry logEvent:@"Text Added"];
}

/*
 * For ScrollView Adding On runtime
 */
-(void)addScrollView:(id)obj{

    // Remove ScrollViews
    NSArray *viewsToRemove = [self.contextView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    //Add ScrollViews
    [self.contextView addSubview:obj];

}

/*
 * For Adding Bottom Button On runtime
 */
-(void)addBottomTabs:(id)obj{

    // Remove ScrollViews
    NSArray *viewsToRemove = [self.libraryContextView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    //Add ScrollViews
    [self.libraryContextView addSubview:obj];
}


/*
 *Here we Remove all Subviews of ScrollViews
 */
-(void)deleteSubviewsFromScrollView{

    NSArray *ChildViews = [self.layerScrollView subviews];
    
    for (UIView *child in ChildViews) {
    
        [child removeFromSuperview];
    }

}


/*
 * When we Back To Main View its
 * add All Layers to ScrollView for Edit and Delete Layers
 */
-(void)addAllLayersIntoScrollView {
        
    //Remove Subviews of ScrollView
    [self deleteSubviewsFromScrollView];
    
    NSInteger layerScrollWidth = 55;
    NSInteger layerScrollHeight = 40;
    
    if( self.flyimgView.layers.count == 0 ){
        [self addScrollView:addMoreLayerOrSaveFlyerLabel];
        return;
    }
    
    CGFloat curXLoc = 0;
    CGFloat curYLoc = 5;
    
    if(IS_IPHONE_5)
    {
        curXLoc = 10;
        curYLoc = 10;
    }
    
    NSArray *sortedLayers = [flyer allKeys];
    NSMutableDictionary *layers = self.flyimgView.layers ;
    int cnt = 0;
    for (NSString* uid in sortedLayers) {
        
        //check for Flyer Background Key
        if ( ![uid isEqualToString:@"Template"] ) {
            
            id lay = [layers objectForKey:uid];
            LayerTileButton *layerButton;
            
            // Checking for Label or ImageView
            if ( [lay isKindOfClass:[UILabel class]] == YES ) {
                
                CustomLabel *lbl = lay;
                CustomLabel *scrollLabel = [[CustomLabel alloc] initWithFrame:lbl.frame];
                scrollLabel.backgroundColor = [UIColor clearColor];
                scrollLabel.textAlignment = UITextAlignmentCenter;
                scrollLabel.adjustsFontSizeToFitWidth = YES;
                scrollLabel.lineBreakMode = UILineBreakModeTailTruncation;
                scrollLabel.numberOfLines = 80;
                scrollLabel.lineWidth = 2;
                scrollLabel.text = lbl.text;
                scrollLabel.font = lbl.font;
                scrollLabel.borderColor = lbl.borderColor;
                scrollLabel.textColor = lbl.textColor;
                
                
                layerButton = [LayerTileButton  buttonWithType:UIButtonTypeCustom];
                [layerButton addTarget:self action:@selector(selectLayer:) forControlEvents:UIControlEventTouchUpInside];
                layerButton.uid = uid;
                layerButton.frame =CGRectMake(0, 5,layerScrollWidth, layerScrollHeight);
                
                [layerButton addTarget:self action:@selector(editLayer:) forControlEvents:UIControlEventTouchUpInside];
                
                [layerButton setBackgroundColor:[UIColor clearColor]];
                [layerButton.layer setBorderWidth:2];
                UIColor * c = [UIColor lightGrayColor];
                [layerButton.layer setCornerRadius:8];
                [layerButton.layer setBorderColor:c.CGColor];
                
                scrollLabel.frame  = CGRectMake(layerButton.frame.origin.x+5, layerButton.frame.origin.y-2, layerButton.frame.size.width-10, layerButton.frame.size.height-7);
                
                [layerButton addSubview:scrollLabel];
                
                layerButton.tag = [[NSString stringWithFormat:@"%@%d",@"111",cnt] integerValue];
            
            
            } else {
                
                //Here We write code for ImageView
                UIImageView *dicImgView = lay;
                
                UIImageView *tileImageView = [[UIImageView alloc] initWithFrame:dicImgView.frame];
                tileImageView.image = dicImgView.image;
                
                layerButton = [LayerTileButton  buttonWithType:UIButtonTypeCustom];
                [layerButton addTarget:self action:@selector(selectLayer:) forControlEvents:UIControlEventTouchUpInside];
                layerButton.uid = uid;
                layerButton.frame =CGRectMake(0, 5,layerScrollWidth, layerScrollHeight);
                
                [layerButton addTarget:self action:@selector(editLayer:) forControlEvents:UIControlEventTouchUpInside];
                
                [layerButton setBackgroundColor:[UIColor clearColor]];
                [layerButton.layer setBorderWidth:2];
                UIColor * c = [UIColor lightGrayColor];
                [layerButton.layer setCornerRadius:8];
                [layerButton.layer setBorderColor:c.CGColor];
                
                tileImageView.frame  = CGRectMake(layerButton.frame.origin.x+5, layerButton.frame.origin.y-2, layerButton.frame.size.width-10, layerButton.frame.size.height-7);
                
                [layerButton addSubview:tileImageView];
                
                layerButton.tag = [[NSString stringWithFormat:@"%@%d",@"444",cnt] integerValue];
            
            }//End if Checking for Label or ImageView
            
            CGRect frame = layerButton.frame;
            frame.origin = CGPointMake(curXLoc, curYLoc);
            layerButton.frame = frame;
            curXLoc += (layerScrollWidth)+5;
            
            if(IS_IPHONE_5){
                if(curXLoc >= 300){
                    curXLoc = 10;
                    curYLoc = curYLoc + layerScrollHeight + 7;
                }
            }
            
            [layerScrollView addSubview:layerButton];

            
        }
        
        cnt ++;
        
    }//Loop
    
    if(IS_IPHONE_5){
        [layerScrollView setContentSize:CGSizeMake(300, curYLoc + layerScrollHeight)];
    } else {
        [layerScrollView setContentSize:CGSizeMake(([layers count]*(layerScrollWidth+5)), [layerScrollView bounds].size.height)];
    }
    
    [self addScrollView:layerScrollView];
    

}



-(void)addDonetoRightBarBotton{
    
    //Delete Bar Button
    UIButton *delButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 45, 42)];
    [delButton addTarget:self action:@selector(callDeleteLayer) forControlEvents:UIControlEventTouchUpInside];
    [delButton setBackgroundImage:[UIImage imageNamed:@"delete_button"] forState:UIControlStateNormal];
    delButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *delBarButton = [[UIBarButtonItem alloc] initWithCustomView:delButton];
    
    
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [doneButton addTarget:self action:@selector(callAddMoreLayers) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
    doneButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:doneBarButton,delBarButton,nil]];
    
}

#pragma mark - Flyer Image View delegate

/**
 * Frame changed for layer, let the model know.
 */
- (void)frameChangedForLayer:(NSString *)uid frame:(CGRect)frame {

    if ([widthTabButton isSelected]) {
        
        CGRect lastFrame = [flyer getImageFrame:uid];

        lastFrame.origin.x = frame.origin.x;
        lastFrame.size.width = frame.size.width;
        frame = lastFrame;
        
    } else if ([heightTabButton isSelected]) {
        
        CGRect lastFrame = [flyer getImageFrame:uid];
        
        lastFrame.origin.y = frame.origin.y;
        lastFrame.size.height = frame.size.height;
        frame = lastFrame;

    }

    //Update Dictionary
    [flyer setImageFrame:uid :frame];
    
    //Update Controller
    [self.flyimgView renderLayer:uid layerDictionary:[flyer getLayerFromMaster:uid]];
}


/*
 * Here we Getting Snap Shot of Flyer Image View Context
 * Return
 *  Image
 */
-(UIImage *)getFlyerSnapShot {

    //Here we take Snap shot of Flyer
    UIGraphicsBeginImageContextWithOptions(self.flyimgView.bounds.size, YES, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.flyimgView.layer renderInContext:context];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}


@end
