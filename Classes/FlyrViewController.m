//
//  FlyrViewController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 22/Jan/2014.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FlyrViewController.h"
#import "UserPurchases.h"
#import "UserVoice.h"
#import <UserReportSDK/UserReportSDK-Swift.h>

#define ADD_AFTER_FLYERS 4 //SHOW AD AFTER (ADD_AFTER_FLYERS - 1 ) => 3 FLYERS

@interface FlyrViewController ()  {
    
    FlyerlyConfigurator *flyerConfigurator;
    int adsCount;
    int adsLoaded;
    CGRect sizeRectForAdd;
    BOOL hideAd;
    UserPurchases *userPurchases;
}
@end


@implementation FlyrViewController

@synthesize sharePanel,tView;
@synthesize searchTextField;
@synthesize flyerPaths;
@synthesize flyer, signInAlert;
@synthesize showUnsharedFlyers;
@synthesize shouldShowAdd,vwSearch;

id lastShareBtnSender;

#pragma mark  View Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    flyerConfigurator = appDelegate.flyerConfigurator;
    
    userPurchases = [UserPurchases getInstance];
    userPurchases.delegate = self;
    hideAd = !([userPurchases canShowAd]);
    
    lastShareBtnSender = nil;
    
//    UVConfig *config = [UVConfig configWithSite:@"http://flyerly.uservoice.com/"];
//    [UserVoice initialize:config];
    
    isSearching = NO;

    [self.view setBackgroundColor:[UIColor colorWithRed:245/255.0 green:241/255.0 blue:222/255.0 alpha:1.0]];
    
    self.navigationItem.hidesBackButton = YES;
    searchTextField.font = [UIFont systemFontOfSize:12.0];
    searchTextField.textAlignment = NSTextAlignmentLeft;
    searchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [searchTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [searchTextField setReturnKeyType:UIReturnKeyDone];
    
    if(IS_IPHONE_5)
    {
        vwSearch.translatesAutoresizingMaskIntoConstraints = true;
        vwSearch.frame = CGRectMake(vwSearch.frame.origin.x, vwSearch.frame.origin.y, vwSearch.frame.size.width, vwSearch.frame.size.height);
    }
    
    [self.tView setBackgroundColor:[UIColor colorWithRed:245/255.0 green:241/255.0 blue:222/255.0 alpha:1.0]];
	tView.dataSource = self;
	tView.delegate = self;
    [self.view addSubview:tView];
    [self.tView setBackgroundView:nil];
    [self.tView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [searchTextField addTarget:self action:@selector(textFieldTapped:) forControlEvents:UIControlEventEditingChanged];
    searchTextField.borderStyle = nil;
    
    lockFlyer = NO; //Unlock save flyer feature for all users
    
    // Load the flyers.
    flyerPaths = [self getFlyersPaths];
    
    sharePanel = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.origin.y, 320,200 )];
    sharePanel.hidden = YES;
    [self.view addSubview:sharePanel];
    
    //set Navigation
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    // Setting Navigation Header Title
    if(showUnsharedFlyers){
        [self setNavigationTitle:@"SAVED"];
    }else{
        [self setNavigationTitle:@"SHARED"];
    }
    
    // Set left bar items
    [self.navigationItem setLeftBarButtonItems: [self leftBarItems]];
    
    // Set right bar items
    [self.navigationItem setRightBarButtonItems: [self rightBarItems]];
    
    
    dispatch_async( dispatch_get_main_queue(), ^{
        //full screen adds
        [self loadGoogleAds];
    });
    
    [self loadAdsTiles];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    isSearching = NO;
    searchTextField.text = @"";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.alpha = 1.0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark  Text Field Delegete

- (void)textFieldTapped:(id)sender {
    
    if (searchTextField.text == nil || [searchTextField.text isEqualToString:@""])
    {
        isSearching = NO;
        [self.tView reloadData];
        [searchTextField resignFirstResponder];
    }else{
        isSearching
        = YES;
        [self searchTableView:[NSString stringWithFormat:@"%@", ((UITextField *)sender).text]];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    isSearching = YES;
    if(isSearching){
        if([string isEqualToString:@"\n"]){
            
            if([searchTextField canResignFirstResponder])
            {
                [searchTextField resignFirstResponder];
            }
        }
    }
    return YES;
}



#pragma mark Ads Handling Methods

/**
 * Invoked when Interstitial ad received
 * @params:
 *      ad: GADInterstitial
 * @return:
 *      void
 */
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
}

/**
 * After dismiss of interstial add
 * @params:
 *      ad: GADInterstitial
 * @return:
 *      void
 */
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    //on add dismiss && after merging video process, save in gallery
    [self saveAndRelease];
}

