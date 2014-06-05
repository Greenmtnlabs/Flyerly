
//  Flyer
//
//  Created by Riksof Pvt. Ltd on 12/10/09.
//
//

#import "CreateFlyerController.h"
#import "UIImage+NBUAdditions.h"
#import "Common.h"

@implementation CreateFlyerController

CameraViewController *nbuCamera;

NSMutableArray *productArray;
@synthesize selectedFont,selectedColor,selectedTemplate,fontTabButton,colorTabButton,sizeTabButton,fontEditButton,selectedSize,
fontBorderTabButton,addVideoTabButton,addMorePhotoTabButton,addArtsTabButton,sharePanel,clipArtTabButton,emoticonsTabButton,artsColorTabButton,artsSizeTabButton;
@synthesize cameraTabButton,photoTabButton,widthTabButton,heightTabButton,deleteAlert,signInAlert;
@synthesize imgPickerFlag,layerScrollView,flyerPath;
@synthesize contextView,libraryContextView,libFlyer,backgroundTabButton,addMoreFontTabButton;
@synthesize libText,libBackground,libArts,libPhoto,libEmpty,backtemplates,cameraTakePhoto,cameraRoll,flyerBorder;
@synthesize flyimgView,currentLayer,layersDic,flyer,player,playerView,playerToolBar,playButton,playerSlider,tempelateView;
@synthesize durationLabel,durationChange,onFlyerBack,mainView;
int selectedAddMoreLayerTab = -1;


#pragma mark -  View Appear Methods

/**
 * Update the view once it appears.
 */
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    //Render Flyer
    [self renderFlyer];
    
    NSString *title = [flyer getFlyerTitle];
    
    //HERE WE GET USER PURCHASES INFO FROM PARSE
    if(![[NSUserDefaults standardUserDefaults] stringForKey:@"InAppPurchases"]){
        
        FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
        UserPurchases *userPurchases_ = appDelegate.userPurchases;
        
        //Checking if user valid purchases
        if ( [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyAllDesignBundle"]   ||
            [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyUnlockSavedFlyers"]    ) {
            
            //Unloking features
            UIImage *buttonImage = [UIImage imageNamed:@"video_tab.png"];
            [addVideoTabButton setImage:buttonImage forState:UIControlStateNormal];
        }
    }
    
    if ( ![title isEqualToString:@""] ) {
        titleLabel.text = title;
    } else {
        titleLabel.text = @"Flyer";
    }
}

/**
 * View setup. This is done once per instance.
 */
-(void)viewDidLoad{
	[super viewDidLoad];
    
    // Here we Set Top Bar Item
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:TITLE_FONT size:18];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];
    
    self.navigationItem.titleView = titleLabel;
    
    // Device Check Maintain Size of ScrollView Because Scroll Indicator will show.
    if ( IS_IPHONE_5 ) {
        layerScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,320,150)];
    } else {
        layerScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,320,60)];
    }
    
    // Configure its scroll view.
    [layerScrollView setCanCancelContentTouches:NO];
	layerScrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
	layerScrollView.clipsToBounds = YES;
	layerScrollView.scrollEnabled = YES;
	layerScrollView.pagingEnabled = NO;
	layerScrollView.showsHorizontalScrollIndicator = YES;
	layerScrollView.showsVerticalScrollIndicator = YES;
    
    // Show the layers first up.
    [self addScrollView:layerScrollView];
    
    // Setup the label fonts
    [_addMoreLayerOrSaveFlyerLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:16]];
    [_takeOrAddPhotoLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:18]];
    [_videoLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:16]];
    
    //Right ShareButton
    shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    shareButton.titleLabel.font = [UIFont fontWithName:@"Signika-Semibold" size:13];
	[shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"share_button"] forState:UIControlStateNormal];
    shareButton.showsTouchWhenHighlighted = YES;
    
    // Right UndoButton
    UIButton *undoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    undoButton.titleLabel.font = [UIFont fontWithName:@"Signika-Semibold" size:13];
	[undoButton addTarget:self action:@selector(undoFlyer) forControlEvents:UIControlEventTouchUpInside];
    [undoButton setBackgroundImage:[UIImage imageNamed:@"undo"] forState:UIControlStateNormal];
    undoButton.showsTouchWhenHighlighted = YES;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    rightUndoBarButton = [[UIBarButtonItem alloc] initWithCustomView:undoButton];
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,rightUndoBarButton,nil]];
    
    // Left BackButton
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
    
    // Left HelpButton
    helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [helpButton addTarget:self action:@selector(loadHelpController) forControlEvents:UIControlEventTouchUpInside];
    [helpButton setBackgroundImage:[UIImage imageNamed:@"help_icon"] forState:UIControlStateNormal];
    helpButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarHelpButton = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
    
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:backBarButton,leftBarHelpButton,nil]];
    
    // Set height and width of each element of scroll view
    layerXposition = 0;
    widthValue = 35;
    heightValue = 35;
    
	// Default Selection for start
	selectedFont = [UIFont fontWithName:@"Arial" size:16];
	selectedColor = [UIColor blackColor];
	selectedSize = 16;
    
    // Set Initial Background Image For Flyer New or Edit
    if( !selectedTemplate ) {
        selectedTemplate  = [UIImage imageNamed:@"main_area_bg"];
    }
    
    // layerTile Button
    editButtonGlobal = [[LayerTileButton alloc]init];
    editButtonGlobal.uid = @"";
    
    // Main Scroll Views Initialize
    layersDic = [[NSMutableDictionary alloc] init];
	templateArray = [[NSMutableArray alloc] init];
	imgPickerFlag = 1;
    selectedAddMoreLayerTab = -1;
    
    // Current selected layer.
    currentLayer = @"";
    
    // Execute the rest of the stuff, a little delayed to speed up loading.
    dispatch_async( dispatch_get_main_queue(), ^{
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
        colorArray = [[NSArray  alloc] initWithObjects: [UIColor redColor],
                      [UIColor blueColor],
                      [UIColor greenColor],
                      [UIColor blackColor],
                      [UIColor colorWithRed:253.0/255.0 green:191.0/255.0 blue:38.0/224.0 alpha:1],
                      [UIColor colorWithWhite:1.0f alpha:1.0f],
                      [UIColor grayColor],
                      [UIColor magentaColor],
                      [UIColor yellowColor],
                      [UIColor colorWithRed:163.0/255.0 green:25.0/255.0 blue:2.0/224.0 alpha:1],
                      [UIColor colorWithRed:3.0/255.0 green:15.0/255.0 blue:41.0/224.0 alpha:1],
                      [UIColor purpleColor],
                      [UIColor colorWithRed:66.0/255.0 green:2.0/255.0 blue:2.0/224.0 alpha:1],
                      [UIColor orangeColor],
                      [UIColor colorWithRed:98.0/255.0 green:74.0/255.0 blue:9.0/224.0 alpha:1],
                      [UIColor colorWithRed:80.0/255.0 green:7.0/255.0 blue:1.0/224.0 alpha:1],
                      [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:97.0/224.0 alpha:1],
                      [UIColor colorWithRed:111.0/255.0 green:168.0/255.0 blue:100.0/224.0 alpha:1],
                      [UIColor cyanColor],
                      [UIColor colorWithRed:17.0/255.0 green:69.0/255.0 blue:70.0/224.0 alpha:1],
                      [UIColor colorWithRed:173.0/255.0 green:127.0/255.0 blue:251.0/224.0 alpha:1], nil];
        
        
        // Create border colors array
        borderArray = 	[[NSArray  alloc] initWithObjects: [UIColor blackColor], [UIColor grayColor], [UIColor darkGrayColor], [UIColor blueColor], [UIColor purpleColor], [UIColor colorWithRed:115.0/255.0 green:134.0/255.0 blue:144.0/255.0 alpha:1], [UIColor orangeColor], [UIColor greenColor], [UIColor redColor], [UIColor colorWithRed:14.0/255.0 green:95.0/255.0 blue:111.0/255.0 alpha:1], [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:149.0/255.0 alpha:1], [UIColor colorWithRed:228.0/255.0 green:128.0/255.0 blue:144.0/255.0 alpha:1], [UIColor colorWithRed:213.0/255.0 green:110.0/255.0 blue:86.0/255.0 alpha:1],[UIColor colorWithRed:156.0/255.0 green:195.0/255.0 blue:233.0/255.0 alpha:1],[UIColor colorWithRed:27.0/255.0 green:70.0/255.0 blue:148.0/255.0 alpha:1],[UIColor colorWithRed:234.0/255.0 green:230.0/255.0 blue:51.0/255.0 alpha:1],[UIColor cyanColor], [UIColor colorWithRed:232.0/255.0 green:236.0/255.0 blue:51.0/224.0 alpha:1],[UIColor magentaColor],[UIColor colorWithRed:57.0/255.0 green:87.0/255.0 blue:13.0/224.0 alpha:1], [UIColor colorWithRed:93.0/255.0 green:97.0/255.0 blue:196.0/224.0 alpha:1],nil];
        
        // HERE WE CREATE FLYERLY ALBUM ON DEVICE
        if(![[NSUserDefaults standardUserDefaults] stringForKey:@"FlyerlyAlbum"]){
            [flyer createFlyerlyAlbum];
        }
        
        // Setup the share panel.
        sharePanel = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.origin.y, 320,400 )];
        shareviewcontroller = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
        
        sharePanel = shareviewcontroller.view;
        sharePanel.hidden = YES;
        [self.view addSubview:sharePanel];
        
        //Set Undo Bar Status
        [self setUndoStatus];
        
        //Set Context View
        [self addAllLayersIntoScrollView ];
        
        //Set Context Tabs
        [self addBottomTabs:libFlyer];
    });
}

