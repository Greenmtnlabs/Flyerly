
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
#import "HelpController.h"
#import "Flurry.h"
#import "SHKConfiguration.h"
#import "FlyerlyConfigurator.h"
#import "FlyerUser.h"

@interface FlyerlyMainScreen () 

@end

@implementation FlyerlyMainScreen

@synthesize tpController,createFlyrLabel,savedFlyrLabel,inviteFriendLabel,addFriendsController;
@synthesize firstFlyer, secondFlyer, thirdFlyer, fourthFlyer, createFlyrButton, savedFlyrButton, inviteFriendButton;
@synthesize facebookLikeView;
@synthesize likeButton,followButton,webview,recentFlyers;

-(IBAction)doNew:(id)sender{
    [Flurry logEvent:@"Create Flyer"];

    NSString *flyPath = [Flyer newFlyerPath];

    //Here We set Source for Flyer screen
    flyer = [[Flyer alloc]initWithPath:flyPath];
    
	createFlyer = [[CreateFlyerController alloc]initWithNibName:@"CreateFlyerController" bundle:nil];
    createFlyer.flyerPath = flyPath;
    createFlyer.flyer = flyer;
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
        UIAlertView *signInAlert = [[UIAlertView alloc] initWithTitle:@"Sign In"
                                                              message:@"This feature requires you to sign in first. Do you want to sign in now?"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:nil];
        [signInAlert addButtonWithTitle:@"Sign In"];
        [signInAlert addButtonWithTitle: @"Later"];
        
        [signInAlert show];
     
    }
	
}
//End

// Buttons event handler,when user click on invite button in anonymous mood
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Sign In"])
    {
        
        NSLog(@"Sign In was selected.");
        SigninController *signInController = [[SigninController alloc]initWithNibName:@"SigninController" bundle:nil];
        
        signInController.launchController = self;
        
        __weak FlyerlyMainScreen *weakMainFlyerScreen = self;
                        
        signInController.signInCompletion = ^void(void) {
                NSLog(@"Sign In via Invite");
            
                //dispatch_async(dispatch_get_main_queue(), ^(void) {
                 
                // Push Invite friends screen on navigation stack
                weakMainFlyerScreen.addFriendsController = [[InviteFriendsController alloc]initWithNibName:@"InviteFriendsController" bundle:nil];
            
                [weakMainFlyerScreen.navigationController pushViewController:weakMainFlyerScreen.addFriendsController animated:YES];
            
            //});
            
        };
        
        [self.navigationController pushViewController:signInController animated:NO];
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
    
    self.navigationController.navigationBarHidden = NO;
    
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"FACEBOOK_LIKED"]){
        [likeButton setSelected:YES];
    }
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"TWITTER_FOLLOWING"]){
        [followButton setSelected:YES];
    }
    
    
    // for Navigation Bar logo
    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 87, 38)];
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

- (void)viewDidLoad {
    
    [super viewDidLoad];
        
	globle = [FlyerlySingleton RetrieveSingleton];
    createFlyrButton.showsTouchWhenHighlighted = YES;
    savedFlyrButton.showsTouchWhenHighlighted = YES;
    inviteFriendButton.showsTouchWhenHighlighted = YES;
    likeButton.showsTouchWhenHighlighted = YES;
    followButton.showsTouchWhenHighlighted = YES;

    
    if(IS_IPHONE_5){
        numberOfFlyers = 6;
    }else{
        numberOfFlyers = 4;
    }
    
    [createFlyrLabel setText:NSLocalizedString(@"create_flyer", nil)];
    
    [savedFlyrLabel setText:NSLocalizedString(@"saved_flyers", nil)];

    [inviteFriendLabel setText:NSLocalizedString(@"invite_friends", nil)];
    
    //Checking if the user is valid or anonymus
    if ([[PFUser currentUser] sessionToken]) {
        //GET UPDATED USER PUCHASES INFO
        [self getUserPurcahses];
    } else {
        NSLog(@"Anonymous user is NOT authenticated.");
    }
    
    
    
    //GET FACEBOOK APP LIKE STATUS
    //Tenporary Commit that part
   // [self setFacebookLikeStatus];
    
}



-(IBAction)showFlyerDetail:(id)sender {
    
    UIButton *clickButton = sender;
    NSString *flyPath;
    
    NSLog(@"%d",clickButton.tag);
    
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
	[self.navigationController pushViewController:createFlyer animated:YES];
}

#pragma Like code

- (IBAction)onTwitter:(id)sender {
    UIButton *button = (UIButton *) sender;


        [self showAlert:@"You're not connected to the internet. Please connect and retry." message:@""];
}

