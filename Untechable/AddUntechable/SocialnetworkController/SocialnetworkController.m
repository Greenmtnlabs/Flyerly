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
#import "ContactsCustomizedModal.h"
#import "CommonFunctions.h"
#import <math.h>


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
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMMM dd yyyy"];
    //showing start date on fields
    NSDate *startDate  =   [untechable.commonFunctions timestampStrToNsDate:untechable.startDate];
    NSString *newDateStr    =   [dateFormat stringFromDate:startDate];
    NSString *showMsgToUser = [NSString stringWithFormat:@"The above message will be posted on %@ to the networks you selected below", newDateStr];
    
    _showMessageBeforeSending.text = showMsgToUser;
    _showMessageBeforeSending.textColor = defGray;
    
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
    
    NSString *url = [NSString stringWithFormat:@"%@",untechable.spendingTimeTxt];
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *startTimeStamp = [ untechable startDate];
    NSString *endTimeStamp = [ untechable endDate];
    NSString *getDaysOrHours = [ self calculateHoursDays:startTimeStamp  endTime: endTimeStamp];
    
    
    NSString *socialStatus;
    
    if(self.isSentFromSetupGuideFourthView){
    
        socialStatus = untechable.spendingTimeTxt;
        
    } else {
        
        socialStatus = [NSString stringWithFormat:@"#Untechable for %@ %@ ", getDaysOrHours,untechable.spendingTimeTxt];
    }
    
    [inputSetSocialStatus setText:socialStatus];
    int len = (int)inputSetSocialStatus.text.length;
    char_Limit.text=[NSString stringWithFormat:@"%i",124-len];
    

    
    [self.btnFacebook setTitleColor:( [untechable.fbAuth isEqualToString:@""] ? defGray : defGreen ) forState:UIControlStateNormal];
    self.btnFacebook.titleLabel.font = [UIFont fontWithName:APP_FONT size:20];
    
    [self.btnTwitter setTitleColor:( [untechable.twitterAuth isEqualToString:@""] ? defGray : defGreen ) forState:UIControlStateNormal];
    self.btnTwitter.titleLabel.font = [UIFont fontWithName:APP_FONT size:20];
    
    [self.btnLinkedin setTitleColor:( [untechable.linkedinAuth isEqualToString:@""] ? defGray : defGreen ) forState:UIControlStateNormal];
    self.btnLinkedin.titleLabel.font = [UIFont fontWithName:APP_FONT size:20];
    
}
#pragma mark - timeStamp to days or hours coverter
-(NSString *) calculateHoursDays:(NSString *) startTime endTime:(NSString *)endTime {
    int totalHoursDays;
    double start = [startTime doubleValue];
    double end = [endTime doubleValue];
    
    NSString *daysOrHoursToBeShown;
    int OneHour =  60 * 60;
    int OneDay  =  60 * 60 * 24;
    double diff = fabs(end  - start);
    totalHoursDays = round(diff/OneHour);
    if(totalHoursDays>48){
        
        totalHoursDays = round(diff/OneDay + 0.1);
        daysOrHoursToBeShown = [NSString stringWithFormat:@"%i days", totalHoursDays];
        
    }else if(totalHoursDays<2){
        
        daysOrHoursToBeShown = [NSString stringWithFormat:@"%i hour", totalHoursDays];
    
    }else{
        daysOrHoursToBeShown = [NSString stringWithFormat:@"%i hours", totalHoursDays];
    }
    
    NSLog(@"Number of days or hours: %@", daysOrHoursToBeShown);
    return daysOrHoursToBeShown;
}

#pragma mark -  Navigation functions

