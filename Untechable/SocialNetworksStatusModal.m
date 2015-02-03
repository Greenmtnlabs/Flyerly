//
//  SocialNetworksStatusModal.m
//  Untechable
//
//  Created by Abdul Rauf on 03/02/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "SocialNetworksStatusModal.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FHSTwitterEngine.h"
#import "LIALinkedInHttpClient.h"
#import "LIALinkedInApplication.h"
#import "CommonFunctions.h"
#import "Common.h"
#import "SettingsCellView.h"
#import "SocialnetworkController.h"
#import "SettingsViewController.h"

@interface SocialNetworksStatusModal () <FHSTwitterEngineAccessTokenDelegate>

@end

@implementation SocialNetworksStatusModal {
    
    UIColor *defGreen;
    UIColor *defGray;
}

@synthesize socialStatus,fbAuth,fbAuthExpiryTs,twitterAuth,twOAuthTokenSecret,linkedinAuth;

#pragma mark - singleton method
+ (SocialNetworksStatusModal* )sharedInstance
{
    static dispatch_once_t predicate = 0;
    static id sharedObject = nil;
    //static id sharedObject = nil;  //if you're not using ARC
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
        //sharedObject = [[[self alloc] init] retain]; // if you're not using ARC
    });
    return sharedObject;
}

- (id)init {
    if ( (self = [super init]) ) {
        commonFunctions = [[CommonFunctions alloc] init];
        
        
        defGreen = [UIColor colorWithRed:66.0/255.0 green:247.0/255.0 blue:206.0/255.0 alpha:1.0];//GREEN
        defGray = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1.0];//GRAY
    }
    return self;
}

- (void)setFbAuth:(NSString *)fbAuthString {
    
    [[NSUserDefaults standardUserDefaults] setObject:fbAuthString forKey:@"fbAuth"];
}

- (void)setFbAuthExpiryTs:(NSString *)setFbAuthExpiryTsString {
    
    [[NSUserDefaults standardUserDefaults] setObject:setFbAuthExpiryTsString forKey:@"fbAuthExpiryTs"];
    
}

- (NSString *)getFbAuth {
    
    NSString *savedFbAuth = @"";
    NSArray *keys = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys];
    if ( [keys containsObject:@"fbAuth"] ){
        
         savedFbAuth = [[NSUserDefaults standardUserDefaults] objectForKey:@"fbAuth"];
    }
    
    return savedFbAuth;
}

- (void)setTwitterAuth:(NSString *)twitterAuthString {
    
    [[NSUserDefaults standardUserDefaults] setObject:twitterAuthString forKey:@"twitterAuth"];
}

- (NSString *)getTwitterAuth {
    
    NSString *savedTwitterAuth = @"";
    NSArray *keys = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys];
    if ( [keys containsObject:@"twitterAuth"] ){
        
        savedTwitterAuth = [[NSUserDefaults standardUserDefaults] objectForKey:@"twitterAuth"];
    }
    
    return savedTwitterAuth;
}

- (void)setTwitterAuthTokkenSecerate:(NSString *)twitterAuthTokkenSecerate {

    [[NSUserDefaults standardUserDefaults] setObject:twitterAuthTokkenSecerate forKey:@"twitterAuthTokkenSecerate"];
    
}

- (NSString *)getTwitterAuthTokkenSecerate{
    
    NSString *savedTwitterAuthTokkenSecerate = @"";
    NSArray *keys = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys];
    if ( [keys containsObject:@"twitterAuthTokkenSecerate"] ){
        
        savedTwitterAuthTokkenSecerate = [[NSUserDefaults standardUserDefaults] objectForKey:@"twitterAuthTokkenSecerate"];
    }
    
    return savedTwitterAuthTokkenSecerate;
}



#pragma mark -  Twitter functions
-(BOOL)twitterBtnStatus
{
    return !( [[self getTwitterAuth] isEqualToString:@""] );
}

//LOGOUT FROM TWITTER
- (void)twLogout {
    [[FHSTwitterEngine sharedEngine]clearAccessToken];
    
    //Bello code will auto call insdie above function
    [self setTwitterAuth:@""];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"twitterAuth"];
}

