//
//  FlyerlyMainScreen.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 22/Jan/2014.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FlyerlyMainScreen.h"
#import "UserPurchases.h"
#import "UserVoice.h"


@implementation FlyerlyMainScreen

@synthesize sharePanel,tView;
@synthesize searchTextField;
@synthesize flyerPaths;
@synthesize flyer, signInAlert;

id lastShareBtnSender;

#pragma mark  View Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    lastShareBtnSender = nil;
    
    UVConfig *config = [UVConfig configWithSite:@"http://flyerly.uservoice.com/"];
    [UserVoice initialize:config];
    
    searching = NO;

    [self.view setBackgroundColor:[UIColor colorWithRed:245/255.0 green:241/255.0 blue:222/255.0 alpha:1.0]];
    
    self.navigationItem.hidesBackButton = YES;
    searchTextField.font = [UIFont systemFontOfSize:12.0];
    searchTextField.textAlignment = NSTextAlignmentLeft;
    searchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [searchTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [searchTextField setReturnKeyType:UIReturnKeyDone];
    
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
    
    // Set left bar items
    [self.navigationItem setLeftBarButtonItems: [self leftBarItems]];
    
    // Set right bar items
    [self.navigationItem setRightBarButtonItems: [self rightBarItems]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    searching = NO;
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
        searching = NO;
        [self.tView reloadData];
        [searchTextField resignFirstResponder];
    }else{
        searching = YES;
        [self searchTableView:[NSString stringWithFormat:@"%@", ((UITextField *)sender).text]];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if([string isEqualToString:@"\n"]){
        if([searchTextField canResignFirstResponder])
        {
            [searchTextField resignFirstResponder];
        }
        return NO;
    }
    
    if(searching){
        if([string isEqualToString:@"\n"]){
            
            if([searchTextField canResignFirstResponder])
            {
                [searchTextField resignFirstResponder];
            }
        }
    }
    return YES;
}


#pragma mark  custom Methods

- (void) searchTableView:(NSString *)schTxt {
	NSString *sTemp;
    NSString *sTemp1;
	NSString *sTemp2;

	NSString *searchText = searchTextField.text;
   
	searchFlyerPaths = [[NSMutableArray alloc] init];
	
	for (int i =0 ; i < [flyerPaths count] ; i++)
	{
		
        Flyer *fly = [[Flyer alloc] initWithPath:[flyerPaths objectAtIndex:i] setDirectory:NO];
        
 		sTemp = [fly getFlyerTitle];
        sTemp1 = [fly getFlyerDescription];
        sTemp2 = [fly getFlyerDate];

        
        NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
        NSRange titleResultsRange1 = [sTemp1 rangeOfString:searchText options:NSCaseInsensitiveSearch];
        NSRange titleResultsRange2 = [sTemp2 rangeOfString:searchText options:NSCaseInsensitiveSearch];

        if (titleResultsRange.length > 0 || titleResultsRange1.length > 0 || titleResultsRange2.length > 0){

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
    
    __weak FlyerlyMainScreen *weakSelf = self;
    __weak CreateFlyerController *weakCreate = createFlyer;
    
    //Here we Manage Block for Update
    [createFlyer setOnFlyerBack:^(NSString *nothing) {
        [weakCreate.flyer saveAfterCheck];
        
        [weakSelf enableBtns:YES];
        
        //HERE WE GET FLYERS
        weakSelf.flyerPaths = [weakSelf getFlyersPaths];
        [weakSelf.tView reloadData];
        
    }];

    [createFlyer setShouldShowAdd:^(NSString *flyPath,BOOL haveValidSubscription) {
        dispatch_async( dispatch_get_main_queue(), ^{
            if (haveValidSubscription == NO && ([weakSelf.interstitial isReady] && ![weakSelf.interstitial hasBeenUsed]) ){
                [weakSelf.interstitial presentFromRootViewController:weakSelf];
            }  else{
                [weakCreate.flyer saveAfterCheck];
            }
        });
    }];
    
	[self.navigationController pushViewController:createFlyer animated:YES];
    
}

- (void)inAppPanelDismissed {

}

-(void)goBack{
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
    [backButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"home_button"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];

    return [NSMutableArray arrayWithObjects:backBarButton,leftBarButton,nil];
}

-(void)loadHelpController{
    
    [UserVoice presentUserVoiceInterfaceForParentViewController:self];
}


-(NSArray *)rightBarItems{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];
    label.text = @"SAVED";
    self.navigationItem.titleView = label;

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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (searching){
        return  [searchFlyerPaths count];
    }else{
        return  [flyerPaths count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"Cell";
    SaveFlyerCell *cell = (SaveFlyerCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    if (cell == nil) {
        if( IS_IPHONE_5 || IS_IPHONE_4){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SaveFlyerCell" owner:self options:nil];
            cell = (SaveFlyerCell *)[nib objectAtIndex:0];
        } else if ( IS_IPHONE_6 ){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SaveFlyerCell-iPhone6" owner:self options:nil];
            cell = (SaveFlyerCell *)[nib objectAtIndex:0];
        } else if ( IS_IPHONE_6_PLUS ) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SaveFlyerCell-iPhone6-Plus" owner:self options:nil];
            cell = (SaveFlyerCell *)[nib objectAtIndex:0];
        } else {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SaveFlyerCell" owner:self options:nil];
            cell = (SaveFlyerCell *)[nib objectAtIndex:0];
        }
        
        
    }
    
    if( searching ){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            flyer = [[Flyer alloc] initWithPath:[searchFlyerPaths objectAtIndex:indexPath.row] setDirectory:NO];
            [cell renderCell:flyer LockStatus:lockFlyer];
            [cell.flyerLock addTarget:self action:@selector(openPanel) forControlEvents:UIControlEventTouchUpInside];
            cell.shareBtn.tag = indexPath.row;
            [cell.shareBtn addTarget:self action:@selector(onShare:) forControlEvents:UIControlEventTouchUpInside];
            
        });


        return cell;
        

    }else{

        dispatch_async(dispatch_get_main_queue(), ^{
            
            flyer = [[Flyer alloc] initWithPath:[flyerPaths objectAtIndex:indexPath.row] setDirectory:NO];
            [cell renderCell:flyer LockStatus:lockFlyer];
            [cell.flyerLock addTarget:self action:@selector(openPanel) forControlEvents:UIControlEventTouchUpInside];
            cell.shareBtn.tag = indexPath.row;
            [cell.shareBtn addTarget:self action:@selector(onShare:) forControlEvents:UIControlEventTouchUpInside];
            
        });


         return cell;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self enableBtns:NO];
    
    flyer = [[Flyer alloc]initWithPath:[flyerPaths objectAtIndex:indexPath.row] setDirectory:YES];
    
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
        [weakSelf.tView reloadData];
        
    }];
    
    [createFlyer setShouldShowAdd:^(NSString *flyPath,BOOL haveValidSubscription) {
        dispatch_async( dispatch_get_main_queue(), ^{
            if (haveValidSubscription == NO && ([weakSelf.interstitial isReady] && ![weakSelf.interstitial hasBeenUsed]) ){
                [weakSelf.interstitial presentFromRootViewController:weakSelf];
            } else{
                [weakCreate.flyer saveAfterCheck];
            }
        });
    }];
    
	[self.navigationController pushViewController:createFlyer animated:YES];
}
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    //on add dismiss && after merging video process, save in gallery
    [createFlyer.flyer saveAfterCheck];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
	[tableView beginUpdates];
	[tableView setEditing:YES animated:YES];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [tableView deleteRowsAtIndexPaths:
        @[[NSIndexPath indexPathForRow:indexPath.row  inSection:indexPath.section]]
                         withRowAnimation:UITableViewRowAnimationLeft];
        
        // HERE WE REMOVE FLYER FROM DIRECTORY
        if ( searching ) {
            
            [[NSFileManager defaultManager] removeItemAtPath:[searchFlyerPaths objectAtIndex:indexPath.row] error:nil];
            [searchFlyerPaths removeObjectAtIndex:indexPath.row];

        } else {
            
            [[NSFileManager defaultManager] removeItemAtPath:[flyerPaths objectAtIndex:indexPath.row] error:nil];
            [flyerPaths removeObjectAtIndex:indexPath.row];
        }

	}
    
    [tableView setEditing:NO animated:YES];
	[tableView endUpdates];
	[tableView reloadData];
}


