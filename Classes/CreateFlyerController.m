
//  Flyer
//
//  Created by Riksof Pvt. Ltd on 12/10/09.
//
//

#import "CreateFlyerController.h"

@implementation CreateFlyerController
@synthesize flyimgView,imgView,imgPicker,imageNameNew,msgTextView,finalFlyer;
@synthesize fontScrollView,colorScrollView,templateScrollView,sizeScrollView,borderScrollView,fontBorderScrollView,symbolScrollView,iconScrollView;
@synthesize selectedFont,selectedColor;
@synthesize selectedTemplate,selectedSymbol,selectedIcon;
@synthesize fontTabButton,colorTabButton,sizeTabButton,fontEditButton,selectedText,selectedSize,fontBorderTabButton,addMoreIconTabButton,addMorePhotoTabButton,addMoreSymbolTabButton;
@synthesize templateBckgrnd,textBackgrnd;
@synthesize cameraTabButton,photoTabButton,widthTabButton,heightTabButton,photoImgView,symbolImgView,iconImgView;
@synthesize photoTouchFlag,symbolTouchFlag,iconTouchFlag, lableTouchFlag,lableLocation,warningAlert,discardAlert,deleteAlert,editAlert, inAppAlert;
@synthesize moreLayersLabel, moreLayersButton,imgPickerFlag,finalImgWritePath, addMoreLayerOrSaveFlyerLabel, takeOrAddPhotoLabel,layerScrollView;
@synthesize cpyTextLabelLayersArray,cpyIconLayersArray,cpyPhotoLayersArray,cpySymbolLayersArray;
@synthesize flyerNumber,flyerPath,flyer;

//Version 3 Change
@synthesize contextView,libraryContextView,libFlyer,backgroundTabButton,addMoreFontTabButton;
@synthesize libText,libBackground,libPhoto,backtemplates,cameraTakePhoto,cameraRoll,flyerBorder;
@synthesize textLabelLayersArray,symbolLayersArray,iconLayersArray,photoLayersArray,currentLayer,layersDic;

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
        /*
        // Custom initialization
        selectedTemplate = templateParam;
        symbolLayersArray = symbolArrayParam;
        iconLayersArray = iconArrayParam;
        photoLayersArray = photoArrayParam;
        textLabelLayersArray = textArrayParam;
        flyerNumber = flyerNumberParam;*/
    }
    return self;
}

#pragma mark  View Appear Methods
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg_without_logo2"] forBarMetrics:UIBarMetricsDefault];

    
}


