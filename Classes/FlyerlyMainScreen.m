

//
//  Created by Riksof Pvt. Ltd. on 22/Jan/2014.
//

#import "FlyerlyMainScreen.h"
#import "CreateFlyerController.h"
#import "FlyrViewController.h"
#import "InviteFriendsController.h"
#import "FlyrAppDelegate.h"
#import "ShareViewController.h"
#import "Common.h"
#import "UserPurchases.h"
#import "HelpController.h"
#import "Flurry.h"
#import "SHKConfiguration.h"
#import "FlyerlyConfigurator.h"
#import "FlyerUser.h"
#import "UVConfig.h"
#import "UserVoice.h"
#import "Common.h"
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"

@interface FlyerlyMainScreen ()  {
    
    FlyerlyConfigurator *flyerConfigurator;
}

@end

@implementation FlyerlyMainScreen

@synthesize tpController;
@synthesize createFlyrLabel;
@synthesize savedFlyrLabel;
@synthesize inviteFriendLabel;
@synthesize addFriendsController;
@synthesize createFlyrButton;
@synthesize savedFlyrButton;
@synthesize recentFlyers;
@synthesize inviteFriendButton;
@synthesize introScreenViewController;

BOOL adLoaded = false;


//When user tap on create new flyer(from main screen)
-(IBAction)doNew:(id)sender{
    
    [Flurry logEvent:@"Create Flyer"];

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
    
    [createFlyer setOnFlyerBack:^(NSString *flyPath) {
        //Here we setCurrent Flyer is Most Recent Flyer
        [weakCreate.flyer setRecentFlyer];

        [weakCreate.flyer saveAfterCheck];
        
        //Getting Recent Flyers
        weakSelf.recentFlyers = [Flyer recentFlyerPreview:4];
        
        //Set Recent Flyers
        [weakSelf updateRecentFlyer:weakSelf.recentFlyers];
        
        // Stop Animations ane enable buttons
        for ( int i = 0; i < weakSelf.activityIndicators.count; i++ ) {
            UIActivityIndicatorView *indicator = [weakSelf.activityIndicators objectAtIndex:i];
            [indicator stopAnimating];
            
            UIButton *button = [weakSelf.flyerButtons objectAtIndex:i];
            [button setUserInteractionEnabled:YES];
        }
    }];
    
    [createFlyer setShouldShowAdd:^(NSString *flyPath,BOOL haveValidSubscription) {
        dispatch_async( dispatch_get_main_queue(), ^{
                if (haveValidSubscription == NO && ([weakSelf.addInterstialFms isReady] && ![weakSelf.addInterstialFms hasBeenUsed]) ){
                    [weakSelf.addInterstialFms presentFromRootViewController:weakSelf];
                } else{
                    [weakCreate.flyer saveAfterCheck];
                }
        });
    }];
    
    
    
	[self.navigationController pushViewController:createFlyer animated:YES];
    
    // Start animations and disable buttons
    for ( int i = 0; i < _activityIndicators.count; i++ ) {
        UIActivityIndicatorView *indicator = [_activityIndicators objectAtIndex:i];
        [indicator startAnimating];
        
        UIButton *button = [_flyerButtons objectAtIndex:i];
        [button setUserInteractionEnabled:NO];
    }
}


-(IBAction)doOpen:(id)sender{
    tpController = [[FlyrViewController alloc]initWithNibName:@"FlyrViewController" bundle:nil];
	[self.navigationController pushViewController:tpController animated:YES];
}
//End


// Load Preferences Method 
-(IBAction)doAbout:(id)sender{
    MainSettingViewController *mainsettingviewcontroller = [[MainSettingViewController alloc]initWithNibName:@"MainSettingViewController" bundle:nil] ;
    [self.navigationController pushViewController:mainsettingviewcontroller animated:YES];
}
//End

