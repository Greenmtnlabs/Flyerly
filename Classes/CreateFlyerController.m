
//  Flyer
//
//  Created by Riksof Pvt. Ltd on 12/10/09.
//
//

#import "CreateFlyerController.h"
#import "UIImage+NBUAdditions.h"
#import "Common.h"
#import "ResourcesView.h"
#import "UserVoice.h"
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"
#import "PrintViewController.h"
#import "InviteForPrint.h"
#import "ImageLayer.h"
#import "GiphyViewController.h"

#define IMAGEPICKER_TEMPLATE 1
#define IMAGEPICKER_PHOTO 2

#define DRAWING_MSG_4_ERASER @"DRAWING_MSG_4_ERASER"
#define DRAWING_MSG_4_COLOR @"DRAWING_MSG_4_COLOR"

//DrawingClass required files
#import "Twitter/TWTweetComposeViewController.h"

@interface CreateFlyerController () {
    CameraViewController *nbuCamera;
    ResourcesView *emoticonsView,*clipartsView,*fontsView,*textBordersView,*drawingView;
    NSString *fontsViewResourcePath,*clipartsViewResourcePath,*emoticonsViewResourcePath,*drawingViewResourcePath;
    NSMutableArray *fontsArray,*clipartsArray,*emoticonsArray;
    NSArray *coloursArray;
    int selectedAddMoreLayerTab;
    FlyerlyConfigurator *flyerConfigurator;
    UserPurchases *userPurchases;
    
    BOOL isNewText;
    //Fix for: 162-create-flyer-screen-when-user-close-the-inapp-tabs-are-active-and-extra-layer-showing-when-it-comes-from-clipart
    BOOL appearingViewAfterInAppHide;
    BOOL saveToGallaryReqBeforeSharing;
    BOOL isNewFlyer;
    BOOL firstTimeInViewDidAppear;
    NSString *productIdentifier;
    NSString *create_flyer_default_image;
    int bannerHeight;
}

@end

@implementation CreateFlyerController

@synthesize sharingPannelIsHidden,tasksAfterGiphySelect;

//Outlets form zoom
@synthesize zoomScrollView,zoomScreenShot,zoomMagnifyingGlass,zoomScreenShotForVideo;

//Drawing required files
@synthesize mainImage;
@synthesize tempDrawImage,enableRenderFlyer;

@synthesize selectedFont,selectedColor,selectedTemplate,fontTabButton,colorTabButton,sizeTabButton,fontEditButton,selectedSize,
fontBorderTabButton,addVideoTabButton,addMorePhotoTabButton,addArtsTabButton,sharePanel,clipArtTabButton,emoticonsTabButton,artsColorTabButton,artsSizeTabButton, drawingColorTabButton,drawingPatternTabButton, drawingSizeTabButton,drawingEraserTabButton,drawingEraserMsg;
@synthesize cameraTabButton,photoTabButton,widthTabButton,heightTabButton,deleteAlert,signInAlert,waterMarkPurchasingAlert,spaceUnavailableAlert;
@synthesize imgPickerFlag,layerScrollView,flyerPath;
@synthesize contextView,libraryContextView,libFlyer,backgroundTabButton,addMoreFontTabButton,drawingMenueButton;
@synthesize libText,libBackground,libArts,libPhoto,libEmpty,backtemplates,cameraTakePhoto,cameraRoll,flyerBorder,giphyBgBtn,libDrawing;
@synthesize flyimgView,currentLayer,layersDic,flyer,player,playerView,playerToolBar,playButton,playerSlider,tempelateView;
@synthesize durationLabel,durationChange,onFlyerBack,shouldShowAdd;
@synthesize backgroundsView,flyerBordersView,colorsView,sizesView,bannerAdsView,drawingPatternsView,drawingEraserMsgView;

@synthesize premiumBtnBg, premiumBtnBgBorder, premiumBtnEmoticons, premiumBtnCliparts, premiumBtnFonts;
@synthesize premiumImgBg, premiumImgBgBorder, premiumImgEmoticons, premiumImgCliparts, premiumImgFonts;
@synthesize btnBannerAdsDismiss;


#pragma mark -  View Appear Methods
- (void)viewWillAppear:(BOOL)animated{
    
    bannerHeight = 0;
    if( [userPurchases canShowAd] ) {
        
        if(IS_IPHONE_4){
        
        } else {
            bannerHeight = bannerAdsView.frame.size.height;
        }
        
        self.bannerAdsView.adUnitID = [flyerConfigurator bannerAdID];
        self.bannerAdsView.delegate = self;
        self.bannerAdsView.rootViewController = self;
        [self.bannerAdsView loadRequest:[self request]];
    }
    
    btnBannerAdsDismiss.alpha = 0.0;
    bannerAdsView.alpha = 0.0;
    [self setFramesOfBtns];
    
    saveToGallaryReqBeforeSharing = NO;
}

-(void) setFramesOfBtns{
    
    CGRect newFrame = CGRectMake( 0, 0,
                                 libraryContextView.frame.size.width,
                                 libraryContextView.frame.size.height);
    
    [libFlyer setFrame:newFrame];
    [libArts setFrame:newFrame];
    [libBackground setFrame:newFrame];
    [libText setFrame:newFrame];
    [libPhoto setFrame:newFrame];
    [libDrawing setFrame:newFrame];
}

/**
 * Set position of WaterMark according to Device.
 * Note: This function will only run when flyer is opening first time
 */
-(void)setWaterMarkLayerPosition {
    if (isNewFlyer && (IS_IPHONE_4 ||  IS_IPHONE_6 || IS_IPHONE_6_PLUS) ){
        NSArray *sortedLayers = [flyer allKeys];
        if ( sortedLayers.count >= 2 ){
            
            NSMutableDictionary *dic = [flyer getLayerFromMaster:sortedLayers[1]];
            
            double device_width = 0;
            
            #if defined(FLYERLY_BIZ)
                dic[@"image"] = @"Photo/watermark_FlyerlyBiz.png";
                dic[@"height"] = @"25";
                dic[@"width"] = @"101";
            #endif
            
            if( [[dic objectForKey:@"type"] isEqualToString:FLYER_LAYER_WATER_MARK] ){
                
                if ( [[dic objectForKey:@"flyerOpenTime"] isEqualToString:@"0"] ) {
                    if( IS_IPHONE_4 || IS_IPHONE_5 ) {
                        device_width = 320;
                    }
                    else if( IS_IPHONE_6 ) {
                        device_width = 375;
                    }
                    else if( IS_IPHONE_6_PLUS ) {
                        device_width = 414;
                    }
                    
                    NSString *x = [NSString stringWithFormat:@"%f", (device_width - [dic[@"width"] doubleValue] - 29.25)];
                    NSString *y = [NSString stringWithFormat:@"%f", (device_width - [dic[@"height"] doubleValue] - 24.25)];
                    
                    [dic setObject:x forKey:@"tx"];
                    [dic setObject:y forKey:@"ty"];
                    
                    [dic setObject:@"1" forKey:@"flyerOpenTime"];
                    
                    //[flyer saveDic];
                    // Save flyer to disk
                    [flyer saveFlyer];
                    
                    // Make a history entry if needed.
                    [flyer addToHistory];
                }
            }
        }
    }
}


/**
 * Update the view once it appears.
 */
-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self setFramesOfBtns];
    if ( firstTimeInViewDidAppear ){
        firstTimeInViewDidAppear = false;
        //Set Context Tabs
        [self addBottomTabs:libFlyer];
    }
    
    if( appearingViewAfterInAppHide == YES ){
        appearingViewAfterInAppHide = NO;
        return;
    }
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    //Render Flyer
    if( enableRenderFlyer == YES )
    [self renderFlyer];
    
    enableRenderFlyer = YES;
    
    self.flyimgView.addUiImgForDrawingLayer = NO;//must set:NO after renderFlyer all layers first time
    
    //Set Context View
    [self addAllLayersIntoScrollView];
    
    NSString *title = [flyer getFlyerTitle];
    
    if ( ![title isEqualToString:@""] ) {
        titleLabel.text = title;
    } else {
        titleLabel.text = @"Untitled";
    }
    // to add click event on Label to open share panel
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(share)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [titleLabel addGestureRecognizer:tapGestureRecognizer];
    titleLabel.userInteractionEnabled = YES;
    
    //245-feature-in-create-screen-when-user-is-creating-brand-new-flyer-have-the-background-button-selected-for-them-initially
    if( isNewFlyer ){
        create_flyer_default_image = @"create_flyer_default_image.png";
        self.flyimgView.image = [UIImage imageNamed:create_flyer_default_image];
        [self setAddMoreLayerTabAction:backgroundTabButton];
        isNewFlyer = NO;
    }
    
    if( tasksAfterGiphySelect != nil ){
        [self callAddMoreLayers];
        if ([tasksAfterGiphySelect isEqual:@"play"] && player != nil ) {
            [self videoPlay:YES repeat:YES];
        }
        tasksAfterGiphySelect = nil;
    }
}

-(void) loadInterstitialAdd{
    self.interstitialAdd.delegate = nil;
    
    // Create a new GADInterstitial each time. A GADInterstitial will only show one request in its
    // lifetime. The property will release the old one and set the new one.
    self.interstitialAdd = [[GADInterstitial alloc] init];
    self.interstitialAdd.delegate = self;
    
    // Note: Edit SampleConstants.h to update kSampleAdUnitId with your interstitial ad unit id.
    self.interstitialAdd.adUnitID = [flyerConfigurator interstitialAdID];
    
    [self.interstitialAdd loadRequest:[self request]];

}
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    
    [self loadInterstitialAdd];
    
    //Here we remove Borders from layer if user touch any layer
    [self.flyimgView layerStoppedEditing:currentLayer];
    
    dispatch_async( dispatch_get_main_queue(), ^{
        //Here we Open Share Panel for Share Flyer
        [self openPanel];
    });
}

- (GADRequest *)request {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as well as any devices
    // you want to receive test ads.
    request.testDevices = @[
                            // TODO: Add your device/simulator test identifiers here. Your device identifier is printed to
                            // the console when the app is launched.
                            //NSString *udid = [UIDevice currentDevice].uniqueIdentifier;
                            GAD_SIMULATOR_ID
                            ];
    return request;
}

- (void)showTopBanner:(UIView *)banner{
    
    [UIView beginAnimations:@"bannerOn" context:NULL];
    
    banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
    
    [UIView commitAnimations];
    
    banner.hidden = NO;
    
}


// We've received an Banner ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    
    if ( bannerAddClosed == NO && bannerShowed == NO ) {
        bannerShowed = YES;//keep bolean we have rendered banner or not ?
    
        btnBannerAdsDismiss.alpha = 1.0;
        [self.bannerAdsView addSubview:btnBannerAdsDismiss];
        
        if ( sharePanel.hidden ){
            bannerAdsView.alpha = 1.0;
            [self.view addSubview:self.bannerAdsView];
        }
    
        return;
    }
}

- (IBAction)onClickBtnBannerAdsDismiss:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dissmisBannerAdd:YES];
    });
}

// Dismiss action for banner ad
-(void)dissmisBannerAdd:(BOOL)valForBannerClose{
    
    productIdentifier = BUNDLE_IDENTIFIER_AD_REMOVAL; // Ad Removal Subscription
    inappviewcontroller = [[InAppViewController alloc] initWithNibName:@"InAppViewController" bundle:nil];
    inappviewcontroller.buttondelegate = self;
    [inappviewcontroller requestProduct];
    [inappviewcontroller purchaseProductByID:productIdentifier];
}

// Dismiss action for banner ad
-(void)removeBAnnerAdd:(BOOL)valForBannerClose{
    
    self.bannerAdsView.backgroundColor = [UIColor clearColor];
    
    UIView *viewToRemove = [bannerAdsView viewWithTag:999];
    [viewToRemove removeFromSuperview];
    [self.bannerAdsView removeFromSuperview];
    self.btnBannerAdsDismiss  = nil;
    self.bannerAdsView = nil;
    
    bannerAddClosed = valForBannerClose;
}



/**
 * View setup. This is done once per instance.
 */
-(void)viewDidLoad{
    
    [self setWaterMarkLayerPosition];
    
    if( IS_IPHONE_4 ){
        [[NSBundle mainBundle] loadNibNamed:@"CreateFlyerController-iPhone4" owner:self options:nil];
    }

    firstTimeInViewDidAppear = YES;
    enableRenderFlyer = YES;
    sharingPannelIsHidden = YES;
    appearingViewAfterInAppHide = NO;
    isNewText   =   NO;
    bannerAddClosed = NO;
    bannerShowed = NO;
    selectedAddMoreLayerTab = -1;
    
    //DrawingClass required vars
    dw_red = 0.0/255.0;
    dw_green = 0.0/255.0;
    dw_blue = 0.0/255.0;
    dw_brush = 10.0;
    dw_brushType = DRAWING_PLANE_LINE;
    dw_opacity = 1.0;
    self.flyimgView.addUiImgForDrawingLayer = YES; //must set:NO after renderLayers
    dw_drawingLayerMode  =  DRAWING_LAYER_MODE_NORMAL;
    dw_layer_save   = NO;
    dw_isOldLayer   = NO;
    
	[super viewDidLoad];
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    flyerConfigurator = appDelegate.flyerConfigurator;
    
    userPurchases = [UserPurchases getInstance];
    userPurchases.delegate = self;
    //when have valid subscription or have ad removal bundle then dont show ad
    if( [userPurchases canShowAd] ) {
        [self loadInterstitialAdd];
    }
    
    // If 50mb space not availble then go to Back
    [self isDiskSpaceAvailable];
    
    UVConfig *config = [UVConfig configWithSite:@"http://flyerly.uservoice.com/"];
    [UserVoice initialize:config];
    
    // Here we Set Top Bar Item
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:TITLE_FONT size:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];
    
    self.navigationItem.titleView = titleLabel;
    CGRect lsvRec = CGRectMake(0, 0,320,60); //iPhone4
    // Device Check Maintain Size of ScrollView Because Scroll Indicator will show.
    if ( IS_IPHONE_5 ) {
        lsvRec = CGRectMake(lsvRec.origin.x, lsvRec.origin.y, self.contextView.frame.size.width,self.contextView.frame.size.height);//CGRectMake(0, 0,320,150);
    } else if ( IS_IPHONE_6 ){
        lsvRec = CGRectMake(0, 0,420,180);
    }else if ( IS_IPHONE_6_PLUS ){
        self.contextView.size = CGSizeMake(self.contextView.frame.size.width, self.contextView.frame.size.height+10);
        lsvRec = CGRectMake(0, 0,420,189);
    }
    layerScrollView = [[UIScrollView alloc]initWithFrame:lsvRec];
    
    layerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(lsvRec.origin.x, lsvRec.origin.y, self.contextView.frame.size.width,self.contextView.frame.size.height)];
    
    
    layerScrollView.autoresizesSubviews = YES;
    layerScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    layerScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
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
    
    [self addButtonsInRightNavigation:@"viewDidLoad"];
    
    // Left BackButton
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    // HERE WE SET BACK BUTTON IMAGE AS REQUIRED
    NSArray * arrayOfControllers =  self.navigationController.viewControllers;
    int idx = (int)[arrayOfControllers count] -2 ;
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
	imgPickerFlag = IMAGEPICKER_TEMPLATE;
    selectedAddMoreLayerTab = -1;
    
    // Current selected layer.
    currentLayer = @"";
    
    // Execute the rest of the stuff, a little delayed to speed up loading.
    dispatch_async( dispatch_get_main_queue(), ^{
        
        // Create color array
        colorArray = [[NSArray  alloc] initWithObjects: [UIColor redColor],
                      [UIColor blueColor],
                      [UIColor greenColor],
                      [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1],//[UIColor blackColor],
                      [UIColor colorWithRed:164.0/255.0 green:166.0/255.0 blue:131.0/255.0 alpha:1],
                      [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1],//[UIColor colorWithWhite:1.0f alpha:1.0f],
                      [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1],//[UIColor grayColor],
                      [UIColor magentaColor],
                      [UIColor yellowColor],
                      [UIColor colorWithRed:0.0/255.0 green:77.0/255.0 blue:92.0/255.0 alpha:1],
                      [UIColor colorWithRed:219.0/255.0 green:105.0/255.0 blue:126.0/255.0 alpha:1],
                      [UIColor purpleColor],
                      [UIColor colorWithRed:201.0/255.0 green:88.0/255.0 blue:69.0/255.0 alpha:1],
                      [UIColor orangeColor],
                      [UIColor colorWithRed:139.0/255.0 green:181.0/255.0 blue:227.0/255.0 alpha:1],
                      [UIColor colorWithRed:22.0/255.0 green:50.0/255.0 blue:129.0/255.0 alpha:1],
                      [UIColor colorWithRed:229.0/255.0 green:228.0/255.0 blue:47.0/255.0 alpha:1],
                      [UIColor colorWithRed:226.0/255.0 green:236.0/255.0 blue:48.0/255.0 alpha:1],
                      [UIColor cyanColor],
                      [UIColor colorWithRed:38.0/255.0 green:72.0/255.0 blue:18.0/255.0 alpha:1],
                      [UIColor colorWithRed:73.0/255.0 green:69.0/255.0 blue:215.0/255.0 alpha:1], nil];
        
        
        // Create border colors array
        borderArray = 	[[NSArray  alloc] initWithObjects:
                         [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1], // black
                         [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1], // grayColor
                         [UIColor colorWithRed:67.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1], // darkGrayColor
                         [UIColor blueColor],
                         [UIColor purpleColor],
                         [UIColor colorWithRed:95.0/255.0 green:115.0/255.0 blue:125.0/255.0 alpha:1],
                         [UIColor orangeColor],
                         [UIColor greenColor],
                         [UIColor redColor],
                         [UIColor colorWithRed:0.0/255.0 green:77.0/255.0 blue:92.0/255.0 alpha:1],
                         [UIColor colorWithRed:164.0/255.0 green:166.0/255.0 blue:131.0/255.0 alpha:1],
                         [UIColor colorWithRed:219.0/255.0 green:105.0/255.0 blue:126.0/255.0 alpha:1],
                         [UIColor colorWithRed:201.0/255.0 green:88.0/255.0 blue:69.0/255.0 alpha:1],
                         [UIColor colorWithRed:139.0/255.0 green:181.0/255.0 blue:227.0/255.0 alpha:1],
                         [UIColor colorWithRed:22.0/255.0 green:50.0/255.0 blue:129.0/255.0 alpha:1],
                         [UIColor colorWithRed:229.0/255.0 green:228.0/255.0 blue:47.0/255.0 alpha:1],
                         [UIColor cyanColor],
                         [UIColor colorWithRed:226.0/255.0 green:236.0/255.0 blue:48.0/255.0 alpha:1],
                         [UIColor magentaColor],
                         [UIColor colorWithRed:38.0/255.0 green:72.0/255.0 blue:18.0/255.0 alpha:1],
                         [UIColor colorWithRed:73.0/255.0 green:69.0/255.0 blue:215.0/255.0 alpha:1],
                         @"b1.png",@"b2.png",@"b3.png",@"b4.png",@"b5.png",@"b6.png",@"b7.png",@"b8.png",@"b9.png",@"b10.png",
                         @"b11.png",@"b12.png",@"b13.png",@"b14.png",@"b15.png",@"b16.png",@"b17.png",@"b18.png",@"b19.png",@"b20.png",@"b21.png",
                         nil];
        
        // HERE WE CREATE FLYERLY ALBUM ON DEVICE
        if(![[NSUserDefaults standardUserDefaults] stringForKey:@"FlyerlyAlbum"]){
            [flyer createFlyerlyAlbum];
        }

        // Setup the share panel.
        sharePanel = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.origin.y, 320,200 )];
        sharePanel.hidden = YES;
        [self.view addSubview:sharePanel];

        //Set Undo Bar Status
        [self setUndoStatus];
        
        
        //Show paid xid for all with yellow overly ( open in app on tap ), we will hide it after user checking user purchases
        fontsViewResourcePath = [[NSBundle mainBundle] pathForResource:@"Fonts-paid" ofType:@"plist"];
        clipartsViewResourcePath = [[NSBundle mainBundle] pathForResource:@"Cliparts-paid" ofType:@"plist"];
        emoticonsViewResourcePath = [[NSBundle mainBundle] pathForResource:@"Emoticons-paid" ofType:@"plist"];
        
        // Execute the rest of the stuff, a little delayed to speed up loading.
        dispatch_async( dispatch_get_main_queue(), ^{
            BOOL canCheckPurchases = ( ![[NSUserDefaults standardUserDefaults] stringForKey:@"InAppPurchases"] );
            
            
            if( IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ){
                
                NSArray *flyerbackgroundsViewArray;
                if ( IS_IPHONE_4) {
                     flyerbackgroundsViewArray = [[NSBundle mainBundle] loadNibNamed:@"Backgrounds-iPhone4" owner:self options:nil];
                }else if ( IS_IPHONE_5 ) {
                    flyerbackgroundsViewArray = [[NSBundle mainBundle] loadNibNamed:@"Backgrounds" owner:self options:nil];
                }else if ( IS_IPHONE_6){
                    flyerbackgroundsViewArray = [[NSBundle mainBundle] loadNibNamed:@"Backgrounds-iPhone6" owner:self options:nil];
                }else if ( IS_IPHONE_6_PLUS){
                    flyerbackgroundsViewArray = [[NSBundle mainBundle] loadNibNamed:@"Backgrounds-iPhone6-Plus" owner:self options:nil];
                } else {
                    flyerbackgroundsViewArray = [[NSBundle mainBundle] loadNibNamed:@"Backgrounds" owner:self options:nil];
                }
                backgroundsView = [flyerbackgroundsViewArray objectAtIndex:0];
                
                NSArray *flyerBordersViewArray;
                if (  IS_IPHONE_4) {
                    flyerBordersViewArray = [[NSBundle mainBundle] loadNibNamed:@"Borders-iPhone4" owner:self options:nil];
                }else if ( IS_IPHONE_5 ) {
                    flyerBordersViewArray = [[NSBundle mainBundle] loadNibNamed:@"Borders" owner:self options:nil];
                }else if ( IS_IPHONE_6){
                    flyerBordersViewArray = [[NSBundle mainBundle] loadNibNamed:@"Borders-iPhone6" owner:self options:nil];
                }else if ( IS_IPHONE_6_PLUS){
                    flyerBordersViewArray = [[NSBundle mainBundle] loadNibNamed:@"Borders-iPhone6-Plus" owner:self options:nil];
                } else {
                    flyerBordersViewArray = [[NSBundle mainBundle] loadNibNamed:@"Borders" owner:self options:nil];
                }
                
                flyerBordersView = [flyerBordersViewArray objectAtIndex:0];
                
                [self addFontsInSubView];
                
                NSArray *fontColorsViewArray;
                if (  IS_IPHONE_4) {
                    fontColorsViewArray = [[NSBundle mainBundle] loadNibNamed:@"Colours-iPhone4s" owner:self options:nil];
                }else if ( IS_IPHONE_5 ) {
                     fontColorsViewArray = [[NSBundle mainBundle] loadNibNamed:@"Colours" owner:self options:nil];
                }else if ( IS_IPHONE_6){
                    fontColorsViewArray = [[NSBundle mainBundle] loadNibNamed:@"Colours-iPhone6" owner:self options:nil];
                }else if ( IS_IPHONE_6_PLUS){
                    fontColorsViewArray = [[NSBundle mainBundle] loadNibNamed:@"Colours-iPhone6-Plus" owner:self options:nil];
                } else {
                    fontColorsViewArray = [[NSBundle mainBundle] loadNibNamed:@"Colours" owner:self options:nil];
                }
                colorsView = [fontColorsViewArray objectAtIndex:0];
                
                
                NSArray *drawingPatternsViewArray;
                if (  IS_IPHONE_4) {
                    drawingPatternsViewArray = [[NSBundle mainBundle] loadNibNamed:@"DrawingPatterns-iPhone4" owner:self options:nil];
                }else if ( IS_IPHONE_5 ) {
                   drawingPatternsViewArray = [[NSBundle mainBundle] loadNibNamed:@"DrawingPatterns" owner:self options:nil];
                }else if ( IS_IPHONE_6){
                    drawingPatternsViewArray = [[NSBundle mainBundle] loadNibNamed:@"DrawingPatterns-iPhone6" owner:self options:nil];
                }else if ( IS_IPHONE_6_PLUS){
                    drawingPatternsViewArray = [[NSBundle mainBundle] loadNibNamed:@"DrawingPatterns-iPhone6-Plus" owner:self options:nil];
                } else {
                    drawingPatternsViewArray = [[NSBundle mainBundle] loadNibNamed:@"DrawingPatterns" owner:self options:nil];
                }
                drawingPatternsView = [drawingPatternsViewArray objectAtIndex:0];
                
                NSArray *drawingEraserMsgViewArray;
                if ( IS_IPHONE_4) {
                    drawingEraserMsgViewArray = [[NSBundle mainBundle] loadNibNamed:@"DrawingEraserMsg-iPhone4" owner:self options:nil];
                } else if ( IS_IPHONE_5 ) {
                    drawingEraserMsgViewArray = [[NSBundle mainBundle] loadNibNamed:@"DrawingEraserMsg" owner:self options:nil];
                }else if ( IS_IPHONE_6){
                    drawingEraserMsgViewArray = [[NSBundle mainBundle] loadNibNamed:@"DrawingEraserMsg-iPhone6" owner:self options:nil];
                }else if ( IS_IPHONE_6_PLUS){
                    drawingEraserMsgViewArray = [[NSBundle mainBundle] loadNibNamed:@"DrawingEraserMsg-iPhone6" owner:self options:nil];
                } else {
                    drawingEraserMsgViewArray = [[NSBundle mainBundle] loadNibNamed:@"DrawingEraserMsg" owner:self options:nil];
                }
                
                drawingEraserMsgView = [drawingEraserMsgViewArray objectAtIndex:0];
                [self setLabelsAfterXibsLoad];
                
                NSArray *fontSizesViewArray;
                if ( IS_IPHONE_4) {
                    fontSizesViewArray = [[NSBundle mainBundle] loadNibNamed:@"Sizes-iPhone4" owner:self options:nil];
                } else if ( IS_IPHONE_5 ) {
                     fontSizesViewArray = [[NSBundle mainBundle] loadNibNamed:@"Sizes" owner:self options:nil];
                }else if ( IS_IPHONE_6){
                    fontSizesViewArray = [[NSBundle mainBundle] loadNibNamed:@"Sizes-iPhone6" owner:self options:nil];
                }else if ( IS_IPHONE_6_PLUS){
                    fontSizesViewArray = [[NSBundle mainBundle] loadNibNamed:@"Sizes-iPhone6-Plus" owner:self options:nil];
                } else {
                    fontSizesViewArray = [[NSBundle mainBundle] loadNibNamed:@"Sizes-iPhone4" owner:self options:nil];
                }
                
                sizesView = [fontSizesViewArray objectAtIndex:0];
                
                NSArray *textBordersViewArray;
                if ( IS_IPHONE_4) {
                    textBordersViewArray = [[NSBundle mainBundle] loadNibNamed:@"TextBorders-iPhone4" owner:self options:nil];
                }else if ( IS_IPHONE_5 ) {
                     textBordersViewArray = [[NSBundle mainBundle] loadNibNamed:@"TextBorders" owner:self options:nil];
                }else if ( IS_IPHONE_6){
                    textBordersViewArray = [[NSBundle mainBundle] loadNibNamed:@"TextBorders-iPhone6" owner:self options:nil];
                }else if ( IS_IPHONE_6_PLUS){
                    textBordersViewArray = [[NSBundle mainBundle] loadNibNamed:@"TextBorders-iPhone6-Plus" owner:self options:nil];
                } else {
                    textBordersViewArray = [[NSBundle mainBundle] loadNibNamed:@"TextBorders" owner:self options:nil];
                }
                
                textBordersView = [textBordersViewArray objectAtIndex:0];
                
                [self addClipArtsInSubView];
                
                [self addEmoticonsInSubView];
                [self addDrawingInSubView];
                
                
            }
            else {
                
                [self dissmisBannerAdd:NO];
                
                NSArray *flyerbackgroundsViewArray = [[NSBundle mainBundle] loadNibNamed:@"Backgrounds-iPhone4" owner:self options:nil];
                backgroundsView = [flyerbackgroundsViewArray objectAtIndex:0];
                
                NSArray *flyerBordersViewArray = [[NSBundle mainBundle] loadNibNamed:@"Borders-iPhone4" owner:self options:nil];
                flyerBordersView = [flyerBordersViewArray objectAtIndex:0];
                
                [self addFontsInSubView];
                //NSArray *fontViewArray = [[NSBundle mainBundle] loadNibNamed:@"Fonts-iPhone4" owner:self options:nil];
                //fontsView = [fontViewArray objectAtIndex:0];
                
                NSArray *fontColorsViewArray = [[NSBundle mainBundle] loadNibNamed:@"Colours-iPhone4s" owner:self options:nil];
                colorsView = [fontColorsViewArray objectAtIndex:0];
                
                NSArray *drawingPatternsViewArray = [[NSBundle mainBundle] loadNibNamed:@"DrawingPatterns-iPhone4" owner:self options:nil];
                drawingPatternsView = [drawingPatternsViewArray objectAtIndex:0];
                
                NSArray *drawingEraserMsgViewArray = [[NSBundle mainBundle] loadNibNamed:@"DrawingEraserMsg-iPhone4" owner:self options:nil];
                drawingEraserMsgView = [drawingEraserMsgViewArray objectAtIndex:0];

                [self setLabelsAfterXibsLoad];
                
                NSArray *fontSizesViewArray = [[NSBundle mainBundle] loadNibNamed:@"Sizes-iPhone4" owner:self options:nil];
                sizesView = [fontSizesViewArray objectAtIndex:0];
                
                NSArray *textBordersViewArray = [[NSBundle mainBundle] loadNibNamed:@"TextBorders-iPhone4" owner:self options:nil];
                textBordersView = [textBordersViewArray objectAtIndex:0];
                
                [self addClipArtsInSubView];
                
                [self addEmoticonsInSubView];
                
            }
            
            premiumImgBg = [[UIImageView alloc] initWithFrame:[self getSizeOfPremium:premiumBtnBg.frame.origin.x y:premiumBtnBg.frame.origin.y]];
            premiumImgBg.image = [UIImage imageNamed:@"premiumImg.png"];
            [backgroundsView addSubview:premiumImgBg];

            premiumImgBgBorder = [[UIImageView alloc] initWithFrame:[self getSizeOfPremium:premiumBtnBgBorder.frame.origin.x y:premiumBtnBgBorder.frame.origin.y]];
            premiumImgBgBorder.image = [UIImage imageNamed:@"premiumImg.png"];
            [flyerBordersView addSubview:premiumImgBgBorder];
            
            [premiumBtnBg setBackgroundColor:[self getPremiumBgColor]];
            [premiumBtnBgBorder setBackgroundColor:[self getPremiumBgColor]];
            
            if( canCheckPurchases ){
                [self loadXibsAfterInAppCheck:NO againAddInSubViews:YES];
            }

        }); //main queue2
    });//main queue1
    
    [self zoomInit];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark -  View DisAppear Methods