- (void)setNavigationDefaults{
    
    defGreen = [UIColor colorWithRed:66.0/255.0 green:247.0/255.0 blue:206.0/255.0 alpha:1.0];//GREEN
    defGray = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1.0];//GRAY
    
    [self testInternetConnection];
    
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
        finishButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        [finishButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
        finishButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [finishButton setTitle:TITLE_FINISH_TXT forState:normal];
        [finishButton setTitleColor:defGray forState:UIControlStateNormal];
        
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:finishButton];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton,nil];
        
        [self.navigationItem setRightBarButtonItems:rightNavItems];//Right buttons ___________
    }
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
    NSString *userNameInDb = [[NSUserDefaults standardUserDefaults]
                    stringForKey:@"userName"];
    
    if( ! ([userNameInDb isEqual:@""] || [userNameInDb length] ==0 || userNameInDb == nil) ){

    if( !internetReachable.isReachable ){
        //Show alert if internet is not avaialble...
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                        message:@"You must be connected to the internet to sync your untechable on server."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }else {
        if( [APP_IN_MODE isEqualToString:TESTING] ){
            [self next:@"GO_TO_THANKYOU"];
        } else {
            
            [self changeNavigation:@"ON_FINISH"];
            
            
            
            //Background work
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                [untechable setOrSaveVars:SAVE];
                [untechable sendToApiAfterTask:^(BOOL errorOnFinish,NSString *message){
                    
                    if( !([message isEqualToString:@""]) ) {
                        dispatch_async( dispatch_get_main_queue(), ^{
                            [self showMsgOnApiResponse:message];
                        });
                    }
                    
                    if( errorOnFinish ){
                        dispatch_async( dispatch_get_main_queue(), ^{
                            [self changeNavigation:@"ERROR_ON_FINISH"];
                        });
                    }
                    else{
                        dispatch_async( dispatch_get_main_queue(), ^{
                            [self changeNavigation:@"GO_TO_THANKYOU"];
                        });
                    }
                    
                }];
            });
        }
             
    }
    } else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Put in your name below. This will be used to help identify yourself to friends."
                                                         message:@""
                                                        delegate:self
                                               cancelButtonTitle:@"Done"
                                               otherButtonTitles:nil, nil];
        
        
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * nameField = [alert textFieldAtIndex:0];
        nameField.keyboardType = UIKeyboardTypeTwitter;
        nameField.placeholder = @"Name";
        
        [alert show];

    }
}

/**
 Action catch for the uiAlertview buttons
 we have to save name and phone number on button press
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //getting text from the text fields
    NSString *name = [alertView textFieldAtIndex:0].text;
    
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"userName"];

    [[NSUserDefaults standardUserDefaults] synchronize];    
}



// Checks if we have an internet connection or not
- (void)testInternetConnection
{
    internetReachable = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachable.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Yayyy, we have the interwebs!");
        });
    };
    
    // Internet is not reachable
    internetReachable.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Someone broke the internet :(");
        });
    };
    
    [internetReachable startNotifier];
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

- (void) removeRedundentDataForContacts {
    
    if ( untechable.customizedContactsForCurrentSession.count > 0){
    
        for ( int i=0; i<untechable.customizedContactsForCurrentSession.count; i++){
            
            ContactsCustomizedModal *tempModal = [untechable.customizedContactsForCurrentSession objectAtIndex:i];
            
            NSMutableArray *phoneNumbersWithStatus  = [[NSMutableArray alloc] initWithArray:tempModal.allPhoneNumbers copyItems:NO];
            
            for ( int j = 0; j < phoneNumbersWithStatus.count; j++){
                NSMutableArray *numberWithStatus = [[NSMutableArray alloc] init];
                
                numberWithStatus = [phoneNumbersWithStatus objectAtIndex:j];
                
                //NSString *phoneNumDecimalsOnly = [[[numberWithStatus objectAtIndex:1] componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
                
                //[numberWithStatus replaceObjectAtIndex:1 withObject:phoneNumDecimalsOnly];
                
                if ( [[numberWithStatus objectAtIndex:2] isEqualToString:@"0"] &&
                    [[numberWithStatus objectAtIndex:3] isEqualToString:@"0"]  )
                {
                    [tempModal.allPhoneNumbers removeObject:numberWithStatus];
                }
            }
            
            NSMutableArray *emailOnly  = [[NSMutableArray alloc] init];
            NSMutableArray *emailsWithStatus  = tempModal.allEmails;
    
            for ( int k = 0; k < emailsWithStatus.count; k++) {
                
                NSMutableArray *emailWithStatus = [emailsWithStatus objectAtIndex:k];
                
                if ( [[emailWithStatus objectAtIndex:1] isEqualToString:@"1"] ) {
                    
                    [emailOnly addObject:emailWithStatus];
                }
            }
            
            tempModal.allEmails = emailOnly;
        }
    }
    
    [self storeSceenVarsInDic];
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
    int len = (int)textView.text.length;
    char_Limit.text=[NSString stringWithFormat:@"%i",124-len];
}

@end