#pragma mark -  View DisAppear Methods

/*
 * This Method Call On Back Button
 * and its Save Flyer then Exits Screen
 */
-(void) goBack {

    // Make sure we hide the keyboard.
    [lastTextView resignFirstResponder];
    [lastTextView removeFromSuperview];
    lastTextView = nil;
    
    // If the sharing panel is open, we are just going to close it down.
    // Do not need to do any thing else.
    float yValue = self.view.frame.size.height - 425;
    if (yValue == sharePanel.frame.origin.y) {
        
        // Close Keyboard if Open
        [shareviewcontroller.titleView resignFirstResponder];
        [shareviewcontroller.descriptionView resignFirstResponder];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4f];
            [sharePanel setFrame:CGRectMake(0, self.view.frame.size.height, 320, 425)];
        [UIView commitAnimations];
        [shareviewcontroller.titleView resignFirstResponder];
        [shareviewcontroller.descriptionView resignFirstResponder];

        rightUndoBarButton.enabled = YES;
        shareButton.enabled = YES;
        helpButton.enabled = YES;
        return;
    }
    
    // Delete empty layer if it exists.
    if ( currentLayer != nil && ![currentLayer isEqualToString:@""] ) {
        
        NSString *flyerImg = [flyer getImageName:currentLayer];
        NSString *flyertext = [flyer getText:currentLayer];
        
        if ( [flyerImg isEqualToString:@""] || [flyertext isEqualToString:@""] ) {
            [flyer deleteLayer:currentLayer];
            [self.flyimgView deleteLayer:currentLayer];
        }
    }
    
    // If a layer is selected, unselect it.
    if ( ![currentLayer isEqualToString:@""] ) {
        [self.flyimgView layerStoppedEditing:currentLayer];
    }
    
    // This work will be done in the background to prevent the UI from being
    // stuck.
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        // Save flyer to disk
        [flyer saveFlyer];
        
        // Make a history entry if needed.
        [flyer addToHistory];
        
        // If this is a video flyer, then merge the video.
        if ( [flyer isVideoFlyer] ) {
            
            // Here Compare Current Flyer with history Flyer
            if ( [self.flyer isVideoMergeProcessRequired] ) {
                
                panelWillOpen = NO;
                
                // Here we Merge All Layers in Video File
                [self videoMergeProcess];
                
            }
            
        } else {
            // Here we take Snap shot of Flyer and
            // Flyer Add to Gallery if user allow to Access there photos
            [flyer setUpdatedSnapshotWithImage:[self getFlyerSnapShot]];
        }
        
        // Go to the main thread and let the home screen know that flyer is
        // updated.
        dispatch_async( dispatch_get_main_queue(), ^{
            
            // Here we call Block for update Main UI
            self.onFlyerBack( @"" );
        });
        
        [Flurry logEvent:@"Saved Flyer"];
    });
    
    [self.navigationController popViewControllerAnimated:YES];
    
    // Remove observers
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -  Add Content In ScrollViews

/*
 * Add templates in scroll views
 */
-(void)addTemplatesInSubView{
    
    // Load sizes xib asynchronously
    dispatch_async( dispatch_get_main_queue(), ^{
        imgPickerFlag =1;

        [templateArray removeAllObjects];

        //Delete SubViews From ScrollView
        [self deleteSubviewsFromScrollView];


        //[layerScrollView addSubview:tempelateView];
        if(IS_IPHONE_5){
            NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"Backgrounds" owner:self options:nil];
            mainView = [subviewArray objectAtIndex:0];
            [layerScrollView addSubview:mainView];
            
            [layerScrollView setContentSize:CGSizeMake(320, mainView.frame.size.height)];
        } else {
            
            NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"Backgrounds-iPhone4" owner:self options:nil];
            mainView = [subviewArray objectAtIndex:0];
            [layerScrollView addSubview:mainView];
            
            [layerScrollView setContentSize:CGSizeMake(mainView.frame.size.width, [layerScrollView bounds].size.height)];
        }

        for (UIView *sub in mainView.subviews) {
            if ([sub isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *) sub;
                [btn addTarget:self action:@selector(selectTemplate:) forControlEvents:UIControlEventTouchUpInside];
                
            }
        }
    });
}

/*
 * Add ClipArts in scroll views
 */
-(void)addClipArtsInSubView{
    
    [self deleteSubviewsFromScrollView];
    
    CGFloat curXLoc = 0;
    CGFloat curYLoc = 5;
    int increment = 5;
    
    if(IS_IPHONE_5){
        curXLoc = 13;
        curYLoc = 10;
        increment = 8;
    }
    
    // Load sizes xib asynchronously
    dispatch_async( dispatch_get_main_queue(), ^{
        
        NSMutableDictionary *textLayer;
        NSString *textFamily;
        NSArray *subviewArray;
        
        if(IS_IPHONE_5){
            subviewArray = [[NSBundle mainBundle] loadNibNamed:@"Cliparts" owner:self options:nil];
            mainView = [subviewArray objectAtIndex:0];
            [layerScrollView addSubview:mainView];
            
            
            [layerScrollView setContentSize:CGSizeMake(320, mainView.frame.size.height)];
            //[layerScrollView setContentSize:CGSizeMake(320, curYLoc + heightValue)];
        } else {
            
            subviewArray = [[NSBundle mainBundle] loadNibNamed:@"Cliparts-iPhone4" owner:self options:nil];
            mainView = [subviewArray objectAtIndex:0];
            [layerScrollView addSubview:mainView];
            
            
            [layerScrollView setContentSize:CGSizeMake(mainView.frame.size.width, [layerScrollView bounds].size.height)];
            //[layerScrollView setContentSize:CGSizeMake(mainView.frame.size.width, [layerScrollView bounds].size.height)];
        }
        
        mainView = [subviewArray objectAtIndex:0];
        NSArray *fontsArray = mainView.subviews;
        
        //Getting Last Info of Text Layer
        if (![currentLayer isEqualToString:@""]) {
            textLayer = [flyer getLayerFromMaster:currentLayer];
            textFamily = [textLayer objectForKey:@"fontname"];
        }
        
        // Find out the path of Cliparts.plist
        NSString *clipartsPlistPath = [[NSBundle mainBundle] pathForResource:@"Cliparts" ofType:@"plist"];
        NSArray *cliparts = [[NSArray alloc] initWithContentsOfFile:clipartsPlistPath];
        
        for (int i = 0; i < [cliparts count] ; i++)
        {
            UIButton *font;
            if ([fontsArray[i] isKindOfClass:[UIButton class]]) {
                font = (UIButton *) fontsArray[i];
            }
            
            UIFont *fontType = [UIFont fontWithName:[cliparts[i] objectForKey:@"fontType"] size:33.0f];
            
            [font.titleLabel setFont: fontType];
            
            [font setTitle:[cliparts[i] objectForKey:@"character" ] forState:UIControlStateNormal];

        }
    });
}


/*
 * Add Arts Colors in scroll views
 */
-(void)addArtsColorsInSubView{
    
}

/*
 * Add Arts Sizes in scroll views
 */