/*
 * This Method Call On Back Button
 * and its Save Flyer then Exits Screen
 */
-(void) goBack {
    
    if( flyimgView.zoomedIn ){
        [self zoomEnd];
    }
    
    //Delete extra layers
    [self deSelectPreviousLayer];
    
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
        
        backButton.enabled = YES;
        helpButton.enabled = YES;
        return;
    }
    
    // Delete empty layer if it exists.
    if ( currentLayer != nil && ![currentLayer isEqualToString:@""] ) {
        BOOL deleteThisLayer    =   NO;
        
        NSMutableDictionary *layerDic = [flyer getLayerFromMaster:currentLayer];
        NSString *type = [layerDic objectForKey:@"type"];
        NSString *flyerImg = [layerDic objectForKey:@"image"];//[flyer getImageName:currentLayer];
        NSString *flyertext = [layerDic objectForKey:@"text"];//[flyer getText:currentLayer];
        
        //IF NEW DRAWING LAYER
        if ( [type isEqualToString:FLYER_LAYER_DRAWING] && !(dw_isOldLayer) ){
            deleteThisLayer =   YES;
        }
        
        deleteThisLayer = ( deleteThisLayer || [flyerImg isEqualToString:@""] ) ?  YES : NO;
        deleteThisLayer = ( deleteThisLayer || [flyertext isEqualToString:@""]) ?  YES : NO;
        
        if ( deleteThisLayer ) {
            [flyer deleteLayer:currentLayer];
            [self.flyimgView deleteLayer:currentLayer];
        }
    }
    
    // If a layer is selected, unselect it.
    if ( ![currentLayer isEqualToString:@""] ) {
        [self.flyimgView layerStoppedEditing:currentLayer];
    }
    
    userPurchases.delegate = nil;
    
    [self videoPlay:NO repeat:NO];
    
    // This work will be done in the background to prevent the UI from being
    // stuck.
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if( [flyer isSaveRequired] == YES ) {
            
            // Save flyer to disk
            [flyer saveFlyer]; //
            
            // Make a history entry if needed.
            [flyer addToHistory]; //
            
            //here we keep the merging vido path
            [flyer isVideoMergeProcessRequired];
        
            // If this is a video flyer, then merge the video.
            if ( [flyer isVideoFlyer] ) {
                
                // Set all share options status to 0
                [flyer resetAllButtonStatus];
                
                // Set all button selected state
                [shareviewcontroller setAllButtonSelected:NO];
                
                [shareviewcontroller enableShareOptions:NO];
                [shareviewcontroller haveVideoLinkEnableAllShareOptions:NO];
                
                // Set saveButton status to 1, i.e. this flyer's been saved
                [flyer setSaveButtonStatus:1];
                // Set SaveButton visual state selected
                [shareviewcontroller.saveButton setSelected:YES]; 
                
                panelWillOpen = NO;
                dispatch_async( dispatch_get_main_queue(), ^{
                    // Here we Merge All Layers in Video File
                    [self videoMergeProcess];
                });
               
                
            } else {
                // Here we take Snap shot of Flyer and
                // Flyer Add to Gallery if user allow to Access there photos
                [flyer setUpdatedSnapshotWithImage:[self getFlyerSnapShot]];
                
                // Go to the main thread and let the home screen know that flyer is
                // updated.
                dispatch_async( dispatch_get_main_queue(), ^{
                    
                    // Here we call Block for update Main UI
                    self.onFlyerBack( @"" );
                });
            }

            [Flurry logEvent:@"Saved Flyer"];
            
        } else {
            dispatch_async( dispatch_get_main_queue(), ^{
                if( self.flyer.saveInGallaryRequired == 0 ) {
                    self.flyer.saveInGallaryAfterNumberOfTasks = -1;//when we have no need to saveInGallary on back
                }
                // Here we call Block for update Main UI
                self.onFlyerBack( @"" );
            });
        }
    });
    
    if ( self.shouldShowAdd != NULL ) {
        if ( [self.flyer isVideoFlyer] ) {
            self.shouldShowAdd ( @"", YES ); // in order not to show full screen ads
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    // Remove observers
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    layerScrollView = nil;
}

#pragma mark -  Add Content In ScrollViews

/*
 * Add templates in scroll views
 */
-(void)addTemplatesInSubView{
    
    widthValue = 60;
    heightValue = 55;
    
    // Load sizes xib asynchronously
    dispatch_async( dispatch_get_main_queue(), ^{
        imgPickerFlag = IMAGEPICKER_TEMPLATE;
        
        [templateArray removeAllObjects];
        
        //Delete SubViews From ScrollView
        [self deleteSubviewsFromScrollView];
        
        if(IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS){
            [layerScrollView addSubview:backgroundsView];
            [layerScrollView setContentSize:CGSizeMake(backgroundsView.frame.size.width, backgroundsView.frame.size.height + bannerHeight)];
            
        } else {
            [layerScrollView addSubview:backgroundsView];
            [layerScrollView setContentSize:CGSizeMake(backgroundsView.frame.size.width, [layerScrollView bounds].size.height + bannerHeight)];
        }
        
        for (UIView *sub in backgroundsView.subviews) {
            if ([sub isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *) sub;
                [btn addTarget:self action:@selector(selectTemplate:) forControlEvents:UIControlEventTouchUpInside];
                
            }
        }
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
    
    if(IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS){
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
        
        if(IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS){
            
            if( IS_IPHONE_6_PLUS ){
                flyerBordersView.frame = CGRectMake((layerScrollView.frame.origin.x+22), (layerScrollView.frame.origin.y), flyerBordersView.frame.size.width, flyerBordersView.frame.size.height);
            }
            [layerScrollView addSubview:flyerBordersView];
            [layerScrollView setContentSize:CGSizeMake(320, flyerBordersView.frame.size.height + bannerHeight)];
            
        } else {
            
            [layerScrollView addSubview:flyerBordersView];
            [layerScrollView setContentSize:CGSizeMake(flyerBordersView.frame.size.width, [layerScrollView bounds].size.height)];
        }
        
        NSArray *bodersArray = flyerBordersView.subviews;
        int borderArrayCount =  (int)borderArray.count;
        int i =0;

        for (int index = 0; index < bodersArray.count; index += 3 )
        {
            if( i >= borderArrayCount )
            break;
            
            //Here we Highlight Last Color Selected
            if (textColor != nil) {
                id colorName = borderArray[i];

                if ([textColor rangeOfString:@".png"].location != NSNotFound ) {
                    if ( [colorName isKindOfClass:[NSString class]] ) {
                        UIButton *curBtn =  bodersArray[index+1];//image is in second button
                        NSString *currentBackgroundImage = curBtn.currentTitle;
                        if( [currentBackgroundImage isEqual:textColor] ){
                            [self highlightAndScrollRect:curBtn.tag inView:flyerBordersView];
                            break;
                        }
                    }
                }
                else if( [colorName isKindOfClass:[UIColor class]] ){
                    colorName  = (UIColor *)colorName;
                    NSString *tcolor;
                    NSString *twhite;
                    CGFloat r = 0.0, g = 0.0, b = 0.0, a = 0.0,wht = 0.0;
                    
                    UILabel *labelToStore = [[UILabel alloc]init];
                    labelToStore.textColor = colorName;
                    
                    //Getting RGB Color Code
                    [labelToStore.textColor getRed:&r green:&g blue:&b alpha:&a];
                    
                    tcolor = [NSString stringWithFormat:@"%f, %f, %f", r, g, b];
                    if ( r == 0 && g == 0 && b ==0) {
                        [labelToStore.textColor getWhite:&wht alpha:&a];
                    }
                    
                    twhite = [NSString stringWithFormat:@"%f, %f", wht, a];
                    
                    if( [textColor isEqual:tcolor] && [textWhiteColor isEqual:twhite]  ){
                        UIButton *curBtn =  bodersArray[index+2];//color is on second button
                        [self highlightAndScrollRect:curBtn.tag inView:flyerBordersView];
                        break;
                    }
                    
                    
                }
            }
            else{
                //When we have no border, focus on first btn
                UIButton *fb =  bodersArray[index+2];
                [layerScrollView scrollRectToVisible:CGRectMake(0, 0, fb.frame.size.width, fb.frame.size.height) animated:YES];
                break;
            }
          i++;
        }// Loop


    });
}

/*
 * Add fonts in scroll views
 */
-(void)addFontsInSubView{
    
    widthValue = 35;
    heightValue = 35;
    
    fontsView = [[ResourcesView alloc] init];
    [self deleteSubviewsFromScrollView];
    fontsArray = [[NSMutableArray alloc] init];
    
    // Low the fonts in background.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
    
        NSArray *fontFamilies = [[NSArray alloc] initWithContentsOfFile:fontsViewResourcePath];
    
        for ( NSString *fontFamily in fontFamilies ) {
            UIFont *itemForFontArray = [UIFont fontWithName:fontFamily size:27];
            
            if( itemForFontArray != nil)
            [fontsArray addObject:itemForFontArray];
        }
        
        dispatch_async( dispatch_get_main_queue(), ^{
    
            CGFloat curXLoc = 0;
            CGFloat curYLoc = 5;
            int increment = 5;
    
            if(IS_IPHONE_5 ){
                curXLoc = 13;
                curYLoc = 10;
                increment = 8;
            }else if ( IS_IPHONE_6) {
                curXLoc = 13;
                curYLoc = 10;
                increment = 8;
            }
            else if ( IS_IPHONE_6_PLUS ) {
                curXLoc = 13;
                curYLoc = 10;
                increment = 8;
            }
            
            int initialX = curXLoc;
            int initialY = curYLoc;
            int fOPrem[6] = {initialX,initialY,0,0};
            
            NSMutableDictionary *textLayer;
            NSString *textFamily;
    
            //Getting Last Info of Text Layer
            if (![currentLayer isEqualToString:@""]) {
                textLayer = [flyer getLayerFromMaster:currentLayer];
                textFamily = [textLayer objectForKey:@"fontname"];
            }
            int fontsArrayCount = (int)[fontsArray count];
            for (int i = 1; i <=fontsArrayCount ; i++) {
                UIButton *font = [UIButton buttonWithType:UIButtonTypeCustom];
                font.frame = CGRectMake(0, 0, widthValue, heightValue);
                [font addTarget:self action:@selector(selectFont:) forControlEvents:UIControlEventTouchUpInside];
                [font setTitle:@"A" forState:UIControlStateNormal];
                UIFont *fontname = fontsArray[(i-1)];
                [font.titleLabel setFont: fontname];
                [font setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                font.tag = i;
                [font setBackgroundImage:[UIImage imageNamed:@"a_bg"] forState:UIControlStateNormal];
        
                //SET BUTTON POSITION ON SCROLLVIEW
                CGRect frame = font.frame;
                frame.origin = CGPointMake(curXLoc, curYLoc);
                font.frame = frame;
                
                
                //We have 21 free fonts, so start yellow overly after it ( from new row)
                if( i >= 22 && (fOPrem[0] == initialX && fOPrem[1] == initialY) && (curXLoc == initialX || curYLoc == initialY )){
                    fOPrem[0] = curXLoc;
                    fOPrem[1] = curYLoc;
                } else if ( i == fontsArrayCount ){
                    if(curYLoc == fOPrem[1] ){ //iPhone4 landscap views
                        fOPrem[2] = (curXLoc + widthValue  ) - fOPrem[0];
                        fOPrem[3] = (int)heightValue;
                    } else{ //square views
                        fOPrem[3] = ( curYLoc + heightValue) - fOPrem[1];
                    }
                }
                
                
                curXLoc = curXLoc + widthValue + increment ;
                
                if( i != 0 ) {
                    if(IS_IPHONE_5 && curXLoc >= 300 ){
                        fOPrem[4] = 0; fOPrem[5] = 320;
                        curXLoc = 13;
                        curYLoc = curYLoc + heightValue + 7;
                    } else if ( IS_IPHONE_6 && curXLoc >= 350 ){
                        fOPrem[4] = 0; fOPrem[5] = 380;
                        curXLoc = 13;
                        curYLoc = curYLoc + heightValue + 7;
                    } else if( IS_IPHONE_6_PLUS && ( i%9 == 0 ) ){ //iphon6+ screen can show 8 font type icons
                        fOPrem[4] = 0; fOPrem[5] = 584;
                        curXLoc = 13;
                        curYLoc = curYLoc + heightValue + 7;
                    }
                }
        
                [fontsView addSubview:font];
            }
            
            userPurchases = [UserPurchases getInstance];
            userPurchases.delegate = self;
            
            if( IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ){
                fOPrem[0] = fOPrem[4]; fOPrem[2] = fOPrem[5];
            }
            
              //if user has not subscription for fonts then show premium view
            if ( [userPurchases checkKeyExistsInPurchases:IN_APP_ID_ICON_BUNDLE] == NO ) {
                premiumBtnFonts = [UIButton buttonWithType:UIButtonTypeCustom];
                premiumBtnFonts.frame = CGRectMake(fOPrem[0], fOPrem[1], fOPrem[2], fOPrem[3]);
                
                [premiumBtnFonts addTarget:self action:@selector(openPanel:) forControlEvents:UIControlEventTouchUpInside];
                
                UIFont *fontname = [UIFont fontWithName:@"Helvetica" size:15.0];
                [premiumBtnFonts.titleLabel setFont: fontname];
                [premiumBtnFonts setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [premiumBtnFonts setBackgroundColor:[self getPremiumBgColor]];

                [fontsView addSubview:premiumBtnFonts];
                
                premiumImgFonts = [[UIImageView alloc] initWithFrame:[self getSizeOfPremium:fOPrem[0] y:fOPrem[1] ] ];
                premiumImgFonts.image = [UIImage imageNamed:@"premiumImg.png"];
                [fontsView addSubview:premiumImgFonts];
            }
            
                //fontsView.backgroundColor = [UIColor redColor];
                
                if ( IS_IPHONE_5 ) {
                    
                    fontsView.size = CGSizeMake(320, curYLoc + heightValue);
                    [layerScrollView setContentSize:CGSizeMake(fontsView.frame.size.width, fontsView.frame.size.height + bannerHeight)];
                    fontsView.frame = CGRectMake((layerScrollView.frame.origin.x+5), (layerScrollView.frame.origin.y+5), fontsView.frame.size.width, fontsView.frame.size.height);
                    
                } else if ( IS_IPHONE_6 ){
                    
                    fontsView.size = CGSizeMake(380, curYLoc + heightValue + 10);
                    [layerScrollView setContentSize:CGSizeMake(320, curYLoc + bannerHeight)];
                    fontsView.frame = CGRectMake((layerScrollView.frame.origin.x+5), (layerScrollView.frame.origin.y+5), fontsView.frame.size.width, fontsView.frame.size.height);
                    
                } else if ( IS_IPHONE_6_PLUS ){
                    fontsView.size = CGSizeMake(584, curYLoc + heightValue);
                    [layerScrollView setContentSize:CGSizeMake(584, curYLoc + bannerHeight)];
                    
                    fontsView.frame = CGRectMake((layerScrollView.frame.origin.x+5), layerScrollView.frame.origin.y, fontsView.frame.size.width, fontsView.frame.size.height);
                    
                } else {
                    fontsView.size = CGSizeMake((curXLoc+10) , heightValue);
                    [layerScrollView setContentSize:CGSizeMake(fontsView.size.width , heightValue + bannerHeight)];
                    
                    fontsView.frame = CGRectMake((layerScrollView.frame.origin.x+5), (layerScrollView.frame.origin.y+5), fontsView.frame.size.width, fontsView.frame.size.height);
                    
                }
            
            //Handling Select Unselect
            [self setSelectedItem:[flyer getLayerType:currentLayer] inView:fontsView ofLayerAttribute:LAYER_ATTRIBUTE_FONT];
        });
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
    
    if( IS_IPHONE_5 ){
        curXLoc = 13;
        curYLoc = 10;
        increment = 8;
    } else if( IS_IPHONE_6 || IS_IPHONE_6_PLUS){
        curXLoc = 13;
        curYLoc = 13;
        increment = 13;
    }
    
    
    NSMutableDictionary *textLayer,*drawingLayer;
    NSString *textColor;
    NSString *textWhiteColor;
    
    NSString *type = [flyer getLayerType:currentLayer];
    if ( [type isEqualToString:FLYER_LAYER_DRAWING] ){
        drawingLayer = [flyer getLayerFromMaster:currentLayer];
    }
    //Getting Last Info of Text Layer
    else if (![currentLayer isEqualToString:@""]) {
        textLayer = [flyer getLayerFromMaster:currentLayer];
        textColor = [textLayer objectForKey:@"textcolor"];
        textWhiteColor = [textLayer objectForKey:@"textWhitecolor"];
    }
    
    // Load sizes xib asynchronously
    dispatch_async( dispatch_get_main_queue(), ^{
        
        if(IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS){
            
            if( IS_IPHONE_6_PLUS ){
                colorsView.frame = CGRectMake((layerScrollView.frame.origin.x+22), (layerScrollView.frame.origin.y), colorsView.frame.size.width, colorsView.frame.size.height);
            }
            [layerScrollView addSubview:colorsView];
            [layerScrollView setContentSize:CGSizeMake(320, colorsView.frame.size.height + bannerHeight)];
            
        } else {
            
            [layerScrollView addSubview:colorsView];
            [layerScrollView setContentSize:CGSizeMake(colorsView.frame.size.width, [layerScrollView bounds].size.height)];
        }

        
        coloursArray = colorsView.subviews;
        
        for (int i = 1; i <=  [colorArray count] ; i++)
        {
            UIButton *color;
            if ([coloursArray[i-1] isKindOfClass:[UIButton class]]) {
                color = (UIButton *) coloursArray[i-1];
            }
            
            id colorName = colorArray[(i-1)];
            //Here we Highlight Last Color Selected
            if (textLayer || drawingLayer) {
                
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
            }
            
        }//Loop
        
        //Handling Select Unselect
        [self setSelectedItem:[flyer getLayerType:currentLayer] inView:colorsView ofLayerAttribute:LAYER_ATTRIBUTE_COLOR];
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
    
    if(IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS){
        curXLoc = 13;
        curYLoc = 10;
        increment = 8;
    }
    
    NSMutableDictionary *textLayer;
    __block NSString *textSize;
    
    //Getting Last Info of Text Layer
    if (![currentLayer isEqualToString:@""]) {
        textLayer = [flyer getLayerFromMaster:currentLayer];
        textSize = [textLayer objectForKey:@"fontsize"];
    }
    
    // Load sizes xib asynchronously
    dispatch_async( dispatch_get_main_queue(), ^{
        
        if(IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS){
            
            if( IS_IPHONE_6_PLUS ){
                sizesView.frame = CGRectMake((layerScrollView.frame.origin.x+22), (layerScrollView.frame.origin.y), sizesView.frame.size.width, sizesView.frame.size.height);
            }
            [layerScrollView addSubview:sizesView];
            [layerScrollView setContentSize:CGSizeMake(320, sizesView.frame.size.height + bannerHeight)];
            
        } else {
            
            [layerScrollView addSubview:sizesView];
            [layerScrollView setContentSize:CGSizeMake(sizesView.frame.size.width, [layerScrollView bounds].size.height)];
        }
        
        
        NSMutableDictionary *layerDic = [flyer getLayerFromMaster:currentLayer];
        
        // Get the type of layer
        NSString *type = [layerDic objectForKey:@"type"];//[flyer getLayerType:currentLayer];
        if( [type isEqualToString:FLYER_LAYER_CLIP_ART] ){
            
            textSize = [NSString stringWithFormat:@"%f", ([textSize floatValue]/3.0)];
            
        }else if ( [type isEqualToString:FLYER_LAYER_EMOTICON] ) {
            
            CGRect lastFrame = [flyer getImageFrame:currentLayer];
            textSize = [NSString stringWithFormat:@"%f", (lastFrame.size.height/1.5)];
        }
        else if ( [type isEqualToString:FLYER_LAYER_DRAWING] ) {
            
            textSize = [layerDic objectForKey:@"brush"];
        }
        
        NSArray *sizesArray = sizesView.subviews;
        for (int i = 1; i <=  [SIZE_ARRAY count] ; i++)
        {
            
            UIButton *size;
            if ([sizesArray[i-1] isKindOfClass:[UIButton class]]) {
                size = (UIButton *) sizesArray[i-1];
            }
            
            NSString *sizeValue =SIZE_ARRAY[(i-1)];
            [size setTitle:sizeValue forState:UIControlStateNormal];
        }
        
        //Handling Select Unselect
        [self setSelectedItem:type inView:sizesView ofLayerAttribute:LAYER_ATTRIBUTE_SIZE];
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
    
    if(IS_IPHONE_5 ){
        curXLoc = 13;
        curYLoc = 10;
        increment = 8;
    } else if( IS_IPHONE_6 || IS_IPHONE_6_PLUS){
        curXLoc = 13;
        curYLoc = 13;
        increment = 13;
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
        
        if(IS_IPHONE_5 || IS_IPHONE_6 ){
            textBordersView.frame = CGRectMake((layerScrollView.frame.origin.x), (layerScrollView.frame.origin.y), textBordersView.frame.size.width, textBordersView.frame.size.height + bannerHeight);
            
        } else if( IS_IPHONE_6_PLUS ){
            textBordersView.frame = CGRectMake((layerScrollView.frame.origin.x+20), (layerScrollView.frame.origin.y+5), textBordersView.frame.size.width, textBordersView.frame.size.height + bannerHeight);
            
        } else {
            textBordersView.frame = CGRectMake((layerScrollView.frame.origin.x), (layerScrollView.frame.origin.y), textBordersView.frame.size.width, textBordersView.frame.size.height + bannerHeight);
        }
        
        [layerScrollView addSubview:textBordersView];
        
        
        NSArray *bodersArray = textBordersView.subviews;
        int count = (int)(bodersArray.count)/3;
        
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
                
                i++;
            }
        }// Loop
        
        //Handling Select Unselect
        [self setSelectedItem:[flyer getLayerType:currentLayer] inView:textBordersView ofLayerAttribute:LAYER_ATTRIBUTE_BORDER];
    });
}


/*
 * Add ClipArts in scroll views
 */
-(void)addClipArtsInSubView{
    
    widthValue = 35;
    heightValue = 35;
    
    clipartsView = [[ResourcesView alloc] init];
    [self deleteSubviewsFromScrollView];
    
    // We need to load the contents of file and images in background. Doing this in the
    // main ui thread makes the app less responsive.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        clipartsArray  = [[NSMutableArray alloc] initWithContentsOfFile:clipartsViewResourcePath];
    
        // Now do the work in UI thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat curXLoc = 0;
            CGFloat curYLoc = 5;
            int increment = 5;
    
            if(IS_IPHONE_5 || IS_IPHONE_6_PLUS){
                curXLoc = 13;
                curYLoc = 10;
                increment = 8;
            }
            
            if ( IS_IPHONE_6 ) {
                curXLoc = 18;
                curYLoc = 10;
                increment = 8;
            }
            
            int initialX = curXLoc;
            int initialY = curYLoc;
            int fOPrem[6] = {initialX,initialY,0,0};
    
            NSMutableDictionary *textLayer;
            NSString *textFamily;
    
            //Getting Last Info of Text Layer
            if (![currentLayer isEqualToString:@""]) {
                textLayer = [flyer getLayerFromMaster:currentLayer];
                textFamily = [textLayer objectForKey:@"fontname"];
            }
            int clipartsArrayCount = (int)[clipartsArray count];
            for (int i = 1; i <=clipartsArrayCount ; i++) {
            
                UIButton *font = [UIButton buttonWithType:UIButtonTypeCustom];
                font.frame = CGRectMake(0, 0, widthValue, heightValue);
                [font addTarget:self action:@selector(selectIcon:) forControlEvents:UIControlEventTouchUpInside];
                UIFont *fontType = [UIFont fontWithName:[clipartsArray[i-1] objectForKey:@"fontType"] size:33.0f];
                [font.titleLabel setFont: fontType];
                [font setTitle:[clipartsArray[i-1] objectForKey:@"character"] forState:UIControlStateNormal];
                [font setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                font.tag = i;
                [font setBackgroundImage:[UIImage imageNamed:@"a_bg"] forState:UIControlStateNormal];
        
                //SET BUTTON POSITION ON SCROLLVIEW
                CGRect frame = font.frame;
                frame.origin = CGPointMake(curXLoc, curYLoc);
                font.frame = frame;
                
                
                //We have 42 free cliparts, so start yellow overly after it ( from new row)
                if( i >= 43 && (fOPrem[0] == initialX && fOPrem[1] == initialY) && (curXLoc == initialX || curYLoc == initialY )){
                    fOPrem[0] = curXLoc;
                    fOPrem[1] = curYLoc;
                } else if ( i == clipartsArrayCount ){
                    if(curYLoc == fOPrem[1] ){ //iPhone4 landscap views
                        fOPrem[2] = (curXLoc + widthValue  ) - fOPrem[0];
                        fOPrem[3] = (int)heightValue;
                    } else{ //square views
                        fOPrem[3] = ( curYLoc + heightValue) - fOPrem[1];
                    }
                }

                
                curXLoc += (widthValue)+increment;
        
                if(IS_IPHONE_5){
                    fOPrem[4] = 0; fOPrem[5] = 320;
                    if(curXLoc >= 300){
                        curXLoc = 13;
                        curYLoc = curYLoc + widthValue + 7;
                    }
                }
                
                if(IS_IPHONE_6){
                    fOPrem[4] = 0; fOPrem[5] = 380;
                    if(curXLoc >= 350){
                        curXLoc = 18;
                        curYLoc = curYLoc + widthValue;
                    }
                }
                
                if(IS_IPHONE_6_PLUS && i%9==0){
                    fOPrem[4] = 0; fOPrem[5] = 584;
                    //if(curXLoc >= 300){
                        curXLoc = 13;
                        curYLoc = curYLoc + widthValue;
                    //}
                }
                   
                [clipartsView addSubview:font];
            }//end for loop
            
            userPurchases = [UserPurchases getInstance];
            userPurchases.delegate = self;

            if( IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ){
                fOPrem[0] = fOPrem[4]; fOPrem[2] = fOPrem[5];
            }

            
            //if user has not subscription for clip art then show premium view
            if ( [userPurchases checkKeyExistsInPurchases: IN_APP_ID_ICON_BUNDLE] == NO  ) {
                //More button
                premiumBtnCliparts = [UIButton buttonWithType:UIButtonTypeCustom];
                premiumBtnCliparts.frame = CGRectMake(fOPrem[0], fOPrem[1], fOPrem[2], fOPrem[3]);
                
                [premiumBtnCliparts addTarget:self action:@selector(openPanel:) forControlEvents:UIControlEventTouchUpInside];
                
                UIFont *fontname = [UIFont fontWithName:@"Helvetica" size:15.0];
                [premiumBtnCliparts.titleLabel setFont: fontname];
                [premiumBtnCliparts setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [premiumBtnCliparts setBackgroundColor:[self getPremiumBgColor]];
                
                [clipartsView addSubview:premiumBtnCliparts];
                
                premiumImgCliparts = [[UIImageView alloc] initWithFrame:[self getSizeOfPremium:fOPrem[0] y:fOPrem[1]] ];
                premiumImgCliparts.image = [UIImage imageNamed:@"premiumImg.png"];
                [clipartsView addSubview:premiumImgCliparts];
            }
            
            if ( IS_IPHONE_5 ) {
                clipartsView.size = CGSizeMake(320, curYLoc);
                [layerScrollView setContentSize:CGSizeMake(320, curYLoc + bannerHeight + 10)];
            } else if ( IS_IPHONE_6 ) {
                clipartsView.size = CGSizeMake(380, curYLoc);
                [layerScrollView setContentSize:CGSizeMake(320, curYLoc + bannerHeight)];
                
            }else if ( IS_IPHONE_6_PLUS ) {
                clipartsView.size = CGSizeMake(584, curYLoc);
                [layerScrollView setContentSize:CGSizeMake(320, curYLoc + bannerHeight)];
                
                clipartsView.frame = CGRectMake((layerScrollView.frame.origin.x+1), clipartsView.frame.origin.y, layerScrollView.size.width, clipartsView.size.height - 20);
            }else {
                clipartsView.size = CGSizeMake(curXLoc+ widthValue + 5 , heightValue + 5);
                [layerScrollView setContentSize:CGSizeMake(clipartsView.size.width , heightValue)];
                
                clipartsView.frame = CGRectMake((layerScrollView.frame.origin.x+5), (layerScrollView.frame.origin.y+5), clipartsView.frame.size.width, clipartsView.frame.size.height);
            }
            
        });
    });
}

/*
 * Add Emoticons in scroll views
 */
-(void)addEmoticonsInSubView{
    
    widthValue = 35;
    heightValue = 35;
    
    emoticonsView = [[ResourcesView alloc] init];
    
    // We need to load the contents of file and images in background. Doing this in the
    // main ui thread makes the app less responsive.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        emoticonsArray = [[NSMutableArray alloc] initWithContentsOfFile:emoticonsViewResourcePath];
    
      dispatch_async(dispatch_get_main_queue(), ^{

        NSInteger symbolScrollWidth = 60;
        NSInteger symbolScrollHeight = 60;

        int initialX = 0;
        int initialY = 5;
        CGFloat curXLoc = initialX;
        CGFloat curYLoc = initialY;
            
        int fOPrem[6] = {initialX,initialY,0,0};

        int emoticonsArrayCount = (int)emoticonsArray.count;
        for( int i=1 ; i<=emoticonsArrayCount; i++ ) {
        
            NSString* symbolName = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[emoticonsArray objectAtIndex:(i-1)]] ofType:@"png"];
            UIImage *symbolImg = [UIImage imageWithContentsOfFile:symbolName];
            
            [symbolArray addObject:symbolImg];
            
                UIButton *symbolButton = [UIButton buttonWithType:UIButtonTypeCustom];
                symbolButton.frame =CGRectMake(0, 0, symbolScrollWidth, symbolScrollHeight);
                [symbolButton setImage:symbolImg forState:UIControlStateNormal];
            
                symbolButton.tag = i;
                [symbolButton addTarget:self action:@selector(selectEmoticon:) forControlEvents:UIControlEventTouchUpInside];
            
                CGRect frame = symbolButton.frame;
                frame.origin = CGPointMake(curXLoc, curYLoc);
                symbolButton.frame = frame;
            
            
                //We have 98 free emoticon, so start yellow overly after it ( from new row)
                if( i >= 99 && (fOPrem[0] == initialX && fOPrem[1] == initialY) && (curXLoc == initialX || curYLoc == initialY )){
                    fOPrem[0] = curXLoc;
                    fOPrem[1] = curYLoc;
                } else if ( i == emoticonsArrayCount ){
                    if(curYLoc == fOPrem[1] ){ //iPhone4 landscap views
                        fOPrem[2] = (curXLoc + symbolScrollWidth  ) - fOPrem[0];
                        fOPrem[3] = (int)symbolScrollHeight;
                    } else{ //square views
                        fOPrem[3] = ( curYLoc + symbolScrollHeight) - fOPrem[1];
                    }
                }
            
                curXLoc += (symbolScrollWidth)+5;
            
                if(IS_IPHONE_5){
                    fOPrem[4] = 0; fOPrem[5] = 320;
                    if(curXLoc >= 320){
                        curXLoc = initialX;
                        curYLoc = curYLoc + symbolScrollHeight + 7;
                    }
                }else if(IS_IPHONE_6){
                    fOPrem[4] = 0; fOPrem[5] = 380;
                    curXLoc +=  - 2;
                    if(curXLoc >= 400){
                        curXLoc = initialX;
                        curYLoc = curYLoc + symbolScrollHeight + 7;
                    }
                }else if (IS_IPHONE_6_PLUS && i%6 == 0 ){
                    fOPrem[4] = 0; fOPrem[5] = 584;
                    //if(curXLoc >= 320){
                        curXLoc = initialX;
                        curYLoc = curYLoc + symbolScrollHeight + 7;
                    //}
                }
                
                [emoticonsView addSubview:symbolButton];
            
        } // Loop
            
            userPurchases = [UserPurchases getInstance];
            userPurchases.delegate = self;

          if( IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ){
              fOPrem[0] = fOPrem[4]; fOPrem[2] = fOPrem[5];
          }

          
            //if user has not subscription for icons then show premium view
            if (  [userPurchases checkKeyExistsInPurchases: IN_APP_ID_ICON_BUNDLE] == NO  ) {
                
                //More button
                premiumBtnEmoticons = [UIButton buttonWithType:UIButtonTypeCustom];
                premiumBtnEmoticons.frame = CGRectMake(fOPrem[0], fOPrem[1], fOPrem[2], fOPrem[3]);
                
                [premiumBtnEmoticons addTarget:self action:@selector(openPanel:) forControlEvents:UIControlEventTouchUpInside];
                
                UIFont *fontname = [UIFont fontWithName:@"Helvetica" size:15.0];
                [premiumBtnEmoticons.titleLabel setFont: fontname];
                [premiumBtnEmoticons setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [premiumBtnEmoticons setBackgroundColor:[self getPremiumBgColor]];

                
                [emoticonsView addSubview:premiumBtnEmoticons];
                
                premiumImgEmoticons = [[UIImageView alloc] initWithFrame:[self getSizeOfPremium:fOPrem[0] y:fOPrem[1]] ];
                premiumImgEmoticons.image = [UIImage imageNamed:@"premiumImg.png"];
                [emoticonsView addSubview:premiumImgEmoticons];
            }
          
                //emoticonsView.backgroundColor = [UIColor redColor];
          
                if(IS_IPHONE_5 ){
                    emoticonsView.size = CGSizeMake(320, curYLoc + symbolScrollHeight );
                    [layerScrollView setContentSize:CGSizeMake(320, curYLoc + symbolScrollHeight + bannerHeight)];
                } else if ( IS_IPHONE_6 ){
                    emoticonsView.size = CGSizeMake(380, curYLoc + symbolScrollHeight);
                    [layerScrollView setContentSize:CGSizeMake(320, curYLoc + symbolScrollHeight + bannerHeight)];
                } else if( IS_IPHONE_6_PLUS ){

                    emoticonsView.size = CGSizeMake(584, curYLoc + symbolScrollHeight);
                    [layerScrollView setContentSize:CGSizeMake(emoticonsView.size.width, curYLoc + symbolScrollHeight + bannerHeight)];
                    
                    emoticonsView.frame = CGRectMake((layerScrollView.frame.origin.x+13), emoticonsView.frame.origin.y, emoticonsView.size.width, emoticonsView.size.height);
                } else {
                    emoticonsView.size = CGSizeMake(curXLoc + symbolScrollWidth, symbolScrollHeight + 5);
                    [layerScrollView setContentSize:CGSizeMake(emoticonsView.size.width , symbolScrollHeight + bannerHeight)];
                    
                    emoticonsView.frame = CGRectMake((layerScrollView.frame.origin.x+5), (layerScrollView.frame.origin.y-5), emoticonsView.frame.size.width, emoticonsView.frame.size.height);
                }
            });
    });
}
-(void)zoomAddLayerButtonsIntoScrollView:(NSString *)callFor{
    NSInteger layerScrollWidth = 55;
    NSInteger layerScrollHeight = 40;

    //Add zoom button as first layer button
    if( [callFor isEqualToString:@"addAllLayersIntoScrollView"] ||
        [callFor isEqualToString:@"zoomStart_inside"]
       ) {
        UIButton* zoomButton = [UIButton  buttonWithType:UIButtonTypeCustom];
        [zoomButton addTarget:self action:@selector(zoom:) forControlEvents:UIControlEventTouchUpInside];
        zoomButton.frame = CGRectMake(10, 10, layerScrollWidth, layerScrollHeight);
        [zoomButton setBackgroundColor:[UIColor clearColor]];
        
        [zoomButton.layer setBorderWidth:2];
        [zoomButton.layer setCornerRadius:8];
        UIColor * lightGray = [UIColor lightGrayColor];
        [zoomButton.layer setBorderColor:lightGray.CGColor];
        zoomButton.tag = @"magnifyingGlass";
        
        UIImageView *tileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0,5.0,10.0,10.0)];

        tileImageView.image = [UIImage imageNamed:@"magnifyingGlass2.png"];
        if( [callFor isEqualToString:@"zoomStart_inside"] )
        tileImageView.image = [UIImage imageNamed:@"magnifyingGlass3.png"];
            
        tileImageView.frame  = CGRectMake(zoomButton.frame.origin.x-5, zoomButton.frame.origin.y-6, zoomButton.frame.size.width-10, zoomButton.frame.size.height-7);
        
        tileImageView.contentMode = UIViewContentModeScaleAspectFit;
        tileImageView.tag = @"magnifyingGlassImg";
        
        [zoomButton addSubview:tileImageView];
        
        //1st layer is bg layer, thats why we set count > 1
        if( [flyer allKeys].count > 1 ) {
            [layerScrollView addSubview:zoomButton];
        }
    }
    else if( [callFor isEqualToString:@"zoomStart"]) {
        //Remove Subviews of ScrollView
        [self deleteSubviewsFromScrollView];
        [self zoomAddLayerButtonsIntoScrollView:@"zoomStart_inside"];
        
        UIButton *zoomButton = (UIButton *)[layerScrollView viewWithTag:@"magnifyingGlass"];
        [zoomButton.layer setBorderColor:[UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0].CGColor];
        [layerScrollView setScrollEnabled:NO];
        
        
        zoomScreenShot.frame = CGRectMake(80, 10, zoomScreenShot.size.width, zoomScreenShot.size.height);
        if ( IS_IPHONE_6 ) {
            zoomScreenShot.frame = CGRectMake(80, 10, zoomScreenShot.size.width, zoomScreenShot.size.height);
        }
        [layerScrollView addSubview:zoomScreenShot];
        
        zoomMagnifyingGlass.frame = CGRectMake(50, 50, zoomMagnifyingGlass.size.width, zoomMagnifyingGlass.size.height);
        [layerScrollView addSubview:zoomMagnifyingGlass];
        
        [self zoomMoveToPoint:CGPointMake(34.0, 45.0)];
        

    }
    else if( [callFor isEqualToString:@"zoomEnd"]){
        [self addAllLayersIntoScrollView];
        [layerScrollView setScrollEnabled:YES];
    }
}

