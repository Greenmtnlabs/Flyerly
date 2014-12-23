//
//  SocialnetworkController.m
//  Untechable
//
//  Created by ABDUL RAUF on 29/09/2014.
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//

#import "SocialnetworkController.h"
#import "Common.h"
#import "EmailSettingController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FHSTwitterEngine.h"
#import "LIALinkedInHttpClient.h"
#import "LIALinkedInApplication.h"


@interface SocialnetworkController () <FHSTwitterEngineAccessTokenDelegate>

@property (strong, nonatomic) IBOutlet UILabel *char_Limit;

@property (strong, nonatomic) IBOutlet UITextView *inputSetSocialStatus;

@property (strong, nonatomic) IBOutlet UIButton *btnFacebook;

@property (strong, nonatomic) IBOutlet UIButton *btnTwitter;

@property (strong, nonatomic) IBOutlet UIButton *btnLinkedin;

@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

@end

@implementation SocialnetworkController
{
  LIALinkedInHttpClient *_linkedInclient;
}

@synthesize untechable;

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
    // Do any additional setup after loading the view from its nib.
 
    _linkedInclient = [self linkedInclient];
    
    [self setNavigationDefaults];
    [self setNavigation:@"viewDidLoad"];
    
    //[self setDefaultModel];
    
    NSArray *fields = @[ _inputSetSocialStatus ];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
}

