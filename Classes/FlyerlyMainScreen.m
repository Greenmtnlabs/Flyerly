//
//  FlyerlyMainScreen.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 22/Jan/2014.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FlyerlyMainScreen.h"
#import "UserPurchases.h"
#import "InviteFriendsController.h"
#import "MainSettingViewController.h"
#import "FlyrAppDelegate.h"
#import "FlyerlyConfigurator.h"
#import "WebViewController.h"

#define ADD_AFTER_FLYERS 4 //SHOW AD AFTER (ADD_AFTER_FLYERS - 1 ) => 3 FLYERS

@interface FlyerlyMainScreen ()  {
    
    FlyerlyConfigurator *flyerConfigurator;
    int addsCount;
    int addsLoaded;
    CGRect sizeRectForAdd;
    BOOL isSearch;
    UIImageView *noAdsImage;
    NSString *imageName;
    bool hideAd;
    BOOL isComingFromCreateFlyer;
}

@end

@implementation FlyerlyMainScreen

@synthesize sharePanel,tView;
@synthesize flyerPaths;
@synthesize flyer, signInAlert, bottomBar;
@synthesize txtSearch;
@synthesize btnCreateFlyer;
@synthesize btnInvite, btnSaved, btnShared, btnSocial;

id lastShareBtnSender;

#pragma mark  View Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    flyerConfigurator = appDelegate.flyerConfigurator;
    txtSearch.delegate = self;
    
    // setting isSearch to NO i.e. no search at first time
    isSearch = NO;
    
    // adding SearchBox to main screen
    [self addSearchBox];
    
    lastShareBtnSender = nil;
    self.navigationItem.hidesBackButton = YES;

	tView.dataSource = self;
	tView.delegate = self;
    [tView setBackgroundView:nil];
    [tView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tView];


    // Load the flyers.
    flyerPaths = [self getFlyersPaths];
    
    sharePanel = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.origin.y, 320,200 )];
    sharePanel.hidden = YES;
    [self.view addSubview:sharePanel];
    
    //set Navigation
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    [self setNavigation];
    
    // Determin if the user has been greeted?
    NSString *greeted = [[NSUserDefaults standardUserDefaults] stringForKey:@"greeted"];
    
    if( !greeted ) {
        // Determining the previous version of app
        NSString *previuosVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"previousVersion"];
        if( ![previuosVersion isEqualToString:[self appVersion]] || previuosVersion == nil ) {
              [self openIntro];
        }
        
        // Show the greeting before going to the main app.
        [[NSUserDefaults standardUserDefaults] setObject:@"greeted" forKey:@"greeted"];
        
    }
    
    [self checkUserPurchases];
    
    dispatch_async( dispatch_get_main_queue(), ^{
        //full screen adds
        [self loadFullScreenGoogleAdd];
    });
    
    // set default image
    [self setNoAdsImage];
    [self loadAdsTiles];
    
    [self.view bringSubviewToFront:bottomBar];
    [self.view bringSubviewToFront:btnCreateFlyer];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Load the flyers.
    isSearch = NO;
    txtSearch.text = @"";
    
    // Load the flyers.
    flyerPaths = [self getFlyersPaths];
    
    userPurchases = [UserPurchases getInstance];
    userPurchases.delegate = self;
    hideAd = !([userPurchases canShowAd]);
    
    [self.tView reloadData];
    [self checkUserPurchases];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if( sizeRectForAdd.size.width == 0 ){
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        MainFlyerCell *cell = (MainFlyerCell *)[self.tView cellForRowAtIndexPath:indexPath];
        sizeRectForAdd = cell.containerView.frame;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSString *) appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}

-(void)checkUserPurchases{
    //Checking if the user is valid or anonymus
   if ([[PFUser currentUser] sessionToken]) {
        
        UserPurchases *userPurchases_ = [UserPurchases getInstance];
        userPurchases_.delegate = nil;
        
        //GET UPDATED USER PUCHASES INFO
        [userPurchases_ setUserPurcahsesFromParse];
        
    } else {
        NSLog(@"Anonymous, User is NOT authenticated.");
    }
}


#pragma mark  custom Methods

/*
 * This method changes flyer title during editing
 * @params:
 *      index: int
 *      text: NSString
 * @return:
 *      void
 */
