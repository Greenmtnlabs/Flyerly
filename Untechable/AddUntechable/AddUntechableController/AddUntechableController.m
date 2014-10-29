//
//  AddUntechableController.m
//  Untechable
//
//  Created by Abdul Rauf on 23/sep/2014
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//

#import "AddUntechableController.h"
#import "PhoneSetupController.h"
#import "ThankyouController.h"
#import "Common.h"
#import "BSKeyboardControls.h"


@interface AddUntechableController (){
    
}


@property (strong, nonatomic) IBOutlet UIButton *btnLblWwud;
@property (strong, nonatomic) IBOutlet UITextField *inputSpendingTimeTxt;

@property (strong, nonatomic) IBOutlet UIButton *btnLblStartTime;
@property (strong, nonatomic) IBOutlet UIButton *btnStartTime;

@property (strong, nonatomic) IBOutlet UIButton *btnLblEndTime;
@property (strong, nonatomic) IBOutlet UIButton *btnEndTime;

@property (strong, nonatomic) IBOutlet UILabel *lblNoEndDate;
@property (strong, nonatomic) IBOutlet UIButton *cbNoEndDate;

@property (strong, nonatomic) IBOutlet UIDatePicker *picker;
@property (strong, nonatomic) IBOutlet UIButton *pickerCloseBtn;



@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

@end

@implementation AddUntechableController


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
    
    [self setDefaultModel];
    
    [self setNavigationDefaults];
    [self setNavigation:@"viewDidLoad"];
    
    [self updateUI];
    
    [self showHideDateTimePicker:NO];
    
    self.picker.datePickerMode = UIDatePickerModeDateAndTime;
    //WHEN any of the date is similer to current date time, the show NOW in date's area
    [self pickerSetAcTo:@"_btnStartTime"];
    [self pickerSetAcTo:@"_btnEndTime"];
    self.picker.minimumDate = now1;
    [self.picker setDate:now1 animated:YES];
    
    
    NSArray *fields = @[ _inputSpendingTimeTxt ];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
    
}

- (void)pickerSetAcTo:(NSString *)callFor
{
    if( [callFor isEqualToString:@"_btnStartTime"] ) {
        pickerOpenFor = @"_btnStartTime";
        [self.picker setDate:[untechable.commonFunctions timestampStrToNsDate:untechable.startDate] animated:YES];
        [self dateChanged];
    }
    else if( [callFor isEqualToString:@"_btnEndTime"] ) {
        pickerOpenFor = @"_btnEndTime";
        [self.picker setDate:[untechable.commonFunctions timestampStrToNsDate:untechable.endDate] animated:YES];
        [self dateChanged];
    }
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
        
        // Center title __________________________________________________
        self.navigationItem.titleView = [untechable.commonFunctions navigationGetTitleView];

        // Right Navigation ______________________________________________
        
        
        nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        //[nextButton setBackgroundColor:[UIColor redColor]];//for testing

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
        [self storeSceenVarsInDic];
        
        PhoneSetupController *phoneSetup;
        phoneSetup = [[PhoneSetupController alloc]initWithNibName:@"PhoneSetupController" bundle:nil];
        phoneSetup.untechable = untechable;
        [self.navigationController pushViewController:phoneSetup animated:YES];
        
        [self hideAllControlls];
    }
}
-(void)storeSceenVarsInDic
{
    untechable.spendingTimeTxt = _inputSpendingTimeTxt.text;
    untechable.hasEndDate = !([_cbNoEndDate isSelected]);
    
    [untechable setOrSaveVars:SAVE];
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
    if( clickedBtn == _btnStartTime ){
        pickerOpenFor = @"_btnStartTime";
        _picker.date = [untechable.commonFunctions timestampStrToNsDate:untechable.startDate];
    }
    else if( clickedBtn == _btnEndTime ){
        pickerOpenFor = @"_btnEndTime";
        _picker.date = [untechable.commonFunctions timestampStrToNsDate:untechable.endDate];
    }
    
}
//when user select the date from datepicker
-(IBAction)onDateChange:(id)sender {
    [self dateChanged];
}

