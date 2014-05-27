
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

@interface FlyerlyMainScreen () 

@end

@implementation FlyerlyMainScreen

NSMutableArray *productArray;


@synthesize tpController,createFlyrLabel,savedFlyrLabel,inviteFriendLabel,addFriendsController;
@synthesize firstFlyer, secondFlyer, thirdFlyer, fourthFlyer, createFlyrButton, savedFlyrButton;
@synthesize recentFlyers,inviteFriendButton,showIndicators;
@synthesize uiBusy1,uiBusy2,uiBusy3,uiBusy4,firstFlyerButton,secondFlyerButton,thirdFlyerButton,fourthFlyerButton;

-(IBAction)doNew:(id)sender{
    [Flurry logEvent:@"Create Flyer"];

    NSString *flyPath = [Flyer newFlyerPath];

    //Here We set Source for Flyer screen
    flyer = [[Flyer alloc]initWithPath:flyPath];
    showIndicators = YES;
	createFlyer = [[CreateFlyerController alloc]initWithNibName:@"CreateFlyerController" bundle:nil];
    createFlyer.flyerPath = flyPath;
    createFlyer.flyer = flyer;
    
    __weak FlyerlyMainScreen *weakSelf = self;
    __weak CreateFlyerController *weakCreate = createFlyer;
    
    [createFlyer setOnFlyerBack:^(NSString *flyPath) {
        
        //Here we setCurrent Flyer is Most Recent Flyer
        [weakCreate.flyer setRecentFlyer];
        
        //Getting Recent Flyers
        weakSelf.recentFlyers = [Flyer recentFlyerPreview:4];
        
        //Set Recent Flyers
        [weakSelf updateRecentFlyer:weakSelf.recentFlyers];
        
        //For Manage Indicators
        weakSelf.showIndicators = NO;
        
        //Stop Animations
        [weakSelf.uiBusy1 stopAnimating];
        [weakSelf.uiBusy2 stopAnimating];
        [weakSelf.uiBusy3 stopAnimating];
        [weakSelf.uiBusy4 stopAnimating];
        
        //Enable User Interaction of Recent Flyer
        [weakSelf.firstFlyerButton setUserInteractionEnabled:YES];
        [weakSelf.secondFlyerButton setUserInteractionEnabled:YES];
        [weakSelf.thirdFlyerButton setUserInteractionEnabled:YES];
        [weakSelf.fourthFlyerButton setUserInteractionEnabled:YES];
        
    }];

    
	[self.navigationController pushViewController:createFlyer animated:YES];

}
//End



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

    firstFlyer.image = [UIImage imageNamed:@"pinned_flyer2.png"];
    secondFlyer.image = [UIImage imageNamed:@"pinned_flyer2.png"];
    thirdFlyer.image = [UIImage imageNamed:@"pinned_flyer2.png"];
    fourthFlyer.image = [UIImage imageNamed:@"pinned_flyer2.png"];
    
    CGSize size = CGSizeMake(firstFlyer.frame.size.width, firstFlyer.frame.size.height);
    
    for (int i = 0 ; i < recFlyers.count; i++) {
        
         UIImage *recentImage =  [UIImage imageWithContentsOfFile:[recFlyers objectAtIndex:i]];

        UIImage *resizeImage = [self imageWithImage:recentImage scaledToSize:size];
        
        if ( i == 0 ){
            firstFlyer.image = resizeImage;
        }
        
        if ( i == 1 ) {
            secondFlyer.image = resizeImage;
        }
        
        if ( i == 2 ){
            thirdFlyer.image = resizeImage;
        }
        
        if ( i == 3 ) {
            fourthFlyer.image = resizeImage;
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
    
    //Here we Show Progress when return From Create Screen
    if (showIndicators){
        
        uiBusy1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [uiBusy1 setFrame:CGRectMake(58,58, 20, 20)];
        [uiBusy1 setColor:[UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0]];
        uiBusy1.hidesWhenStopped = YES;
        [uiBusy1 startAnimating];
        
        uiBusy2 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [uiBusy2 setFrame:CGRectMake(58,58, 20, 20)];
        [uiBusy2 setColor:[UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0]];
        uiBusy2.hidesWhenStopped = YES;
        [uiBusy2 startAnimating];
        
        uiBusy3 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [uiBusy3 setFrame:CGRectMake(58,58, 20, 20)];
        [uiBusy3 setColor:[UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0]];
        uiBusy3.hidesWhenStopped = YES;
        [uiBusy3 startAnimating];
        
        uiBusy4 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [uiBusy4 setFrame:CGRectMake(58,58, 20, 20)];
        [uiBusy4 setColor:[UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0]];
        uiBusy4.hidesWhenStopped = YES;
        [uiBusy4 startAnimating];

        [self.firstFlyer addSubview:uiBusy1];
        [self.secondFlyer addSubview:uiBusy2];
        [self.thirdFlyer addSubview:uiBusy3];
        [self.fourthFlyer addSubview:uiBusy4];
        
        [firstFlyerButton setUserInteractionEnabled:NO];
        [secondFlyerButton setUserInteractionEnabled:NO];
        [thirdFlyerButton setUserInteractionEnabled:NO];
        [fourthFlyerButton setUserInteractionEnabled:NO];

        showIndicators = NO;
    }
    
    self.navigationController.navigationBarHidden = NO;
    
    // for Navigation Bar logo
    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    [logo setImage:[UIImage imageNamed:@"flyerlylogo"]];
    self.navigationItem.titleView = logo;
    
    [self.navigationItem setHidesBackButton:YES];
    

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
    HelpController *helpController = [[HelpController alloc]initWithNibName:@"HelpController" bundle:nil];
    [self.navigationController pushViewController:helpController animated:NO];
}

/*
 * Here we Open InAppPurchase Panel
 */
-(void)openPanel {
    
    if(IS_IPHONE_5){
        inappviewcontroller = [[InAppViewController alloc] initWithNibName:@"InAppViewController" bundle:nil];
        [inappviewcontroller setModalPresentationStyle:UIModalPresentationFullScreen];
        
    }else {
        inappviewcontroller = [[InAppViewController alloc] initWithNibName:@"InAppViewController-iPhone4" bundle:nil];
        [inappviewcontroller setModalPresentationStyle:UIModalPresentationFullScreen];
        
    }
    [self presentModalViewController:inappviewcontroller animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    if ( productArray.count == 0 ){
        [inappviewcontroller requestProduct];
    }
    if( productArray.count != 0 ) {
        
        //[inappviewcontroller.contentLoaderIndicatorView stopAnimating];
        //inappviewcontroller.contentLoaderIndicatorView.hidden = YES;
    }
    
    inappviewcontroller.buttondelegate = self;
    
}

- ( void )inAppPurchasePanelContent {
    [inappviewcontroller inAppDataLoaded];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Determin if the user has been greeted?
    NSString *greeted = [[NSUserDefaults standardUserDefaults] stringForKey:@"greeted"];
    
    if( !greeted ) {
        
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
        
        FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
        userPurchases = appDelegate.userPurchases;
        
        //GET UPDATED USER PUCHASES INFO
        [userPurchases setUserPurcahsesFromParse];
        
    } else {
        NSLog(@"Anonymous, User is NOT authenticated.");
    }
    
}

- (void)inAppPurchasePanelButtonTappedWasPressed:(NSString *)inAppPurchasePanelButtonCurrentTitle {
    
    __weak InAppViewController *inappviewcontroller_ = inappviewcontroller;
    if ([inAppPurchasePanelButtonCurrentTitle isEqualToString:(@"Sign In")]) {
        
        signInController = [[SigninController alloc]initWithNibName:@"SigninController" bundle:nil];
        
        FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
        signInController.launchController = appDelegate.lauchController;
        
        __weak FlyerlyMainScreen *flyerlyMainScreen = self;
        __weak UserPurchases *userPurchases_ = appDelegate.userPurchases;
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
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    UserPurchases *userPurchases_ = appDelegate.userPurchases;
    
    if ( [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyAllDesignBundle"]  ||
         [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyUnlockSavedFlyers"] ) {
        
        //[inappviewcontroller.paidFeaturesTview reloadData];
    }else {
        
        //[self presentModalViewController:inappviewcontroller animated:YES];
    }
    
}


-(IBAction)showFlyerDetail:(id)sender {
    
    UIButton *clickButton = sender;
    NSString *flyPath;
    
    if (clickButton.tag < [recentFlyers count]) {
        
        NSString *pathWitFileName = [recentFlyers objectAtIndex:clickButton.tag];
        NSString *pathWithoutFileName = [pathWitFileName
                                         stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/flyer.%@",IMAGETYPE] withString:@""];
        flyPath = pathWithoutFileName;
        
    }else {
        
        flyPath = [Flyer newFlyerPath];
        
    }
    
    
    flyer = [[Flyer alloc]initWithPath:flyPath];
    
    
    createFlyer = [[CreateFlyerController alloc]initWithNibName:@"CreateFlyerController" bundle:nil];
    
    // Set CreateFlyer Screen
    createFlyer.flyer = flyer;
    showIndicators = YES;

    __weak FlyerlyMainScreen *weakSelf = self;
    __weak CreateFlyerController *weakCreate = createFlyer;
    
    [createFlyer setOnFlyerBack:^(NSString *flyPath) {

        //Here we setCurrent Flyer is Most Recent Flyer
        [weakCreate.flyer setRecentFlyer];

        //Getting Recent Flyers
        weakSelf.recentFlyers = [Flyer recentFlyerPreview:4];
        
        //Set Recent Flyers
        [weakSelf updateRecentFlyer:weakSelf.recentFlyers];
        
        //For Manage Indicators
        weakSelf.showIndicators = NO;
        
        //Stop Animations
        [weakSelf.uiBusy1 stopAnimating];
        [weakSelf.uiBusy2 stopAnimating];
        [weakSelf.uiBusy3 stopAnimating];
        [weakSelf.uiBusy4 stopAnimating];
        
        //Enable User Interaction of Recent Flyer
        [weakSelf.firstFlyerButton setUserInteractionEnabled:YES];
        [weakSelf.secondFlyerButton setUserInteractionEnabled:YES];
        [weakSelf.thirdFlyerButton setUserInteractionEnabled:YES];
        [weakSelf.fourthFlyerButton setUserInteractionEnabled:YES];

    }];

    
	[self.navigationController pushViewController:createFlyer animated:YES];
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
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    UserPurchases *userPurchases_ = appDelegate.userPurchases;
    if ( [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyAllDesignBundle"] ||
        [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyUnlockSavedFlyers"] ) {
    }
    
}

@end