-(void)addArtsSizesInSubView{
    
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

        // Load sizes xib asynchronously
        dispatch_async( dispatch_get_main_queue(), ^{
            
        NSMutableDictionary *textLayer;
        NSString *textFamily;
        NSArray *subviewArray;
        
        if(IS_IPHONE_5){
            subviewArray = [[NSBundle mainBundle] loadNibNamed:@"Fonts" owner:self options:nil];
            mainView = [subviewArray objectAtIndex:0];
            [layerScrollView addSubview:mainView];
            
            [layerScrollView setContentSize:CGSizeMake(320, curYLoc + heightValue)];
        } else {
            
            subviewArray = [[NSBundle mainBundle] loadNibNamed:@"Fonts-iPhone4" owner:self options:nil];
            mainView = [subviewArray objectAtIndex:0];
            [layerScrollView addSubview:mainView];
            
            [layerScrollView setContentSize:CGSizeMake(mainView.frame.size.width, [layerScrollView bounds].size.height)];
        }
        
        mainView = [subviewArray objectAtIndex:0];
        NSArray *fontsArray = mainView.subviews;
        
       //Getting Last Info of Text Layer
        if (![currentLayer isEqualToString:@""]) {
            textLayer = [flyer getLayerFromMaster:currentLayer];
            textFamily = [textLayer objectForKey:@"fontname"];
        }
        
        for (int i = 1; i <=[fontArray count] ; i++)
        {
            UIButton *font;
            if ([fontsArray[i-1] isKindOfClass:[UIButton class]]) {
                font = (UIButton *) fontsArray[i-1];            
            }
            
            UIFont *fontname =fontArray[(i-1)];
            [font.titleLabel setFont: fontname];
            
            //Here we Highlight Last Font Selected
            if (textLayer) {
                
                NSString *fontFamily = [fontname familyName];
                
                if ([textFamily isEqualToString:fontFamily]) {
                    
                    // Add border to selected layer thumbnail
                    [font.layer setBorderWidth:3.0];
                    [font.layer setCornerRadius:8];
                    UIColor * c = [UIColor colorWithRed:1/255.0 green:151/255.0 blue:221/255.0 alpha:1];
                    [font.layer setBorderColor:c.CGColor];
                }
            }
        }
    });

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
    
    // Load sizes xib asynchronously
    dispatch_async( dispatch_get_main_queue(), ^{
        
        NSArray *subviewArray;
        
        if(IS_IPHONE_5){
            
            subviewArray = [[NSBundle mainBundle] loadNibNamed:@"Sizes" owner:self options:nil];
          
            mainView = [subviewArray objectAtIndex:0];
            [layerScrollView addSubview:mainView];
            
            [layerScrollView setContentSize:CGSizeMake(320, curYLoc + heightValue)];
        } else {
            
            subviewArray = [[NSBundle mainBundle] loadNibNamed:@"Sizes-iPhone4" owner:self options:nil];
            mainView = [subviewArray objectAtIndex:0];
            [layerScrollView addSubview:mainView];
            
            [layerScrollView setContentSize:CGSizeMake(mainView.frame.size.width, [layerScrollView bounds].size.height)];
        }
        
        mainView = [subviewArray objectAtIndex:0];
        NSArray *sizesArray = mainView.subviews;
        
        for (int i = 1; i <=  [SIZE_ARRAY count] ; i++)
        {
            
            UIButton *size;
            if ([sizesArray[i-1] isKindOfClass:[UIButton class]]) {
                size = (UIButton *) sizesArray[i-1];
            }
            
            NSString *sizeValue =SIZE_ARRAY[(i-1)];
            [size setTitle:sizeValue forState:UIControlStateNormal];
            
            //Here we Highlight Last Size Selected
            if (textLayer) {
                
                NSString *tsize = [NSString stringWithFormat:@"%f", [sizeValue floatValue]];
                
                if ([textSize isEqualToString:tsize]) {
                    
                    // Add border to selected layer thumbnail
                    [size.layer setBorderWidth:3.0];
                    [size.layer setCornerRadius:8];
                    UIColor * c = [UIColor colorWithRed:1/255.0 green:151/255.0 blue:221/255.0 alpha:1];
                    [size.layer setBorderColor:c.CGColor];
                }
                
            }
        
        }
    });
    
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
    
    // Load sizes xib asynchronously
    dispatch_async( dispatch_get_main_queue(), ^{
        NSArray *subviewArray;
        
        if(IS_IPHONE_5){
            subviewArray = [[NSBundle mainBundle] loadNibNamed:@"Colours" owner:self options:nil];
            mainView = [subviewArray objectAtIndex:0];
            [layerScrollView addSubview:mainView];
            
            [layerScrollView setContentSize:CGSizeMake(320, curYLoc + heightValue)];
        } else {
            
            subviewArray = [[NSBundle mainBundle] loadNibNamed:@"Colours-iPhone4s" owner:self options:nil];
            mainView = [subviewArray objectAtIndex:0];
            [layerScrollView addSubview:mainView];
            
            [layerScrollView setContentSize:CGSizeMake(mainView.frame.size.width, [layerScrollView bounds].size.height)];
        }
        
        mainView = [subviewArray objectAtIndex:0];
        NSArray *coloursArray = mainView.subviews;
        
        for (int i = 1; i <=  [colorArray count] ; i++)
        {        
            UIButton *color;
            if ([coloursArray[i-1] isKindOfClass:[UIButton class]]) {
                color = (UIButton *) coloursArray[i-1];
            }
            
            id colorName = colorArray[(i-1)];
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
                    UIColor * c = [UIColor colorWithRed:1/255.0 green:151/255.0 blue:221/255.0 alpha:1];
                    [color.layer setBorderColor:c.CGColor];
                }
            }
            
        }//Loop
    });
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
    
    
    // Load sizes xib asynchronously
    dispatch_async( dispatch_get_main_queue(), ^{
        
            NSArray *subviewArray;
            
            if(IS_IPHONE_5){
                subviewArray = [[NSBundle mainBundle] loadNibNamed:@"Borders" owner:self options:nil];
                mainView = [subviewArray objectAtIndex:0];
                [layerScrollView addSubview:mainView];
                
                [layerScrollView setContentSize:CGSizeMake(320, curYLoc + heightValue)];
            } else {
                
                subviewArray = [[NSBundle mainBundle] loadNibNamed:@"Borders-iPhone4" owner:self options:nil];
                mainView = [subviewArray objectAtIndex:0];
                [layerScrollView addSubview:mainView];
                
                [layerScrollView setContentSize:CGSizeMake(mainView.frame.size.width, [layerScrollView bounds].size.height)];
            }
            
            mainView = [subviewArray objectAtIndex:0];
            NSArray *bodersArray = mainView.subviews;
            int count = (bodersArray.count)/3;
        
            int i=1;
            for (int index = 0; index < count; index++ )
            {
                
                UIColor *colorName = borderArray[(i-1)];
                
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
                        UIButton *color = (UIButton *) bodersArray[index];
                        // Add border to selected layer thumbnail
                        //color.backgroundColor = [UIColor colorWithRed:1/255.0 green:151/255.0 blue:221/255.0 alpha:1];
                    }
                    
                    i++;
                
            }
        }// Loop
        
    });
    
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

    // Load sizes xib asynchronously
    dispatch_async( dispatch_get_main_queue(), ^{
        
        NSArray *subviewArray;
        
        if(IS_IPHONE_5){
            subviewArray = [[NSBundle mainBundle] loadNibNamed:@"Borders" owner:self options:nil];
            mainView = [subviewArray objectAtIndex:0];
            [layerScrollView addSubview:mainView];
            
            [layerScrollView setContentSize:CGSizeMake(320, curYLoc + heightValue)];
        } else {
            
            subviewArray = [[NSBundle mainBundle] loadNibNamed:@"Borders-iPhone4" owner:self options:nil];
            mainView = [subviewArray objectAtIndex:0];
            [layerScrollView addSubview:mainView];
            
            [layerScrollView setContentSize:CGSizeMake(mainView.frame.size.width, [layerScrollView bounds].size.height)];
        }
        
        mainView = [subviewArray objectAtIndex:0];
        NSArray *bodersArray = mainView.subviews;
        int count = (bodersArray.count)/3;
        
        int i=1;
        int index_ = 0;
        for (int index = 0; index < count; index++ )
        {
            
            UIColor *colorName = borderArray[(i-1)];
            
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
                    //color.backgroundColor = [UIColor colorWithRed:1/255.0 green:151/255.0 blue:221/255.0 alpha:1];
                }
                
                i++;
            }
        }// Loop
        
        for (int counter = 2; counter  < bodersArray.count; counter += 3) {
            NSLog(@"%d",counter);
            [[bodersArray objectAtIndex:counter] addTarget:self action:@selector(selectBorder:) forControlEvents:UIControlEventTouchUpInside];
        }
    });
    
}
/*
 * Add flyer Symbols in scroll views
 */
-(void)addSymbolsInSubView{
    
    //Delete Subviews of ScrollViews
    [self deleteSubviewsFromScrollView];
    
    //Getting Last Image Tag for highlight
    NSString *LastTag = [flyer getImageTag:currentLayer];
    
    // Load sizes xib asynchronously
    dispatch_async( dispatch_get_main_queue(), ^{
        
        
            NSArray *subviewArray;
            
            if(IS_IPHONE_5){
                subviewArray = [[NSBundle mainBundle] loadNibNamed:@"Symbols" owner:self options:nil];
                mainView = [subviewArray objectAtIndex:0];
                [layerScrollView addSubview:mainView];
                
                [layerScrollView setContentSize:CGSizeMake(320, mainView.frame.size.height)];
            } else {
                
                subviewArray = [[NSBundle mainBundle] loadNibNamed:@"Symbols-iPhone4" owner:self options:nil];
                mainView = [subviewArray objectAtIndex:0];
                [layerScrollView addSubview:mainView];
                
                [layerScrollView setContentSize:CGSizeMake(mainView.frame.size.width, [layerScrollView bounds].size.height)];
            }
            
            mainView = [subviewArray objectAtIndex:0];
            NSArray *symbolsArray = mainView.subviews;
            
            for(int i=1;i<=113;i++) {
                
                //Here we Hightlight Last Selected Image
                if (![LastTag isEqualToString:@""]) {
                    
                    if ([LastTag intValue] == i ) {
                        
                        UIButton *symbolButton = symbolsArray[i-1];
                        // Add border to selected layer thumbnail
                        [symbolButton.layer setCornerRadius:8];
                        [symbolButton.layer setBorderWidth:3.0];
                        UIColor * c = [UIColor colorWithRed:1/255.0 green:151/255.0 blue:221/255.0 alpha:1];
                        [symbolButton.layer setBorderColor:c.CGColor];
                    }
            
                }
                
            }//loop
    });

}


/*
 * Add Emoticons in scroll views
 */