-(void) updateCellTitle :(int)index text:(NSString *) text{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    MainFlyerCell *cell = (MainFlyerCell *)[self.tView  cellForRowAtIndexPath:indexPath];
    cell.lblFlyerTitle.text = text;
}


/*
 * Method to set default image instead of ads
 * when internet is not available
 * @params:
 *      void
 * @return:
 *      void
 */
-(void) setNoAdsImage{
    
    imageName = @"noAds_5_HomeScreen.png";
    
    if (IS_IPHONE_6){
        imageName = @"noAds_6_HomeScreen.png";
    } else if (IS_IPHONE_6_PLUS){
        imageName = @"noAds_6Plus_HomeScreen.png";
    }
    noAdsImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    noAdsImage.userInteractionEnabled = NO;
    
    if(![FlyerlySingleton connected]){
        
        // If not connected to internet, enables image user interaction
        noAdsImage.userInteractionEnabled = YES;
        
        // and applies gesture recognizer on image
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openInAppPanel)];
        noAdsImage.userInteractionEnabled = YES;
        [tap setNumberOfTapsRequired:1];
        [noAdsImage addGestureRecognizer:tap];
    }
}

/*
 * TextView to input and search
 * @params:
 *      void
 * @return:
 *      void
 */

-(void) addSearchBox{
    
    txtSearch.font = [UIFont systemFontOfSize:12.0];
    txtSearch.textAlignment = NSTextAlignmentLeft;
    txtSearch.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [txtSearch setBorderStyle:UITextBorderStyleRoundedRect];
    [txtSearch setReturnKeyType:UIReturnKeyDone];
    
    [txtSearch addTarget:self action:@selector(textFieldTapped:) forControlEvents:UIControlEventEditingChanged];
    txtSearch.borderStyle = nil;
    
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
    
    // To get Flyer Title,, Description and Date to search
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

    NSString *flyPath = [Flyer newFlyerPath];
    
    //Here We set Source for Flyer screen
    flyer = [[Flyer alloc]initWithPath:flyPath setDirectory:YES];
    
	createFlyer = [[CreateFlyerController alloc]initWithNibName:@"CreateFlyerController" bundle:nil];
    createFlyer.flyerPath = flyPath;
    createFlyer.flyer = flyer;

    //Tasks after create new flyer
    [createFlyer tasksOnCreateNewFlyer];
    
    __weak FlyerlyMainScreen *weakSelf = self;
    
    //Here we Manage Block for Update
    [createFlyer setOnFlyerBack:^(NSString *nothing) {
        [weakSelf saveAndRelease];
        
        [weakSelf enableBtns:YES];
        
        //HERE WE GET FLYERS
        weakSelf.flyerPaths = [weakSelf getFlyersPaths];
        
        [weakSelf loadAdsTiles];
        
        if( weakSelf.flyerPaths.count > 1 ){
         [weakSelf.tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        [weakSelf.tView reloadData];
        
    }];
    
    [createFlyer setShouldShowAdd:^(NSString *flyPath,BOOL haveValidSubscription) {
        dispatch_async( dispatch_get_main_queue(), ^{
            
            if (haveValidSubscription == NO && ([weakSelf.addInterstialFms isReady] && ![weakSelf.addInterstialFms hasBeenUsed]) ){
                [weakSelf.addInterstialFms presentFromRootViewController:weakSelf];
            }  else{
                [weakSelf saveAndRelease];
            }
        });
    }];
    
    isComingFromCreateFlyer = YES;
    [self.navigationController pushViewController:createFlyer animated:YES];
}

- (void)inAppPanelDismissed {

}


/*
 * This method is invoked
 * when the Flyerly Logo is tapped
 */

-(void)tapDetected{
    [self.tView setContentOffset:CGPointZero animated:YES];
}



/*
 * Here we get All Flyers Directories
 * return
 *      Nsarray of Flyers Path
 */
-(NSMutableArray *)getFlyersPaths{
    
    NSMutableArray *sortedList = [ Flyer recentFlyerPreview:0];
    
    for(int i = 0 ; i < [sortedList count];i++) {
        
        //Here we remove File Name from Path
        NSString *pathWithoutFileName = [[sortedList objectAtIndex:i]
                                         stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/flyer.%@",IMAGETYPE] withString:@""];
        [sortedList replaceObjectAtIndex:i withObject:pathWithoutFileName];
    }
    return sortedList;
}

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
    addsCount = floor(flyersCount/ (ADD_AFTER_FLYERS -1) );
    int total = flyersCount + addsCount;
    
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
    addsCount = floor(flyersCount/ (ADD_AFTER_FLYERS -1) );
    int total = flyersCount + addsCount;
    
    return  total;
}

/**
 * Get index of add row
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
    if( addsCount > 0 && rowNumber > 0 && ( rowNumber % ADD_AFTER_FLYERS ) == 0 ) {
        isAddRow = YES;
    }
    return isAddRow;
}

// We've received an ad for cell successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    //Adding ad in custom view
    if( addsLoaded < self.bannerAdd.count ){
        if( sizeRectForAdd.size.width != 0 ){
            adView.frame = sizeRectForAdd;
        }
        self.bannerAdd[addsLoaded] = adView;
        [self loadAdsTiles];
        
        addsLoaded++;
    }
    
}

/**
 * Load addvertise tiles
 */
-(void)loadAdsTiles{
    
    if( self.bannerAdd == nil )
        self.bannerAdd = [[NSMutableArray alloc] init];
    
    [self getRowsCountWithAds]; // addsCount will be set in this function
    
    if( self.bannerAdd.count >= addsCount )
    return; //dont load adds if we already have
    
    //Start process if banner required to load
    __block int i=-1;
    addsLoaded = 0;
    
    for(int j=0;j<addsCount; j++){
        //add strip
        // Initialize the banner at the bottom of the screen.
        CGPoint origin;
        origin = CGPointMake(0.0,0.0);
        GADAdSize customAdSize;
        customAdSize = GADAdSizeFromCGSize(CGSizeMake(300,250));
        
        if( j >= self.bannerAdd.count  )
            self.bannerAdd[j] = [[GADBannerView alloc] initWithAdSize:customAdSize origin:origin];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            i++;
            //if( haveValidSubscription == NO ) {
            // Use predefined GADAdSize constants to define the GADBannerView.
            GADBannerView *bannerAddTemp = self.bannerAdd[i];
            
            // Note: Edit SampleConstants.h to provide a definition for kSampleAdUnitID before compiling.
            bannerAddTemp.adUnitID = [flyerConfigurator bannerAdID];
            bannerAddTemp.delegate = self;
            bannerAddTemp.rootViewController = self;
            
            self.bannerAdd[i] = bannerAddTemp;
            
            [self.bannerAdd[i] loadRequest:[self request]];
            //}
        });
    }
}

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ( IS_IPHONE_4 || IS_IPHONE_5 ) {
        return 380;
    }
    else if ( IS_IPHONE_6 ) {
        return 445;
    }
    else{
        return 492;
    }
    
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // If searching, the number of rows may be different
    
    if(hideAd && isSearch){ // search flyers with no ads
        return searchFlyerPaths.count;
    }else if (!hideAd && isSearch){ // search flyers with ads
        return  [self getRowsCountWithAdsInSeleceted];
    }else if(!hideAd){ // all flyers with ads
        return [self getRowsCountWithAds];
    } else{ // all flyers with no ads
         return flyerPaths.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int rowNumber = (int)indexPath.row;
    MainFlyerCell *cell = (MainFlyerCell *)[tableView dequeueReusableCellWithIdentifier:@"MainFlyerCellId"];
    
    if (cell == nil) {
        NSArray *nib;
        if ( IS_IPHONE_4 || IS_IPHONE_5 ) {
            nib = [[NSBundle mainBundle] loadNibNamed:@"MainFlyerCell" owner:self options:nil];
        } else if ( IS_IPHONE_6 ) {
            nib = [[NSBundle mainBundle] loadNibNamed:@"MainFlyerCell-iPhone6" owner:self options:nil];
        } else if ( IS_IPHONE_6_PLUS ) {
            nib = [[NSBundle mainBundle] loadNibNamed:@"MainFlyerCell-iPhone6-Plus" owner:self options:nil];
        }
        cell = (MainFlyerCell *)[nib objectAtIndex:0];
    }
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    if( !hideAd && [self isAddvertiseRow:rowNumber] ){ // Shows ads
        
        cell.cellImage.alpha = 0.0;
        cell.sideView.alpha = 0.0;
        cell.shareBtn.alpha = 0.0;
        cell.lblFlyerTitle.alpha = 0.0;
        cell.lblFlyerTitle.alpha = 0.0;
        cell.lblCreatedAt.alpha = 0.0;
        cell.imgSeperator.alpha = 0.0;
        
        if([FlyerlySingleton connected]){
            dispatch_async(dispatch_get_main_queue(), ^{
                int addRow = [self getIndexOfAd:rowNumber];
                GADBannerView *adView = self.bannerAdd[ addRow ];
                adView.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tView.frame.size.width, cell.frame.size.height);
                if( sizeRectForAdd.size.width != 0 ){
                    adView.frame = sizeRectForAdd;
                }
                self.bannerAdd[ addRow ] = adView;
                [cell addSubview:self.bannerAdd[ addRow ]];
            });
            return cell;
        } else {
            [cell addSubview: noAdsImage];
        }
        
        return cell;
        
    } else { // Shows flyers
        
        // If searching, it will load selected flyers else all flyers
        // To perform it asynchronously, dispatch_async is used
        
        if( isSearch ){
            dispatch_async(dispatch_get_main_queue(), ^{
                int flyerRow = rowNumber;
                if(!hideAd){
                    flyerRow = [self getIndexOfSelectedFlyer:rowNumber];
                }
                
                flyer = [[Flyer alloc] initWithPath:[searchFlyerPaths objectAtIndex:flyerRow] setDirectory:NO];
                [cell renderCell:flyer LockStatus:NO];
                [cell.flyerLock addTarget:self action:@selector(openInAppPanel) forControlEvents:UIControlEventTouchUpInside];
                cell.shareBtn.tag = indexPath.row;
                [cell.shareBtn addTarget:self action:@selector(onShare:) forControlEvents:UIControlEventTouchUpInside];
                
                // Adding UITapGestureRecognizer on UILable
                UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onShare:)];
                cell.lblFlyerTitle.tag = indexPath.row;
                cell.lblFlyerTitle.userInteractionEnabled = YES;
                [tap setNumberOfTapsRequired:1];
                [cell.lblFlyerTitle addGestureRecognizer:tap];
                
            });
            return cell;
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                int flyerRow = rowNumber;
                if(!hideAd){
                    flyerRow = [self getIndexOfFlyer:rowNumber];
                }
                
                // Load the flyers.
                flyerPaths = [self getFlyersPaths];
                flyer = [[Flyer alloc] initWithPath:[flyerPaths objectAtIndex:flyerRow] setDirectory:NO];
                [cell renderCell:flyer LockStatus:NO];
                [cell.flyerLock addTarget:self action:@selector(openInAppPanel) forControlEvents:UIControlEventTouchUpInside];
                cell.shareBtn.tag = indexPath.row;
                [cell.shareBtn addTarget:self action:@selector(onShare:) forControlEvents:UIControlEventTouchUpInside];
                
                // Adding UITapGestureRecognizer on UILable
                UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onShare:)];
                cell.lblFlyerTitle.tag = indexPath.row;
                cell.lblFlyerTitle.userInteractionEnabled = YES;
                [tap setNumberOfTapsRequired:1];
                [cell.lblFlyerTitle addGestureRecognizer:tap];
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
        
        if(isSearch){
            flyer = [[Flyer alloc]initWithPath:[searchFlyerPaths objectAtIndex:rowNumberSelectedFlyer] setDirectory:YES];
        } else {
            // Load the flyers.
            flyerPaths = [self getFlyersPaths];
            flyer = [[Flyer alloc]initWithPath:[flyerPaths objectAtIndex:rowNumber] setDirectory:YES];
        }
        
        createFlyer = [[CreateFlyerController alloc]initWithNibName:@"CreateFlyerController" bundle:nil];
        
        // Set CreateFlyer Screen
        createFlyer.flyer = flyer;
        
        __weak FlyerlyMainScreen *weakSelf = self;
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
        
        [createFlyer setShouldShowAdd:^(NSString *flyPath,BOOL haveValidSubscription) {
            dispatch_async( dispatch_get_main_queue(), ^{
                if (haveValidSubscription == NO && ([weakSelf.addInterstialFms isReady] && ![weakSelf.addInterstialFms hasBeenUsed]) ){
                    [weakSelf.addInterstialFms presentFromRootViewController:weakSelf];
                }  else{
                    [weakSelf saveAndRelease];
                }
            });
        }];
        
    } else {
        
        [self enableBtns:NO];
        
        if(isSearch){
            flyer = [[Flyer alloc]initWithPath:[searchFlyerPaths objectAtIndex:rowNumberSelectedFlyer] setDirectory:YES];
        } else {
            // Load the flyers.
            flyerPaths = [self getFlyersPaths];
            flyer = [[Flyer alloc]initWithPath:[flyerPaths objectAtIndex:rowNumber] setDirectory:YES];
        }
        
        createFlyer = [[CreateFlyerController alloc]initWithNibName:@"CreateFlyerController" bundle:nil];
        
        // Set CreateFlyer Screen
        createFlyer.flyer = flyer;
        
        __weak FlyerlyMainScreen *weakSelf = self;
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
        
        [createFlyer setShouldShowAdd:^(NSString *flyPath,BOOL haveValidSubscription) {
            dispatch_async( dispatch_get_main_queue(), ^{
                if (haveValidSubscription == NO && ([weakSelf.addInterstialFms isReady] && ![weakSelf.addInterstialFms hasBeenUsed]) ){
                    [weakSelf.addInterstialFms presentFromRootViewController:weakSelf];
                }  else{
                    [weakSelf saveAndRelease];
                }
            });
        }];
    }
    
    isComingFromCreateFlyer = YES;
    [self.navigationController pushViewController:createFlyer animated:YES];
}

