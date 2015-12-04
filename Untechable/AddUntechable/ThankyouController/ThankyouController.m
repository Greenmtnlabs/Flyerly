//
//  ThankyouController.m
//  Untechable
//
//  Created by RIKSOF Developer on 28/10/2014.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "ThankyouController.h"
#import "AddUntechableController.h"
#import "Common.h"
#import "SettingsViewController.h"
#import "HowToScreenThreeViewController.h"
#import "UntechablesList.h"
#import "InviteFriendsController.h"

@interface ThankyouController ()

@property (strong, nonatomic) IBOutlet UILabel *lblStartsFrom;
@property (strong, nonatomic) IBOutlet UILabel *lblStartDateTime;
@property (strong, nonatomic) IBOutlet UILabel *lblEnd;
@property (strong, nonatomic) IBOutlet UILabel *lblEndDateTime;
@property (strong, nonatomic) IBOutlet UILabel *lblForwadingNumber;

@end

@implementation ThankyouController

@synthesize untechable;
@synthesize btnEnjoyLife, btnInviteOthers;

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
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self updateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToSettings {
    
    NSLog(@"Go To settings screen");
    SettingsViewController *settingsController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    settingsController.untechable = untechable;
    [self.navigationController pushViewController:settingsController animated:YES];
}

- (IBAction)onNext:(id)sender {
    HowToScreenThreeViewController *howToScreenThreeViewController = [[HowToScreenThreeViewController alloc]initWithNibName:@"HowToScreenThreeViewController" bundle:nil];
    howToScreenThreeViewController.isComingFromThankYou = YES;
    [self.navigationController pushViewController:howToScreenThreeViewController animated:YES];
}



#pragma mark -  UI functions
-(void)updateUI
{
    [btnEnjoyLife setTitle: NSLocalizedString(@"Enjoy Life", nil) forState: UIControlStateNormal];
    [btnInviteOthers setTitle: NSLocalizedString(@"Invite Others", nil) forState: UIControlStateNormal];
    
    [_lblStartsFrom setText:NSLocalizedString(@"You will be untechable from", nil)];
    [_lblStartsFrom setTextColor:DEF_GRAY];
    _lblStartsFrom.font = [UIFont fontWithName:APP_FONT size:20];
    
    
    [_lblStartDateTime setTextColor:DEF_GREEN];
    _lblStartDateTime.font = [UIFont fontWithName:APP_FONT size:20];
    _lblStartDateTime.text = [untechable.commonFunctions convertTimestampToAppDate:untechable.startDate];
    
    
    [_lblEnd setText:NSLocalizedString(@"To", nil)];
    [_lblEnd setTextColor:DEF_GRAY];
    _lblEnd.font = [UIFont fontWithName:APP_FONT size:20];
    
    
    [_lblEndDateTime setTextColor:DEF_GREEN];
    _lblEndDateTime.font = [UIFont fontWithName:APP_FONT size:20];
    _lblEndDateTime.text = [untechable.commonFunctions convertTimestampToAppDate:untechable.endDate];
    
    [_lblForwadingNumber setTextColor:DEF_GRAY];
    _lblForwadingNumber.font = [UIFont fontWithName:APP_FONT size:20];
    
    NSString *twillioNumber = untechable.twillioNumber;
   
    NSLog(@"twillioNumber1: %@", twillioNumber);
    twillioNumber   =   [untechable.commonFunctions standarizePhoneNumber:twillioNumber];
    NSLog(@"twillioNumber2: %@", twillioNumber);
   
}

#pragma mark -  Navigation functions

- (void)setNavigationDefaults{    
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES]; //show navigation bar
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}


-(BOOL) canEdit
{
    BOOL canEditUntechable;
    if( [untechable isUntechableStarted] || [untechable isUntechableExpired] ){
        canEditUntechable = NO; //starts new
    } else{
        canEditUntechable = YES;
    }
   return canEditUntechable;
}

-(void)setNavigation:(NSString *)callFrom
{
    if([callFrom isEqualToString:@"viewDidLoad"])
    {
        
        self.navigationItem.hidesBackButton = YES;
        
        // Center title
        self.navigationItem.titleView = [untechable.commonFunctions navigationGetTitleView];
        
        // Right Navigation
        NSMutableArray  *rightNavItems;
        
        // Setting left Navigation button "Settings"
        settingsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 86, 42)];
        settingsButton.titleLabel.shadowColor = [UIColor clearColor];
        settingsButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [settingsButton setTitle:NSLocalizedString(TITLE_SETTINGS_TXT, nil) forState:normal];
        [settingsButton setTitleColor:DEF_GRAY forState:UIControlStateNormal];
        
        [settingsButton addTarget:self action:@selector(goToSettings) forControlEvents:UIControlEventTouchUpInside];
        settingsButton.showsTouchWhenHighlighted = YES;
        
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
        
        [self.navigationItem setLeftBarButtonItem:leftBarButton];//Left button ___________
        
        btnNext = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        [btnNext addTarget:self action:@selector(onNext:) forControlEvents:UIControlEventTouchUpInside];
        btnNext.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [btnNext setTitle:NSLocalizedString(TITLE_NEXT_TXT, nil) forState:normal];
        [btnNext setTitleColor:DEF_GRAY forState:UIControlStateNormal];
        btnNext.showsTouchWhenHighlighted = YES;
        
        UIBarButtonItem *btnNextBar = [[UIBarButtonItem alloc] initWithCustomView:btnNext];
        rightNavItems  = [NSMutableArray arrayWithObjects:btnNextBar,nil];
        
        // adds right button to navigation bar
        [self.navigationItem setRightBarButtonItems:rightNavItems];
    }
}


- (IBAction)onClickInviteOthers:(id)sender {
    //Load Invite Screen
    InviteFriendsController *inviteFriendsController = [[InviteFriendsController alloc] initWithNibName:@"InviteFriendsController" bundle:nil];
    [self.navigationController pushViewController:inviteFriendsController animated:YES];
}

- (IBAction)onClickEnjoyLife:(id)sender {
    // Load Home Screen
    UntechablesList *mainViewController = [[UntechablesList alloc] initWithNibName:@"UntechablesList" bundle:nil];
    [self.navigationController pushViewController:mainViewController animated:YES];
}
@end