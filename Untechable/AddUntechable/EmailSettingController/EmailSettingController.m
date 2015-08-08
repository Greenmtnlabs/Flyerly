 //
//  EmailSettingController.m
//  Untechable
//
//  Created by ABDUL RAUF on 30/09/2014.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "EmailSettingController.h"
#import "ThankyouController.h"
#import "Common.h"
#import "BSKeyboardControls.h"
#import "EmailChangingController.h"
#import "ServerAccountDetailsViewCell.h"
#import "SSLCell.h"
#import "SettingsViewController.h"
#import "SocialnetworkController.h"
#import "SocialNetworksStatusModal.h"
#import "ContactsCustomizedModal.h"
#import "SetupGuideFourthView.h"


@class EmailTableViewCell;

@interface EmailSettingController (){
 
    NSString *iSsl,*oSsl;
}

@property (strong, nonatomic) IBOutlet UIView *emailSetting;
@property (strong, nonatomic) IBOutlet UIView *emailSetting1;
@property (strong, nonatomic) IBOutlet UIView *emailSetting2;

@property (strong, nonatomic) IBOutlet UITableView *tableView0;
@property (weak, nonatomic) IBOutlet UISegmentedControl *serverType;


@property (strong, nonatomic) IBOutlet UILabel *lbl1;
@property (strong, nonatomic) IBOutlet UITextField *inputEmail;

@property (strong, nonatomic) IBOutlet UITextField *inputPassword;
//@property (strong, nonatomic) IBOutlet UITextField *inputMsg;


@property (strong, nonatomic) IBOutlet UITextField *inputImsHostName;
@property (strong, nonatomic) IBOutlet UITextField *inputImsPort;
@property (strong, nonatomic) IBOutlet UITextField *inputOmsHostName;
@property (strong, nonatomic) IBOutlet UITextField *inputOmsPort;

@property (strong, nonatomic) IBOutlet UISwitch *iSslSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *oSslSwitch;

@property (nonatomic, strong) BSKeyboardControls *keyboardControls;


@property (strong, nonatomic) NSMutableArray *table01Data;

@end

@implementation EmailSettingController

@synthesize untechable,sslSwitch,serverAccountTable,scrollView,comingFromSettingsScreen,comingFromChangeEmailScreen,comingFromContactsListScreen, comingFromSetupScreen;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
   return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    iSsl = @"YES";
    oSsl = @"YES";
    
    //Setting up the Scroll size
    [scrollView setContentSize:CGSizeMake(320, 750)];
 
    //Setting the initial position for scroll view
    scrollView.contentOffset = CGPointMake(0,0);
    
    _tableView0.contentInset = UIEdgeInsetsMake(-65.0f, 0.0f, 0.0f, 0.0f);
    
    [self setNavigationDefaults];
    [self setNavigation:@"viewDidLoad"];
    
    [self setDefaultModel];
    
    NSArray *fields = @[ self.inputEmail, self.inputPassword ];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
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
    
    [self hideAllViews];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self updateUI];
}

