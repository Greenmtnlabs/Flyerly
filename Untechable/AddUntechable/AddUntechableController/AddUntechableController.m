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
#import "BSKeyboardControls.h"

@interface AddUntechableController (){
    
}


@property (strong, nonatomic) IBOutlet UILabel *lbl1S1;
@property (strong, nonatomic) IBOutlet UILabel *lbl2S1;
@property (strong, nonatomic) IBOutlet UILabel *lbl3S1;
@property (strong, nonatomic) IBOutlet UILabel *lbl4S1;
@property (strong, nonatomic) IBOutlet UILabel *lbl5S1;


@property (strong, nonatomic) IBOutlet UITextField *inputSpendingTimeTxt;

@property (strong, nonatomic) IBOutlet UILabel *lblStartTime;




@property (strong, nonatomic) IBOutlet UILabel *lblEndTime;

@property (strong, nonatomic) IBOutlet UIButton *cbNoEndDate;

@property (strong, nonatomic) IBOutlet UIButton *pickerCloseBtn;

@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

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
    
    [self showHideDateTimePicker:NO];
    
    self.picker.datePickerMode = UIDatePickerModeDateAndTime;
    self.picker.minimumDate = now1;
    [self.picker setDate:now1 animated:YES];
    
    pickerOpenFor = @"";
    
    NSArray *fields = @[ _inputSpendingTimeTxt ];
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

}
// ________________________     Custom functions    ___________________________
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

#pragma mark - Keyboard Controls Delegate

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    /*
     UIView *view;
     
     if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
     view = field.superview.superview;
     } else {
     view = field.superview.superview.superview;
     }
     
     [self.tableView scrollRectToVisible:view.frame animated:YES];
     */
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [self.view endEditing:YES];
}



#pragma mark -  UI functions
-(void)updateUI
{

    [_cbNoEndDate setSelected:!(untechable.hasEndDate)];
    
    [_lbl1S1 setTextColor:defGray];
    _lbl1S1.font = [UIFont fontWithName:APP_FONT size:14];
    
    [_inputSpendingTimeTxt setTextColor:defGreen];
    _inputSpendingTimeTxt.font = [UIFont fontWithName:APP_FONT size:14];
    
    [_lbl2S1 setTextColor:defGray];
    _lbl2S1.font = [UIFont fontWithName:APP_FONT size:14];
    
    
    
    
    [_lblStartTime setTextColor:defGray];
    _lblStartTime.font = [UIFont fontWithName:APP_FONT size:25];
    
    [self.btnStartTime setTitleColor:defGreen forState:UIControlStateNormal];
    self.btnStartTime.titleLabel.font = [UIFont fontWithName:APP_FONT size:18];
    [self.btnStartTime setTitle:untechable.startDate forState:UIControlStateNormal];
    
    [_lbl3S1 setTextColor:defGray];
    _lbl3S1.font = [UIFont fontWithName:APP_FONT size:14];
    
    
    
    
    
    [_lblEndTime setTextColor:defGray];
    _lblEndTime.font   = [UIFont fontWithName:APP_FONT size:25];
    
    [self.btnEndTime setTitleColor:defGreen forState:UIControlStateNormal];
    self.btnEndTime.titleLabel.font = [UIFont fontWithName:APP_FONT size:18];
    [self.btnEndTime setTitle:untechable.endDate forState:UIControlStateNormal];
    
    [_lbl4S1 setTextColor:defGray];
    _lbl4S1.font = [UIFont fontWithName:APP_FONT size:14];
    
    [_lbl5S1 setTextColor:defGray];
    _lbl5S1.font = [UIFont fontWithName:APP_FONT size:14];
    
    [_pickerCloseBtn setTitleColor:defGray forState:UIControlStateNormal];
    _pickerCloseBtn.titleLabel.font = [UIFont fontWithName:APP_FONT size:18];

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
        
        
        untechable.spendingTimeTxt = _inputSpendingTimeTxt.text;
        
        [self hideAllControlls];
    }
}

