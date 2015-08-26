//
//  SocialnetworkController.m
//  Untechable
//
//  Created by RIKSOF Developer on 29/09/2014.
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
#import "UserPurchases.h"

@interface SocialnetworkController(){
    UserPurchases *userPurchases;
}
@end

@implementation SocialnetworkController

@synthesize untechable,comingFromContactsListScreen,char_Limit,inputSetSocialStatus,btnFacebook,btnTwitter,btnLinkedin,keyboardControls;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 
    userPurchases = [UserPurchases getInstance];
    
    [self setNavigationDefaults];
    [self setNavigation:@"viewDidLoad"];
    [self updateUI];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMMM dd yyyy"];
  
    //showing start date on fields
    NSDate *startDate  =   [untechable.commonFunctions convertTimestampToNSDate:untechable.startDate];
    NSString *newDateStr    =   [dateFormat stringFromDate:startDate];
    NSString *showMsgToUser = [NSString stringWithFormat:@"The above message will be posted on %@ to the networks you selected below", newDateStr];
    
    _showMessageBeforeSending.text = showMsgToUser;
    _showMessageBeforeSending.textColor = DEF_GRAY;
    
    NSArray *fields = @[ inputSetSocialStatus ];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
}

-(void)viewWillAppear:(BOOL)animated {
    [self updateUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * Update the view once it appears.
 */
-(void)viewDidAppear:(BOOL)animated {    
    [super viewDidAppear:animated];
}
/*
 * Hide keyboard on done button of keyboard press
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

// Custom functions

#pragma mark - Text View Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
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

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction {
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls {
    [self.view endEditing:YES];
}


#pragma mark -  UI functions
-(void)updateUI{

    [inputSetSocialStatus setTextColor:DEF_GREEN];
    inputSetSocialStatus.font = [UIFont fontWithName:APP_FONT size:16];
    inputSetSocialStatus.delegate = self;
    
    NSString *startTimeStamp = [ untechable startDate];
    NSString *endTimeStamp = [ untechable endDate];
    NSString *getDaysOrHours = [ self calculateHoursDays:startTimeStamp  endTime: endTimeStamp];
    
    if ( [untechable.socialStatus isEqualToString:@""] ){
        untechable.socialStatus = [NSString stringWithFormat:@"#Untechable for %@ %@ ", getDaysOrHours,untechable.spendingTimeTxt];
    }
    [inputSetSocialStatus setText:untechable.socialStatus];
    
    int len = (int)inputSetSocialStatus.text.length;
    char_Limit.text=[NSString stringWithFormat:@"%i",124-len];
    
    [self.btnFacebook setTitleColor:( [untechable.fbAuth isEqualToString:@""] ? DEF_GRAY : DEF_GREEN ) forState:UIControlStateNormal];
    self.btnFacebook.titleLabel.font = [UIFont fontWithName:APP_FONT size:20];
    
    [self.btnTwitter setTitleColor:( [untechable.twitterAuth isEqualToString:@""] ? DEF_GRAY : DEF_GREEN ) forState:UIControlStateNormal];
    self.btnTwitter.titleLabel.font = [UIFont fontWithName:APP_FONT size:20];
    
    [self.btnLinkedin setTitleColor:( [untechable.linkedinAuth isEqualToString:@""] ? DEF_GRAY : DEF_GREEN ) forState:UIControlStateNormal];
    self.btnLinkedin.titleLabel.font = [UIFont fontWithName:APP_FONT size:20];
    
}
#pragma mark - timeStamp to days or hours coverter
-(NSString *) calculateHoursDays:(NSString *) startTime endTime:(NSString *)endTime {
    
    int totalMinutes;
    int totalHoursDays;
    int remainingMinutes;
    double start = [startTime doubleValue];
    double end = [endTime doubleValue];
    
    NSString *daysOrHoursToBeShown;
    int OneMinute = 60;
    int OneHour =  60 * 60;
    int OneDay  =  60 * 60 * 24;
    double diff = fabs(end  - start);
    
    totalHoursDays = round(diff/OneHour);
    totalMinutes = round(((diff/OneHour) * OneMinute));
    
    // calculating remaining minutes
    
    if(totalMinutes<=59){
        remainingMinutes = totalMinutes;
    } else if(totalMinutes<=120) {
        remainingMinutes = totalMinutes%60;
    } else {
        remainingMinutes = totalMinutes%(totalHoursDays*60);
    }
    
    if(totalHoursDays>=24) {

        totalHoursDays = round(diff/OneDay + 0.1);
        
        if( totalHoursDays == 1 ) {
            daysOrHoursToBeShown = [NSString stringWithFormat:@"%i day", totalHoursDays];
        } else {
            daysOrHoursToBeShown = [NSString stringWithFormat:@"%i days", totalHoursDays];
        }
    } else {
       
        NSString *minutes;
        if(remainingMinutes>1) {
            minutes = @"minutes";
        } else if(remainingMinutes==1) {
            minutes = @"minute";
        }
        
        if(totalHoursDays>1){
            if(remainingMinutes>0) {
                daysOrHoursToBeShown = [NSString stringWithFormat:@"%i hours and %i %@" ,totalHoursDays, remainingMinutes, minutes];
            } else {
                daysOrHoursToBeShown = [NSString stringWithFormat:@"%i hours" ,totalHoursDays];
            }
        } else if(totalHoursDays==1) {
            if(remainingMinutes>0) {
                daysOrHoursToBeShown = [NSString stringWithFormat:@"%i hour and %i %@" ,totalHoursDays, remainingMinutes, minutes];
            } else {
                daysOrHoursToBeShown = [NSString stringWithFormat:@"%i hour" ,totalHoursDays];
            }
        } else if(totalHoursDays<1) {
            daysOrHoursToBeShown = [NSString stringWithFormat:@"%i minutes", remainingMinutes];
        }
    }
 
    NSLog(@"Number of days or hours: %@", daysOrHoursToBeShown);
    return daysOrHoursToBeShown;
}

#pragma mark -  Navigation functions

- (void)setNavigationDefaults{
    
    [self testInternetConnection];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES]; //show navigation bar
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

-(void)setNavigation:(NSString *)callFrom
{
    if([callFrom isEqualToString:@"viewDidLoad"])
    {
        // Left Navigation
        backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        backButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_LEFT_SIZE];
        [backButton setTitle:TITLE_BACK_TXT forState:normal];
        [backButton setTitleColor:DEF_GRAY forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(btnBackTouchStart) forControlEvents:UIControlEventTouchDown];
        [backButton addTarget:self action:@selector(btnBackTouchEnd) forControlEvents:UIControlEventTouchUpInside];
        backButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        NSMutableArray  *leftNavItems  = [NSMutableArray arrayWithObjects:leftBarButton,nil];
        
        // adds left button to navigation bar
        [self.navigationItem setLeftBarButtonItems:leftNavItems];
        
        // Center title
        self.navigationItem.titleView = [untechable.commonFunctions navigationGetTitleView];
        
        // Right Navigation
        finishButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        [finishButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
        finishButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [finishButton setTitle:TITLE_FINISH_TXT forState:normal];
        [finishButton setTitleColor:DEF_GRAY forState:UIControlStateNormal];
        
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:finishButton];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton,nil];
        
        // adds right button to navigation bar
        [self.navigationItem setRightBarButtonItems:rightNavItems];
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
    (highlighted) ? [backButton setBackgroundColor:DEF_GREEN] : [backButton setBackgroundColor:[UIColor clearColor]];
}

-(void)onBack{
    [untechable goBack:self.navigationController];
}

-(void)onNext{

    if( !internetReachable.isReachable && !([UNT_ENVIRONMENT isEqualToString:TESTING]) ){
        //Show alert if internet is not avaialble...
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                        message:@"You must be connected to the internet to sync your untechable on server."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self testInternetConnection];
        
    }else {
        if( [APP_IN_MODE isEqualToString:TESTING] ){
            [self next:@"GO_TO_THANKYOU"];
        } else {
            
            [self changeNavigation:@"ON_FINISH"];
            
            [self storeScreenVarsInDic];
            
            [self checkPayment];
        }
             
    }

}

// Checks if we have an internet connection or not
- (void)testInternetConnection {
    internetReachable = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachable.reachableBlock = ^(Reachability*reach) {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Yayyy, we have the interwebs!");
        });
    };
    
    // Internet is not reachable
    internetReachable.unreachableBlock = ^(Reachability*reach) {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Someone broke the internet :(");
        });
    };
    
    [internetReachable startNotifier];
}


-(void)changeNavigation:(NSString *)option {
    
    int btnStatusInt = -1;
    
    // disables navigations when data is sent to API
    if([option isEqualToString:@"ON_FINISH"] ){
        btnStatusInt = 0;
    }
    
    // enables navigation when any error occurs
    else if( [option isEqualToString:@"ERROR_ON_FINISH"] || [option isEqualToString:@"ALERT_CANCEL"]){
        btnStatusInt = 1;
    }
    // ON DATA SAVED TO API SUCCESSFULLY
    else if([option isEqualToString:@"GO_TO_THANKYOU"] ){
        [self next:@"GO_TO_THANKYOU"];
    }
    
    BOOL btnsStatus = (btnStatusInt == 1) ? YES : NO;
    if( btnStatusInt != -1 ){
        finishButton.userInteractionEnabled = btnsStatus;
        backButton.userInteractionEnabled = btnsStatus;
        [self showHidLoadingIndicator:!(btnsStatus)];
    }
}

-(void)showMsgOnApiResponse:(NSString *)message {
    UIAlertView *temAlert = [[UIAlertView alloc ]
                             initWithTitle:@""
                             message:message
                             delegate:self
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
    [temAlert show];
}

- (void)setNextHighlighted:(BOOL)highlighted {
    (highlighted) ? [finishButton setBackgroundColor:DEF_GREEN] : [finishButton setBackgroundColor:[UIColor clearColor]];
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

-(void)next:(NSString *)after {
    
    if( [after isEqualToString:@"GO_TO_THANKYOU"] ) {
        ThankyouController *thankyouController;
        thankyouController = [[ThankyouController alloc]initWithNibName:@"ThankyouController" bundle:nil];
        thankyouController.untechable = untechable;
        [self.navigationController pushViewController:thankyouController animated:YES];
    }
}

-(void)storeScreenVarsInDic{
    untechable.socialStatus = inputSetSocialStatus.text;
}

-(void)requestPublishPermissions{
    
}
-(void)publishStory {
    
}

-(void)makeRequestForUserData{
    
}

#pragma mark -  Get Sharing permissions functions
- (IBAction)shareOn:(id)sender {
    
    [self storeScreenVarsInDic];
    
    if(sender == self.btnFacebook){
        
        untechable.socialStatus = inputSetSocialStatus.text;
        

        if ( [untechable.fbAuth isEqualToString:@""] ){
            if ( [untechable.socialNetworksStatusModal.mFbAuth isEqualToString:@""] ) {
                [untechable.socialNetworksStatusModal loginFacebook:sender Controller:self];
            }else {
                untechable.fbAuth = untechable.socialNetworksStatusModal.mFbAuth;
                untechable.fbAuthExpiryTs = untechable.socialNetworksStatusModal.mFbAuthExpiryTs;
                [self btnActivate:self.btnFacebook active:YES];
            }
        }else {
            untechable.fbAuth = @"";
            untechable.fbAuthExpiryTs = @"";
            [self btnActivate:self.btnFacebook active:NO];
        }
    }else if(sender == self.btnTwitter){
        if ( [untechable.twitterAuth isEqualToString:@""] || [untechable.twOAuthTokenSecret isEqualToString:@""] ){
            if ( [untechable.socialNetworksStatusModal.mTwitterAuth isEqualToString:@""] || [untechable.socialNetworksStatusModal.mTwOAuthTokenSecret isEqualToString:@""] ){
                [untechable.socialNetworksStatusModal loginTwitter:sender Controller:self];
            }else {
                untechable.twitterAuth = untechable.socialNetworksStatusModal.mTwitterAuth;
                untechable.twOAuthTokenSecret = untechable.socialNetworksStatusModal.mTwOAuthTokenSecret;
                [self btnActivate:self.btnTwitter active:YES];
            }
        }else {
            untechable.twitterAuth = @"";
            untechable.twOAuthTokenSecret = @"";
            [self btnActivate:self.btnTwitter active:NO];
        }

    }else if(sender == self.btnLinkedin){
        if ( [untechable.linkedinAuth isEqualToString:@""] ){
            if ( [untechable.socialNetworksStatusModal.mLinkedinAuth isEqualToString:@""] ) {
                [untechable.socialNetworksStatusModal loginLinkedIn:sender Controller:self];
            }else {
                untechable.linkedinAuth = untechable.socialNetworksStatusModal.mLinkedinAuth;
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
        [btnPointer setTitleColor:DEF_GREEN forState:UIControlStateNormal];
    else
        [btnPointer setTitleColor:DEF_GRAY forState:UIControlStateNormal];
}

#pragma mark -  Facebook functions

//Fb user info [Note: Do not change the name of this functions, it will called from facebook libraries]
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    NSLog(@"%@", user);
}
-(void)textViewDidChange:(UITextView *)textView{
    int len = (int)textView.text.length;
    char_Limit.text=[NSString stringWithFormat:@"%i",124-len];
}

#pragma mark -  Payment functions
/**
 * Check have valid subscription before creating untechable
 */
-(void)checkPayment{
    //When haven't any sms/call in untechable
    if( [untechable.commonFunctions haveCallOrSms:untechable.customizedContactsForCurrentSession] == NO ){
        [self createUntechableAfterPaymentCheck];
    } else {
        if( [userPurchases isSubscriptionValid] ){
            [self createUntechableAfterPaymentCheck];
        } else{
            [self showOrLoadProductsForPurchase:YES];
        }
    }
}

/**
 * Create untechable in free,without paid services (call/sms notifications)
 */
-(void)createFreeUntechable{
    //1-
    //Remove all sms / call flags, user wants free untechable
    [untechable.commonFunctions delCallAndSmsStatus:untechable.customizedContactsForCurrentSession];
    
    //2-
    [self createUntechableAfterPaymentCheck];
}

/**
 * Create untechable without payment
 */
-(void)createUntechableAfterPaymentCheck{
    //Background work
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
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


/**
 * When products loaded from apple store then show, else load
 * @param: For handling recursion deadlock we have this flag
 */
-(void)showOrLoadProductsForPurchase:(BOOL)canLoadProduct {
    
    if( userPurchases.productArray.count > 1) {
        [self showAlert:1];
    } else if( canLoadProduct ){
        
        [userPurchases loadAllProducts:^(NSString *errorMsg){
            
            if( [errorMsg isEqualToString:@""] ){
                [self showOrLoadProductsForPurchase:NO];
            } else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error occured while loading products"
                                                                message:errorMsg
                                                               delegate:self
                                                      cancelButtonTitle:@"Close"
                                                      otherButtonTitles: nil];
                alert.tag = 0;
                [alert show];
            }
        }];
        
    } else {
        [self changeNavigation:@"ERROR_ON_FINISH"];
    }
}

/**
 * Create untechable on response
 */
-(void)handlePurchaseProductResponse:(NSString *)msg{
    if ( [msg isEqualToString:SUCCESS] ) {
        [self createUntechableAfterPaymentCheck];
    }
    else if ( [msg isEqualToString:CANCEL] ) {
        [self changeNavigation:@"ALERT_CANCEL"];
    }
    else{
        [self changeNavigation:@"ERROR_ON_FINISH"];
        [untechable.commonFunctions showAlert:@"Error in purchase" message:msg];
    }
}

/**
 * All ui alerts at one place
 */
-(void)showAlert:(int)tag{
    
    //Show products in alert
    if( tag == 1 ){
        NSMutableDictionary *prodDic = userPurchases.productArray[0];
        NSString *monthlySubs = [NSString stringWithFormat:@"%@ - %@",
                                 [prodDic objectForKey:@"packagename"],
                                 [prodDic objectForKey:@"packageprice"]];
        
        prodDic = userPurchases.productArray[1];
        NSString *yearlySubs = [NSString stringWithFormat:@"%@ - %@",
                                [prodDic objectForKey:@"packagename"],
                                [prodDic objectForKey:@"packageprice"]];
        
        // Show alert before start of match to purchase our product
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase Subscription"
                                                        message:@"You can purchase monthly and yearly subscription"
                                                       delegate:self
                                              cancelButtonTitle:@"Not now"
                                              otherButtonTitles: monthlySubs, yearlySubs , @"Restore", nil];
        alert.tag = tag;
        [alert show];
    }
    //Show create untechable in free without sms/call, offer in alert
    else if( tag == 2 ){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Note"
                                                        message:@"Call / sms notifications of untechable are paid, Do you want untechable without it."
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles: @"Yes", nil];
        alert.tag = tag;
        [alert show];
    }
    
}

/**
 * Alert view delegate functions
 */
-(void)alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //Alert tag = 0, while loading product cause an error prompts the alert
    if( alertView.tag == 0 ) {
        [self changeNavigation:@"ALERT_CANCEL"];
    }
    //Alert tag = 1, while showing products in alert
    else if( alertView.tag == 1 ) {
        
        //Purchase monthly / yearly subscription
        if(buttonIndex == 1 || buttonIndex == 2) {
            NSString *productidentifier = ( buttonIndex == 1 ) ? PRO_MONTHLY_SUBS : PRO_YEARLY_SUBS;
            [userPurchases purchaseProductID:productidentifier callBack:^(NSString *msg){
                [self handlePurchaseProductResponse:msg];
            }];
        }
        //Restore purchase
        else if (buttonIndex == 3){
            [userPurchases restorePurchase:^(NSString *msg){
                [self handlePurchaseProductResponse:msg];
            }];
        }
        else{
            [self showAlert:2];
        }
    }
    //Create untechable without call / sms
    else if( alertView.tag == 2 ){
        if( buttonIndex == 1 ){
            [self createFreeUntechable];
        }
        //Cancel
        else {
            [self changeNavigation:@"ALERT_CANCEL"];
        }
    }
}
@end