/*
 * Opens InAppPurchase Panel
 */
-(void) openInAppPanel{
    inappviewcontroller = [InAppPurchaseRelatedMethods openInAppPurchasePanel:self];
}

/**
 * When interstial add received
 */
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    //adLoaded = true;
    //[self.addInterstialFms presentFromRootViewController:self];
}

/**
 * After dismiss of interstial add
 */
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    
    // To load (or reload) ads on home screen (FlyerlyMainScreen) after the full screen ad is closed
    [self loadFullScreenGoogleAdd];
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

/**
 * Request for google add
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
 * Load google add
 */
-(void)loadFullScreenGoogleAdd{
    self.addInterstialFms = [[GADInterstitial alloc] init];
    self.addInterstialFms.delegate = self;
    
    // Note: Edit SampleConstants.h to update kSampleAdUnitId with your addInterstialFms ad unit id.
    self.addInterstialFms.adUnitID = [flyerConfigurator interstitialAdID];
    [self.addInterstialFms loadRequest:[self request]];
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
            if ( isSearch ) {
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


- ( void )productSuccesfullyPurchased: (NSString *)productId {
    
    UserPurchases *userPurchases_ = [UserPurchases getInstance];
    userPurchases_.delegate = nil;
    
    if ( [userPurchases_ checkKeyExistsInPurchases: IN_APP_ID_SAVED_FLYERS] ) {
        
        [self.tView reloadData];
        [inappviewcontroller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
}
- ( void )inAppPurchasePanelContent {
    [inappviewcontroller inAppDataLoaded];
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView == signInAlert && buttonIndex == 0) {
        [self hideLoadingIndicator];
        
        if( rightBarButtonItem == nil ){
            [self setNavigation];
        } else {
            [self enableBtns:YES];
        }
    } else if(alertView == signInAlert && buttonIndex == 1) {
        [self signInRequired];
    }
}


-(void)enableHome:(BOOL)enable{
    [self.tView reloadData];
    [self enableBtns:YES];
}

/**
 * Enable touche on table view and buttons,
 * It was required when mergin process takes time, so prevent user to do any action
 */
-(void)enableBtns:(BOOL)enable{

    btnSettings.enabled = enable;
    rightBarButton.enabled = enable;
    leftBarButton.enabled = enable;
    btnCreateFlyer.enabled = enable;
    
    btnInvite.enabled = enable;
    btnSaved.enabled = enable;
    btnShared.enabled = enable;
    btnSocial.enabled = enable;
    
    tView.userInteractionEnabled = enable;
    
    if( enable ){
        [self hideLoadingIndicator];
    } else{
        [self showLoadingIndicator];
    }
}

/**
 * Set navigation bar
 */
-(void)setNavigation{
   
    // for Navigation Bar logo
    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 102, 38)];
    
    #if defined(FLYERLY)
        [logo setImage:[UIImage imageNamed:@"flyerlyLogo"]];
    #else
        [logo setImage:[UIImage imageNamed:@"flyerlyBizLogo"]];
    #endif
    
    self.navigationItem.titleView = logo;
    
    // to apply gesture recognizer on image(flyerlyLogo)
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [logo setUserInteractionEnabled:YES];
    [logo addGestureRecognizer:singleTap];
    
    // Settings Button
    btnSettings = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [btnSettings addTarget:self action:@selector(doAbout:) forControlEvents:UIControlEventTouchUpInside];
    [btnSettings setBackgroundImage:[UIImage imageNamed:@"settingsButton"] forState:UIControlStateNormal];
    btnSettings.showsTouchWhenHighlighted = YES;
    rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:btnSettings];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    // InApp Purchase Button
    btnInAppPurchase = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btnInAppPurchase addTarget:self action:@selector(openInAppPanel) forControlEvents:UIControlEventTouchUpInside];
    [btnInAppPurchase setBackgroundImage:[UIImage imageNamed:@"premium_features"] forState:UIControlStateNormal];
    btnInAppPurchase.showsTouchWhenHighlighted = YES;
    leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:btnInAppPurchase];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