-(void)showAlert:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)makeTwitterPost:(ACAccount *)acct follow:(int)follow {
    
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    [tempDict setValue:@"flyerlyapp" forKey:@"screen_name"];
    [tempDict setValue:@"true" forKey:@"follow"];
    
    
    TWRequest *postRequest;
    if ( follow == 1 ) {
        postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1/friendships/create.json"]
                                                 parameters:tempDict
                                              requestMethod:TWRequestMethodPOST];
    } else {
        postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1/friendships/destroy.json"]
                                                     parameters:tempDict
                                                  requestMethod:TWRequestMethodPOST];
    }
    
    [postRequest setAccount:acct];
    
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSString *output = [NSString stringWithFormat:@"HTTP response status: %i", [urlResponse statusCode]];
        NSLog(@"%@", output);
        
        [self hideLoadingIndicator];
        
        if([[output lowercaseString] rangeOfString:[@"200" lowercaseString]].location == NSNotFound){
            
            if ( follow == 1 ) {
                [followButton setSelected:NO];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"TWITTER_FOLLOWING"];
            } else {
                [followButton setSelected:YES];
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"TWITTER_FOLLOWING"];
            }
        } else {
            
            if ( follow == 1 ) {
                [followButton setSelected:YES];
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"TWITTER_FOLLOWING"];
            } else {
                [followButton setSelected:NO];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"TWITTER_FOLLOWING"];
            }
        }
    }];
    
}

- (IBAction)followOnTwitter:(id)sender {
    [self showLoadingIndicator];
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        
        if(granted) {
            // Get the list of Twitter accounts.
          NSArray  *arrayOfAccounts = [accountStore accountsWithAccountType:accountType];
            twtAcconts = [[NSArray alloc] initWithArray:arrayOfAccounts];
            // If there are more than 1 account, ask user which they want to use.
            if ( [arrayOfAccounts count] > 1 ) {
                // Show list of acccounts from which to select
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Choose Account" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
                    actionSheet.tag = 1;
                    
                    for (int i = 0; i < arrayOfAccounts.count; i++) {
                        ACAccount *acct = arrayOfAccounts[i];
                        [actionSheet addButtonWithTitle:acct.username];
                    }
                    
                    [actionSheet addButtonWithTitle:@"Cancel"];
                    [actionSheet showInView:self.view];
                });
                
            } else if ( [arrayOfAccounts count] > 0 ) {
                // Grab the initial Twitter account to tweet from.
                ACAccount *twitterAccount = arrayOfAccounts[0];
                [self makeTwitterPost:twitterAccount follow:1];
            } else {
                [self hideLoadingIndicator];
            }
        } else {
            [self hideLoadingIndicator];
        }
    }];
}

- (IBAction)unFollowOnTwitter:(id)sender {
    [self showLoadingIndicator];
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if(granted) {
            
            // Get the list of Twitter accounts.
           NSArray *arrayOfAccounts = [accountStore accountsWithAccountType:accountType];
            twtAcconts = [[NSArray alloc] initWithArray:arrayOfAccounts];
            // If there are more than 1 account, ask user which they want to use.
            if ( [arrayOfAccounts count] > 1 ) {
                // Show list of acccounts from which to select
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Choose Account" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
                    actionSheet.tag = 0;
                    
                    for (int i = 0; i < arrayOfAccounts.count; i++) {
                        ACAccount *acct = arrayOfAccounts[i];
                        [actionSheet addButtonWithTitle:acct.username];
                    }
                    
                    [actionSheet addButtonWithTitle:@"Cancel"];
                    [actionSheet showInView:self.view];
                });
                
            } else if ( [arrayOfAccounts count] > 0 ) {
                // Grab the initial Twitter account to tweet from.
                ACAccount *twitterAccount = arrayOfAccounts[0];
                [self makeTwitterPost:twitterAccount follow:0];
            } else {
                [self hideLoadingIndicator];
            }
        } else {
            [self hideLoadingIndicator];
        }
    }];
}