/*
 * Invoked when Ad is received
 * @params:
 *      adView: GADBannerView
 * @return:
 *      void
 */
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    //Adding ad in custom view
    if( adsLoaded < self.gadAdsBanner.count ){
        if( sizeRectForAdd.size.width != 0 ){
            adView.frame = sizeRectForAdd;
        }
        self.gadAdsBanner[adsLoaded] = adView;
      adsLoaded++;
    }
}

/**
 * Request for google ads
 * @params:
 *      void
 * @return:
 *      GADRequest
 */
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

/**
 * Method to load google ads
 * @params:
 *      void
 * @return:
 *      void
 */
-(void)loadGoogleAds{
    self.gadInterstitial = [[GADInterstitial alloc] init];
    self.gadInterstitial.delegate = self;
    
    // Note: Edit SampleConstants.h to update kSampleAdUnitId with your addInterstialFms ad unit id.
    self.gadInterstitial.adUnitID = [flyerConfigurator interstitialAdID];
    [self.gadInterstitial loadRequest:[self request]];
}

/**
 * Load advertise tiles
 * @params:
 *      void
 * @return:
 *      void
 */
-(void)loadAdsTiles{
    
    if( self.gadAdsBanner == nil )
        self.gadAdsBanner = [[NSMutableArray alloc] init];
    
    [self getRowsCountWithAds]; // adsCount will be set in this function
    
    if( self.gadAdsBanner.count >= adsCount )
        return; //dont load adds if we already have
    
    //Start process if banner required to load    
    __block int i=-1;
    adsLoaded = 0;
    
    //Load different adds for cells
    for(int j=0;j<adsCount; j++){
        //add strip
        // Initialize the banner at the bottom of the screen.
        CGPoint origin;
        origin = CGPointMake(0.0,0.0);
        GADAdSize customAdSize;
        // define size of ad
        customAdSize = GADAdSizeFromCGSize(CGSizeMake(300,250));
        
        if( j >= self.gadAdsBanner.count  )
            self.gadAdsBanner[j] = [[GADBannerView alloc] initWithAdSize:customAdSize origin:origin];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            i++;
            GADBannerView *tempAdsBanner = self.gadAdsBanner[i];
            tempAdsBanner.adUnitID = [flyerConfigurator bannerAdID];
            tempAdsBanner.delegate = self;
            tempAdsBanner.rootViewController = self;
            
            self.gadAdsBanner[i] = tempAdsBanner;
            
            //[self.gadAdsBanner[i] loadRequest:[self request]];
        });
    }
}


#pragma mark Default NoAdsImage GetName Methods
/*
 * Method to get default image instead of ads
 * when internet is not available
 * @params:
 *      void
 * @return:
 *      imageName: NSString
 */
-(NSString *) getNoAdsImage{
    
    NSString *imageName;

    imageName = @"noAds_5.png";
    
    if (IS_IPHONE_6){
        imageName = @"noAds_6.png";
    } else if (IS_IPHONE_6_PLUS || IS_IPHONE_XR || IS_IPHONE_XS){
        imageName = @"noAds_6Plus.png";
    }
    return imageName;
}

#pragma mark UI Related Methods

/**
 * Enable touche on table view and buttons,
 * It was required when mergin process takes time, so prevent user to do any action
 */
-(void)enableBtns:(BOOL)enable{
    
    backButton.enabled = enable;
    helpButton.enabled = enable;
    createButton.enabled = enable;
    btnInAppPurchase.enabled = enable;
    
    tView.userInteractionEnabled = enable;
    
    if( enable ){
        // Set right bar items
        [self.navigationItem setRightBarButtonItems: [self rightBarItems]];
    }
}

#pragma mark  Custom Methods

/**
 * Return incremented number of rows with respect to ads
 * @params:
 *      void
 * @return:
 *      total(number of rows with ads): int
 *
 */
-(int)getRowsCountWithAds{
    int flyersCount = (int)flyerPaths.count;
    adsCount = floor(flyersCount/ (ADD_AFTER_FLYERS -1) );
    int total = flyersCount + adsCount;
    return  total;
}

/**
 * Return incremented number of rows with respect to ads
 * @params:
 *      void
 * @return:
 *      total(number of rows with ads): int
 *
 */
-(int)getRowsCountWithAdsInSeleceted{
    int flyersCount = (int)searchFlyerPaths.count;
    adsCount = floor(flyersCount/ (ADD_AFTER_FLYERS -1) );
    int total = flyersCount + adsCount;
    return  total;
}

