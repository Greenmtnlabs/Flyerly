//
//  ThankyouController.m
//  Untechable
//
//  Created by Muhammad Raheel on 28/10/2014.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "ThankyouController.h"
#import "Common.h"

@interface ThankyouController ()

@property (strong, nonatomic) IBOutlet UILabel *lblStartsFrom;
@property (strong, nonatomic) IBOutlet UILabel *lblStartDateTime;
@property (strong, nonatomic) IBOutlet UILabel *lblEnd;
@property (strong, nonatomic) IBOutlet UILabel *lblEndDateTime;
@property (strong, nonatomic) IBOutlet UILabel *lblTwillioNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblForwadingNumber;
@property (strong, nonatomic) IBOutlet UIButton *btnEdit;
@property (strong, nonatomic) IBOutlet UIButton *btnNew;

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
    
    
    defGreen = [UIColor colorWithRed:66.0/255.0 green:247.0/255.0 blue:206.0/255.0 alpha:1.0];//GREEN
    defGray = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1.0];//GRAY
    
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
    
}

- (IBAction)onEdit:(id)sender {
    
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
    
    
    [_btnEdit setTitleColor:defGray forState:UIControlStateNormal];
    _btnEdit.titleLabel.font = [UIFont fontWithName:APP_FONT size:20];
    
    [_btnNew setTitleColor:defGray forState:UIControlStateNormal];
    _btnNew.titleLabel.font = [UIFont fontWithName:APP_FONT size:20];
}


@end