/**
 * clickedButtonAtIndex (UIActionSheet)
 *
 * Handle the button clicks from mode of getting out selection.
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //if not cancel button presses
 
    if(buttonIndex != twtAcconts.count) {
        
        //save to NSUserDefault
        ACAccount *account = twtAcconts[buttonIndex];
        
        //Convert twitter username to email
        [self makeTwitterPost:account follow:actionSheet.tag];
    }
    [self hideLoadingIndicator];
}


- (void)facebookLikeViewDidRender:(FacebookLikeView *)aFacebookLikeView {
    
    self.likeView.hidden = NO;
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDelay:0.5];
    [UIView commitAnimations];
}

- (void)facebookLikeViewDidUnlike:(FacebookLikeView *)aFacebookLikeView {
    
    // Set like button un selected
    [likeButton setSelected:NO];

    // Remove views
    [self goBack];
    
    // Remove liked status
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FACEBOOK_LIKED"];
}

- (void)facebookLikeViewDidLike:(FacebookLikeView *)aFacebookLikeView {
    
    // Set like button selected
    [likeButton setSelected:YES];

    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    // Remove views
    [self goBack];
    
    // Set like status
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"FACEBOOK_LIKED"];
}

- (IBAction)showLikeButton {
    
        
        ACAccountStore *accountStore = [[ACAccountStore alloc]init];
        ACAccountType *FBaccountType= [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
        
        //get facebook app id
        NSString *path = [[NSBundle mainBundle] pathForResource: @"Flyr-Info" ofType: @"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
        
        NSDictionary *options = @{ACFacebookAppIdKey : dict[@"FacebookAppID"],
                                  ACFacebookPermissionsKey : @[@"email", @"publish_stream"],
                                  ACFacebookAudienceKey:ACFacebookAudienceFriends};
        
        [accountStore requestAccessToAccountsWithType:FBaccountType options:options completion:^(BOOL granted, NSError *error) {
            
            // if User Login in device
            if ( granted ) {
                
                // Populate array with all available Twitter accounts
                NSArray *arrayOfAccounts = [accountStore accountsWithAccountType:FBaccountType];
                
                // Sanity check
                if ([arrayOfAccounts count] > 0) {
                    
                    // Calling The Facebook Like Button
                    self.facebookLikeView.delegate = self;
                    self.facebookLikeView.href = [NSURL URLWithString:@"http://www.facebook.com/flyerlyapp"];
                    self.facebookLikeView.layout = @"button_count";
                    self.facebookLikeView.showFaces = NO;
                    [self.facebookLikeView load];
                    
                 }
                
            } else {
                
                //Fail gracefully...
                NSLog(@"error getting permission %@",error);
                [self showAlert:@"There is no Facebook account configured. You can add or create a Facebook account in Settings" message:@""];
            }
        }];
    

        
}


- (void)facebookLikeViewRequiresLogin:(FacebookLikeView *)aFacebookLikeView {

}


/*
 * Getting
 */
- (void)setFacebookLikeStatus{

    
        // getting Facebook account Info From Device
        ACAccountStore *accountStore = [[ACAccountStore alloc]init];
        ACAccountType *FBaccountType= [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
        
        // Get facebook account
        DefaultSHKConfigurator *configurator = [[FlyerlyConfigurator alloc] init];
        
        NSDictionary *options = @{ACFacebookAppIdKey : [configurator facebookAppId],
                                  ACFacebookPermissionsKey : @[@"email", @"publish_stream"],
                                  ACFacebookAudienceKey:ACFacebookAudienceFriends};
        
        
        [accountStore requestAccessToAccountsWithType:FBaccountType options:options completion:^(BOOL granted, NSError *error) {
            
            // if User Login in device
            if ( granted ) {
                
                // Populate array with all available Twitter accounts
                NSArray *arrayOfAccounts = [accountStore accountsWithAccountType:FBaccountType];
                ACAccount *account = [arrayOfAccounts lastObject];
                
                // Sanity check
                if ([arrayOfAccounts count] > 0) {
                    
                    NSURL *requestURL = [NSURL URLWithString:@"https://graph.facebook.com/me/likes"];
                    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                            requestMethod:SLRequestMethodGET
                                                                      URL:requestURL
                                                               parameters:nil];
                    request.account = account;
                    
                    [request performRequestWithHandler:^(NSData *data,
                                                         NSHTTPURLResponse *response,
                                                         NSError *error) {
                        
                        if(!error){
                            NSDictionary *likeslist =[NSJSONSerialization JSONObjectWithData:data
                                                                                options:kNilOptions error:&error];
                            
                            //NSLog(@"Request received %@", likeslist);
                              [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FACEBOOK_LIKED"];
                            for (NSDictionary *likesData in likeslist[@"data"]) {
                                
                                // Here we will get the facebook contacts
                                
                                NSString *likeName = likesData[@"name"];
                                if([likeName isEqualToString:@"Flyerly"]){
                                    [self.likeButton setSelected:YES];
                                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"FACEBOOK_LIKED"];
                                    return;
                                } else {
                                    [likeButton setSelected:NO];
                                    
                                }
                            }
                            
                        }
                        
                    }];
                }
                
            }
        }];
        

}

-(IBAction)goBack{

    
    [self.likeView setHidden:YES];
}

/*
 * HERE WE GET USER PURCHASES INFO FROM PARSE
 */
-(void)getUserPurcahses {

    // HERE WE GET USER PURCHASES DETAIL
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"InAppPurchases"]){
        PFUser *user = [PFUser currentUser];
        PFQuery *query = [PFQuery queryWithClassName:@"InApp"];
        [query whereKey:@"user" equalTo:user];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (!error) {
                
                if (objects.count >= 1) {
                    NSMutableDictionary  *oldPurchases = [[objects objectAtIndex:0] valueForKey:@"json"];
                    
                    //its for remember key of InApp already copy to Device
                    [[NSUserDefaults standardUserDefaults] setObject:oldPurchases forKey:@"InAppPurchases"];
                    
                }
                // The find succeeded. The first 100 objects are available in objects
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
}

@end
