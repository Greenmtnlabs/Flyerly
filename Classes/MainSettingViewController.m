//
//  MainSettingViewController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd on 07/08/2013.
//
//

#import "MainSettingViewController.h"
#import "UserVoice.h"
#import "IntroScreenViewController.h"
#import "Common.h"
#import "SHKActivityIndicator.h"

@interface MainSettingViewController () {
    
    SHKSharer *iosSharer;
    FlyerlyConfigurator *flyerConfigurator;
    BOOL canShowAd;
    UserPurchases *userPurchases;
    NSString *productIdentifier;
}


@end

@implementation MainSettingViewController
@synthesize tableView,_persistence;
@synthesize bannerAdsView, btnBannerAdsDismiss;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    flyerConfigurator = appDelegate.flyerConfigurator;
    
    userPurchases = [UserPurchases getInstance];
    userPurchases.delegate = self;
    canShowAd = [userPurchases canShowAd];

    
    bannerAdClosed = NO;
    bannerShowed = NO;
    
    UVConfig *config = [UVConfig configWithSite:@"http://flyerly.uservoice.com/"];
    [UserVoice initialize:config];
    
    globle = [FlyerlySingleton RetrieveSingleton];
    [self.view setBackgroundColor:[UIColor colorWithRed:245/255.0 green:241/255.0 blue:222/255.0 alpha:1]];
    self.tableView.rowHeight = 40;

    self.tableView.backgroundView = nil;
    [self.tableView setBackgroundColor:[UIColor colorWithRed:245/255.0 green:241/255.0 blue:222/255.0 alpha:1]];
    [self.tableView setSeparatorColor:[UIColor lightGrayColor]];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.tableView.contentInset = UIEdgeInsetsMake(-92, 0, 0, 0);
    }

    self.navigationItem.hidesBackButton = YES;
    
    UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [helpButton setBackgroundImage:[UIImage imageNamed:@"help_icon"] forState:UIControlStateNormal];
    [helpButton addTarget:self action:@selector(gohelp) forControlEvents:UIControlEventTouchUpInside];
    helpButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *helpBarButton = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"home_button"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:backBarButton,helpBarButton,nil ]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-35, -6, 50, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];
    label.text = @"SETTINGS";
    
    self.navigationItem.titleView = label;
    
    category = [[NSMutableArray alloc] init];
    [category addObject:@"Premium Features"];//0 -- category - array index number, it will help when we ask for cellForRowAtIndex
    [category addObject:@"Autosave to Gallery"];//1
    [category addObject:@"Flyers are public"];//2
    
    BOOL IS_LOGIN = [self isLogin];
    //Checking if the user is valid or anonymous
    if ( IS_LOGIN ) {
        //GET UPDATED USER PUCHASES INFO
        [category addObject:@"Account Setting"];//3
    }
    
    [category addObject:@"Like us on Facebook"];//4/3
    [category addObject:@"Follow us on Twitter"];//5/4
    

    //Checking if the user is valid or anonymus
    if ( IS_LOGIN ) {
        [category addObject:@"Sign Out"];//6
    } else {
        [category addObject:@"Sign In"];//5
    }
    [category addObject:@"Terms of Service"];//7,6
    [category addObject:@"Privacy Policy"];//8,7
    [category addObject:@"How To"];//9,8
    [category addObject:@"Partner Apps"];//10,9 --
    [category addObject:@"Untech"];//11,10
    [category addObject:@"eyeSPOT"];//12,11
    
    #if defined(FLYERLY)
        [category addObject:@"FlyerlyBiz"];
    #else
        [category addObject:@"Flyerly"];
    #endif
    

    // will remove in production build, this row must be in the end of table view
    if ( IS_LOGIN && [flyerConfigurator currentDebugMood] ){
        [category addObject:@"Clear Purchases"];//13
    }
    
    if([FlyerlySingleton connected]){
        if( canShowAd ) {
            [self loadInterstitialAdd];
        }
    }
    
    
    // Execute the rest of the stuff, a little delayed to speed up loading.
    dispatch_async( dispatch_get_main_queue(), ^{
        
        if( IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ){
            
            if( canShowAd ) {
                self.bannerAdsView.adUnitID = [flyerConfigurator bannerAdID];
                self.bannerAdsView.delegate = self;
                self.bannerAdsView.rootViewController = self;
                [self.bannerAdsView loadRequest:[self request]];
            }
        }
    });
   
}


