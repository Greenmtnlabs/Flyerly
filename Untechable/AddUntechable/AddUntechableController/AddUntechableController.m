//
//  AddUntechableController.m
//  Untechable
//
//  Created by Abdul Rauf on 23/sep/2014
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//

#import "AddUntechableController.h"
#import "PhoneSetupController.h"



@interface AddUntechableController (){
    PhoneSetupController *phoneSetup;
}
@end

//Class level vars ___start
    //Navigation buttons
    UILabel *titleLabel;
    UIButton *helpButton;
    UIButton *backButton;
    UIButton *nextButton;
    UIColor *defBlueColor;

    NSString *pickerOpenFor = @"";

//Class level vars ___end

@implementation AddUntechableController


@synthesize btnEndTime,btnStartTime,picker;


#pragma mark -  Default iOs functions
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

    defBlueColor =  [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];
    
    [self setNavigationDefaults];
    
    [self setNavigation:@"viewDidLoad"];
    
    [self setDefaultModel];
    
	self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];    // show short-style date format
    [self.dateFormatter setTimeStyle:NSDateFormatterMediumStyle];

    
    NSDate *now = [NSDate date];
	NSString *date = [self.dateFormatter stringFromDate:now];
    [self.btnStartTime setTitle:date forState:UIControlStateNormal];
    [self.btnEndTime setTitle:date forState:UIControlStateNormal];
    
    self.picker.alpha = 0.0;
    self.picker.datePickerMode = UIDatePickerModeDateAndTime;
    self.picker.minimumDate = now;
    [self.picker setDate:now animated:YES];
    
    pickerOpenFor = @"";

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

}
// ________________________     Custom functions    ___________________________
#pragma mark -  Navigation functions

- (void)setNavigationDefaults{
    //[[self navigationController] setNavigationBarHidden:YES animated:YES]; //hide navigation bar
    [[self navigationController] setNavigationBarHidden:NO animated:YES]; //show navigation bar
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

-(void)setNavigation:(NSString *)callFrom
{
    if([callFrom isEqualToString:@"viewDidLoad"])
    {   /*
       // Left Navigation ________________________________________________________________________________________________________
        backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
        [backButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
         */
        /*
        //[backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        // HERE WE SET BACK BUTTON IMAGE AS REQUIRED
        NSArray * arrayOfControllers =  self.navigationController.viewControllers;
        int idx = [arrayOfControllers count] -2 ;
        id previous = [arrayOfControllers objectAtIndex:idx];
        if ([previous isKindOfClass:[AddUntechableController class]])
        {
            //[backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
        } else {
            //[backButton setBackgroundImage:[UIImage imageNamed:@"home_button"] forState:UIControlStateNormal];
        }
        */
        
        /*
        [backButton setTitle:@"Back" forState:normal];
        
        backButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];

        helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
        //[helpButton addTarget:self action:@selector(loadHelpController) forControlEvents:UIControlEventTouchUpInside];
        //[helpButton setBackgroundImage:[UIImage imageNamed:@"help_icon"] forState:UIControlStateNormal];
        [helpButton setTitle:@"Help" forState:normal];
        helpButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *leftBarHelpButton = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
        NSMutableArray  *leftNavItems  = [NSMutableArray arrayWithObjects:backBarButton,leftBarHelpButton,nil];
        [self.navigationItem setLeftBarButtonItems:leftNavItems]; //Left button ___________
        */
        
        
        
        // Center title ________________________________________________________________________________________________________
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        titleLabel.backgroundColor = [UIColor clearColor];
        //titleLabel.font = [UIFont fontWithName:TITLE_FONT size:18];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = defBlueColor;
        titleLabel.text = @"Untechable";
        
        self.navigationItem.titleView = titleLabel; //Center title ___________
        
        

        // Right Navigation ________________________________________________________________________________________________________
        
        
        nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
        [nextButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
        //[nextButton setBackgroundImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
        [nextButton setTitle:@"Next" forState:normal];
        [nextButton setTitleColor:defBlueColor forState:UIControlStateNormal];

        nextButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton,nil];
        
        [self.navigationItem setRightBarButtonItems:rightNavItems];//Right button ___________
        
        
    }
}

-(void)onNext{
    phoneSetup = [[PhoneSetupController alloc]initWithNibName:@"PhoneSetupController" bundle:nil];
    phoneSetup.untechable = untechable;
    [self.navigationController pushViewController:phoneSetup animated:YES];
}

#pragma mark -  Select Date
//when user tap on dates
-(IBAction)changeDate:(id)sender
{
    self.picker.alpha = 1.0;
    
    UIButton *clickedBtn = sender;
    if( clickedBtn == self.btnStartTime ){
        pickerOpenFor = @"self.btnStartTime";
    }
    else if( clickedBtn == self.btnEndTime ){
        pickerOpenFor = @"self.btnEndTime";
    }
    
}

//when user select the date from datepicker
-(IBAction)onDateChange:(id)sender {
    self.picker.alpha = 0.0;
	NSString * date = [self.dateFormatter stringFromDate:[picker date]];
    untechable.test1 = @"test1dfafs";
    NSLog(@" untechable.test1 == %@",untechable.test1);
    
    NSLog(@"onDateChange: %@",date);
    
	if( [pickerOpenFor isEqualToString:@"self.btnStartTime"] ){
      untechable.startDate = date;
        
      [self.btnStartTime setTitle:date forState:UIControlStateNormal];
        
    }
    else if( [pickerOpenFor isEqualToString:@"self.btnEndTime"] ){
      untechable.endDate = date;
      [self.btnEndTime setTitle:date forState:UIControlStateNormal];
    }
    

}

#pragma mark -  Model funcs

// set default vaules in model
-(void)setDefaultModel{
    NSDate *now = [NSDate date];
	NSString *date = [self.dateFormatter stringFromDate:now];
    
    untechable.startDate = date;
    untechable.endDate = date;
    
    untechable.forwardingNumber = @"";
    untechable.emergencyNumbers = @"";
    untechable.emergencyContacts = [[NSMutableDictionary alloc] init];
}

@end
