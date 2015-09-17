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
#import "MainScreenAddsCell.h"

#define ADD_AFTER_FLYERS 4 //SHOW AD AFTER (ADD_AFTER_FLYERS - 1 ) => 3 FLYERS

@interface FlyerlyMainScreen ()  {
    
    FlyerlyConfigurator *flyerConfigurator;
    int addsCount;
    int addsLoaded;
    CGRect sizeRectForAdd;
}

@end

@implementation FlyerlyMainScreen

@synthesize sharePanel,tView;
@synthesize flyerPaths;
@synthesize flyer, signInAlert,settingBtn;

id lastShareBtnSender;

#pragma mark  View Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    flyerConfigurator = appDelegate.flyerConfigurator;
    
    lastShareBtnSender = nil;
    self.navigationItem.hidesBackButton = YES;

	tView.dataSource = self;
	tView.delegate = self;
    [self.view addSubview:tView];
    [self.tView setBackgroundView:nil];
    [self.tView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

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
        [self loadGoogleAdd];
    });
    
    [self loadAddTiles];

    [self.view bringSubviewToFront:settingBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self checkUserPurchases];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if( sizeRectForAdd.size.width == 0 ){
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        MainFlyerCell *cell = (MainFlyerCell *)[self.tView cellForRowAtIndexPath:indexPath];
        sizeRectForAdd = CGRectMake(cell.cellImage.frame.origin.x,cell.cellImage.frame.origin.y,(cell.cellImage.frame.size.width+cell.sideView.frame.size.width),cell.cellImage.frame.size.height);
        NSLog(@"flyerImg(%f,%f)",cell.cellImage.frame.size.width,cell.cellImage.frame.size.height);
    }
    
    NSLog(@"sizeRectForAdd(%f,%f,%f,%f,)",sizeRectForAdd.origin.x,sizeRectForAdd.origin.y,sizeRectForAdd.size.width,sizeRectForAdd.size.height);
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.alpha = 1.0;
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
        
        //GET UPDATED USER PUCHASES INFO
        [userPurchases_ setUserPurcahsesFromParse];
        
    } else {
        NSLog(@"Anonymous, User is NOT authenticated.");
    }
}

#pragma mark  Text Field Delegete

- (void)textFieldTapped:(id)sender {
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}


#pragma mark  custom Methods

- (void) searchTableView:(NSString *)schTxt {
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
    __weak CreateFlyerController *weakCreate = createFlyer;
    
    //Here we Manage Block for Update
    [createFlyer setOnFlyerBack:^(NSString *nothing) {
        [weakCreate.flyer saveAfterCheck];
        
        [weakSelf enableBtns:YES];
        
        //HERE WE GET FLYERS
        weakSelf.flyerPaths = [weakSelf getFlyersPaths];
        
        [weakSelf loadAddTiles];
        
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
                [weakCreate.flyer saveAfterCheck];
            }
        });
    }];
    
	[self.navigationController pushViewController:createFlyer animated:YES];
    
}

- (void)inAppPanelDismissed {

}

-(NSArray *)leftBarItems{
    inviteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [inviteButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [inviteButton setBackgroundImage:[UIImage imageNamed:@"invite_friend"] forState:UIControlStateNormal];
    [inviteButton addTarget:self action:@selector(doInvite:) forControlEvents:UIControlEventTouchUpInside];
    inviteButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:inviteButton];

    return [NSMutableArray arrayWithObjects:backBarButton,nil];
}




-(NSArray *)rightBarItems{
    
    // for Navigation Bar logo
    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 102, 38)];
    [logo setImage:[UIImage imageNamed:@"flyerlylogo"]];
    self.navigationItem.titleView = logo;

    // Create Button
    createButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [createButton addTarget:self action:@selector(createFlyer:) forControlEvents:UIControlEventTouchUpInside];
    [createButton setBackgroundImage:[UIImage imageNamed:@"createButton"] forState:UIControlStateNormal];
    createButton.showsTouchWhenHighlighted = YES;
    rightUndoBarButton = [[UIBarButtonItem alloc] initWithCustomView:createButton];
    
    return [NSMutableArray arrayWithObjects:rightUndoBarButton,nil];
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
 * Return incremented numbers of rows with respect to add
 */
-(int)getRowsCountWithAdds{
    int flyersCount = (int)flyerPaths.count;
    addsCount = floor(flyersCount/ (ADD_AFTER_FLYERS -1) );
    int total = flyersCount + addsCount;
    
    return  total;
}

/**
 * Get index of add row
 */
-(int)getIndexOfAdd:(int)rowNumber{
    rowNumber++;
    int row = floor(rowNumber / ADD_AFTER_FLYERS ) - 1;
    return  row;
}

