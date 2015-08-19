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

@interface SocialNetworksStatusModal () <FHSTwitterEngineAccessTokenDelegate>{
    CommonFunctions *commonFunctions;
}

@end

@implementation SocialNetworksStatusModal {
    LIALinkedInHttpClient *_linkedInclient;
}

@synthesize mSocialStatus, mFbAuth, mFbAuthExpiryTs, mTwitterAuth, mTwOAuthTokenSecret, mLinkedinAuth;;

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
        
        _linkedInclient = [self linkedInclient];
    }
    return self;
}

- (void)setEmailAddress:(NSString *)emailAddressString{
    
    [[NSUserDefaults standardUserDefaults] setObject:emailAddressString forKey:EMAIL_KEY];
}

- (void)setEmailPassword:(NSString *)emailPasswordString{
    
    [[NSUserDefaults standardUserDefaults] setObject:emailPasswordString forKey:PASSWORD_KEY];
}

- (NSString *)getEmailAddress{
    
    NSString *savedEmailAddress = @"";
    NSArray *keys = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys];
    if ( [keys containsObject:EMAIL_KEY] ){
        
        savedEmailAddress = [[NSUserDefaults standardUserDefaults] objectForKey:EMAIL_KEY];
    }
    
    return savedEmailAddress;

}

- (NSString *)getEmailPassword{
    
    NSString *savedEmailPassword = @"";
    NSArray *keys = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys];
    if ( [keys containsObject:PASSWORD_KEY] ){
        
        savedEmailPassword = [[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD_KEY];
    }
    
    return savedEmailPassword;
}

- (void)loginLinkedIn:(id)sender Controller:(UIViewController *)Controller{
    
    if( [self linkedInBtnStatus] ) {
        //When button was green , the delete permissions
        [self linkedInLogout];
        [self setLoggedInStatusOnCell:sender Controller:Controller LoggedIn:NO];
        //[self btnActivate:self.btnLinkedin active:[self linkedInBtnStatus]];
    }
    else {
        //[self getLinkedInAuth];
        [self getLinkedInAuth:sender Controller:Controller];

    }
}

#pragma mark -  LinkedIn functions
//Init linkedin client
- (LIALinkedInHttpClient *)linkedInclient {
    LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:LINKEDIN_REDIRECT_URL
                                                                                    clientId:LINKEDIN_CLIENT_ID
                                                                                clientSecret:LINKEDIN_CLIENT_SECRET
                                                                                       state:LINKEDIN_STATE
                                                                               grantedAccess:@[@"r_basicprofile", @"w_share"]
                                           ];
    
    return [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
}

//Get linkedin User profile details using accessToken
- (void)requestMeWithToken:(NSString *)linkedInAccessToken {
    
    NSLog(@"linked2 in accessToken %@",linkedInAccessToken);
    //Async call
    [self.linkedInclient GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~?oauth2_access_token=%@&format=json", linkedInAccessToken] parameters:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
                         
                         NSLog(@"current user %@", result);
                         /* //SAMPLE DATA
                          current user {
                          firstName = rufi;
                          headline = "Sr. Software Engineer at RIKSOF";
                          lastName = untechable;
                          siteStandardProfileRequest =     {
                          url = "https://www.linkedin.com/profile/view?id=384207301&authType=name&authToken=I9FC&trk=api*a3572303*s3643513*";
                          };
                          */
                         
                     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         NSLog(@"failed to fetch current user %@", error);
                     }];
}

//Update data base for fb data
-(void)linkedInFlushData {
    [self linkedInUpdateData:@""];
}

//Update data base for fb data
-(void)linkedInUpdateData:(NSString *)linkedInAccessToken {
    mLinkedinAuth = linkedInAccessToken;
}

-(BOOL)linkedInBtnStatus {
    return !( [mLinkedinAuth isEqualToString:@""] );
}

- (void)linkedInLogout {
    [self linkedInUpdateData:@""];
}

