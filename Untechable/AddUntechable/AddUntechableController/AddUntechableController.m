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

@property (strong, nonatomic) IBOutlet UILabel *lblStartTime;

@property (strong, nonatomic) IBOutlet UILabel *lblEndTime;

@end

@implementation AddUntechableController


@synthesize btnEndTime,btnStartTime,picker;


#pragma mark -  Default functions
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

    [self setDefaultModel];
    
    [self updateUI];
    
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
    [untechable printNavigation:[self navigationController]];

}
// ________________________     Custom functions    ___________________________
#pragma mark -  UI functions
-(void)updateUI
{
    
    _lblStartTime.font = [UIFont fontWithName:APP_FONT size:30];
    _lblEndTime.font   = [UIFont fontWithName:APP_FONT size:30];
    
    self.btnStartTime.titleLabel.font = [UIFont fontWithName:APP_FONT size:20];
    [self.btnStartTime setTitle:untechable.startDate forState:UIControlStateNormal];
    
    self.btnEndTime.titleLabel.font = [UIFont fontWithName:APP_FONT size:20];
    [self.btnEndTime setTitle:untechable.endDate forState:UIControlStateNormal];
}

#pragma mark -  Navigation functions
- (void)setNavigationDefaults{

    /*
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"EEEE, dd MMMM yyyy HH:mm"];
    NSDate *date = [df dateFromString:@"Sep 25, 2014 05:27 PM"];
    NSLog(@"\n\n  DATE: %@ \n\n\n", date);
    */

    defGreen = [UIColor colorWithRed:66.0/255.0 green:247.0/255.0 blue:206.0/255.0 alpha:1.0];//GREEN
    defGray = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1.0];//GRAY
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES]; //show navigation bar
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

-(void)setNavigation:(NSString *)callFrom
{
    if([callFrom isEqualToString:@"viewDidLoad"])
    {
        
        // Center title ________________________________________________________________________________________________________
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_FONT_SIZE];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = defGreen;
        titleLabel.text = APP_NAME;
        
        self.navigationItem.titleView = titleLabel; //Center title ___________        
        

        // Right Navigation ________________________________________________________________________________________________________
        
        
        nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];

        nextButton.titleLabel.shadowColor = [UIColor clearColor];
        //nextButton.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
        
        [nextButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
        //[nextButton setBackgroundImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
        nextButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [nextButton setTitle:TITLE_NEXT_TXT forState:normal];
        [nextButton setTitleColor:defGray forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(btnNextTouchStart) forControlEvents:UIControlEventTouchDown];
        [nextButton addTarget:self action:@selector(btnNextTouchEnd) forControlEvents:UIControlEventTouchUpInside];
        

        nextButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton,nil];
        
        [self.navigationItem setRightBarButtonItems:rightNavItems];//Right button ___________
        
        
    }
}
-(void)btnNextTouchStart{
    [self setNextHighlighted:YES];
}
-(void)btnNextTouchEnd{
    [self setNextHighlighted:NO];
}
- (void)setNextHighlighted:(BOOL)highlighted {
    (highlighted) ? [nextButton setBackgroundColor:defGreen] : [nextButton setBackgroundColor:[UIColor clearColor]];
}


-(void)onNext{
    /* WILL WORK FOR IT
    BOOL goToNext = NO;
    NSDate *d1 = [untechable stringToDate:DATE_FORMATE_1 dateString:untechable.startDate];
    NSDate *d2 = [untechable stringToDate:DATE_FORMATE_1 dateString:untechable.endDate];
    if( d2 > d1 ) {
        goToNext = YES;
    }
    
    
    NSLog(goToNext ? @"goToNext- YES" : @"goToNext- NO");
    */
    
    if( YES ) {
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