-(void)addEmoticonsInSubView{
    
    iconArray = [[NSMutableArray alloc]init];
    
    //Delete SubViews from ScrollView
    [self deleteSubviewsFromScrollView];
    
    
    // Load sizes xib asynchronously
    dispatch_async( dispatch_get_main_queue(), ^{
        
        NSArray *subviewArray;
        
        if(IS_IPHONE_5){
            subviewArray = [[NSBundle mainBundle] loadNibNamed:@"Emoticons" owner:self options:nil];
            mainView = [subviewArray objectAtIndex:0];
            [layerScrollView addSubview:mainView];
            
            [layerScrollView setContentSize:CGSizeMake(320, mainView.frame.size.height)];
        } else {
            
            subviewArray = [[NSBundle mainBundle] loadNibNamed:@"Emoticons-iPhone4" owner:self options:nil];
            mainView = [subviewArray objectAtIndex:0];
            [layerScrollView addSubview:mainView];
            
            [layerScrollView setContentSize:CGSizeMake(mainView.frame.size.width, [layerScrollView bounds].size.height)];
        }
        
        mainView = [subviewArray objectAtIndex:0];
        NSArray *flyerIconArray = mainView.subviews;
        
        //Getting Last Image Tag for highlight
        NSString *LastTag = [flyer getImageTag:currentLayer];
        
        for(int i=1;i<=94;i++) {
            
            //Here we Hightlight Last Selected Image
            if (![LastTag isEqualToString:@""]) {
                
                
                if ([LastTag intValue] == i ) {
                    
                    // Add border to selected layer thumbnail
                    UIButton *iconButton = flyerIconArray[i-1];
                    [iconButton.layer setCornerRadius:8];
                    [iconButton.layer setBorderWidth:3.0];
                    UIColor * c = [UIColor colorWithRed:1/255.0 green:151/255.0 blue:221/255.0 alpha:1];
                    [iconButton.layer setBorderColor:c.CGColor];
                }
            }
            
        }//loop
        
    });
    
}


/*
 * Add flyer Icons in scroll views
 */
-(void)addFlyerIconInSubView{
    
    iconArray = [[NSMutableArray alloc]init];
    
    //Delete SubViews from ScrollView
    [self deleteSubviewsFromScrollView];
    
    
    // Load sizes xib asynchronously
    dispatch_async( dispatch_get_main_queue(), ^{
        
    NSArray *subviewArray;
        
            if(IS_IPHONE_5){
                subviewArray = [[NSBundle mainBundle] loadNibNamed:@"FlyerIcons" owner:self options:nil];
                mainView = [subviewArray objectAtIndex:0];
                [layerScrollView addSubview:mainView];
                
                [layerScrollView setContentSize:CGSizeMake(320, mainView.frame.size.height)];
            } else {
                
                subviewArray = [[NSBundle mainBundle] loadNibNamed:@"FlyerIcons-iPhone4" owner:self options:nil];
                mainView = [subviewArray objectAtIndex:0];
                [layerScrollView addSubview:mainView];
                
                [layerScrollView setContentSize:CGSizeMake(mainView.frame.size.width, [layerScrollView bounds].size.height)];
            }
            
            mainView = [subviewArray objectAtIndex:0];
            NSArray *flyerIconArray = mainView.subviews;
            
            //Getting Last Image Tag for highlight
            NSString *LastTag = [flyer getImageTag:currentLayer];
            
            for(int i=1;i<=94;i++) {        

                //Here we Hightlight Last Selected Image
                if (![LastTag isEqualToString:@""]) {
                    
                    
                    if ([LastTag intValue] == i ) {
                        
                        // Add border to selected layer thumbnail
                        UIButton *iconButton = flyerIconArray[i-1];
                        [iconButton.layer setCornerRadius:8];
                        [iconButton.layer setBorderWidth:3.0];
                        UIColor * c = [UIColor colorWithRed:1/255.0 green:151/255.0 blue:221/255.0 alpha:1];
                        [iconButton.layer setBorderColor:c.CGColor];
                    }
                }
                      
            }//loop
        
    });
    
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
        _addMoreLayerOrSaveFlyerLabel.alpha = 1;
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

#pragma mark -  Select Layer On ScrollView

/*
 * When any font is selected
 */
-(IBAction)selectFont:(id)sender
{
	int  i=1;
	UIButton *view = sender;
    
	for(UIView *tempView  in [mainView subviews])
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
                
                UIColor * c = [UIColor colorWithRed:1/255.0 green:151/255.0 blue:221/255.0 alpha:1];
                [l setBorderColor:c.CGColor];
            }
            i++;
        }// uiImageView Found
        
	}// Loop
}

/*
 * When any color is selected
 */
-(IBAction)selectColor:(id)sender
{
    
	int  i=1;
	UIButton *view = sender;
    
	for(UIView *tempView  in [mainView subviews])
	{

        //CHECK UIIMAGEVIEW BECAUSE SCROLL VIEW HAVE ADDITIONAL
        //SUBVIEWS OF UIIMAGEVIEW FOR FLASH INDICATORS
        if (![tempView isKindOfClass:[UIImageView class]]) {
            
            // Add border to Un-select layer thumbnail
            CALayer * l = [tempView layer];
            [l setBorderWidth:1];
            [l setCornerRadius:0];
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
                [l setCornerRadius:8];
                UIColor * c = [UIColor colorWithRed:1/255.0 green:151/255.0 blue:221/255.0 alpha:1];
                [l setBorderColor:c.CGColor];
            }
            
            i++;
        }//UIIMAGEVIEW CHECK
        
	}// LOOP
}

/*
 * When any size is selected
 */
-(IBAction)selectSize:(id)sender{

    
	int  i=1;
	UIButton *view = sender;
    
	for(UIView *tempView  in [mainView subviews])
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
                NSString *flyerImg = [flyer getImageName:currentLayer];
                
                if ( flyerImg == nil ) {
                    
                    NSString *sizeStr = SIZE_ARRAY[i-1];
                    selectedSize = [sizeStr intValue];
                    selectedFont = [selectedFont fontWithSize:selectedSize];
                
                    [flyer setFlyerTextSize:currentLayer Size:selectedFont];
                
                    //Here we call Render Layer on View
                    [flyimgView renderLayer:currentLayer layerDictionary:[flyer getLayerFromMaster:currentLayer]];
                
                    // Add border to selected layer thumbnail
                    CALayer * l = [tempView layer];
                    [l setBorderWidth:3.0];
                    UIColor * c = [UIColor colorWithRed:1/255.0 green:151/255.0 blue:221/255.0 alpha:1];
                    [l setBorderColor:c.CGColor];
                }else {
                    
                    NSString *sizeStr = SIZE_ARRAY[i-1];
                    
                    CGRect lastFrame = [flyer getImageFrame:currentLayer];
                    
                    CGRect imageFrame  = CGRectMake(lastFrame.origin.x,lastFrame.origin.y,[sizeStr floatValue],[sizeStr floatValue]);
                    [flyer setImageFrame:currentLayer :imageFrame];
                    NSMutableDictionary *dic = [flyer getLayerFromMaster:currentLayer];
                    [self.flyimgView renderLayer:currentLayer layerDictionary:dic];
            
                    //Here we call Render Layer on View
                    [flyimgView renderLayer:currentLayer layerDictionary:[flyer getLayerFromMaster:currentLayer]];
                    
                    // Add border to selected layer thumbnail
                    CALayer * l = [tempView layer];
                    [l setBorderWidth:3.0];
                    UIColor * c = [UIColor colorWithRed:1/255.0 green:151/255.0 blue:221/255.0 alpha:1];
                    [l setBorderColor:c.CGColor];
                
                }
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
    for(UIView *tempView  in [mainView subviews])
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
            UIColor * c = [UIColor colorWithRed:1/255.0 green:151/255.0 blue:221/255.0 alpha:1];
            [l setBorderColor:c.CGColor];
        }
    }
    
    [Flurry logEvent:@"Background Selected"];
}

/*
 * Called when select a symbol
 */
-(IBAction)selectSymbol:(id)sender
{
    
    UIButton *view = sender;
    [Flurry logEvent:@"Layer Added"];
    
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
    for(UIView *tempView  in [mainView subviews])
    {
        // Add border to Un-select layer thumbnail
        CALayer * l = [tempView layer];
        [l setBorderWidth:3.0];
        [l setCornerRadius:8];
        UIColor * c = [UIColor clearColor];
        [l setBorderColor:c.CGColor];
        
        if(tempView == view)
        {
            // Add border to selected layer thumbnail
            CALayer * l = [tempView layer];
            [l setBorderWidth:3.0];
            UIColor * c = [UIColor colorWithRed:1/255.0 green:151/255.0 blue:221/255.0 alpha:1];
            [l setBorderColor:c.CGColor];
        }
    }
}

/*
 * Called when select emoticon
 */
-(IBAction)selectEmoticon:(id)sender {
    
    
    UIButton *view = sender;
    
    [Flurry logEvent:@"Emoticon Added"];
    
    int lstTag = 500;
    NSString *lastTag = [flyer getImageTag:currentLayer];
    
    if (![lastTag isEqualToString:@""]) lstTag = [lastTag intValue];
    
    if (lstTag != view.tag) {
        
        NSString *imgPath = [self getImagePathByTag:[NSString stringWithFormat:@"emoticon%d@2x",view.tag]];
        
        //Set Symbol Image
        [flyer setImagePath:currentLayer ImgPath:imgPath];
        
        //Set Image Tag
        [flyer setImageTag:currentLayer Tag:[NSString stringWithFormat:@"%d",view.tag]];
        
        [self.flyimgView renderLayer:currentLayer layerDictionary:[flyer getLayerFromMaster:currentLayer]];
        
        //Here we Highlight The ImageView
        [self.flyimgView layerIsBeingEdited:currentLayer];
    }
    
    
    //Handling Select Unselect
    for(UIView *tempView  in [mainView subviews])
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
            UIColor * c = [UIColor colorWithRed:1/255.0 green:151/255.0 blue:221/255.0 alpha:1];
            [l setBorderColor:c.CGColor];
        }
    }
}
/*
 * Called when select icon
 */