-(void)viewDidAppear:(BOOL)animated{
    
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
    
	msgLabel = [[CustomLabel alloc]initWithFrame:CGRectMake(0, 30, 320, 500)];
	msgLabel.backgroundColor = [UIColor clearColor];
	msgLabel.textColor = [UIColor blackColor];
	msgLabel.textAlignment = UITextAlignmentCenter;
	[self.imgView addSubview:msgLabel];
    
	msgTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 100, 280, 250)];
	msgTextView.delegate = self;
	msgTextView.font = [UIFont fontWithName:@"Arial" size:16];
	msgTextView.textColor = [UIColor blackColor];
	msgTextView.textAlignment = UITextAlignmentCenter;
    
    // Add Hight Width
	NSInteger symbolScrollWidth = 60;
	NSInteger symbolScrollHeight = 50;
    
  
    NSInteger iconScrollWidth = 60;
	NSInteger iconScrollHeight = 50;
    


    
    
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
    
    NSArray *flyerPiecesKeys = [flyer allKeys];
    
    for (int i = 0 ; i < flyerPiecesKeys.count; i++) {

        //Getting Layers Detail from Master Dictionary
        NSMutableDictionary *dic = [flyer getLayerFromMaster:[flyerPiecesKeys objectAtIndex:i]];
        
        //Create Subview from dictionary
        [self.flyimgView renderLayer:[flyerPiecesKeys objectAtIndex:i] layerDictionary:dic];

    }

 
    globle = [FlyerlySingleton RetrieveSingleton];
    [self.view setBackgroundColor:[globle colorWithHexString:@"f5f1de"]];
    [self.contextView setBackgroundColor:[globle colorWithHexString:@"f5f1de"]];

    photoTouchFlag=NO;
	symbolTouchFlag=NO;
    iconTouchFlag = NO;
	lableTouchFlag=NO;
    
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
    
	lableLocation = CGPointMake(160,100);
    
    //layerTile Button
    editButtonGlobal = [[LayerTileButton alloc]init];
    editButtonGlobal.uid = @"";
    
    // Create Main Image View
    templateBckgrnd = [[UIImageView alloc]initWithFrame:CGRectMake(0, 413, 320, 135)];
    moreLayersButton = [[UIButton alloc] initWithFrame:CGRectMake(82, 445, 156, 43)];
    moreLayersLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 445, 156, 43)];
    
    // Main Scroll Views Initialize
    layerScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,320,130)];
    layersDic = [[NSMutableDictionary alloc] init];
    
    //Setting ScrollView
    [layerScrollView setCanCancelContentTouches:NO];
    layerScrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    layerScrollView.clipsToBounds = YES;
    layerScrollView.scrollEnabled = YES;
    layerScrollView.pagingEnabled = NO;
    layerScrollView.showsHorizontalScrollIndicator = NO;
    layerScrollView.showsVerticalScrollIndicator = NO;
    
    //all Labels Intialize
    //for Using in ContextView
    takeOrAddPhotoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 310, 43)];
    addMoreLayerOrSaveFlyerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 310, 63)];
    
    
    
    // Add Templates

	templateArray = [[NSMutableArray alloc]init];
    
	imgPickerFlag =1;
    selectedAddMoreLayerTab = -1;
    
    
    //On Removing Background Screen so some
    //Code paste here
    deleteMode = NO;
    undoCount = 0;
    layerallow = 0;
    
    ((CustomLabel *)[[self textLabelLayersArray] lastObject]).alpha = 1;
	textBackgrnd.alpha  =ALPHA0;
    
    photoTouchFlag = NO;
	lableTouchFlag = NO;
    symbolTouchFlag = NO;
    iconTouchFlag = NO;
    [self hideAddMoreButton];
	[msgTextView removeFromSuperview];
    
    // Call Main View
	[self callAddMoreLayers];

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
    
	// Create Main Image View
    /*
    if(IS_IPHONE_5){
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 65, 310, 310)];
    }else{
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 44, 310, 310)];
    }*/
    
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
	//[self.view addSubview:imgView];
    [self callAddMoreLayers];
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
        
		[layerScrollView addSubview:templateButton];
	}// Loop
    
    if(IS_IPHONE_5){
        [layerScrollView setContentSize:CGSizeMake(320, curYLoc + templateScrollHeight)];
    } else {
        [layerScrollView setContentSize:CGSizeMake(([templateArray count]*(templateScrollWidth+5)), [layerScrollView bounds].size.height)];
    }
    
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
        
        
        [layerScrollView addSubview:font];
        
	}
    
    if(IS_IPHONE_5){
        [layerScrollView setContentSize:CGSizeMake(320, curYLoc)];
    } else {
        [layerScrollView setContentSize:CGSizeMake((  [fontArray count]*(fontScrollWidth+5)), [layerScrollView bounds].size.height)];
    }
    
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


		[layerScrollView addSubview:size];
	}
    
    if(IS_IPHONE_5){
        [layerScrollView setContentSize:CGSizeMake(320, curYLoc)];
    } else {
        [layerScrollView setContentSize:CGSizeMake((  [SIZE_ARRAY count]*(sizeScrollWidth+5)), [layerScrollView bounds].size.height)];
    }
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

        
        [layerScrollView addSubview:color];
	
    }//Loop
    
    if(IS_IPHONE_5){
        [layerScrollView setContentSize:CGSizeMake(320, curYLoc)];
    } else {
        [layerScrollView setContentSize:CGSizeMake((  [colorArray count]*(colorScrollWidth+5)), [layerScrollView bounds].size.height)];
    }
    
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
        
		[layerScrollView addSubview:color];
	}// Loop
    
    if(IS_IPHONE_5){
        [layerScrollView setContentSize:CGSizeMake(320, curYLoc)];
    } else {
        [layerScrollView setContentSize:CGSizeMake((  [borderArray count]*(borderScrollWidth+5)), [layerScrollView bounds].size.height)];
    }
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
        
		[layerScrollView addSubview:color];
	}//Loop
    
    if(IS_IPHONE_5){
        [layerScrollView setContentSize:CGSizeMake(320, curYLoc)];
    } else {
        [layerScrollView setContentSize:CGSizeMake((  [borderArray count]*(borderScrollWidth+5)), [layerScrollView bounds].size.height)];
    }
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
        
		[layerScrollView addSubview:symbolButton];
	}//loop
    
    if(IS_IPHONE_5){
        [layerScrollView setContentSize:CGSizeMake(320, curYLoc + symbolScrollHeight)];
    } else {
        [layerScrollView setContentSize:CGSizeMake(([symbolArray count]*(symbolScrollWidth+5)), [layerScrollView bounds].size.height)];
    }

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

        
		[layerScrollView addSubview:iconButton];
    }//loop
    
    if(IS_IPHONE_5){
        [layerScrollView setContentSize:CGSizeMake(320, curYLoc + iconScrollHeight)];
    } else {
        [layerScrollView setContentSize:CGSizeMake(([iconArray count]*(iconScrollWidth+5)), [layerScrollView bounds].size.height)];
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
			msgTextView.font = selectedFont;
            
            //Here we set Font
            [flyer setFlyerTextFont:currentLayer FontName:[NSString stringWithFormat:@"%@",[selectedFont familyName]]];
            
            //Here we call Render Layer on View
            [flyimgView renderLayer:currentLayer layerDictionary:[flyer getLayerFromMaster:currentLayer]];
            
            //((CustomLabel*)[self textLabelLayersArray][arrangeLayerIndex]).font = selectedFont;
            
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
			msgTextView.textColor = selectedColor;
            
            [flyer setFlyerTextColor:currentLayer RGBColor:selectedColor];
            
            //Here we call Render Layer on View
            [flyimgView renderLayer:currentLayer layerDictionary:[flyer getLayerFromMaster:currentLayer]];
            
            //((CustomLabel*)[self textLabelLayersArray][arrangeLayerIndex]).textColor = selectedColor;
            
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
			msgTextView.font = selectedFont;
            
            [flyer setFlyerTextSize:currentLayer Size:selectedFont];
            
            //Here we call Render Layer on View
            [flyimgView renderLayer:currentLayer layerDictionary:[flyer getLayerFromMaster:currentLayer]];
            
           // ((CustomLabel*)[self textLabelLayersArray][arrangeLayerIndex]).font =selectedFont;
            
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
            // Add border to selected layer thumbnail
            CALayer * l = [tempView layer];
            [l setBorderWidth:3.0];
            UIColor * c = [globle colorWithHexString:@"0197dd"];
            [l setBorderColor:c.CGColor];
        }
        
    }
    
    
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
    
    
    //Create Unique Id for Image
    int timestamp = [[NSDate date] timeIntervalSince1970];
    
    NSString *imageFolderPath = [NSString stringWithFormat:@"%@/%d.jpg", FolderPath,timestamp];
    
    dicPath = [dicPath stringByAppendingString:[NSString stringWithFormat:@"/%d.jpg",timestamp]];
    
    //Getting Image From Bundle
    NSString *existImagePath =[[NSBundle mainBundle] pathForResource:imgName ofType:@"png"];
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
    
    
    NSString *imgPath = [self getImagePathByTag:[NSString stringWithFormat:@"symbol%d",view.tag]];
    
    //Set Symbol Image
    [flyer setSymbolImage:currentLayer ImgPath:imgPath];
    
    [self.flyimgView renderLayer:currentLayer layerDictionary:[flyer getLayerFromMaster:currentLayer]];
    
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
    