-(void)viewWillAppear:(BOOL)animated {
    [self updateUI];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 * Update the view once it appears.
 */
-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [untechable printNavigation:[self navigationController]];
    [untechable setOrSaveVars:SAVE];
    
}
/*
 Hide keyboard on done button of keyboard press
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
// ________________________     Custom functions    ___________________________

#pragma mark - Text View Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    if ( [textView.text isEqualToString:@"e.g Spending time with family."] ){
        textView.text = @"";
    }
    if ( textView == _inputSetSocialStatus ){
        if ([textView.text isEqualToString:@"e.g Spending time with family."]) {
            textView.text = @"";
            textView.font = [UIFont fontWithName:TITLE_FONT size:12.0];
            textView.textColor = [UIColor blackColor]; //optional
        }
        [textView becomeFirstResponder];
    }
    [self.keyboardControls setActiveField:textView];
}

#pragma mark - Keyboard Controls(< PREV , NEXT > )  Delegate

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [self.view endEditing:YES];
}


#pragma mark -  UI functions
-(void)updateUI
{

    [_inputSetSocialStatus setTextColor:defGreen];
    _inputSetSocialStatus.font = [UIFont fontWithName:APP_FONT size:16];
    _inputSetSocialStatus.delegate = self;
    
    if ( [untechable.socialStatus isEqualToString:@""] ){
        _inputSetSocialStatus.text = @"e.g Spending time with family.";
    }
    
    
    //[self.inputSetSocialStatus setText:untechable.socialStatus];
    if ( [untechable.socialStatus isEqualToString:@""] && [_inputSetSocialStatus.text isEqualToString:@"e.g Spending time with family."] ){
        
        [_inputSetSocialStatus setText:untechable.spendingTimeTxt];
    
    }else {
        
        [_inputSetSocialStatus setText:untechable.socialStatus];
    }
    
    
    [self.btnFacebook setTitleColor:( [untechable.fbAuth isEqualToString:@""] ? defGray : defGreen ) forState:UIControlStateNormal];
    self.btnFacebook.titleLabel.font = [UIFont fontWithName:APP_FONT size:20];
    
    [self.btnTwitter setTitleColor:( [untechable.twitterAuth isEqualToString:@""] ? defGray : defGreen ) forState:UIControlStateNormal];
    self.btnTwitter.titleLabel.font = [UIFont fontWithName:APP_FONT size:20];
    
    [self.btnLinkedin setTitleColor:( [untechable.linkedinAuth isEqualToString:@""] ? defGray : defGreen ) forState:UIControlStateNormal];
    self.btnLinkedin.titleLabel.font = [UIFont fontWithName:APP_FONT size:20];
    
}
#pragma mark -  Navigation functions

- (void)setNavigationDefaults{
    
    defGreen = [UIColor colorWithRed:66.0/255.0 green:247.0/255.0 blue:206.0/255.0 alpha:1.0];//GREEN
    defGray = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1.0];//GRAY
    
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES]; //show navigation bar
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

-(void)setNavigation:(NSString *)callFrom
{
    if([callFrom isEqualToString:@"viewDidLoad"])
    {
        
        
        // Left Navigation ________________________________________________________________________________________________________
        backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        backButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_LEFT_SIZE];
        [backButton setTitle:TITLE_BACK_TXT forState:normal];
        [backButton setTitleColor:defGray forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(btnBackTouchStart) forControlEvents:UIControlEventTouchDown];
        [backButton addTarget:self action:@selector(btnBackTouchEnd) forControlEvents:UIControlEventTouchUpInside];
        
        
        backButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        NSMutableArray  *leftNavItems  = [NSMutableArray arrayWithObjects:leftBarButton,nil];
        
        [self.navigationItem setLeftBarButtonItems:leftNavItems]; //Left button ___________
        
        
        // Center title ________________________________________
        self.navigationItem.titleView = [untechable.commonFunctions navigationGetTitleView];
        
        
        // Right Navigation ________________________________________
        
        nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 33, 42)];
        [nextButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
        nextButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [nextButton setTitle:@"NEXT" forState:normal];
        [nextButton setTitleColor:defGray forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(btnNextTouchStart) forControlEvents:UIControlEventTouchDown];
        [nextButton addTarget:self action:@selector(btnNextTouchEnd) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        skipButton = [[UIButton alloc] initWithFrame:CGRectMake(33, 0, 33, 42)];
        skipButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_LEFT_SIZE];
        [skipButton setTitle:@"SKIP" forState:normal];
        [skipButton setTitleColor:defGray forState:UIControlStateNormal];
        [skipButton addTarget:self action:@selector(btnSkipTouchStart) forControlEvents:UIControlEventTouchDown];
        [skipButton addTarget:self action:@selector(btnSkipTouchEnd) forControlEvents:UIControlEventTouchUpInside];
        
        //[skipButton setBackgroundColor:[UIColor redColor]];
        skipButton.showsTouchWhenHighlighted = YES;
        
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
        UIBarButtonItem *skipButtonBarButton = [[UIBarButtonItem alloc] initWithCustomView:skipButton];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton,skipButtonBarButton,nil];
        
        [self.navigationItem setRightBarButtonItems:rightNavItems];//Right buttons ___________
    }
}

-(void)btnNextTouchStart{
    [self setNextHighlighted:YES];
}
-(void)btnNextTouchEnd{
    [self setNextHighlighted:NO];
}
- (void)setNextHighlighted:(BOOL)highlighted {
    (highlighted) ? [nextButton setBackgroundColor:defGreen] : [nextButton setBackgroundColor:[UIColor clearColor]];
}

-(void)btnBackTouchStart{
    [self setBackHighlighted:YES];
}
-(void)btnBackTouchEnd{
    [self setBackHighlighted:NO];
    [self onBack];
}
- (void)setBackHighlighted:(BOOL)highlighted {
    (highlighted) ? [backButton setBackgroundColor:defGreen] : [backButton setBackgroundColor:[UIColor clearColor]];
}

-(void)onBack{
    [untechable goBack:self.navigationController];
}

-(void)onNext{
    [self setNextHighlighted:NO];
    BOOL goToNext = YES;

    if( goToNext ) {
        [self storeSceenVarsInDic];
        [self next:@"GO_TO_NEXT"];
        
    }
}

- (void)setSkipHighlighted:(BOOL)highlighted {
    (highlighted) ? [skipButton setBackgroundColor:defGreen] : [skipButton setBackgroundColor:[UIColor clearColor]];
}

-(void)btnSkipTouchStart{
    [self setSkipHighlighted:YES];
}

-(void)btnSkipTouchEnd{
    [self setSkipHighlighted:NO];
    [self onSkip];
}
-(void)onSkip{
    
    [self setSkipHighlighted:NO];
    [self storeSceenVarsInDic];
    
    [self next:@"ON_SKIP"];
}

-(void)next:(NSString *)after{
    
    if( [after isEqualToString:@"GO_TO_NEXT"] || [after isEqualToString:@"ON_SKIP"] ) {
        EmailSettingController *emailSettingController;
        emailSettingController = [[EmailSettingController alloc]initWithNibName:@"EmailSettingController" bundle:nil];
        emailSettingController.untechable = untechable;
        [self.navigationController pushViewController:emailSettingController animated:YES];
    }
    
}




-(void)storeSceenVarsInDic
{
    //untechable.socialStatus = [NSString stringWithFormat:@"%@",_inputSetSocialStatus.text];
    untechable.socialStatus = _inputSetSocialStatus.text;
    [untechable setOrSaveVars:SAVE];
}

-(void)requestPublishPermissions{
    
}
-(void)publishStory{
    
}

-(void)makeRequestForUserData{
    
}

#pragma mark -  Get Sharing permissions functions

- (IBAction)shareOn:(id)sender {
    if(sender == self.btnFacebook){
        
        untechable.socialStatus = _inputSetSocialStatus.text;
        if( [self fbBtnStatus] ) {
            //When button was green , the delete permissions
            [untechable fbFlushFbData];
            [self btnActivate:self.btnFacebook active:[self fbBtnStatus]];
        }
        else{
            //When button was gray , take permissions
            
            // If the session state is any of the two "open" states when the button is clicked
            if (FBSession.activeSession.state == FBSessionStateOpen
                || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
                
                // Close the session and remove the access token from the cache
                // The session state handler (in the app delegate) will be called automatically
                [FBSession.activeSession closeAndClearTokenInformation];
                
                [self btnActivate:self.btnFacebook active:NO];
                
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
                     
                     
                     [self btnActivate:self.btnFacebook active:[self fbBtnStatus]];
                 }];
            }
        }
    }
    else if(sender == self.btnTwitter){
        
        if( [self twitterBtnStatus] ) {
            //When button was green , the delete permissions
            [self twLogout];
            [self btnActivate:self.btnTwitter active:[self twitterBtnStatus]];
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
            }];
            [self presentViewController:loginController animated:YES completion:nil];

            
        }
    }
    else if(sender == self.btnLinkedin){
        
        if( [self linkedInBtnStatus] ) {
            //When button was green , the delete permissions
            [self linkedInLogout];
            [self btnActivate:self.btnLinkedin active:[self linkedInBtnStatus]];
        }
        else {
            [self getLinkedInAuth];
        }
        
        
    }
}

// Button green (active) and gray ( inActive ) case
-(void)btnActivate:(UIButton *)btnPointer active:(BOOL)active {
    if( active == YES )
        [btnPointer setTitleColor:defGreen forState:UIControlStateNormal];
    else
        [btnPointer setTitleColor:defGray forState:UIControlStateNormal];
}



#pragma mark -  Facebook functions

//Fb user info [Note: Do not change the name of this functions, it will called from facebook libraries]
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    NSLog(@"%@", user);
}

//Active fb button when fb toke expiry date is greater then current date.
-(BOOL)fbBtnStatus
{
    NSDate* date1 = [NSDate date];
    NSDate* date2 = [untechable.commonFunctions timestampStrToNsDate:untechable.fbAuthExpiryTs];
    BOOL active   = [untechable.commonFunctions date1IsSmallerThenDate2:date1 date2:date2];
    return active;
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


-(BOOL)linkedInBtnStatus
{
    return !([untechable.linkedinAuth isEqualToString:@""]);
}

- (void)linkedInLogout {
    [untechable linkedInUpdateData:@""];
}

- (void)getLinkedInAuth{
    //1-st async call
    [self.linkedInclient getAuthorizationCode:^(NSString *code) {
 
        //2-st async call for getting access token
        [self.linkedInclient getAccessToken:code
        success:^(NSDictionary *accessTokenData) {
            
            untechable.linkedinAuth = [accessTokenData objectForKey:@"access_token"];
            
            NSLog(@"linked1 in accessToken %@",untechable.linkedinAuth);
            
            [untechable linkedInUpdateData:untechable.linkedinAuth];
            [self btnActivate:self.btnLinkedin active:YES];
            
            //[self requestMeWithToken:untechable.linkedinAuth];
            
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

-(void)textViewDidChange:(UITextView *)textView
{
    int len = textView.text.length;
    _char_Limit.text=[NSString stringWithFormat:@"%i",140-len];
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


@end