/*
 * When we Back To Main View its
 * add All Layers to ScrollView for Edit and Delete Layers
 */
-(void)addAllLayersIntoScrollView {
    
    //Remove Subviews of ScrollView
    [self deleteSubviewsFromScrollView];

    //Default for iPhone 4
    NSInteger layerScrollWidth = 55;
    NSInteger layerScrollHeight = 40;
    CGFloat curXLoc = 0;
    CGFloat curYLoc = 5;
    
    if(IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS){
        curXLoc = 70;
        curYLoc = 10;
    }
    

    //--Add zoom button as first layer button----start
    if( IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ) {
        [self zoomAddLayerButtonsIntoScrollView:@"addAllLayersIntoScrollView"];
    }
    //--Add zoom button as first layer button----end
    
    
    if( self.flyimgView.layers.count == 0 ){
        _addMoreLayerOrSaveFlyerLabel.alpha = 1;
        _takeOrAddPhotoLabel.alpha = 0;
        _videoLabel.alpha = 0;
        return;
    }

    
    
    NSArray *sortedLayers = [flyer allKeys];
    NSMutableDictionary *layers = self.flyimgView.layers;
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
                scrollLabel.textAlignment = NSTextAlignmentCenter;
                scrollLabel.adjustsFontSizeToFitWidth = YES;
                scrollLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                scrollLabel.numberOfLines = 80;
                scrollLabel.lineWidth = 2;
                scrollLabel.text = lbl.text;
                scrollLabel.font = lbl.font;
                scrollLabel.borderColor = lbl.borderColor;
                scrollLabel.textColor = lbl.textColor;
                
                layerButton = [LayerTileButton  buttonWithType:UIButtonTypeCustom];
                [layerButton addTarget:self action:@selector(editLayer:) forControlEvents:UIControlEventTouchUpInside];
                layerButton.uid = uid;
                layerButton.frame =CGRectMake(0, 5,layerScrollWidth, layerScrollHeight);
                
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
                [layerButton addTarget:self action:@selector(editLayer:) forControlEvents:UIControlEventTouchUpInside];
                layerButton.uid = uid;
                layerButton.frame =CGRectMake(0, 5,layerScrollWidth, layerScrollHeight);
                
                
                [layerButton setBackgroundColor:[UIColor clearColor]];
                [layerButton.layer setBorderWidth:2];
                UIColor * c = [UIColor lightGrayColor];
                [layerButton.layer setCornerRadius:8];
                [layerButton.layer setBorderColor:c.CGColor];
                
                tileImageView.frame  = CGRectMake(layerButton.frame.origin.x+5, layerButton.frame.origin.y-2, layerButton.frame.size.width-10, layerButton.frame.size.height-7);
                
                tileImageView.contentMode = UIViewContentModeScaleAspectFit;
                
                [layerButton addSubview:tileImageView];
                
                //layerButton.contentMode = UIViewContentModeScaleAspectFit;
                
                layerButton.tag = [[NSString stringWithFormat:@"%@%d",@"444",cnt] integerValue];
                
            }//End if Checking for Label or ImageView
            
            CGRect frame = layerButton.frame;
            frame.origin = CGPointMake(curXLoc, curYLoc);
            layerButton.frame = frame;
            curXLoc += (layerScrollWidth)+5;
            
            if(IS_IPHONE_5 || IS_IPHONE_6_PLUS){
                if(curXLoc >= 300){
                    curXLoc = 10;
                    curYLoc = curYLoc + layerScrollHeight + 7;
                }
            }else if ( IS_IPHONE_6 ) {
                if(curXLoc >= 350){
                    curXLoc = 10;
                    curYLoc = curYLoc + layerScrollHeight + 7;
                }
            }
            
            [layerScrollView addSubview:layerButton];
        }
        
        cnt ++;
        
    }//Loop
    
    if(IS_IPHONE_5 || IS_IPHONE_6){
        [layerScrollView setContentSize:CGSizeMake(300, curYLoc + layerScrollHeight + bannerHeight)];
    }
    else if( IS_IPHONE_6_PLUS ){
        [layerScrollView setContentSize:CGSizeMake(300, curYLoc + layerScrollHeight + bannerHeight)];
    }
    else {
        [layerScrollView setContentSize:CGSizeMake(([layers count]*(layerScrollWidth+5)), [layerScrollView bounds].size.height + bannerHeight)];
    }
    
    
    [self addScrollView:layerScrollView];
}

#pragma mark -  Select Layer On ScrollView

/*
 * When more button tapped
 */
-(void)openPanel:(id)sender
{
    [self openInAppPanel];
}
/*
 * When any font is selected
 */
-(void)selectFont:(id)sender
{
	int  i=1;
	UIButton *view = sender;
    
	for(UIView *tempView  in [fontsView subviews])
	{
        //CHECK UIIMAGEVIEW BECAUSE SCROLL VIEW HAVE ADDITIONAL
        //SUBVIEWS OF UIIMAGEVIEW FOR FLASH INDICATORS
        if (![tempView isKindOfClass:[UIImageView class]]) {
            
            if(tempView == view)
            {
                selectedFont = fontsArray[i-1];
                selectedFont = [selectedFont fontWithSize:selectedSize];
                
                //Update Dictionaries------------------{--
                //Here we set Font
                [flyer setFlyerTextFont:currentLayer FontName:[NSString stringWithFormat:@"%@",[selectedFont familyName]]];
                //Update Dictionaries-----------------}---
                
                //Update Ui------{----
                [self reRenderLabelAfterFontTypeChange:[flyer getLayerFromMaster:currentLayer]]; //Rufi code
                //Handling Select Unselect
                [self setSelectedItem:FLYER_LAYER_TEXT inView:fontsView ofLayerAttribute:LAYER_ATTRIBUTE_FONT];
                //Update Ui -------}---
            }
            i++;
        }// uiImageView Found
        
	}// Loop
}

-(void)reRenderLabelAfterFontTypeChange:(NSMutableDictionary *)labelDictionary
{
    [self.flyimgView deleteLayer:currentLayer];

    [flyimgView renderLayer:currentLayer layerDictionary:labelDictionary];
    
    //Here we Highlight The TextView [ show borders arround it ]
    [flyimgView layerIsBeingEdited:currentLayer];
}


/*
 * When any color is selected
 */