/*
 * Here we Open Intro screens
 */
-(void)openIntro {
    
    introScreenViewController = [[IntroScreenViewController alloc] initWithNibName:@"IntroScreenViewController" bundle:nil];
    [introScreenViewController setModalPresentationStyle:UIModalPresentationFullScreen];
    introScreenViewController.buttonDelegate = self;
    
            //enable buttons if save to gallary not required
            if ( [flyer isVideoFlyer] ){
                [shareviewcontroller enableShareOptions:YES];
                [shareviewcontroller saveButtonSelected:YES];
                [shareviewcontroller haveVideoLinkEnableAllShareOptions:[[self.flyer getYouTubeStatus] isEqualToString:@"1"]];
            }

    
        
    [self presentViewController:introScreenViewController animated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];    
}

-(void)onShare:(id)sender {
    
    NSInteger row, index;
    
    // check the kind of control that called it
    if([sender isKindOfClass:[UIButton class]]){
        UIButton *clickButton = sender;
        row = clickButton.tag; //will get it from button tag
    }
    if([sender isKindOfClass:[UITapGestureRecognizer class]] ){
        UITapGestureRecognizer *gesture = sender;
        row = gesture.view.tag; //will get it from UITapGestureRecognizer tag
    }
    index = row;
    
    // To move cell to top
    [self.tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    if(row > (ADD_AFTER_FLYERS-1)){
        row = row - floor(row/ADD_AFTER_FLYERS);
    }
    
    if([txtSearch.text isEqualToString:@""]) {
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
            }else if ( IS_IPHONE_6 || IS_IPHONE_6_PLUS ) {
                shareviewcontroller = [[ShareViewController alloc] initWithNibName:@"ShareVideoViewController-iPhone6" bundle:nil];
            }
            
        } else {
            
            if ( IS_IPHONE_5 || IS_IPHONE_4) {
                shareviewcontroller = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
            }else if ( IS_IPHONE_6  || IS_IPHONE_6_PLUS ) {
                shareviewcontroller = [[ShareViewController alloc] initWithNibName:@"ShareViewController-iPhone6" bundle:nil];
            }
            
        }
       
        shareviewcontroller.cfController = (id)self;
        shareviewcontroller.fmController = (id) self;
        shareviewcontroller.indexRow = index;
        
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
        UIImage *shareImage =  [UIImage imageWithContentsOfFile:shareImagePath];
        
        //Here we Pass Param to Share Screen Which use for Sharing
        [shareviewcontroller.titleView resignFirstResponder];
        [shareviewcontroller.descriptionView resignFirstResponder];
        shareviewcontroller.selectedFlyerImage = shareImage;
        shareviewcontroller.flyer = self.flyer;
        shareviewcontroller.imageFileName = shareImagePath;
        shareviewcontroller.rightUndoBarButton = rightBarButton;
        shareviewcontroller.shareButton = btnSettings;
        
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
        
        
        // If video flyer has been saved,
        // enable share options (independent of Youtube Link)
        [shareviewcontroller enableShareOptions: YES];
        [shareviewcontroller saveButtonSelected: YES];
        
        // If uploaded video link of Youtube available,
        // enable other sharing options (dependent on Youtube Link)
        if (![isAnyVideoUploadOnYoutube isEqualToString:@""]) {
            [shareviewcontroller haveVideoLinkEnableAllShareOptions : [[self.flyer getYouTubeStatus] isEqualToString:@"1"]];
        }
        
        
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
        
        
        if ( !self.addInterstialFms.hasBeenUsed )
            [signInAlert show];
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

    __weak FlyerlyMainScreen *flyerlyMainScreen = self;

    UserPurchases *userPurchases_ = [UserPurchases getInstance];
    userPurchases_.delegate = self;

    signInController.signInCompletion = ^void(void) {
        flyerlyMainScreen.flyerPaths = [flyerlyMainScreen getFlyersPaths];
        UINavigationController* navigationController = flyerlyMainScreen.navigationController;
        [navigationController popViewControllerAnimated:NO];
        [userPurchases_ setUserPurcahsesFromParse];
    };

    [self.navigationController pushViewController:signInController animated:YES];
}

