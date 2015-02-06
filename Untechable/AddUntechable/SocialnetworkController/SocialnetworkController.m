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
#import "ThankyouController.h"
#import "SocialNetworksStatusModal.h"


@implementation SocialnetworkController

@synthesize untechable,comingFromContactsListScreen,char_Limit,inputSetSocialStatus,btnFacebook,btnTwitter,btnLinkedin,keyboardControls;

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
 
    [self setNavigationDefaults];
    [self setNavigation:@"viewDidLoad"];
    [self updateUI];
    
    //[self setDefaultModel];
    
    NSArray *fields = @[ inputSetSocialStatus ];
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
    if ( textView == inputSetSocialStatus ){
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

    [inputSetSocialStatus setTextColor:defGreen];
    inputSetSocialStatus.font = [UIFont fontWithName:APP_FONT size:16];
    inputSetSocialStatus.delegate = self;
    
    if ( [untechable.socialStatus isEqualToString:@""] ){
        inputSetSocialStatus.text = @"e.g Spending time with family.";
    }
    
    
    //[self.inputSetSocialStatus setText:untechable.socialStatus];
    if ( [untechable.socialStatus isEqualToString:@""] && [inputSetSocialStatus.text isEqualToString:@"e.g Spending time with family."] ){
        
        NSString *url = [NSString stringWithFormat:@"%@",untechable.spendingTimeTxt];
        url = [url stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *socialStatus = [NSString stringWithFormat:@"I am #Untechable & %@ untechable.com/away/%@", untechable.spendingTimeTxt,url];
        [inputSetSocialStatus setText:socialStatus];
        int len = (int)inputSetSocialStatus.text.length;
        char_Limit.text=[NSString stringWithFormat:@"%i",124-len];
    
    }else {
        
        [inputSetSocialStatus setText:untechable.socialStatus];
        int len = (int)inputSetSocialStatus.text.length;
        char_Limit.text=[NSString stringWithFormat:@"%i",124-len];
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
        
        finishButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        [finishButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
        finishButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [finishButton setTitle:TITLE_FINISH_TXT forState:normal];
        [finishButton setTitleColor:defGray forState:UIControlStateNormal];
        
        // Right Navigation ________________________________________
        /*nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 33, 42)];
        [nextButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
        nextButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [nextButton setTitle:@"NEXT" forState:normal];
        [nextButton setTitleColor:defGray forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(btnNextTouchStart) forControlEvents:UIControlEventTouchDown];
        [nextButton addTarget:self action:@selector(btnNextTouchEnd) forControlEvents:UIControlEventTouchUpInside];*/
        
        /*skipButton = [[UIButton alloc] initWithFrame:CGRectMake(33, 0, 33, 42)];
        skipButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_LEFT_SIZE];
        [skipButton setTitle:@"SKIP" forState:normal];
        [skipButton setTitleColor:defGray forState:UIControlStateNormal];
        [skipButton addTarget:self action:@selector(btnSkipTouchStart) forControlEvents:UIControlEventTouchDown];
        [skipButton addTarget:self action:@selector(btnSkipTouchEnd) forControlEvents:UIControlEventTouchUpInside];
        
        //[skipButton setBackgroundColor:[UIColor redColor]];
        skipButton.showsTouchWhenHighlighted = YES;*/
        
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:finishButton];
        //UIBarButtonItem *skipButtonBarButton = [[UIBarButtonItem alloc] initWithCustomView:skipButton];
        //NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton,skipButtonBarButton,nil];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton,nil];
        
        [self.navigationItem setRightBarButtonItems:rightNavItems];//Right buttons ___________
    }
}

/*
-(void)btnNextTouchStart{
    [self setNextHighlighted:YES];
}
-(void)btnNextTouchEnd{
    [self setNextHighlighted:NO];
}
- (void)setNextHighlighted:(BOOL)highlighted {
    (highlighted) ? [nextButton setBackgroundColor:defGreen] : [nextButton setBackgroundColor:[UIColor clearColor]];
}*/

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
    
    if( [APP_IN_MODE isEqualToString:TESTING] ){
        [self next:@"GO_TO_THANKYOU"];
    } else {
        [self sendToApi];
    }
    
    /*[self setNextHighlighted:NO];
    BOOL goToNext = YES;

    if( goToNext ) {
        [self storeSceenVarsInDic];
        [self next:@"GO_TO_NEXT"];
        
    }*/
}

-(void) sendToApi{
    
    [self changeNavigation:@"ON_FINISH"];
    
    //Background work
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        [self sendToApiAfterTask];
        
    });
}