-(IBAction)selectIcon:(id)sender
{
    
    [Flurry logEvent:@"Clip Art Added"];
    
    int  i=1;
	UIButton *view = sender;
    
    int  index = [[mainView subviews] indexOfObject:view];
    // Find out the path of Cliparts.plist
    NSString *clipartsPlistPath = [[NSBundle mainBundle] pathForResource:@"Cliparts" ofType:@"plist"];
    NSArray *cliparts = [[NSArray alloc] initWithContentsOfFile:clipartsPlistPath];
    
    UIFont *fontType = [UIFont fontWithName:[cliparts[i] objectForKey:@"fontType"] size:64.0f];
    
	for(UIView *tempView  in [mainView subviews])
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
                
                [self.flyimgView addSubview:lastTextView];
                
                //Set Text of Layer
                [flyer setFlyerText:currentLayer text:view.currentTitle ];
                
                selectedFont = fontType;
                
                [flyer setFlyerTextFont:currentLayer FontName:[cliparts[index] objectForKey:@"fontType"]];
                
                [flyer setFlyerTextSize:currentLayer Size:selectedFont];
                
                //Here we call Render Layer on View
                [flyimgView renderLayer:currentLayer layerDictionary:[flyer getLayerFromMaster:currentLayer]];
                
                // Add border to selected layer thumbnail
                CALayer * l = [tempView layer];
                [l setBorderWidth:3.0];
                UIColor * c = [UIColor colorWithRed:1/255.0 green:151/255.0 blue:221/255.0 alpha:1];
                [l setBorderColor:c.CGColor];
            }
            i++;
        }// uiImageView Found
        
	}// Loop
    
}

/*
 * When any font border is selected
 */
-(IBAction)selectFontBorder:(id)sender
{
    NSArray *bodersArray = mainView.subviews;
    int count = (bodersArray.count);
    
    UIView *tempView;
    
    int  i=1;
	UIButton *view = sender;
    
	for (int index = 0; index < count; index++ )
    {
        tempView  = [bodersArray objectAtIndex:index];
        
        if ( (index % 3) == 0)
        {
            tempView  = [bodersArray objectAtIndex:index];
            
            // Add border to Un-select layer thumbnail
            CALayer * l = [tempView layer];
            [l setBorderWidth:1];
            [l setCornerRadius:0];
            UIColor * c = [UIColor clearColor];
            [l setBorderColor:c.CGColor];
            i++;
            
        }
        
        if(tempView == view)
        {
            UIColor *borderColor = borderArray[i-2];
            [flyer setFlyerTextBorderColor:currentLayer Color:borderColor ];
            //Here we call Render Layer on View
            [flyimgView renderLayer:currentLayer layerDictionary:[flyer getLayerFromMaster:currentLayer]];
            
            // Add border to selected layer thumbnail
            tempView = [bodersArray objectAtIndex:(index-2)];
            CALayer * l = [tempView layer];
            [l setBorderWidth:5.0];
            [l setCornerRadius:8];
            UIColor * c = [UIColor colorWithRed:1/255.0 green:151/255.0 blue:221/255.0 alpha:1];
            [l setBorderColor:c.CGColor];
        }
        
	}//LOOP
}


/*
 * When any Flyer border is selected
 */
-(void)selectBorder:(id)sender
{
    
    NSArray *bodersArray = mainView.subviews;
    int count = (bodersArray.count);
    
    UIView *tempView;
    
    int  i=1;
	UIButton *view = sender;
    
	for (int index = 0; index < count; index++ )
    {
        tempView  = [bodersArray objectAtIndex:index];
        
        if ( (index % 3) == 0)
        {
            tempView  = [bodersArray objectAtIndex:index];
            
            // Add border to Un-select layer thumbnail
            CALayer * l = [tempView layer];
            [l setBorderWidth:1];
            [l setCornerRadius:0];
            UIColor * c = [UIColor clearColor];
            [l setBorderColor:c.CGColor];
            i++;
            
        }
        
        if(tempView == view)
        {
            UIColor *borderColor = borderArray[i-2];
            currentLayer = @"Template";
            [flyer setFlyerBorder:currentLayer RGBColor:borderColor];
            
            //Here we call Render Layer on View
            [flyimgView setTemplateBorder:[flyer getLayerFromMaster:currentLayer]];
            
            // Add border to selected layer thumbnail
            tempView = [bodersArray objectAtIndex:(index-2)];
            CALayer * l = [tempView layer];
            [l setBorderWidth:5.0];
            [l setCornerRadius:8];
            UIColor * c = [UIColor colorWithRed:1/255.0 green:151/255.0 blue:221/255.0 alpha:1];
            [l setBorderColor:c.CGColor];
        }
        
	}//LOOP
}

/*
 * When any layer is selected while editing flyer
 * its Also Call editLayer Method
 */
-(void)selectLayer:(id)sender {
    
    [self deSelectPreviousLayer];
    
    [self renderFlyer];
    
    UIView *sView = editButtonGlobal;
    
    NSString *tag = [NSString stringWithFormat:@"%d",sView.tag];
    NSLog(@"%@",tag);
    
}


#pragma mark -  Progress Indicator

-(void)showLoadingView:(NSString *)message{
    [self showLoadingIndicator];
}

-(void)removeLoadingView{
    [self hideLoadingIndicator];
}

#pragma mark -  NBUKIT

/*
 * Here we Load Gallery
 */