//RETURN TWITTER TOKEN [Note: Do not change the name of this functions, it will called from twitter libraries]
- (NSString *)twLoadAccessToken {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"];
}

//This functions return parmaeter value from url parmeter string
//http:abc.com?a=1&b=c in this url a is target and body is the full url
/*
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
 }*/

- (void)loginTwitter:(id)sender Controller:(UIViewController *) Controller{
    
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
        [[FHSTwitterEngine sharedEngine]setDelegate:Controller];
        [[FHSTwitterEngine sharedEngine]loadAccessToken];
        
        //GO TO TWITTER AUTH LOGIN SCREEN
        UIViewController *loginController = [[FHSTwitterEngine sharedEngine]loginControllerWithCompletionHandler:^(BOOL success) {
            NSLog( success ? @"Twitter, success login on twitter" : @"Twitter login failure.");
            if ( success ){
                
                [self setLoggedInStatusOnCell:sender Controller:Controller];
            }
        }];
        
        [Controller presentViewController:loginController animated:YES completion:nil];
    }
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
    
    [self twUpdateData:oauth_token oAuthTokenSecret:oauth_token_secret];
    
}

//Update data base for fb data
-(void)twUpdateData:(NSString *)oAuthToken oAuthTokenSecret:(NSString * )oAuthTokenSecret
{
    NSLog(@"oAuthToken=%@",oAuthToken);
    NSLog(@"oAuthTokenSecret=%@",oAuthTokenSecret);
    
    twitterAuth =   oAuthToken;
    twOAuthTokenSecret =   oAuthTokenSecret;
    
    [[SocialNetworksStatusModal sharedInstance] setTwitterAuth:twitterAuth];
    [[SocialNetworksStatusModal sharedInstance] setTwOAuthTokenSecret:twOAuthTokenSecret];
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

#pragma mark -  Facebook functions
// This method will handle ALL the session state changes in the app
- (void)fbSessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        
        // Show the user the logged-in UI
        [self fbUserLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self fbUserLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self fbShowMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self fbShowMessage:alertText withTitle:alertTitle];
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self fbShowMessage:alertText withTitle:alertTitle];
            }
        }
        
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // Show the user the logged-out UI
        [self fbUserLoggedOut];
    }
}

// Show an alert message
- (void)fbShowMessage:(NSString *)text withTitle:(NSString *)title
{
    NSLog(@"in fbShowMessage: title=%@, text=%@", title, text);
    
    /*
     [[[UIAlertView alloc] initWithTitle:title
     message:text
     delegate:self
     cancelButtonTitle:@"OK!"
     otherButtonTitles:nil] show];
     */
}

// Show the user the logged-out UI
- (void)fbUserLoggedOut
{
    // Set the button title as "Log in with Facebook"
    //----//UIButton *loginButton = [self.customLoginViewController loginButton];
    //----//[loginButton setTitle:@"Log in with Facebook" forState:UIControlStateNormal];
    
    // Confirm logout message
    //----// [self fbShowMessage:@"You're now logged out" withTitle:@""];
    
    [self fbFlushFbData];
}

// Show the user the logged-in UI
- (void)fbUserLoggedIn
{
    
    NSString *fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
    
    NSDate *expirationDate = [[[FBSession activeSession] accessTokenData] expirationDate];
    
    [self fbUpdateFbData:fbAccessToken fbAuthExpD:expirationDate];
    
    // Set the button title as "Log out"
    //----// UIButton *loginButton = self.customLoginViewController.loginButton;
    //----// [loginButton setTitle:@"Log out" forState:UIControlStateNormal];
    
    // Welcome message
    //----// [self fbShowMessage:@"You're now logged in" withTitle:@"Welcome!"];
    
}

//Update data base for fb data
-(void)fbFlushFbData
{
    [self fbUpdateFbData:@"" fbAuthExpD:[commonFunctions getDate:@"PAST_1_MONTH"] ];
}

