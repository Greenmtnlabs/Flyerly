//
//  SettingsViewController.m
//  Untechable
//
//  Created by Abdul Rauf on 28/01/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsCellView.h"
#import "Common.h"
#import "SocialnetworkController.h"
#import "EmailSettingController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FHSTwitterEngine.h"
#import "LIALinkedInHttpClient.h"
#import "LIALinkedInApplication.h"

@interface SettingsViewController () {
    
    NSMutableArray *socialIcons;
    NSMutableArray *socialNetworksName;
}
@property (strong, nonatomic) IBOutlet UITableView *socialNetworksTable;

@end

@implementation SettingsViewController

@synthesize untechable;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigation:@"viewDidLoad"];

    socialNetworksName = [[NSMutableArray alloc] initWithObjects:@"Facebook",@"Twitter",@"LinkedIn",@"Email", nil];
    
    socialIcons = [[NSMutableArray alloc] init];
    
    if ( IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 ){
        NSLog(@"iPhone 6");
        [socialIcons addObject:@{@"type":@"image", @"imgPath":@"facebook@2x.png", @"text":@""}];
        [socialIcons addObject:@{@"type":@"image", @"imgPath":@"twitter@2x.png", @"text":@""}];
        [socialIcons addObject:@{@"type":@"image", @"imgPath":@"linkedIn@2x.png", @"text":@""}];
        [socialIcons addObject:@{@"type":@"image", @"imgPath":@"email@2x.png", @"text":@""}];
    }
    
    if ( IS_IPHONE_6_PLUS ){
        NSLog(@"iPhone 6");
        [socialIcons addObject:@{@"type":@"image", @"imgPath":@"facebook@3x.png", @"text":@""}];
        [socialIcons addObject:@{@"type":@"image", @"imgPath":@"twitter@3x.png", @"text":@""}];
        [socialIcons addObject:@{@"type":@"image", @"imgPath":@"linkedIn@3x.png", @"text":@""}];
        [socialIcons addObject:@{@"type":@"image", @"imgPath":@"email@3x.png", @"text":@""}];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavigation:(NSString *)callFrom
{
    defGreen = [UIColor colorWithRed:66.0/255.0 green:247.0/255.0 blue:206.0/255.0 alpha:1.0];//GREEN
    defGray = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1.0];//GRAY
    
    if([callFrom isEqualToString:@"viewDidLoad"])
    {
        self.navigationItem.hidesBackButton = YES;
        
        // Center title __________________________________________________
        self.navigationItem.titleView = [untechable.commonFunctions navigationGetTitleView];
        
        // Right Navigation ______________________________________________
        backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        //[newUntechableButton setBackgroundColor:[UIColor redColor]];//for testing
        
        backButton.titleLabel.shadowColor = [UIColor clearColor];
        //newUntechableButton.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
        
        //[newUntechableButton setBackgroundImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
        backButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [backButton setTitle:TITLE_BACK_TXT forState:normal];
        [backButton setTitleColor:defGray forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        
        backButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *lefttBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [self.navigationItem setLeftBarButtonItem:lefttBarButton];//Left button ___________
        
       // [self.navigationItem setRightBarButtonItems:rightNavItems];//Right button ___________
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [_socialNetworksTable reloadData];
}

-(void) goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"SettingsCellView";
    SettingsCellView *cell = (SettingsCellView *)[tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        if( IS_IPHONE_5 ){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingsCellView" owner:self options:nil];
            cell = (SettingsCellView *)[nib objectAtIndex:0];
        } else if ( IS_IPHONE_6 ){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingsCellView-iPhone6" owner:self options:nil];
            cell = (SettingsCellView *)[nib objectAtIndex:0];
        } else if ( IS_IPHONE_6_PLUS ) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingsCellView-iPhone6-Plus" owner:self options:nil];
            cell = (SettingsCellView *)[nib objectAtIndex:0];
        } else {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingsCellView" owner:self options:nil];
            cell = (SettingsCellView *)[nib objectAtIndex:0];
        }
    }
    
    NSLog(@"%@", [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allValues]);
    
    NSArray *keys = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys];
    
    if ( indexPath.row == 0 ){
    
        if ( ![keys containsObject:@"fbAuth"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"fbAuth"] isEqualToString:@""] )
        {
            [cell setCellValueswithSocialNetworkName :[socialNetworksName objectAtIndex:indexPath.row] LoginStatus:0];
            
        }else if ( [keys containsObject:@"fbAuth"] && ![[[NSUserDefaults standardUserDefaults] objectForKey:@"fbAuth"] isEqualToString:@""] )
        {
            
            [cell setCellValueswithSocialNetworkName :[socialNetworksName objectAtIndex:indexPath.row] LoginStatus:1];
            
        }
        
        [cell.socialNetworkButton addTarget:self action:@selector(loginFacebook:) forControlEvents:UIControlEventTouchUpInside];
        
    }else if ( indexPath.row == 1 ){
        
        if ( ![keys containsObject:@"twitterAuth"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"twitterAuth"] isEqualToString:@""] ){
            
            [cell setCellValueswithSocialNetworkName :[socialNetworksName objectAtIndex:indexPath.row] LoginStatus:0];
            
        }else if ( [keys containsObject:@"twitterAuth"] && ![[[NSUserDefaults standardUserDefaults] objectForKey:@"twitterAuth"] isEqualToString:@""] )
        {
            
             [cell setCellValueswithSocialNetworkName :[socialNetworksName objectAtIndex:indexPath.row] LoginStatus:1];
        }
        
        [cell.socialNetworkButton addTarget:self action:@selector(loginTwitter:) forControlEvents:UIControlEventTouchUpInside];
        
    }else if ( indexPath.row == 2 ){
        
        if ( ![keys containsObject:@"linkedinAuth"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"linkedinAuth"] isEqualToString:@""] )
        {
            
            [cell setCellValueswithSocialNetworkName :[socialNetworksName objectAtIndex:indexPath.row] LoginStatus:0];
            
        }else if ( [keys containsObject:@"linkedinAuth"] && ![[[NSUserDefaults standardUserDefaults] objectForKey:@"linkedinAuth"] isEqualToString:@""] )
        {
            
             [cell setCellValueswithSocialNetworkName :[socialNetworksName objectAtIndex:indexPath.row] LoginStatus:1];
            
        }
        
        [cell.socialNetworkButton addTarget:self action:@selector(loginLinkedIn:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ( indexPath.row == 3 ){
        
        if (  [untechable.email isEqualToString:@""] || [untechable.password isEqualToString:@""] ){
            
            [cell setCellValueswithSocialNetworkName :[socialNetworksName objectAtIndex:indexPath.row] LoginStatus:0];
            
        }else {
            
            [cell setCellValueswithSocialNetworkName :[socialNetworksName objectAtIndex:indexPath.row] LoginStatus:1];
            
        }
        
        [cell.socialNetworkButton addTarget:self action:@selector(emailLogin:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

-(IBAction)emailLogin:(id)sender {
    
    if ( [untechable.email isEqualToString:@""] || [untechable.password isEqualToString:@""] ){
        
        EmailSettingController *emailSettingController;
        emailSettingController = [[EmailSettingController alloc]initWithNibName:@"EmailSettingController" bundle:nil];
        emailSettingController.untechable = untechable;
        emailSettingController.comingFromSettingsScreen = YES;
        emailSettingController.comingFromChangeEmailScreen = NO;
        [self.navigationController pushViewController:emailSettingController animated:YES];
    }
}

//Active fb button when fb toke expiry date is greater then current date.
-(BOOL)fbBtnStatus
{
    NSDate* date1 = [NSDate date];
    NSDate* date2 = [untechable.commonFunctions timestampStrToNsDate:untechable.fbAuthExpiryTs];
    BOOL active   = [untechable.commonFunctions date1IsSmallerThenDate2:date1 date2:date2];
    return active;
}

#pragma mark -  LinkedIn functions
//Init linkedin client
- (LIALinkedInHttpClient *)linkedInclient {
    LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:LINKEDIN_REDIRECT_URL
                                                                                    clientId:LINKEDIN_CLIENT_ID
                                                                                clientSecret:LINKEDIN_CLIENT_SECRET
                                                                                       state:LINKEDIN_STATE
                                                                               grantedAccess:@[@"r_basicprofile", @"rw_nus"]
                                           ];
    
    return [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
}


-(IBAction)loginLinkedIn:(id) sender {
    
    if( [self linkedInBtnStatus] ) {
        //When button was green , the delete permissions
        [self linkedInLogout];
        UIButton *linkedInButton = (UIButton *) sender;
        [linkedInButton setTitle:@"Log In" forState:UIControlStateNormal];
    }
    else {
        [self getLinkedInAuth:sender];
    }
}

-(BOOL)linkedInBtnStatus
{
    return !([untechable.linkedinAuth isEqualToString:@""]);
}

- (void)linkedInLogout {
    [untechable linkedInUpdateData:@""];
    
}

- (void)getLinkedInAuth :(id) sender {
    //1-st async call
    [self.linkedInclient getAuthorizationCode:^(NSString *code) {
        
        //2-st async call for getting access token
        [self.linkedInclient getAccessToken:code
                                    success:^(NSDictionary *accessTokenData) {
                                        
                                        untechable.linkedinAuth = [accessTokenData objectForKey:@"access_token"];
                                        
                                        NSLog(@"linked1 in accessToken %@",untechable.linkedinAuth);
                                        
                                        [untechable linkedInUpdateData:untechable.linkedinAuth];
                                        
                                       
                                        
                                        [self setLoggedInStatusOnCell:sender];
                                        
                                    }
                                    failure:^(NSError *error) {
                                        NSLog(@"Quering accessToken failed %@", error);
                                    }];
    }
                                       cancel:^{
                                           NSLog(@"Authorization was cancelled by user");
                                       }
                                      failure:^(NSError *error) {
                                          NSLog(@"Authorization failed %@", error);
                                      }];
}

-(IBAction)loginTwitter:(id) sender {
    
    if( [self twitterBtnStatus] ) {
        //When button was green , the delete permissions
        
        UIButton *twitterButton = (UIButton *) sender;
        [twitterButton setTitle:@"Log In" forState:UIControlStateNormal];
        [self twLogout];
    }
    else {
        //When button was gray , take permissions
        
        //https://github.com/fhsjaagshs/FHSTwitterEngine
        
        [[FHSTwitterEngine sharedEngine]permanentlySetConsumerKey:TW_CONSUMER_KEY andSecret:TW_CONSUMER_SECRET];
        [[FHSTwitterEngine sharedEngine]setDelegate:self];
        [[FHSTwitterEngine sharedEngine]loadAccessToken];
        
        //GO TO TWITTER AUTH LOGIN SCREEN
        UIViewController *loginController = [[FHSTwitterEngine sharedEngine]loginControllerWithCompletionHandler:^(BOOL success) {
            NSLog( success ? @"Twitter, success login on twitter" : @"Twitter login failure.");
            if ( success ){
                
                [self setLoggedInStatusOnCell:sender];
            }
        }];
        [self presentViewController:loginController animated:YES completion:nil];
    }
}

#pragma mark -  Twitter functions

-(BOOL)twitterBtnStatus
{
    return !([untechable.twitterAuth isEqualToString:@""]);
}

//LOGOUT FROM TWITTER
- (void)twLogout {
    [[FHSTwitterEngine sharedEngine]clearAccessToken];
    
    //Bello code will auto call insdie above function
    [untechable twUpdateData:@"" oAuthTokenSecret:@""];
}

//STORE TWITTER TOKEN [Note: Do not change the name of this functions, it will called from twitter libraries]
- (void)twStoreAccessToken:(NSString *)accessTokenZ {
    
    [[NSUserDefaults standardUserDefaults]setObject:accessTokenZ forKey:@"SavedAccessHTTPBody"];
    NSString *authenticatedUsername = [self extractValueForKey:@"screen_name" fromHTTPBody:accessTokenZ];
    NSString *authenticatedID = [self extractValueForKey:@"user_id" fromHTTPBody:accessTokenZ];
    
    NSString *oauth_token = [self extractValueForKey:@"oauth_token" fromHTTPBody:accessTokenZ];
    NSString *oauth_token_secret = [self extractValueForKey:@"oauth_token_secret" fromHTTPBody:accessTokenZ];
    
    NSLog(@"B- twitter : oauth_token: %@, oauth_token_secret: %@, self.authenticatedUsername: %@, self.authenticatedID: %@, ", oauth_token, oauth_token_secret, authenticatedUsername, authenticatedID);
    
    if(oauth_token == nil || oauth_token_secret == nil){
        oauth_token = oauth_token_secret =  @"";
    }
    
    [untechable twUpdateData:oauth_token oAuthTokenSecret:oauth_token_secret];
    
}
//RETURN TWITTER TOKEN [Note: Do not change the name of this functions, it will called from twitter libraries]
- (NSString *)twLoadAccessToken {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"];
}

//This functions return parmaeter value from url parmeter string
//http:abc.com?a=1&b=c in this url a is target and body is the full url
- (NSString *)extractValueForKey:(NSString *)target fromHTTPBody:(NSString *)body {
    if (body.length == 0) {
        return nil;
    }
    
    if (target.length == 0) {
        return nil;
    }
    
    NSArray *tuples = [body componentsSeparatedByString:@"&"];
    if (tuples.count < 1) {
        return nil;
    }
    
    for (NSString *tuple in tuples) {
        NSArray *keyValueArray = [tuple componentsSeparatedByString:@"="];
        
        if (keyValueArray.count >= 2) {
            NSString *key = [keyValueArray objectAtIndex:0];
            NSString *value = [keyValueArray objectAtIndex:1];
            
            if ([key isEqualToString:target]) {
                return value;
            }
        }
    }
    
    return nil;
}


-(IBAction)loginFacebook:(id) sender {
    
    if( [self fbBtnStatus] ) {
        //When button was green , the delete permissions
        [untechable fbFlushFbData];
        UIButton *facebookButton = (UIButton *) sender;
        [facebookButton setTitle:@"Log In" forState:UIControlStateNormal];
    }
    else{
        //When button was gray , take permissions
        
        // If the session state is any of the two "open" states when the button is clicked
        if (FBSession.activeSession.state == FBSessionStateOpen
            || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
            
            // Close the session and remove the access token from the cache
            // The session state handler (in the app delegate) will be called automatically
            [FBSession.activeSession closeAndClearTokenInformation];
            // If the session state is not any of the two "open" states when the button is clicked
        }
        else {
            // Open a session showing the user the login UI
            // You must ALWAYS ask for public_profile permissions when opening a session
            [FBSession openActiveSessionWithReadPermissions:@[@"publish_actions"]
                                               allowLoginUI:YES
                                          completionHandler:
             ^(FBSession *session, FBSessionState state, NSError *error) {
                 
                 // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
                 [untechable fbSessionStateChanged:session state:state error:error];
                 
                 [self setLoggedInStatusOnCell:sender];
             }];
        }
    }
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //return number of rows;
    return  4;
}

-(void) setLoggedInStatusOnCell : (id) sender {

    UIButton *socialButton = (UIButton *) sender;
    [socialButton setTitle:@"Log out" forState:UIControlStateNormal];
    
    SettingsCellView *settingCell;
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.socialNetworksTable];
    NSIndexPath *indexPath = [self.socialNetworksTable indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        settingCell = (SettingsCellView*)[_socialNetworksTable cellForRowAtIndexPath:indexPath];
    }
    
    [settingCell.loginStatus setText:@"Logged In"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
