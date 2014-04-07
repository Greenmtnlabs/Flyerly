
//  Flyer
//
//  Created by Riksof Pvt. Ltd on 12/10/09.
//
//

#import "CreateFlyerController.h"
#import "UIImage+NBUAdditions.h"

@implementation CreateFlyerController

@synthesize selectedFont,selectedColor,selectedTemplate,fontTabButton,colorTabButton,sizeTabButton,fontEditButton,selectedSize,
fontBorderTabButton,addMoreIconTabButton,addMorePhotoTabButton,addMoreSymbolTabButton,sharePanel;
@synthesize textBackgrnd,cameraTabButton,photoTabButton,widthTabButton,heightTabButton,deleteAlert;
@synthesize imgPickerFlag, addMoreLayerOrSaveFlyerLabel, takeOrAddPhotoLabel,layerScrollView,flyerPath;
@synthesize contextView,libraryContextView,libFlyer,backgroundTabButton,addMoreFontTabButton;
@synthesize libText,libBackground,libPhoto,libEmpty,backtemplates,cameraTakePhoto,cameraRoll,flyerBorder;
@synthesize flyimgView,currentLayer,layersDic,flyer,player,playerView,playerToolBar,playButton,playerSlider;
@synthesize durationLabel,durationChange;
int selectedAddMoreLayerTab = -1;


#pragma mark  View Appear Methods

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];

    //Here we Set Top Bar Item
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:TITLE_FONT size:18];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];
    
    NSString *title = [flyer getFlyerTitle];
    
    if ( [title isEqualToString:@""] ) {
        titleLabel.text = @"Flyerly";
    } else {
        titleLabel.text = title;
    }
    
    self.navigationItem.titleView = titleLabel;
}

-(void)viewDidAppear:(BOOL)animated {
    
    [addMoreLayerOrSaveFlyerLabel setText:@"CREATE YOUR FLYER WITH THE FEATURES BELOW THEN SHARE WITH THE WORLD!"];    [addMoreLayerOrSaveFlyerLabel setNumberOfLines:2];
    [addMoreLayerOrSaveFlyerLabel setBackgroundColor:[UIColor clearColor]];
    [addMoreLayerOrSaveFlyerLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:16]];
    [addMoreLayerOrSaveFlyerLabel setTextColor:[UIColor grayColor]];
    [addMoreLayerOrSaveFlyerLabel setTextAlignment:UITextAlignmentCenter];

    
    [takeOrAddPhotoLabel setText:@"TAKE OR ADD PHOTO & RESIZE"];
    [takeOrAddPhotoLabel setBackgroundColor:[UIColor clearColor]];
    [takeOrAddPhotoLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:18]];
    [takeOrAddPhotoLabel setTextColor:[UIColor grayColor]];
    [takeOrAddPhotoLabel setTextAlignment:UITextAlignmentCenter];

    [videoLabel setText:@"SET PHOTO OR VIDEO AS BACKGROUND"];
    [videoLabel setBackgroundColor:[UIColor clearColor]];
    [videoLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:16]];
    [videoLabel setTextColor:[UIColor grayColor]];
    [videoLabel setTextAlignment:UITextAlignmentCenter];
    
    [layerScrollView setCanCancelContentTouches:NO];
	layerScrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
	layerScrollView.clipsToBounds = YES;
	layerScrollView.scrollEnabled = YES;
	layerScrollView.pagingEnabled = NO;
	layerScrollView.showsHorizontalScrollIndicator = YES;
	layerScrollView.showsVerticalScrollIndicator = YES;

    
	
	textBackgrnd = [[UIImageView alloc]initWithFrame:CGRectMake(0, 385, 320, 44)];
	//[self.view addSubview:textBackgrnd];
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
	colorArray = [[NSArray  alloc] initWithObjects: [UIColor redColor], [UIColor blueColor], [UIColor greenColor], [UIColor blackColor], [UIColor colorWithRed:253.0/255.0 green:191.0/255.0 blue:38.0/224.0 alpha:1], [UIColor colorWithWhite:1.0f alpha:1.0f], [UIColor grayColor], [UIColor magentaColor], [UIColor yellowColor], [UIColor colorWithRed:163.0/255.0 green:25.0/255.0 blue:2.0/224.0 alpha:1], [UIColor colorWithRed:3.0/255.0 green:15.0/255.0 blue:41.0/224.0 alpha:1], [UIColor purpleColor], [UIColor colorWithRed:85.0/255.0 green:86.0/255.0 blue:12.0/224.0 alpha:1], [UIColor orangeColor], [UIColor colorWithRed:98.0/255.0 green:74.0/255.0 blue:9.0/224.0 alpha:1], [UIColor colorWithRed:80.0/255.0 green:7.0/255.0 blue:1.0/224.0 alpha:1], [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:97.0/224.0 alpha:1], [UIColor colorWithRed:111.0/255.0 green:168.0/255.0 blue:100.0/224.0 alpha:1], [UIColor cyanColor], [UIColor colorWithRed:17.0/255.0 green:69.0/255.0 blue:70.0/224.0 alpha:1], [UIColor colorWithRed:173.0/255.0 green:127.0/255.0 blue:251.0/224.0 alpha:1], nil];
	
    
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
    
    // HERE WE CREATE FLYERLY ALBUM ON DEVICE
    if(![[NSUserDefaults standardUserDefaults] stringForKey:@"FlyerlyAlbum"]){
        [flyer createFlyerlyAlbum];
    }
    
    //Render Flyer
    [self renderFlyer];
 
    globle = [FlyerlySingleton RetrieveSingleton];
    [self.view setBackgroundColor:[globle colorWithHexString:@"f5f1de"]];
    [self.contextView setBackgroundColor:[globle colorWithHexString:@"f5f1de"]];

    sharePanel = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.origin.y, 320,400 )];
    shareviewcontroller = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];

    sharePanel = shareviewcontroller.view;
    sharePanel.hidden = YES;
    [self.view addSubview:sharePanel];

    // Set height and width of each element of scroll view
    layerXposition = 0;
    widthValue = 35;
    heightValue = 35;
    
	//Default Selection for start
	selectedFont = [UIFont fontWithName:@"Arial" size:16];
	selectedColor = [UIColor blackColor];	
	selectedSize = 16;
    
    //Set Initial Background Image For Flyer New or Edit
    if(!selectedTemplate){
        selectedTemplate  = [UIImage imageNamed:@"main_area_bg"];
    }
    
    //layerTile Button
    editButtonGlobal = [[LayerTileButton alloc]init];
    editButtonGlobal.uid = @"";
    
    // Main Scroll Views Initialize
    // Device Check Maintain Size of ScrollView Because Scroll Indicator will show.
    if(IS_IPHONE_5){
        layerScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,320,150)];
    }else {
        layerScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,320,60)];
    }
    layersDic = [[NSMutableDictionary alloc] init];

        
    //all Labels Intialize
    //for Using in ContextView
    takeOrAddPhotoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 310, 43)];
    videoLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 310, 43)];
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
	[backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    // HERE WE SET BACK BUTTON IMAGE AS REQUIRED
    NSArray * arrayOfControllers =  self.navigationController.viewControllers;
    int idx = [arrayOfControllers count] -2 ;
    id previous = [arrayOfControllers objectAtIndex:idx];
    if ([previous isKindOfClass:[FlyrViewController class]])
    {
        [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    } else {
        [backButton setBackgroundImage:[UIImage imageNamed:@"home_button"] forState:UIControlStateNormal];
    }

    
    
    backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    //Left HelpButton
    helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
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

#pragma mark  View DisAppear Methods

/*
 * This Method Call On Back Button
 * and its Save Flyer then Exits Screen
 */
-(void) goBack
{
    float yValue = self.view.frame.size.height -425;
    
    if (yValue == sharePanel.frame.origin.y) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4f];
            [sharePanel setFrame:CGRectMake(0, self.view.frame.size.height, 320,425 )];
        [UIView commitAnimations];
        [shareviewcontroller.titleView resignFirstResponder];
        [shareviewcontroller.descriptionView resignFirstResponder];

        rightUndoBarButton.enabled = YES;
        shareButton.enabled = YES;
        helpButton.enabled = YES;
        return;
    }
    
    //Delete Empty Layer if Exist
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
    
    // Remove Border if Any Layer Selected
    if (![currentLayer isEqualToString:@""]) [self.flyimgView layerStoppedEditing:currentLayer];
    
    [shareviewcontroller.titleView resignFirstResponder];
    [shareviewcontroller.descriptionView resignFirstResponder];
    

    UIImage *snapshotImage;
    
    //Save OnBack
    
    
    if ([flyer isVideoFlyer]) {
        
        //Background Thread
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            
            //Here we Merge All Layers in Video File
            [self videoMergeProcess];
            
        });
    }
    
    //Here we take Snap shot of Flyer
      snapshotImage =  [self getFlyerSnapShot];
    
    // Here we Save Flyer Info
    [flyer saveFlyer:snapshotImage];

    
    if (![[flyer getFlyerURL] isEqualToString:@""]) {
        
        // Update Recent Flyer List
         if (![flyer isVideoFlyer]) {
             [flyer setRecentFlyer];
         }
    }
    [Flurry logEvent:@"Saved Flyer"];
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark  Add Content In ScrollViews