-(void)loadCustomPhotoLibrary :(BOOL)videoAllow {

    uiBusy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [uiBusy setFrame:CGRectMake(280, 5, 20, 20)];
    [uiBusy setColor:[UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0]];
    uiBusy.hidesWhenStopped = YES;
    [uiBusy startAnimating];
    
    [self.flyimgView addSubview:uiBusy];
    
    LibraryViewController *nbuGallary = [[LibraryViewController alloc] initWithNibName:@"LibraryViewController" bundle:nil];
    
    nbuGallary.videoAllow = videoAllow;
    
    if ( imgPickerFlag == 2 ) {
        NSDictionary *dict = [flyer getLayerFromMaster:currentLayer];
        nbuGallary.desiredImageSize = CGSizeMake( [[dict valueForKey:@"width"] floatValue],
                                                [[dict valueForKey:@"height"] floatValue]);
    } else {
        nbuGallary.desiredImageSize = CGSizeMake( flyerlyWidth,  flyerlyHeight );
    }
    
    __weak CreateFlyerController *weakSelf = self;

    [nbuGallary setOnImageTaken:^(UIImage *img) {
        
        [uiBusy stopAnimating];
        [uiBusy removeFromSuperview];
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
                
                
                //Render Flyer
                //[self renderFlyer];
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
    
    
    [nbuGallary setOnVideoFinished:^(NSURL *recvUrl, CGRect cropRect, CGFloat scale ) {
        
        [uiBusy stopAnimating];
        [uiBusy removeFromSuperview];

        NSLog(@"%@",recvUrl);
        NSError *error = nil;
        
        [weakSelf.flyer setFlyerTypeVideo];
        
        // HERE WE MOVE SOURCE FILE INTO FLYER FOLDER
        NSString* currentpath  =   [[NSFileManager defaultManager] currentDirectoryPath];
        NSString *destination = [NSString stringWithFormat:@"%@/Template/template.mov",currentpath];
        [weakSelf.flyer setOriginalVideoUrl:@"Template/template.mov"];
        
        NSURL *movieURL = [NSURL fileURLWithPath:destination];
        
        
        //HERE WE MAKE SURE FILE ALREADY EXISTS THEN DELETE IT OTHERWISE IGNORE
        if ([[NSFileManager defaultManager] fileExistsAtPath:destination isDirectory:NULL]) {
            [[NSFileManager defaultManager] removeItemAtPath:destination error:&error];
        }
        
        // Make sure the video is scaled and cropped as required.
        [weakSelf modifyVideo:recvUrl destination:movieURL crop:cropRect scale:scale overlay:nil completion:^(NSInteger status, NSError *error) {
            switch ( status ) {
                case AVAssetExportSessionStatusFailed:
                    NSLog (@"FAIL = %@", error );
                    break;
                    
                case AVAssetExportSessionStatusCompleted:
                    
                    // Main Thread
                    dispatch_async( dispatch_get_main_queue(), ^{
                        
                        // Render the movie player.
                        [weakSelf.flyimgView renderLayer:@"Template" layerDictionary:[self.flyer getLayerFromMaster:@"Template"]];
                        
                    });
                    break;
            }
        }];
    }];
    
    [nbuGallary setOnVideoCancel:^() {
        
        [self.view addSubview:flyimgView];
        [uiBusy stopAnimating];
        [uiBusy removeFromSuperview];
        
    }];
    
    [self.navigationController pushViewController:nbuGallary animated:YES];
    [Flurry logEvent:@"Custom Background"];
}


#pragma mark - Add Video
/*
 * Here we Overload Open Camera for Video
 */
-(void)openCustomCamera:(BOOL)forVideo {
    
    uiBusy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [uiBusy setFrame:CGRectMake(280, 5, 20, 20)];
    [uiBusy setColor:[UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0]];
    uiBusy.hidesWhenStopped = YES;
    [uiBusy startAnimating];
    [self.view addSubview:uiBusy];
    
    nbuCamera = [[CameraViewController alloc]initWithNibName:@"CameraViewController" bundle:nil];
    
    nbuCamera.videoAllow = forVideo;
    
    if ( imgPickerFlag == 2 ) {
        NSDictionary *dict = [flyer getLayerFromMaster:currentLayer];
        nbuCamera.desiredImageSize = CGSizeMake( [[dict valueForKey:@"width"] floatValue],
                                                 [[dict valueForKey:@"height"] floatValue]);
    } else {
        nbuCamera.desiredImageSize = CGSizeMake( flyerlyWidth,  flyerlyHeight );
    }
    
    __weak CreateFlyerController *weakSelf = self;
    
    // Callback once image is selected.
    [nbuCamera setOnImageTaken:^(UIImage *img) {
        
        [uiBusy stopAnimating];
        [uiBusy removeFromSuperview];
        dispatch_async( dispatch_get_main_queue(), ^{

            if ( imgPickerFlag == 2 ) {
                NSString *imgPath = [weakSelf getImagePathforPhoto:img];
                
                // Set Image to dictionary
                [weakSelf.flyer setImagePath:weakSelf.currentLayer ImgPath:imgPath];
                
                // Here we Create ImageView Layer
                [weakSelf.flyimgView renderLayer:weakSelf.currentLayer layerDictionary:[weakSelf.flyer getLayerFromMaster:weakSelf.currentLayer]];
                
                [weakSelf.flyimgView layerStoppedEditing:weakSelf.currentLayer];
                
                weakSelf.imgPickerFlag = 1;
                
            } else {
            
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

    // Call back for when video is selected.
    [nbuCamera setOnVideoFinished:^(NSURL *recvUrl, CGRect cropRect, CGFloat scale ) {
        
        [uiBusy stopAnimating];
        [uiBusy removeFromSuperview];

        NSError *error = nil;
        
        [weakSelf.view addSubview:flyimgView];
        [weakSelf.flyer setFlyerTypeVideo];
        
        // Move video in to the sour flyer.
        NSString* currentpath  =   [[NSFileManager defaultManager] currentDirectoryPath];

        NSString *destination = [NSString stringWithFormat:@"%@/Template/template.mov",currentpath];
        [weakSelf.flyer setOriginalVideoUrl:@"Template/template.mov"];
        
        NSURL *movieURL = [NSURL fileURLWithPath:destination];

        // Make sure the video does not exist already. If it does, delete it.
        if ([[NSFileManager defaultManager] fileExistsAtPath:destination isDirectory:NULL]) {
            [[NSFileManager defaultManager] removeItemAtPath:destination error:&error];
        }
        
        // Make sure the video is scaled and cropped as required.
        [weakSelf modifyVideo:recvUrl destination:movieURL crop:cropRect scale:scale overlay:nil completion:^(NSInteger status, NSError *error) {
            switch ( status ) {
                case AVAssetExportSessionStatusFailed:
                    NSLog (@"FAIL = %@", error );
                    break;
                
                case AVAssetExportSessionStatusCompleted:
                    
                    // Main Thread
                    dispatch_async( dispatch_get_main_queue(), ^{
                            
                        // Render the movie player.
                        [weakSelf.flyimgView renderLayer:@"Template" layerDictionary:[self.flyer getLayerFromMaster:@"Template"]];
                            
                    });
                    break;
            }
        }];
        
      }];
    
    [nbuCamera setOnVideoCancel:^() {
        dispatch_async( dispatch_get_main_queue(), ^{
            [weakSelf.view addSubview:flyimgView];
            [uiBusy stopAnimating];
            [uiBusy removeFromSuperview];
        });
    }];
    
    if ( [[weakSelf.flyer getFlyerTypeVideo]isEqualToString:@"video"] ){
        
        nbuCamera.isVideoFlyer = YES;
    }
    [self.navigationController pushViewController:nbuCamera animated:YES];
    
}

#pragma mark -  Movie Player

/*
 * Here we Configure Player and Load File in Player
 */
-(void)loadPlayerWithURL :(NSURL *)movieURL {
    
    if ( player != nil ) {
        [player.view removeFromSuperview];
    }
    
    NSLog(@"Video URL = %@",movieURL);
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

    self.flyimgView.image = nil;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [player.view  addGestureRecognizer:tap];
    tap.delegate = self;
    [self.playerView addSubview:player.view];
 

    [playerToolBar setFrame:CGRectMake(0, self.playerView.frame.size.height - 40, 306, 40)];
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


#pragma mark -  Movie Player Delegate


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


#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView == deleteAlert && buttonIndex == 1) {
        
        editButtonGlobal.uid = currentLayer;
        [self deleteLayer:editButtonGlobal overrided:nil];
        [Flurry logEvent:@"Layer Deleted"];
        
	}else if(alertView == signInAlert && buttonIndex == 0) {
        
        // Enable  Buttons
        rightUndoBarButton.enabled = YES;
        shareButton.enabled = YES;
        helpButton.enabled = YES;
        
        [self hideLoadingIndicator];        
        
    }else if(alertView == signInAlert && buttonIndex == 1) {
        
        NSLog(@"Sign In was selected.");
        signInController = [[SigninController alloc]initWithNibName:@"SigninController" bundle:nil];
        
        FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
        signInController.launchController = appDelegate.lauchController;
        
        __weak CreateFlyerController *weakSelf = self;
        //__weak CreateFlyerController *weakCreateFlyerController = signInController;
        
        signInController.signInCompletion = ^void(void) {
            NSLog(@"Sign In via Share");
            
            UINavigationController* navigationController = weakSelf.navigationController;
            [navigationController popViewControllerAnimated:NO];
            //[navigationController popViewController:weakSigninController];
            //[navigationController popToViewController:weakSelf animated:YES];
            
            [weakSelf openPanel];
            //[shareButton sendActionsForControlEvents: UIControlEventTouchUpInside];
            //=======
            /*
            //UINavigationController* navigationController = weakSigninController.navigationController;
            UINavigationController* navigationController = weakSelf.navigationController;
            [navigationController popViewControllerAnimated:NO];
            [weakSignInController.navigationController popViewController:weakSignInController];

            //Render Flyer
            [weakSelf renderFlyer];
            
            //[shareButton sendActionsForControlEvents: UIControlEventTouchUpInside];
            [weakSelf openPanel];
             */
            //>>>>>>> tempBranch
            
        };
        
        [self.navigationController pushViewController:signInController animated:YES];
        
    }

  }


#pragma mark - Custom Methods

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
    UIButton *delButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
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
    UIButton *delButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
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

    // SET BOTTOM BAR
    [self setStyleTabAction:fontTabButton];

	[lastTextView resignFirstResponder];
	[lastTextView removeFromSuperview];
    lastTextView = nil;
}

-(void) donePhoto{
    
    [self deSelectPreviousLayer];
    [self callAddMoreLayers];
    [self logPhotoAddedEvent];
    
}

-(void)deSelectPreviousLayer {
    // Remove Border if Any Layer Selected check the entire layers in a flyer
    for ( NSString* key in self.flyimgView.layers ) {
        [self.flyimgView layerStoppedEditing:key];
        NSLog(@ "%@",self.flyimgView.layer);
        NSLog(@ "%@",key);
        
        //Delete Empty Layer if Exist
        if (key != nil && ![key isEqualToString:@""]) {
            
            NSString *flyerImg = [flyer getImageName:key];
            NSString *flyertext = [flyer getText:key];
            
            if ([flyerImg isEqualToString:@""]) {
                [flyer deleteLayer:key];
            }
            
            if ([flyertext isEqualToString:@""]) {
                [flyer deleteLayer:key];
            }
        }
        
    }

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
    UIButton *delButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
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
        
        if ([child isKindOfClass:[LayerTileButton class]] || [child isKindOfClass:[UIButton class]] || [child isKindOfClass:[UILabel class]] || [child isKindOfClass:[UIView class]] ) {
            [child removeFromSuperview];
        }
        
    }
    
    // Hide the labels.
    _addMoreLayerOrSaveFlyerLabel.alpha = 0;
    _takeOrAddPhotoLabel.alpha = 0;
    _videoLabel.alpha = 0;
}

/*
 * Here we Getting Snap Shot of Flyer Image View Context
 * Return
 *  Image
 */
-(UIImage *)getFlyerSnapShot {
    
    //Here we take Snap shot of Flyer
    UIGraphicsBeginImageContextWithOptions( self.flyimgView.frame.size, NO, 0);
    
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
    
//    // Remove all Subviews inside image view
//    NSArray *viewsToRemove = [self.flyimgView subviews];
//    for (UIView *v in viewsToRemove) {
//        [v removeFromSuperview];
//    }
    
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

# pragma mark - Video editing

/**
 * Export video to given destination, from given source, cropped and scaled to specified
 * rect with the given overlay.
 */
- (void)modifyVideo:(NSURL *)src destination:(NSURL *)dest crop:(CGRect)crop
              scale:(CGFloat)scale overlay:(UIImage *)image
         completion:(void (^)(NSInteger, NSError *))callback {
    
    // Get a pointer to the asset
    AVURLAsset* firstAsset = [AVURLAsset URLAssetWithURL:src options:nil];
    
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
    
    NSLog(@"Natural size: %.2f x %.2f", videoTrack.naturalSize.width, videoTrack.naturalSize.height);
    
    // Set the mix composition size.
    mixComposition.naturalSize = crop.size;
    
    // Set up the composition parameters.
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.frameDuration = CMTimeMake(1, VIDEOFRAME );
    videoComposition.renderSize = crop.size;
    videoComposition.renderScale = 1.0;
    
    // Pass through parameters for animation.
    AVMutableVideoCompositionInstruction *passThroughInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    passThroughInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, inTime);
    
    // Layer instructions
    AVMutableVideoCompositionLayerInstruction *passThroughLayer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    
    // Set the transform to maintain orientation
    if ( scale != 1.0 ) {
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale( scale, scale);
        CGAffineTransform translateTransform = CGAffineTransformTranslate( CGAffineTransformIdentity,
                                                                          -crop.origin.x,
                                                                          -crop.origin.y);
        transform = CGAffineTransformConcat( transform, scaleTransform );
        transform = CGAffineTransformConcat( transform, translateTransform);
    }
    
    [passThroughLayer setTransform:transform atTime:kCMTimeZero];
    
    passThroughInstruction.layerInstructions = @[ passThroughLayer ];
    videoComposition.instructions = @[passThroughInstruction];
    
    // If an image is given, then put that in the animation.
    if ( image != nil ) {
    
        // Layer that merges the video and image
        CALayer *parentLayer = [CALayer layer];
        parentLayer.frame = CGRectMake( 0, 0, crop.size.width, crop.size.height);
    
        // Layer that renders the video.
        CALayer *videoLayer = [CALayer layer];
        videoLayer.frame = CGRectMake(0, 0, crop.size.width, crop.size.height );
        [parentLayer addSublayer:videoLayer];
    
        // Layer that renders flyerly image.
        CALayer *imageLayer = [CALayer layer];
        imageLayer.frame = CGRectMake(0, 0, crop.size.width, crop.size.height );
        imageLayer.contents = (id)image.CGImage;
        [imageLayer setMasksToBounds:YES];
        
        [parentLayer addSublayer:imageLayer];
    
        // Setup the animation tool
        videoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    }
    
    // Now export the movie
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    exportSession.videoComposition = videoComposition;
    
    // Export the URL
    exportSession.outputURL = dest;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    exportSession.shouldOptimizeForNetworkUse = YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        callback( exportSession.status, exportSession.error );
    }];
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
    
    // HERE WE ARE MERGE OVER CREATED VIDEO AND USER SELECTED OR MAKE
    [self mergeVideoWithOverlay:url image:image];
}


/*
 * HERE WE MERGE TWO VIDEOS FOR SHARE VIDEO
 */
-(void)mergeVideoWithOverlay:(NSURL *)firstURL image:(UIImage *)image {
    
    // Export path
    NSString *destination = [self.flyer getSharingVideoPath];
    
    // Delete Old File if they exist
    NSError *error = nil;
    if ( [[NSFileManager defaultManager] isReadableFileAtPath:destination] ) {
        [[NSFileManager defaultManager] removeItemAtPath:destination error:&error];
    }
    
    // Export the URL
    NSURL *exportURL = [NSURL fileURLWithPath:destination];
    
    [self modifyVideo:firstURL destination:exportURL crop:CGRectMake(0, 0, flyerlyWidth, flyerlyHeight ) scale:1 overlay:image completion:^(NSInteger status, NSError *error) {
        switch ( status ) {
            case AVAssetExportSessionStatusFailed:{
                NSLog (@"FAIL = %@", error );
                break;
            }
            case AVAssetExportSessionStatusCompleted: {
                
                
                //Here we take Image From Video Player
                UIImage *videoCover = [self.flyer getImageForVideo];
                [self.flyer setVideoCover:videoCover];
                
                NSLog(@"Video Merge Process Completed");
                
                if (panelWillOpen) {
                    
                    // Main Thread
                    dispatch_async( dispatch_get_main_queue(), ^{
                        
                        //Here we Open Share Panel for Share Flyer
                        [self openPanel];
                        
                    });
                }else {
                    
                    // Main Thread
                    dispatch_async( dispatch_get_main_queue(), ^{
                        
                        //Here we Open Share Panel for Share Flyer
                        self.onFlyerBack(@"");
                        
                    });
                    
                }
                
                // Here we Add Video In Flyerly Album
                [self.flyer addToGallery:nil];
            }
        };
    }];
}


#pragma mark - Flyer Modified

/**
 * Edit the current layer.
 */
- (void)editCurrentLayer {
    
    [self renderFlyer];
    
    [self deSelectPreviousLayer];
    
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
            //[self setAddMoreLayerTabAction:addMoreIconTabButton];
        }
        
        //when we tap on icon
        if ([imgName rangeOfString:@"Icon"].location == NSNotFound) {
            NSLog(@"sub string doesnt exist");
        } else {
            
            // Call Symbol
            [self setAddMoreLayerTabAction:addArtsTabButton];
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
    
    //Here we remove Borders from layer if user touch any layer
    [self.flyimgView layerStoppedEditing:currentLayer];
    
    //Here we take Snap shot of Flyer and
    //Flyer Add to Gallery if user allow to Access there photos
    [flyer setUpdatedSnapshotWithImage:[self getFlyerSnapShot]];
    
    //First we Save Current flyer in history
    [flyer saveFlyer];
    
    //Add Flyer in History if any Change Exists
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
    
    //Save OnBack
    //Here we remove Borders from layer if user touch any layer
    [self.flyimgView layerStoppedEditing:currentLayer];
    
    //Here we Save Flyer
    [flyer saveFlyer];
    
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



#pragma mark -  Share Flyer


/*
 * HERE WE SHARE FLYER TO SOCIAL NETWORKS
 */
-(void)share {
    
    // Disable  Buttons
    rightUndoBarButton.enabled = NO;
    shareButton.enabled = NO;
    helpButton.enabled = NO;

    [self showLoadingIndicator];
    
    //Here we Merge Video for Sharing
    if ([flyer isVideoFlyer]) {
        
        //Here Compare Current Flyer with history Flyer
        if ([self.flyer isVideoMergeProcessRequired]) {
            
            panelWillOpen = YES;

            //Background Thread
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                
                //Here we Merge All Layers in Video File
                [self videoMergeProcess];
                
            });
        }else {
            
            //Here we Open Share Panel for Share Flyer
            [self openPanel];
        }
    }else {
        
        //Background Thread
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            
            //Here we remove Borders from layer if user touch any layer
            [self.flyimgView layerStoppedEditing:currentLayer];
            
            //Here we take Snap shot of Flyer and
            //Flyer Add to Gallery if user allow to Access there photos
            [flyer setUpdatedSnapshotWithImage:[self getFlyerSnapShot]];
            
            dispatch_async( dispatch_get_main_queue(), ^{
                //Here we Open Share Panel for Share Flyer
                [self openPanel];
            });
            
        });
        
    }
    
}