/**
 * Get index of Ads row
 * because of ads
 * indices of flyers are not in proper order
 *
 * @params:
 *      rowNumber: int
 * @return:
 *      row (index of flyer): int
 */
-(int)getIndexOfAd:(int)rowNumber{
    rowNumber++;
    int row = floor(rowNumber / ADD_AFTER_FLYERS ) - 1;
    return  row;
}

/**
 * Get index of flyer row
 * because of ads
 * indices of flyers are not in proper order
 *
 * @params:
 *      rowNumber: int
 * @return:
 *      row (index of flyer): int
 */
-(int)getIndexOfFlyer:(int)rowNumber{
    rowNumber++;//because indexes are starting from 0
    int row = rowNumber - floor(rowNumber / ADD_AFTER_FLYERS ) - 1 ;
    return  row;
}

-(int)getIndexOfSelectedFlyer:(int)rowNumber{
    rowNumber++;//because indexes are starting from 0
    int row = rowNumber - floor(rowNumber / ADD_AFTER_FLYERS ) - 1 ;
    return  row;
}

/**
 * It will return the index is it belongs from advertise or not
 */
-(BOOL)isAddvertiseRow:(int)rowNumber{
    rowNumber++;//because indexes are starting from 0
    
    BOOL isAddRow = NO;
    if( adsCount > 0 && rowNumber > 0 && ( rowNumber % ADD_AFTER_FLYERS ) == 0 ) {
        isAddRow = YES;
    }
    return isAddRow;
}

/*
 * Inputs a string and searches it in the given data
 * @params:
 *      textToSearch: String
 * @return:
 *      void
 */
- (void) searchTableView: (NSString *) textToSearch {
    
    NSString *tempFlyerTitle;
    NSString *tempFlyerDescription;
    NSString *tempFlyerDate;
    NSString *searchText = textToSearch;
    
    searchFlyerPaths = [[NSMutableArray alloc] init];
    
    // To get Flyer Title, Description and Date to search
    for (int i =0 ; i < [flyerPaths count] ; i++)
    {
        Flyer *fly = [[Flyer alloc] initWithPath:[flyerPaths objectAtIndex:i] setDirectory:NO];
        
        tempFlyerTitle = [fly getFlyerTitle];
        tempFlyerDescription = [fly getFlyerDescription];
        tempFlyerDate = [flyer dateFormatter:[fly getFlyerDate]];
        
        NSRange flyerTitileRange = [tempFlyerTitle rangeOfString:searchText options:NSCaseInsensitiveSearch];
        NSRange flyerDescriptionRange = [tempFlyerDescription rangeOfString:searchText options:NSCaseInsensitiveSearch];
        NSRange flyerDateRange = [tempFlyerDate rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if (flyerTitileRange.length > 0 || flyerDescriptionRange.length > 0 || flyerDateRange.length > 0){
            [searchFlyerPaths addObject:[flyerPaths objectAtIndex:i]];
        }
    }
    [self.tView reloadData];
}

//when user tap on create new flyer(from saved flyer)
-(IBAction)createFlyer:(id)sender {
    
    [self enableBtns:NO];
    
    cancelRequest = YES;
    NSString *flyPath = [Flyer newFlyerPath];
    
    //Here We set Source for Flyer screen
    flyer = [[Flyer alloc]initWithPath:flyPath setDirectory:YES];
    
	createFlyer = [[CreateFlyerController alloc]initWithNibName:@"CreateFlyerController" bundle:nil];
    createFlyer.flyerPath = flyPath;
    createFlyer.flyer = flyer;

    //Tasks after create new flyer
    [createFlyer tasksOnCreateNewFlyer];
    
    __weak FlyrViewController *weakSelf = self;
    
    //Here we Manage Block for Update
    [createFlyer setOnFlyerBack:^(NSString *nothing) {
        
        // Here we setCurrent Flyer is Most Recent Flyer
        
        [weakSelf saveAndRelease];
        
        [weakSelf enableBtns:YES];
        
        // HERE WE GET FLYERS
        weakSelf.flyerPaths = [weakSelf getFlyersPaths];
        
        if( weakSelf.flyerPaths.count > 1 ){
            [weakSelf.tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        [weakSelf.tView reloadData];
        
    }];

    [createFlyer setShouldShowAdd:^(NSString *flyPath,BOOL haveValidSub) {
        dispatch_async( dispatch_get_main_queue(), ^{
            if (haveValidSub == NO && ([weakSelf.interstitial isReady] && ![weakSelf.interstitial hasBeenUsed]) ){
                [weakSelf.interstitial presentFromRootViewController:weakSelf];
            }  else{
                [weakSelf saveAndRelease];
            }
        });
    }];

    [self.navigationController pushViewController:createFlyer animated:YES];
}

-(void)goBack{
    
    userPurchases = [UserPurchases getInstance];
    userPurchases.delegate = self;
    hideAd = !([userPurchases canShowAd]);
    if ( self.shouldShowAdd != NULL ) {
        self.shouldShowAdd ( @"", hideAd );
    }
  	[self.navigationController popViewControllerAnimated:YES];
    cancelRequest = YES;
}


-(NSArray *)leftBarItems{
    
    // Create left bar help button
    helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [helpButton addTarget:self action:@selector(loadHelpController) forControlEvents:UIControlEventTouchUpInside];
    [helpButton setImage:[UIImage imageNamed:@"help_icon"] forState:UIControlStateNormal];
    helpButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
   
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"home_button"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];

    return [NSMutableArray arrayWithObjects:backBarButton,leftBarButton,nil];
}

-(NSArray *)rightBarItems{
   
    // InApp Purchase Button
    btnInAppPurchase = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btnInAppPurchase addTarget:self action:@selector(openInAppPanel) forControlEvents:UIControlEventTouchUpInside];
    [btnInAppPurchase setBackgroundImage:[UIImage imageNamed:@"premium_features"] forState:UIControlStateNormal];
    btnInAppPurchase.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *inAppPurchaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnInAppPurchase];
    
    // Create Button
    createButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [createButton addTarget:self action:@selector(createFlyer:) forControlEvents:UIControlEventTouchUpInside];
    [createButton setBackgroundImage:[UIImage imageNamed:@"createButton"] forState:UIControlStateNormal];
    createButton.showsTouchWhenHighlighted = YES;
    
    rightUndoBarButton = [[UIBarButtonItem alloc] initWithCustomView:createButton];
    
    return [NSMutableArray arrayWithObjects:rightUndoBarButton, inAppPurchaseButtonItem, nil];
}