/*
 * Add templates in scroll views
 */
-(void)addTemplatesInSubView{

    widthValue = 60;
	heightValue = 55;
    
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
		templateButton.frame =CGRectMake(0, 5,widthValue, heightValue);
        [templateButton addTarget:self action:@selector(selectTemplate:) forControlEvents:UIControlEventTouchUpInside];

        [templateButton setBackgroundColor:[UIColor whiteColor]];
        
		UIImageView *img = [[UIImageView alloc]initWithImage:iconImg];
		img.frame  = CGRectMake(templateButton.frame.origin.x+5, templateButton.frame.origin.y-2, templateButton.frame.size.width-10, templateButton.frame.size.height-7);
		[templateButton addSubview:img];
		templateButton.tag = i;
        
        CGRect frame = templateButton.frame;
        frame.origin = CGPointMake(curXLoc, curYLoc);
        templateButton.frame = frame;
        curXLoc += (widthValue)+5;
        
        if(IS_IPHONE_5){
            if(curXLoc >= 320){
                curXLoc = 0;
                curYLoc = curYLoc + heightValue + 7;
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
        [layerScrollView setContentSize:CGSizeMake(320, curYLoc + heightValue)];
    } else {
        [layerScrollView setContentSize:CGSizeMake(([templateArray count]*(widthValue+5)), [layerScrollView bounds].size.height)];
    }
    
    
    // Ressize Hight Width again for others Layers Tile size is different
    widthValue = 35;
    heightValue = 35;

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
		font.frame = CGRectMake(0, 0, widthValue, heightValue);
        
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
        curXLoc += (widthValue)+increment;
        
        if(IS_IPHONE_5){
            if(curXLoc >= 300){
                curXLoc = 13;
                curYLoc = curYLoc + widthValue + 7;
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
        [layerScrollView setContentSize:CGSizeMake((  [fontArray count]*(widthValue+5)), [layerScrollView bounds].size.height)];
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

		size.frame = CGRectMake(0, 0, widthValue, heightValue);
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
        curXLoc += (widthValue)+increment;
        
        if(IS_IPHONE_5){
            if(curXLoc >= 300){
                curXLoc = 13;
                curYLoc = curYLoc + heightValue + 7;
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
        [layerScrollView setContentSize:CGSizeMake((  [SIZE_ARRAY count]*(widthValue+5)), [layerScrollView bounds].size.height)];
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
		color.frame = CGRectMake(0, 0, widthValue, heightValue);
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
        curXLoc += (widthValue)+increment;
        
        if(IS_IPHONE_5){
            if(curXLoc >= 300){
                curXLoc = 13;
                curYLoc = curYLoc + heightValue + 7;
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
        [layerScrollView setContentSize:CGSizeMake((  [colorArray count]*(widthValue+5)), [layerScrollView bounds].size.height)];
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
		color.frame = CGRectMake(0, 0, widthValue, heightValue);
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
        curXLoc += (widthValue)+increment;
        
        if(IS_IPHONE_5){
            if(curXLoc >= 300){
                curXLoc = 13;
                curYLoc = curYLoc + heightValue + 7;
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
        [layerScrollView setContentSize:CGSizeMake((  [borderArray count]*(widthValue+5)), [layerScrollView bounds].size.height)];
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
		color.frame = CGRectMake(0, 0, widthValue, heightValue);
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
        curXLoc += (widthValue)+increment;
        
        if(IS_IPHONE_5){
            if(curXLoc >= 300){
                curXLoc = 13;
                curYLoc = curYLoc + heightValue + 7;
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
        [layerScrollView setContentSize:CGSizeMake((  [borderArray count]*(widthValue+5)), [layerScrollView bounds].size.height)];
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
                curYLoc = curYLoc + iconScrollHeight + 5;
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


#pragma mark  Select Layer On ScrollView

/*
 * When any font is selected
 */
-(void)selectFont:(id)sender
{

	int  i=1;
	UIButton *view = sender;
    
	for(UIView *tempView  in [layerScrollView subviews])
	{
        //CHECK UIIMAGEVIEW BECAUSE SCROLL VIEW HAVE ADDITIONAL
        //SUBVIEWS OF UIIMAGEVIEW FOR FLASH INDICATORS
        if (![tempView isKindOfClass:[UIImageView class]]) {
 
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
        }// uiImageView Found
        
	}// Loop
}

/*
 * When any color is selected
 */
-(void)selectColor:(id)sender
{
	int  i=1;
	UIButton *view = sender;
    
	for(UIView *tempView  in [layerScrollView subviews])
	{

        //CHECK UIIMAGEVIEW BECAUSE SCROLL VIEW HAVE ADDITIONAL
        //SUBVIEWS OF UIIMAGEVIEW FOR FLASH INDICATORS
        if (![tempView isKindOfClass:[UIImageView class]]) {
            
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
        }//UIIMAGEVIEW CHECK
        
	}// LOOP
}

/*
 * When any size is selected
 */
-(void)selectSize:(id)sender{

	int  i=1;
	UIButton *view = sender;
    
	for(UIView *tempView  in [layerScrollView subviews])
	{
        
        //CHECK UIIMAGEVIEW BECAUSE SCROLL VIEW HAVE ADDITIONAL
        //SUBVIEWS OF UIIMAGEVIEW FOR FLASH INDICATORS
        if (![tempView isKindOfClass:[UIImageView class]]) {
            
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
            
        }//UIIMAGEVIEW CHECK
        
	}//LOOP
}


/*
 * When any font border is selected
 */
-(void)selectFontBorder:(id)sender
{
	int  i=1;
	UIButton *view = sender;
    
	for(UIView *tempView  in [layerScrollView subviews]) {
        
        //CHECK UIIMAGEVIEW BECAUSE SCROLL VIEW HAVE ADDITIONAL
        //SUBVIEWS OF UIIMAGEVIEW FOR FLASH INDICATORS
        if (![tempView isKindOfClass:[UIImageView class]]) {
            
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
            
        }//UIIMAGEVIEW CHECK
	}//LOOP
}



/*
 * When any template is selected
 */
-(void)selectTemplate:(id)sender
{
	UIButton *view = sender;
    
    //Handling Select Unselect
    for(UIView *tempView  in [layerScrollView subviews])
    {
        
        // Add border to Un-select layer thumbnail
        CALayer * l = [tempView layer];
        [tempView.layer setCornerRadius:8];
        [l setBorderWidth:1];
        UIColor * c = [UIColor clearColor];
        [l setBorderColor:c.CGColor];
        
        if(tempView == view)
        {
            
            int lstTag = 500;
            NSString *lastTag = [flyer getImageTag:@"Template"];
            
            if (![lastTag isEqualToString:@""]) lstTag = [lastTag intValue];


            if (lstTag != view.tag || view.tag == 0) {
                
                //Here we Set Flyer Type
                [flyer setFlyerTypeImage];
                
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
 * When any Flyer border is selected
 */
-(void)selectBorder:(id)sender
{
	int  i=1;
	UIButton *view = sender;
    
	for(UIView *tempView  in [layerScrollView subviews])
	{
        
        //CHECK UIIMAGEVIEW BECAUSE SCROLL VIEW HAVE ADDITIONAL
        //SUBVIEWS OF UIIMAGEVIEW FOR FLASH INDICATORS
        if (![tempView isKindOfClass:[UIImageView class]]) {
        
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
        }//UIIMAGEVIEW CHECK
	}//LOOP
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


#pragma mark  Progress Indicator

-(void)showLoadingView:(NSString *)message{
    [self showLoadingIndicator];
}

-(void)removeLoadingView{
    [self hideLoadingIndicator];
}

#pragma mark  NBUKIT

/*
 * Here we Load Gallery
 */
-(void)loadCustomPhotoLibrary :(NSString *)videoAllow {
    
    LibraryViewController *nbuGallary = [[LibraryViewController alloc] initWithNibName:@"LibraryViewController" bundle:nil];
    
    nbuGallary.videoAllow = videoAllow;
    
    if ( imgPickerFlag == 2 ) {
        NSDictionary *dict = [flyer getLayerFromMaster:currentLayer];
        nbuGallary.desiredImageSize = CGSizeMake( [[dict valueForKey:@"width"] floatValue],
                                                [[dict valueForKey:@"height"] floatValue]);
    } else {
        nbuGallary.desiredImageSize = CGSizeMake( 300,  300 );
    }
    
    __weak CreateFlyerController *weakSelf = self;

    [nbuGallary setOnImageTaken:^(UIImage *img) {
        
        dispatch_async( dispatch_get_main_queue(), ^{
            // Do any UI operation here (render layer).
            if (weakSelf.imgPickerFlag == 2) {
                
                NSString *imgPath = [weakSelf getImagePathforPhoto:img];
                
                //Set Image to dictionary
                [weakSelf.flyer setImagePath:weakSelf.currentLayer ImgPath:imgPath];
                
                //Here we Create ImageView Layer
                [weakSelf.flyimgView renderLayer:weakSelf.currentLayer layerDictionary:[weakSelf.flyer getLayerFromMaster:weakSelf.currentLayer]];
                
                [weakSelf.flyimgView layerStoppedEditing:weakSelf.currentLayer];
                
                weakSelf.imgPickerFlag = 1;
            }else{
                
                //Here we Set Flyer Type
                [weakSelf.flyer setFlyerTypeImage];

                //Create Copy of Image
                [weakSelf copyImageToTemplate:img];
                
                //set template Image
                [weakSelf.flyimgView setTemplate:[NSString stringWithFormat:@"Template/template.%@",IMAGETYPE] ];
                [Flurry logEvent:@"Custom Background"];
                
            }
        });
    }];
    
    
    [nbuGallary setOnVideoFinished:^(NSURL *recvUrl) {
        
        NSLog(@"%@",recvUrl);
        NSError *error = nil;
        
        [self.flyer setFlyerTypeVideo];
        
        
        // HERE WE MOVE SOURCE FILE INTO FLYER FOLDER
        NSString* currentpath  =   [[NSFileManager defaultManager] currentDirectoryPath];
        NSString *destination = [NSString stringWithFormat:@"%@/Template/template.mov",currentpath];
        [self.flyer setOriginalVideoUrl:@"Template/template.mov"];
        
        NSURL *movieURL = [NSURL fileURLWithPath:destination];
        
        
        //HERE WE MAKE SURE FILE ALREADY EXISTS THEN DELETE IT OTHERWISE IGNORE
        if ([[NSFileManager defaultManager] fileExistsAtPath:destination isDirectory:NULL]) {
            [[NSFileManager defaultManager] removeItemAtPath:destination error:&error];
        }
        
        //HERE WE MOVE FILE INTO FLYER FOLDER
        [[NSFileManager defaultManager] moveItemAtURL:recvUrl toURL:movieURL error:&error];
        
        //HERE WE RENDER MOVIE PLAYER
        [self.flyimgView renderLayer:@"Template" layerDictionary:[self.flyer getLayerFromMaster:@"Template"]];

    }];
    
    
    [self.navigationController pushViewController:nbuGallary animated:YES];
    [Flurry logEvent:@"Custom Background"];
}




/*
 * Here we Open Camera for Capture Image
 */
-(void)openCustomCamera{

    CameraViewController *nbuCamera = [[CameraViewController alloc]initWithNibName:@"CameraViewController" bundle:nil];
    
    if ( imgPickerFlag == 2 ) {
        NSDictionary *dict = [flyer getLayerFromMaster:currentLayer];
        nbuCamera.desiredImageSize = CGSizeMake( [[dict valueForKey:@"width"] floatValue],
                                                 [[dict valueForKey:@"height"] floatValue]);
    } else {
        nbuCamera.desiredImageSize = CGSizeMake( 300,  300 );
    }
    
    __weak CreateFlyerController *weakSelf = self;
    
    // Callback once image is selected.
    [nbuCamera setOnImageTaken:^(UIImage *img) {
        
        dispatch_async( dispatch_get_main_queue(), ^{
            // Do any UI operation here (render layer).

            
            if (weakSelf.imgPickerFlag == 2) {
                
                NSString *imgPath = [weakSelf getImagePathforPhoto:img];
                
                //Set Image to dictionary
                [weakSelf.flyer setImagePath:weakSelf.currentLayer ImgPath:imgPath];
                
                //Here we Create ImageView Layer
                [weakSelf.flyimgView renderLayer:weakSelf.currentLayer layerDictionary:[weakSelf.flyer getLayerFromMaster:weakSelf.currentLayer]];
                
                [weakSelf.flyimgView layerStoppedEditing:weakSelf.currentLayer];
                [Flurry logEvent:@"Custom Photo"];
                
                weakSelf.imgPickerFlag = 1;
            }else{
                
                //Here we Set Flyer Type
                [weakSelf.flyer setFlyerTypeImage];
                
                //Create Copy of Image
                [weakSelf copyImageToTemplate:img];
                
                
                //set template Image
                [weakSelf.flyimgView setTemplate:[NSString stringWithFormat:@"Template/template.%@",IMAGETYPE ]];
                [Flurry logEvent:@"Custom Background"];
            }
        });
    }];
    
    
    [self.navigationController pushViewController:nbuCamera animated:YES];
}


#pragma mark Add Video
/*
 * Here we Overload Open Camera for Video
 */
-(void)openCustomCamera :(BOOL *)forVideo{
    
    CameraViewController *nbuCamera = [[CameraViewController alloc]initWithNibName:@"CameraViewController" bundle:nil];
    
    //Here we Pass FlyerImageView For Video
    nbuCamera.flyerImageView = self.flyimgView;
    
    nbuCamera.videoAllow = @"YES";
    nbuCamera.desiredImageSize = CGSizeMake( 300,  300 );
    
      __weak CreateFlyerController *weakSelf = self;
    // Callback once image is selected.
    [nbuCamera setOnImageTaken:^(UIImage *img) {
        
        dispatch_async( dispatch_get_main_queue(), ^{

                //Here we Set Flyer Type
                [weakSelf.flyer setFlyerTypeImage];
                
                //Create Copy of Image
                [weakSelf copyImageToTemplate:img];
                
                
                //set template Image
                [weakSelf.flyimgView setTemplate:[NSString stringWithFormat:@"Template/template.%@",IMAGETYPE ]];
                [Flurry logEvent:@"Custom Background"];

        });
    }];

        
    [nbuCamera setOnVideoFinished:^(NSURL *recvUrl) {
        
        NSLog(@"%@",recvUrl);
        NSError *error = nil;
        [self.view addSubview:flyimgView];
        
        [self.flyer setFlyerTypeVideo];

        // HERE WE MOVE SOURCE FILE INTO FLYER FOLDER
        NSString* currentpath  =   [[NSFileManager defaultManager] currentDirectoryPath];

        NSString *destination = [NSString stringWithFormat:@"%@/Template/template.mov",currentpath];
        [self.flyer setOriginalVideoUrl:@"Template/template.mov"];
        
        NSURL *movieURL = [NSURL fileURLWithPath:destination];


        //HERE WE MAKE SURE FILE ALREADY EXISTS THEN DELETE IT OTHERWISE IGNORE
        if ([[NSFileManager defaultManager] fileExistsAtPath:destination isDirectory:NULL]) {
            [[NSFileManager defaultManager] removeItemAtPath:destination error:&error];
        }
        

        //THNE HERE WE MOVE FILE INTO FLYER TEMPLATE FOLDER
        [[NSFileManager defaultManager] moveItemAtURL:recvUrl toURL:movieURL error:&error];

        //HERE WE RENDER MOVIE PLAYER
        [self.flyimgView renderLayer:@"Template" layerDictionary:[self.flyer getLayerFromMaster:@"Template"]];
        
      }];
    
    [nbuCamera setOnVideoCancel:^() {
    
      [self.view addSubview:flyimgView];
    
    }];

    
    [self.navigationController pushViewController:nbuCamera animated:YES];
}

#pragma mark  Movie Player

/*
 * Here we Configure Player and Load File in Player
 */
-(void)loadPlayerWithURL :(NSURL *)movieURL {
    
    player =[[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    [player.view setFrame:self.playerView.bounds];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(movieFinishedCallback:)
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(movieStateChangeCallback:)
     name:MPMoviePlayerPlaybackStateDidChangeNotification
     object:player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MPMoviePlayerThumbnailImageRequestDidFinishNotification::) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MPMoviePlayerLoadStateDidChange:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:nil];
    
    [player.view removeFromSuperview];
    [playerToolBar removeFromSuperview];

    self.flyimgView.image = nil;
    [self.playerView addSubview:player.view];
    [playerToolBar setFrame:CGRectMake(0, self.playerView.frame.size.height - 40, 310, 40)];
    [self.playerView addSubview:playerToolBar];
    player.accessibilityElementsHidden = YES;
    player.shouldAutoplay = NO;
    player.fullscreen = NO;
    player.movieSourceType  = MPMovieSourceTypeFile;
    player.controlStyle =  MPMovieControlStyleNone;
    player.scalingMode = MPMovieScalingModeAspectFill;
    player.backgroundView.backgroundColor = [UIColor whiteColor];
    [player prepareToPlay];

}


-(IBAction)play:(id)sender {
    
    if ([playButton isSelected] == YES) {
        [playButton setSelected:NO];
        isPlaying = NO;
        [player pause];

    }else {
        [playButton setSelected:YES];
        isPlaying = YES;
        player.currentPlaybackTime = playerSlider.value;
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:NO];
        [player play];
   
    }
}

-(IBAction)slide:(id)sender {

    NSLog(@"%f",playerSlider.value);
    player.currentPlaybackTime = playerSlider.value;
    durationChange.text =[self stringFromTimeInterval:playerSlider.value];

}

- (void)updateTime:(NSTimer *)timer {
    
     NSLog(@"%f",player.currentPlaybackTime);
    playerSlider.value = player.currentPlaybackTime;
    durationChange.text =[self stringFromTimeInterval:player.currentPlaybackTime];
    
    if (isPlaying) {
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:NO];
    }
}


#pragma mark  Movie Player Delegate


/*
 * Here we Set Slider
 */
- (void)MPMoviePlayerLoadStateDidChange:(NSNotification *)notification
{
    if ((player.loadState & MPMovieLoadStatePlaythroughOK) == MPMovieLoadStatePlaythroughOK)
    {
        
        videolastImage = [player thumbnailImageAtTime:player.duration /2
                                           timeOption:MPMovieTimeOptionNearestKeyFrame];

        playerSlider.maximumValue = player.duration;
        NSTimeInterval duration = player.duration;
        durationLabel.text =[NSString stringWithFormat:@"%@",[self stringFromTimeInterval:player.duration]] ;
        durationChange.text = @"00:00";
        
        float minutes = floor(duration / 60);
        videoDuration = duration - minutes * 60;
        playerSlider.value = 0.0;
    } else {
        NSLog(@"Unknown load state: %u", player.loadState);
    }
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
}

/*
 * Here we Get Player Button Press Info
 */
- (void) movieStateChangeCallback:(NSNotification*) aNotification {
    
    
    //User Press Pause or Stop we Disable Player Access and Enable Flyer for Others Layers
    if (player.playbackState == MPMoviePlaybackStatePaused || player.playbackState == MPMoviePlaybackStateStopped ) {
        [self performSelectorOnMainThread:@selector(enableImageViewInteraction) withObject:nil waitUntilDone:NO ];
    }
    

}

- (void) movieFinishedCallback:(NSNotification*) aNotification {
    
    playerSlider.value = 0.0;
    isPlaying = NO;
    [playButton setSelected:NO];
     player.currentPlaybackTime = playerSlider.value;

}


#pragma mark UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView == deleteAlert && buttonIndex == 1) {
        
        editButtonGlobal.uid = currentLayer;
        [self deleteLayer:editButtonGlobal overrided:nil];
        [Flurry logEvent:@"Layer Deleted"];
	}

  }


#pragma mark Custom Methods

/*
 * Load Help Screen
 */

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
	[backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
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
    lastTextView.accessibilityLabel = @"TextInput";
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
 * Here we add or Replace Two Button on Top Bar
 */
-(void)addDonetoRightBarBotton{
    
    //Delete Bar Button
    UIButton *delButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 45, 42)];
    [delButton addTarget:self action:@selector(callDeleteLayer) forControlEvents:UIControlEventTouchUpInside];
    [delButton setBackgroundImage:[UIImage imageNamed:@"delete_button"] forState:UIControlStateNormal];
    delButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *delBarButton = [[UIBarButtonItem alloc] initWithCustomView:delButton];
    
    
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [doneButton addTarget:self action:@selector(callAddMoreLayers) forControlEvents:UIControlEventTouchUpInside];
    [doneButton addTarget:self action:@selector(logPhotoAddedEvent) forControlEvents:UIControlEventTouchUpInside];

    [doneButton setBackgroundImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
    doneButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:doneBarButton,delBarButton,nil]];
    
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
    
	textBackgrnd.alpha = ALPHA1;

    // SET BOTTOM BAR
    [self setStyleTabAction:fontTabButton];

	[lastTextView resignFirstResponder];
	[lastTextView removeFromSuperview];
    lastTextView = nil;
}

-(void) donePhoto{
    
    [self callAddMoreLayers];
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

-(void)deleteLayer:(UIButton *)crossButton{
    
    
    deleteAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Delete this layer?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK" ,nil];
    [deleteAlert show];
}

-(void) callDeleteLayer{
    
    deleteAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Delete this layer?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK" ,nil];
    [deleteAlert show];
    
    
}


-(void)createDirectoryAtPath:(NSString *)directory{
	if (![[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:NULL]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
	}
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
        
        if ([child isKindOfClass:[LayerTileButton class]] || [child isKindOfClass:[UIButton class]] || [child isKindOfClass:[UILabel class]] ) {
            [child removeFromSuperview];
        }
        
    }
    

}

/*
 * Here we Getting Snap Shot of Flyer Image View Context
 * Return
 *  Image
 */
-(UIImage *)getFlyerSnapShot {
    
    //Here we take Snap shot of Flyer
    UIGraphicsBeginImageContextWithOptions(self.flyimgView.bounds.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.flyimgView.layer renderInContext:context];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshotImage;
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



/**
 * Rotate frames to ensure they are in their correct orientation. This method returns and instraction that we 
 * can use to set it right.
 *
 * Details here: http://stackoverflow.com/questions/12136841/avmutablevideocomposition-rotated-video-captured-in-portrait-mode
 */
- (void)layerInstructionAfterFixingOrientation:(AVMutableVideoCompositionLayerInstruction *)videolayerInstruction
                                     transform:(CGAffineTransform)videoTransform {
    
    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    BOOL  isVideoAssetPortrait_  = YES;
    
    if(videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0)  {videoAssetOrientation_= UIImageOrientationRight; isVideoAssetPortrait_ = YES;}
    if(videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0)  {videoAssetOrientation_ =  UIImageOrientationLeft; isVideoAssetPortrait_ = YES;}
    if(videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0)   {videoAssetOrientation_ =  UIImageOrientationUp;}
    if(videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {videoAssetOrientation_ = UIImageOrientationDown;}
    
    CGFloat FirstAssetScaleToFitRatio = 1.0;
    
    if( YES ) {
        CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
        [videolayerInstruction setTransform:CGAffineTransformConcat( videoTransform, FirstAssetScaleFactor) atTime:kCMTimeZero];
    }else{
        CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
        [videolayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat( videoTransform, FirstAssetScaleFactor),CGAffineTransformMakeTranslation(0, 160)) atTime:kCMTimeZero];
    }
}

/**
 * Determine if this video asset is in portrait mode.
 *
 * @param asset
 *           The asset that needs to be checked.
 *
 * @return
 *           YES if in portrait, NO otherwise.
 */
-(BOOL) isVideoPortrait:(AVAsset *)asset
{
    BOOL isPortrait = FALSE;
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks    count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        
        CGAffineTransform t = videoTrack.preferredTransform;
        // Portrait
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0)
        {
            isPortrait = YES;
        }
        // PortraitUpsideDown
        if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0)  {
            
            isPortrait = YES;
        }
        // LandscapeRight
        if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0)
        {
            isPortrait = FALSE;
        }
        // LandscapeLeft
        if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0)
        {
            isPortrait = FALSE;
        }
    }
    return isPortrait;
}

/*
 * HERE WE MERGE TWO VIDEOS FOR SHARE VIDEO
 */
-(void)mergeVideoWithOverlay:(NSURL *)firstURL image:(UIImage *)image {
    
    // Get a pointer to the asset
    AVURLAsset* firstAsset = [AVURLAsset URLAssetWithURL:firstURL options:nil];

    // Make an instance of avmutablecomposition so that we can edit this asset:
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    // Add tracks to this composition
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    // Audio track
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    // Image video is always 30 seconds. So we use that unless the background video is smaller.
    CMTime inTime = CMTimeMake( MAX_VIDEO_LENGTH * VIDEOFRAME, VIDEOFRAME );
    if ( CMTimeCompare( firstAsset.duration, inTime ) < 0 ) {
        inTime = firstAsset.duration;
    }

    // Add to the video track.
    NSArray *videos = [firstAsset tracksWithMediaType:AVMediaTypeVideo];
    CGAffineTransform transform;
    if ( videos.count > 0 ) {
        AVAssetTrack *track = [videos objectAtIndex:0];
        [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, inTime) ofTrack:track atTime:kCMTimeZero error:nil];
        transform = track.preferredTransform;
        videoTrack.preferredTransform = transform;
    }
    
    // Add the audio track.
    NSArray *audios = [firstAsset tracksWithMediaType:AVMediaTypeAudio];
    if ( audios.count > 0 ) {
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, inTime) ofTrack:[audios objectAtIndex:0] atTime:kCMTimeZero error:nil];
    }
    
    // Determine size of video based on orientation
    BOOL isPortrait = [self isVideoPortrait:firstAsset];
    CGSize videoSize = videoTrack.naturalSize;
    if( isPortrait ) {
        videoSize = CGSizeMake(videoSize.height, videoSize.width);
    }
    
    // Set the mix composition size.
    mixComposition.naturalSize = videoSize;

    // Set up the composition parameters.
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.frameDuration = CMTimeMake(1, VIDEOFRAME );
    videoComposition.renderSize = videoSize;
    videoComposition.renderScale = 1.0;
    
    // Pass through parameters for animation.
    AVMutableVideoCompositionInstruction *passThroughInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    passThroughInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, inTime);
    
    // Layer instructions
    AVMutableVideoCompositionLayerInstruction *passThroughLayer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    
    // Set the transform to maintain orientation
    [passThroughLayer setTransform:transform atTime:kCMTimeZero];
    
    passThroughInstruction.layerInstructions = @[ passThroughLayer ];
    videoComposition.instructions = @[passThroughInstruction];
    
    // Layer that merges the video and image
    CALayer *parentLayer = [CALayer layer];
    
    // Layer that renders the video.
    CALayer *videoLayer = [CALayer layer];
    videoLayer.frame = CGRectMake(0, 0, videoComposition.renderSize.width, videoComposition.renderSize.height);
    [parentLayer addSublayer:videoLayer];
    
    // Layer that renders flyerly image.
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, videoComposition.renderSize.width, videoComposition.renderSize.height );
    imageLayer.contents = (id)image.CGImage;
    [parentLayer addSublayer:imageLayer];
    
    // Setup the animation tool
    videoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    // Now export the movie
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    exportSession.videoComposition = videoComposition;
    
    // Export path
    NSString *destination = [self.flyer getSharingVideoPath];

    // Delete Old File if they exist
    NSError *error = nil;
    if ( [[NSFileManager defaultManager] isReadableFileAtPath:destination] ) {
        [[NSFileManager defaultManager] removeItemAtPath:destination error:&error];
    }
    
    // Export the URL
    NSURL *exportURL = [NSURL fileURLWithPath:destination];
    exportSession.outputURL = exportURL;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    exportSession.shouldOptimizeForNetworkUse = YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        switch (exportSession.status) {
            case AVAssetExportSessionStatusFailed:{
                NSLog (@"FAIL = %@",exportSession.error);
                break;
            }
            case AVAssetExportSessionStatusCompleted: {
                
                
                //Here we take Image From Video Player
                UIImage *videoCover = [self.flyer getImageForVideo];
                [self.flyer setVideoCover:videoCover];
                
                //Update Recent Flyer
                [self.flyer setRecentFlyer];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateCover" object:nil];
                
                // Background Thread
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                    
                    // Here we Add Video In Flyerly Album
                    [self.flyer saveInGallery:nil];
                    NSLog(@"Video Merge Process Completed");
                    
                    
                });
            }
        };
    }]; 

}