/*
 * Here we Open InAppPurchase Panel
 */
-(void)openInAppPanel {
    
    if(IS_IPHONE_5){
        inappviewcontroller = [[InAppViewController alloc] initWithNibName:@"InAppViewController" bundle:nil];
    }else {
        inappviewcontroller = [[InAppViewController alloc] initWithNibName:@"InAppViewController-iPhone4" bundle:nil];
    }
    [self presentModalViewController:inappviewcontroller animated:YES];
    if ( productArray.count == 0 ){
        [inappviewcontroller requestProduct];
    }
    if( productArray.count != 0 ) {
        
        //[inappviewcontroller.contentLoaderIndicatorView stopAnimating];
        //inappviewcontroller.contentLoaderIndicatorView.hidden = YES;
    }
    
    inappviewcontroller.buttondelegate = self;
    
}


/*
 * Here we Open Share Panel
 */
-(void)openPanel {
    
    if ( [[PFUser currentUser] sessionToken] ) {
        sharePanel.hidden = NO;
        [sharePanel removeFromSuperview];
        
        if ([flyer isVideoFlyer]) {
            shareviewcontroller = [[ShareViewController alloc] initWithNibName:@"ShareVideoViewController" bundle:nil];
            
        } else {
            shareviewcontroller = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
        }
        sharePanel = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.origin.y, 320,400 )];
        
        sharePanel = shareviewcontroller.view;
        [self.view addSubview:sharePanel];
        
        sharePanel = shareviewcontroller.view;
        NSString *shareImagePath = [flyer getFlyerImage];
        UIImage *shareImage =  [UIImage imageWithContentsOfFile:shareImagePath];
        
        //Here we Pass Param to Share Screen Which use for Sharing
        [shareviewcontroller.titleView becomeFirstResponder];
        shareviewcontroller.selectedFlyerImage = shareImage;
        shareviewcontroller.flyer = self.flyer;
        shareviewcontroller.imageFileName = shareImagePath;
        shareviewcontroller.rightUndoBarButton = rightUndoBarButton;
        shareviewcontroller.shareButton = shareButton;
        shareviewcontroller.helpButton = helpButton;
        if( [shareviewcontroller.titleView.text isEqualToString:@"Flyer"] ) {
            shareviewcontroller.titleView.text = [flyer getFlyerTitle];
        }
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
        
        [self hideLoadingIndicator];
        
    } else {
        // Alert when user logged in as anonymous
        signInAlert = [[UIAlertView alloc] initWithTitle:@"Sign In"
                                                 message:@"The selected feature requires that you sign in. Would you like to register or sign in now?"
                                                delegate:self
                                       cancelButtonTitle:@"Later"
                                       otherButtonTitles:@"Sign In",nil];
        
        
        [signInAlert show];
    }

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