-(IBAction)selectColor:(id)sender
{
    
	int  i=1;
	UIButton *view = sender;
    
	for(UIView *tempView  in [colorsView subviews])
	{
        
        //CHECK UIIMAGEVIEW BECAUSE SCROLL VIEW HAVE ADDITIONAL
        //SUBVIEWS OF UIIMAGEVIEW FOR FLASH INDICATORS
        if (![tempView isKindOfClass:[UIImageView class]]) {
            
            if(tempView == view)
            {
                selectedColor = colorArray[i-1];
                NSString *type = [flyer getLayerType:currentLayer];
                if( [type isEqualToString:FLYER_LAYER_DRAWING] ){
                   
                    [self setDrawingRGB:selectedColor updateDic:YES];
                    //Handling Select Unselect
                    [self setSelectedItem:FLYER_LAYER_DRAWING inView:colorsView ofLayerAttribute:LAYER_ATTRIBUTE_COLOR];
                }
                else {
                
                    [flyer setFlyerTextColor:currentLayer RGBColor:selectedColor];
                    
                    //Here we call Render Layer on View
                    [flyimgView configureLabelColor :currentLayer labelDictionary:[flyer getLayerFromMaster:currentLayer]];
                    
                    if( [type isEqualToString:FLYER_LAYER_CLIP_ART] ){
                        //Handling Select Unselect
                        [self setSelectedItem:FLYER_LAYER_CLIP_ART inView:colorsView ofLayerAttribute:LAYER_ATTRIBUTE_COLOR];
                    }
                    else {
                        //Handling Select Unselect
                        [self setSelectedItem:FLYER_LAYER_TEXT inView:colorsView ofLayerAttribute:LAYER_ATTRIBUTE_COLOR];
                    }
                }
                break;
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
    
	for(UIView *tempView  in [sizesView subviews])
	{
        
        //CHECK UIIMAGEVIEW BECAUSE SCROLL VIEW HAVE ADDITIONAL
        //SUBVIEWS OF UIIMAGEVIEW FOR FLASH INDICATORS
        if (![tempView isKindOfClass:[UIImageView class]]) {
            
            if(tempView == view)
            {
                NSString *flyerImg = [flyer getImageName:currentLayer];
                NSString *type = [flyer getLayerType:currentLayer];
                
                if ( flyerImg == nil ) { //Label[text]/clipart
                    
                    NSString *sizeStr = SIZE_ARRAY[i-1];
                    selectedSize = [sizeStr intValue];
                    
                    //Checking if layer in clip art,we do not open text editing mood
                    if( [type isEqualToString:FLYER_LAYER_CLIP_ART] ){
                        selectedSize = selectedSize * 3.0;
                    }
                    
                    selectedFont = [selectedFont fontWithSize:selectedSize];

                    //Set size in dictionary
                    [flyer setFlyerTextSize:currentLayer Size:selectedFont];
                    
                    
                    //Rendering related task  ------- starts ------
                    //Here we call Render Layer on View
                    NSMutableDictionary *layerDic =  [flyer getLayerFromMaster:currentLayer];
                    //i call this function 2 time due to a reason.
                    [flyimgView configureLabelSize:currentLayer labelDictionary:layerDic];
                    [flyimgView configureLabelSize:currentLayer labelDictionary:layerDic];

                    if( [type isEqualToString:FLYER_LAYER_CLIP_ART] ){
                        //Handling Select Unselect
                        [self setSelectedItem:FLYER_LAYER_CLIP_ART inView:sizesView ofLayerAttribute:LAYER_ATTRIBUTE_SIZE];
                    } else {
                        //Handling Select Unselect
                        [self setSelectedItem:FLYER_LAYER_TEXT inView:sizesView ofLayerAttribute:LAYER_ATTRIBUTE_SIZE];
                    }
                    
                }
                else if( [type isEqualToString:FLYER_LAYER_DRAWING] ){
                    NSString *sizeStr = SIZE_ARRAY[i-1];
                    selectedSize = [sizeStr intValue];
                    
                    [self setDrawingBrushRadius:selectedSize updateDic:YES];
                    
                    //Handling Select Unselect
                    [self setSelectedItem:FLYER_LAYER_DRAWING inView:sizesView ofLayerAttribute:LAYER_ATTRIBUTE_SIZE];
                }
                else { //image,emoticon...etc
    
                    NSString *sizeStr = SIZE_ARRAY[i-1];
                    
                    ImageLayer *img = [flyimgView.layers objectForKey:currentLayer];
                    
                    // Because emoticons are always sized squarely, we are just considering width here, assuming height is the same
                    CGFloat currentSize = [img newSize].width;
                    
                    CGFloat newSize = [sizeStr floatValue]*1.5;
                    
                    CGFloat scale = newSize / currentSize;
                    
                    CGAffineTransform currentTransform = img.transform;
                    
                    img.layer.anchorPoint = CGPointMake( 0.5, 0.5 );
                    
                    CGAffineTransform tr =
                    CGAffineTransformConcat(
                                            CGAffineTransformMakeScale(scale, scale),
                                            currentTransform);
                    
                    img.transform = tr;
                    
                    NSArray *keys = [flyimgView.layers allKeysForObject:img];
                    // Find key for rotated layer
                    for ( int i = 0; i < keys.count; i++ ) {
                        
                        CGAffineTransform newTransForm = img.transform;
                        
                        NSString *key = [keys objectAtIndex:i];
                        
                        // Save rotation angle for layer
                        [self layerTransformedforKey:key :&newTransForm];
                        
                    }
                    
                    // Show selected size
                    [self setSelectedItem:FLYER_LAYER_EMOTICON inView:sizesView ofLayerAttribute:LAYER_ATTRIBUTE_SIZE];
                    
                }
            }
            i++;
            
        }//UIIMAGEVIEW CHECK
        
	}//LOOP
}

/*
 * Used to resize a font after a label has been resized via a transform
 */
- (void)layerResizedForKey:(NSString *)uid : (CGFloat) scale {
    
    if ( [[[flyer getLayerFromMaster:uid] objectForKey:@"type"] isEqualToString:FLYER_LAYER_CLIP_ART] ||
        [[[flyer getLayerFromMaster:uid] objectForKey:@"type"] isEqualToString:FLYER_LAYER_TEXT ]) {
    
        UIFont* currentFont = [self.flyer getTextFont:uid];
        
        UIFont* newFont = [currentFont fontWithSize:(currentFont.pointSize * scale)];
        
        [self.flyer setFlyerTextSize:uid Size:newFont];
    }
}

/*
 * When any template(background image) is selected
 */
-(void)selectTemplate:(id)sender
{
	UIButton *view = sender;
    
    if( view.tag < 0 )
    return;
    
    //Handling Select Unselect
    for(UIView *tempView  in [backgroundsView subviews])
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
                [self setFlyerTypeImage];
                
                //Getting Image Path
                NSString *imgPath = [self getImagePathByTag:[NSString stringWithFormat:@"Template%d",(int)view.tag]];
                
                //set template Image on view
                [self.flyimgView setTemplate:imgPath];
                
                //Set Image Tag in dictionary
                [flyer setImageTag:@"Template" Tag:[NSString stringWithFormat:@"%d",(int)view.tag]];
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
 * Used to convert a clipart frame to emoticon frame and vice versa.
 */
- (CGRect) convertFrameFromLayerType:(NSString*)fromLayerType toLayerType:(NSString*)toLayerType forClipart:(NSString*)clipart{
    
    CGRect currentFrame;
    
    // Get current view layer
    UIView *view = [flyimgView.layers objectForKey:currentLayer];
    CALayer* l = nil;
    
    
    if ( view != nil ) {
        l = view.layer;
        
        currentFrame = [flyer getImageFrame:currentLayer];
        float currentCenterX = l.frame.origin.x + (l.frame.size.width / 2);
        float currentCenterY = l.frame.origin.y + (l.frame.size.height / 2);
        
        float artLayerSize = 10.0f;
        
        if ( [fromLayerType isEqualToString:FLYER_LAYER_CLIP_ART] ) {
            
            NSDictionary* textLayer = [flyer getLayerFromMaster:currentLayer];
            artLayerSize = [[textLayer objectForKey:@"fontsize"] floatValue] / 3.0;
            
            currentFrame.size.height = artLayerSize * 1.5;
            currentFrame.size.width = artLayerSize * 1.5;
            
            currentFrame.origin.x  = currentCenterX - (currentFrame.size.width / 2);
            currentFrame.origin.y  = currentCenterY - (currentFrame.size.height / 2);
            
        } else if ( [fromLayerType isEqualToString:FLYER_LAYER_EMOTICON] ) {
            
            artLayerSize = currentFrame.size.height / 1.5;
            
            currentFrame.size.height = artLayerSize * 3.0;
            currentFrame.size.width = artLayerSize * 3.0;
            
            UIFont* fontType = [UIFont fontWithName:[clipartsArray[0] objectForKey:@"fontType"] size:(artLayerSize * 3.0)];
            CGSize clipartSize = [clipart sizeWithAttributes:@{ NSFontAttributeName : fontType}];
            
            currentFrame.origin.x  = currentCenterX - (clipartSize.width / 2);
            currentFrame.origin.y  = currentCenterY - (clipartSize.height / 2);
        }
    }
    
    return currentFrame;
}

/*
 * Called when select emoticon
 */
-(void)selectEmoticon:(id)sender {
    
    UIButton *view = sender;
    
    // Get current layer type
    NSString* previousLayerType = [flyer getLayerType:currentLayer];
    
    // Set the layer type and make sure there is no text.
    [flyer setLayerType:currentLayer type:FLYER_LAYER_EMOTICON];
    [flyer setFlyerText:currentLayer text:nil];
    
    // Getting info of selected layer
    UIView *layerView = [flyimgView.layers objectForKey:currentLayer];
    if ( layerView != nil ) {
        
        if ( ![previousLayerType isEqualToString:FLYER_LAYER_EMOTICON] ) {
            
            // Keep existing layer's transform
            CGAffineTransform tempTransform = layerView.transform;
            
            // Now apply the identity transform
            layerView.transform = CGAffineTransformIdentity;
            
            [flyer setImageFrame:currentLayer :[self convertFrameFromLayerType:previousLayerType toLayerType:FLYER_LAYER_EMOTICON forClipart:nil]];
            
            // Now apply the previous transform again
            layerView.transform = tempTransform;
        }
        
        // If no layer is selected then have the emoticon of default size
    } else {
        [flyer setImageFrame:currentLayer:CGRectMake(5, 5, 90, 90)];
    }
    
    NSMutableDictionary *dic = [flyer getLayerFromMaster:currentLayer];
    [self.flyimgView renderLayer:currentLayer layerDictionary:dic];
    
    int lstTag = 500;
    NSString *lastTag = [flyer getImageTag:currentLayer];
    
    if (![lastTag isEqualToString:@""]) lstTag = [lastTag intValue];
    
    if (lstTag != view.tag) {
        
        //Getting Image Path
        NSString *imgPath = [self getEmoticon:[NSString stringWithFormat:@"%@",[emoticonsArray objectAtIndex:(view.tag-1)]]];
        
        //Set Symbol Image
        [flyer setImagePath:currentLayer ImgPath:imgPath];
        
        //Set Image Tag
        [flyer setImageTag:currentLayer Tag:[NSString stringWithFormat:@"%ld",(long)view.tag]];
        
        [self.flyimgView renderLayer:currentLayer layerDictionary:[flyer getLayerFromMaster:currentLayer]];
        
        //Here we Highlight The ImageView
        [self.flyimgView layerIsBeingEdited:currentLayer];
    }
    
    //Handling Select Unselect
    [self setSelectedItem:FLYER_LAYER_EMOTICON inView:emoticonsView ofLayerAttribute:LAYER_ATTRIBUTE_IMAGE];
    
    [self bringNotEditableLayersToFront:@"call from selectEmoticon"];
}


/*
 * Called when select icon(clipart)
 */
-(void)selectIcon:(id)sender
{
    int i=1;
    UIButton *view = sender;
    
    // Get current layer type
    NSString* previousLayerType = [flyer getLayerType:currentLayer];
    
    // Set the type
    [flyer setLayerType:currentLayer type:FLYER_LAYER_CLIP_ART];
    [flyer setImagePath:currentLayer ImgPath:nil];
    [flyer setImageTag:currentLayer Tag:nil];
    
    UIFont* fontType = nil;
    
    // Getting info of selected layer
    UIView *layerView = [flyimgView.layers objectForKey:currentLayer];
    if ( layerView != nil ) {

        if ( ![previousLayerType isEqualToString:FLYER_LAYER_CLIP_ART] ) {
            
            // Keep existing layer's transform
            CGAffineTransform tempTransform = layerView.transform;
            
            // Now apply the identity transform
            layerView.transform = CGAffineTransformIdentity;
            
            CGRect frame = [self convertFrameFromLayerType:previousLayerType toLayerType:FLYER_LAYER_EMOTICON forClipart:view.currentTitle];
            [flyer setImageFrame:currentLayer:frame];
            fontType = [UIFont fontWithName:[clipartsArray[i] objectForKey:@"fontType"] size:frame.size.height];
            
            [layerView sizeToFit];
            
            // Now apply the previous transform again
            layerView.transform = tempTransform;
            
        } else {
            // Get size of current clipart and set it for new clipart
            NSDictionary* textLayer = [flyer getLayerFromMaster:currentLayer];
            fontType = [UIFont fontWithName:[clipartsArray[i] objectForKey:@"fontType"] size:[[textLayer objectForKey:@"fontsize"] floatValue]];
        }
        
    } else {
        //Set default icon (entypo) size
        fontType = [UIFont fontWithName:[clipartsArray[i] objectForKey:@"fontType"] size:(60 * 3.0)];
    }
    
    NSUInteger index = [[clipartsView subviews] indexOfObject:view];
    
    for(UIView *tempView in [clipartsView subviews])
    {
        //CHECK UIIMAGEVIEW BECAUSE SCROLL VIEW HAVE ADDITIONAL
        //SUBVIEWS OF UIIMAGEVIEW FOR FLASH INDICATORS
        if (![tempView isKindOfClass:[UIImageView class]]) {
            
            if(tempView == view)
            {
                [self.flyimgView addSubview:lastTextView];
                
                //Set Text of Layer
                [flyer setFlyerText:currentLayer text:view.currentTitle ];
                
                selectedFont = fontType;
                [flyer setFlyerTextFont:currentLayer FontName:[clipartsArray[index] objectForKey:@"fontType"]];
                [flyer setFlyerTextSize:currentLayer Size:selectedFont];
                
                NSMutableDictionary *layDic = [flyer getLayerFromMaster:currentLayer];
                
                //Here we call Render Layer on View
                [flyimgView renderLayer:currentLayer layerDictionary:layDic];
                
                if ([layDic objectForKey:@"type"] != nil && [[layDic objectForKey:@"type"] isEqual:FLYER_LAYER_CLIP_ART]){
                    [flyimgView configureLabelSize:currentLayer labelDictionary:layDic];
                    [flyimgView configureLabelSize:currentLayer labelDictionary:layDic];
                }
                
                [self setSelectedItem:FLYER_LAYER_CLIP_ART inView:clipartsView ofLayerAttribute:LAYER_ATTRIBUTE_IMAGE];
            }
            i++;
        }
        
    }// Loop
    
    [self bringNotEditableLayersToFront:@"call from selectIcon"];
}
/*
 * When any font border is selected
 */
-(IBAction)selectFontBorder:(id)sender
{
	UIButton *view = sender;
    
	for(UIView *tempView  in [textBordersView subviews])
	{
        if(tempView == view)
        {
            UIColor *borderColor = borderArray[ (((tempView.tag)/3) - 1) ];
            
            [flyer setFlyerTextBorderColor:currentLayer Color:borderColor];
            
            //Here we call Render Layer on View
            [self.flyimgView configureLabelBorder:currentLayer labelDictionary:[flyer getLayerFromMaster:currentLayer]];
            
            //Handling Select Unselect
            [self setSelectedItem:FLYER_LAYER_TEXT inView:textBordersView ofLayerAttribute:LAYER_ATTRIBUTE_BORDER];
            
            break;
        }
	}// LOOP
}


/*
 * When any Flyer border is selected
 */
-(IBAction)selectBorder:(id)sender {
    
    NSArray *bodersArray = flyerBordersView.subviews;
    int count = (int)(bodersArray.count);
    
    UIView *tempView;
    int  i=1;
	UIButton *view = sender;
    
	for (int index = 0; index < count; index++ ) {
        tempView  = [bodersArray objectAtIndex:index];
        
        if ( (index % 3) == 0) {
            
            tempView  = [bodersArray objectAtIndex:index];
            // Add border to Un-select layer thumbnail
            CALayer * l = [tempView layer];
            [l setBorderWidth:1];
            [l setCornerRadius:0];
            UIColor * c = [UIColor clearColor];
            [l setBorderColor:c.CGColor];
            i++;
        }
        
        if(tempView == view) {
            id borderColor = borderArray[i-2];
            currentLayer = @"Template";

            //Save in dictionary
            [flyer setFlyerBorder:currentLayer RGBColor:borderColor];
            
            //Reflect on view / Here we call Render Layer on View
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

#pragma mark -  Progress Indicator
-(void)showLoadingView:(NSString *)message{
    [self showLoadingIndicator];
}

-(void)removeLoadingView{
    [self hideLoadingIndicator];
}

-(CGSize)setSizeForCropView: (CGSize)imageSize {
    if ( IS_IPHONE_5 ){
        if( imageSize.width > 320.0 ){
            imageSize.width = 320;
        }
        if ( imageSize.height > 320.0 ){
            imageSize.height = 320;
        }
    }else if ( IS_IPHONE_6 ){
        if( imageSize.width > 320.0 ){
            imageSize.width = 320.0;
        }
        if ( imageSize.height > 320.0 ){
            imageSize.height = 320.0;
        }
    } else if ( IS_IPHONE_6_PLUS ){
        if( imageSize.width > 320.0 ){
            imageSize.width = 320.0;
        }
        if ( imageSize.height > 320.0 ){
            imageSize.height = 320.0;
        }
    }
    return imageSize;
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
    
    if ( imgPickerFlag == IMAGEPICKER_PHOTO ) {
        UIImageView *currentImage = [self.flyimgView.layers objectForKey:currentLayer];
        nbuGallary.desiredImageSize = [self setSizeForCropView:currentImage.frame.size];
    } else {
        nbuGallary.desiredImageSize = [self setSizeForCropView:CGSizeMake( flyerlyWidth, flyerlyHeight )];
        nbuGallary.desiredVideoSize = CGSizeMake( flyerlyWidth, flyerlyHeight );
    }
    
    __weak CreateFlyerController *weakSelf = self;
    
    [nbuGallary setOnImageTaken:^(UIImage *img) {
        
        [uiBusy stopAnimating];
        [uiBusy removeFromSuperview];
        
        // If there is no image do no further processing.
        if ( img == nil ) {
            return;
        }
        
        //Remove tag of selected background
        [flyer setImageTag:@"Template" Tag:[NSString stringWithFormat:@"%d",-1]];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            
            // Do any UI operation here (render layer).
            if (weakSelf.imgPickerFlag == IMAGEPICKER_PHOTO) {
                
                NSString *imgPath = [weakSelf getImagePathforPhoto:img];
                
                //Set Image to dictionary
                [weakSelf.flyer setImagePath:weakSelf.currentLayer ImgPath:imgPath];
                
                //Here we Create ImageView Layer
                [weakSelf.flyimgView renderLayer:weakSelf.currentLayer layerDictionary:[weakSelf.flyer getLayerFromMaster:weakSelf.currentLayer]];
                
                [weakSelf.flyimgView layerStoppedEditing:weakSelf.currentLayer];
                
                weakSelf.imgPickerFlag = IMAGEPICKER_TEMPLATE;

            }else{
                
                //Here we Set Flyer Type
                [weakSelf setFlyerTypeImage];
                
                //Create Copy of Image
                [weakSelf copyImageToTemplate:img];
                
                //set template Image
                [weakSelf.flyimgView setTemplate:[NSString stringWithFormat:@"Template/template.%@",IMAGETYPE] ];
                [Flurry logEvent:@"Custom Background"];
            }
        });
    }];
    
    
    [nbuGallary setOnVideoFinished:^(NSURL *recvUrl, CGRect cropRect, CGFloat scale ) {
        weakSelf.enableRenderFlyer = NO;
        [weakSelf stopUiBusy];
        [weakSelf.flyimgView addSubview:[weakSelf getUiBusyIndication:[weakSelf getCenterOfView:weakSelf.flyimgView w:20 h:20]] ];
        [weakSelf enableNavigation:NO];
        
        
        NSError *error = nil;
        
        [weakSelf setFlyerTypeVideo];
        
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
            dispatch_async( dispatch_get_main_queue(), ^{
                [weakSelf stopUiBusy];
                [weakSelf enableNavigation:YES];
            });
            switch ( status ) {
                case AVAssetExportSessionStatusFailed:
                    NSLog (@"FAIL = %@", error );
                    break;
                    
                case AVAssetExportSessionStatusCompleted:
                    // Main Thread
                    dispatch_async( dispatch_get_main_queue(), ^{
                        // Render the movie player.
                        [weakSelf.flyimgView renderLayer:@"Template" layerDictionary:[weakSelf.flyer getLayerFromMaster:@"Template"]];
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

-(UIActivityIndicatorView *)getUiBusyIndication:(CGRect)rect{
    uiBusy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [uiBusy setFrame:rect];
    [uiBusy setColor:[UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0]];
    uiBusy.hidesWhenStopped = YES;
    [uiBusy startAnimating];
    return uiBusy;
}
-(void)stopUiBusy{
    [uiBusy stopAnimating];
    [uiBusy removeFromSuperview];
}

-(CGRect)getCenterOfView:(UIImageView *)tempImgView w:(int)w h:(int)h{
    CGRect imageViewCenterRect = CGRectMake( (tempImgView.size.width/2-w/2), (tempImgView.size.height/2-h/2), w, h);
    return imageViewCenterRect;
}

#pragma mark - Add Video
/*
 * Here we Overload Open Camera for Video
 */
-(void)openCustomCamera:(BOOL)forVideo {
    
    [self.view addSubview:[self getUiBusyIndication:CGRectMake(280, 5, 20, 20)] ];
    
    nbuCamera = [[CameraViewController alloc]initWithNibName:@"CameraViewController" bundle:nil];
    
    nbuCamera.videoAllow = forVideo;
    
    if ( imgPickerFlag == IMAGEPICKER_PHOTO ) {
        UIImageView *currentImage = [self.flyimgView.layers objectForKey:currentLayer];
        CGRect imgRect = currentImage.frame;
        
        if ( IS_IPHONE_5 ){
            if( imgRect.size.width > 320.0 ){
                imgRect.size.width = 320;
            }
            if ( imgRect.size.height > 320.0 ){
                imgRect.size.height = 320;
            }
        }else if ( IS_IPHONE_6 ){
            if( imgRect.size.width > 380.0 ){
                imgRect.size.width = 380.0;
            }
            if ( imgRect.size.height > 380.0 ){
                imgRect.size.height = 380.0;
            }
        }
        
        CGSize imageSize = CGSizeMake( imgRect.size.width,
                                      imgRect.size.height );
        
        nbuCamera.desiredImageSize = imageSize;
        
    } else {
        nbuCamera.desiredImageSize = self.flyimgView.size;
        nbuCamera.desiredVideoSize = CGSizeMake( flyerlyWidth, flyerlyHeight );
    }
    
    __weak CreateFlyerController *weakSelf = self;
    
    // Callback once image is selected.
    [nbuCamera setOnImageTaken:^(UIImage *img) {
        
        [weakSelf stopUiBusy];
        
        // If there is no image, do no further processing.
        if ( img == nil ) {
            return;
        }
        
        //Remove tag of selected background
        [weakSelf.flyer setImageTag:@"Template" Tag:[NSString stringWithFormat:@"%d",-1]];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            
            if ( imgPickerFlag == IMAGEPICKER_PHOTO ) {
                NSString *imgPath = [weakSelf getImagePathforPhoto:img];
                
                // Set Image to dictionary
                [weakSelf.flyer setImagePath:weakSelf.currentLayer ImgPath:imgPath];
                
                // Here we Create ImageView Layer
                [weakSelf.flyimgView renderLayer:weakSelf.currentLayer layerDictionary:[weakSelf.flyer getLayerFromMaster:weakSelf.currentLayer]];
                
                [weakSelf.flyimgView layerStoppedEditing:weakSelf.currentLayer];
                
                weakSelf.imgPickerFlag = IMAGEPICKER_TEMPLATE;
                
            } else {
                
                //Here we Set Flyer Type
                [weakSelf setFlyerTypeImage];
                
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
         weakSelf.enableRenderFlyer = NO;
        [weakSelf stopUiBusy];
        [weakSelf.flyimgView addSubview:[weakSelf getUiBusyIndication:[weakSelf getCenterOfView:weakSelf.flyimgView w:20 h:20]] ];
        [weakSelf enableNavigation:NO];
        
        //Remove tag of selected background
        [weakSelf.flyer setImageTag:@"Template" Tag:[NSString stringWithFormat:@"%d",-1]];
        
        NSError *error = nil;
        
        [weakSelf.view addSubview:weakSelf.flyimgView];
        [weakSelf setFlyerTypeVideo];
        
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
            dispatch_async( dispatch_get_main_queue(), ^{
                [weakSelf stopUiBusy];
                [weakSelf enableNavigation:YES];
            });
            switch ( status ) {
                case AVAssetExportSessionStatusFailed:
                    NSLog (@"FAIL = %@", error );
                    break;
                    
                case AVAssetExportSessionStatusCompleted:
                    // Main Thread
                    dispatch_async( dispatch_get_main_queue(), ^{
                        // Render the movie player.
                        [weakSelf.flyimgView renderLayer:@"Template" layerDictionary:[weakSelf.flyer getLayerFromMaster:@"Template"]];
                    });
                    break;
            }
        }];
        
    }];
    
    [nbuCamera setOnVideoCancel:^() {
        dispatch_async( dispatch_get_main_queue(), ^{
            [weakSelf.view addSubview:weakSelf.flyimgView];
            [uiBusy stopAnimating];
            [uiBusy removeFromSuperview];
        });
    }];
    
    if ( [[weakSelf.flyer getFlyerTypeVideo]isEqualToString:@"video"] ){

        if ( [[flyer getLayerType:currentLayer]isEqualToString:FLYER_LAYER_IMAGE] ) {
            nbuCamera.isVideoFlyer = YES;
        }
    }
    [self.navigationController pushViewController:nbuCamera animated:YES];
    
}

#pragma mark -  Movie Player

/*
 * Here we Configure Player and Load File in Player
 */
-(void)loadPlayerWithURL :(NSURL *)movieURL {


    BOOL playerIsNil = YES;
    if ( player != nil ) {
        [player.view removeFromSuperview];
        playerIsNil = NO;
    }
    
    player =[[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    
    [player.view setFrame:self.playerView.bounds];
    
    if( playerIsNil ){
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
    }
    
    self.flyimgView.image = nil;
    
    [self.playerView addSubview:player.view];
    [playerToolBar setFrame:CGRectMake(0, self.playerView.frame.size.height - 40, self.playerView.frame.size.width, 40)];
    [self.flyimgView addSubview:playerToolBar];
    
    player.accessibilityElementsHidden = YES;
    player.shouldAutoplay = NO;
    player.fullscreen = NO;
    player.movieSourceType  = MPMovieSourceTypeFile;
    player.controlStyle =  MPMovieControlStyleNone;
    player.scalingMode = MPMovieScalingModeAspectFill;
    player.backgroundView.backgroundColor = [UIColor whiteColor];
    [player prepareToPlay];
    
    NSString *videoSoure = [[flyer getLayerFromMaster:@"Template"] objectForKey:@"videoSoure"];
    if( videoSoure != nil && [videoSoure isEqualToString:@"giphy"] ){
        [self videoPlay:YES repeat:YES];
    }
}


-(IBAction)play:(id)sender {
    BOOL playOrStop = ([playButton isSelected] == NO);
    [self videoPlay:playOrStop repeat:NO changeAlph:NO];
}

-(void)videoPlay:(BOOL)playOrStop repeat:(BOOL)repeat{
        [self videoPlay:playOrStop repeat:repeat changeAlph:YES];
}
-(void)videoPlay:(BOOL)playOrStop repeat:(BOOL)repeat  changeAlph:(BOOL)changeAlph{
    
    if ( playOrStop ) {
        if(player != nil ){
            [playButton setSelected:YES];
            isPlaying = YES;
            [player play];
            player.repeatMode = repeat;
            player.currentPlaybackTime = playerSlider.value;
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:NO];
            
            if( changeAlph ){
                playerToolBar.alpha = 1;
                [playerToolBar setHidden:NO];
            }
        }
        
    } else{
        if(player != nil ){
            isPlaying = NO;
            [player pause];
            player.repeatMode = repeat;            
        }
        [playButton setSelected:NO];
        
        if( changeAlph ){
            playerToolBar.alpha = 0;
           [playerToolBar setHidden:YES];
        }
    }
}

-(IBAction)slide:(id)sender {
    player.currentPlaybackTime = playerSlider.value;
    durationChange.text =[self stringFromTimeInterval:playerSlider.value];
}

- (void)updateTime:(NSTimer *)timer {
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
- (void)MPMoviePlayerLoadStateDidChange:(NSNotification *)notification {

    if ((player.loadState & MPMovieLoadStatePlaythroughOK) == MPMovieLoadStatePlaythroughOK) {
        
        //videolastImage = [player thumbnailImageAtTime:player.duration /2 timeOption:MPMovieTimeOptionNearestKeyFrame];
        
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:[flyer getVideoAssetURL]] options:nil];
        AVAssetImageGenerator *gen =  [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
        gen.appliesPreferredTrackTransform = YES;
        CMTime time = CMTimeMakeWithSeconds(player.duration/2, 2);
        NSError *error = nil;
        CGImageRef image = [gen copyCGImageAtTime:time actualTime:NULL error:&error];
        videolastImage = [[UIImage alloc] initWithCGImage:image];
        
        playerSlider.maximumValue = player.duration;
        NSTimeInterval duration = player.duration;
        durationLabel.text =[NSString stringWithFormat:@"%@",[self stringFromTimeInterval:player.duration]] ;
        durationChange.text = @"00:00";
        
        float minutes = floor(duration / 60);
        videoDuration = duration - minutes * 60;
        playerSlider.value = 0.0;
    } else {
        NSLog(@"Unknown load state: %lu", (unsigned long)player.loadState);
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
        [self performSelectorOnMainThread:@selector(toggleImageViewInteraction) withObject:nil waitUntilDone:NO ];
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
        NSString *type = [flyer getLayerType:currentLayer];
        if ( [type isEqualToString:FLYER_LAYER_DRAWING] ){
            [self flushTempDrawImg:@"alertView"];
        }
        
        [self deleteLayer:editButtonGlobal overrided:nil];
        [Flurry logEvent:@"Layer Deleted"];
        
	}else if(alertView == spaceUnavailableAlert && buttonIndex == 0) {
        [self goBack];
    }
    else if(alertView == signInAlert && buttonIndex == 0) {
        // Enable  Buttons
        backButton.enabled = YES;
        helpButton.enabled = YES;
        
        rightUndoBarButton.enabled = YES;
        shareButton.enabled = YES;
        
        [self hideLoadingIndicator];
        
    }else if (alertView == waterMarkPurchasingAlert && buttonIndex == 1) {
        [self openInAppPanel];
    }else if(alertView == signInAlert && buttonIndex == 1) {

        signInController = [[SigninController alloc]initWithNibName:@"SigninController" bundle:nil];
        
        FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
        signInController.launchController = appDelegate.lauchController;
        
        __weak CreateFlyerController *weakSelf = self;
        
        UserPurchases *userPurchases_ = [UserPurchases getInstance];
        userPurchases_.delegate = self;
        
        signInController.signInCompletion = ^void(void) {
            NSLog(@"Sign In via Share");
            
            UINavigationController* navigationController = weakSelf.navigationController;
            [navigationController popViewControllerAnimated:NO];
            [userPurchases_ setUserPurcahsesFromParse];
            
            [weakSelf openPanel];
            [weakSelf hideLoadingIndicator];
        };
        [self.navigationController pushViewController:signInController animated:YES];
    }
}

#pragma mark - Custom Methods
/*
 * Load Help Screen
 */
-(void)loadHelpController{
    [UserVoice presentUserVoiceInterfaceForParentViewController:self];
}

/*
 * Here we Create Text Box for Getting Text And
 * and Set Menu for Text Layer
 */
-(void)callWrite{
   
    //--- Set navigation ----------- { --
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];;
    label.text = @"TEXT";
    self.navigationItem.titleView = label;
    
    [self addButtonsInRightNavigation:@"callWrite"];
    
    UIButton *backButtonTemp = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
	[backButtonTemp addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButtonTemp setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    backButtonTemp.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    //--- Set navigation ----------- } --
    
    // disable user interaction of Home and Help button when editing
    backButton.enabled = NO;
    helpButton.enabled = NO;
    
    //Add Context Library
    [self addBottomTabs:libText];
    
    // Get current layer dictionary
    NSDictionary *detail = [flyer getLayerFromMaster:currentLayer];
    
    // Prepare a new text layer for view
    lastTextView = [[UITextView alloc] initWithFrame:CGRectMake([flyer getTvDefPosX], [flyer getTvDefPosY], [[detail valueForKey:@"width"] floatValue], [[detail valueForKey:@"height"] floatValue])];
    lastTextView.accessibilityLabel = @"TextInput";
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
    
    lastTextView.textAlignment = NSTextAlignmentCenter;
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
    
    [self bringNotEditableLayersToFront:@"call from callWrite"];
}


/*
 * Here we add or Replace Two Button on Top Bar
 */
-(void)addDonetoRightBarBotton{
    [self addButtonsInRightNavigation:@"addDonetoRightBarBotton"];
    
}

-(void)addButtonsInRightNavigation:(NSString *)callFrom {
    
    NSMutableArray  *barItems;
    
    // enable user interaction of Home and Help button in every condition
    backButton.enabled = YES;
    helpButton.enabled = YES;
    
    if( [callFrom isEqualToString:@"callWrite"] ){
        
        UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
        [nextButton addTarget:self action:@selector(nextForFont) forControlEvents:UIControlEventTouchUpInside];
        [nextButton setBackgroundImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
        nextButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
        barItems  = [NSMutableArray arrayWithObjects:rightBarButton,nil];
    }
    if( [callFrom isEqualToString:@"viewDidLoad"] ){
        
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
        barItems  = [NSMutableArray arrayWithObjects:rightBarButton,rightUndoBarButton,nil];
    }
    else if( [callFrom isEqualToString:@"choosePhoto"] ){
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
        barItems  = [NSMutableArray arrayWithObjects:doneBarButton,delBarButton,nil];
    }
    else if( [callFrom isEqualToString:@"nextForFont"] ){
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
        barItems  = [NSMutableArray arrayWithObjects:DoneBarButton,delBarButton,nil];
    }
    else if( [callFrom isEqualToString:@"addDonetoRightBarBotton"] ) {
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
        barItems  = [NSMutableArray arrayWithObjects:doneBarButton,delBarButton,nil];
    }
    else if( [callFrom isEqualToString:@"zoomStart"] ){
        // Done Bar Button
        UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
        [doneButton addTarget:self action:@selector(zoomEnd) forControlEvents:UIControlEventTouchUpInside];
        
        [doneButton setBackgroundImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
        doneButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *DoneBarButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
        
        barItems  = [NSMutableArray arrayWithObjects:DoneBarButton,nil];
    }
    else if( [callFrom isEqualToString:@"callAddMoreLayers"] || [callFrom isEqualToString:@"zoomEnd"]){
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
        
        
        barItems  = [NSMutableArray arrayWithObjects:rightBarButton,rightUndoBarButton,nil];
    }
    
    [self.navigationItem setRightBarButtonItems:barItems];
}

/*
 * Here we Set ScrollView and Bottom Tabs
 * after getting Text
 */
-(void)nextForFont
{
    [self addButtonsInRightNavigation:@"nextForFont"];
    
    //Checking Empty String
    if ([lastTextView.text isEqualToString:@""] ) {
        
        [lastTextView resignFirstResponder];
        [lastTextView removeFromSuperview];
        lastTextView = nil;
        
        [self callAddMoreLayers];
        return; // Do not run the bellow code
    }
    
    NSMutableDictionary *textDetailDictionary = [flyer getLayerFromMaster:currentLayer];
    
    if( isNewText == YES || textDetailDictionary[@"tx"] == nil ) {
        float newX = 0.0, newY = 0.0;
        CGSize txtSize = [lastTextView.text sizeWithAttributes: @{NSFontAttributeName:lastTextView.font}];
        
        if( txtSize.width < lastTextView.size.width ){
            newX = lastTextView.frame.origin.x + ( lastTextView.size.width / 2 ) - ( txtSize.width / 2);
            newY = lastTextView.frame.origin.y+3;
            textDetailDictionary[@"x"]  =    [NSString stringWithFormat:@"%f",newX];
            textDetailDictionary[@"y"]  =    [NSString stringWithFormat:@"%f",newY];
        }
    }


    //Update Dictionaries------------------{--
        textDetailDictionary[@"type"] = FLYER_LAYER_TEXT;
        [textDetailDictionary setValue:lastTextView.text forKey:@"text"];
    
        [flyer.masterLayers setValue:textDetailDictionary forKey:currentLayer];
    //Update Dictionaries-----------------}---
    
    //Here we call Render Layer on View
    [flyimgView renderLayer:currentLayer layerDictionary:textDetailDictionary];
    
    //Here we Highlight The TextView [ show borders arround it ]
    [self.flyimgView layerIsBeingEdited:currentLayer];
    

    // SET BOTTOM BAR
    [self setStyleTabAction:fontTabButton];
    
    if( isNewText == YES ) {
         isNewText = NO;
    }
    
	[lastTextView resignFirstResponder];
	[lastTextView removeFromSuperview];
    lastTextView = nil;
}

-(void) donePhoto{
    
    [self deSelectPreviousLayer];
    [self callAddMoreLayers];
    [self logPhotoAddedEvent];

    [self bringNotEditableLayersToFront:@"call from donePhoto"];
    
    self.flyimgView.widthIsSelected = NO;
    self.flyimgView.heightIsSelected = NO;
}

-(void)deSelectPreviousLayer {
    
    // Remove Border if Any Layer Selected check the entire layers in a flyer
    for ( NSString* key in self.flyimgView.layers ) {
        [self.flyimgView layerStoppedEditing:key];
        
        //Delete Empty Layer if Exist
        if (key != nil && ![key isEqualToString:@""]) {
            
            NSString *flyerImg = [flyer getImageName:key];
            NSString *flyertext = [flyer getText:key];
            
            NSLog(@"flyerImg: %@,  flyertext: %@",flyerImg,flyertext);
            
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
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];;
    label.text = @"PHOTO";
    self.navigationItem.titleView = label;

    [self addButtonsInRightNavigation:@"choosePhoto"];
    
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

/**
 * Clean up previous scrollviews.
 */
-(void)removeAllScrolviews {
    // Remove only scrollViews
    NSArray *viewsToRemove = [self.contextView subviews];
    for (UIView *v in viewsToRemove) {
        if ( [v isKindOfClass:[UIScrollView class]] ) {
            [v removeFromSuperview];
        }
    }
}

/*
 * For ScrollView Adding On runtime
 */
-(void)addScrollView:(id)obj{
    // Remove previously added scrollviews.
    [self removeAllScrolviews];
    
    //Add ScrollViews
    [self.contextView addSubview:obj];
    
    if( [userPurchases canShowAd] ){
        if ( sharePanel.hidden ){
            bannerAdsView.alpha = bannerAdsView.alpha ? 1.0 : 0.0;
            [self.view addSubview:self.bannerAdsView];
        }
    }
}

/*
 * For Adding Bottom Button On runtime
 */
-(void)addBottomTabs:(id)obj{
    // Remove previously added scrollviews.
    [self removeAllScrolviews];
    
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

#pragma mark - Screenshot funcs
//Here we Getting Snap Shot of Flyer Image View Context
-(UIImage *)getFlyerSnapShot {
    UIImage *uiImage = [self getFlyerSnapshotWithSize:self.flyimgView.size];
    CGSize size = [self.flyer getSizeOfFlyer];
    uiImage = [self updateImageSize:uiImage scaledToSize:size];//CGSizeMake(uiImage.size.width*2, uiImage.size.height*2)];
    
    return uiImage;
}

- (UIImage *)updateImageSize:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//Here we Getting Snap Shot of Flyer Image View Context for desired size
-(UIImage *)getFlyerSnapshotWithSize:(CGSize)size{
    
    CGFloat alphaOfZoomScreenShotForVideo = zoomScreenShotForVideo.alpha;
    [zoomScreenShotForVideo setAlpha:0.0];
    
    //Here we take Snap shot of Flyer
    UIGraphicsBeginImageContextWithOptions( size, NO, 0);
    
    UIImage *snapshotImage;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.flyimgView.layer renderInContext:context];
    snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [zoomScreenShotForVideo setAlpha:alphaOfZoomScreenShotForVideo];
    
    return snapshotImage;
}

/**
 * Return video flyer screenshot
 * @videoImg: can be nil, or any fram of video
 */
-(UIImage *)getVideoWithMergeSnapshot:(CGSize)size videoFramImg:(UIImage *)videoImg {

    UIImage *flyerSnapshot = [self getFlyerSnapshotWithSize:size];
    
    videoImg = ( videoImg == nil ) ? [flyer getVideoWithoutMergeSnapshot] : videoImg;
    videoImg = [self setSizeOfImage:videoImg size:size]; //set size of image for required size
    
return [flyer mergeImages:videoImg withImage:flyerSnapshot width:zoomScreenShot.size.width height:zoomScreenShot.size.height];
}

/*
 * This resets the flyer image view by removing and readding all its subviews
 */
-(void)renderFlyer {
    
    NSArray *flyerPiecesKeys = [flyer allKeys];
    
    for (int i = 0 ; i < flyerPiecesKeys.count; i++) {
        //Getting Layers Detail from Master Dictionary
        NSMutableDictionary *dic = [flyer getLayerFromMaster:[flyerPiecesKeys objectAtIndex:i]];
        
        //Create Subview from dictionary
        [self.flyimgView renderLayer:[flyerPiecesKeys objectAtIndex:i] layerDictionary:dic];
    }
    [self bringNotEditableLayersToFront:@"call from renderFlyer"];
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
    
    BOOL isVideo = false;
    
    // If it is video
    if ( !([self.flyer getLayerFromMaster:FLYER_LAYER_GIPHY_LOGO] != nil)) {
        isVideo = true;
    }
    
    
    // Get a pointer to the asset
    AVURLAsset* firstAsset = [AVURLAsset URLAssetWithURL:src options:nil];
    
    // Make an instance of avmutablecomposition so that we can edit this asset:
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    // Add tracks to this composition
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    // Audio track
    AVMutableCompositionTrack *audioTrack;
    if ( isVideo ) {
        audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    }
    
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
    if(isVideo){
        // Add the audio track.
        NSArray *audios = [firstAsset tracksWithMediaType:AVMediaTypeAudio];
        if ( audios.count > 0 ) {
            [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, inTime) ofTrack:[audios objectAtIndex:0] atTime:kCMTimeZero error:nil];
        }
    }
    
    NSLog(@"Natural size: %.2f x %.2f", videoTrack.naturalSize.width, videoTrack.naturalSize.height);
    
    // if we have negative dimensions
    if(crop.size.width < 0){
        crop.size.width = -1 * crop.size.width;
    }
    if(crop.size.height < 0){
        crop.size.height = -1 * crop.size.height;
    }
    
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
    
    if(isVideo){
        // Set the transform to maintain orientation
        if ( scale != 1.0 ) {
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale( scale, scale);
            CGAffineTransform translateTransform = CGAffineTransformTranslate( CGAffineTransformIdentity,
                                                                              -crop.origin.x,
                                                                              -crop.origin.y);
            transform = CGAffineTransformConcat( transform, scaleTransform );
            transform = CGAffineTransformConcat( transform, translateTransform);
        }
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
    
    [self videoPlay:NO repeat:NO];
    
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
    
    // Sharing Video( merged video ) path
    NSString *destination = [self.flyer getSharingVideoPath];
    
    // Delete Old File if they exist
    NSError *error = nil;
    if ( [[NSFileManager defaultManager] isReadableFileAtPath:destination] ) {
        [[NSFileManager defaultManager] removeItemAtPath:destination error:&error];
    }
    
    // Export the URL
    NSURL *exportURL = [NSURL fileURLWithPath:destination];
    CGSize size = [self.flyer getSizeOfFlyer];
    int vWidth = size.width;
    int vHeight = size.height;
    
    self.flyer.saveInGallaryRequired = -1;//video merging starts now
    [self modifyVideo:firstURL destination:exportURL crop:CGRectMake(0, 0, vWidth, vHeight ) scale:1 overlay:image completion:^(NSInteger status, NSError *error) {
        switch ( status ) {
            case AVAssetExportSessionStatusFailed:{
                NSLog (@"FAIL = %@", error );
                [self tasksAfterVideoMerging:0];
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
                    [self tasksAfterVideoMerging:1];
                }
            }
        };
        
        FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
        [appDelegate endAppBgTask];
    }];
}

-(void)tasksAfterVideoMerging:(int)sigr{
    // Main Thread
    dispatch_async( dispatch_get_main_queue(), ^{
        if( self.sharingPannelIsHidden == YES ){
            self.onFlyerBack(@"");
        } else {
            self.flyer.saveInGallaryRequired = sigr;
        }
    });
}

#pragma mark - Flyer Modified

/**
 * Edit the current layer.
 */
- (void)editCurrentLayer {
    
    // Get the type of layer
    NSString *type = [flyer getLayerType:currentLayer];
    
    [self renderFlyer];
    
    [self deSelectPreviousLayer];
    
    [self.flyimgView layerIsBeingEdited:currentLayer];
    
    if ( [type isEqualToString:FLYER_LAYER_TEXT] ) {
        
        lastTextView = [[UITextView  alloc] init];
        lastTextView.text = [flyer getText:currentLayer];
        
        lastTextView.accessibilityLabel = @"TextInput";
        
        // For Immediate Showing Delete button
        [self nextForFont];
    }
    else if ( [type isEqualToString:FLYER_LAYER_WATER_MARK] ) {
        if( [self wmCanPerformAction:currentLayer] ) {
               // Call Photo Tab
               [self setAddMoreLayerTabAction:addMorePhotoTabButton];
        }
    }
    else if ( [type isEqualToString:FLYER_LAYER_IMAGE] ) {
        
        // Call Photo Tab
        [self setAddMoreLayerTabAction:addMorePhotoTabButton];
    }
    else if ( [type isEqualToString:FLYER_LAYER_CLIP_ART] ) {
        
        // Call Photo Tab
        [self setArtsTabAction:clipArtTabButton];
        
        [self addDonetoRightBarBotton];
        
    }else if ( [type isEqualToString:FLYER_LAYER_EMOTICON] ) {
        
        // Call Photo Tab
        [self setArtsTabAction:emoticonsTabButton];
        
        [self addDonetoRightBarBotton];
    }
    else if ( [type isEqualToString:FLYER_LAYER_DRAWING] ) {
        [self editDrawingLayer];
    }
    
}

/*
 * When any Layer Tap for Edit its Call (when just tapped on layerboxes from scrollview)
 */
-(void)editLayer:(LayerTileButton *)editButton{
    
    if( !(flyimgView.zoomedIn) ){
        editButtonGlobal = editButton;
        currentLayer =  editButton.uid;
        editButtonGlobal.uid = currentLayer;
        
        [self editCurrentLayer];
    }
    [self bringThisLayerToFront:editButton.uid];
}
/*
 * Here we Delete Layer form Dictionary and Controller
 */
-(void)deleteLayer:(LayerTileButton *)layerButton overrided:(BOOL)overrided{
    
    if(layerButton.uid != nil ){
        //Delete From Master Dictionary
        [flyer deleteLayer:layerButton.uid];
        
        //Delete From View
        [flyimgView deleteLayer:layerButton.uid];
        
        NSLog(@"Delete Layer Tag: %ld", (long)layerButton.tag);
        
        //Set Main View On Screen
        [self callAddMoreLayers];
        
    } else {
        NSLog(@"Deleting background layer");
        
        // Make sure we hide the play bar.
        [playerToolBar setHidden:YES];
        
        //Here we Set Flyer Type
        [self setFlyerTypeImage];
        
        // Get path of current flyer background and remove it
        NSString *currentpath  =   [[NSFileManager defaultManager] currentDirectoryPath];
        NSString *replaceDirName = @"Template/template.png";
        NSString *flyerTemplate = [currentpath stringByAppendingPathComponent:replaceDirName];
        
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:flyerTemplate error:&error];
        if (error) {
            NSLog(@"%@", error.debugDescription);
        }
        
        // Getting Image Path of default background image
        NSString *defaultTemplate = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"flyerbundle/flyer.png"];
        
        // Copy default template again into flyer as its background has been deleted
        [[NSFileManager defaultManager] copyItemAtPath:defaultTemplate toPath:flyerTemplate error:&error];
        
        if (error) {
            NSLog(@"%@", error.debugDescription);
        }
        //Remove tag of selected background
        [flyer setImageTag:@"Template" Tag:[NSString stringWithFormat:@"%d",-1]];
        
        //Set Main View On Screen
        [self callAddMoreLayers];
        
        // Render flyer
        [self renderFlyer];
    }
}

#pragma mark - Delegate for Flyerly ImageView
-(void)setLayerDicXY :(NSString *)layerId :(CGRect)rect {
    [flyer setLayerDicXYInModel :layerId :rect];
}

/**
 *  Transformation changed for layer, let the model know.
 */
- (void)layerTransformedforKey:(NSString *)uid :(CGAffineTransform *) transform {
    //Update Dictionary
    [flyer setImageTransform:uid :transform];
}

/**
 * Frame changed for layer, let the model know.
 */
- (void)frameChangedForLayer:(NSString *)uid frame:(CGRect)frame {
    
    if ([widthTabButton isSelected]) {
        self.flyimgView.widthIsSelected = YES;
        
    } else if ([heightTabButton isSelected]) {
        self.flyimgView.heightIsSelected = YES;
    }
    
    //Update Dictionary
    [flyer setImageFrame:uid :frame];
    
    //Update Controller
    [self.flyimgView renderLayer:uid layerDictionary:[flyer getLayerFromMaster:uid]];
}

/**
 * Get previous Rotation Angle
 */
- (void)previuosRotationAngle:(NSString *)uid{
    
    NSLog(@"previuos Rotation Angle called");
    //return [flyer getImageRotationAngle:uid];
    
}
/**
 * Rotation Angle changed for layer, let the model know.
 */
- (void)rotationAngleChangedForLayer:(NSString *)uid rotationAngle:(CGFloat)rotationAngle {
    //Update Dictionary
    [flyer addImageRotationAngle:uid :rotationAngle];
}



/**
 * Frame changed for layer, let the model know.
 */
- (void)sendLayerToEditMode:(NSString *)uid  {
    // Set the given layer as current. If it is not already set.
    if ( ![self.currentLayer isEqualToString:uid] ) {
        
        // Make sure we hide the keyboard.
        [lastTextView resignFirstResponder];
        [lastTextView removeFromSuperview];
        lastTextView = nil;
        
        self.currentLayer = uid;
        
        // Edit the current layer.
        [self editCurrentLayer];
    } else if ( [flyer getText:self.currentLayer] != nil ) {
        // If the current layer is a text layer, and its been tapped
        // again then edit the text.
        
        // Get the type of layer
        NSString *type = [flyer getLayerType:currentLayer];
        //Checking if layer in clip art,we do not open text editing mood
        if( ![type isEqualToString:FLYER_LAYER_CLIP_ART] ){
            [self callWrite];
        }
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

- (void)toggleImageViewInteraction {
    
    // If the toolbar is hidden, show it.
    if ( playerToolBar.hidden ) {
        [self.flyimgView bringSubviewToFront:playerToolBar];
        [playerToolBar setHidden:NO];
    } else {
        [playerToolBar setHidden:YES];
    }
    
}

#pragma mark - Bring layer to front
/**
 * A layer needs to be brought to the front.
 * @updateSv: YES means reinit layers scrollivew
 * @oldUid: oldLayerid
 * @uid: layerid
 */
-(void)bringLayerToFrontCf:(NSString *)oldUid new:(NSString *)uid updateSv:(BOOL)updateSv{
    
    // Should we update the current layer?
    if ( [currentLayer isEqualToString:oldUid] ) {
        currentLayer = uid;
    }
    
    [self.flyer updateLayerKey:oldUid newKey:uid];
    
    // Only update layers if we are not editing any layer.
    if ( [currentLayer isEqualToString:@""] && !(self.flyimgView.zoomedIn) && updateSv) {
        [self addAllLayersIntoScrollView];
    }
    [self bringNotEditableLayersToFront:@"call from bringLayerToFrontCf"];
}

-(void)bringThisLayerToFront:(NSString *)layerId{
    [self.flyimgView bringLayerToFrontFiv:[self.flyimgView.layers objectForKey:layerId] bypassIsFront:YES updateSv:NO];
}

/**
  * Keep non editable layer on top
 */
-(void)bringNotEditableLayersToFront:(NSString *)callFrom{

    
    NSArray *flyerPiecesKeys = [flyer allKeys];
    
    // we need to loop layers in revers order because first non editable layer should be on top
    int i = (int)flyerPiecesKeys.count;
    while ( i > 0) {
        i--;
        //Getting Layers Detail from Master Dictionary
        NSMutableDictionary *dic = [flyer getLayerFromMaster:[flyerPiecesKeys objectAtIndex:i]];

        if( [[dic objectForKey:@"isEditable"]  isEqual: @"NO"] ){
            UIView *view = [self.flyimgView.layers objectForKey:[flyerPiecesKeys objectAtIndex:i]];
            [self.flyimgView bringSubviewToFront:view];
        }
    }
    
}

#pragma mark - Undo Implementation

-(void)undoFlyer{
    if( !(flyimgView.zoomedIn) ) {
        
        //Here we remove Borders from layer if user touch any layer
        [self.flyimgView layerStoppedEditing:currentLayer];
        
        //Here we take Snap shot of Flyer and
        //Flyer Add to Gallery if user allow to Access there photos
        [flyer setUpdatedSnapshotWithImage:[self getFlyerSnapShot]];
        
        //First we Save Current flyer in history,
        //if we didn't do this here, so when we undo, it will back to 2 steps back.
        [flyer saveFlyer];
        
        //Add Flyer in History if any Change Exists
        [flyer addToHistory];
        
        //Here we send Request to Model for Move Back
        [flyer replaceFromHistory];
        
        //set Undo Bar Button Status
        [self setUndoStatus];
        
        //Here we Re-Initialize Flyer Instance
        NSString* currentPath  =   [[NSFileManager defaultManager] currentDirectoryPath];
        self.flyer = [[Flyer alloc]initWithPath:currentPath setDirectory:YES];

        // Remove all sub views
        [self.flyimgView removeAllLayers];
        
        self.flyimgView.addUiImgForDrawingLayer = YES; //AFTER removing all layer set it yes for drawing layers
        
        [self setWaterMarkLayerPosition];
        
        //Here we Render Flyer
        [self renderFlyer];
        self.flyimgView.addUiImgForDrawingLayer = NO; // After rendering all layers set it no
        
        //Here we Load Current Layer in ScrollView
        [self addAllLayersIntoScrollView];
        
        [Flurry logEvent:@"Undone"];
    }    
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
    
    if ( fileList.count >= 2 ) {
        [rightUndoBarButton setEnabled:YES];
        
    } else {
        [rightUndoBarButton setEnabled:NO];
    }
    
}

//When user pressed done button
-(void)callAddMoreLayers {

    [self deleteEmptyTextCliptartEmoticonDrawingLayer];
    
    //Empty Layer Delete
    [self deSelectPreviousLayer];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];
    
    NSString *title = [flyer getFlyerTitle];
    
    if ( [title isEqualToString:@""] ) {
        label.text = APP_NAME;
    } else {
        label.text = title;
    }
    self.navigationItem.titleView = label;
    
    [self addButtonsInRightNavigation:@"callAddMoreLayers"];
    
    [self addBottomTabs:libFlyer];
    
    //Set here Un-Selected State of HIGHT & WIDTH Buttons IF selected
    [widthTabButton setSelected:NO];
    [heightTabButton setSelected:NO];
    
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
    [self addAllLayersIntoScrollView];
    [UIView commitAnimations];
    //End Animation
    
    currentLayer = @"";    
    [self bringNotEditableLayersToFront:@"call from callAddMoreLayers"];
}

#pragma mark -  Share Flyer
/*
 * HERE WE SHARE FLYER TO SOCIAL NETWORKS
 */
-(void)share {
    
    sharingPannelIsHidden = NO;
    
    // Disable  Buttons
    rightUndoBarButton.enabled = NO;
    shareButton.enabled = NO;
    
    backButton.enabled = NO;
    helpButton.enabled = NO;
    
    [self showLoadingIndicator];

    //Here we remove Borders from layer if user touch any layer
    [self.flyimgView layerStoppedEditing:currentLayer];
    
    if( [flyer isSaveRequired] == YES ) {
        saveToGallaryReqBeforeSharing = YES;
        
        // Save flyer to disk //
        [flyer saveFlyer]; //
        
        // Make a history entry if needed.
        [flyer addToHistory];
        
        //here we keep the merging vido path
        [flyer isVideoMergeProcessRequired];
        
        //Here we Merge Video for Sharing
        if ([flyer isVideoFlyer]) {

            // Set all share options status to 0, i.e. this flyer never shared
            [flyer resetAllButtonStatus];
            // Set saveButton status to 0, i.e. this flyer not saved
            [flyer setSaveButtonStatus:0];

            //Background Thread
//            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            dispatch_async( dispatch_get_main_queue(), ^{
                //Here we Merge All Layers in Video File
                [self videoMergeProcess];
            });

        } else{
            //Here we take Snap shot of Flyer and
            //Flyer Add to Gallery if user allow to Access there photos
            [flyer setUpdatedSnapshotWithImage:[self getFlyerSnapShot]];
            self.flyer.saveInGallaryRequired = 1;
        }
    }
    
    //Background Thread
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        /* // Remove full screen add when user going to share
         if ( [[PFUser currentUser] sessionToken] ) {
            if ( [self.interstitialAdd isReady]  && ![self.interstitialAdd hasBeenUsed] ) {
                
                dispatch_async( dispatch_get_main_queue(), ^{
                    [self.interstitialAdd presentFromRootViewController:self];
                });
                return;
            }
        }
         */
        
        //If pennel didn't open [ and return-ed ] then open the sharing pannel
        dispatch_async( dispatch_get_main_queue(), ^{
            //Here we Open Share Panel for Share Flyer
            [self openPanel];
        });
    });
}

/*
 * Here we Open InAppPurchase Panel
 */
-(void)openInAppPanel {
    
    if( IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ){
        inappviewcontroller = [[InAppViewController alloc] initWithNibName:@"InAppViewController" bundle:nil];
    }else {
        inappviewcontroller = [[InAppViewController alloc] initWithNibName:@"InAppViewController-iPhone4" bundle:nil];
    }
    [self presentViewController:inappviewcontroller animated:YES completion:nil];
    [inappviewcontroller requestProduct];
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
            if ( IS_IPHONE_5 || IS_IPHONE_4) {
            shareviewcontroller = [[ShareViewController alloc] initWithNibName:@"ShareVideoViewController" bundle:nil];
            }else if ( IS_IPHONE_6 || IS_IPHONE_6_PLUS ) {
                shareviewcontroller = [[ShareViewController alloc] initWithNibName:@"ShareVideoViewController-iPhone6" bundle:nil];
            }
            
        } else {
            saveToGallaryReqBeforeSharing = NO;
            if ( IS_IPHONE_5 || IS_IPHONE_4) {
                shareviewcontroller = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
            }else if ( IS_IPHONE_6  || IS_IPHONE_6_PLUS ) {
                shareviewcontroller = [[ShareViewController alloc] initWithNibName:@"ShareViewController-iPhone6" bundle:nil];
            }
            
        }
        shareviewcontroller.cfController = self;
        
        sharePanel = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.origin.y, 320,400 )];
        if ( IS_IPHONE_6) {
            sharePanel = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.origin.y, 340,350 )];
        }else if ( IS_IPHONE_6_PLUS){
            sharePanel = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.origin.y, 400,600 )];
        }
        
        sharePanel.backgroundColor = [UIColor redColor];
        sharePanel = shareviewcontroller.view;
        
        [self.view addSubview:sharePanel];
        
        sharePanel = shareviewcontroller.view;
        NSString *shareImagePath = [flyer getFlyerImage];
        UIImage *shareImage =  [self getFlyerSnapShot];
        
        //Here we Pass Param to Share Screen Which use for Sharing
        shareviewcontroller.selectedFlyerImage = shareImage;
        shareviewcontroller.flyer = self.flyer;
        shareviewcontroller.imageFileName = shareImagePath;
        shareviewcontroller.rightUndoBarButton = rightUndoBarButton;
        shareviewcontroller.shareButton = shareButton;
        shareviewcontroller.helpButton = helpButton;
        shareviewcontroller.backButton = backButton;
        shareviewcontroller.saveToGallaryReqBeforeSharing = saveToGallaryReqBeforeSharing;
        if( [shareviewcontroller.titleView.text isEqualToString:@"Untitled"] ) {
            shareviewcontroller.titleView.text = [flyer getFlyerTitle];
        }
        
        NSString *title = [flyer getFlyerTitle];
        if (![title isEqualToString:@""]) {
            shareviewcontroller.titleView.text = title;
        }
        
        NSString *description = [flyer getFlyerDescription];
        if (![description isEqualToString:@""]) {
            shareviewcontroller.descriptionView.text = description;
        }
        
        NSString *shareType  = [[NSUserDefaults standardUserDefaults] valueForKey:@"FlyerlyPublic"];
        
        if ([shareType isEqualToString:@"Private"]) {
            [shareviewcontroller.flyerShareType setSelected:YES];
        }
        
        if ([[flyer getShareType] isEqualToString:@"Private"]){
            [shareviewcontroller.flyerShareType setSelected:YES];
        }
        
        shareviewcontroller.selectedFlyerDescription = [flyer getFlyerDescription];
        shareviewcontroller.topTitleLabel = titleLabel;
        
        [shareviewcontroller.descriptionView setReturnKeyType:UIReturnKeyDone];
        shareviewcontroller.Yvalue = [NSString stringWithFormat:@"%f",self.view.frame.size.height];
        
        PFUser *user = [PFUser currentUser];
        if (user[@"appStarRate"])
            [shareviewcontroller setStarsofShareScreen:user[@"appStarRate"]];
        
        [user saveInBackground];
        [shareviewcontroller setSocialStatus];
        
        //Create Animation Here
        [sharePanel setFrame:CGRectMake(0, self.view.frame.size.height, 320,475 )];
        if ( IS_IPHONE_6) {
            [sharePanel setFrame:CGRectMake(0, self.view.frame.size.height, 375,350 )];
        }else if ( IS_IPHONE_6_PLUS){
            [sharePanel setFrame:CGRectMake(0, self.view.frame.size.height, 375,550 )];
        }
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4f];
        [sharePanel setFrame:CGRectMake(0, self.view.frame.size.height - 450, 320,505 )];
        if ( IS_IPHONE_6) {
            [sharePanel setFrame:CGRectMake(0, self.view.frame.size.height - 450, 375,450 )];
        }else if ( IS_IPHONE_6_PLUS){
            [sharePanel setFrame:CGRectMake(0, self.view.frame.size.height-550, 420,550 )];
        }
        [UIView commitAnimations];
        
        [self hideLoadingIndicator];
        
    } else {
        // Alert when user logged in as anonymous
        signInAlert = [[UIAlertView alloc] initWithTitle:@"Sign In"
                                                 message:@"The selected feature requires that you sign in. Would you like to register or sign in now?"
                                                delegate:self
                                       cancelButtonTitle:@"Later"
                                       otherButtonTitles:@"Sign In",nil];
        
        if ( !self.interstitialAdd.hasBeenUsed )
            [signInAlert show];
    }
    
}

