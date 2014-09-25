//
//  AddUntechableController.m
//  Untechable
//
//  Created by Abdul Rauf on 23/sep/2014
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//

#import "AddUntechableController.h"
#import "PhoneSetupController.h"
#import "Common.h"


@interface AddUntechableController (){
    
}
@end

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
    
    [self.btnStartTime setTitle:untechable.startDate forState:UIControlStateNormal];
    [self.btnEndTime setTitle:untechable.endDate forState:UIControlStateNormal];
    
    self.picker.alpha = 0.0; //default hide picker
    self.picker.datePickerMode = UIDatePickerModeDateAndTime;
    self.picker.minimumDate = now1;
    [self.picker setDate:now1 animated:YES];
    
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
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"EEEE, dd MMMM yyyy HH:mm"];
    
    NSDate *date = [df dateFromString:@"Sep 25, 2014 05:27 PM"];

    NSLog(@"\n\n  DATE: %@ \n\n\n", date);
    
    
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
    BOOL goToNext = NO;
    NSDate *d1 = [untechable stringToDate:DATE_FORMATE_1 dateString:untechable.startDate];
    NSDate *d2 = [untechable stringToDate:DATE_FORMATE_1 dateString:untechable.endDate];
    if( d2 > d1 ) {
        goToNext = YES;
    }
    
    
    NSLog(goToNext ? @"goToNext- YES" : @"goToNext- NO");
    
    if( NO ) {
        PhoneSetupController *phoneSetup;
        phoneSetup = [[PhoneSetupController alloc]initWithNibName:@"PhoneSetupController" bundle:nil];
        phoneSetup.untechable = untechable;
        [self.navigationController pushViewController:phoneSetup animated:YES];
    }
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
	NSString * date = [untechable.dateFormatter stringFromDate:[picker date]];
    
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
    //init object
    untechable  = [[Untechable alloc] init];

    //init object with its default values
    [untechable initObj];
    
    //1-vars for screen1
    now1 = [[NSDate date] dateByAddingTimeInterval:(60*2)]; //current time + 2mint
    now2 = [[NSDate date] dateByAddingTimeInterval:(60*120)]; //current time + 2hr
    
    untechable.startDate = [untechable.dateFormatter stringFromDate:now1];
    untechable.endDate = [untechable.dateFormatter stringFromDate:now2];

    //2-vars for screen2
    untechable.forwardingNumber = @"";
    untechable.emergencyNumbers = @"";
    untechable.emergencyContacts = [[NSMutableDictionary alloc] init];
}

@end