// Load invite friends
-(IBAction)doInvite:(id)sender{
    
    //Checking if the user is valid or anonymous
    if ([[PFUser currentUser] sessionToken]) {
       
        addFriendsController = [[InviteFriendsController alloc]initWithNibName:@"InviteFriendsController" bundle:nil];
        
        [self.navigationController pushViewController:addFriendsController animated:YES];
        
    } else {
         // Alert when user logged in as anonymous
        UIAlertView *signInAlert = [[UIAlertView alloc] initWithTitle:@"Sign In" message:@"The selected feature requires that you sign in. Would you like to register or sign in now?" delegate:self cancelButtonTitle:@"Later" otherButtonTitles:@"Sign In",nil];
        [signInAlert show];
      
    }
	
}
//End

// Buttons event handler,when user click on invite button in anonymous mood
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   //when click on sign in button in alert view
    if(buttonIndex == 1)
    {

        signInController = [[SigninController alloc]initWithNibName:@"SigninController" bundle:nil];
        
        signInController.launchController = self;
        
        __weak FlyerlyMainScreen *weakMainFlyerScreen = self;
                        
        signInController.signInCompletion = ^void(void) {
            
            UINavigationController* navigationController = weakMainFlyerScreen.navigationController;
            [navigationController popViewControllerAnimated:NO];
            
            // Push Invite friends screen on navigation stack
            weakMainFlyerScreen.addFriendsController = [[InviteFriendsController alloc]initWithNibName:@"InviteFriendsController" bundle:nil];            
            [weakMainFlyerScreen.navigationController pushViewController:weakMainFlyerScreen.addFriendsController animated:YES];
            
        };
        
        [self.navigationController pushViewController:signInController animated:YES];
    }
   
    
}

/*
 * here we Resize Image by providing image & Size as param
 */
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/*
 * Here we Set recent Flyer
 */
- (void)updateRecentFlyer:(NSMutableArray *)recFlyers{

    for ( int i = 0; i < _flyerPreviews.count; i++ ) {
        UIImageView *preview = [_flyerPreviews objectAtIndex:i];
        
        
        // Get the size.
        CGSize size = CGSizeMake( preview.frame.size.width, preview.frame.size.height );
        
        // Do we have a flyer at this index?
        if ( recFlyers.count > i ) {
            // Get the recent image
            UIImage *recentImage =  [UIImage imageWithContentsOfFile:[recFlyers objectAtIndex:i]];
            
            // Resize it
            UIImage *resizeImage = [self imageWithImage:recentImage scaledToSize:size];
            
            // Set this image for preview
            preview.image = resizeImage;
        } else {
            // Use default image.
            preview.image = [UIImage imageNamed:@"pinned_flyer2.png"];
        }
        
    }
}