-(void) hideAllControlls {
    [self showHideDateTimePicker:NO];
    [_inputSpendingTimeTxt resignFirstResponder];
}


#pragma mark -  Select Date
//when user tap on dates
-(IBAction)changeDate:(id)sender
{
    [self hideAllControlls];
    
    [self showHideDateTimePicker:YES];
    
    UIButton *clickedBtn = sender;
    if( clickedBtn == self.btnStartTime ){
        pickerOpenFor = @"self.btnStartTime";
    }
    else if( clickedBtn == self.btnEndTime ){
        pickerOpenFor = @"self.btnEndTime";
    }
    
}

- (IBAction)closeDateTimePicker:(id)sender {
   [self showHideDateTimePicker:NO];
}

-(void)showHideDateTimePicker:(BOOL)showHide{

    float alpha = (showHide) ? 1.0 : 0.0;
    
    self.picker.alpha = alpha;
    _pickerCloseBtn.alpha = alpha;
    
}

//when user select the date from datepicker
-(IBAction)onDateChange:(id)sender {
    
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
    //Set Date formate
    untechable.dateFormatter = [[NSDateFormatter alloc] init];
    [untechable.dateFormatter setDateFormat:DATE_FORMATE_1];
    //[untechable.dateFormatter setDateStyle:NSDateFormatterShortStyle];    // show short-style date format
    //[untechable.dateFormatter setTimeStyle:NSDateFormatterMediumStyle];

    untechable.userId   = @"1";
    

    BOOL isNew = YES;
    int showThisUntechable = 0;
    
    NSMutableDictionary *sUntechable; //Selected Untechable
    
    if( showThisUntechable > -1 ) {
        sUntechable = [untechable getUntechable: showThisUntechable ];
        
        if( sUntechable != nil ){
            isNew = NO;
        }
    }
    
    if( isNew == NO ){

        //Settings
        untechable.uniqueId = sUntechable[@"uniqueId"];
        untechable.untechablePath = sUntechable[@"untechablePath"];
        
        //-----------------{--
        now1 = [[NSDate date] dateByAddingTimeInterval:(60*2)]; //current time + 2mint
        now2 = [[NSDate date] dateByAddingTimeInterval:(60*120)]; //current time + 2hr
        
        untechable.startDate = [untechable.dateFormatter stringFromDate:now1];
        untechable.endDate   = [untechable.dateFormatter stringFromDate:now2];
        //-----------------}--
        
        [untechable initUntechableDirectory];
    }
    //New
    else {
        
        //Settings
        untechable.uniqueId = [untechable getUniqueId];
        untechable.untechablePath = [untechable getNewUntechablePath];
        
        untechable.hasFbPermission          = NO;
        untechable.hasTwitterPermission     = NO;
        untechable.hasLinkedinPermission    = NO;
        
        
        //1-vars for screen1
        untechable.spendingTimeTxt = @"";
        now1 = [[NSDate date] dateByAddingTimeInterval:(60*2)]; //current time + 2mint
        now2 = [[NSDate date] dateByAddingTimeInterval:(60*120)]; //current time + 2hr
        
        untechable.startDate = [untechable.dateFormatter stringFromDate:now1];
        untechable.endDate   = [untechable.dateFormatter stringFromDate:now2];
        
        untechable.hasEndDate = YES;
        
        //2-vars for screen2
        untechable.forwardingNumber  = @"";
        untechable.emergencyNumbers  = @"";
        untechable.emergencyContacts = [[NSMutableDictionary alloc] init];
        untechable.hasRecording = NO;
        
        [untechable initUntechableDirectory];
        
    }
    
}

- (IBAction)noEndDate:(id)sender {
    untechable.hasEndDate = [_cbNoEndDate isSelected];
    [_cbNoEndDate setSelected:!(untechable.hasEndDate)];
}


@end