-(void)loadHelpController
{
   // [UserVoice presentUserVoiceInterfaceForParentViewController:self];
    [UserReport tryInvite];
}

/*
 * Here we get All Flyers Directories
 * @params:
 *      void
 * @return
 *      unsharedFlyer/unsharedFlyer: NSarray of Flyers Path
 */
-(NSMutableArray *)getFlyersPaths{

    NSMutableArray *allFlyers = [ Flyer recentFlyerPreview:0];
    for(int i = 0 ; i < [allFlyers count];i++) {
        //Here we remove File Name from Path
        NSString *pathWithoutFileName = [[allFlyers objectAtIndex:i]
                                         stringByReplacingOccurrencesOfString:[NSString
                                                                               stringWithFormat:@"/flyer.%@",IMAGETYPE] withString:@""];
        [allFlyers replaceObjectAtIndex:i withObject:pathWithoutFileName];
    }
    
    NSMutableArray *unsharedFlyer = [[NSMutableArray alloc] initWithArray:allFlyers];
    int count = (int) [allFlyers count] - 1;
    // Finding unshared flyers
    for (int i = count ; i>=0 ; i--)
    {
        Flyer *flyr = [[Flyer alloc] initWithPath:[allFlyers objectAtIndex:i] setDirectory:NO];
               
        for(int j =0 ; j < [flyr.socialArray count] ; j++){
            
            if([flyr.socialArray[j] isEqualToString:@"1"]){
                // N.B.: In "flyr.socialArray" index '4' is saveButton Status
                // So, we skip it because it does not show any social status
                if(j == 4){
                    continue;
                }else {
                    [unsharedFlyer removeObjectAtIndex:i];
                    break;
                }
            }
        }
    }
   
    if(showUnsharedFlyers){ // unshared flyers
        return unsharedFlyer;
    } else { //shared flyers
        [allFlyers removeObjectsInArray:unsharedFlyer];
        return allFlyers;
    }
    return unsharedFlyer;
}

/*
 * Method to set navigation title
 * @params:
 *      title: NSString
 * @return:
 *      void
 */