- ( void )productSuccesfullyPurchased: (NSString *)productId {
    
    UserPurchases *userPurchases_ = [UserPurchases getInstance];
    
    if ( [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyAllDesignBundle"] ||
        [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyUnlockSavedFlyers"] ) {
        
        lockFlyer = NO;
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

    backButton.enabled = enable;
    helpButton.enabled = enable;
    createButton.enabled = enable;
    rightUndoBarButton.enabled = enable;
    
    tView.userInteractionEnabled = enable;
    
    if( enable ){
        // Set right bar items
        [self.navigationItem setRightBarButtonItems: [self rightBarItems]];
    }
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
        
        
        if ( !self.interstitial.hasBeenUsed )
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
        UINavigationController* navigationController = flyerlyMainScreen.navigationController;
        [navigationController popViewControllerAnimated:NO];
        [userPurchases_ setUserPurcahsesFromParse];

        if( lastShareBtnSender != nil ){
            [flyerlyMainScreen onShare:lastShareBtnSender];
        }
        [flyerlyMainScreen enableBtns:YES];
        [flyerlyMainScreen hideLoadingIndicator];
    };

    [self.navigationController pushViewController:signInController animated:YES];
}

- (void) userPurchasesLoaded {
    
    UserPurchases *userPurchases_ = [UserPurchases getInstance];
    
    if ( [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyAllDesignBundle"]  ||
         [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyUnlockSavedFlyers"] ) {

        lockFlyer = NO;
        [self.tView reloadData];
        [inappviewcontroller.paidFeaturesTview reloadData];
    }else {
            
        [self presentViewController:inappviewcontroller animated:NO completion:nil];
    }

}

@end