/*
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
    */
    // else update the selected index of symbol
    /*
    if([[self symbolLayersArray] count] > 0){
        
        // reset flags
        symbolTouchFlag = YES;
        iconTouchFlag = NO;
        photoTouchFlag = NO;
        
        // set borders on selected symbol
        FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
        appDele.changesFlag = YES;

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
    */
    


}

/*
 * Called when select icon
 */
-(void)selectIcon:(id)sender
{
    
    UIButton *view = sender;
    
    [Flurry logEvent:@"Layer Added"];
    [Flurry logEvent:@"Clip Art Added"];

  
    NSString *imgPath = [self getImagePathByTag:[NSString stringWithFormat:@"ricon%d",view.tag]];
    
    //Set Symbol Image
    [flyer setSymbolImage:currentLayer ImgPath:imgPath];
    
    [self.flyimgView renderLayer:currentLayer layerDictionary:[flyer getLayerFromMaster:currentLayer]];
    
    
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

int arrangeLayerIndex;




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
            
            imgView.layer.borderColor = borderColor.CGColor;
            imgView.layer.borderWidth = 3.0;
            
            // Add border to selected layer thumbnail
            tempView.backgroundColor = [globle colorWithHexString:@"0197dd"];
		}
		i++;
	}
}


/*
 * Get index from a view tag
 */
-(int)getIndexFromTag:(NSString *)tag{
    NSString *str = [tag substringWithRange:NSMakeRange(3, [tag length] - 3)];
    return [str integerValue];
}



-(void)showLoadingView:(NSString *)message{
    [self showLoadingIndicator];
}

-(void)removeLoadingView{
    [self hideLoadingIndicator];
}



-(void)loadCustomPhotoLibrary{
    
    nbuGallary = [[GalleryViewController alloc] initWithNibName:@"GalleryViewController" bundle:nil];
    nbuGallary.desiredImageSize = CGSizeMake(300, 300);
    [nbuGallary setOnImageTaken:^(UIImage *img) {
        NSLog(@"Image size: %.2f %.2f", img.size.width, img.size.height );
        
        dispatch_async( dispatch_get_main_queue(), ^{
            // Do any UI operation here (render layer).
            if (imgPickerFlag == 2) {
                
                newPhotoImgView.image = img;
                NSString *imgPath = [self getImagePathforPhoto:img];
                
                //Set Image to dictionary
                [flyer setSymbolImage:currentLayer ImgPath:imgPath];
                
                //Set frame to dictionary
                [flyer setImageFrame:currentLayer :newPhotoImgView.frame];
                
                //Here we Create ImageView Layer
                [self.flyimgView renderLayer:currentLayer layerDictionary:[flyer getLayerFromMaster:currentLayer]];
                
                imgPickerFlag = 1;
            }else{
                //Here We Write Code for Backgeound
            }
        });
    }];
    
    [self.navigationController pushViewController:nbuGallary animated:YES];
    [Flurry logEvent:@"Custom Background"];
}