- (void)viewWillAppear:(BOOL)animated{
    btnBannerAdsDismiss.alpha = 0.0;
    bannerAdsView.alpha = 0.0;
}

//return flag is login
- (BOOL)isLogin{
    return ([[PFUser currentUser] sessionToken].length != 0);
}

#pragma TableView Events

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return [category count];
}

- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"SettingCell";
    
    // Create My custom cell view
    MainSettingCell *cell = (MainSettingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( cell == nil ) {
        cell = [[MainSettingCell alloc] init] ;
        // Create Imageview for image
        cell.imgview = [[UIImageView alloc]init];
        [cell.imgview setFrame:CGRectMake(4, 7, 25, 25)];
        [cell.contentView addSubview:cell.imgview];
        
        // Create Labels for text
        cell.description = [[UILabel alloc]initWithFrame:CGRectMake(35, 9, 250, 21)];
        [cell.description setBackgroundColor:[UIColor clearColor]];
        [cell.description setTextColor:[UIColor darkGrayColor]];
        [cell.description setFont:[UIFont fontWithName:@"AvenirNext-Bold" size:14]];
        [cell.description setTextAlignment:NSTextAlignmentLeft];
        [cell.contentView addSubview:cell.description];

        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settingsrow"]]];
    }

    NSString *title =[NSString stringWithFormat:@"%@",category[indexPath.row]];
    NSString *imgname =@"";

    if (indexPath.row == 0){
        imgname = @"premium_features";
    }
    else if (indexPath.row == 1){
        imgname = @"save_gallery";
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settingsrow"]]];
        
        UISwitch *mSwitch;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            mSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(263, 4, 0, 0)];
            if ( IS_IPHONE_6 )
                mSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(320, 4, 0, 0)];
            else if ( IS_IPHONE_6_PLUS )
                mSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(350, 4, 0, 0)];
        }else{
            mSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(223, 4, 0, 0)] ;
        }
        
        [cell.contentView  addSubview:mSwitch];
        [mSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
        
        NSString  *savecamra = [[NSUserDefaults standardUserDefaults] stringForKey:@"saveToCameraRollSetting"];
        if (savecamra == nil) {
            [mSwitch setOn:NO];
        }else{
            [mSwitch setOn:YES];
        }
    }
    else if (indexPath.row == 2){
        UISwitch *mSwitch;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            mSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(263, 4, 0, 0)] ;
            if ( IS_IPHONE_6 )
                mSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(320, 4, 0, 0)];
            else if ( IS_IPHONE_6_PLUS )
                mSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(350, 4, 0, 0)];
        }else{
            mSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(223, 4, 0, 0)] ;
        }
        
        [cell.contentView  addSubview:mSwitch];
        [mSwitch addTarget:self action:@selector(flyerlypublic:) forControlEvents:UIControlEventValueChanged];
        
        NSString  *typ = [[NSUserDefaults standardUserDefaults] stringForKey:@"FlyerlyPublic"];
        if ([typ isEqualToString:@"Public"]) {
            [mSwitch setOn:YES];
        }else{
            [mSwitch setOn:NO];
        }
        
        imgname = @"privacy_icon";
        
    }
    else if (indexPath.row == 3){
        //Checking if the user is valid or anonymus
        if ([[PFUser currentUser] sessionToken].length != 0) {
            //account setting row clicked
            imgname = @"account_settings";
            [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SettingcellBack"]]];
        }
    }
    
    if ( [self isLogin] ) {
        if (indexPath.row == 4)imgname = @"fb_Like";
        if (indexPath.row == 5)imgname = @"twt_follow";
        if (indexPath.row == 6)imgname = @"signout";
        if (indexPath.row == 7)imgname = @"tnc";
        if (indexPath.row == 8)imgname = @"privacy";
        if (indexPath.row == 9)imgname = @"howto"; // How To
        
        // only for Partner Apps
        if (indexPath.row == 10){
            // Create Labels for text
            cell.description = [[UILabel alloc]initWithFrame:CGRectMake(5, 17, 250, 21)];
            [cell.description setBackgroundColor:[UIColor clearColor]];
            [cell.description setTextColor:[UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0]];
            [cell.description setFont:[UIFont fontWithName:@"AvenirNext-Bold" size:16]];
            [cell.description setTextAlignment:NSTextAlignmentLeft];
            [cell.contentView addSubview:cell.description];
            [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settingsrow"]]];
        }
        if (indexPath.row == 11)imgname = @"icon_untech";//untech
        if (indexPath.row == 12)imgname = @"icon_eyespot";//eyespot
        if (indexPath.row == 13){
            #if defined(FLYERLY)
                imgname = @"icon_flyerly_biz"; // flyerly biz icon
            #else
                imgname = @"icon_flyerly"; // flyerly icon
            #endif
        }
        
    } else {
        if (indexPath.row == 3)imgname = @"fb_Like";
        if (indexPath.row == 4)imgname = @"twt_follow";
        if (indexPath.row == 5)imgname = @"signin";
        if (indexPath.row == 6)imgname = @"tnc";
        if (indexPath.row == 7)imgname = @"privacy";
        if (indexPath.row == 8)imgname = @"howto";// How To
        
        // only for Partner Apps
        if (indexPath.row == 9){
            // Create Labels for text
            cell.description = [[UILabel alloc]initWithFrame:CGRectMake(5, 17, 250, 21)];
            [cell.description setBackgroundColor:[UIColor clearColor]];
            [cell.description setTextColor:[UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0]];
            [cell.description setFont:[UIFont fontWithName:@"AvenirNext-Bold" size:16]];
            [cell.description setTextAlignment:NSTextAlignmentLeft];
            [cell.contentView addSubview:cell.description];
            [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settingsrow"]]];
        }
        if (indexPath.row == 10)imgname = @"icon_untech";//untech
        if (indexPath.row == 11)imgname = @"icon_eyespot";//eyespot
        if (indexPath.row == 12){
            #if defined(FLYERLY)
                imgname = @"icon_flyerly_biz"; // flyerly biz icon
            #else
                imgname = @"icon_flyerly"; // flyerly icon
            #endif
        }
    }
    
    // Set cell Values
    [cell setCellObjects:title leftimage:imgname];
    return cell;
}

/*
 * Here we Open InAppPurchase Panel
 */
-(void)openPanel {
    if ([FlyerlySingleton connected]) {
        if( IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ){
            inappviewcontroller = [[InAppViewController alloc] initWithNibName:@"InAppViewController" bundle:nil];
        }else {
            inappviewcontroller = [[InAppViewController alloc] initWithNibName:@"InAppViewController-iPhone4" bundle:nil];
        }
        [self presentViewController:inappviewcontroller animated:YES completion:nil];
        
        [inappviewcontroller requestProduct];
        inappviewcontroller.buttondelegate = self;
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You're not connected to the internet. Please connect and retry." message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
}


/*
 * HERE WE ENABLE AND DISABLE SAVING PICTURE IN GALLERY
 */
- (void)changeSwitch:(id)sender{
    
    if([sender isOn]){
        
        // Execute any code when the switch is ON
        [[NSUserDefaults standardUserDefaults]  setObject:@"enabled" forKey:@"saveToCameraRollSetting"];
        
    } else{
        
        // Execute any code when the switch is OFF
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"saveToCameraRollSetting"];
        
    }
    
}


- (void)flyerlypublic:(id)sender{
    
    if([sender isOn]){
        [[NSUserDefaults standardUserDefaults]  setObject:@"Public" forKey:@"FlyerlyPublic"];
        
    } else{
        
        [[NSUserDefaults standardUserDefaults]  setObject:@"Private" forKey:@"FlyerlyPublic"];
    }
    
}

- (void)tableView:(UITableView *)tView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    //Opening InApp Panel when click on Premium Features row
    if (indexPath.row == 0){
        [self openPanel];
    }
    
    // Checking if the user is valid
    if ( [self isLogin]) {
        if(indexPath.row == 3) {
            accountUpdater = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
            [self.navigationController pushViewController:accountUpdater animated:YES];
        
        }
        else if(indexPath.row == 4){
            [ self likeFacebook ];
        
        }
        else if(indexPath.row == 5){
            [self likeTwitter];
            
        }
        else if(indexPath.row == 6){
            
            warningAlert = [[UIAlertView  alloc]initWithTitle:@"Are you sure?" message:@"" delegate:self cancelButtonTitle:@"Sign out" otherButtonTitles:@"Cancel",nil];
            [warningAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
        }
        else if (indexPath.row == 7){
            //terms of service
            termOfServiceView = [[TermsOfServiceViewController alloc]initWithNibName:@"TermsOfServiceViewController" bundle:nil];
            [self.navigationController pushViewController:termOfServiceView animated:YES];
            
        }
        else if (indexPath.row == 8){
            //privicy policy
            privicyPolicyView = [[PrivicyPolicyViewController alloc]initWithNibName:@"PrivicyPolicyViewController" bundle:nil];
            [self.navigationController pushViewController:privicyPolicyView animated:YES];
            
        }
        else if (indexPath.row == 9){
            [self openIntroScreen];
            
        }
        else if (indexPath.row == 11){
            [self openITunes:@"untech-reconnect-with-life/id934720123?mt=8"]; //Untech
        }
        else if (indexPath.row == 12){
           [self openITunes:@"eyespot/id611525338?mt=8"]; //eyeSPOT
        }
        else if (indexPath.row == 13){
            
            #if defined(FLYERLY)
                [self openITunes:@"socialflyr-free/id344139192?mt=8"]; //Flyerly Biz
            #else
                [self openITunes:@"socialflyr-free/flyerly-add-creativity-to/id344130515?mt=8"]; //Flyerly
            #endif
        }
        else if(indexPath.row == 14){//clear purchasis
            _persistence = [[RMStoreKeychainPersistence alloc] init];
            [RMStore defaultStore].transactionPersistor = _persistence;
            
            //Uncomment this line if you want to remove transactions from the phone.
            [_persistence removeTransactions];
            
        }

        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
        
    } else { // Otherwise the user is anonymous
        if(indexPath.row == 3) {
            [ self likeFacebook ];
            
        }else if(indexPath.row == 4){
            [self likeTwitter];
            
        }else if(indexPath.row == 5){
            
            signInController = [[SigninController alloc]initWithNibName:@"SigninController" bundle:nil];
            
            FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
            signInController.launchController = appDelegate.lauchController;
            
            // Keep a reference to navigation controller as we are going to pop this view controller mid way
            UINavigationController* navigationController = self.navigationController;
            
            signInController.signInCompletion = ^void(void) {
                
                // Pop out sign in controller as user has successfully signed in
                [navigationController popViewControllerAnimated:NO];
                
                // Since we popped settings controller out of stack we need to puch a new one.
                // This should be done in a better way e.g., reloadData instead of popping it out and pushing a new one
                MainSettingViewController *mainsettingviewcontroller = [[MainSettingViewController alloc]initWithNibName:@"MainSettingViewController" bundle:nil] ;
                [navigationController pushViewController:mainsettingviewcontroller animated:YES];
                UserPurchases *userPurchases_ = [UserPurchases getInstance];
                [userPurchases_ setUserPurcahsesFromParse];
            };
            
            // Pop out settings controller
            [navigationController popViewControllerAnimated:NO];
            
            // Push sign in controller on the stack
            [navigationController pushViewController:signInController animated:YES];
            
        }else if (indexPath.row == 6){
            //terms of service
            termOfServiceView = [[TermsOfServiceViewController alloc]initWithNibName:@"TermsOfServiceViewController" bundle:nil];
            [self.navigationController pushViewController:termOfServiceView animated:YES];
            
        } else if (indexPath.row == 7){
            //privicy policy
            privicyPolicyView = [[PrivicyPolicyViewController alloc]initWithNibName:@"PrivicyPolicyViewController" bundle:nil];
            [self.navigationController pushViewController:privicyPolicyView animated:YES];
        } else if (indexPath.row == 8){
            [self openIntroScreen];
            
        } else if (indexPath.row == 10){
            [self openITunes:@"untech-reconnect-with-life/id934720123?mt=8"]; //Untech
        } else if (indexPath.row == 11){
            [self openITunes:@"eyespot/id611525338?mt=8"]; //eyeSPOT
        } else if (indexPath.row == 12){
            #if defined(FLYERLY)
                [self openITunes:@"socialflyr-free/id344139192?mt=8"]; //Flyerly Biz
            #else
                [self openITunes:@"socialflyr-free/flyerly-add-creativity-to/id344130515?mt=8"]; //Flyerly
            #endif
        }
    }
}

/*
 * Opens Intro screens
 * @params:
 *      void
 * @return:
 *      void
 */
-(void)openIntroScreen {
    
    IntroScreenViewController *introScreenViewController = [[IntroScreenViewController alloc] initWithNibName:@"IntroScreenViewController" bundle:nil];
    [introScreenViewController setModalPresentationStyle:UIModalPresentationFullScreen];
    introScreenViewController.buttonDelegate = self;
    
    [self presentViewController:introScreenViewController animated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
}

/*
 * This method opens iTune
 * @params:
 *      appID: NSString
 * @return:
 *      void
 */
-(void) openITunes : (NSString *) appID{
    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/app/%@",appID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
	if(alertView == warningAlert && buttonIndex == 0) {
        [MainSettingViewController signOut];
        LaunchController *actaController = nil;
        
        actaController = [[LaunchController alloc] initWithNibName:@"LaunchController" bundle:nil];
        
        [self.navigationController pushViewController:actaController animated:YES];
    }
    
}


+ (void)signOut{

    //REMOVE KEYS
    [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"User"];
    [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"InAppPurchases"];
    
    [[NSUserDefaults standardUserDefaults]setValue: nil forKey:@"InAppPurchases"];
    
    // Log out from parse.
    [PFUser logOut];
}


- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}


-(IBAction)rateApp:(id)sender{
    
    #if defined(FLYERLY)
        [self openITunes:@"socialflyr-free/flyerly-add-creativity-to/id344130515?mt=8"]; //Flyerly
    #else
        [self openITunes:@"socialflyr-free/id344139192?mt=8"]; //Flyerly Biz
    #endif
    
}

-(void)showAlert:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(IBAction)gotwitter:(id)sender{
    
    globle.inputValue = @"twitter";
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        [self showAlert:@"No internet available,please connect to the internet first" message:@""];
    } else {
        NSLog(@"There IS internet connection");
        
        /*if ([txtfield.text isEqualToString:@""]) {
            [self showAlert:@"Please Enter Comments" message:@""];
        }else{*/
            
            // Current Item For Sharing
        NSString *str;
        
        #if defined(FLYERLY)
            str = @"@flyerlyapp";
        #else
            str = @"@flyerlybiz";
        #endif
        SHKItem *item = [SHKItem text:str];
        
            //Calling ShareKit for Sharing
            iosSharer = [[ SHKSharer alloc] init];
            iosSharer = [SHKTwitter shareItem:item];
            iosSharer.shareDelegate = self;
        //}
    }
    
    /*InputViewController  *inputcontroller = [[InputViewController alloc]initWithNibName:@"InputViewController" bundle:nil];
    [self.navigationController presentViewController:inputcontroller animated:YES completion:nil];*/
    
}



-(IBAction)goemail:(id)sender{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    if([MFMailComposeViewController canSendMail]){
        
        picker.mailComposeDelegate = self;
        [picker setSubject: [NSString stringWithFormat:@"%@ Email Feedback...", APP_NAME]];
        
        // Set up recipients
        NSMutableArray *toRecipients = [[NSMutableArray alloc]init];
        [toRecipients addObject:@"support@greenmtnlabs.com"];
        [picker setToRecipients:toRecipients];

        [self presentViewController:picker animated:YES completion:nil];
    }

}

- (IBAction)onClickBtnDismissBannerAds:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissBannerAds:YES];
    });
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	switch (result) {
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
			break;
	}
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)goBack{
   [self.navigationController popViewControllerAnimated:YES];
}