/*
 Hide keyboard on done button of keyboard press
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [textField resignFirstResponder];
    return NO;
}
// ________________________     Custom functions    ___________________________

- (void)setDefaultModel {

    _table01Data = [[NSMutableArray alloc] init];

    if ( IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 ){
        NSLog(@"iPhone 6");
        [_table01Data addObject:@{@"type":@"image", @"imgPath":@"icloudIcon@2x.png", @"text":@""}];
        [_table01Data addObject:@{@"type":@"image", @"imgPath":@"exchangeIcon@2x.png", @"text":@""}];
        [_table01Data addObject:@{@"type":@"image", @"imgPath":@"GoogleIcon@2x.png", @"text":@""}];
        [_table01Data addObject:@{@"type":@"image", @"imgPath":@"YahooIcon@2x.png", @"text":@""}];
        [_table01Data addObject:@{@"type":@"image", @"imgPath":@"aolIcon@2x.png", @"text":@""}];
        [_table01Data addObject:@{@"type":@"image", @"imgPath":@"outlookIcon@2x.png", @"text":@""}];
        [_table01Data addObject:@{@"type":@"image", @"imgPath":@"logo-Other@2x.png", @"text":@""}];
    }
    
    if ( IS_IPHONE_6_PLUS ){
        NSLog(@"iPhone 6");
        [_table01Data addObject:@{@"type":@"image", @"imgPath":@"icloudIcon@3x.png", @"text":@""}];
        [_table01Data addObject:@{@"type":@"image", @"imgPath":@"exchangeIcon@3x.png", @"text":@""}];
        [_table01Data addObject:@{@"type":@"image", @"imgPath":@"GoogleIcon@3x.png", @"text":@""}];
        [_table01Data addObject:@{@"type":@"image", @"imgPath":@"YahooIcon@3x.png", @"text":@""}];
        [_table01Data addObject:@{@"type":@"image", @"imgPath":@"aolIcon@3x.png", @"text":@""}];
        [_table01Data addObject:@{@"type":@"image", @"imgPath":@"outlookIcon@3x.png", @"text":@""}];
        [_table01Data addObject:@{@"type":@"image", @"imgPath":@"logo-Other@3x.png", @"text":@""}];
    }
}


#pragma mark - Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.keyboardControls setActiveField:textField];
}

#pragma mark - Text View Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
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
    
    [_lbl1 setTextColor:defGray];
    _lbl1.font = [UIFont fontWithName:APP_FONT size:20];
    
    [self.inputEmail setTextColor:defGreen];
    self.inputEmail.font = [UIFont fontWithName:APP_FONT size:16];
    self.inputEmail.delegate = self;
    
    
    [self.inputPassword setTextColor:defGreen];
    self.inputPassword.font = [UIFont fontWithName:APP_FONT size:16];
    self.inputPassword.delegate = self;
    
    
    if ( [untechable.email isEqualToString:@""] ){
        
        if ( ![[[NSUserDefaults standardUserDefaults] objectForKey:EMAIL_KEY] isEqualToString:@""] ||
            ![[[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD_KEY] isEqualToString:@""] ){
            
            self.inputEmail.text = [[NSUserDefaults standardUserDefaults] objectForKey:EMAIL_KEY];
            self.inputPassword.text = [[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD_KEY];
        }
    }else {
        self.inputEmail.text = untechable.email;
    }
}

#pragma mark -  Navigation functions

- (void)setNavigationDefaults{
    
    defGreen = [UIColor colorWithRed:66.0/255.0 green:247.0/255.0 blue:206.0/255.0 alpha:1.0];//GREEN
    defGray = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1.0];//GRAY
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES]; //show navigation bar
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

-(void)btnBackToAccountType{

    [self hideAllViews];
    [UIView transitionWithView:self.view duration:0.5
                       options:UIViewAnimationOptionTransitionCurlUp //change to whatever animation you like
                    animations:^ {  }
                    completion:^(BOOL finished){
                        [self setNavigation:@"viewDidLoad"];
                    }];
}

-(void)btnNextTouchEndToServerAccount{
    
    if( IS_IPHONE_5 ){
        [_emailSetting2 setFrame:CGRectMake(0,0,320,568)];
    } else if ( IS_IPHONE_6 ){
        [_emailSetting2 setFrame:CGRectMake(0,0,375,667)];
    } else if ( IS_IPHONE_6_PLUS ) {
        [_emailSetting2 setFrame:CGRectMake(0,0,414,736)];
    }
    
    [self hideAllViews];
    [UIView transitionWithView:self.view duration:0.5
                       options:UIViewAnimationOptionTransitionCurlUp //change to whatever animation you like
                    animations:^ { [self.view addSubview:_emailSetting2]; }
                    completion:^(BOOL finished){
                        [self setNavigation:@"emailSetting2"];
                    }];
}

-(void)setNavigation:(NSString *)callFrom
{
    if( [callFrom isEqualToString:@"emailSetting1"] ){
        
        // Left Navigation ________________________________________________________________________________________________________
        backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        backButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_LEFT_SIZE];
        [backButton setTitle:TITLE_BACK_TXT forState:normal];
        [backButton setTitleColor:defGray forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(btnBackTouchStart) forControlEvents:UIControlEventTouchDown];
        [backButton addTarget:self action:@selector(btnNextTouchEndToServerAccount) forControlEvents:UIControlEventTouchUpInside];
        backButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        NSMutableArray  *leftNavItems  = [NSMutableArray arrayWithObjects:leftBarButton,nil];
        
        [self.navigationItem setLeftBarButtonItems:leftNavItems]; //Left button ___________
        
        // Center title ________________________________________
        self.navigationItem.titleView = [untechable.commonFunctions navigationGetTitleView];
        
        // Right Navigation ________________________________________
        rightBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        [rightBarButton addTarget:self action:@selector(onFinish) forControlEvents:UIControlEventTouchUpInside];
        rightBarButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        
        if ( comingFromSettingsScreen ){
            
            [rightBarButton setTitle:TITLE_DONE_TXT forState:normal];
            
        }else if ( comingFromSetupScreen ) {
            
            [rightBarButton setTitle:TITLE_NEXT_TXT forState:normal];
            
        }else if ( comingFromChangeEmailScreen ) {
            
            [rightBarButton setTitle:TITLE_DONE_TXT forState:normal];
            
        }else if ( comingFromContactsListScreen ){
            
            [rightBarButton setTitle:TITLE_DONE_TXT forState:normal];
            
        }else {
            
            [rightBarButton setTitle:TITLE_FINISH_TXT forState:normal];
        }
        
        [rightBarButton setTitleColor:defGray forState:UIControlStateNormal];
        rightBarButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *rightBarButton_ = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton_,nil];
        
        if ( comingFromSettingsScreen && ![untechable.acType isEqualToString:@"OTHER"] ){
            
            [self.navigationItem setRightBarButtonItems:nil];//Right buttons ___________
            
        }else {
            
            [self.navigationItem setRightBarButtonItems:rightNavItems];//Right buttons ___________
        }
    }
    
    if( [callFrom isEqualToString:@"emailSetting2"] )
    {
        // Left Navigation ________________________________________________________________________________________________________
        backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        backButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_LEFT_SIZE];
        [backButton setTitle:TITLE_BACK_TXT forState:normal];
        [backButton setTitleColor:defGray forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(btnBackTouchStart) forControlEvents:UIControlEventTouchDown];
        [backButton addTarget:self action:@selector(btnBackToAccountType) forControlEvents:UIControlEventTouchUpInside];
        
        backButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        NSMutableArray  *leftNavItems  = [NSMutableArray arrayWithObjects:leftBarButton,nil];
        
        [self.navigationItem setLeftBarButtonItems:leftNavItems]; //Left button ___________
        
        // Center title ________________________________________
        self.navigationItem.titleView = [untechable.commonFunctions navigationGetTitleView];
        
         // Right Navigation ________________________________________
        rightBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        [rightBarButton addTarget:self action:@selector(onFinish) forControlEvents:UIControlEventTouchUpInside];
        rightBarButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        if ( comingFromSettingsScreen ){
            
            [rightBarButton setTitle:TITLE_DONE_TXT forState:normal];
            
        }else if ( comingFromChangeEmailScreen ) {
            
            [rightBarButton setTitle:TITLE_DONE_TXT forState:normal];
            
        }else if ( comingFromSetupScreen ) {
            
            [rightBarButton setTitle:TITLE_NEXT_TXT forState:normal];
            
        }else if ( comingFromContactsListScreen ){
            
            [rightBarButton setTitle:TITLE_DONE_TXT forState:normal];
            
        }else {
            
            [rightBarButton setTitle:TITLE_FINISH_TXT forState:normal];
        }
        
        [rightBarButton setTitleColor:defGray forState:UIControlStateNormal];
        
        if ( [untechable.acType isEqualToString:@"OTHER"] ){
            
            rightBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
            [rightBarButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
            rightBarButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
            [rightBarButton setTitle:@"NEXT" forState:normal];
            [rightBarButton setTitleColor:defGray forState:UIControlStateNormal];
            
        }
         rightBarButton.showsTouchWhenHighlighted = YES;
         UIBarButtonItem *rightBarButton_ = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
         NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton_,nil];
        
        [self.navigationItem setRightBarButtonItems:rightNavItems];//Right buttons ___________
    }
    
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
        rightBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        [rightBarButton addTarget:self action:@selector(onFinish) forControlEvents:UIControlEventTouchUpInside];
        rightBarButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [rightBarButton setTitle:@"FINISH" forState:normal];
        [rightBarButton setTitleColor:defGray forState:UIControlStateNormal];
        
        rightBarButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *rightBarButton_ = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton_,nil];
        
        if ( comingFromSettingsScreen ){
            
            [self.navigationItem setRightBarButtonItems:nil];//Right buttons ___________
            
        }else if ( comingFromChangeEmailScreen ) {
            
            [self.navigationItem setRightBarButtonItems:nil];//Right buttons ___________
            
        }else if ( comingFromContactsListScreen ){
            
            [self.navigationItem setRightBarButtonItems:nil];//Right buttons ___________
            
        }else if ( comingFromSetupScreen ){
            
            [self.navigationItem setRightBarButtonItems:nil];//Right buttons ___________
            
        }else {
            
            [self.navigationItem setRightBarButtonItems:rightNavItems];//Right buttons ___________
        }
    }
}

-(void)btnNextTouchStart{
    [self setNextHighlighted:YES];
}
-(void)btnNextTouchEnd{
    [self setNextHighlighted:NO];
}
- (void)setNextHighlighted:(BOOL)highlighted {
    (highlighted) ? [rightBarButton setBackgroundColor:defGreen] : [rightBarButton setBackgroundColor:[UIColor clearColor]];
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

-(void)onFinish {
    
    [[SocialNetworksStatusModal sharedInstance] setEmailAddress:self.inputEmail.text];
    
    [[SocialNetworksStatusModal sharedInstance] setEmailPassword:self.inputPassword.text];
    
    if ( comingFromSettingsScreen ){
    
        [self storeSceenVarsInDic];
        
        NSLog(@"Go To settings screen");
        
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[SettingsViewController class]]) {
                //Do not forget to import AnOldViewController.h
                
                [self.navigationController popToViewController:controller
                                                      animated:YES];
                break;
            }
        }
        
    }else if ( comingFromChangeEmailScreen ){
        
        [self storeSceenVarsInDic];
        
        NSLog(@"Go To settings screen");
        
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[EmailChangingController class]]) {
                //Do not forget to import AnOldViewController.h
                
                [self.navigationController popToViewController:controller
                                                      animated:YES];
                break;
            }
        }
        
    } else if ( comingFromContactsListScreen ){
    
        [self storeSceenVarsInDic];
        
        SocialnetworkController *socialnetwork;
        socialnetwork = [[SocialnetworkController alloc]initWithNibName:@"SocialnetworkController" bundle:nil];
        socialnetwork.untechable = untechable;
        [self.navigationController pushViewController:socialnetwork animated:YES];
        
    } else if ( comingFromSetupScreen ) {
        
        SetupGuideFourthView *fourthScreen = [[SetupGuideFourthView alloc] init];
        fourthScreen.untechable = untechable;
        [self storeSceenVarsInDic];
        [self.navigationController pushViewController:fourthScreen animated:YES];
        
    }else {
        
        if ( iSsl == nil ){
            untechable.iSsl = @"YES";
        }
        
        if ( oSsl == nil ){
            untechable.oSsl = @"YES";
        }
        
        [self storeSceenVarsInDic];
        
        if( [APP_IN_MODE isEqualToString:TESTING] ){
            [self next:@"GO_TO_THANKYOU"];
        } else {
            [self changeNavigation:@"ON_FINISH"];
            
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
    }
}

- (void) removeRedundentDataForContacts {
    
    if ( untechable.customizedContactsForCurrentSession.count > 0){
        
        for ( int i=0; i<untechable.customizedContactsForCurrentSession.count; i++){
            
            ContactsCustomizedModal *tempModal = [untechable.customizedContactsForCurrentSession objectAtIndex:i];
            
            NSMutableArray *phoneNumbersWithStatus  = tempModal.allPhoneNumbers;
            for ( int j = 0; j < phoneNumbersWithStatus.count; j++){
                NSMutableArray *numberWithStatus = [phoneNumbersWithStatus objectAtIndex:j];
                if ( [[numberWithStatus objectAtIndex:2] isEqualToString:@"0"] &&
                    [[numberWithStatus objectAtIndex:3] isEqualToString:@"0"]  )
                {
                    [phoneNumbersWithStatus removeObject:numberWithStatus];
                }
            }
            
            NSMutableArray *emailOnly  = [[NSMutableArray alloc] init];
            NSMutableArray *emailsWithStatus  = tempModal.allEmails;
            for ( int k = 0; k < emailsWithStatus.count; k++){
                NSMutableArray *emailWithStatus = [emailsWithStatus objectAtIndex:k];
                if ( [[emailWithStatus objectAtIndex:1] isEqualToString:@"0"] )
                {
                    [emailsWithStatus removeObject:emailWithStatus];
                }else {
                    [emailOnly addObject:emailWithStatus];
                }
            }
            
            tempModal.allEmails = emailOnly;
        }
        untechable.customizedContactsForCurrentSession = untechable.customizedContactsForCurrentSession;
    }
    
    [self storeSceenVarsInDic];
}

-(void)onNext {

    untechable.email = self.inputEmail.text;
    untechable.password = self.inputPassword.text;
    
    [self hideAllViews];
    
    if( IS_IPHONE_5 ){
        [_emailSetting1 setFrame:CGRectMake(0,0,320,568)];
    } else if ( IS_IPHONE_6 ){
        [_emailSetting1 setFrame:CGRectMake(0,0,375,667)];
    } else if ( IS_IPHONE_6_PLUS ) {
        [_emailSetting1 setFrame:CGRectMake(0,0,414,736)];
    }
    
    [UIView transitionWithView:self.view duration:0.5
                       options:UIViewAnimationOptionTransitionCurlUp //change to whatever animation you like
                    animations:^ { [self.view addSubview:_emailSetting1]; }
                    completion:^(BOOL finished){
                        [self setNavigation:@"emailSetting1"];
                    }];
    
}

-(void)storeSceenVarsInDic{
    
    [[NSUserDefaults standardUserDefaults] setObject:_inputEmail.text forKey:EMAIL_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:_inputPassword.text forKey:PASSWORD_KEY];
    
    untechable.email = _inputEmail.text;
    untechable.password = _inputPassword.text;
    
    if ( [untechable.acType isEqualToString:@"OTHER"] ) {
        untechable.iSsl          = iSsl;
        untechable.oSsl          = oSsl;
        untechable.imsHostName  = _inputImsHostName.text;
        untechable.imsPort      = _inputImsPort.text;
        untechable.omsHostName  = _inputOmsHostName.text;
        untechable.omsPort      = _inputOmsPort.text;
        
    }else {
        untechable.iSsl          = @"";
        untechable.oSsl          = @"";
        untechable.imsHostName   = @"";
        untechable.imsPort       = @"";
        untechable.omsHostName   = @"";
        untechable.omsPort       = @"";
    }

}



-(void)changeNavigation:(NSString *)option
{
    // DISABLE NAVIGATION ON SEND DATA TO API
    if([option isEqualToString:@"ON_FINISH"] ){
    
        rightBarButton.userInteractionEnabled = NO;
        backButton.userInteractionEnabled = NO;
        
        [self showHidLoadingIndicator:YES];
        
    }
    
    // RE-ENABLE NAVIGATION WHEN ANY ERROR OCCURED
    else if([option isEqualToString:@"ERROR_ON_FINISH"] ){
        
        rightBarButton.userInteractionEnabled = YES;
        backButton.userInteractionEnabled = YES;
        
        [self showHidLoadingIndicator:NO];
        
        
    }
    
    // ON DATA SAVED TO API SUCCESSFULLY
    else if([option isEqualToString:@"GO_TO_THANKYOU"] ){
    
        [self next:@"GO_TO_THANKYOU"];
    }
}

-(void)next:(NSString *)after
{
    if( [after isEqualToString:@"GO_TO_THANKYOU"] ) {
        
        ThankyouController *thankyouController;
        thankyouController = [[ThankyouController alloc]initWithNibName:@"ThankyouController" bundle:nil];
        thankyouController.untechable = untechable;
        [self.navigationController pushViewController:thankyouController animated:YES];
        
    }
}
/**
 * Show / hide, a loding indicator in the right bar button.
 */