- (NSString *)getFbAuthExpiryTs {
    
    NSString *savedFbAuthExpiryTs = @"";
    NSArray *keys = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys];
    if ( [keys containsObject:@"fbAuthExpiryTs"] ){
        
        savedFbAuthExpiryTs = [[NSUserDefaults standardUserDefaults] objectForKey:@"fbAuthExpiryTs"];
    }
    
    return savedFbAuthExpiryTs;
}

//Update data base for fb data
-(void)fbUpdateFbData:(NSString *)fbA fbAuthExpD:(NSDate * )fbAuthExpD
{
    NSLog(@"expirationDate=%@",fbAuthExpD);
    NSLog(@"fbAccessToken=%@",fbA);
    
    fbAuth = fbA;
    fbAuthExpiryTs = [commonFunctions nsDateToTimeStampStr:fbAuthExpD ];
    
    [[SocialNetworksStatusModal sharedInstance] setFbAuth:fbAuth];
    [[SocialNetworksStatusModal sharedInstance] setFbAuthExpiryTs:fbAuthExpiryTs];
}

- (void)loginFacebook:(id)sender Controller:(UIViewController *) Controller{
    
    if( [self fbBtnStatus] ) {
        //When button was green , the delete permissions
        [self fbFlushFbData];
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
                 [self fbSessionStateChanged:session state:state error:error];
                 
                 [self setLoggedInStatusOnCell:sender Controller:Controller];
             }];
        }
    }
}

//Active fb button when fb toke expiry date is greater then current date.
-(BOOL)fbBtnStatus
{
    NSDate* date1 = [NSDate date];
    NSDate* date2 = [commonFunctions timestampStrToNsDate:[self getFbAuthExpiryTs]];
    BOOL active   = [commonFunctions date1IsSmallerThenDate2:date1 date2:date2];
    return active;
}

-(void) setLoggedInStatusOnCell : (id) sender Controller:(UIViewController *) Controller {
    
    if( [Controller isKindOfClass:[SettingsViewController class]] ){
        
        UIButton *socialButton = (UIButton *) sender;
        SettingsViewController *controller = (SettingsViewController *) Controller;
        SettingsCellView *settingCell;
        CGPoint buttonPosition = [socialButton convertPoint:CGPointZero toView:controller.socialNetworksTable];
        NSIndexPath *indexPath = [controller.socialNetworksTable indexPathForRowAtPoint:buttonPosition];
        if (indexPath != nil)
        {
            settingCell = (SettingsCellView*)[controller.socialNetworksTable cellForRowAtIndexPath:indexPath];
        }
        
        [socialButton setTitle:@"Log out" forState:UIControlStateNormal];
        [settingCell.loginStatus setText:@"Logged In"];
        indexPath = nil;
        
    }else if ( [Controller isKindOfClass:[SocialnetworkController class]] ){
        
        UIButton *socialButton = (UIButton *) sender;
        [self btnActivate:socialButton active:YES];
        
        //[socialButton setTitle:@"Log out" forState:UIControlStateNormal];
        //[settingCell.loginStatus setText:@"Logged In"];
    }
}

// Button green (active) and gray ( inActive ) case
-(void)btnActivate:(UIButton *)btnPointer active:(BOOL)active {
    if( active == YES )
        [btnPointer setTitleColor:defGreen forState:UIControlStateNormal];
    else
        [btnPointer setTitleColor:defGray forState:UIControlStateNormal];
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

/*
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
    //return !([[self getLinkedinAuth] isEqualToString:@""]);
}*/

- (void)linkedInLogout {
    
    //[untechable linkedInUpdateData:@""];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"linkedinAuth"];
    
}

- (void)getLinkedInAuth :(id) sender {
    //1-st async call
    [self.linkedInclient getAuthorizationCode:^(NSString *code) {
        
        //2-st async call for getting access token
        [self.linkedInclient getAccessToken:code
                                    success:^(NSDictionary *accessTokenData) {
                                        
                                        //untechable.linkedinAuth = [accessTokenData objectForKey:@"access_token"];
                                        
                                        NSLog(@"linked1 in accessToken %@",self.linkedinAuth);
                                        
                                        //[untechable linkedInUpdateData:untechable.linkedinAuth];
                                        
                                        
                                        
                                        //[self setLoggedInStatusOnCell:sender];
                                        
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
@end