#pragma mark Flyer Modified

/**
 * Edit the current layer.
 */
- (void)editCurrentLayer {
    [self.flyimgView layerIsBeingEdited:currentLayer];
    
    
    //when tap on Text Box
    NSString *btnText = [flyer getText:currentLayer];
    
    if (![btnText isEqualToString:@""] && btnText != nil) {
        
        lastTextView = [[UITextView  alloc] init];
        lastTextView.text = btnText;
        
        lastTextView.accessibilityLabel = @"TextInput";
        
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

/*
 * When any Layer Tap for Edit its Call
 * and Here we manage all Layers
 */
-(void)editLayer:(LayerTileButton *)editButton{
    
    editButtonGlobal = editButton;
    currentLayer =  editButton.uid;
    editButtonGlobal.uid = currentLayer;
    
    [self editCurrentLayer];
}


/*
 * Here we Delete Layer form Dictionary and Controller
 */
-(void)deleteLayer:(LayerTileButton *)layerButton overrided:(BOOL)overrided{
    
    
    //Delete From Master Dictionary
    [flyer deleteLayer:layerButton.uid];
    
    //Delete From View
    [flyimgView deleteLayer:layerButton.uid];
    
    NSLog(@"Delete Layer Tag: %d", layerButton.tag);
    
    //Set Main View On Screen
    [self callAddMoreLayers];
}

#pragma mark - Delegate for Flyerly ImageView



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



/**
 * Frame changed for layer, let the model know.
 */
- (void)sendLayerToEditMode:(NSString *)uid  {
    // Set the given layer as current. If it is not
    // already set.
    if ( ![self.currentLayer isEqualToString:uid] ) {
        self.currentLayer = uid;

        // Edit the current layer.
        [self editCurrentLayer];
    } else if ( [flyer getText:self.currentLayer] != nil ) {
        // If the current layer is a text layer, and its been tapped
        // again then edit the text.
        [self callWrite];
    }
}

/**
 * Add video Player and Load Video .
 */
- (void)addVideo :(NSString *)url {
    
    // HERE WE MOVE SOURCE FILE INTO FLYER FOLDER
    NSString* currentpath  =   [[NSFileManager defaultManager] currentDirectoryPath];
    NSString *destination = [NSString stringWithFormat:@"%@/%@",currentpath,url];
    
    [self loadPlayerWithURL:[NSURL fileURLWithPath:destination]];
}

/**
 * Disable User Interaction of ImageView for video Player.
 */
- (void)disableImageViewInteraction {
    self.flyimgView.userInteractionEnabled = NO;
    [playerToolBar setHidden:NO];
}


/**
 * Enable User Interaction of ImageView.
 */
- (void)enableImageViewInteraction {
    self.flyimgView.userInteractionEnabled = YES;
    [playerToolBar setHidden:YES];
    
}

#pragma mark - Undo Implementation

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
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];
    
    NSString *title = [flyer getFlyerTitle];
    
    if ( [title isEqualToString:@""] ) {
        label.text = @"Flyerly";
    } else {
        label.text = title;
    }
    self.navigationItem.titleView = label;
    

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
    
    UIImage *snapshotImage;
    
    //Save OnBack
    //Here we take Snap shot of Flyer
    snapshotImage =  [self getFlyerSnapShot];
    
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


/*
 * Here we Merge Video
 */
-(void)videoMergeProcess {
    
    // CREATING PATH FOR FLYER OVERLAY VIDEO
    NSString* currentpath  =   [[NSFileManager defaultManager] currentDirectoryPath];
    NSString *originalVideoPath = [NSString stringWithFormat:@"%@/Template/template.mov", currentpath];

    // URL of the movie.
    NSURL *url = [NSURL fileURLWithPath:originalVideoPath];
    
    // Here we Update Overlay
    UIImage *image = [self getFlyerSnapShot];
    
    // Crop the image based on aspect ratio. First get the movie size.
    CGSize movieSize = self.player.naturalSize;
    
    // Now compute the aspect ratio
    CGFloat aspectRatio = movieSize.width / movieSize.height;
    
    // Now get the image height we need to use.
    CGFloat imageHeight = image.size.width / aspectRatio;
    
    // Now compute the y offset from where we crop
    CGFloat y = (image.size.height - imageHeight) / 2.0f;
    
    // Get the new cropped image
    image = [image imageCroppedToRect:CGRectMake( 0, y, image.size.width, imageHeight)];
    
    // Now scale to the movie size
    UIGraphicsBeginImageContextWithOptions( movieSize, NO, 0.0 );
    [image drawInRect:CGRectMake(0, 0, movieSize.width, movieSize.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // HERE WE ARE MERGE OVER CREATED VIDEO AND USER SELECTED OR MAKE
    [self mergeVideoWithOverlay:url image:image];
}

#pragma mark  Share Flyer


/*
 * HERE WE SHARE FLYER TO SOCIAL NETWORKS
 */
-(void)share {
    
    // Disable  Buttons
    sharePanel.hidden = NO;
    rightUndoBarButton.enabled = NO;
    shareButton.enabled = NO;
    helpButton.enabled = NO;

    //Here we Merge Video for Sharing
    if ([flyer isVideoFlyer]) {
        
        //Background Thread
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            
            //Here we Merge All Layers in Video File
            [self videoMergeProcess];
            
        });
    }
    
    [sharePanel removeFromSuperview];

    if ([flyer isVideoFlyer]) {
        shareviewcontroller = [[ShareViewController alloc] initWithNibName:@"ShareVideoViewController" bundle:nil];
        
    }else {
        shareviewcontroller = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
    }
    sharePanel = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.origin.y, 320,400 )];
    
    sharePanel = shareviewcontroller.view;
    [self.view addSubview:sharePanel];
    
    sharePanel = shareviewcontroller.view;
    NSString *shareImagePath = [flyer getFlyerImage];
    UIImage *shareImage =  [UIImage imageWithContentsOfFile:shareImagePath];

    //Here we Pass Param to Share Screen Which use for Sharing
    shareviewcontroller.selectedFlyerImage = shareImage;
    shareviewcontroller.flyer = self.flyer;
    shareviewcontroller.imageFileName = shareImagePath;
    shareviewcontroller.rightUndoBarButton = rightUndoBarButton;
    shareviewcontroller.shareButton = shareButton;
    shareviewcontroller.helpButton = helpButton;
    shareviewcontroller.titleView.text = [flyer getFlyerTitle];
    NSString *description = [flyer getFlyerDescription];
    if (![description isEqualToString:@""]) {
        shareviewcontroller.descriptionView.text = description;
    }
    
    NSString *shareType  = [[NSUserDefaults standardUserDefaults] valueForKey:@"FlyerlyPublic"];
    
    if ([shareType isEqualToString:@"Private"]) {
        [shareviewcontroller.flyerShareType setSelected:YES];
        
    }
    [flyer setShareType:shareType];
    shareviewcontroller.selectedFlyerDescription = [flyer getFlyerDescription];
    shareviewcontroller.topTitleLabel = titleLabel;
    [shareviewcontroller.descriptionView setReturnKeyType:UIReturnKeyDone];
    shareviewcontroller.Yvalue = [NSString stringWithFormat:@"%f",self.view.frame.size.height];
    
    
    PFUser *user = [PFUser currentUser];
    if (user[@"appStarRate"])
        [self setStarsofShareScreen:user[@"appStarRate"]];


    [user saveInBackground];
    
    [shareviewcontroller setSocialStatus];
    
    
    //Here we Get youtube Link
    NSString *isAnyVideoUploadOnYoutube = [self.flyer getYoutubeLink];
    
    // Any Uploaded Video Link Available of Youtube
    // then we Enable Other Sharing Options
    if (![isAnyVideoUploadOnYoutube isEqualToString:@""]) {
        [shareviewcontroller enableAllShareOptions];
    }
    
    //Create Animation Here
    [sharePanel setFrame:CGRectMake(0, self.view.frame.size.height, 320,425 )];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4f];
        [sharePanel setFrame:CGRectMake(0, self.view.frame.size.height -425, 320,425 )];
    [UIView commitAnimations];
  

}