-(NSString *) getTagForText:(NSString*)clipart {
    
    NSMutableDictionary *textLayer = [flyer getLayerFromMaster:currentLayer];
    NSString *textFamily = [textLayer objectForKey:@"fontname"];
    
    for(UIView *tempView in [fontsView subviews]) {
        if ([tempView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *) tempView;
            NSString *fontName = btn.titleLabel.font.familyName;
            
            if ( [textFamily isEqualToString:fontName] ) {
                return [NSString stringWithFormat: @"%ld", (long)btn.tag];
            }
        }
    }
    
    return [NSString stringWithFormat: @"%d", -1];
}

-(NSString *) getTagForClipart:(NSString*)clipart {
    
    for(UIView *tempView in [clipartsView subviews]) {
        if ([tempView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *) tempView;
            if ( [btn.currentTitle isEqualToString:clipart] ) {
                return [NSString stringWithFormat: @"%ld", (long)btn.tag];
            }
        }
    }
    return [NSString stringWithFormat: @"%d", -1];
}

-(NSString *) getTagForColor:(NSString*)layerType ofView:(ResourcesView*)view{
    
    [view dehighlightResource];
    
    NSString* tag = nil;
    
    NSMutableDictionary *textLayer;
    NSString *textColor;
    NSString *textWhiteColor;
    
    //Getting Last Info of Text Layer
    if (![currentLayer isEqualToString:@""]) {
        textLayer = [flyer getLayerFromMaster:currentLayer];
        textColor = [textLayer objectForKey:@"textcolor"];
        textWhiteColor = [textLayer objectForKey:@"textWhitecolor"];
    }
    
    NSArray *RGB = [textColor componentsSeparatedByString:@","];
    UIColor *fontColor = [UIColor colorWithRed:[RGB[0] floatValue] green:[RGB[1] floatValue] blue:[RGB[2] floatValue] alpha:1.0];
    
    for (int i = 1; i <=  [colorArray count] ; i++)
    {
        UIButton *color;
        if ([coloursArray[i-1] isKindOfClass:[UIButton class]]) {
            color = (UIButton *) coloursArray[i-1];
        }
        
        UIColor* buttonColor = color.backgroundColor;
        
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
            
            if ( [Flyer compareColor:buttonColor withColor:fontColor] ) {
                tag = [NSString stringWithFormat: @"%ld", (long)color.tag];
                break;
            }
        }
    }
    return tag;
}