/**
 * Get index of flyer row
 */
-(int)getIndexOfFlyer:(int)rowNumber{
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

// We've received an Banner ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    //Adding ad in custom view
    if( addsLoaded < self.bannerAdd.count ){
        if( sizeRectForAdd.size.width != 0 ){
            adView.frame = sizeRectForAdd;
        }
        self.bannerAdd[addsLoaded] = adView;
    }
    addsLoaded++;
}

/**
 * Load addvertise tiles
 */
-(void)loadAddTiles{
    __block int i=-1;
    addsLoaded = 0;
    
    if( self.bannerAdd == nil )
        self.bannerAdd = [[NSMutableArray alloc] init];
    
    [self getRowsCountWithAdds]; // addsCount will be set in this function
    
    if( self.bannerAdd.count >= addsCount )
    return; //dont load adds if we already have
    
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

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self getRowsCountWithAdds];
}

-(MainFlyerCell *)getMainFlyerCell:(MainFlyerCell *)cell{
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainFlyerCell-iPhone6" owner:self options:nil];
        cell = (MainFlyerCell *)[nib objectAtIndex:0];
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int rowNumber = (int)indexPath.row;
    NSString *showCell = @"MainFlyerCell-iPhone6";

    if( [self isAddvertiseRow:rowNumber] ) {
        showCell = @"MainScreenAddsCell";
    }
    
    
    if( [showCell isEqualToString:@"MainFlyerCell-iPhone6"] ){
        static NSString *MainFlyerCellId = @"MainFlyerCellId";
        MainFlyerCell *cell = (MainFlyerCell *)[tableView dequeueReusableCellWithIdentifier:MainFlyerCellId];
        cell = [self getMainFlyerCell:cell];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
                int flyerRow = [self getIndexOfFlyer:rowNumber];
                flyer = [[Flyer alloc] initWithPath:[flyerPaths objectAtIndex:flyerRow] setDirectory:NO];
                [cell renderCell:flyer LockStatus:NO];
                [cell.flyerLock addTarget:self action:@selector(openPanel) forControlEvents:UIControlEventTouchUpInside];
                cell.shareBtn.tag = indexPath.row;
                [cell.shareBtn addTarget:self action:@selector(onShare:) forControlEvents:UIControlEventTouchUpInside];
        });
        
        return cell;
    }
    else/* if( [showCell isEqualToString:@"MainScreenAddsCell"] )*/{
        static NSString *MainScreenAddsCellId = @"MainScreenAddsCell";
        MainScreenAddsCell *cell = (MainScreenAddsCell *)[tableView dequeueReusableCellWithIdentifier:MainScreenAddsCellId];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainScreenAddsCell" owner:self options:nil];
        cell = (MainScreenAddsCell *)[nib objectAtIndex:0];

        int addRow = [self getIndexOfAdd:rowNumber];
        GADBannerView *adView = self.bannerAdd[ addRow ];
        adView.frame = CGRectMake(cell.frame.origin.x+10, cell.frame.origin.y+10, tView.frame.size.width-20, cell.frame.size.height-20);
        if( sizeRectForAdd.size.width != 0 ){
            adView.frame = sizeRectForAdd;
        }
        self.bannerAdd[ addRow ] = adView;
        [cell addSubview:self.bannerAdd[ addRow ]];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int rowNumber = (int)indexPath.row;
    if( [self isAddvertiseRow:rowNumber] == NO ) {
        rowNumber = [self getIndexOfFlyer:rowNumber];
        
        [self enableBtns:NO];
        
        flyer = [[Flyer alloc]initWithPath:[flyerPaths objectAtIndex:rowNumber] setDirectory:YES];
        
        createFlyer = [[CreateFlyerController alloc]initWithNibName:@"CreateFlyerController" bundle:nil];
        
        // Set CreateFlyer Screen
        createFlyer.flyer = flyer;
        
        __weak FlyerlyMainScreen *weakSelf = self;
        __weak CreateFlyerController *weakCreate = createFlyer;
        
        //Here we Manage Block for Update
        [createFlyer setOnFlyerBack:^(NSString *nothing) {
            
            // Here we setCurrent Flyer is Most Recent Flyer
            [weakCreate.flyer setRecentFlyer];
            
            [weakCreate.flyer saveAfterCheck];

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
                if ( haveValidSubscription == NO && ([weakSelf.addInterstialFms isReady] && ![weakSelf.addInterstialFms hasBeenUsed]) ){
                    [weakSelf.addInterstialFms presentFromRootViewController:weakSelf];
                } else{
                    [weakCreate.flyer saveAfterCheck];
                }
            });
        }];
        
        [self.navigationController pushViewController:createFlyer animated:YES];
    }
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
    //on add dismiss && after merging video process, save in gallery
    [createFlyer.flyer saveAfterCheck];
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
-(void)loadGoogleAdd{
    self.addInterstialFms = [[GADInterstitial alloc] init];
    self.addInterstialFms.delegate = self;
    
    // Note: Edit SampleConstants.h to update kSampleAdUnitId with your addInterstialFms ad unit id.
    self.addInterstialFms.adUnitID = [flyerConfigurator interstitialAdID];
    [self.addInterstialFms loadRequest:[self request]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    int rowNumber = (int)indexPath.row;

    if( [self isAddvertiseRow:rowNumber] == NO ) {
        rowNumber = [self getIndexOfFlyer:rowNumber];

        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            [[NSFileManager defaultManager] removeItemAtPath:[flyerPaths objectAtIndex:rowNumber] error:nil];
            [flyerPaths removeObjectAtIndex:rowNumber];
        }

        [tableView reloadData];
    }
}