/*
 *Here we Set Stars
 */
-(void)setStarsofShareScreen :(NSString *)rate {
    
    if ([rate isEqualToString:@"1"]) {
        [shareviewcontroller.star1 setSelected:YES];
        
    }else if ([rate isEqualToString:@"2"]) {
        [shareviewcontroller.star1 setSelected:YES];
        [shareviewcontroller.star2 setSelected:YES];
        
    }else if ([rate isEqualToString:@"3"]) {
        [shareviewcontroller.star1 setSelected:YES];
        [shareviewcontroller.star2 setSelected:YES];
        [shareviewcontroller.star3 setSelected:YES];

    }else if ([rate isEqualToString:@"4"]) {
        [shareviewcontroller.star1 setSelected:YES];
        [shareviewcontroller.star2 setSelected:YES];
        [shareviewcontroller.star3 setSelected:YES];
        [shareviewcontroller.star4 setSelected:YES];
        
    }else if ([rate isEqualToString:@"5"]) {
        [shareviewcontroller.star1 setSelected:YES];
        [shareviewcontroller.star2 setSelected:YES];
        [shareviewcontroller.star3 setSelected:YES];
        [shareviewcontroller.star4 setSelected:YES];
        [shareviewcontroller.star5 setSelected:YES];
    }

}