-(void)dateChanged
{
    NSString *dateStr, *pickerTimeStampStr;
    pickerTimeStampStr   = [untechable.commonFunctions nsDateToTimeStampStr:[_picker date]];
	dateStr = [untechable.dateFormatter stringFromDate:[_picker date]];
    //NSLog(@"date str dateStr %@", dateStr); //    "startTime": "Oct 24, 2014 03:04 PM",
    

    NSString *nowDateStr = [untechable.dateFormatter stringFromDate:[NSDate date]];
    if( [nowDateStr isEqualToString:dateStr] ){
        dateStr = @"NOW";
    }
    
    
    //NSLog(@"time stamp dateStr %@", timeStampStr); //1414329211
    //NSLog(@"newDateStr: %@", [untechable.commonFunctions timestampStrToAppDate:dateStr]); // "startTime": "Oct 24, 2014 03:04 PM",
    
    
	if( [pickerOpenFor isEqualToString:@"_btnStartTime"] ){
        untechable.startDate = pickerTimeStampStr;
        [_btnStartTime setTitle:dateStr forState:UIControlStateNormal];
    }
    else if( [pickerOpenFor isEqualToString:@"_btnEndTime"] ){
        untechable.endDate = pickerTimeStampStr;
        
        if( [_cbNoEndDate isSelected] )
        dateStr = @"Never";
        
        [_btnEndTime setTitle:dateStr forState:UIControlStateNormal];
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



#pragma mark -  Model funcs
// set default vaules in model
-(void)setDefaultModel{
    
    //init object
    untechable  = [[Untechable alloc] init];
    untechable.commonFunctions = [[CommonFunctions alloc] init];
    
    //Set Date formate
    untechable.dateFormatter = [[NSDateFormatter alloc] init];
    [untechable.dateFormatter setDateFormat:DATE_FORMATE_1];
    //[untechable.dateFormatter setDateStyle:NSDateFormatterShortStyle];    // show short-style date format
    //[untechable.dateFormatter setTimeStyle:NSDateFormatterMediumStyle];

    //For testing -------- { --
        [self configureTestData];
    //For testing -------- } --
    
    

    BOOL isNew = YES;
    BOOL goToThankyouScreen = NO;
    
    int showThisUntechable = 0;
    
    NSMutableDictionary *sUntechable; //Selected Untechable
    
    if( showThisUntechable > -1 ) {
        sUntechable = [untechable getUntechable: showThisUntechable ];

        //Old Untechable going to edit, set the vars
        if( sUntechable != nil ){
            isNew = NO;
            
            //Settings
            untechable.uniqueId = sUntechable[@"uniqueId"];
            untechable.untechablePath = sUntechable[@"untechablePath"];
        }
    }
    
    //New, set the vars
    if( isNew ){
        
        [untechable initWithDefValues];
        
        //For testing -------- { --
            [self configureTestData];
        //For testing -------- } --
    }
    else{
        if( [untechable isUntechableStarted] && !([untechable isUntechableExpired]) ){
            goToThankyouScreen = YES;
        }
    }
    
    if( goToThankyouScreen ) {
        
        [self goToThankyou];
    }
    else {
        [untechable initUntechableDirectory];
        now1 = [NSDate date]; //current date
    }
}
-(void)goToThankyou{
    ThankyouController *thankyouController;
    thankyouController = [[ThankyouController alloc]initWithNibName:@"ThankyouController" bundle:nil];
    thankyouController.untechable = untechable;
    [self.navigationController pushViewController:thankyouController animated:YES];
}

/*
 Variable we must need in model, for testing we can use these vars
 */
-(void) configureTestData
{
    untechable.userId   = TEST_UID;
    //untechable.eventId = TEST_EID;
    //untechable.twillioNumber = TEST_TWILLIO_NUM;
    //untechable.twillioNumber = @"123";
}

#pragma mark -  UI functions
-(void)updateUI
{
    
    [_btnLblWwud setTitleColor:defGray forState:UIControlStateNormal];
    _btnLblWwud.titleLabel.font = [UIFont fontWithName:APP_FONT size:25];

    _inputSpendingTimeTxt.text = untechable.spendingTimeTxt;
    _inputSpendingTimeTxt.font = [UIFont fontWithName:APP_FONT size:18];
    
    [_btnLblStartTime setTitleColor:defGray forState:UIControlStateNormal];
    _btnLblStartTime.titleLabel.font = [UIFont fontWithName:APP_FONT size:25];
    
    [_btnStartTime setTitleColor:defGreen forState:UIControlStateNormal];
    _btnStartTime.titleLabel.font = [UIFont fontWithName:APP_FONT size:18];
    [_btnStartTime setTitle:[untechable.commonFunctions timestampStrToAppDate:untechable.startDate] forState:UIControlStateNormal];
    
    
    [_btnLblEndTime setTitleColor:defGray forState:UIControlStateNormal];
    _btnLblEndTime.titleLabel.font = [UIFont fontWithName:APP_FONT size:25];
    
    [_btnEndTime setTitleColor:defGreen forState:UIControlStateNormal];
    _btnEndTime.titleLabel.font = [UIFont fontWithName:APP_FONT size:18];
    [_btnEndTime setTitle:[untechable.commonFunctions timestampStrToAppDate:untechable.startDate] forState:UIControlStateNormal];
    
    [_lblNoEndDate setTextColor:defGray];
    _lblNoEndDate.font = [UIFont fontWithName:APP_FONT size:14];

    [_cbNoEndDate setSelected:!(untechable.hasEndDate)];
    
    [_pickerCloseBtn setTitleColor:defGray forState:UIControlStateNormal];
    _pickerCloseBtn.titleLabel.font = [UIFont fontWithName:APP_FONT size:18];
    
}

- (IBAction)noEndDate:(id)sender {
    untechable.hasEndDate = [_cbNoEndDate isSelected];
    [_cbNoEndDate setSelected:!(untechable.hasEndDate)];
    

    [self showHideDateTimePicker:NO];
    //[self showHideDateTimePicker:!([_cbNoEndDate isSelected])];
    
    if( !([_cbNoEndDate isSelected]) ){
        untechable.endDate  = [untechable.commonFunctions nsDateToTimeStampStr: [[NSDate date] dateByAddingTimeInterval:(60*120)] ]; //current time +2hr
    }
    [self pickerSetAcTo:@"_btnEndTime"];
    
    

}

- (IBAction)btnClic:(id)sender {
    if( sender == _btnLblWwud ){
        [_inputSpendingTimeTxt becomeFirstResponder];
    }
}
@end