- (void)getLinkedInAuth:(id)sender Controller:(UIViewController *)Controller{
    //1-st async call
    [self.linkedInclient getAuthorizationCode:^(NSString *code) {
        
        //2-st async call for getting access token
        [self.linkedInclient getAccessToken:code
                                    success:^(NSDictionary *accessTokenData) {
                                        
                                        [self linkedInUpdateData:[accessTokenData objectForKey:@"access_token"]];
                                        [self setLoggedInStatusOnCell:sender Controller:Controller LoggedIn:YES];
                                        
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

#pragma mark -  Twitter functions
//LOGOUT FROM TWITTER
- (void)twLogout {
    [[FHSTwitterEngine sharedEngine]clearAccessToken];
    
    //Bello code will auto call insdie above function
    mTwitterAuth = @"";
}

//RETURN TWITTER TOKEN [Note: Do not change the name of this functions, it will called from twitter libraries]
- (NSString *)twLoadAccessToken {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"];
}

- (void)loginTwitter:(id)sender Controller:(UIViewController *)Controller{
    
    if( [mTwitterAuth isEqualToString:@""] == NO ) {
        //When button was green , the delete permissions
        
        [self twLogout];
        [self setLoggedInStatusOnCell:sender Controller:Controller LoggedIn:NO];
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
                
                [self setLoggedInStatusOnCell:sender Controller:Controller LoggedIn:YES];
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
-(void)twUpdateData:(NSString *)oAuthToken oAuthTokenSecret:(NSString * )oAuthTokenSecret {
    
    mTwitterAuth =   oAuthToken;
    mTwOAuthTokenSecret =   oAuthTokenSecret;
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
- (void)fbShowMessage:(NSString *)text withTitle:(NSString *)title{
    NSLog(@"in fbShowMessage: title=%@, text=%@", title, text);
}

// Show the user the logged-out UI
- (void)fbUserLoggedOut{
    [self fbFlushFbData];
}

// Show the user the logged-in UI
- (void)fbUserLoggedIn {
    
    NSString *fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
    
    NSDate *expirationDate = [[[FBSession activeSession] accessTokenData] expirationDate];
    
    [self fbUpdateFbData:fbAccessToken fbAuthExpD:expirationDate];
}

//Update data base for fb data
-(void)fbFlushFbData {
    [self fbUpdateFbData:@"" fbAuthExpD:[commonFunctions getDate:@"PAST_1_MONTH"] ];
}

//Update data base for fb data
-(void)fbUpdateFbData:(NSString *)fbA fbAuthExpD:(NSDate * )fbAuthExpD{
    mFbAuth = fbA;
    mFbAuthExpiryTs = [commonFunctions nsDateToTimeStampStr:fbAuthExpD ];
}

- (void)loginFacebook:(id)sender Controller:(UIViewController *)Controller {
    
    if( [commonFunctions fbBtnStatus:mFbAuthExpiryTs] ) {
        //When button was green , the delete permissions
        [self fbFlushFbData];
        [self setLoggedInStatusOnCell:sender Controller:Controller LoggedIn:NO];
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
                 
                 [self setLoggedInStatusOnCell:sender Controller:Controller LoggedIn:YES];
             }];
        }
    }
}
-(void) setLoggedOutStatusOnCell:(id)sender Controller:(UIViewController *)Controller {
    
    if( [Controller isKindOfClass:[SettingsViewController class]] ){
        
        UIButton *socialButton = (UIButton *) sender;
        SettingsViewController *settingsViewController = (SettingsViewController *) Controller;
        SettingsCellView *settingCell;
        CGPoint buttonPosition = [socialButton convertPoint:CGPointZero toView:settingsViewController.socialNetworksTable];
        NSIndexPath *indexPath = [settingsViewController.socialNetworksTable indexPathForRowAtPoint:buttonPosition];

        if (indexPath != nil) {
            settingCell = (SettingsCellView*)[settingsViewController.socialNetworksTable cellForRowAtIndexPath:indexPath];
        }else {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            settingCell = (SettingsCellView*)[settingsViewController.socialNetworksTable cellForRowAtIndexPath:indexPath];
            [settingCell.socialNetworkButton setTitle:@"Log In" forState:UIControlStateNormal];
        }
        
        [socialButton setTitle:@"Log In" forState:UIControlStateNormal];
        [settingCell.loginStatus setText:@"Logged Out"];
        indexPath = nil;
        
    }
    else if ( [Controller isKindOfClass:[SocialnetworkController class]] ){
        SocialnetworkController *socialnetworkController = (SocialnetworkController *) Controller;
        UIButton *socialButton = (UIButton *) sender;
        
        if ( [socialButton.titleLabel.text isEqualToString:@"Facebook"] ){
            socialnetworkController.untechable.fbAuth = mFbAuth;
            socialnetworkController.untechable.fbAuthExpiryTs = mFbAuthExpiryTs;
        }else if ( [socialButton.titleLabel.text isEqualToString:@"Twitter"] ){
            socialnetworkController.untechable.twitterAuth = mTwitterAuth;
            socialnetworkController.untechable.twOAuthTokenSecret = mTwOAuthTokenSecret;
        }else if ( [socialButton.titleLabel.text isEqualToString:@"LinkedIn"] ){
            socialnetworkController.untechable.linkedinAuth = mLinkedinAuth;
        }
        
        [socialnetworkController btnActivate:socialButton active:NO];
    }
}

-(void) setLoggedInStatusOnCell:(id)sender Controller:(UIViewController *)Controller LoggedIn:(BOOL)LoggedIn{
    
    if( [Controller isKindOfClass:[SettingsViewController class]] ){
        
        UIButton *socialButton = (UIButton *) sender;
        SettingsViewController *settingsViewController = (SettingsViewController *) Controller;
        SettingsCellView *settingCell;
        CGPoint buttonPosition = [socialButton convertPoint:CGPointZero toView:settingsViewController.socialNetworksTable];
        NSIndexPath *indexPath = [settingsViewController.socialNetworksTable indexPathForRowAtPoint:buttonPosition];
        if (indexPath != nil)
        {
            settingCell = (SettingsCellView*)[settingsViewController.socialNetworksTable cellForRowAtIndexPath:indexPath];
        }else {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            settingCell = (SettingsCellView*)[settingsViewController.socialNetworksTable cellForRowAtIndexPath:indexPath];
            if ( LoggedIn ){
                [settingCell.socialNetworkButton setTitle:@"Log Out" forState:UIControlStateNormal];
            }else {
                [settingCell.socialNetworkButton setTitle:@"Log In" forState:UIControlStateNormal];
            }
        }
        
        if ( LoggedIn ){
            [socialButton setTitle:@"Log Out" forState:UIControlStateNormal];
            [settingCell.loginStatus setText:@"Logged In"];
        }else {
            [socialButton setTitle:@"Log In" forState:UIControlStateNormal];
            [settingCell.loginStatus setText:@"Logged Out"];
        }
        indexPath = nil;
        
    }
    else if ( [Controller isKindOfClass:[SocialnetworkController class]] ){
        SocialnetworkController *socialnetworkController = (SocialnetworkController *) Controller;
        UIButton *socialButton = (UIButton *) sender;
        
        if ( [socialButton.titleLabel.text isEqualToString:@"Facebook"] ){
            socialnetworkController.untechable.fbAuth = mFbAuth;
            socialnetworkController.untechable.fbAuthExpiryTs = mFbAuthExpiryTs;
        }else if ( [socialButton.titleLabel.text isEqualToString:@"Twitter"] ){
            socialnetworkController.untechable.twitterAuth = mTwitterAuth;
            socialnetworkController.untechable.twOAuthTokenSecret = mTwOAuthTokenSecret;
        }else if ( [socialButton.titleLabel.text isEqualToString:@"LinkedIn"] ){
            socialnetworkController.untechable.linkedinAuth = mLinkedinAuth;
        }

        [socialnetworkController btnActivate:socialButton active:LoggedIn];
    }
}
@end