-(void)setNavigationTitle: (NSString *) headerTitle{
    
    self.title = headerTitle;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0]};
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // If searching, the number of rows may be different
    if(hideAd && isSearching){ // search flyers with no ads
        return searchFlyerPaths.count;
    }else if (!hideAd && isSearching){ // search flyers with ads
        return [self getRowsCountWithAdsInSeleceted];
    }else if(!hideAd){ // all flyers with ads
        return [self getRowsCountWithAds];
    }else{ // all flyers with no ads
        return flyerPaths.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int rowNumber = (int)indexPath.row;
    
    SaveFlyerCell *cell = (SaveFlyerCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SaveFlyerCell" owner:self options:nil];
        if( IS_IPHONE_4 || IS_IPHONE_5){
            nib = [[NSBundle mainBundle] loadNibNamed:@"SaveFlyerCell" owner:self options:nil];
        } else if ( IS_IPHONE_6 ){
            nib = [[NSBundle mainBundle] loadNibNamed:@"SaveFlyerCell-iPhone6" owner:self options:nil];
        } else if ( IS_IPHONE_6_PLUS || IS_IPHONE_XR || IS_IPHONE_XS) {
            nib = [[NSBundle mainBundle] loadNibNamed:@"SaveFlyerCell-iPhone6-Plus" owner:self options:nil];
        }
        cell = (SaveFlyerCell *)[nib objectAtIndex:0];
    }
    
    if( !hideAd && [self isAddvertiseRow:rowNumber] ){ // Shows ads
        
        cell.createLabel.alpha = 0.0;
        cell.updatedLabel.alpha = 0.0;
        cell.shareBtn.alpha = 0.0;
        cell.nameLabel.alpha = 0.0;
        cell.description.alpha = 0.0;
        cell.dateLabel.alpha = 0.0;
        cell.updatedDateLabel.alpha = 0.0;
        cell.btnEdit.alpha = 0.0;
        
        // Setting background image while ad is loading
        UIImageView *noAdsImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self getNoAdsImage]]];
        
        if([FlyerlySingleton connected]){
            int addRow = [self getIndexOfAd:rowNumber];
            
            // If not connected to internet, enables image user interaction
            noAdsImage.userInteractionEnabled = NO;
            
            GADBannerView *adView = self.gadAdsBanner[ addRow ];
            adView.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tView.frame.size.width, cell.frame.size.height);
            if( sizeRectForAdd.size.width != 0 ){
                adView.frame = sizeRectForAdd;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.gadAdsBanner[ addRow ] = adView;
                [cell addSubview:self.gadAdsBanner[addRow]];
            });
            return cell;
            
        } else {
            
            // If not connected to internet, enables image user interaction
            noAdsImage.userInteractionEnabled = YES;
            // and applies gesture recognizer on image
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openInAppPanel)];
            [tap setNumberOfTapsRequired:1];
            [noAdsImage addGestureRecognizer:tap];
            [cell addSubview: noAdsImage];
            return cell;
        }
        
    } else { // Shows flyers
        if( isSearching ){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                int flyerRow = rowNumber;
                if(!hideAd){
                    flyerRow = [self getIndexOfSelectedFlyer:rowNumber];
                }
                flyer = [[Flyer alloc] initWithPath:[searchFlyerPaths objectAtIndex:flyerRow] setDirectory:NO];
                [cell renderCell:flyer LockStatus:lockFlyer];
                [cell.flyerLock addTarget:self action:@selector(openInAppPanel) forControlEvents:UIControlEventTouchUpInside];
                cell.shareBtn.tag = indexPath.row;
                [cell.shareBtn addTarget:self action:@selector(onShare:) forControlEvents:UIControlEventTouchUpInside];
            });
            
            return cell;
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Load the flyers again so that flyer can be loaded if user logs in from here
                int flyerRow = rowNumber;
                if(!hideAd){
                    flyerRow = [self getIndexOfFlyer:rowNumber];
                }
                flyerPaths = [self getFlyersPaths];
                flyer = [[Flyer alloc] initWithPath:[flyerPaths objectAtIndex:flyerRow] setDirectory:NO];
                [cell renderCell:flyer LockStatus:lockFlyer];
                [cell.flyerLock addTarget:self action:@selector(openInAppPanel) forControlEvents:UIControlEventTouchUpInside];
                cell.shareBtn.tag = indexPath.row;
                [cell.shareBtn addTarget:self action:@selector(onShare:) forControlEvents:UIControlEventTouchUpInside];
            });
            
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int rowNumber = (int)indexPath.row;
    int rowNumberSelectedFlyer = (int)indexPath.row;
    
    if(!hideAd && [self isAddvertiseRow:rowNumber] == NO ) {
        rowNumber = [self getIndexOfFlyer:rowNumber];
        rowNumberSelectedFlyer = [self getIndexOfSelectedFlyer:rowNumberSelectedFlyer];
        
        [self enableBtns:NO];
        
        if(isSearching){
            flyer = [[Flyer alloc]initWithPath:[searchFlyerPaths objectAtIndex:rowNumberSelectedFlyer] setDirectory:YES];
        } else {
            // Load the flyers.
            flyerPaths = [self getFlyersPaths];
            flyer = [[Flyer alloc]initWithPath:[flyerPaths objectAtIndex:rowNumber] setDirectory:YES];
        }
        
        createFlyer = [[CreateFlyerController alloc]initWithNibName:@"CreateFlyerController" bundle:nil];
        
        // Set CreateFlyer Screen
        createFlyer.flyer = flyer;
        __weak FlyrViewController *weakSelf = self;
        __weak CreateFlyerController *weakCreate = createFlyer;
        
        //Here we Manage Block for Update
        [createFlyer setOnFlyerBack:^(NSString *nothing) {
            // Here we setCurrent Flyer is Most Recent Flyer
            [weakCreate.flyer setRecentFlyer];
            [weakSelf saveAndRelease];
            [weakSelf enableBtns:YES];
            
            // HERE WE GET FLYERS
            weakSelf.flyerPaths = [weakSelf getFlyersPaths];
            if( weakSelf.flyerPaths.count > 1 ){
                [weakSelf.tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            [weakSelf.tView reloadData];
        }];
        
        [createFlyer setShouldShowAdd:^(NSString *flyPath,BOOL hasValidSubscription) {
            dispatch_async( dispatch_get_main_queue(), ^{
                if ( hasValidSubscription == NO && ([weakSelf.gadInterstitial isReady] && ![weakSelf.gadInterstitial hasBeenUsed]) ){
                    [weakSelf.gadInterstitial presentFromRootViewController:weakSelf];
                } else{
                    [weakSelf saveAndRelease];
                }
            });
        }];
        [self.navigationController pushViewController:createFlyer animated:YES];
        
    } else if ([self isAddvertiseRow:rowNumber] == NO){
        
        [self enableBtns:NO];
        
        if(isSearching){
            flyer = [[Flyer alloc]initWithPath:[searchFlyerPaths objectAtIndex:rowNumberSelectedFlyer] setDirectory:YES];
        } else {
            // Load the flyers.
            flyerPaths = [self getFlyersPaths];
            flyer = [[Flyer alloc]initWithPath:[flyerPaths objectAtIndex:rowNumber] setDirectory:YES];
        }
        
        createFlyer = [[CreateFlyerController alloc]initWithNibName:@"CreateFlyerController" bundle:nil];
        
        // Set CreateFlyer Screen
        createFlyer.flyer = flyer;
        __weak FlyrViewController *weakSelf = self;
        __weak CreateFlyerController *weakCreate = createFlyer;
        
        //Here we Manage Block for Update
        [createFlyer setOnFlyerBack:^(NSString *nothing) {
            // Here we setCurrent Flyer is Most Recent Flyer
            [weakCreate.flyer setRecentFlyer];
            [weakSelf saveAndRelease];
            [weakSelf enableBtns:YES];
            
            // HERE WE GET FLYERS
            weakSelf.flyerPaths = [weakSelf getFlyersPaths];
            if( weakSelf.flyerPaths.count > 1 ){
                [weakSelf.tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            [weakSelf.tView reloadData];
        }];
        
        [createFlyer setShouldShowAdd:^(NSString *flyPath,BOOL hasValidSubscription) {
            dispatch_async( dispatch_get_main_queue(), ^{
                if ( hasValidSubscription == NO && ([weakSelf.gadInterstitial isReady] && ![weakSelf.gadInterstitial hasBeenUsed]) ){
                    [weakSelf.gadInterstitial presentFromRootViewController:weakSelf];
                } else{
                    [weakSelf saveAndRelease];
                }
            });
        }];
        
        [self.navigationController pushViewController:createFlyer animated:YES];
    }
    
}


/**
 * Save flyer and release extras
 */
-(void)saveAndRelease{
    BOOL condition1 = (createFlyer.flyer.saveInGallaryAfterNumberOfTasks == -1);
    BOOL condition2 = [createFlyer.flyer saveAfterCheck];

    if( condition1 || condition2 ){
        [self releaseExtras];
    }
}

/**
 * Release extras
 */
-(void)releaseExtras{
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int total;
    int rowNumber = (int)indexPath.row;
    int rowNumberSelectedFlyer = (int)indexPath.row;
    
    if( [self isAddvertiseRow:rowNumber] == NO ) {
        rowNumber = [self getIndexOfFlyer:rowNumber];
        rowNumberSelectedFlyer = [self getIndexOfFlyer:rowNumberSelectedFlyer];
        
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            // HERE WE REMOVE FLYER FROM DIRECTORY
            if ( isSearching ) {
                total = [self getRowsCountWithAdsInSeleceted];
                if (total > 0 && total > rowNumberSelectedFlyer){
                    [[NSFileManager defaultManager] removeItemAtPath:[searchFlyerPaths objectAtIndex:rowNumberSelectedFlyer] error:nil];
                    [searchFlyerPaths removeObjectAtIndex:rowNumberSelectedFlyer];
                }
                
            } else {
                total = [self getRowsCountWithAds];
                if (total > 0 && total > rowNumber){
                    [[NSFileManager defaultManager] removeItemAtPath:[flyerPaths objectAtIndex:rowNumber] error:nil];
                    [flyerPaths removeObjectAtIndex:rowNumber];
                }
            }
        }
        
        flyerPaths = [self getFlyersPaths];
        
        [tableView reloadData];
    }
}


# pragma In App Purchase

/*
 * Opens InAppPurchase Panel
 */
-(void) openInAppPanel{
    inappviewcontroller = [InAppPurchaseRelatedMethods openInAppPurchasePanel:self];
}


- (void)inAppPanelDismissed {
    
}

- (void)productSuccesfullyPurchased: (NSString *)productId {
    
    UserPurchases *userPurchases_ = [UserPurchases getInstance];
    
    if ( [userPurchases_ checkKeyExistsInPurchases: IN_APP_ID_SAVED_FLYERS] ) {
        
        lockFlyer = NO;
        [self.tView reloadData];
        [inappviewcontroller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)inAppPurchasePanelContent {
    [inappviewcontroller inAppDataLoaded];
}

#pragma mark - UIAlertView delegate

-(void)enableHome:(BOOL)enable{
    [self.tView reloadData];
    [self enableBtns:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView == signInAlert && buttonIndex == 0) {
        [self enableBtns:YES];
        [self hideLoadingIndicator];
    } else if(alertView == signInAlert && buttonIndex == 1) {
        [self signInRequired];
    }
}


-(void)onShare:(id)sender {
    
    UIButton *clickButton = sender;
    NSInteger row = clickButton.tag; ///will get it from button tag
    
    if(row > (ADD_AFTER_FLYERS-1)){
        row = row - floor(row/ADD_AFTER_FLYERS);
    }
    
    if([searchTextField.text isEqualToString:@""]) {
        flyer = [[Flyer alloc] initWithPath:[flyerPaths objectAtIndex:row] setDirectory:NO];
    } else{
        flyer = [[Flyer alloc] initWithPath:[searchFlyerPaths objectAtIndex:row] setDirectory:NO];
    }

    if ( [[PFUser currentUser] sessionToken] ) {
        [self enableBtns:NO];
        sharePanel.hidden = NO;
        [sharePanel removeFromSuperview];
        
        if ([flyer isVideoFlyer]) {
            if ( IS_IPHONE_5 || IS_IPHONE_4) {
                shareviewcontroller = [[ShareViewController alloc] initWithNibName:@"ShareVideoViewController" bundle:nil];
            }else if ( IS_IPHONE_6 || IS_IPHONE_6_PLUS || IS_IPHONE_XR || IS_IPHONE_XS) {
                shareviewcontroller = [[ShareViewController alloc] initWithNibName:@"ShareVideoViewController-iPhone6" bundle:nil];
            }
        } else {
            if ( IS_IPHONE_5 || IS_IPHONE_4) {
                shareviewcontroller = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
            }else if ( IS_IPHONE_6  || IS_IPHONE_6_PLUS || IS_IPHONE_XR || IS_IPHONE_XS) {
                shareviewcontroller = [[ShareViewController alloc] initWithNibName:@"ShareViewController-iPhone6" bundle:nil];
            }
        }
        shareviewcontroller.cfController = (id)self;

        
        sharePanel = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.origin.y, 320,400 )];
        if ( IS_IPHONE_6) {
            sharePanel = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.origin.y, 340,350 )];
        }else if ( IS_IPHONE_6_PLUS || IS_IPHONE_XR || IS_IPHONE_XS){
            sharePanel = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.origin.y, 400,600 )];
        }
        
        sharePanel.backgroundColor = [UIColor redColor];
        sharePanel = shareviewcontroller.view;
        
        [self.view addSubview:sharePanel];
        
        sharePanel = shareviewcontroller.view;
        NSString *shareImagePath = [flyer getFlyerImage];
        UIImage *shareImage =  [UIImage imageWithContentsOfFile:shareImagePath];
        
        //Here we Pass Param to Share Screen Which use for Sharing
        [shareviewcontroller.titleView resignFirstResponder];
        [shareviewcontroller.descriptionView resignFirstResponder];
        shareviewcontroller.selectedFlyerImage = shareImage;
        shareviewcontroller.flyer = self.flyer;
        shareviewcontroller.imageFileName = shareImagePath;
        shareviewcontroller.rightUndoBarButton = rightUndoBarButton;
        shareviewcontroller.shareButton = createButton;
        shareviewcontroller.helpButton = helpButton;
        shareviewcontroller.backButton = backButton;
        if( [shareviewcontroller.titleView.text isEqualToString:@"Flyer"] ) {
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
        //shareviewcontroller.topTitleLabel = titleLabel;
        
        [shareviewcontroller.descriptionView setReturnKeyType:UIReturnKeyDone];
        shareviewcontroller.Yvalue = [NSString stringWithFormat:@"%f",self.view.frame.size.height];
        
        PFUser *user = [PFUser currentUser];
        if (user[@"appStarRate"])
            [shareviewcontroller setStarsofShareScreen:user[@"appStarRate"]];
        
        [user saveInBackground];
        
        [shareviewcontroller setSocialStatus];
        
        //Here we Get youtube Link
        NSString *isAnyVideoUploadOnYoutube = [self.flyer getYoutubeLink];
        
        // Any Uploaded Video Link Available of Youtube
        // then we Enable Other Sharing Options
        if (![isAnyVideoUploadOnYoutube isEqualToString:@""]) {
            [shareviewcontroller haveVideoLinkEnableAllShareOptions : YES];
        }
        
        //Create Animation Here
        [sharePanel setFrame:CGRectMake(0, self.view.frame.size.height, 320,475 )];
        if ( IS_IPHONE_6) {
            [sharePanel setFrame:CGRectMake(0, self.view.frame.size.height, 375,350 )];
        }else if ( IS_IPHONE_6_PLUS || IS_IPHONE_XR || IS_IPHONE_XS){
            [sharePanel setFrame:CGRectMake(0, self.view.frame.size.height, 375,550 )];
        }
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4f];
        [sharePanel setFrame:CGRectMake(0, self.view.frame.size.height - 450, 320,505 )];
        if ( IS_IPHONE_6) {
            [sharePanel setFrame:CGRectMake(0, self.view.frame.size.height - 450, 375,450 )];
        }else if ( IS_IPHONE_6_PLUS || IS_IPHONE_XR || IS_IPHONE_XS){
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
        if ( !self.interstitial.hasBeenUsed )
            [signInAlert show];
    }
 }