-(void)openCustomCamera{

    nbuCamera = [[CameraViewController alloc]initWithNibName:@"CameraViewController" bundle:nil];
    nbuCamera.desiredImageSize = CGSizeMake(300, 300);
    
    // Callback once image is selected.
    [nbuCamera setOnImageTaken:^(UIImage *img) {
        NSLog(@"Image size: %.2f %.2f", img.size.width, img.size.height );
        
        dispatch_async( dispatch_get_main_queue(), ^{
            // Do any UI operation here (render layer).
            
            if (imgPickerFlag == 2) {
                
                newPhotoImgView.image = img;
                NSString *imgPath = [self getImagePathforPhoto:img];
                
                //Set Image to dictionary
                [flyer setSymbolImage:currentLayer ImgPath:imgPath];
                
                //Set frame to dictionary
                [flyer setImageFrame:currentLayer :newPhotoImgView.frame];
                
                //Here we Create ImageView Layer
                [self.flyimgView renderLayer:currentLayer layerDictionary:[flyer getLayerFromMaster:currentLayer]];
                
                imgPickerFlag = 1;
            }else{
                //Here We Write Code for Backgeound
            }
        });
    }];
    
    
    [self.navigationController pushViewController:nbuCamera animated:YES];

    [Flurry logEvent:@"Custom Background"];
}



+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
 
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
    // Update Recent Flyer List
    [flyer setRecentFlyer];
    [self.navigationController popViewControllerAnimated:YES];
}

+(UIView *)setTitleViewWithTitle:(NSString *)title rect:(CGRect)rect{
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:@"Symbol" size:18]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = NSLocalizedString([title uppercaseString], @"");
    [label sizeToFit];

    UIView *titleView = [[UIView alloc] initWithFrame:CGRectZero];
    [titleView addSubview:label];    
    
    return titleView;
}


/*
 * When any layer is selected while editing flyer
 */
-(void)selectLayer:(id)sender {
    
    UIView *sView = editButtonGlobal;
    
    NSString *tag = [NSString stringWithFormat:@"%d",sView.tag];
    NSLog(@"%@",tag);
    
    
    //its Also Call editLayer Method
}

-(void)editLayer:(LayerTileButton *)editButton{
    
    
    editButtonGlobal = editButton;
    currentLayer =  editButton.uid;
    editButtonGlobal.uid = currentLayer;
    

    //when tap on Text Box
    NSString *btnText = [flyer getText:currentLayer];

    if (![btnText isEqualToString:@""] && btnText != nil) {
        
        msgTextView.text = btnText;
        
        //Call Style
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

    // [self chooseEdit];
    //[self editLayer:editButtonGlobal overrided:YES];
    
}


-(void)editLayer:(LayerTileButton *)editButton overrided:(BOOL)overrided{
    
    // Since we are editting we should enable the deleteNode On
    undoCount = undoCount + 1;
    NSLog(@"Edit Layer Tag: %d", editButton.tag);
    NSString *tag = [NSString stringWithFormat:@"%d", editButton.tag];

    
    if([tag hasPrefix:@"111"])
    {
        // Set index
      //  arrangeLayerIndex = [self getIndexFromTag:tag];

        
        selectedAddMoreLayerTab = ADD_MORE_TEXTTAB;
        

        NSArray *ary = [editButton subviews];
        CustomLabel * txt = [ary objectAtIndex:0];
        msgTextView.text = txt.text;
        //Call Style
        [self callStyle];
        
    }
    else if([tag hasPrefix:@"222"])
    {
        // Set index
        arrangeLayerIndex = [self getIndexFromTag:tag];
        
        // Call Photo
        [self choosePhoto];
        
        //Replace RightBar Button With
        //Delete Bar Button
        UIButton *delButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 45, 42)];
        [delButton addTarget:self action:@selector(callDeleteLayer) forControlEvents:UIControlEventTouchUpInside];
        [delButton setBackgroundImage:[UIImage imageNamed:@"delete_button"] forState:UIControlStateNormal];
        delButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *delBarButton = [[UIBarButtonItem alloc] initWithCustomView:delButton];
        
        //Done Bar Button
        UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
        [doneButton addTarget:self action:@selector(donePhoto) forControlEvents:UIControlEventTouchUpInside];
        [doneButton setBackgroundImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
        doneButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
        
        [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:doneBarButton,delBarButton,nil]];
        
    }
    else if([tag hasPrefix:@"333"])
    {
        // Set index
        arrangeLayerIndex = [self getIndexFromTag:tag];
        
        // Call Symbol
        [self setAddMoreLayerTabAction:addMoreSymbolTabButton];
        
        //Replace RightBar Button With
        //Delete Bar Button
        UIButton *delButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 45, 42)];
        [delButton addTarget:self action:@selector(callDeleteLayer) forControlEvents:UIControlEventTouchUpInside];
        [delButton setBackgroundImage:[UIImage imageNamed:@"delete_button"] forState:UIControlStateNormal];
        delButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *delBarButton = [[UIBarButtonItem alloc] initWithCustomView:delButton];
        
        //Done Bar Button
        UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
        [doneButton addTarget:self action:@selector(callAddMoreLayers) forControlEvents:UIControlEventTouchUpInside];
        [doneButton setBackgroundImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
        doneButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
        
        [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:doneBarButton,delBarButton,nil]];
        
    }
    else if([tag hasPrefix:@"444"])
    {

        
        // Call Icon
        [self setAddMoreLayerTabAction:addMoreIconTabButton];
        
        //Replace RightBar Button With
        //Delete Bar Button
        UIButton *delButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 45, 42)];
        [delButton addTarget:self action:@selector(callDeleteLayer) forControlEvents:UIControlEventTouchUpInside];
        [delButton setBackgroundImage:[UIImage imageNamed:@"delete_button"] forState:UIControlStateNormal];
        delButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *delBarButton = [[UIBarButtonItem alloc] initWithCustomView:delButton];
        
        //Done Bar Button
        UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
        [doneButton addTarget:self action:@selector(callAddMoreLayers) forControlEvents:UIControlEventTouchUpInside];
        [doneButton setBackgroundImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
        doneButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
        
        [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:doneBarButton,delBarButton,nil]];
        
    }
    deleteMode = YES;
    undoCount = undoCount + 1;
    [rightUndoBarButton setEnabled:YES];
    [self makeCopyOfLayers];
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
    
}