/*
 * When we click on Arts Tab
 * This Method Manage Arts SubTabs
 */
-(IBAction)setArtsTabAction:(id) sender
{

    [self addBottomTabs:libArts];
    [clipArtTabButton setSelected:NO];
    [emoticonsTabButton setSelected:NO];
    [artsColorTabButton setSelected:NO];
    [artsSizeTabButton setSelected:NO];
    UIButton *selectedButton = (UIButton*)sender;
    if(selectedButton == clipArtTabButton)
	{
        
        //HERE WE SET ANIMATION
        [UIView animateWithDuration:0.4f
                         animations:^{
                             //Create ScrollView
                             [self addClipArtsInSubView];
                         }
                         completion:^(BOOL finished){
                             [layerScrollView flashScrollIndicators];
                         }];
        //END ANIMATION
        
        //Add ContextView
        [self addScrollView:layerScrollView];
        
		[clipArtTabButton setSelected:YES];
	}
    else if(selectedButton == emoticonsTabButton)
	{
        
        //HERE WE SET ANIMATION
        [UIView animateWithDuration:0.4f
                         animations:^{
                             //Create ScrollView
                             [self addEmoticonsInSubView];
                         }
                         completion:^(BOOL finished){
                             [layerScrollView flashScrollIndicators];
                         }];
        //END ANIMATION
        
        //Add ContextView
        [self addScrollView:layerScrollView];
        
		[emoticonsTabButton setSelected:YES];
	}
    else if(selectedButton == artsColorTabButton)
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
        [artsColorTabButton setSelected:YES];
	}
    else if(selectedButton == artsSizeTabButton)
	{
        
        //HERE WE SET ANIMATION
        [UIView animateWithDuration:0.4f
                         animations:^{
                             //Create ScrollView
                             // [self addArtsSizesInSubView];
                             [self addSizeInSubView];
                         }
                         completion:^(BOOL finished){
                             [layerScrollView flashScrollIndicators];
                         }];
        //END ANIMATION
        
        //Add ContextView
        [self addScrollView:layerScrollView];
        
		[artsSizeTabButton setSelected:YES];
	}
    
    
}

#pragma mark -  Bottom Tabs Context
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
        _videoLabel.alpha = 1;

    }
    else if(selectedButton == cameraRoll)
    {

        //HERE WE CHECK USER DID ALLOWED TO ACCESS PHOTO library
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusRestricted || [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
            
            UIAlertView *photoAlert = [[UIAlertView alloc ] initWithTitle:@"" message:@"Flyerly does not access to your photo album.To enable access goto the Setting app >> Privacy >> Photos and enable Flyerly" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [photoAlert show];
            return;
            
        }
        
        [self loadCustomPhotoLibrary:YES];
        
        //Add ContextView
        _videoLabel.alpha = 1;

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
        [self openCustomCamera:NO];

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
        
        [self loadCustomPhotoLibrary:NO];
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
    [addArtsTabButton setSelected:NO];
    [addVideoTabButton setSelected:NO];
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
        _takeOrAddPhotoLabel.alpha = 1;
	    
        [self choosePhoto];
		imgPickerFlag = 2;
        [addMorePhotoTabButton setSelected:YES];
        

	}
	else if(selectedButton == addArtsTabButton)
	{
        selectedAddMoreLayerTab = ADD_MORE_SYMBOLTAB;
        
        if ([currentLayer isEqualToString:@""]) {
            
            //currentLayer = [flyer addImage];
            currentLayer = [flyer addText];
            editButtonGlobal.uid = currentLayer;
            
            
            CGRect imageFrame  = CGRectMake(0,0,64,64);
            [flyer setImageFrame:currentLayer :imageFrame];
            NSMutableDictionary *dic = [flyer getLayerFromMaster:currentLayer];
            [self.flyimgView renderLayer:currentLayer layerDictionary:dic];
        }
        
        [addArtsTabButton setSelected:YES];
        
        [self addDonetoRightBarBotton];
        
        //HERE WE SET ANIMATION
        [UIView animateWithDuration:0.4f
                         animations:^{
                             //Create ScrollView
                             //[self addFlyerIconInSubView];
                         }
                         completion:^(BOOL finished){
                             [layerScrollView flashScrollIndicators];
                         }];
        

        
        [clipArtTabButton setSelected:YES];
        //Add right Bar button
        [self addDonetoRightBarBotton];
        
        // SET BOTTOM BAR
        [self setArtsTabAction:clipArtTabButton];
        //[self setlibBackgroundTabAction:backtemplates];
        
        //Add Context
        [self addScrollView:layerScrollView];
        
        
        //Add ContextView
        [self addBottomTabs:libArts];
        
	}
	else if(selectedButton == addVideoTabButton)
	{
        FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
        UserPurchases *userPurchases_ = appDelegate.userPurchases;
    
        if ([[PFUser currentUser] sessionToken].length != 0) {
            if ( [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyAllDesignBundle"] ||
                 [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyUnlockCreateVideoFlyerOption"] ) {
                
                [self openCustomCamera:YES];
                _videoLabel.alpha = 1;
                nbuCamera.isVideoFlyer = YES;
            }else {
                [self openInAppPanel];
            }
            
        }else {
            [self openInAppPanel];
        }
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



#pragma mark - Flurry Methods

-(void) logPhotoAddedEvent{
    [Flurry logEvent:@"Photo Added"];
}

-(void) logTextAddedEvent{
    [Flurry logEvent:@"Text Added"];
}


#pragma mark - Access Image Directory
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
    
    //when we create emoticons
    if ([imgName rangeOfString:@"emoticon"].location == NSNotFound) {
        NSLog(@"sub string doesnt exist");
    } else {
        FolderPath = [NSString stringWithFormat:@"%@/Emoticon", currentpath];
        dicPath = @"Emoticon";
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


#pragma mark - gesture delegate

// this allows you to dispatch touches
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}
// this enables you to handle multiple recognizers on single view
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)onTap:(UITapGestureRecognizer *)gesture {
    [self enableImageViewInteraction];
}


- ( void )productSuccesfullyPurchased: (NSString *)productId {
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    UserPurchases *userPurchases_ = appDelegate.userPurchases;
    if ( [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyAllDesignBundle"] ||
         [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyUnlockCreateVideoFlyerOption"] ) {
        
        UIImage *buttonImage = [UIImage imageNamed:@"video_tab.png"];
        [addVideoTabButton setImage:buttonImage forState:UIControlStateNormal];
        [inappviewcontroller.paidFeaturesTview reloadData];
        [inappviewcontroller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- ( void )inAppPurchasePanelContent {
    [inappviewcontroller inAppDataLoaded];
}


- (void)inAppPurchasePanelButtonTappedWasPressed:(NSString *)inAppPurchasePanelButtonCurrentTitle {
    
    __weak InAppViewController *inappviewcontroller_ = inappviewcontroller;
    if ([inAppPurchasePanelButtonCurrentTitle isEqualToString:(@"Sign In")]) {
        
        signInController = [[SigninController alloc]initWithNibName:@"SigninController" bundle:nil];
        
        FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
        signInController.launchController = appDelegate.lauchController;
        
        __weak CreateFlyerController *createFlyerController = self;
        __weak UserPurchases *userPurchases_ = appDelegate.userPurchases;
        userPurchases_.delegate = self;
        
        [inappviewcontroller_.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        
        signInController.signInCompletion = ^void(void) {
            
            UINavigationController* navigationController = createFlyerController.navigationController;
            [navigationController popViewControllerAnimated:NO];
            [userPurchases_ setUserPurcahsesFromParse];
        };
        
        [self.navigationController pushViewController:signInController animated:YES];
        
    }else if ([inAppPurchasePanelButtonCurrentTitle isEqualToString:(@"Restore Purchases")]){
        
        
        [inappviewcontroller_ restorePurchase];
    }
}

- (void) userPurchasesLoaded {
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    UserPurchases *userPurchases_ = appDelegate.userPurchases;
    
    if ( [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyAllDesignBundle"]  ||
         [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyUnlockCreateVideoFlyerOption"] ) {
        
        
        UIImage *buttonImage = [UIImage imageNamed:@"video_tab.png"];
        [addVideoTabButton setImage:buttonImage forState:UIControlStateNormal];
        [inappviewcontroller.paidFeaturesTview reloadData];
        
    }else {
        
        [self presentModalViewController:inappviewcontroller animated:YES];
    }
    
}



@end