- (void)printFlyer {
    
    if(IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS || IS_IPHONE_XR || IS_IPHONE_XS){
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

- (void)inAppPurchasePanelButtonTappedWasPressed:(NSString *)inAppPurchasePanelButtonCurrentTitle {
    
    __weak InAppViewController *inappviewcontroller_ = inappviewcontroller;
    if ([inAppPurchasePanelButtonCurrentTitle isEqualToString:(@"Sign In")]) {
        [inappviewcontroller_.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        [self signInRequired];
    }else if ([inAppPurchasePanelButtonCurrentTitle isEqualToString:(@"Restore Purchases")]){
        [inappviewcontroller_ restorePurchase];
    }
}

-(void)signInRequired {
    signInController = [[SigninController alloc]initWithNibName:@"SigninController" bundle:nil];

    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    signInController.launchController = appDelegate.lauchController;

    __weak FlyrViewController *flyrViewController = self;

    UserPurchases *userPurchases_ = [UserPurchases getInstance];

    userPurchases_.delegate = self;

    signInController.signInCompletion = ^void(void) {
        UINavigationController* navigationController = flyrViewController.navigationController;
        [navigationController popViewControllerAnimated:NO];
        [userPurchases_ setUserPurcahsesFromParse];

        if( lastShareBtnSender != nil ){
            [flyrViewController onShare:lastShareBtnSender];
        }
        [flyrViewController enableBtns:YES];
        [flyrViewController hideLoadingIndicator];
    };

    [self.navigationController pushViewController:signInController animated:YES];
}

- (void) userPurchasesLoaded {
    
    UserPurchases *userPurchases_ = [UserPurchases getInstance];
    
    if ( [userPurchases_ checkKeyExistsInPurchases: IN_APP_ID_SAVED_FLYERS] ) {

        lockFlyer = NO;
        [self.tView reloadData];
        [inappviewcontroller.paidFeaturesTview reloadData];
    }else {
            
        [self presentViewController:inappviewcontroller animated:NO completion:nil];
    }

}

@end