-(void)loadHelpController{

    HelpController *helpController = [[HelpController alloc]initWithNibName:@"HelpController" bundle:nil];
    [self.navigationController pushViewController:helpController animated:NO];
    [self callAddMoreLayers];
}

-(void)callKeyboard{
		[msgTextView becomeFirstResponder];
}


-(void)hideAddMoreButton{
    [self.moreLayersButton setHidden:YES];
    [self.moreLayersLabel setHidden:YES];
}
-(void)showAddMoreButton{
    [self.moreLayersButton setHidden:NO];
    [self.moreLayersLabel setHidden:NO];
}


-(void)cancelLayer{
    
    discardAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Do you want to go back? You will lose unsaved changes" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES" ,nil];
    [discardAlert show];
}

-(void)callWrite{


    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
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

    [self hideAddMoreButton];

    UITextView *lastTextView = msgTextView;
	lastTextView.font = [UIFont fontWithName:@"Arial" size:16];
	lastTextView.textColor = [UIColor blackColor];
    
    
    CustomLabel *lastLabelView = [[CustomLabel alloc] init];
    
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
    
	templateBckgrnd.alpha = ALPHA0;


	[UIView commitAnimations];
}

-(void)callStyle
{

    if(selectedAddMoreLayerTab == -1){
        UIButton *photoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        [photoButton addTarget:self action:@selector(choosePhoto) forControlEvents:UIControlEventTouchUpInside];
        [photoButton setBackgroundImage:[UIImage imageNamed:@"photo_button"] forState:UIControlStateNormal];
        photoButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:photoButton];
        
        [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];
    } else {
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
        
    }
   
    [self hideAddMoreButton];

    UITextView *lastTextView = msgTextView;
    
    //Checking Empty String
    if ([lastTextView.text isEqualToString:@""] ) {
        
        [msgTextView resignFirstResponder];
        [msgTextView removeFromSuperview];
        
        // Remove object from array if not in delete mode
        if(!deleteMode)[textLabelLayersArray removeLastObject];
        [self callAddMoreLayers];
        return;
    }
    
    if ([currentLayer isEqualToString:@""]) {
        
        //Here we write in Master Dictionary
        currentLayer = [flyer addText];
        editButtonGlobal.uid = currentLayer;
        
    } else {
        
        currentLayer = editButtonGlobal.uid;
        
    }
    
    //Set Text of Layer
    [flyer setFlyerText:currentLayer text:msgTextView.text ];
    
    //Here we call Render Layer on View
    [flyimgView renderLayer:currentLayer layerDictionary:[flyer getLayerFromMaster:currentLayer]];
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4f];
    
	textBackgrnd.alpha = ALPHA1;

    // SET BOTTOM BAR
    [self setStyleTabAction:fontTabButton];

	[lastTextView resignFirstResponder];
	[lastTextView removeFromSuperview];
}

