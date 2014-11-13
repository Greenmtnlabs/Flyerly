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

@property (strong, nonatomic) IBOutlet UILabel *lblPlay1;
@property (strong, nonatomic) IBOutlet UIButton *playVideoBtn;
@property (strong, nonatomic) IBOutlet UIButton *btnCopy;

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

    untechable.paid = NO;
    
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
    
    [_lblPlay1 setTextColor:defGray];
    _lblPlay1.font = [UIFont fontWithName:APP_FONT size:19];
    
    [_btnCopy setTitleColor:defGray forState:UIControlStateNormal];
    _btnCopy.titleLabel.font = [UIFont fontWithName:APP_FONT size:20];
    
    [[_playVideoBtn layer] setBorderWidth:2.0f];
    [[_playVideoBtn layer] setBorderColor:defGreen.CGColor];

}

#pragma mark -  Navigation functions

- (void)setNavigationDefaults{
    
    defGreen = [UIColor colorWithRed:66.0/255.0 green:247.0/255.0 blue:206.0/255.0 alpha:1.0];//GREEN
    defGray = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1.0];//GRAY
    
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES]; //show navigation bar
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}


-(BOOL) canEdit
{
    BOOL canEditUntechable;
    if( [untechable isUntechableStarted] || [untechable isUntechableExpired] ){
        canEditUntechable = NO;//start's new
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
        
        // Center title ________________________________________
        self.navigationItem.titleView = [untechable.commonFunctions navigationGetTitleView];
        
        
        // Right Navigation ________________________________________

        NSMutableArray  *rightNavItems;
        if( [self canEdit] ) {
            
            editUntechable = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
            [editUntechable addTarget:self action:@selector(onEdit:) forControlEvents:UIControlEventTouchUpInside];
            editUntechable.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_LEFT_SIZE];
            [editUntechable setTitle:@"EDIT" forState:normal];
            [editUntechable setTitleColor:defGray forState:UIControlStateNormal];
            editUntechable.showsTouchWhenHighlighted = YES;
            
            UIBarButtonItem *editUntechableBarBtn = [[UIBarButtonItem alloc] initWithCustomView:editUntechable];
            rightNavItems  = [NSMutableArray arrayWithObjects:editUntechableBarBtn,nil];
            
        }
        else{
            startNewUntechable = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
            [startNewUntechable addTarget:self action:@selector(onNew:) forControlEvents:UIControlEventTouchUpInside];
            startNewUntechable.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
            [startNewUntechable setTitle:@"NEW" forState:normal];
            [startNewUntechable setTitleColor:defGray forState:UIControlStateNormal];
            startNewUntechable.showsTouchWhenHighlighted = YES;
            
            UIBarButtonItem *startNewUntechableBarBtn = [[UIBarButtonItem alloc] initWithCustomView:startNewUntechable];
            rightNavItems  = [NSMutableArray arrayWithObjects:startNewUntechableBarBtn,nil];
        }
        
        
        [self.navigationItem setRightBarButtonItems:rightNavItems];//Right buttons ___________
        
        
        
    }
}

-(IBAction)playVideo:(id)sender{
    /*
    NSString *path = [[NSBundle mainBundle]pathForResource:
                      @"HowToSetForwadingNumber" ofType:@"mov"];
    moviePlayer = [[MPMoviePlayerViewController
                    alloc]initWithContentURL:[NSURL fileURLWithPath:path]];
    //[self presentModalViewController:moviePlayer animated:NO];
    [self presentViewController:moviePlayer animated:YES completion:nil];
    */
}


- (IBAction)copyNumer:(id)sender {
    
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    // This code assumes that you have created the outlet for UITextField as 'textField1'. // Update the below code, if you have given different name
    [pb setString:_lblTwillioNumber.text];
    
}

@end