- (void) userPurchasesLoaded {
    
    UserPurchases *userPurchases_ = [UserPurchases getInstance];
    userPurchases_.delegate = nil;
    
    if ( [userPurchases_ checkKeyExistsInPurchases: IN_APP_ID_SAVED_FLYERS] ) {

        [self.tView reloadData];
        [inappviewcontroller.paidFeaturesTview reloadData];
    }else {
            
        [self presentViewController:inappviewcontroller animated:NO completion:nil];
    }

}

// Load Preferences Method
-(IBAction)doAbout:(id)sender{
    MainSettingViewController *mainsettingviewcontroller = [[MainSettingViewController alloc]initWithNibName:@"MainSettingViewController" bundle:nil] ;
    [self.navigationController pushViewController:mainsettingviewcontroller animated:YES];
}
//End


#pragma mark Tab Buttons Methods

// Load invite friends
-(IBAction)doInvite:(id)sender{
    
    //[self openIntro]; return; //for testing of intro screen
    
    //Checking if the user is valid or anonymous
    if ([[PFUser currentUser] sessionToken]) {

        __weak FlyerlyMainScreen *weakSelf = self;
        
        InviteFriendsController *addFriendsController = [[InviteFriendsController alloc]initWithNibName:@"InviteFriendsController" bundle:nil];
        
        [addFriendsController setShouldShowAdd:^(NSString *flyPath,BOOL haveValidSubscription) {
            dispatch_async( dispatch_get_main_queue(), ^{
                if (haveValidSubscription == NO && ([weakSelf.addInterstialFms isReady] && ![weakSelf.addInterstialFms hasBeenUsed]) ){
                    [weakSelf.addInterstialFms presentFromRootViewController:weakSelf];
                }
            });
        }];
        
        [self.navigationController pushViewController:addFriendsController animated:YES];
        
    } else {
        // Alert when user logged in as anonymous
        signInAlert = [[UIAlertView alloc] initWithTitle:@"Sign In" message:@"The selected feature requires that you sign in. Would you like to register or sign in now?" delegate:self cancelButtonTitle:@"Later" otherButtonTitles:@"Sign In",nil];
        [signInAlert show];
        
    }
    
}