-(NSString *) getTagForTextBorder:(NSString*)layerType ofView:(ResourcesView*)view{
    
    [view dehighlightResource];
    
    NSString* tag = nil;
    
    NSMutableDictionary *textLayer;
    NSString *textBorderColor;
    NSString *textBorderWhiteColor;
    
    //Getting Last Info of Text Layer
    if (![currentLayer isEqualToString:@""]) {
        textLayer = [flyer getLayerFromMaster:currentLayer];
        textBorderColor = [textLayer objectForKey:@"textbordercolor"];
        textBorderWhiteColor = [textLayer objectForKey:@"textborderWhite"];
    }
    
    NSArray *RGB = [textBorderColor componentsSeparatedByString:@","];
    UIColor *borderColor = [UIColor colorWithRed:[RGB[0] floatValue] green:[RGB[1] floatValue] blue:[RGB[2] floatValue] alpha:1.0];
    
    NSArray *bodersArray = textBordersView.subviews;
    int count = (int)(bodersArray.count)/3;
    
    int i=1,j=1;
    for (int index = 0; index < count; index++ ) {
        
        UIButton *border;
        if ([bodersArray[j] isKindOfClass:[UIButton class]]) {
            border = (UIButton *) bodersArray[j];
        }
        j = j+3;
        
        UIColor* buttonColor = border.backgroundColor;
        
        if ( [Flyer compareColor:buttonColor withColor:borderColor] ) {
            tag = [NSString stringWithFormat: @"%ld", ((border.tag) - 1)];
            break;
        }
        i++;
    }// Loop
    
    return tag;
}

-(NSString *) getTagForDrawingPattern:(NSString*)layerType ofView:(ResourcesView*)view{
    [view dehighlightResource];
    
    NSString* tag = nil;
    NSMutableDictionary *dic;
    NSString *line_type;
   
    dic = [flyer getLayerFromMaster:currentLayer];
    line_type = [dic objectForKey:@"line_type"];
    
    NSArray *drawingPatternsArrayInSV = drawingPatternsView.subviews;
    for (int i = 1; i <=  [drawingPatternsArrayInSV count] ; i++)
    {
        UIButton *lineBtn;
        if ([drawingPatternsArrayInSV[i-1] isKindOfClass:[UIButton class]]) {
            
            lineBtn = (UIButton *) drawingPatternsArrayInSV[i-1];
            
            if ( [DRAWING_PATTERNS_ARRAY[i-1] isEqualToString:line_type] ){
                tag = [NSString stringWithFormat: @"%ld", (long)lineBtn.tag];
                break;
            }
        }
    }
    return tag;
    
}

-(NSString *) getTagForSize:(NSString*)layerType ofView:(ResourcesView*)view{
    
    [view dehighlightResource];
    
    NSString* tag = nil;
    
    NSMutableDictionary *textLayer;
    NSString *textSize;
    
    //Getting Last Info of Text Layer
    if ( [layerType isEqualToString:FLYER_LAYER_DRAWING] ) {
        textLayer = [flyer getLayerFromMaster:currentLayer];
        textSize = [NSString stringWithFormat:@"%f", [[textLayer objectForKey:@"brush"] floatValue]];
    }
    else if (![currentLayer isEqualToString:@""]) {
        textLayer = [flyer getLayerFromMaster:currentLayer];
        textSize = [textLayer objectForKey:@"fontsize"];
    }
    
    if( [layerType isEqualToString:FLYER_LAYER_CLIP_ART] ){
        CustomLabel *lbl = [flyimgView.layers objectForKey:currentLayer];
        textSize = [NSString stringWithFormat:@"%f", roundf(([lbl newSize].width)/3.0)];
        
    } else if ( [layerType isEqualToString:FLYER_LAYER_EMOTICON] ) {
        
        ImageLayer *img = [flyimgView.layers objectForKey:currentLayer];
        // Because emoticons are always sized squrely, we are just considering width here, assuming height is the same
        textSize = [NSString stringWithFormat:@"%f", roundf(([img newSize].width)/1.5)];
        
    } else if ( [layerType isEqualToString:FLYER_LAYER_TEXT] ) {
        
        
    }

    NSArray *sizesArray = sizesView.subviews;
    for (int i = 1; i <=  [sizesArray count] ; i++) {
        
        UIButton *size;
        if ([sizesArray[i-1] isKindOfClass:[UIButton class]]) {
            size = (UIButton *) sizesArray[i-1];
        }
        
        NSString *btnTitleToBeHighlighted = [NSString stringWithFormat:@"%f", [size.currentTitle floatValue]];
        
        if ( [btnTitleToBeHighlighted isEqualToString:textSize] ){
            
            tag = [NSString stringWithFormat: @"%ld", (long)size.tag];
            break;
        }
    }
    return tag;
}


-(NSString*) getCurrentLayerTag:(NSString *)layerAttribute inView:(ResourcesView*)view {
    
    NSString* tag = nil;
    
    NSString* layerType = [flyer getLayerType:currentLayer];
    if( [layerType isEqualToString:FLYER_LAYER_CLIP_ART] ){
        
        tag = [self getTagForClipart:[flyer getText:currentLayer]];
        if ( [layerAttribute isEqualToString:LAYER_ATTRIBUTE_SIZE] ) {
            tag = [self getTagForSize:layerType ofView:view];
        }else if ( [layerAttribute isEqualToString:LAYER_ATTRIBUTE_COLOR] ) {
            tag = [self getTagForColor:layerType ofView:view];
        }
        
    } else if ( [layerType isEqualToString:FLYER_LAYER_EMOTICON] ) {
        
        tag = [flyer getImageTag:currentLayer];
        if ( [layerAttribute isEqualToString:LAYER_ATTRIBUTE_SIZE] ) {
            tag = [self getTagForSize:layerType ofView:view];
        }
        
    }else if ( [layerType isEqualToString:FLYER_LAYER_TEXT] ) {
        
        tag = [self getTagForText:currentLayer];
        if ( [layerAttribute isEqualToString:LAYER_ATTRIBUTE_SIZE] ) {
            tag = [self getTagForSize:layerType ofView:view];
        }else if ( [layerAttribute isEqualToString:LAYER_ATTRIBUTE_COLOR] ) {
            tag = [self getTagForColor:layerType ofView:view];
        }else if ( [layerAttribute isEqualToString:LAYER_ATTRIBUTE_BORDER] ) {
            tag = [self getTagForTextBorder:layerType ofView:view];
        }
        
        
    } else if ( [layerType isEqualToString:FLYER_LAYER_DRAWING] ) {
        
        tag = [self getTagForColor:layerType ofView:view];
        if ( [layerAttribute isEqualToString:LAYER_ATTRIBUTE_COLOR] ) {
            tag = [self getTagForColor:layerType ofView:view];
        } else if ( [layerAttribute isEqualToString:LAYER_ATTRIBUTE_SIZE] ) {
            tag = [self getTagForSize:layerType ofView:view];
        } else if ( [layerAttribute isEqualToString:LAYER_ATTRIBUTE_DRAWING_PATTERN] ) {
            tag = [self getTagForDrawingPattern:layerType ofView:view];
        }
    }
    return tag;
}

//show selected blue border around select size/border/color....etc
-(void) setSelectedItem:(NSString*)layerType inView:(ResourcesView*)view ofLayerAttribute:(NSString *)layerAttribute {
    
    NSString* tag = [self getCurrentLayerTag:layerAttribute inView:view];
    
    //If this layer is of type image AND there is a selected layer AND layer type is emoticon
    if ( tag != nil && ![tag isEqualToString:@""] && (![currentLayer isEqualToString:@""]) && ([[flyer getLayerType:currentLayer] isEqualToString:layerType]) ) {
        
        if ( [tag intValue] ) {
            // Highlight selected resource
            [view highlightResource:[tag intValue]];
            [layerScrollView scrollRectToVisible:[view getHighlightedResource].frame animated:NO];
        }
        
    } else {
        // If no emoticon is selected then scroll to top
        [layerScrollView scrollToTopAnimated:NO];
        [view dehighlightResource];
    }
}

/*
 * When we click on Arts Tab
 * This Method Manage Arts SubTabs
 */
-(IBAction)setArtsTabAction:(id) sender
{
    //add clipart sub menu in bottom
    [self addBottomTabs:libArts];
    
    //deselect previously selected buttons
    [clipArtTabButton setSelected:NO];
    [emoticonsTabButton setSelected:NO];
    [artsColorTabButton setSelected:NO];
    [drawingMenueButton setSelected:NO];
    [artsSizeTabButton setSelected:NO];
    
    //currently pressed button
    UIButton *selectedButton = (UIButton*)sender;
    
    if(selectedButton == clipArtTabButton) {
        
        //HERE WE SET ANIMATION
        [UIView animateWithDuration:0.4f
                         animations:^{
                             //Create ScrollView
                             if(IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS){
                                 
                                 // Delete SubViews from ScrollView and add Emoticons view
                                 [self deleteSubviewsFromScrollView];
                                 [layerScrollView addSubview:clipartsView];
                                 [layerScrollView setContentSize:CGSizeMake(320, clipartsView.size.height + 50 + bannerHeight)];
                                 
                                 [self setSelectedItem:FLYER_LAYER_CLIP_ART inView:clipartsView ofLayerAttribute:LAYER_ATTRIBUTE_IMAGE];
                                 
                             } else {
                                 
                                 // Delete SubViews from ScrollView and add Emoticons view
                                 [self deleteSubviewsFromScrollView];
                                 [layerScrollView addSubview:clipartsView];
                                 [layerScrollView setContentSize:CGSizeMake(clipartsView.size.width , clipartsView.size.height + 50 + bannerHeight)];
                                 
                                 [self setSelectedItem:FLYER_LAYER_CLIP_ART inView:clipartsView ofLayerAttribute:LAYER_ATTRIBUTE_IMAGE];
                             }
                         }
                         completion:^(BOOL finished){
                             [layerScrollView flashScrollIndicators];
                         }];
        //END ANIMATION
        
        //Add ContextView
        [self addScrollView:layerScrollView];
        
		[clipArtTabButton setSelected:YES];
	}
    else if(selectedButton == emoticonsTabButton) {
        
        //HERE WE SET ANIMATION
        [UIView animateWithDuration:0.4f
                         animations:^{
                             
                             if(IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS){
                                 // Delete SubViews from ScrollView and add Emoticons view
                                 [self deleteSubviewsFromScrollView];
                                 [layerScrollView addSubview:emoticonsView];
                                 [layerScrollView setContentSize:CGSizeMake(320, emoticonsView.size.height + bannerHeight)];
                                 
                                 [self setSelectedItem:FLYER_LAYER_EMOTICON inView:emoticonsView ofLayerAttribute:LAYER_ATTRIBUTE_IMAGE];
                                 
                             } else {
                                 
                                 // Delete SubViews from ScrollView and add Emoticons view
                                 [self deleteSubviewsFromScrollView];
                                 [layerScrollView addSubview:emoticonsView];
                                 [layerScrollView setContentSize:CGSizeMake(emoticonsView.size.width , emoticonsView.size.height + bannerHeight)];
                                 
                                 [self setSelectedItem:FLYER_LAYER_EMOTICON inView:emoticonsView ofLayerAttribute:LAYER_ATTRIBUTE_IMAGE];
                             }
                         }
                         completion:^(BOOL finished){
                             [layerScrollView flashScrollIndicators];
                         }];
        //END ANIMATION
        //Add ContextView
        [self addScrollView:layerScrollView];
        [emoticonsTabButton setSelected:YES];
        
	} else if(selectedButton == artsColorTabButton) {
        // Set the type
        if ( [[flyer getLayerType:currentLayer] isEqualToString:FLYER_LAYER_EMOTICON] ) {
            
            _addMoreLayerOrSaveFlyerLabel.alpha = 1;
            _addMoreLayerOrSaveFlyerLabel.text = @"COLORS CANNOT BE APPLIED ON EMOTICONS";
            
        }else {
            //HERE WE SET ANIMATION
            [UIView animateWithDuration:0.4f
                             animations:^{
                                 //Create ScrollView
                                 [self addColorsInSubView];
                                 [layerScrollView setContentSize:CGSizeMake(colorsView.size.width , colorsView.size.height + bannerHeight)];
                             }
                             completion:^(BOOL finished){
                                 [layerScrollView flashScrollIndicators];
                             }];
            //END ANIMATION
            
            //Add ContextView
            [self addScrollView:layerScrollView];
            [artsColorTabButton setSelected:YES];
        }
    }
    else if(selectedButton == artsSizeTabButton)
	{
        
        //HERE WE SET ANIMATION
        [UIView animateWithDuration:0.4f
                         animations:^{
                             //Create ScrollView
                             // [self addArtsSizesInSubView];
                             [self addSizeInSubView];
                             [layerScrollView setContentSize:CGSizeMake(sizesView.size.width , sizesView.size.height + bannerHeight)];
                         }
                         completion:^(BOOL finished){
                             [layerScrollView flashScrollIndicators];
                         }];
        //END ANIMATION
        
        //Add ContextView
        [self addScrollView:layerScrollView];
        
		[artsSizeTabButton setSelected:YES];
	}
    else if(selectedButton == drawingMenueButton ){
        //for drawing we are doing all(add/edit) work in setAddMoreLayerTabAction
    }
}