#pragma mark View Appear 

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:YES];
    
    globle.NBUimage = nil;

    //Getting Recent Flyers
    recentFlyers = [Flyer recentFlyerPreview:4];

    //Set Recent Flyers
    [self updateRecentFlyer:recentFlyers];
    
    self.navigationController.navigationBarHidden = NO;
    
    // Execute the rest of the stuff, a little delayed to speed up loading.
    dispatch_async( dispatch_get_main_queue(), ^{
        
        //Checking if the user is valid or anonymus
        if ([[PFUser currentUser] sessionToken].length != 0) {
        
        NSString *username = [[PFUser currentUser] objectForKey:@"username"];
        //Save congratulation message a/c to username
        NSString *congratulatedVal  =   [NSString stringWithFormat:@"%@-%@",username, @"congratulated"];
        // Determin if the user has been congratulated?
        NSString *congratulated = [[NSUserDefaults standardUserDefaults] stringForKey:@"congratulated"];

        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:username];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                if (objects.count) {
                    for (PFObject *object in objects){
                        NSLog(@"ParseUser unique object ID: %@", object.objectId);
                        
                        PFQuery *query = [PFUser  query];
                        [query whereKey:@"objectId" equalTo:object.objectId];
                        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
                            
                            if (!error) {
                                NSMutableDictionary *counterDictionary = [object valueForKey:@"estimatedData"];
                                int refrelCounter = [[counterDictionary objectForKey:@"inviteCounter"] intValue];

                                //When user invited more then 20 peoples
                                if ( refrelCounter >= 20 && ![congratulated isEqualToString:congratulatedVal] ) {
                                    //bundel changed on preston request, see git issue #417
                                    NSString *pid  = @"com.flyerly.AllDesignBundle";//@"com.flyerly.UnlockSavedFlyers";
                                    
                                    NSString *strWithOutDot = [pid stringByReplacingOccurrencesOfString:@"." withString:@""];
                                    
                                    if(![[NSUserDefaults standardUserDefaults] stringForKey:@"InAppPurchases"]){
                                        
                                        NSMutableDictionary *userPurchase =[[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults]valueForKey:@"InAppPurchases"]];
                                        
                                        [userPurchase setValue:@"1" forKey:strWithOutDot];
                                        [[NSUserDefaults standardUserDefaults]setValue:userPurchase forKey:@"InAppPurchases"];
                                        
                                    }else {
                                        NSMutableDictionary *userPurchase =[[NSMutableDictionary alloc] init];
                                        [userPurchase setValue:@"1" forKey:strWithOutDot];
                                        [[NSUserDefaults standardUserDefaults]setValue:userPurchase forKey:@"InAppPurchases"];
                                        
                                    }
                                    
                                    InAppViewController *purchseController = [[InAppViewController alloc] init];
                                    
                                    //Saved in Parse Account
                                    [purchseController updateParse];
                                    // Showing action sheet after succesfull sign in
                                    [userPurchases setUserPurcahsesFromParse];
                                    [purchseController.buttondelegate productSuccesfullyPurchased:pid];
                                    
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Design Bundle Unlocked!" message:@"Thank you for helping us grow!  You just earned the Design Bundle for inviting others to join Flyerly." delegate:self cancelButtonTitle:@"Awesome!" otherButtonTitles:nil, nil];
                                    
                                    [alert show];
                                    
                                    // Show the greeting before going to the main app.
                                    [[NSUserDefaults standardUserDefaults] setObject:congratulatedVal forKey:@"congratulated"];
                                    
                                }
                            }
                        }];
                    }
                }
            }
        }];
        

        
    }
    });
    
    // for Navigation Bar logo
    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 102, 38)];
    [logo setImage:[UIImage imageNamed:@"flyerlylogo"]];
    self.navigationItem.titleView = logo;
    
    [self.navigationItem setHidesBackButton:YES];
    
    
    //Checking if the user is valid or anonymus
    if ([[PFUser currentUser] sessionToken]) {
        
        UserPurchases *userPurchases_ = [UserPurchases getInstance];
        
        //GET UPDATED USER PUCHASES INFO
        [userPurchases_ setUserPurcahsesFromParse];
        
    } else {
        NSLog(@"Anonymous, User is NOT authenticated.");
    }
}

/*
 * Returns the left items on navigation bar
 * Add space item with help icon
 */