-(void) donePhoto{
    

    if (newPhotoImgView.image == nil) {
        //Delete From Master Dictionary
        [flyer deleteLayer:currentLayer];
        
        //Delete From View
        [flyimgView deleteLayer:currentLayer];
    }
    
    [newPhotoImgView removeFromSuperview];
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
    label.textColor = [UIColor whiteColor];
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



-(void)callAddMoreLayers {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:12];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"UNTITLED";
    self.navigationItem.titleView = label;
    
     //ShareButton
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    shareButton.titleLabel.font = [UIFont fontWithName:@"Signika-Semibold" size:13];
	[shareButton addTarget:self action:@selector(callSaveAndShare) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"share_button"] forState:UIControlStateNormal];
    shareButton.showsTouchWhenHighlighted = YES;
    
    //UndoButton
    UIButton *undoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    undoButton.titleLabel.font = [UIFont fontWithName:@"Signika-Semibold" size:13];
	[undoButton addTarget:self action:@selector(undo:) forControlEvents:UIControlEventTouchUpInside];
    [undoButton setBackgroundImage:[UIImage imageNamed:@"undo"] forState:UIControlStateNormal];
    undoButton.showsTouchWhenHighlighted = YES;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    rightUndoBarButton = [[UIBarButtonItem alloc] initWithCustomView:undoButton];
    
    if(undoCount <= 0){
        [rightUndoBarButton setEnabled:NO];
        undoCount = 0;
    }

    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,rightUndoBarButton,nil]];
    
    //BackButton
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [backButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	[backButton addTarget:self action:@selector(callMenu) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
     backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    //HelpButton
    UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [helpButton addTarget:self action:@selector(loadHelpController) forControlEvents:UIControlEventTouchUpInside];
    [helpButton setBackgroundImage:[UIImage imageNamed:@"help_icon"] forState:UIControlStateNormal];
    helpButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarHelpButton = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
    
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:backBarButton,leftBarHelpButton,nil]];
    
    [self addBottomTabs:libFlyer];
    
    
    //Here we take Snap shot of Flyer
    UIGraphicsBeginImageContextWithOptions(self.flyimgView.bounds.size, YES, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.flyimgView.layer renderInContext:context];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    [flyer saveFlyer:currentLayer :snapshotImage];
    [self addAllLayersIntoScrollView ];
    currentLayer = @"";
    [self hideAddMoreButton];

    templateBckgrnd.alpha = ALPHA0;
    
    
    ((CustomLabel *)[[self textLabelLayersArray] lastObject]).alpha = 1;
    photoImgView.alpha=0;
   symbolImgView.alpha = 0;
    iconImgView.alpha = 0;
    
	textBackgrnd.alpha = ALPHA0;

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

    [Flurry logEvent:@"Saved Flyer"];

    [self removeBordersFromAllLayers];

	lableTouchFlag = NO;
	photoTouchFlag = NO;
    symbolTouchFlag= NO;
    iconTouchFlag = NO;
	photoImgView.userInteractionEnabled = NO;
	
    [self hideAddMoreButton];
	textBackgrnd.alpha = ALPHA0;
    

    ((CustomLabel *)[[self textLabelLayersArray] lastObject]).alpha = 1;

    FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
     
    NSData *data = [self getCurrentFrameAndSaveIt];
    appDele.changesFlag = NO;

    ShareViewController *draftViewController = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
    draftViewController.selectedFlyerImage = [UIImage imageWithData:data];
    draftViewController.selectedFlyerTitle = globle.flyerName;
    if([[self textLabelLayersArray] count] > 0){
        draftViewController.selectedFlyerDescription = ((CustomLabel*)[self textLabelLayersArray][0]).text;
    }else{
        draftViewController.selectedFlyerDescription = @"";
    }

    draftViewController.imageFileName = finalImgWritePath;
    draftViewController.detailFileName = [finalImgWritePath stringByReplacingOccurrencesOfString:@".jpg" withString:@".txt"];
    [self.navigationController pushViewController:draftViewController animated:YES];
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




#pragma mark  TEXTVIEW delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{

}

- (void)textViewDidEndEditing:(UITextView *)textView
{

}

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
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4f];
        
        //Create ScrollView
        [self addFontsInSubView ];
        
         //Add ContextView
        [self addScrollView:layerScrollView];
        
		[fontTabButton setSelected:YES];
	}
	else if(selectedButton == colorTabButton)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4f];
        
        //Create ScrollView
        [self addColorsInSubView];
        
        //Add ContextView
        [self addScrollView:layerScrollView];
		[UIView commitAnimations];
        [colorTabButton setSelected:YES];
        
	}
	else if(selectedButton == sizeTabButton)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4f];
        
        //Create ScrollView
        [self   addSizeInSubView];

        //Add ContextView
        [self addScrollView:layerScrollView];
        
		[sizeTabButton setSelected:YES];
		[UIView commitAnimations];
	}
	else if(selectedButton == fontBorderTabButton)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4f];
        
        //Create ScrollView
        [self addTextBorderInSubView];
        
        //Add ContextView
        [self addScrollView:layerScrollView];
        
		[fontBorderTabButton setSelected:YES];
		[UIView commitAnimations];
	}
    else if(selectedButton == fontEditButton)
	{
        [fontEditButton setSelected:YES];
        [self callWrite];
	}
    
}

-(IBAction)setlibBackgroundTabAction:(id)sender{
    UIButton *selectedButton = (UIButton*)sender;
    
    //Uns Selected State of All Buttons
    [backtemplates setSelected:NO];
    [cameraTakePhoto setSelected:NO];
    [cameraRoll setSelected:NO];
    [flyerBorder setSelected:NO];
    

    if(undoCount >= 1){
        [rightUndoBarButton setEnabled:YES];
    }
    
    if( selectedButton == backtemplates )
	{
        [backtemplates setBackgroundImage:[UIImage imageNamed:@"addbg_library_selected"] forState:UIControlStateNormal];
        [UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4f];

        //Create ScrollView
        [self addTemplatesInSubView];
        
        //Add ContextView
        [self addScrollView:layerScrollView];
        [UIView commitAnimations];
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
        
        [UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4f];
        
        //Create ScrollView
        [self addFlyerBorderInSubView];
        
        //Add ContextView
        [self addScrollView:layerScrollView];
    
		[UIView commitAnimations];
    }

}

