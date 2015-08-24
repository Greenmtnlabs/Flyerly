//
//  SocialNetworksStatusModal.m
//  Untechable
//
//  Created by RIKSOF Developer on 03/02/2015.
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
    LIALinkedInHttpClient *_linkedInclient;
    CommonFunctions *commonFunctions;
}

@synthesize mSocialStatus, mFbAuth, mFbAuthExpiryTs, mTwitterAuth, mTwOAuthTokenSecret, mLinkedinAuth;;

#pragma mark - singleton method
+ (SocialNetworksStatusModal* )sharedInstance {
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
- (void)loginLinkedIn:(id)sender Controller:(UIViewController *)Controller{
    
    if( [self linkedInBtnStatus] ) {
        //When button was green , the delete permissions
        [self linkedInLogout];
        [self setLoggedInStatusOnCell:sender Controller:Controller LoggedIn:NO calledFor:@"LinkedIn"];
    }
    else {
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
            [self.linkedInclient getAccessToken:code success:^(NSDictionary *accessTokenData) {
                [self linkedInUpdateData:[accessTokenData objectForKey:@"access_token"]];
                [self setLoggedInStatusOnCell:sender Controller:Controller LoggedIn:YES calledFor:@"LinkedIn"];
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
    mTwOAuthTokenSecret = @"";
}

//RETURN TWITTER TOKEN [Note: Do not change the name of this functions, it will called from twitter libraries]
- (NSString *)twLoadAccessToken {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"];
}

- (void)loginTwitter:(id)sender Controller:(UIViewController *)Controller{
    
    if( [mTwitterAuth isEqualToString:@""] == NO ) {
        //When button was green , the delete permissions
        [self twLogout];
        [self setLoggedInStatusOnCell:sender Controller:Controller LoggedIn:NO calledFor:@"Twitter"];
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
                [self setLoggedInStatusOnCell:sender Controller:Controller LoggedIn:YES calledFor:@"Twitter"];
            }
            
        }];
        
        [Controller presentViewController:loginController animated:YES completion:nil];
    }
}

//STORE TWITTER TOKEN [Note: Do not change the name of this functions, it will called from twitter libraries]
- (void)twStoreAccessToken:(NSString *)accessTokenZ {
    
    [[NSUserDefaults standardUserDefaults]setObject:accessTokenZ forKey:@"SavedAccessHTTPBody"];
    NSString *oauth_token = [self extractValueForKey:@"oauth_token" fromHTTPBody:accessTokenZ];
    NSString *oauth_token_secret = [self extractValueForKey:@"oauth_token_secret" fromHTTPBody:accessTokenZ];
    
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
- (void)fbSessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error {
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        
        // Show the user the logged-in UI
        mFbAuth = [[[FBSession activeSession] accessTokenData] accessToken];
        mFbAuthExpiryTs = [commonFunctions nsDateToTimeStampStr:[[[FBSession activeSession] accessTokenData] expirationDate]];
        NSLog(@"Session opened new mFbAuth=%@ \n mFbAuthExpiryTs=%@ ", mFbAuth, mFbAuthExpiryTs);
        
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

//Update data base for fb data
-(void)fbFlushFbData {
    mFbAuth = @"";
    mFbAuthExpiryTs = @"";
}

/**
 * if fb session is open then close the session and return the state
 */
-(BOOL)closeFbSessionIfOpen{
    BOOL wasSessionOpen = NO;
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {

        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        // If the session state is not any of the two "open" states when the button is clicked
        
        wasSessionOpen = YES;
    }
    
    return wasSessionOpen;
}

/**
 * Function for handling facebook login and logouts
 */
- (void)loginFacebook:(id)sender Controller:(UIViewController *)Controller {
    //if we have token( already login) then logout and flush the token
    if( [commonFunctions fbBtnStatus:mFbAuthExpiryTs] ) {
        //When button was green , the delete permissions
        [self fbFlushFbData];
        [self closeFbSessionIfOpen];
        [self setLoggedInStatusOnCell:sender Controller:Controller LoggedIn:NO calledFor:@"Facebook"];
    }
    //if we haven't token then login to facebook
    else if( [self closeFbSessionIfOpen] == NO ) {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"publish_actions"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [self fbSessionStateChanged:session state:state error:error];
             
             [self setLoggedInStatusOnCell:sender Controller:Controller LoggedIn:YES calledFor:@"Facebook"];
         }];
    }
    
}

-(void) setLoggedInStatusOnCell:(id)sender Controller:(UIViewController *)Controller LoggedIn:(BOOL)LoggedIn calledFor:(NSString * )calledFor{
    
    if( [Controller isKindOfClass:[SettingsViewController class]] ){
        
        UIButton *socialButton = (UIButton *) sender;
        SettingsViewController *settingsViewController = (SettingsViewController *) Controller;
        SettingsCellView *settingCell;
        CGPoint buttonPosition = [socialButton convertPoint:CGPointZero toView:settingsViewController.socialNetworksTable];
        NSIndexPath *indexPath = [settingsViewController.socialNetworksTable indexPathForRowAtPoint:buttonPosition];
        if (indexPath != nil){
            settingCell = (SettingsCellView*)[settingsViewController.socialNetworksTable cellForRowAtIndexPath:indexPath];
        }else {
            int index = 0;
            if( ([calledFor isEqualToString:@"Facebook"])) index = 1;
            if( ([calledFor isEqualToString:@"Twitter"])) index = 2;
            if( ([calledFor isEqualToString:@"LinkedIn"])) index = 3;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
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