-(void)changeNavigation:(NSString *)option
{
    // DISABLE NAVIGATION ON SEND DATA TO API
    if([option isEqualToString:@"ON_FINISH"] ){
        
        finishButton.userInteractionEnabled = NO;
        backButton.userInteractionEnabled = NO;
        
        [self showHidLoadingIndicator:YES];
        
    }
    
    // RE-ENABLE NAVIGATION WHEN ANY ERROR OCCURED
    else if([option isEqualToString:@"ERROR_ON_FINISH"] ){
        
        finishButton.userInteractionEnabled = YES;
        backButton.userInteractionEnabled = YES;
        
        [self showHidLoadingIndicator:NO];
        
        
    }
    
    // ON DATA SAVED TO API SUCCESSFULLY
    else if([option isEqualToString:@"GO_TO_THANKYOU"] ){
        
        [self next:@"GO_TO_THANKYOU"];
    }
}

-(void) sendToApiAfterTask
{
    //NSLog(@"API_SAVE = %@ ",API_SAVE);
    //NSLog(@"[untechable getRecFilePath]: %@",[untechable getRecFilePath]);
    //NSLog(@"[untechable getRecFileName]: %@",[untechable getRecFileName]);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:API_SAVE]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // -------------------- ---- Audio Upload Status ---------------------------\\
    //pass MediaType file
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"recording\"; filename=\"%@\"\r\n",[untechable getRecFileName]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: audio/caf\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // get the audio data from main bundle directly into NSData object
    NSData *audioData;
    audioData = [[NSData alloc] initWithContentsOfFile:[NSURL URLWithString:[untechable getRecFilePath]]];
    // add it to body
    [body appendData:audioData];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSArray *stringVarsAry = [[NSArray alloc] initWithObjects:@"eventId", @"userId", @"paid",
                              @"timezoneOffset", @"spendingTimeTxt", @"startDate", @"endDate", @"hasEndDate"
                              ,@"twillioNumber", @"location", @"emergencyNumber", @"hasRecording"
                              ,@"socialStatus", @"fbAuth", @"fbAuthExpiryTs" , @"twitterAuth",@"twOAuthTokenSecret",   @"linkedinAuth"
                              ,@"acType", @"email", @"password", @"respondingEmail", @"iSsl", @"imsHostName", @"imsPort", @"oSsl", @"omsHostName", @"omsPort",@"customizedContacts"
                              ,nil];
    
    for (NSString* key in untechable.dic) {
        BOOL sendIt =   NO;
        id value    =   [untechable.dic objectForKey:key];
        
        if([key isEqualToString:@"emergencyContacts"] ){
            value = [untechable.commonFunctions convertDicIntoJsonString:value];
            sendIt = YES;
        }
        
        /*if([key isEqualToString:@"customizedContacts"] ){
         value = [untechable.commonFunctions convertArrayIntoJsonString:value];
         sendIt = YES;
         }*/
        
        if( sendIt || [stringVarsAry containsObject:key]){
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
    }//for
    
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    // NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    [self setNextHighlighted:NO];
    
    BOOL errorOnFinish = NO;
    
    if( returnData != nil ){
        
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"In response of save api: %@",dict);
        
        NSString *message = @"";
        
        if( [[dict valueForKey:@"status"] isEqualToString:@"OK"] ) {
            //message = @"Untechable saved successfully";
            
            untechable.twillioNumber = [dict valueForKey:@"twillioNumber"];
            untechable.eventId = [dict valueForKey:@"eventId"];
            untechable.savedOnServer = YES;
            untechable.hasFinished = YES;
            [untechable setOrSaveVars:SAVE];
            
        } else{
            message = [dict valueForKey:@"message"];
            if( !([[dict valueForKey:@"eventId"] isEqualToString:@"0"]) ) {
                untechable.eventId = [dict valueForKey:@"eventId"];
                [untechable setOrSaveVars:SAVE];
            }
            
            errorOnFinish = YES;
        }
        
        if( !([message isEqualToString:@""]) ) {
            dispatch_async( dispatch_get_main_queue(), ^{
                [self showMsgOnApiResponse:message];
            });
        }
    }
    else{
        errorOnFinish = YES;
    }
    
    
    if( errorOnFinish ){
        dispatch_async( dispatch_get_main_queue(), ^{
            [self changeNavigation:@"ERROR_ON_FINISH"];
        });
    }
    else{
        dispatch_async( dispatch_get_main_queue(), ^{
            [self changeNavigation:@"ON_FINISH"];
            [self next:@"GO_TO_THANKYOU"];
        });
    }
    
    
}