#pragma mark -  Bottom Tabs Context
/*
 * When we click on Text Tab
 * This Method Manage Text SubTabs
 */
-(IBAction)setStyleTabAction:(id) sender {
    
    [self addBottomTabs:libText];
    
    [fontTabButton setSelected:NO];
    [colorTabButton setSelected:NO];
    [sizeTabButton setSelected:NO];
    [fontBorderTabButton setSelected:NO];
    [fontEditButton setSelected:NO];
    
    UIButton *selectedButton = (UIButton*)sender;
	
    if(selectedButton == fontTabButton) {
        //HERE WE SET ANIMATION
        [UIView animateWithDuration:0.4f
                         animations:^{
                             //Create ScrollView
                             if(IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS){
                                 
                                 //Delete SubViews from ScrollView
                                 [self deleteSubviewsFromScrollView];
                                 [layerScrollView addSubview:fontsView];
                                 [layerScrollView setContentSize:CGSizeMake(320, fontsView.size.height + bannerHeight)];
                                 
                                 [self setSelectedItem:FLYER_LAYER_TEXT inView:fontsView ofLayerAttribute:LAYER_ATTRIBUTE_FONT];
                                 
                             } else {
                                 
                                 //Delete SubViews from ScrollView
                                 [self deleteSubviewsFromScrollView];
                                 [layerScrollView addSubview:fontsView];
                                 [layerScrollView setContentSize:CGSizeMake(fontsView.size.width , fontsView.size.height)];
                                 
                                 [self setSelectedItem:FLYER_LAYER_TEXT inView:fontsView ofLayerAttribute:LAYER_ATTRIBUTE_FONT];
                             }
                             
                         }
                         completion:^(BOOL finished){
                             [layerScrollView flashScrollIndicators];
                         }];
        //END ANIMATION
        
        //Add ContextView
        [self addScrollView:layerScrollView];
        
		[fontTabButton setSelected:YES];
	}
	else if(selectedButton == colorTabButton) {
        
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
	else if(selectedButton == sizeTabButton) {
        
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
	else if(selectedButton == fontBorderTabButton) {
        
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
    else if(selectedButton == fontEditButton) {
        [fontEditButton setSelected:YES];
        [self callWrite];
	}
}

/*
 * When we click on Background Tab
 * This Method Manage Background SubTabs
 */
-(IBAction)setlibBackgroundTabAction:(id)sender {
    UIButton *selectedButton = (UIButton*)sender;
    
    //Un Selected State of Buttons
    [backtemplates setSelected:NO];
    [flyerBorder setSelected:NO];
    [giphyBgBtn setSelected:NO];
    
    if( selectedButton == backtemplates ) {
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
    else if(selectedButton == cameraTakePhoto) {
        
        [self openCustomCamera:YES];
        _videoLabel.alpha = 1;
        
        _addMoreLayerOrSaveFlyerLabel.alpha = 0;
        _takeOrAddPhotoLabel.alpha = 0;

    }
    else if(selectedButton == cameraRoll) {
        
        //HERE WE CHECK USER DID ALLOWED TO ACCESS PHOTO library
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusRestricted || [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
            
            NSString *msg;
            msg = [NSString stringWithFormat:@"%@ does not access to your photo album. To enable access goto the Setting app >> Privacy >> Photos and enable %@", APP_NAME, APP_NAME] ;
            UIAlertView *photoAlert = [[UIAlertView alloc ] initWithTitle:@"" message: msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [photoAlert show];
            return;
        }
        
        [self loadCustomPhotoLibrary:NO];
        
        //Add ContextView
        _videoLabel.alpha = 1;
        
        _addMoreLayerOrSaveFlyerLabel.alpha = 0;
        _takeOrAddPhotoLabel.alpha = 0;
        
    }
    else if(selectedButton == flyerBorder) {
        
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
        
        [flyerBorder setSelected:YES];
    }
    else if(selectedButton == giphyBgBtn) {
        
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable) {
            [self showAlert:@"No internet available,please connect to the internet first" message:@""];
        } else {
            [self goToGiphyScreen];
        }
    }
}

// show message in alert
-(void)showAlert:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

// Go to Giphy screen
-(void)goToGiphyScreen{
    NSMutableDictionary *templateDictionary = [flyer getLayerFromMaster:@"Template"];
    [backgroundsView setHighlightedResourceTag:[[templateDictionary objectForKey:@"imageTag"] intValue]];
    [backgroundsView dehighlightResource];
    
    tasksAfterGiphySelect = @"goingToGiphy";
    GiphyViewController *giphyViewController = [[GiphyViewController alloc]initWithNibName:@"GiphyViewController" bundle:nil];
    giphyViewController.flyer = flyer;
    giphyViewController.tasksAfterGiphySelect = tasksAfterGiphySelect;
    [self.navigationController pushViewController:giphyViewController animated:YES];
}

/*
 * When we click on Photo Tab
 * This Method Manage Photo SubTabs
 */
-(IBAction)setlibPhotoTabAction:(id) sender{
    
    UIButton *selectedButton = (UIButton*)sender;
    
    
    if( selectedButton == cameraTabButton ) {
        imgPickerFlag = IMAGEPICKER_PHOTO;
        [self openCustomCamera:NO];
        
    }
    else if( selectedButton == photoTabButton ) {
        imgPickerFlag = IMAGEPICKER_PHOTO;
        
        //HERE WE CHECK USER DID ALLOWED TO ACESS PHOTO library
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusRestricted || [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
            
            NSString *msg;
            msg = [NSString stringWithFormat:@"%@ does not access to your photo album. To enable access goto the Setting app >> Privacy >> Photos and enable %@", APP_NAME, APP_NAME] ;
            UIAlertView *photoAlert = [[UIAlertView alloc ] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [photoAlert show];
            return;
            
        }
        
        [self loadCustomPhotoLibrary:NO];
    }
    else if( selectedButton == widthTabButton ) {
        if (widthTabButton.isSelected == YES) {
            
            //Set here Un-Selected
            [widthTabButton setSelected:NO];
            
        } else {
            //FOR PINCH
            [widthTabButton  setSelected:YES];
            [heightTabButton setSelected:NO];
            
        }
        
        self.flyimgView.widthIsSelected = YES;
        self.flyimgView.heightIsSelected = NO;
        
    }
    else if( selectedButton == heightTabButton ) {
        
        if (heightTabButton.isSelected == YES) {
            
            //Set here Un-Selected State
            [heightTabButton setSelected:NO];
            
        } else {
            //FOR PINCH
            [heightTabButton  setSelected:YES];
            [widthTabButton setSelected:NO];
        }
        
        self.flyimgView.widthIsSelected = NO;
        self.flyimgView.heightIsSelected = YES;
    }
}


/* Main Bottom Tab Botton Handler
 * When we click any Tab
 * This Method Manage SubTabs
 */
-(IBAction) setAddMoreLayerTabAction:(id) sender {
    
    if( flyimgView.zoomedIn )
    [self zoomEnd];
    
	UIButton *selectedButton = (UIButton*)sender;
    
    //Unselected All main menue buttons
    [addMoreFontTabButton setSelected:NO];
    [addMorePhotoTabButton setSelected:NO];
    [addArtsTabButton setSelected:NO];
    [addVideoTabButton setSelected:NO];
    [backgroundTabButton setSelected:NO];
    
	if(selectedButton == addMoreFontTabButton) {
        
        selectedAddMoreLayerTab = ADD_MORE_TEXTTAB;
        
        [addMoreFontTabButton setSelected:YES];
        
        if ([currentLayer isEqualToString:@""]) {
            isNewText = YES;
            currentLayer = [flyer addText];
            editButtonGlobal.uid = currentLayer;
        }
        [self callWrite];

	}
    else if(selectedButton == addMorePhotoTabButton) {
        selectedAddMoreLayerTab = ADD_MORE_PHOTOTAB;
        
        if ([currentLayer isEqualToString:@""]) {
            currentLayer = [flyer addImage];
            
            CGRect imageFrame;
            if ( IS_IPHONE_5 || IS_IPHONE_4) {
                imageFrame = CGRectMake(55,10,200,200);
            }else if ( IS_IPHONE_6){
                imageFrame = CGRectMake(90,10,200,200);
            }else if ( IS_IPHONE_6_PLUS){
                imageFrame = CGRectMake(100,10,200,200);
            }
            [flyer setImageFrame:currentLayer :imageFrame];
            NSMutableDictionary *dic = [flyer getLayerFromMaster:currentLayer];
            [self.flyimgView renderLayer:currentLayer layerDictionary:dic];
        }
        
        //Here we Highlight The ImageView
        [self.flyimgView layerIsBeingEdited:currentLayer];
        
        //Here we Add Some Text In ScrolView
        _takeOrAddPhotoLabel.alpha = 1;
        
        _addMoreLayerOrSaveFlyerLabel.alpha = 0;
        _videoLabel.alpha = 0;
	    
        [self choosePhoto];
		imgPickerFlag = IMAGEPICKER_PHOTO;
        [addMorePhotoTabButton setSelected:YES];
        
        [self bringNotEditableLayersToFront:@"call from setAddMoreLayerTabAction"];
	}
	else if(selectedButton == addArtsTabButton)
	{
        selectedAddMoreLayerTab = ADD_MORE_SYMBOLTAB;
        
        if ([currentLayer isEqualToString:@""]) {
            
            currentLayer = [flyer addClipArt];
            editButtonGlobal.uid = currentLayer;
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
        
        //Add Context
        [self addScrollView:layerScrollView];
        
        //Add ContextView
        [self addBottomTabs:libArts];
        
        // FORCE CLICK ON FIRST BUTTON OF addBottomTab, then it will auto select SET BOTTOM BAR
        [self setArtsTabAction:clipArtTabButton];
        
	}
	else if(selectedButton == addVideoTabButton) {
        
        userPurchases = [UserPurchases getInstance];
        userPurchases.delegate = self;
        
        if ( [userPurchases canCreateVideoFlyer] ) {
            
            [self openCustomCamera:YES];
            _videoLabel.alpha = 1;
            
            _addMoreLayerOrSaveFlyerLabel.alpha = 0;
            _takeOrAddPhotoLabel.alpha = 0;
            
            nbuCamera.isVideoFlyer = YES;
        }else {
            [self openInAppPanel];
        }
        
  	} else if (selectedButton == backgroundTabButton) {
        currentLayer = nil;
        
        NSMutableDictionary *templateDictionary = [flyer getLayerFromMaster:@"Template"];
        NSInteger *backgroundImageTag = [[templateDictionary objectForKey:@"imageTag"] intValue];
        
        [layerScrollView setContentSize:CGSizeMake(backgroundsView.frame.size.width, backgroundsView.frame.size.height + bannerHeight)];
        
        [self highlightAndScrollRect:backgroundImageTag inView:backgroundsView];
        
        [backgroundTabButton setSelected:YES];
        //Add right Bar button
        [self addDonetoRightBarBotton];
        
        //Add ContextView
        [self addBottomTabs:libBackground];
        
        [self setlibBackgroundTabAction:backtemplates];
        
    }
    else if( selectedButton == drawingMenueButton)  {
        [drawingMenueButton setSelected:YES];
        
        NSMutableDictionary *dic;
        
        // addDrawing layer case
        if ([currentLayer isEqualToString:@""]) {
            [self deSelectPreviousLayer];
            currentLayer = [flyer addDrawingImage:YES];
            dic = [flyer getLayerFromMaster:currentLayer];
            self.flyimgView.addUiImgForDrawingLayer    =   YES;
            [self.flyimgView renderLayer:currentLayer layerDictionary:dic];
            self.flyimgView.addUiImgForDrawingLayer    =   NO;//AFTER renderLayer set this flag is: YES
            dw_layer_save   =   NO;
            dw_isOldLayer   =   NO;
        }
        // editDrawing layer case
        else {
            dic = [flyer getLayerFromMaster:currentLayer];
            dw_layer_save   =   YES;
            dw_isOldLayer   =   YES;
        }
        
        //here we get ImageView
        self.tempDrawImage   = [self.flyimgView.layers objectForKey:currentLayer];

        // Hook event of Gesture for moving layers ------------------
        self.tempDrawImage.userInteractionEnabled = YES; // CAN receive touches
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drawingLayerMoved:)];
        [self.tempDrawImage addGestureRecognizer:panGesture];
        
        //Hook event end-----
        
        //Here we Highlight The ImageView
        [self.flyimgView layerIsBeingEdited:currentLayer];
        
        //HERE WE SET ANIMATION
        [UIView animateWithDuration:0.4f
                         animations:^{
                             //Create ScrollView
                             //[self addFlyerIconInSubView];
                         }
                         completion:^(BOOL finished){
                             [layerScrollView flashScrollIndicators];
                         }];
        
        //Add right Bar button
        [self addDonetoRightBarBotton];
        
        //Add Context
        [self addScrollView:layerScrollView];
        
        //Add ContextView
        [self addBottomTabs:libDrawing];
        
        // FORCE CLICK ON FIRST BUTTON OF drawingSubMenuButton, then it will auto select SET BOTTOM BAR
        [self drawingSetStyleTabAction:drawingPatternTabButton];
        
	}
}

/**
 * Hightlight a button and scroll to it in view
 */
-(void)highlightAndScrollRect:(NSInteger *)btnTag inView:(ResourcesView *)viewForHighlight {
    if ( btnTag ) {
        [viewForHighlight highlightResource:btnTag];
        UIButton *highLight = [viewForHighlight getHighlightedResource];
        
        [layerScrollView scrollRectToVisible:highLight.frame animated:YES];
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
    NSString *uniqueId = [Flyer getUniqueId];
    
    NSString *imageFolderPath = [NSString stringWithFormat:@"%@/%@.%@", FolderPath, uniqueId, IMAGETYPE];
    
    dicPath = [dicPath stringByAppendingString:[NSString stringWithFormat:@"/%@.%@", uniqueId, IMAGETYPE]];
    
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
        FolderPath = [NSString stringWithFormat:@"%@/Symbol", currentpath];
        dicPath = @"Symbol";
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
        NSString *uniqueId = [Flyer getUniqueId];
        
        imageFolderPath = [NSString stringWithFormat:@"%@/%@.%@", FolderPath, uniqueId, IMAGETYPE];
        dicPath = [dicPath stringByAppendingString:[NSString stringWithFormat:@"/%@.%@", uniqueId, IMAGETYPE]];
        
        //Getting Image From Bundle
        existImagePath =[[NSBundle mainBundle] pathForResource:imgName ofType:@"png"];
        
    }
    
    UIImage *realImage =  [UIImage imageWithContentsOfFile:existImagePath];
    NSData *imgData = UIImagePNGRepresentation(realImage);
    
    //Create a Image Copy to Current Flyer Folder
    [[NSFileManager defaultManager] createFileAtPath:imageFolderPath contents:imgData attributes:nil];
    
    
    return dicPath;
    
}

-(NSString *)getEmoticon:(NSString *) imgName {
    
    // Create Symbol direcrory if not created
    NSString* currentpath  =   [[NSFileManager defaultManager] currentDirectoryPath];
    
    NSString *FolderPath = [NSString stringWithFormat:@"%@/Symbol", currentpath];
    NSString *dicPath = @"Symbol";
    
    //Create Unique Id for Image
    NSString *uniqueId = [Flyer getUniqueId];
    
    NSString *imageFolderPath = [NSString stringWithFormat:@"%@/%@.%@", FolderPath, uniqueId, IMAGETYPE];
    dicPath = [dicPath stringByAppendingString:[NSString stringWithFormat:@"/%@.%@", uniqueId, IMAGETYPE]];
    
    //Getting Image From Bundle
    NSString *existImagePath =[[NSBundle mainBundle] pathForResource:imgName ofType:@"png"];
    
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
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyxWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- ( void )productSuccesfullyPurchased: (NSString *)productId {
    appearingViewAfterInAppHide = YES;
    [self loadXibsAfterInAppCheck:YES againAddInSubViews:YES];
    if ( [userPurchases canShowAd] == NO ) {
        bannerHeight = 0;
        [self removeBAnnerAdd:YES];
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
        
        UserPurchases *userPurchases_ = [UserPurchases getInstance];
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
    
    userPurchases = [UserPurchases getInstance];
    userPurchases.delegate = self;

    if( [userPurchases checkKeyExistsInPurchases: IN_APP_ID_ALL_DESIGN] ){

        [self premiumBtnHideAfterCheck:@"ALL"];
        [inappviewcontroller.paidFeaturesTview reloadData];
    } else{
        //check for videos
        if ( [userPurchases canCreateVideoFlyer] ) {
        
            [self premiumBtnHideAfterCheck: IN_APP_ID_UNLOCK_VIDEO];
            [inappviewcontroller.paidFeaturesTview reloadData];
            
        }
        
        //check for icons
        if([userPurchases checkKeyExistsInPurchases: IN_APP_ID_ICON_BUNDLE] ){
                [self premiumBtnHideAfterCheck: IN_APP_ID_ICON_BUNDLE];
        }
        
        [inappviewcontroller.paidFeaturesTview reloadData];
    }
    
    if ( [sharePanel isHidden] && inappviewcontroller != nil &&
        ![[self presentedViewController] isKindOfClass:[InAppViewController class]])
    {
        if([productIdentifier length] == 0){
            [self presentViewController:inappviewcontroller animated:YES completion:nil];
        }
    }

    
}

-(void)enableHome:(BOOL)enable{
    sharePanel.hidden = enable;
    sharingPannelIsHidden = enable;
    [self enableNavigation:enable];
}
-(void)enableNavigation:(BOOL)enable{
    [backButton setEnabled:enable];
    [helpButton setEnabled:enable];
    [shareButton setEnabled:enable];
    [rightUndoBarButton setEnabled:enable];
}


//return free space in in mb
-(unsigned long long)getFreeDiskspace {
    unsigned long long totalSpace = 0;
    unsigned long long totalFreeSpace = 0;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = (([fileSystemSizeInBytes unsignedLongLongValue]/1024ll)/1024ll);
        totalFreeSpace = (([freeFileSystemSizeInBytes unsignedLongLongValue]/1024ll)/1024ll);
        
        NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.",totalSpace , totalFreeSpace);
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    
    return totalFreeSpace;
}

// If 50mb space not availble then go to Back
-(void) isDiskSpaceAvailable {
    
    unsigned long long totalFreeSpace = [self getFreeDiskspace];
    
    if( totalFreeSpace < 50 ){
        spaceUnavailableAlert = [[UIAlertView alloc] initWithTitle:@"Not Enough Storage"
                                                           message:@"Please clear storage space in your device then try again"
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        
        [spaceUnavailableAlert show];
    }
}

- (void)printFlyer {
    
    if(IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS){
        printViewController = [[PrintViewController alloc] initWithNibName:@"PrintViewController" bundle:nil];
    }else {
        printViewController = [[PrintViewController alloc] initWithNibName:@"PrintViewController-iPhone4" bundle:nil];
    }
    
    printViewController.flyer = self.flyer;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didDismissPrintViewController)
                                                 name:@"PrintViewControllerDismissed"
                                               object:nil];
    [self presentViewController:printViewController animated:NO completion:nil];
}


-(void)didDismissPrintViewController {
    
    InviteForPrint *inviteForPrint = [[InviteForPrint alloc]initWithNibName:@"InviteForPrint" bundle:nil];
    inviteForPrint.flyer = self.flyer;
	[self.navigationController pushViewController:inviteForPrint animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PrintViewControllerDismissed" object:nil];
}


#pragma mark - Drawing Methods
-(IBAction)selectDrawingLine:(id)sender
{
	int  i=1;
	UIButton *view = sender;
    
	for(UIView *tempView  in [drawingPatternsView subviews]) {
        //CHECK UIIMAGEVIEW BECAUSE SCROLL VIEW HAVE ADDITIONAL
        //SUBVIEWS OF UIIMAGEVIEW FOR FLASH INDICATORS
        if (![tempView isKindOfClass:[UIImageView class]]) {
            
            if(tempView == view)
            {
                //Here we set line
                [self setDrawingLine:DRAWING_PATTERNS_ARRAY[i-1] updateDic:YES];
                
                //Handling Select Unselect
                [self setSelectedItem:FLYER_LAYER_DRAWING inView:drawingPatternsView ofLayerAttribute:LAYER_ATTRIBUTE_DRAWING_PATTERN];
            }
            i++;
        }// uiImageView Found
        
	}// Loop
}

-(void)addDrawingPatternsInSubView {
    
    [self deleteSubviewsFromScrollView];

    [layerScrollView addSubview:drawingPatternsView];
    [layerScrollView setContentSize:CGSizeMake(drawingPatternsView.frame.size.width, [drawingPatternsView bounds].size.height + bannerHeight)];
    [self setSelectedItem:FLYER_LAYER_DRAWING inView:drawingPatternsView ofLayerAttribute:LAYER_ATTRIBUTE_DRAWING_PATTERN];
}

-(void) setLabelsAfterXibsLoad {
    for(UIView *tempView in [drawingEraserMsgView subviews]) {
        if ([tempView isKindOfClass:[UITextView class]]) {
            UITextView *txtView = (UITextView *) tempView;
            if ( txtView.tag == 1 ) {
                drawingEraserMsg    =   (UITextView *) tempView;
            }
        }
    }
}
-(void)addEraserMsgInSubViewFor:msgFor {
    
    if( [msgFor isEqualToString:DRAWING_MSG_4_COLOR] || [msgFor isEqualToString:DRAWING_MSG_4_ERASER] ) {
        [self deleteSubviewsFromScrollView];
        [drawingEraserMsg setFont:[UIFont fontWithName:@"Signika-Semibold" size:16]];
        drawingEraserMsg.textColor = [UIColor grayColor];
        drawingEraserMsg.text   = @"NOTE: ERASER CAN ONLY BE APPLIED ON SELECTED DRAWING LAYER.";
        if( [msgFor isEqualToString:DRAWING_MSG_4_COLOR])
        drawingEraserMsg.text   = @"COLORS CANNOT BE APPLIED ON ERASER";
        
        [layerScrollView addSubview:drawingEraserMsgView];
        [layerScrollView setContentSize:CGSizeMake(drawingEraserMsgView.frame.size.width, [drawingEraserMsgView bounds].size.height + bannerHeight)];
    }
}


/*
 * Add Drawing styles(line,dotted,dashed ..etc) in scroll views
 */
-(void)addDrawingInSubView{
    
    //DELETE SUBVIEWS
    [self deleteSubviewsFromScrollView];
    
    CGFloat curXLoc = 0;
    CGFloat curYLoc = 5;
    int increment = 5;
    
    if(IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS){
        curXLoc = 13;
        curYLoc = 10;
        increment = 8;
    }
    
    // NSMutableDictionary *textLayer = [flyer getLayerFromMaster:currentLayer];
    
    // Load sizes xib asynchronously
    dispatch_async( dispatch_get_main_queue(), ^{
        
        if(IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS){
            if( IS_IPHONE_6_PLUS ){
                drawingView.frame = CGRectMake((layerScrollView.frame.origin.x+18), layerScrollView.frame.origin.y, drawingView.size.width, drawingView.size.height);
            }
            [layerScrollView addSubview:drawingView];
            [layerScrollView setContentSize:CGSizeMake(320, curYLoc + heightValue + bannerHeight)];
            
        } else {
            [layerScrollView addSubview:drawingView];
            [layerScrollView setContentSize:CGSizeMake(drawingView.frame.size.width, [layerScrollView bounds].size.height + bannerHeight)];
        }
        
        NSArray *sizesArray = drawingView.subviews;
        for (int i = 1; i <=  3 ; i++) {
            
            UIButton *size;
            if ([sizesArray[i-1] isKindOfClass:[UIButton class]]) {
                size = (UIButton *) sizesArray[i-1];
            }
            
            NSString *sizeValue =SIZE_ARRAY[(i-1)];
            [size setTitle:sizeValue forState:UIControlStateNormal];
        }
    });
}

-(IBAction)addDrawingLayer:(id) sender {
    
    [self deleteEmptyTextCliptartEmoticonDrawingLayer];
    
    //reSet currentLayer for new drawing layer
    currentLayer = @"";
    
    //show drawing layer menu
    [self setAddMoreLayerTabAction:drawingMenueButton];
}

-(void)editDrawingLayer{
    //show drawing layer menu
    [self setAddMoreLayerTabAction:drawingMenueButton];
}

#pragma mark -  DRAWING FUNCTIONS
/*
 * When we click on Drawing Tab
 * This Method Manage Drawing SubTabs
 */
-(IBAction)drawingSetStyleTabAction:(id) sender
{
    //unselect drawing sub menu's
    [drawingPatternTabButton setSelected:NO];
    [drawingColorTabButton setSelected:NO];
    [drawingSizeTabButton setSelected:NO];
    [drawingEraserTabButton setSelected:NO];
    
    
    NSMutableDictionary *dic = [flyer getLayerFromMaster:currentLayer];
    
    UIButton *selectedButton = (UIButton*)sender;
	
    if(selectedButton == drawingPatternTabButton) {
        //HERE WE SET ANIMATION
        [UIView animateWithDuration:0.4f
                         animations:^{
                             //Create ScrollView
                             [self addDrawingPatternsInSubView];
                         }
                         completion:^(BOOL finished){
                             [layerScrollView flashScrollIndicators];
                         }];
        //END ANIMATION
        
        //Add ContextView
        [self addScrollView:layerScrollView];
        
        //Assign dic values(pattern,color,size) to class level variables
        [self setDrawingTools:dic callFrom:DRAWING_LAYER_MODE_NORMAL];
        
        //SHOW button selected
		[drawingPatternTabButton setSelected:YES];

	}
	else if(selectedButton == drawingColorTabButton) {
        if( [dw_drawingLayerMode  isEqual: DRAWING_LAYER_MODE_ERASER]){
            //HERE WE SET ANIMATION
            [UIView animateWithDuration:0.4f
                             animations:^{
                                 //Create ScrollView
                                 [self addEraserMsgInSubViewFor:DRAWING_MSG_4_COLOR];
                             }
                             completion:^(BOOL finished){
                                 [layerScrollView flashScrollIndicators];
                             }];
            //END ANIMATION
        } else{
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
            
            //Assign dic values(pattern,color,size) to class level variables
            [self setDrawingTools:dic callFrom:DRAWING_LAYER_MODE_NORMAL];
        }
        
        //Add ContextView
        [self addScrollView:layerScrollView];
        
        //SHOW button selected
        [drawingColorTabButton setSelected:YES];
        
	}
	else if(selectedButton == drawingSizeTabButton) {
        if( [dw_drawingLayerMode  isEqual: DRAWING_LAYER_MODE_ERASER]){
            
        } else {
            //Assign dic values(pattern,color,size) to class level variables
            [self setDrawingTools:dic callFrom:DRAWING_LAYER_MODE_NORMAL];
        }
        
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
        
        //SHOW button selected
		[drawingSizeTabButton setSelected:YES];

	}
    else if(selectedButton == drawingEraserTabButton) {
        //HERE WE SET ANIMATION
        [UIView animateWithDuration:0.4f
                         animations:^{
                             //Create ScrollView
                             [self addEraserMsgInSubViewFor:DRAWING_MSG_4_ERASER];
                         }
                         completion:^(BOOL finished){
                             [layerScrollView flashScrollIndicators];
                         }];
        //END ANIMATION
        
        //Assign dic values(pattern,color,size) to class level variables
        [self setDrawingTools:dic callFrom:DRAWING_LAYER_MODE_ERASER];
        
        //SHOW button selected
		[drawingEraserTabButton setSelected:YES];
	}
    
}

//Assign dic values(pattern,color,size) to class level variables
- (void)setDrawingTools:(NSMutableDictionary *)dic callFrom:(NSString *)callFrom {
    dw_drawingLayerMode = callFrom;
    
    //Get color(r,g,b) from dic, then assign them to class level red,green,blue
    NSArray *colorAry = [dic[@"textcolor"] componentsSeparatedByString: @", "];
    dw_red   = (CGFloat)[colorAry[0] floatValue];
    dw_green = (CGFloat)[colorAry[1] floatValue];
    dw_blue  = (CGFloat)[colorAry[2] floatValue];
    
    [self setDrawingBrushRadius:[[dic objectForKey:@"brush"] integerValue] updateDic:NO];
    [self setDrawingLine:[dic objectForKey:@"line_type"] updateDic:NO];
}

// Set value of rgb of drawing tool
- (void)setDrawingRGB:(UIColor *) color updateDic:(BOOL)updateDic {
    CGFloat alpha;
    //Getting RGB Color Code
    [color getRed:&dw_red green:&dw_green blue:&dw_blue alpha:&alpha];
    //[color getWhite:&white alpha:&alpha];
    
    if( updateDic ) {
        NSMutableDictionary *dic = [flyer getLayerFromMaster:currentLayer];
        [dic setObject: [NSString stringWithFormat:@"%f, %f, %f",dw_red,dw_green,dw_blue] forKey:@"textcolor"];
        [flyer.masterLayers setValue:dic forKey:currentLayer];
    }
}

// Set value brush radius
- (void)setDrawingBrushRadius:(NSInteger)brushRadiusSize  updateDic:(BOOL)updateDic {
    dw_brush = (CGFloat)brushRadiusSize;
    
    if( updateDic ) {
        NSMutableDictionary *dic = [flyer getLayerFromMaster:currentLayer];
        [dic setObject:[NSString stringWithFormat:@"%f",dw_brush] forKey:@"brush"];
        [flyer.masterLayers setValue:dic forKey:currentLayer];
    }
}

// Set value of
- (void)setDrawingLine:(NSString *)lineType updateDic:(BOOL)updateDic {
    dw_brushType   =  lineType;
    
    if( updateDic ) {
        NSMutableDictionary *dic = [flyer getLayerFromMaster:currentLayer];
        [dic setObject:dw_brushType forKey:@"line_type"];
        [flyer.masterLayers setValue:dic forKey:currentLayer];
    }
}

-(CGFloat) distanceBtwPoints:(CGPoint)p1 p2:(CGPoint)p2 {
    CGFloat xDist = (p2.x - p1.x);
    CGFloat yDist = (p2.y - p1.y);
    return sqrt((xDist * xDist) + (yDist * yDist));
}
/**
 * When user starts drawing
 */
- (void)drawingLayerMoved:(UIPanGestureRecognizer *)recognizer {
    
    //MOVE START
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        dw_mouseSwiped = NO;
        dw_lastPoint = [recognizer locationInView:self.tempDrawImage];
        
        UIGraphicsBeginImageContext(self.tempDrawImage.frame.size);
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.tempDrawImage.frame.size.width, self.tempDrawImage.frame.size.height)];
        
    }
    //MOVING
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        dw_mouseSwiped = YES;
        CGPoint currentPoint = [recognizer locationInView:self.tempDrawImage];
        BOOL dw_addThisPointInLine  =   YES;
        
        
        if( ([dw_brushType  isEqual: DRAWING_DASHED_LINE] || [dw_brushType  isEqual: DRAWING_DOTTED_LINE]) && !([dw_drawingLayerMode isEqualToString:DRAWING_LAYER_MODE_ERASER]) ) {
            
            CGFloat dw_points_distance  = 0.0;
            dw_points_distance = [self distanceBtwPoints:currentPoint p2:dw_lastPoint];
            
            if( dw_points_distance < dw_brush)
            dw_addThisPointInLine  =   NO;
            
            if( !(dw_addThisPointInLine) ) {
                if( dw_points_distance > 30 && dw_brush < 50)
                dw_addThisPointInLine  =   YES;
                else if( dw_points_distance > 40 && dw_brush < 80)
                dw_addThisPointInLine  =   YES;
                else if( dw_points_distance > 50 && dw_brush < 100)
                dw_addThisPointInLine  =   YES;
            }
        }
        
        if( dw_addThisPointInLine ) {
            CGContextRef dw_context = UIGraphicsGetCurrentContext();
            
            if( [dw_brushType  isEqual: DRAWING_DOTTED_LINE] ) {
                CGContextSetLineCap(dw_context, kCGLineCapRound);
            }
            else if( [dw_brushType  isEqual: DRAWING_DASHED_LINE] ) {
                CGContextSetLineCap(dw_context, kCGLineCapSquare);
            }
            else if( [dw_brushType  isEqual: DRAWING_PLANE_LINE]  ) {
                CGContextSetLineCap(dw_context, kCGLineCapRound);
            }
            
            // ADD FEW SPACES B/W DOTS OF LINE
            if( [dw_brushType  isEqual: DRAWING_DASHED_LINE] || [dw_brushType  isEqual: DRAWING_DOTTED_LINE] ) {
                CGFloat dw_dash[] = {2,dw_brush*2,dw_brush,dw_brush/2};
                CGContextSetLineDash(dw_context, 0, dw_dash, 4);
            }
            
            //BRUSH WIDTH ( we have devided it on 3 )
            CGContextSetLineWidth(dw_context, (dw_brush/3));
            
            if( [dw_drawingLayerMode isEqualToString:DRAWING_LAYER_MODE_ERASER] ){
                //BRUSH CLEAR COLOR
                CGContextSetFillColorWithColor( dw_context, [UIColor clearColor].CGColor );
                //CLEAR DRAWING
                CGContextSetBlendMode(dw_context, kCGBlendModeClear);
            } else{
                // BRUSH RGB COLOR
                CGContextSetRGBStrokeColor(dw_context, dw_red, dw_green, dw_blue, dw_opacity);
                //NORMAL DRAWING
                CGContextSetBlendMode(dw_context,kCGBlendModeNormal);
            }
            
            CGContextMoveToPoint(dw_context, dw_lastPoint.x, dw_lastPoint.y);
            CGContextAddLineToPoint(dw_context, currentPoint.x, currentPoint.y);
            CGContextStrokePath(dw_context);

            //SAVE CURRENT MOVE INFO IN TEMP IMG
            self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
            
            //when it is not an empty drawing layer so save drawing layer
            dw_layer_save   =   YES;
            
            //SAVE CURRENT MOVE POINT AS dw_lastPoint
            dw_lastPoint = currentPoint;
        }
        
    }
    //MOVE END
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        UIGraphicsEndImageContext();
    }
}

-(void)deleteEmptyTextCliptartEmoticonDrawingLayer{
    NSMutableDictionary *dic    =   [self.flyer getLayerFromMaster:currentLayer];
    if( dic != nil) {
        NSString   *layerType  =  [dic objectForKey:@"type"];
        NSString   *text  = [dic objectForKey:@"text"];
        NSString   *image = [dic objectForKey:@"image"];
        
        if( [layerType isEqualToString:FLYER_LAYER_DRAWING] ) {
            [self saveDeleteDrawingLayerAfterEmptyCheck];
        }
        else{
            BOOL  deleteLayer = NO;
            if( (text == nil || [text  isEqual: @""]) && (image == nil || [image  isEqual: @""]) )
            deleteLayer = YES;
            
            if( deleteLayer  ){
                [flyer deleteLayer:currentLayer];
            }
        }
    }
}

-(void) saveDeleteDrawingLayerAfterEmptyCheck {
    //when it is not an empty drawing layer so save drawing layer
    if(dw_layer_save){
        // End of save flyer and drawing layer
        [self.flyimgView.layers setObject:self.tempDrawImage forKey:currentLayer];
        
        // Save drawing layer and flyer
        NSString *imgPath = [self getImagePathforPhoto:self.tempDrawImage.image];
        
        //Set Image to dictionary
        [self.flyer setImagePath:self.currentLayer ImgPath:imgPath];
    }
    else if( !(dw_isOldLayer) ){
        //if layer is not old layer(new layer) and user didn't perform any thing then delete that layer
        [flyer deleteLayer:currentLayer];
        currentLayer  = @"";
    }
    
    [self flushTempDrawImg:@"saveDeleteDrawingLayerAfterEmptyCheck"];
    
}
-(void) flushTempDrawImg:callFrom {
    dw_layer_save   =   NO;
    
    //disable drawing interaction
    self.tempDrawImage.userInteractionEnabled = NO;
    self.tempDrawImage  = nil;
}

#pragma mark - ZOOM FUNCTIONS
//set values at viewWillAppear
-(void)zoomInit{
    if( IS_IPHONE_4 ){
        [zoomScrollView removeFromSuperview];
        [zoomScreenShot removeFromSuperview];
        [zoomMagnifyingGlass removeFromSuperview];
        [zoomScreenShotForVideo removeFromSuperview];
    }
    else {
        zoomScrollView.backgroundColor = [UIColor clearColor];
        
        //on load time zooming is disabled
        flyimgView.zoomedIn = NO;
        
        //inject zoomScreenShotForVideo as a first layer in flyer
        [zoomScreenShotForVideo setFrame:flyimgView.frame];
        [flyimgView addSubview:zoomScreenShotForVideo];
        
        //disable scrolling in scrollView
        [zoomScrollView setScrollEnabled:NO];
        
        //hide zoom elements on init
        [self zoomElementsSetAlpha:0.0];
        
        //HOOK MOVE GESTURE ON SCREEN SHOT IMAGE
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(zoomMagnifyerMove:)];
        [zoomScreenShot addGestureRecognizer:panGesture];
        UITapGestureRecognizer *tapGesture =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomMagnifyerMoveOnTap:)];
        [zoomScreenShot addGestureRecognizer:tapGesture];
        
        zoomScrollView.minimumZoomScale = FLYER_ZOOM_MIN_SCALE;
        zoomScrollView.maximumZoomScale = FLYER_ZOOM_SET_SCALE;//FLYER_ZOOM_MAX_SCALE;
        
        // Gesture for resizing zommScrollView
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoomScrollViewOnPinch:)];
        [zoomScrollView addGestureRecognizer:pinchGesture];
        
        [zoomScrollView setContentSize:CGSizeMake(zoomScrollView.contentSize.width, zoomScrollView.frame.size.height + bannerHeight)];
    }
}