-(IBAction)setlibPhotoTabAction:(id) sender{
    
    UIButton *selectedButton = (UIButton*)sender;
    
    //Set here Un-Selected State of All Buttons
    [cameraTabButton setSelected:NO];
    [photoTabButton setSelected:NO];
    [widthTabButton setSelected:NO];
    [heightTabButton setSelected:NO];
    
    
    if(undoCount >= 1){
        [rightUndoBarButton setEnabled:YES];
    }
    
    if( selectedButton == cameraTabButton )
	{
        imgPickerFlag =2;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4f];
        textBackgrnd.alpha = ALPHA0;
        [UIView commitAnimations];
        [cameraTabButton setSelected:YES];
        [self openCustomCamera];

    }
    else if( selectedButton == photoTabButton )
	{
        imgPickerFlag =2;
        [self loadCustomPhotoLibrary];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4f];
        textBackgrnd.alpha = ALPHA0;
        [photoTabButton setSelected:YES];
        [UIView commitAnimations];
    }
    else if( selectedButton == widthTabButton )
	{

        [widthTabButton  setSelected:YES];
        
        UIImageView *lastImgView = [[self photoLayersArray] lastObject];
        lastImgView.frame = CGRectMake(lastImgView.frame.origin.x, lastImgView.frame.origin.y,lastImgView.frame.size.width-10,lastImgView.frame.size.height);
        
    }
    else if( selectedButton == heightTabButton )
	{

        [heightTabButton  setSelected:YES];
        
        UIImageView *lastImgView = [[self photoLayersArray] lastObject];
        lastImgView.frame = CGRectMake(lastImgView.frame.origin.x, lastImgView.frame.origin.y,lastImgView.frame.size.width,lastImgView.frame.size.height-10);
    }
}


-(IBAction) setAddMoreLayerTabAction:(id) sender {
    layerallow = 0;
    
	UIButton *selectedButton = (UIButton*)sender;
    [self SetMenu];
    
    if(undoCount >= 1){
        [rightUndoBarButton setEnabled:YES];
    }
    
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
        [self plusButtonClick];
	}
	else if(selectedButton == addMorePhotoTabButton)
	{
        selectedAddMoreLayerTab = ADD_MORE_PHOTOTAB;
        
        
        newPhotoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 10, 200, 200)];

        
        CALayer * l = [newPhotoImgView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:10];
        [l setBorderWidth:1.0];
        [l setBorderColor:[[UIColor grayColor] CGColor]];
        [self.flyimgView addSubview:newPhotoImgView];
        
        if ([currentLayer isEqualToString:@""]) {
            currentLayer = [flyer addSymbols];
        }else{
            NSString *imgPath = [flyer getImageName:currentLayer];
            UIImage *realImage =  [UIImage imageWithContentsOfFile:imgPath];
            newPhotoImgView.image = realImage;
        
        }

        [self addScrollView:takeOrAddPhotoLabel];
        [self choosePhoto];
		imgPickerFlag =2;
        [addMorePhotoTabButton setSelected:YES];
        

        //[self plusButtonClick];

	}
	else if(selectedButton == addMoreSymbolTabButton)
	{
        selectedAddMoreLayerTab = ADD_MORE_SYMBOLTAB;

        if ([currentLayer isEqualToString:@""]) {
            currentLayer = [flyer addSymbols];
        }

        [addMoreSymbolTabButton setSelected:YES];
        [self addDonetoRightBarBotton];
        
       	[UIView beginAnimations:nil context:NULL];
        
        //Create ScrollView
        [self addFlyerIconInSubView];

        //Add Context
        [self addScrollView:layerScrollView];
		
        [UIView setAnimationDuration:0.4f];
		[UIView commitAnimations];
	}
	else if(selectedButton == addMoreIconTabButton)
	{
        selectedAddMoreLayerTab = ADD_MORE_ICONTAB;
        
        [addMoreIconTabButton setSelected:YES];
        
        if ([currentLayer isEqualToString:@""]) {
            currentLayer = [flyer addSymbols];
        }
        
        //Add right Bar button
        [self addDonetoRightBarBotton];
        
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4f];
        
        //Create ScrollView
        [self addSymbolsInSubView];
        
        //Add ContextView
        [self addScrollView:layerScrollView];

		[UIView commitAnimations];
	}
    else if(selectedButton == backgroundTabButton)
	{
        
        [backgroundTabButton setSelected:YES];
        //Add right Bar button
        [self addDonetoRightBarBotton];
        
        [UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4f];
            [self setlibBackgroundTabAction:backtemplates];
        [UIView commitAnimations];

        //Add ContextView
        [self addBottomTabs:libBackground];
       

    }
}

/*
 * Here we Delete Button From Scrollview
 */
-(void)resetLayerScrollView :(NSString *)udid{

   doStopWobble = YES;
    
    NSArray *ChildViews = [self.layerScrollView subviews];
    
    for (LayerTileButton *child in ChildViews) {
        
        if (child.uid == udid) {
            
            //Remove From ScrollView
            [child removeFromSuperview];

        }
    }
    


}

-(void)resetLayerScrollView{

    doStopWobble = YES;
}