-(void)showMsgOnApiResponse:(NSString *)message
{
    UIAlertView *temAlert = [[UIAlertView alloc ]
                             initWithTitle:@""
                             message:message
                             delegate:self
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
    [temAlert show];
    
    if( [message isEqualToString:@"Untechable created successfully"] ){
        
        /* //doing this app crashing bcz alert value nil
         //Go to main screen
         [self.navigationController popToRootViewControllerAnimated:YES];
         // Remove observers
         [[NSNotificationCenter defaultCenter] removeObserver:self];
         */
    }
}

- (void)setNextHighlighted:(BOOL)highlighted {
    (highlighted) ? [finishButton setBackgroundColor:defGreen] : [finishButton setBackgroundColor:[UIColor clearColor]];
}

/**
 * Show / hide, a loding indicator in the right bar button.
 */
- (void)showHidLoadingIndicator:(BOOL)show {
    if( show ){
        finishButton.enabled = NO;
        backButton.enabled = NO;
        
        UIActivityIndicatorView *uiBusy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [uiBusy setColor:[UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0]];
        uiBusy.hidesWhenStopped = YES;
        [uiBusy startAnimating];
        
        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:uiBusy];
        [self.navigationItem setRightBarButtonItem:btn animated:NO];
    }
    else{
        finishButton.enabled = YES;
        backButton.enabled = YES;
        [self setNavigation:@"viewDidLoad"];
    }
}

/*

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
}*/

-(void)next:(NSString *)after{
    
    if( [after isEqualToString:@"GO_TO_THANKYOU"] ) {
        ThankyouController *thankyouController;
        thankyouController = [[ThankyouController alloc]initWithNibName:@"ThankyouController" bundle:nil];
        thankyouController.untechable = untechable;
        [self.navigationController pushViewController:thankyouController animated:YES];
        
    }
    
}

-(void)storeSceenVarsInDic
{
    //untechable.socialStatus = [NSString stringWithFormat:@"%@",_inputSetSocialStatus.text];
    untechable.socialStatus = inputSetSocialStatus.text;
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
        
        untechable.socialStatus = inputSetSocialStatus.text;
        
        NSString *savedFbAuth = @"";
        NSString *savedFbAuthExpiryTs = @"";
        if ( [untechable.fbAuth isEqualToString:@""] || [untechable.fbAuthExpiryTs isEqualToString:@""] ){
            
             savedFbAuth = [[SocialNetworksStatusModal sharedInstance] getFbAuth];
             savedFbAuthExpiryTs = [[SocialNetworksStatusModal sharedInstance] getFbAuthExpiryTs];
            
            if ( [savedFbAuth isEqualToString:@""] || [savedFbAuthExpiryTs isEqualToString:@""] )
            {
                
                [[SocialNetworksStatusModal sharedInstance] loginFacebook:sender Controller:self Untechable:untechable];
                
            }else {
                
                untechable.fbAuth = savedFbAuth;
                untechable.fbAuthExpiryTs = savedFbAuthExpiryTs;
                [self btnActivate:self.btnFacebook active:YES];
            }
        }else {
            
            untechable.fbAuth = @"";
            untechable.fbAuthExpiryTs = @"";
            [self btnActivate:self.btnFacebook active:NO];
        }
    }else if(sender == self.btnTwitter){
        
        
        NSString *savedTwitterAuth = @"";
        NSString *savedTwitterAuthTokkenSecerate = @"";
        if ( [untechable.twitterAuth isEqualToString:@""] || [untechable.twOAuthTokenSecret isEqualToString:@""] ){
            
            savedTwitterAuth = [[SocialNetworksStatusModal sharedInstance] getTwitterAuth];
            savedTwitterAuthTokkenSecerate = [[SocialNetworksStatusModal sharedInstance] getTwitterAuthTokkenSecerate];
            
            if ( [savedTwitterAuth isEqualToString:@""] || [savedTwitterAuthTokkenSecerate isEqualToString:@""] )
            {
                
                [[SocialNetworksStatusModal sharedInstance] loginTwitter:sender Controller:self Untechable:untechable];
                
            }else {
                
                untechable.twitterAuth = savedTwitterAuth;
                untechable.twOAuthTokenSecret = savedTwitterAuthTokkenSecerate;
                [self btnActivate:self.btnTwitter active:YES];
            }
        }else {
            
            untechable.twitterAuth = @"";
            untechable.twOAuthTokenSecret = @"";
            [self btnActivate:self.btnTwitter active:NO];
        }

    }else if(sender == self.btnLinkedin){
        
        NSString *savedLinkedInAuth = @"";

        if ( [untechable.linkedinAuth isEqualToString:@""] ){
            
            savedLinkedInAuth = [[SocialNetworksStatusModal sharedInstance] getLinkedInAuth];
            
            if ( [savedLinkedInAuth isEqualToString:@""] )
            {
                
                [[SocialNetworksStatusModal sharedInstance] loginLinkedIn:sender Controller:self Untechable:untechable ];
                
            }else {
                
                untechable.linkedinAuth = savedLinkedInAuth;
                [self btnActivate:self.btnLinkedin active:YES];
            }
        }else {
            
            untechable.linkedinAuth = @"";
            [self btnActivate:self.btnLinkedin active:NO];
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

//RETURN TWITTER TOKEN [Note: Do not change the name of this functions, it will called from twitter libraries]
- (NSString *)twLoadAccessToken {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"];
}


-(void)textViewDidChange:(UITextView *)textView
{
    int len = textView.text.length;
    char_Limit.text=[NSString stringWithFormat:@"%i",124-len];
}

@end