- (void)showHidLoadingIndicator:(BOOL)show {
    if( show ){
        rightBarButton.enabled = NO;
        backButton.enabled = NO;
        
        UIActivityIndicatorView *uiBusy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [uiBusy setColor:[UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0]];
        uiBusy.hidesWhenStopped = YES;
        [uiBusy startAnimating];
        
        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:uiBusy];
        [self.navigationItem setRightBarButtonItem:btn animated:NO];
    }
    else{
        rightBarButton.enabled = YES;
        backButton.enabled = YES;
        [self setNavigation:@"viewDidLoad"];
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

- (IBAction)showEmailSettings1:(id)sender {
    
    [self hideAllViews];
    
    [UIView transitionWithView:self.view duration:0.5
                       options:UIViewAnimationOptionTransitionCurlUp //change to whatever animation you like
                    animations:^ { [self.view addSubview:_emailSetting1]; }
                    completion:^(BOOL finished){
                        
                    }];
    
}

- (IBAction)showEmailSettings2:(id)sender {
    
    [self hideAllViews];
    [UIView transitionWithView:self.view duration:0.5
                       options:UIViewAnimationOptionTransitionCurlUp //change to whatever animation you like
                    animations:^ { [self.view addSubview:_emailSetting2]; }
                    completion:^(BOOL finished){
                        
                    }];
    
}


-(void)hideAllViews {
    [_emailSetting1 removeFromSuperview];
    [_emailSetting2 removeFromSuperview];
}

//Allow cell editing(swip to delete)
// Override to support editing the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}


-(IBAction)clickedOnEmailOption:(id)sender
{
    UIButton *btn = sender;
    NSArray *acTypesAry = [[NSMutableArray arrayWithObjects:@"ICLOUD", @"EXCHANGE", @"GOOGLE", @"YAHOO", @"AOL", @"OUTLOOK", @"OTHER", nil] init];
    untechable.acType = [acTypesAry objectAtIndex:btn.tag];

    [self hideAllViews];
    
    if( IS_IPHONE_5 ){
        [_emailSetting2 setFrame:CGRectMake(0,0,320,568)];
    } else if ( IS_IPHONE_6 ){
        [_emailSetting2 setFrame:CGRectMake(0,0,375,667)];
    } else if ( IS_IPHONE_6_PLUS ) {
        [_emailSetting2 setFrame:CGRectMake(0,0,414,736)];
    }
    
    [UIView transitionWithView:self.view duration:0.5
                       options:UIViewAnimationOptionTransitionCurlUp //change to whatever animation you like
                    animations:^ { [self.view addSubview:_emailSetting2]; }
                    completion:^(BOOL finished){
                        [self setNavigation:@"emailSetting2"];
                    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int countOfSection = 0;
    if ( tableView == serverAccountTable ){
        countOfSection =  3;
    }else if ( tableView == _tableView0 ){
        countOfSection =  1;
    }
    
    return countOfSection;
}

//4
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if ( tableView == serverAccountTable ){
        if ( indexPath.row == 2 ){
            
            static NSString *cellId = @"SSLCell";
            SSLCell *cell = (SSLCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
            
            if (cell == nil)
            {
                if( IS_IPHONE_5 ){
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SSLCell" owner:self options:nil];
                    cell = (SSLCell *)[nib objectAtIndex:0];
                } else if ( IS_IPHONE_6 ){
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SSLCell-iPhone6" owner:self options:nil];
                    cell = (SSLCell *)[nib objectAtIndex:0];
                } else if ( IS_IPHONE_6_PLUS ) {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SSLCell-iPhone6-Plus" owner:self options:nil];
                    cell = (SSLCell *)[nib objectAtIndex:0];
                } else {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SSLCell" owner:self options:nil];
                    cell = (SSLCell *)[nib objectAtIndex:0];
                }
                
            }
            
            cell.sslSwitch.tag = indexPath.section;
            [cell.sslSwitch addTarget:self
                               action:@selector(sslStateChanged:) forControlEvents:UIControlEventValueChanged];
            
            if ( cell.sslSwitch.tag == 0 ){
                _iSslSwitch = cell.sslSwitch;
                if ( [untechable.iSsl isEqualToString:@"YES"] ){
                    [_iSslSwitch setOn:YES];
                }else if ( [untechable.iSsl isEqualToString:@"NO"] ){
                    [_iSslSwitch setOn:NO];
                }
            }else if ( cell.sslSwitch.tag == 1 ){
                _oSslSwitch = cell.sslSwitch;
                if ( [untechable.oSsl isEqualToString:@"YES"] ){
                    [_oSslSwitch setOn:YES];
                }else if ( [untechable.oSsl isEqualToString:@"NO"] ){
                    [_oSslSwitch setOn:NO];
                }
            }
            return cell;
        }
        else if ( indexPath.section == 0 || indexPath.section == 1 ){
            
            if ( indexPath.section == 0 ){
                NSMutableArray *inputLabel = [[NSMutableArray arrayWithObjects:@"Host Name",@"IMAP Port",nil] init];
                NSMutableArray *inputFeildPlaceHolder = [[NSMutableArray arrayWithObjects:@"mail.example.com",@"993",nil] init];
                
                static NSString *cellId = @"ServerAccountDetailsViewCell";
                ServerAccountDetailsViewCell *cell = (ServerAccountDetailsViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
                
                if (cell == nil)
                {
                    if( IS_IPHONE_5 ){
                        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ServerAccountDetailsViewCell" owner:self options:nil];
                        cell = (ServerAccountDetailsViewCell *)[nib objectAtIndex:0];
                    } else if ( IS_IPHONE_6 ){
                        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ServerAccountDetailsViewCell-iPhone6" owner:self options:nil];
                        cell = (ServerAccountDetailsViewCell *)[nib objectAtIndex:0];
                    } else if ( IS_IPHONE_6_PLUS ) {
                        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ServerAccountDetailsViewCell-iPhone6-Plus" owner:self options:nil];
                        cell = (ServerAccountDetailsViewCell *)[nib objectAtIndex:0];
                    } else {
                        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ServerAccountDetailsViewCell" owner:self options:nil];
                        cell = (ServerAccountDetailsViewCell *)[nib objectAtIndex:0];
                    }
                }
                
                [cell setCellValueswithInputLabel:[inputLabel objectAtIndex:indexPath.row] FeildPlaceholder:[inputFeildPlaceHolder objectAtIndex:indexPath.row]];
                
                cell.inputFeild.delegate = self;
                cell.inputFeild.tag = indexPath.row + indexPath.section;
                [cell.inputFeild addTarget:self action:@selector(inputBegin:) forControlEvents:UIControlEventEditingDidBegin];
                [cell.inputFeild addTarget:self action:@selector(inputEnd:) forControlEvents:UIControlEventValueChanged];
                
                if( cell.inputFeild.tag == 0 ){
                    _inputImsHostName   =   cell.inputFeild;
                    _inputImsHostName.text = untechable.imsHostName;
                }else if( cell.inputFeild.tag == 1 ){
                    _inputImsPort   =   cell.inputFeild;
                    [cell.inputFeild setKeyboardType:UIKeyboardTypeNumberPad];
                    _inputImsPort.text = untechable.imsPort;
                }
                
                return cell;
            }else if ( indexPath.section == 1 ){
                NSMutableArray *inputLabel = [[NSMutableArray arrayWithObjects:@"Host Name",@"SMTP Port",nil] init];
                NSMutableArray *inputFeildPlaceHolder = [[NSMutableArray arrayWithObjects:@"smtp.example.com",@"587",nil] init];
                
                static NSString *cellId = @"ServerAccountDetailsViewCell";
                ServerAccountDetailsViewCell *cell = (ServerAccountDetailsViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
                
                if (cell == nil)
                {
                    if( IS_IPHONE_5 ){
                        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ServerAccountDetailsViewCell" owner:self options:nil];
                        cell = (ServerAccountDetailsViewCell *)[nib objectAtIndex:0];
                    } else if ( IS_IPHONE_6 ){
                        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ServerAccountDetailsViewCell-iPhone6" owner:self options:nil];
                        cell = (ServerAccountDetailsViewCell *)[nib objectAtIndex:0];
                    } else if ( IS_IPHONE_6_PLUS ) {
                        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ServerAccountDetailsViewCell-iPhone6-Plus" owner:self options:nil];
                        cell = (ServerAccountDetailsViewCell *)[nib objectAtIndex:0];
                    } else {
                        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ServerAccountDetailsViewCell" owner:self options:nil];
                        cell = (ServerAccountDetailsViewCell *)[nib objectAtIndex:0];
                    }
                }
            
                [cell setCellValueswithInputLabel:[inputLabel objectAtIndex:indexPath.row] FeildPlaceholder:[inputFeildPlaceHolder objectAtIndex:indexPath.row]];
                
                cell.inputFeild.delegate = self;
                cell.inputFeild.tag = indexPath.row + indexPath.section;
                [cell.inputFeild addTarget:self action:@selector(inputBegin:) forControlEvents:UIControlEventEditingDidBegin];
                [cell.inputFeild addTarget:self action:@selector(inputEnd:) forControlEvents:UIControlEventValueChanged];
                
                if( cell.inputFeild.tag == 1 ){
                    _inputOmsHostName   =   cell.inputFeild;
                    _inputOmsHostName.text = untechable.omsHostName;
                }else if( cell.inputFeild.tag == 2 ){
                    _inputOmsPort   =   cell.inputFeild;
                    [cell.inputFeild setKeyboardType:UIKeyboardTypeNumberPad];
                    _inputOmsPort.text = untechable.omsPort;
                }
                
                return cell;
            }
        }
    }
    
    if( tableView == _tableView0 ) {
        static NSString *cellId = @"EmailTableViewCell";
        EmailTableViewCell *cell = (EmailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
        if (cell == nil)
        {
            if( IS_IPHONE_5 ){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EmailTableViewCell" owner:self options:nil];
                cell = (EmailTableViewCell *)[nib objectAtIndex:0];
            } else if ( IS_IPHONE_6 ){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EmailTableViewCell-iPhone6" owner:self options:nil];
                cell = (EmailTableViewCell *)[nib objectAtIndex:0];
            } else if ( IS_IPHONE_6_PLUS ) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EmailTableViewCell-iPhone6-Plus" owner:self options:nil];
                cell = (EmailTableViewCell *)[nib objectAtIndex:0];
            } else {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EmailTableViewCell" owner:self options:nil];
                cell = (EmailTableViewCell *)[nib objectAtIndex:0];
            }
        }
        NSString *imgPath = [[_table01Data objectAtIndex:indexPath.row] objectForKey:@"imgPath"];
        cell.button1.tag = indexPath.row;
        [cell.button1 setImage:[UIImage imageNamed:imgPath] forState:UIControlStateNormal];
        [cell.button1 addTarget:self action:@selector(clickedOnEmailOption:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    return cell;
}


-(IBAction)inputBegin:(id) sender
{
    UITextField *feild = (UITextField *) sender;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    return  YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    if ( textField == _inputOmsHostName || textField == _inputOmsPort ){
        
        [scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
        
    }
    return YES;
}

//3
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = 0;
    
    if ( tableView == serverAccountTable ){
        
        if ( section == 0 ){
            count = 3;
        }else if ( section == 1 ){
            count = 3;
        }
        
    } else if ( tableView == _tableView0 ) {
        
        if( tableView == _tableView0 )
            count = _table01Data.count;
    }

    return count;
}

-(IBAction)sslStateChanged:(id) sender
{
    UISwitch *my_switch = (UISwitch *) sender;
    
    if ( my_switch == _iSslSwitch ){
        if ( [_iSslSwitch isOn] ) {
            iSsl = @"YES";
        } else {
            iSsl = @"NO";
        }
    }else if ( my_switch == _oSslSwitch ){
        if ([_oSslSwitch isOn]) {
            oSsl = @"YES";
        } else {
            oSsl = @"NO";
        }
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerView;
    
    if ( tableView == _tableView0 ){
    
        // 1. The view for the header
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -2, tableView.frame.size.width, 60)];
        
        // 2. Set a custom background color and a border
        headerView.backgroundColor = [UIColor whiteColor];
        
        // 3. Add a label
        UILabel* headerLabel = [[UILabel alloc] init];
        
        headerLabel.frame = CGRectMake(10, 0, tableView.frame.size.width - 10, 60);
        headerLabel.textColor = [UIColor lightGrayColor];
        headerLabel.font = [UIFont fontWithName:APP_FONT size:18];
        headerLabel.numberOfLines = 3;
        headerLabel.text = @"Select your email service to let your contacts know you will be untechable.";
        
        NSString *labelText = @"Select your email service to let your contacts know you will be untechable.";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:8];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        headerLabel.attributedText = attributedString ;
        
        headerLabel.textAlignment = NSTextAlignmentCenter;
        
        // 4. Add the label to the header view
        [headerView addSubview:headerLabel];
    }
    
    // 5. Finally return
    return headerView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionHeader;
    if ( tableView != _tableView0 ){
        if ( section == 0 ){
            sectionHeader = @"Incoming Mail Server";
        }else if ( section == 1 ){
            sectionHeader = @"OutGoing Mail Server";
        }
    }
    return sectionHeader;
}

@end