/*
 * When invoked, shows unshared flyers
 */

- (IBAction)showUnsharedFlyers:(id)sender {


    FlyrViewController *flyrViewController = [[FlyrViewController alloc]initWithNibName:@"FlyrViewController" bundle:nil];
    
    __weak FlyerlyMainScreen *weakSelf = self;
    
    //Here we Manage Block for Update
    [flyrViewController setOnFlyerBack:^(NSString *nothing) {
        //[weakSelf saveAndRelease];
        
        [weakSelf enableBtns:YES];
        
        //HERE WE GET FLYERS
        weakSelf.flyerPaths = [weakSelf getFlyersPaths];
        
        [weakSelf loadAdsTiles];
        
        if( weakSelf.flyerPaths.count > 1 ){
            [weakSelf.tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        [weakSelf.tView reloadData];
        
    }];
    
    [flyrViewController setShouldShowAdd:^(NSString *flyPath,BOOL haveValidSubscription) {
        dispatch_async( dispatch_get_main_queue(), ^{
            if (haveValidSubscription == NO && ([weakSelf.addInterstialFms isReady] && ![weakSelf.addInterstialFms hasBeenUsed]) ){
                [weakSelf.addInterstialFms presentFromRootViewController:weakSelf];
            }
        });
    }];
    
    flyrViewController.showUnsharedFlyers = YES;
    [self.navigationController pushViewController:flyrViewController animated:YES];
}

/*
 * When invoked, shows shared flyers
 */

- (IBAction)showSharedFlyers:(id)sender {
    
    FlyrViewController *flyrViewController = [[FlyrViewController alloc]initWithNibName:@"FlyrViewController" bundle:nil];
    
    __weak FlyerlyMainScreen *weakSelf = self;
    
    //Here we Manage Block for Update
    [flyrViewController setOnFlyerBack:^(NSString *nothing) {
        //[weakSelf saveAndRelease];
        
        [weakSelf enableBtns:YES];
        
        //HERE WE GET FLYERS
        weakSelf.flyerPaths = [weakSelf getFlyersPaths];
        
        [weakSelf loadAdsTiles];
        
        if( weakSelf.flyerPaths.count > 1 ){
            [weakSelf.tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        [weakSelf.tView reloadData];
        
    }];
    
    [flyrViewController setShouldShowAdd:^(NSString *flyPath,BOOL haveValidSubscription) {
        dispatch_async( dispatch_get_main_queue(), ^{
            if (haveValidSubscription == NO && ([weakSelf.addInterstialFms isReady] && ![weakSelf.addInterstialFms hasBeenUsed]) ){
                [weakSelf.addInterstialFms presentFromRootViewController:weakSelf];
            }
        });
    }];
    
    flyrViewController.showUnsharedFlyers = NO;
    [self.navigationController pushViewController:flyrViewController animated:YES];
}


/*
 * When invoked, shows shared flyers with Hash Tags
 */
- (IBAction)showHashTagFlyers:(id)sender {
    
    WebViewController *webViewController = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    
    __weak FlyerlyMainScreen *weakSelf = self;
    
    //Here we Manage Block for Update
    [webViewController setOnFlyerBack:^(NSString *nothing) {
        //[weakSelf saveAndRelease];
        
        [weakSelf enableBtns:YES];
        
        //HERE WE GET FLYERS
        weakSelf.flyerPaths = [weakSelf getFlyersPaths];
        
        [weakSelf loadAdsTiles];
        
        if( weakSelf.flyerPaths.count > 1 ){
            [weakSelf.tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        [weakSelf.tView reloadData];
        
    }];
    
    [webViewController setShouldShowAdd:^(NSString *flyPath,BOOL haveValidSubscription) {
        dispatch_async( dispatch_get_main_queue(), ^{
            if (haveValidSubscription == NO && ([weakSelf.addInterstialFms isReady] && ![weakSelf.addInterstialFms hasBeenUsed]) ){
                [weakSelf.addInterstialFms presentFromRootViewController:weakSelf];
            }
        });
    }];
   
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark  Text Field Delegete

/*
 * When any key of a keyboard of a textview is pressed, it is invoked
 * @params:
 *      sender(uicontrol):id
 * @return:
 *      void
 */

- (void)textFieldTapped:(id)sender {
    
    if (txtSearch.text == nil || [txtSearch.text isEqualToString:@""])
    {
        isSearch = NO;
        [self.tView reloadData];
        [txtSearch resignFirstResponder];
    }else{
        isSearch = YES;
        [self searchTableView:[NSString stringWithFormat:@"%@", ((UITextField *)sender).text]];
    }
}

/*
 * When any key of a keyboard of a textview is pressed, it is invoked
 * @params:
 *      textField(UITextField):UITextField
 *      range: NSRange
 *      string: NSString
 * @return:
 *      BOOL
 */

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if([string isEqualToString:@"\n"]){
        if([txtSearch canResignFirstResponder])
        {
            [txtSearch resignFirstResponder];
        }
        return NO;
    }
    
    if(isSearch){
        if([string isEqualToString:@"\n"]){
            
            if([txtSearch canResignFirstResponder])
            {
                [txtSearch resignFirstResponder];
            }
        }
    }
    return YES;
}

@end
