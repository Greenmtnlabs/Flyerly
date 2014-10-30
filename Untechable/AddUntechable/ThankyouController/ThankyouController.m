//
//  ThankyouController.m
//  Untechable
//
//  Created by Muhammad Raheel on 28/10/2014.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "ThankyouController.h"
#import "AddUntechableController.h"
#import "Common.h"

@interface ThankyouController ()

@property (strong, nonatomic) IBOutlet UILabel *lblStartsFrom;
@property (strong, nonatomic) IBOutlet UILabel *lblStartDateTime;
@property (strong, nonatomic) IBOutlet UILabel *lblEnd;
@property (strong, nonatomic) IBOutlet UILabel *lblEndDateTime;
@property (strong, nonatomic) IBOutlet UILabel *lblTwillioNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblForwadingNumber;
@property (strong, nonatomic) IBOutlet UIButton *btnNew;
@property (strong, nonatomic) IBOutlet UIButton *btnEdit;

@end

@implementation ThankyouController

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
    
    _btnNew.alpha = 0.0;
    _btnEdit.alpha = 0.0;
    
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


- (IBAction)onNew:(id)sender {
    untechable.startDate  = [untechable.commonFunctions nsDateToTimeStampStr: [[NSDate date] dateByAddingTimeInterval:(60*2)] ]; //current time +2MIN
    untechable.endDate  = [untechable.commonFunctions nsDateToTimeStampStr: [[NSDate date] dateByAddingTimeInterval:(60*120)] ]; //current time +2hr
    
    [self goToAddUntechableScreen];
}

-(void)goToAddUntechableScreen{
    
    untechable.savedOnServer    = NO;
    [untechable setOrSaveVars:SAVE];
    
    AddUntechableController *addUntechableController;
    addUntechableController = [[AddUntechableController alloc]initWithNibName:@"AddUntechableController" bundle:nil];
    [self.navigationController pushViewController:addUntechableController animated:YES];    
    
}

- (IBAction)onEdit:(id)sender {
    [self goToAddUntechableScreen];
}


#pragma mark -  UI functions
-(void)updateUI
{
    if( [untechable isUntechableStarted] || [untechable isUntechableExpired] ){
        _btnNew.alpha = 1.0;
    } else{
       _btnEdit.alpha = 1.0;
    }
    
    [_lblStartsFrom setTextColor:defGray];
    _lblStartsFrom.font = [UIFont fontWithName:APP_FONT size:20];
    
    
    [_lblStartDateTime setTextColor:defGreen];
    _lblStartDateTime.font = [UIFont fontWithName:APP_FONT size:20];
    _lblStartDateTime.text = [untechable.commonFunctions timestampStrToAppDate:untechable.startDate];
    
    
    [_lblEnd setTextColor:defGray];
    _lblEnd.font = [UIFont fontWithName:APP_FONT size:20];
    
    
    [_lblEndDateTime setTextColor:defGreen];
    _lblEndDateTime.font = [UIFont fontWithName:APP_FONT size:20];
    _lblEndDateTime.text = [untechable.commonFunctions timestampStrToAppDate:untechable.endDate];
    
    [_lblForwadingNumber setTextColor:defGray];
    _lblForwadingNumber.font = [UIFont fontWithName:APP_FONT size:20];
    
    
    [_lblTwillioNumber setTextColor:defGreen];
    _lblTwillioNumber.font = [UIFont fontWithName:APP_FONT size:20];
    _lblTwillioNumber.text = untechable.twillioNumber;
    
    
    [_btnNew setTitleColor:defGray forState:UIControlStateNormal];
    _btnNew.titleLabel.font = [UIFont fontWithName:APP_FONT size:20];
    
    [_btnEdit setTitleColor:defGray forState:UIControlStateNormal];
    _btnEdit.titleLabel.font = [UIFont fontWithName:APP_FONT size:20];
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
        
        self.navigationItem.hidesBackButton = YES;
        
        // Center title ________________________________________
        self.navigationItem.titleView = [untechable.commonFunctions navigationGetTitleView];
        
    }
}

@end