-(void)gohelp{
    
    [UserVoice presentUserVoiceInterfaceForParentViewController:self];
}

#pragma mark  LIKE

/*
 * Here we Like Our App
 */
-(void)likeFacebook {
    
    if ([FlyerlySingleton connected]) {
        NSURL *url = [NSURL URLWithString:@"fb://profile/500819963306066"];
        
        if ([[UIApplication sharedApplication] canOpenURL:url]){
            [[UIApplication sharedApplication] openURL:url];
        }
        else {
            NSString *url_str;
            
            #if defined(FLYERLY)
                url_str = @"https://www.facebook.com/flyerlyapp";
            #else
                url_str = @"https://www.facebook.com/flyerlybiz";
            #endif
            
            //Open the url as usual
            url = [NSURL URLWithString:url_str];
            [[UIApplication sharedApplication] openURL:url];
        }
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You're not connected to the internet. Please connect and retry." message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
}

/*
 * Here we Follow Our App
 */
-(void)likeTwitter {
    
    if ([FlyerlySingleton connected]) {
        // Current Item For Sharing
        SHKItem *item = [[SHKItem alloc] init];
    
        iosSharer = [[ SHKSharer alloc] init];
        //iosSharer = [FlyerlyTwitterLike shareItem:item];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You're not connected to the internet. Please connect and retry." message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    
    }
}

- ( void )productSuccesfullyPurchased: (NSString *)productId {
    
    UserPurchases *userPurchases_ = [UserPurchases getInstance];
    canShowAd = [userPurchases_ canShowAd];
    
    if ( [userPurchases_ checkKeyExistsInPurchases: IN_APP_ID_SAVED_FLYERS] ) {
        
        [inappviewcontroller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    //when purchased bundle is of ad removal or check can we remove banner add
    if ( [productId isEqualToString: BUNDLE_IDENTIFIER_AD_REMOVAL] || canShowAd == NO) {
        [self removeBAnnerAdd:YES];
    }
}

- (void)inAppPurchasePanelButtonTappedWasPressed:(NSString *)inAppPurchasePanelButtonCurrentTitle {
    
    __weak InAppViewController *inappviewcontroller_ = inappviewcontroller;
    if ([inAppPurchasePanelButtonCurrentTitle isEqualToString:(@"Sign In")]) {
        
        signInController = [[SigninController alloc]initWithNibName:@"SigninController" bundle:nil];
        
        FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
        signInController.launchController = appDelegate.lauchController;
        
        __weak MainSettingViewController *mainSettingViewController = self;
        
        UserPurchases *userPurchases_ = [UserPurchases getInstance];
        userPurchases_.delegate = self;
        
        [inappviewcontroller_.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        
        signInController.signInCompletion = ^void(void) {
            
            UINavigationController* navigationController = mainSettingViewController.navigationController;
            [navigationController popViewControllerAnimated:NO];
            [userPurchases_ setUserPurcahsesFromParse];
        };
        
        [self.navigationController pushViewController:signInController animated:YES];
        
    }else if ([inAppPurchasePanelButtonCurrentTitle isEqualToString:(@"Restore Purchases")]){
        
        
        [inappviewcontroller_ restorePurchase];
    }
}

- (void)inAppPanelDismissed {

}

- ( void )inAppPurchasePanelContent {
    [inappviewcontroller inAppDataLoaded];
}

- (void) userPurchasesLoaded {
    
    UserPurchases *userPurchases_ = [UserPurchases getInstance];
    
    if ( [userPurchases_ checkKeyExistsInPurchases: IN_APP_ID_SAVED_FLYERS] ) {
        
        [inappviewcontroller.paidFeaturesTview reloadData];
    }else {
        
        if([productIdentifier length] == 0 && inappviewcontroller != nil){
            [self presentViewController:inappviewcontroller animated:YES completion:nil];
        }
    }
    
}


// These are used if you do not provide your own custom UI and delegate
- (void)sharerStartedSending:(SHKSharer *)sharer
{
    
	if (!sharer.quiet)
		[[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Saving to %@", [[sharer class] sharerTitle]) forSharer:sharer];
}

- (void)sharerFinishedSending:(SHKSharer *)sharer
{
    NSString *strAlert;
    
    #if defined(FLYERLY)
        strAlert =@"Thank you. Your feedback has been sent to @flyerlyapp on Twitter.";
    #else
        strAlert = @"Thank you. Your feedback has been sent to @flyerlybiz on Twitter.";
    #endif
    // Here we show Messege after Sending
    [self showAlert:strAlert message:@""];
    
    if (!sharer.quiet)
		[[SHKActivityIndicator currentIndicator] displayCompleted:SHKLocalizedString(@"Saved!") forSharer:sharer];
}

- (void)sharer:(SHKSharer *)sharer failedWithError:(NSError *)error shouldRelogin:(BOOL)shouldRelogin
{
    
    [[SHKActivityIndicator currentIndicator] hideForSharer:sharer];
	NSLog(@"Sharing Error");
}

- (void)sharerCancelledSending:(SHKSharer *)sharer
{
    NSLog(@"Sending cancelled.");
}

- (void)sharerShowBadCredentialsAlert:(SHKSharer *)sharer
{
    NSString *errorMessage = SHKLocalizedString(@"Sorry, %@ did not accept your credentials. Please try again.", [[sharer class] sharerTitle]);
    
    [[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Login Error")
                                message:errorMessage
                               delegate:nil
                      cancelButtonTitle:SHKLocalizedString(@"Close")
                      otherButtonTitles:nil] show];
}

- (void)sharerShowOtherAuthorizationErrorAlert:(SHKSharer *)sharer
{
    NSString *errorMessage = SHKLocalizedString(@"Sorry, %@ encountered an error. Please try again.", [[sharer class] sharerTitle]);
    
    [[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Login Error")
                                message:errorMessage
                               delegate:nil
                      cancelButtonTitle:SHKLocalizedString(@"Close")
                      otherButtonTitles:nil] show];
}

- (void)hideActivityIndicatorForSharer:(SHKSharer *)sharer {
    
    [[SHKActivityIndicator currentIndicator]  hideForSharer:sharer];
}

- (void)displayActivity:(NSString *)activityDescription forSharer:(SHKSharer *)sharer {
    
    if (sharer.quiet) return;
    
    [[SHKActivityIndicator currentIndicator]  displayActivity:activityDescription forSharer:sharer];
}

- (void)displayCompleted:(NSString *)completionText forSharer:(SHKSharer *)sharer {
    
    if (sharer.quiet) return;
    [[SHKActivityIndicator currentIndicator]  displayCompleted:completionText forSharer:sharer];
}

- (void)showProgress:(CGFloat)progress forSharer:(SHKSharer *)sharer {
    
    if (sharer.quiet) return;
    [[SHKActivityIndicator currentIndicator]  showProgress:progress forSharer:sharer];
}

#pragma Ads
-(void) loadInterstitialAdd{
    self.interstitialAds.delegate = nil;
    
    // Create a new GADInterstitial each time. A GADInterstitial will only show one request in its
    // lifetime. The property will release the old one and set the new one.
    self.interstitialAds = [[GADInterstitial alloc] init];
    self.interstitialAds.delegate = self;
    
    // Note: Edit SampleConstants.h to update kSampleAdUnitId with your interstitial ad unit id.
    self.interstitialAds.adUnitID = [flyerConfigurator interstitialAdID];
    
    [self.interstitialAds loadRequest:[self request]];
    
}
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    
    [self loadInterstitialAdd];
    
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

// We've received a Banner ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    if ( bannerAdClosed == NO && bannerShowed == NO ) {
        bannerShowed = YES;//keep bolean we have rendered banner or not ?
        bannerAdsView.alpha = 1.0;
        btnBannerAdsDismiss.alpha = 1.0;
        [self.bannerAdsView addSubview:btnBannerAdsDismiss];
    }
}



// Dismiss action for banner ad
-(void)dismissBannerAds:(BOOL)valForBannerClose{
    
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
    //[bannerAdDismissBtn removeFromSuperview];
    [self.bannerAdsView removeFromSuperview];
    btnBannerAdsDismiss = nil;
    self.bannerAdsView = nil;
    
    bannerAdClosed = valForBannerClose;
}

@end