- ( void )productSuccesfullyPurchased: (NSString *)productId {
    
    UserPurchases *userPurchases_ = [UserPurchases getInstance];
    
    if ( [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyAllDesignBundle"] ||
        [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyUnlockSavedFlyers"] ) {
        
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
        [self enableBtns:YES];
        [self hideLoadingIndicator];
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

    inviteButton.enabled = enable;
    createButton.enabled = enable;
    rightUndoBarButton.enabled = enable;
    settingBtn.enabled = enable;
    
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
    // Set left bar items
    [self.navigationItem setLeftBarButtonItems: [self leftBarItems]];

    // Set right bar items
    [self.navigationItem setRightBarButtonItems: [self rightBarItems]];
}

/*
 * Here we Open Intro screens
 */
-(void)openIntro {
    
    introScreenViewController = [[IntroScreenViewController alloc] initWithNibName:@"IntroScreenViewController" bundle:nil];
    [introScreenViewController setModalPresentationStyle:UIModalPresentationFullScreen];
    introScreenViewController.buttonDelegate = self;
    
    [self presentViewController:introScreenViewController animated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];    
}

/*
 * Here we Open InAppPurchase Panel
 */
-(void)openPanel {
    
    if( IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ){
        inappviewcontroller = [[InAppViewController alloc] initWithNibName:@"InAppViewController" bundle:nil];
    } else {
        inappviewcontroller = [[InAppViewController alloc] initWithNibName:@"InAppViewController-iPhone4" bundle:nil];
    }
    
    [self presentViewController:inappviewcontroller animated:NO completion:nil];
    
    [inappviewcontroller requestProduct];
    inappviewcontroller.buttondelegate = self;
}

-(void)onShare:(id)sender {
    UIButton *clickButton = sender;
    NSInteger row = clickButton.tag; ///will get it from button tag
    flyer = [[Flyer alloc] initWithPath:[flyerPaths objectAtIndex:row] setDirectory:NO];
    
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
        UIImage *shareImage =  [UIImage imageWithContentsOfFile:shareImagePath];
        
        //Here we Pass Param to Share Screen Which use for Sharing
        [shareviewcontroller.titleView resignFirstResponder];
        [shareviewcontroller.descriptionView resignFirstResponder];
        shareviewcontroller.selectedFlyerImage = shareImage;
        shareviewcontroller.flyer = self.flyer;
        shareviewcontroller.imageFileName = shareImagePath;
        shareviewcontroller.rightUndoBarButton = rightUndoBarButton;
        shareviewcontroller.shareButton = createButton;
        shareviewcontroller.backButton = inviteButton;
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
            [shareviewcontroller enableAllShareOptions];
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
    
    if ( [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyAllDesignBundle"]  ||
         [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyUnlockSavedFlyers"] ) {

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

// Load invite friends
-(IBAction)doInvite:(id)sender{
    
    //[self openIntro]; return; //for testing of intro screen
    
    //Checking if the user is valid or anonymous
    if ([[PFUser currentUser] sessionToken]) {
        
        InviteFriendsController *addFriendsController = [[InviteFriendsController alloc]initWithNibName:@"InviteFriendsController" bundle:nil];
        
        [self.navigationController pushViewController:addFriendsController animated:YES];
        
    } else {
        // Alert when user logged in as anonymous
        signInAlert = [[UIAlertView alloc] initWithTitle:@"Sign In" message:@"The selected feature requires that you sign in. Would you like to register or sign in now?" delegate:self cancelButtonTitle:@"Later" otherButtonTitles:@"Sign In",nil];
        [signInAlert show];
        
    }
    
}
@end