-(void) SetMenu{
    
    //Back Button
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [backButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(callMenu) forControlEvents:UIControlEventTouchUpInside];
    backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarMenuButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    //Help Button
    UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [helpButton addTarget:self action:@selector(loadHelpController) forControlEvents:UIControlEventTouchUpInside];
    [helpButton setBackgroundImage:[UIImage imageNamed:@"help_icon"] forState:UIControlStateNormal];
    helpButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarHelpButton = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
    
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:leftBarMenuButton,leftBarHelpButton,nil]];
    
    //Share Button
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    shareButton.titleLabel.font = [UIFont fontWithName:@"Signika-Semibold" size:13];
	[shareButton addTarget:self action:@selector(callSaveAndShare) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"share_button"] forState:UIControlStateNormal];
    shareButton.showsTouchWhenHighlighted = YES;
    
    //Undo Button
    UIButton *undoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    undoButton.titleLabel.font = [UIFont fontWithName:@"Signika-Semibold" size:13];
	[undoButton addTarget:self action:@selector(undo:) forControlEvents:UIControlEventTouchUpInside];
    [undoButton setBackgroundImage:[UIImage imageNamed:@"undo"] forState:UIControlStateNormal];
    undoButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    rightUndoBarButton = [[UIBarButtonItem alloc] initWithCustomView:undoButton];
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,rightUndoBarButton,nil]];
    if(undoCount == 0){
        [rightUndoBarButton setEnabled:NO];
    }
}

-(void) callDeleteLayer{
    
    deleteAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Delete this layer?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK" ,nil];
    [deleteAlert show];
    

}

-(void)deleteLayer:(UIButton *)crossButton{

    crossButtonGlobal = crossButton;
    
    deleteAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Delete this layer?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK" ,nil];
    [deleteAlert show];
}

-(void)deleteLayer:(LayerTileButton *)layerButton overrided:(BOOL)overrided{
    
    
    
// New Code
    
     //Delete From Master Dictionary
    [flyer deleteLayer:layerButton.uid];
    
    //Delete From View
    [flyimgView deleteLayer:layerButton.uid];
    
// End New Code

    
    deleteMode = YES;
    undoCount = undoCount + 1;
    
    NSLog(@"Delete Layer Tag: %d", layerButton.tag);
    
    //Set Main View On Screen
    [self callAddMoreLayers];
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
		else if (loc.y <= (imgView.frame.size.height- newPhotoImgView.frame.size.height/2) && photoTouchFlag
                 && loc.x <= (imgView.frame.size.width - newPhotoImgView.frame.size.width/2)
                 && loc.x >= newPhotoImgView.frame.size.width/2)
		{
            if(selectedAddMoreLayerTab == ARRANGE_LAYERTAB){
                [self.imgView bringSubviewToFront:[self photoLayersArray][arrangeLayerIndex]];
            }else{
                //[self.imgView bringSubviewToFront:[[self photoLayersArray] lastObject]];

                [self.imgView bringSubviewToFront:newPhotoImgView];
            }

			for (UITouch *touch in touches) {
                if(selectedAddMoreLayerTab == ARRANGE_LAYERTAB){
                    [self dispatchFirstTouchAtPoint:[self photoLayersArray][arrangeLayerIndex] point:[touch locationInView:self.imgView] forEvent:nil];
                }else{
                    [self dispatchFirstTouchAtPoint:newPhotoImgView point:[touch locationInView:self.imgView] forEvent:nil];
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
	else if (loc.y <= (imgView.frame.size.height-newPhotoImgView.frame.size.height/2)
             && photoTouchFlag
             && loc.x <= (imgView.frame.size.width - newPhotoImgView.frame.size.width/2)
             && loc.x >= newPhotoImgView.frame.size.width/2)
	{
		for (UITouch *touch in touches){
            
            if(selectedAddMoreLayerTab == ARRANGE_LAYERTAB){
                [self dispatchTouchEvent:[self photoLayersArray][arrangeLayerIndex] toPosition:[touch locationInView:self.imgView]];
            }else{
                [self dispatchTouchEvent:newPhotoImgView toPosition:[touch locationInView:self.imgView]];
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
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if ([OldDetail count] > 0) {

        [array addObject:OldDetail[0]];
        globle.flyerName = OldDetail[0];
    }else{
        [array addObject:@""];
         globle.flyerName =@"";
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


-(void)showAlert:(NSString *)title message:(NSString *)message{
    UIAlertView *salert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [salert show];
}


- (void)removeAllViewsFromScrollview:(UIScrollView *)scrollView {
    NSArray *subviews = scrollView.subviews;
    
    for ( UIView *v in subviews ) {
        [v removeFromSuperview];
    }
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
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4f];
    //Add ScrollViews
    [self.libraryContextView addSubview:obj];
    
    [UIView commitAnimations];
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
    layerallow = 0 ;
        
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
        [layerScrollView setContentSize:CGSizeMake(320, curYLoc + layerScrollHeight)];
    } else {
        [layerScrollView setContentSize:CGSizeMake(([self getLayerCounts]*(layerScrollWidth+5)), [layerScrollView bounds].size.height)];
    }
    
    [self addScrollView:layerScrollView];
    
    deleteMode = NO;
    doStopWobble = YES;

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

@end