#pragma mark  Bottom Tabs Context
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
        
        //HERE WE SET ANIMATION
        [UIView animateWithDuration:0.4f
                         animations:^{
                             //Create ScrollView
                             [self addFontsInSubView];
                         }
                         completion:^(BOOL finished){
                             [layerScrollView flashScrollIndicators];
                         }];
        //END ANIMATION
        
         //Add ContextView
        [self addScrollView:layerScrollView];
        
		[fontTabButton setSelected:YES];
	}
	else if(selectedButton == colorTabButton)
	{
        
        //HERE WE SET ANIMATION
        [UIView animateWithDuration:0.4f
                         animations:^{
                             //Create ScrollView
                             [self addColorsInSubView];
                         }
                         completion:^(BOOL finished){
                             [layerScrollView flashScrollIndicators];
                         }];
        //END ANIMATION
        
        //Add ContextView
        [self addScrollView:layerScrollView];
        [colorTabButton setSelected:YES];
        
	}
	else if(selectedButton == sizeTabButton)
	{

        //HERE WE SET ANIMATION
        [UIView animateWithDuration:0.4f
                         animations:^{
                             //Create ScrollView
                             [self addSizeInSubView];
                         }
                         completion:^(BOOL finished){
                             [layerScrollView flashScrollIndicators];
                         }];
        //END ANIMATION
        
        //Add ContextView
        [self addScrollView:layerScrollView];
        
		[sizeTabButton setSelected:YES];
	}
	else if(selectedButton == fontBorderTabButton)
	{

        //HERE WE SET ANIMATION
        [UIView animateWithDuration:0.4f
                         animations:^{
                             //Create ScrollView
                             [self addTextBorderInSubView];
                         }
                         completion:^(BOOL finished){
                             [layerScrollView flashScrollIndicators];
                         }];
        //END ANIMATION
        
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
    
    //Un Selected State of Buttons
    [backtemplates setSelected:NO];
    [flyerBorder setSelected:NO];
    
    
    if( selectedButton == backtemplates )
	{
        [backtemplates setBackgroundImage:[UIImage imageNamed:@"addbg_library_selected"] forState:UIControlStateNormal];
        
        
        //HERE WE SET ANIMATION
        [UIView animateWithDuration:0.4f
                         animations:^{
                             //Create ScrollView
                             [self addTemplatesInSubView];
                         }
                         completion:^(BOOL finished){
                             [layerScrollView flashScrollIndicators];
                         }];
        //END ANIMATION
        
        //Add ContextView
        [self addScrollView:layerScrollView];
        [backtemplates setSelected:YES];
    }
    else if(selectedButton == cameraTakePhoto)
    {

        [self openCustomCamera:YES];
        [self addScrollView:videoLabel];

    }
    else if(selectedButton == cameraRoll)
    {

        //HERE WE CHECK USER DID ALLOWED TO ACCESS PHOTO library
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusRestricted || [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
            
            UIAlertView *photoAlert = [[UIAlertView alloc ] initWithTitle:@"" message:@"Flyerly does not access to your photo album.To enable access goto the Setting app >> Privacy >> Photos and enable Flyerly" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [photoAlert show];
            return;
            
        }
        
        [self loadCustomPhotoLibrary :@"YES"];
        
        //Add ContextView
        [self addScrollView:videoLabel];

    }
    else if(selectedButton == flyerBorder)
    {
        [flyerBorder setSelected:YES];
        
        //HERE WE SET ANIMATION
        [UIView animateWithDuration:0.4f
                         animations:^{
                             //Create ScrollView
                            [self addFlyerBorderInSubView];
                         }
                         completion:^(BOOL finished){
                             [layerScrollView flashScrollIndicators];
                         }];
        //END ANIMATION
        
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
        
        //HERE WE CHECK USER DID ALLOWED TO ACESS PHOTO library
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusRestricted || [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
            
            UIAlertView *photoAlert = [[UIAlertView alloc ] initWithTitle:@"" message:@"Flyerly does not access to your photo album.To enable access goto the Setting app >> Privacy >> Photos and enable Flyerly" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [photoAlert show];
            return;
            
        }
        
        [self loadCustomPhotoLibrary :@"NO"];

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
		imgPickerFlag = 2;
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
        
        //HERE WE SET ANIMATION
        [UIView animateWithDuration:0.4f
                         animations:^{
                             //Create ScrollView
                             [self addFlyerIconInSubView];
                         }
                         completion:^(BOOL finished){
                             [layerScrollView flashScrollIndicators];
                         }];
        

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
        
        
        //HERE WE SET ANIMATION
        [UIView animateWithDuration:0.4f
                         animations:^{
                             //Create ScrollView
                             [self addSymbolsInSubView];
                         }
                         completion:^(BOOL finished){
                             [layerScrollView flashScrollIndicators];
                         }];

        
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



#pragma mark Flurry Methods

-(void) logPhotoAddedEvent{
    [Flurry logEvent:@"Photo Added"];
}

-(void) logTextAddedEvent{
    [Flurry logEvent:@"Text Added"];
}


#pragma mark Access Image Directory
/*
 *Here we Copy Image to Template Directory
 */
-(void)copyImageToTemplate :(UIImage *)img{
    
    // Create Symbol direcrory if not created
    NSString* currentpath  =   [[NSFileManager defaultManager] currentDirectoryPath];
    
    NSString *FolderPath = [NSString stringWithFormat:@"%@/Template/template.%@", currentpath,IMAGETYPE];
    
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
    
    NSString *imageFolderPath = [NSString stringWithFormat:@"%@/%d.%@", FolderPath,timestamp,IMAGETYPE];
    
    dicPath = [dicPath stringByAppendingString:[NSString stringWithFormat:@"/%d.%@",timestamp,IMAGETYPE]];
    
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
        
        imageFolderPath = [NSString stringWithFormat:@"%@/template.%@", FolderPath,IMAGETYPE];
        dicPath = [dicPath stringByAppendingString:[NSString stringWithFormat:@"/template.%@",IMAGETYPE]];
        
        //Getting Image From Bundle
        existImagePath =[[NSBundle mainBundle] pathForResource:imgName ofType:@"jpg"];
        
    } else {
        
        //Create Unique Id for Image
        int timestamp = [[NSDate date] timeIntervalSince1970];
        
        imageFolderPath = [NSString stringWithFormat:@"%@/%d.%@", FolderPath,timestamp,IMAGETYPE];
        dicPath = [dicPath stringByAppendingString:[NSString stringWithFormat:@"/%d.%@",timestamp,IMAGETYPE]];
        
        //Getting Image From Bundle
        existImagePath =[[NSBundle mainBundle] pathForResource:imgName ofType:@"png"];
        
    }
    
    UIImage *realImage =  [UIImage imageWithContentsOfFile:existImagePath];
    NSData *imgData = UIImagePNGRepresentation(realImage);
    
    //Create a Image Copy to Current Flyer Folder
    [[NSFileManager defaultManager] createFileAtPath:imageFolderPath contents:imgData attributes:nil];
    
    
    return dicPath;
    
}


@end
