//
//  MainSettingViewController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd on 07/08/2013.
//
//

#import "MainSettingViewController.h"

@interface MainSettingViewController ()


@end

@implementation MainSettingViewController
@synthesize tableView;


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
    [helpButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [helpButton setBackgroundImage:[UIImage imageNamed:@"help_icon"] forState:UIControlStateNormal];
    [helpButton addTarget:self action:@selector(gohelp) forControlEvents:UIControlEventTouchUpInside];
    helpButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *helpBarButton = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [backButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"home_button"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:backBarButton,helpBarButton,nil ]];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-35, -6, 50, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];
    label.text = @"SETTINGS";
    
    self.navigationItem.titleView = label;
    
    category = [[NSMutableArray alloc] init];
    [category addObject:@"Premium Features"];
    [category addObject:@"Autosave to Gallery"];
    [category addObject:@"Flyers are public"];
    
    //Checking if the user is valid or anonymous
    if ([[PFUser currentUser] sessionToken].length != 0) {
        //GET UPDATED USER PUCHASES INFO
        [category addObject:@"Account Setting"];
    }
    
    [category addObject:@"Like us on Facebook"];
    [category addObject:@"Follow us on Twitter"];
    
    //Checking if the user is valid or anonymus
    if ([[PFUser currentUser] sessionToken].length != 0) {
        [category addObject:@"Sign Out"];
    } else {
        [category addObject:@"Sign In"];
    }
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
        cell = [[MainSettingCell alloc] initWithFrame:CGRectZero] ;
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
                 mSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(263, 4, 0, 0)] ;
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
    
    if (indexPath.row == 2){
        UISwitch *mSwitch;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            mSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(263, 4, 0, 0)] ;
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
    
    if (indexPath.row == 3){
        //Checking if the user is valid or anonymus
        if ([[PFUser currentUser] sessionToken].length != 0) {
            //account setting row clicked
            imgname = @"account_settings";
            [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SettingcellBack"]]];
        }
        
    }
    
    if ([[PFUser currentUser] sessionToken].length != 0) {
        if (indexPath.row == 4)imgname = @"fb_Like";
        if (indexPath.row == 5)imgname = @"twt_follow";
        if (indexPath.row == 6)imgname = @"signout";
    } else {
        if (indexPath.row == 3)imgname = @"fb_Like";
        if (indexPath.row == 4)imgname = @"twt_follow";
        if (indexPath.row == 5)imgname = @"signin";
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
        if(IS_IPHONE_5){
            inappviewcontroller = [[InAppViewController alloc] initWithNibName:@"InAppViewController" bundle:nil];
        }else {
            inappviewcontroller = [[InAppViewController alloc] initWithNibName:@"InAppViewController-iPhone4" bundle:nil];
        }
        [self presentModalViewController:inappviewcontroller animated:YES];
        
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
    if ([[PFUser currentUser] sessionToken].length != 0) {
        if(indexPath.row == 3) {
            
            accountUpdater = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
            [self.navigationController pushViewController:accountUpdater animated:YES];
            
        }else if(indexPath.row == 4){
            
            [ self likeFacebook ];
            
        }else if(indexPath.row == 5){
            
            [self likeTwitter];
            
        }else if(indexPath.row == 6){
            
            warningAlert = [[UIAlertView  alloc]initWithTitle:@"Are you sure?" message:@"" delegate:self cancelButtonTitle:@"Sign out" otherButtonTitles:@"Cancel",nil];
            [warningAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
            
        }
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
        // Otherwise the user is anonymous
    } else {
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
            
        }
    }
    
    
    
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
     NSString *url = @"itms-apps://itunes.apple.com/app/id344130515";
    //url = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", @"344130515"];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
    
}


-(IBAction)gotwitter:(id)sender{
    
    globle.inputValue = @"twitter";
    InputViewController  *inputcontroller = [[InputViewController alloc]initWithNibName:@"InputViewController" bundle:nil];
    [self.navigationController presentModalViewController:inputcontroller animated:YES];
    
}



-(IBAction)goemail:(id)sender{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    if([MFMailComposeViewController canSendMail]){
        
        picker.mailComposeDelegate = self;
        [picker setSubject:@"Flyerly Email Feedback..."];
        
        // Set up recipients
        NSMutableArray *toRecipients = [[NSMutableArray alloc]init];
        [toRecipients addObject:@"support@greenmtnlabs.com"];
        [picker setToRecipients:toRecipients];

        [self presentModalViewController:picker animated:YES];
    }

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
    
    [controller dismissModalViewControllerAnimated:YES];
}

-(void)goBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)gohelp{
    
    HelpController *helpController = [[HelpController alloc]initWithNibName:@"HelpController" bundle:nil];
    [self.navigationController pushViewController:helpController animated:NO];

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
            //Open the url as usual
            url = [NSURL URLWithString:@"https://www.facebook.com/flyerlyapp"];
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
    
        SHKSharer  *iosSharer = [[ SHKSharer alloc] init];
        iosSharer = [FlyerlyTwitterLike shareItem:item];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You're not connected to the internet. Please connect and retry." message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    
    }
}

- ( void )productSuccesfullyPurchased: (NSString *)productId {
    
    UserPurchases *userPurchases_ = [UserPurchases getInstance];
    
    if ( [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyAllDesignBundle"] ||
        [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyUnlockSavedFlyers"] ) {
        
        [inappviewcontroller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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

- ( void )inAppPurchasePanelContent {
    [inappviewcontroller inAppDataLoaded];
}

- (void) userPurchasesLoaded {
    
    UserPurchases *userPurchases_ = [UserPurchases getInstance];
    
    if ( [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyAllDesignBundle"]  ||
         [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyUnlockSavedFlyers"] ) {
        
        [inappviewcontroller.paidFeaturesTview reloadData];
    }else {
        
        [self presentModalViewController:inappviewcontroller animated:YES];
    }
    
}


@end