//when ever user try to pin the main scrollview then reset it with it zomm value
- (void)zoomScrollViewOnPinch:(UIGestureRecognizer *)sender {
    [zoomScrollView setZoomScale:FLYER_ZOOM_SET_SCALE];
}

// When user tap on zomm glass layer
- (IBAction)zoom:(id)sender {
    ( flyimgView.zoomedIn ) ? [self zoomEnd] : [self zoomStart];
}

//Start zoom
-(void)zoomStart {
    [self addButtonsInRightNavigation:@"zoomStart"];
    flyimgView.zoomedIn = YES;
    [self.playerView setAlpha:0];
    [self zoomElementsSetAlpha:1.0];
    
    [self zoomUpdateScreenshot];
    
    zoomScreenShot.userInteractionEnabled = YES;
    
    zoomScrollView.delegate = self;
    [zoomScrollView addSubview:flyimgView];

    [zoomScrollView setZoomScale:FLYER_ZOOM_SET_SCALE];

    //FOR TESTING SHOW RED RECT AROUND CURSOR
    [zoomScrollView setContentSize:CGSizeMake(flyimgView.frame.size.width, flyimgView.frame.size.height + bannerHeight)];

    // set buttons in right nav
    [self zoomAddLayerButtonsIntoScrollView:@"zoomStart"];
}

-(void)zoomUpdateScreenshot{
    if( self.flyimgView.zoomedIn ){
        
        CGSize size = [self getFlyerSizeOnScreen];
        CGFloat width = size.width;
        CGFloat height = size.height;
        
        if ( [flyer isVideoFlyer] ){
            [self videoPlay:NO repeat:NO];
            
            UIImage *videoImg = [flyer getVideoWithoutMergeSnapshot]; //get a framof video
            zoomScreenShot.image = [self getVideoWithMergeSnapshot:size videoFramImg:videoImg];

            //Video first fram snap short for bg of flyer
            zoomScreenShotForVideo.image = [self setSizeOfImage:videoImg size:size];
            zoomScreenShotForVideo.frame = CGRectMake(0, 0, width, height);
        }
        else{
            
            UIImage *flyerSnapshot = [self getFlyerSnapshotWithSize:size];
            zoomScreenShot.image = flyerSnapshot;
        }
    }
}

// reset size of image
-(UIImage *)setSizeOfImage:(UIImage *)image size:(CGSize)newSize {

    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void)zoomEnd {
    
    flyimgView.zoomedIn   =   NO;
    [self.playerView setAlpha:1];
    [self zoomElementsSetAlpha:0.0];
    
    zoomScreenShot.image         = nil;
    zoomScreenShotForVideo.image = nil;
    
    //[self.view addSubview:zoomScreenShotForVideo];
    [self.view addSubview:flyimgView];
    
    [zoomScrollView setZoomScale:zoomScrollView.minimumZoomScale];
    [self zoomAddLayerButtonsIntoScrollView:@"zoomEnd"];
    [self addButtonsInRightNavigation:@"zoomEnd"];
}

-(void)zoomElementsSetAlpha:(CGFloat)zoomAlpha{
    [zoomScreenShotForVideo setAlpha:zoomAlpha];
    [zoomScrollView setAlpha:zoomAlpha];
    [zoomScreenShot setAlpha:zoomAlpha];
    [zoomMagnifyingGlass setAlpha:zoomAlpha];
}

//WHEN USER MOVING MAGNIFYING GLASS
- (void)zoomMagnifyerMove:(UIPanGestureRecognizer *)recognizer {
    CGPoint magnifierCurLoc = [recognizer locationInView:self.zoomScreenShot];
    [self zoomMoveToPoint:magnifierCurLoc];
}
- (void)zoomMagnifyerMoveOnTap:(UITapGestureRecognizer *)recognizer {
    CGPoint magnifierCurLoc = [recognizer locationInView:self.zoomScreenShot];
    magnifierCurLoc.x += -20;
    magnifierCurLoc.y += -20;
    [self zoomMoveToPoint:magnifierCurLoc];
}

- (void)zoomMoveToPoint:(CGPoint) magnifierCurLoc{
    int x = magnifierCurLoc.x;
    int y = magnifierCurLoc.y;
    
    int x2 = floor( (x*100)/zoomScreenShot.size.width );
    int y2 = floor( (y*100)/zoomScreenShot.size.height);
    
    //CHANGE ZOOM SCOLLVIEW
    CGFloat xSv = x2, ySv = y2;
    if( ySv < 11)
    ySv = 11; //dont show gray background in top
    else if( ySv > 60)
    ySv = 60; //dont show gray background in bottom
    
    if( xSv < 1)
    xSv = 1;//dont show gray background in left
    else if( xSv > 50)
    xSv = 50; //dont show gray background in right
    
    //Logic of scrolling the zoom view a/c to magnifier postion on screenshot( % logic )
    xSv = ( flyimgView.size.width * xSv ) / 100;
    ySv = ( flyimgView.size.width * ySv ) / 100;
   
    CGRect recSv = CGRectMake(xSv, ySv, 10,10);
    [zoomScrollView scrollRectToVisible:recSv animated:YES];
    [zoomScrollView setContentOffset:CGPointMake(xSv, ySv) animated:YES];
    
    //CHANGE MAGNIFIER POSITION ON SCREEN SHORT
    CGFloat xMg = x, yMg = y, xMgE = 9, yMgE = -5;
    if( xMg < -9 ){
        xMg =  0;
        xMgE = 0;
    }
    else if( xMg > 82)
    xMg =  82;
    
    if( yMg < 0)
    yMg =   0;
    if( yMg > 95)
    yMg =  95;
    
    xMg  = xMg + zoomScreenShot.origin.x + xMgE;
    yMg  = yMg + zoomScreenShot.origin.y + yMgE;
    
    zoomMagnifyingGlass.frame  =  CGRectMake(xMg,yMg, zoomMagnifyingGlass.size.width, zoomMagnifyingGlass.size.height);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.flyimgView;
}

#pragma mark -  Watermark funcs
//Tasks after create new flyer
-(void)tasksOnCreateNewFlyer{
    isNewFlyer = YES;
}

- (void)inAppPanelDismissed {
    appearingViewAfterInAppHide = YES;
}

//When user perform action on watermark layer and has no complete design bundle then show in app panel
- (BOOL)wmCanPerformAction:(NSString *)uid{
    BOOL canPerformAct = YES;
    
    NSMutableDictionary *dic = [flyer getLayerFromMaster:uid];
    NSString* tempLayerType = [dic objectForKey:@"type"];
    if( [tempLayerType isEqualToString:FLYER_LAYER_WATER_MARK] ){
        //if layer type is watermark, then first check have permission of changing
        canPerformAct = NO;
        
        userPurchases = [UserPurchases getInstance];
        userPurchases.delegate = self;
        if ([[PFUser currentUser] sessionToken].length != 0) {
            //can move water mark layer when have valid subscription / IN_APP_ID_ALL_DESIGN
            if ( [userPurchases isSubscriptionValid] || [userPurchases haveProduct:IN_APP_ID_ALL_DESIGN] ) {
                canPerformAct = YES;
            }
        }
    }
    
    if( [tempLayerType isEqualToString:FLYER_LAYER_WATER_MARK]  && canPerformAct == NO ){
        currentLayer = @"";
        [self deSelectPreviousLayer];
        
        // Alert when user logged in as anonymous
        waterMarkPurchasingAlert = [[UIAlertView alloc] initWithTitle:@"Want to remove watermark?"
                                                 message:@"Purchase complete bundle."
                                                delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:@"OK",nil];
        
        
        
        [waterMarkPurchasingAlert show];
        
    }
    
    return canPerformAct;
}

/**
 * Get Visible size of flyer
 */
-(CGSize)getFlyerSizeOnScreen
{
    CGFloat width = flyerlyWidth/2;
    CGFloat height = flyerlyHeight/2;
    
    if ( IS_IPHONE_4 ){
        width = 310;
        height = 310;
    }
    else if ( IS_IPHONE_5 ){
        width = 310;
        height = 310;
    }
    else if ( IS_IPHONE_6 ){
        width = 363;
        height = 371;
    } else if ( IS_IPHONE_6_PLUS ){
        width = 401;
        height = 414;
    }
    
    CGSize size = CGSizeMake(width,height);
    return size;
}



/*
 LOAD XIB'S AFTER CHECKING USER HAS PAID USING IN-APP 
 CODITIONAL XIBS ARE
 1- FONT TYPES
 2- CLIP ART
 3- EMOTICONS
 4- VIDEO
 */
-(void)loadXibsAfterInAppCheck:(BOOL)checkAndCloseInAppPanel againAddInSubViews:(BOOL)againAddInSubViews{
    userPurchases = [UserPurchases getInstance];
    userPurchases.delegate = self;
    
    if ( [userPurchases canCreateVideoFlyer] ) {
        
        UIImage *buttonImage = [UIImage imageNamed:@"video_tab.png"];
        [addVideoTabButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        
        if( checkAndCloseInAppPanel ){
            [inappviewcontroller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    } else if( checkAndCloseInAppPanel ) {
        [inappviewcontroller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    if( againAddInSubViews ){
        //When user have complete design bundle or any subscription dont show the premium button
        if( [userPurchases haveProduct:IN_APP_ID_ALL_DESIGN] || [userPurchases isSubscriptionValid] ){
            [self premiumBtnHideAfterCheck:@"ALL"];
        }else if([userPurchases haveProduct: IN_APP_ID_ICON_BUNDLE] ) {
            [self premiumBtnHideAfterCheck: IN_APP_ID_ICON_BUNDLE];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//Hide premium button from view when have purchases
-(void)premiumBtnHideAfterCheck:(NSString *)from{
    
    if ( [from isEqualToString:NOT_FOUND_IN_APP] ){
        return; //don go further when bundle is NOT_FOUND_IN_APP
    }
    
    if( [from isEqualToString:@"ALL"] ||  [from isEqualToString: IN_APP_ID_UNLOCK_VIDEO]){
        UIImage *buttonImage = [UIImage imageNamed:@"video_tab.png"];
        [addVideoTabButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    }
    if( [from isEqualToString:@"ALL"] ||  [from isEqualToString:@"BACKGROUND"]){
        [premiumBtnBg removeFromSuperview];
        [premiumImgBg removeFromSuperview];
    }
    if( [from isEqualToString:@"ALL"] ||  [from isEqualToString:@"BACKGROUND_BORDER"] ){
        [premiumBtnBgBorder removeFromSuperview];
        [premiumImgBgBorder removeFromSuperview];
    }
    
    if( [from isEqualToString:@"ALL"] || [from isEqualToString: IN_APP_ID_ICON_BUNDLE] ){
        if(premiumBtnEmoticons != nil ){
            [premiumBtnEmoticons removeFromSuperview];
            [premiumImgEmoticons removeFromSuperview];
        }
        
        if(premiumBtnCliparts != nil ){
            [premiumBtnCliparts  removeFromSuperview];
            [premiumImgCliparts removeFromSuperview];
        }
        
        if(premiumBtnFonts != nil ){
            [premiumBtnFonts  removeFromSuperview];
            [premiumImgFonts removeFromSuperview];
        }
    }
}

-(CGRect)getSizeOfPremium:(int)x y:(int)y {
    CGRect recT = CGRectMake(x,y,200,150);
    if( IS_IPHONE_4 ){
        recT = CGRectMake(x,y,70,50);
    }
    return recT;
}

-(UIColor *) getPremiumBgColor{
    return [UIColor colorWithRed:0 green:0 blue:255 alpha:0.5];
}

-(void)setFlyerTypeVideo{
    [flyer setFlyerTypeVideo];
    [flyimgView deleteLayer:FLYER_LAYER_GIPHY_LOGO];
    playerToolBar.alpha = 1;
}

-(void)setFlyerTypeImage{
    [flyer setFlyerTypeImage];
    [flyimgView deleteLayer:FLYER_LAYER_GIPHY_LOGO];
    [self videoPlay:NO repeat:NO];
}

@end