-(NSArray *)leftBarItems{
    // Space item
    UIBarButtonItem *spaceBarButton = [[UIBarButtonItem alloc] initWithCustomView:[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)]];
    
    // Create left bar help button
    UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [helpButton addTarget:self action:@selector(loadHelpController) forControlEvents:UIControlEventTouchUpInside];
    [helpButton setBackgroundImage:[UIImage imageNamed:@"help_icon"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
    
    NSMutableArray *leftItems = [NSMutableArray arrayWithObjects:spaceBarButton,leftBarButton,nil];
    
    return leftItems;
}

-(void)loadHelpController{
    
    [UserVoice presentUserVoiceInterfaceForParentViewController:self];
}

/*
 * Here we Open InAppPurchase Panel
 */

-(void)openPanel {
    
    introScreenViewController = [[IntroScreenViewController alloc] initWithNibName:@"IntroScreenViewController" bundle:nil];
    [introScreenViewController setModalPresentationStyle:UIModalPresentationFullScreen];
    
    [self presentViewController:introScreenViewController animated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
}


-(void)openPanel1{
    
    if( IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ){
        inappviewcontroller = [[InAppViewController alloc] initWithNibName:@"InAppViewController" bundle:nil];
        [inappviewcontroller setModalPresentationStyle:UIModalPresentationFullScreen];
        
    }else {
        inappviewcontroller = [[InAppViewController alloc] initWithNibName:@"InAppViewController-iPhone4" bundle:nil];
        [inappviewcontroller setModalPresentationStyle:UIModalPresentationFullScreen];
        
    }
    [self presentViewController:inappviewcontroller animated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    [inappviewcontroller requestProduct];
    inappviewcontroller.buttondelegate = self;
}

- ( void )inAppPurchasePanelContent {
    [inappviewcontroller inAppDataLoaded];
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

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    //adLoaded = true;
    //[self.addInterstialFms presentFromRootViewController:self];
}


- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    //on add dismiss && after merging video process, save in gallery
    [createFlyer.flyer saveAfterCheck];
    
    self.addInterstialFms.delegate = nil;
    
    // Prepare next addInterstialFms.
    self.addInterstialFms = [[GADInterstitial alloc] init];
    self.addInterstialFms.adUnitID = [flyerConfigurator interstitialAdID];
    self.addInterstialFms.delegate = self;
    [self.addInterstialFms loadRequest:[self request]];
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UVConfig *config = [UVConfig configWithSite:@"http://flyerly.uservoice.com/"];
    [UserVoice initialize:config];
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    flyerConfigurator = appDelegate.flyerConfigurator;
    
    // Create a new GADInterstitial each time. A GADInterstitial will only show one request in its
    // lifetime. The property will release the old one and set the new one.
    
    dispatch_async( dispatch_get_main_queue(), ^{
        
        self.addInterstialFms = [[GADInterstitial alloc] init];
        self.addInterstialFms.delegate = self;
        
        // Note: Edit SampleConstants.h to update kSampleAdUnitId with your addInterstialFms ad unit id.
        self.addInterstialFms.adUnitID = [flyerConfigurator interstitialAdID];
        [self.addInterstialFms loadRequest:[self request]];
        
    });
 
    
    // Determin if the user has been greeted?
    NSString *greeted = [[NSUserDefaults standardUserDefaults] stringForKey:@"greeted"];
    
    //if( !greeted ) {
        
    if(YES){
        
        
        
        // Determining the previous version of app
        NSString *previuosVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"previousVersion"];
        
        if( ![previuosVersion isEqualToString:[self appVersion]] ||
            previuosVersion == nil ) {
    
            
            [self openPanel];
        }
        
        
        
        // Show the greeting before going to the main app.
        [[NSUserDefaults standardUserDefaults] setObject:@"greeted" forKey:@"greeted"];
    
    }
    
	globle = [FlyerlySingleton RetrieveSingleton];
    createFlyrButton.showsTouchWhenHighlighted = YES;
    savedFlyrButton.showsTouchWhenHighlighted = YES;
    inviteFriendButton.showsTouchWhenHighlighted = YES;

    [createFlyrLabel setText:NSLocalizedString(@"create_flyer", nil)];
    
    [savedFlyrLabel setText:NSLocalizedString(@"saved_flyers", nil)];

    [inviteFriendLabel setText:NSLocalizedString(@"invite_friends", nil)];
    
    //Checking if the user is valid or anonymus
    if ([[PFUser currentUser] sessionToken]) {
        
        UserPurchases *userPurchases_ = [UserPurchases getInstance];
        
        //GET UPDATED USER PUCHASES INFO
        [userPurchases_ setUserPurcahsesFromParse];
        
    } else {
        NSLog(@"Anonymous, User is NOT authenticated.");
    }
    
}

- (void)inAppPanelDismissed {
    
}

- (void)inAppPurchasePanelButtonTappedWasPressed:(NSString *)inAppPurchasePanelButtonCurrentTitle {
    
    __weak InAppViewController *inappviewcontroller_ = inappviewcontroller;
    if ([inAppPurchasePanelButtonCurrentTitle isEqualToString:(@"Sign In")]) {
        
        signInController = [[SigninController alloc]initWithNibName:@"SigninController" bundle:nil];
        
        FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
        signInController.launchController = appDelegate.lauchController;
        
        __weak FlyerlyMainScreen *flyerlyMainScreen = self;
        
        UserPurchases *userPurchases_ = [UserPurchases getInstance];
        userPurchases_.delegate = self;
        
        [inappviewcontroller_.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
        
        signInController.signInCompletion = ^void(void) {
            
            UINavigationController* navigationController = flyerlyMainScreen.navigationController;
            [navigationController popViewControllerAnimated:NO];
            [userPurchases_ setUserPurcahsesFromParse];
        };
        
        [self.navigationController pushViewController:signInController animated:YES];
        
    }else if ([inAppPurchasePanelButtonCurrentTitle isEqualToString:(@"Restore Purchases")]){
        
        
        [inappviewcontroller_ restorePurchase];
    }
}

- (void) userPurchasesLoaded {
    
    UserPurchases *userPurchases_ = [UserPurchases getInstance];
    
    if ( [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyAllDesignBundle"]  ||
         [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyUnlockSavedFlyers"] ) {
        
        //[inappviewcontroller.paidFeaturesTview reloadData];
    }else {
        
        //[self presentModalViewController:inappviewcontroller animated:YES];
    }
    
}

//When user tap on flyer from main screen
-(IBAction)showFlyerDetail:(id)sender {
    
    UIButton *clickButton = sender;
    NSString *flyPath;
    
    BOOL isNewFlyer = NO;
    if (clickButton.tag < [recentFlyers count]) {
        
        NSString *pathWitFileName = [recentFlyers objectAtIndex:clickButton.tag];
        NSString *pathWithoutFileName = [pathWitFileName
                                         stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/flyer.%@",IMAGETYPE] withString:@""];
        flyPath = pathWithoutFileName;
        
    }else {
        
        flyPath = [Flyer newFlyerPath];
        isNewFlyer = YES;
    }
    
    
    flyer = [[Flyer alloc]initWithPath:flyPath setDirectory:YES];
    
    createFlyer = [[CreateFlyerController alloc]initWithNibName:@"CreateFlyerController" bundle:nil];
    
    // Set CreateFlyer Screen
    createFlyer.flyer = flyer;
    
    if( isNewFlyer ){
        //Tasks after create new flyer
        [createFlyer tasksOnCreateNewFlyer];
    }
    

    __weak FlyerlyMainScreen *weakSelf = self;
    __weak CreateFlyerController *weakCreate = createFlyer;
    
    [createFlyer setOnFlyerBack:^(NSString *flyPath) {
        
        //Here we setCurrent Flyer is Most Recent Flyer
        [weakCreate.flyer setRecentFlyer];
        
        [weakCreate.flyer saveAfterCheck];

        //Getting Recent Flyers
        weakSelf.recentFlyers = [Flyer recentFlyerPreview:4];
        
        //Set Recent Flyers
        [weakSelf updateRecentFlyer:weakSelf.recentFlyers];
        
        // Stop Animations and enable buttons
        for ( int i = 0; i < weakSelf.activityIndicators.count; i++ ) {
            UIActivityIndicatorView *indicator = [weakSelf.activityIndicators objectAtIndex:i];
            [indicator stopAnimating];
            
            UIButton *button = [weakSelf.flyerButtons objectAtIndex:i];
            [button setUserInteractionEnabled:YES];
        }
        
        
    }];
    
    [createFlyer setShouldShowAdd:^(NSString *flyPath,BOOL haveValidSubscription) {
        
        dispatch_async( dispatch_get_main_queue(), ^{
                if (haveValidSubscription == NO && ([weakSelf.addInterstialFms isReady] && ![weakSelf.addInterstialFms hasBeenUsed]) ){
                    [weakSelf.addInterstialFms presentFromRootViewController:weakSelf];
                }
                else{
                    [weakCreate.flyer saveAfterCheck];
                }
        });
        
    }];
    
    
    dispatch_async( dispatch_get_main_queue(), ^{
        
        [self.addInterstialFms loadRequest:[self request]];
        
    });

	[self.navigationController pushViewController:createFlyer animated:YES];
    
    // Start Animations and disable buttons
    for ( int i = 0; i < _activityIndicators.count; i++ ) {
        UIActivityIndicatorView *indicator = [_activityIndicators objectAtIndex:i];
        [indicator startAnimating];
        
        UIButton *button = [_flyerButtons objectAtIndex:i];
        [button setUserInteractionEnabled:NO];
    }
}


-(void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (NSString *) appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}

- ( void )productSuccesfullyPurchased: (NSString *)productId {
    
    UserPurchases *userPurchases_ = [UserPurchases getInstance];
    
    if ( [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyAllDesignBundle"] ||
        [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyUnlockSavedFlyers"] ) {
    }
    
}

@end
