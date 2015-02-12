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
#import "SettingsViewController.h"
#import "ContactsListControllerViewController.h"


@interface AddUntechableController (){
    
    NSArray *_pickerData;
    
}


@property (strong, nonatomic) IBOutlet UIButton *btnLblWwud;
@property (strong, nonatomic) IBOutlet UITextView *inputSpendingTimeText;
@property (strong, nonatomic) IBOutlet UILabel *char_Limit;

@property (strong, nonatomic) IBOutlet UIButton *btnLblStartTime;
@property (strong, nonatomic) IBOutlet UIButton *btnStartTime;

@property (strong, nonatomic) IBOutlet UIButton *btnLblEndTime;
@property (strong, nonatomic) IBOutlet UIButton *btnEndTime;

@property (strong, nonatomic) IBOutlet UILabel *lblNoEndDate;
@property (strong, nonatomic) IBOutlet UIButton *cbNoEndDate;

@property (strong, nonatomic) IBOutlet UIDatePicker *picker;
@property (strong, nonatomic) IBOutlet UIButton *pickerCloseBtn;

@property (strong, nonatomic) IBOutlet UIPickerView *spendingTimeTextPicker;

@property (strong, nonatomic) IBOutlet UIButton *openPickerButton;

@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

@end

@implementation AddUntechableController

@synthesize indexOfUntechableInEditMode,callReset,untechable;

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
    
    [self showHideTextPicker:NO];
    
    // Initialize Data
    _pickerData = @[@"Spending time with family.", @"Driving.", @"Spending time outdoors.", @"At the beach.", @"Enjoying the holidays.", @"Just needed a break.", @"Running.", @"On vacation.", @"Finding my inner peace.", @"Removing myself from technology."];
    
    // Connect data
    _spendingTimeTextPicker.dataSource = self;
    _spendingTimeTextPicker.delegate = self;
    
    self.picker.datePickerMode = UIDatePickerModeDateAndTime;
    //WHEN any of the date is similer to current date time, the show NOW in date's area
    [self pickerSetAcTo:@"_btnStartTime"];
    [self pickerSetAcTo:@"_btnEndTime"];
    self.picker.minimumDate = now1;
    [self.picker setDate:now1 animated:YES];
    
    _inputSpendingTimeText.delegate = self;
   
    
    NSArray *fields = @[ _inputSpendingTimeText ];
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
    if ( [textView.text isEqualToString:@"e.g Spending time with family."] ){
        textView.text = @"";
    }
    if ( textView == _inputSpendingTimeText ){
        if ([textView.text isEqualToString:@"e.g Spending time with family."]) {
            textView.text = @"";
            textView.font = [UIFont fontWithName:TITLE_FONT size:12.0];
            textView.textColor = [UIColor blackColor]; //optional
        }
        [textView becomeFirstResponder];
    }
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
        self.navigationItem.hidesBackButton = YES;
        
        // Center title __________________________________________________
        self.navigationItem.titleView = [untechable.commonFunctions navigationGetTitleView];

        if ( [untechable.commonFunctions getAllUntechables:untechable.userId].count > 0 ) {
            // Back Navigation button
            backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
            backButton.titleLabel.shadowColor = [UIColor clearColor];
            backButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
            [backButton setTitle:TITLE_BACK_TXT forState:normal];
            [backButton setTitleColor:defGray forState:UIControlStateNormal];
            [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchDown];
            [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            backButton.showsTouchWhenHighlighted = YES;
            
            UIBarButtonItem *lefttBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
            
            [self.navigationItem setLeftBarButtonItem:lefttBarButton];//Left button ___________
        }else {
            
            // Setting left Navigation button "Settings"
            settingsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 86, 42)];
            settingsButton.titleLabel.shadowColor = [UIColor clearColor];
            settingsButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
            [settingsButton setTitle:TITLE_SETTINGS_TXT forState:normal];
            [settingsButton setTitleColor:defGray forState:UIControlStateNormal];
            [settingsButton addTarget:self action:@selector(goToSettings) forControlEvents:UIControlEventTouchUpInside];
            settingsButton.showsTouchWhenHighlighted = YES;
            
            UIBarButtonItem *lefttBarButton = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
            
            [self.navigationItem setLeftBarButtonItem:lefttBarButton];//Left button ___________
        }
        
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

-(IBAction)goToSettings{
    
    NSLog(@"Go To settings screen");
    SettingsViewController *settingsController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    settingsController.untechable = untechable;
    [self.navigationController pushViewController:settingsController animated:YES];
}

-(void) goBack {
    [self.navigationController popViewControllerAnimated:YES];
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
    
    if ( ![_inputSpendingTimeText.text isEqualToString:@"e.g Spending time with family."] ){
        [self storeSceenVarsInDic];
        
        [self hideAllControlls];
        
        BOOL goToNext = untechable.hasEndDate ? NO : YES;
        
        //When we have end date, must check end date is greater then start date
        if( untechable.hasEndDate == YES )
        {
            NSDate *d1 = [untechable.commonFunctions timestampStrToNsDate:untechable.startDate];
            NSDate *d2 = [untechable.commonFunctions timestampStrToNsDate:untechable.endDate];
            
            
            goToNext = [untechable.commonFunctions date1IsSmallerThenDate2:d1 date2:d2];
            
            if( goToNext == NO ) {
                
                [untechable.commonFunctions showAlert:@"Invalid Dates" message:@"End date should be greater then start date."];
            }
            
        }
        
        NSLog(goToNext ? @"goToNext- YES" : @"goToNext- NO");
        
        
        if( goToNext ) {
            
            ContactsListControllerViewController *listController = [[ContactsListControllerViewController alloc] initWithNibName:@"ContactsListControllerViewController" bundle:nil];
            listController.untechable = untechable;
            [self.navigationController pushViewController:listController animated:YES];
            
            /*PhoneSetupController *phoneSetup;
             phoneSetup = [[PhoneSetupController alloc]initWithNibName:@"PhoneSetupController" bundle:nil];
             phoneSetup.untechable = untechable;
             [self.navigationController pushViewController:phoneSetup animated:YES];*/
        }
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Why getting Untechable?"
                                                        message:@"You must need to specify why are you getting Untechable..."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
-(void)storeSceenVarsInDic
{
    untechable.spendingTimeTxt = _inputSpendingTimeText.text;
    untechable.hasEndDate = !([_cbNoEndDate isSelected]);
    
    [untechable setOrSaveVars:SAVE];
}

-(void) hideAllControlls {
    [self showHideDateTimePicker:NO];
    [self showHideTextPicker:NO];
    [_inputSpendingTimeText resignFirstResponder];
}

#pragma mark- Select text
//when user tapes on select text
-(IBAction)selectText:(id)sender{
    
    [self hideAllControlls];
    
    [self showHideTextPicker:YES];
}

#pragma mark -  Select Date
//when user tap on dates
-(IBAction)changeDate:(id)sender
{
    [self hideAllControlls];
    
    [self showHideDateTimePicker:YES];
    
    UIButton *clickedBtn = sender;
    if( clickedBtn == _btnStartTime || clickedBtn == _btnLblStartTime ){
        pickerOpenFor = @"_btnStartTime";
        _picker.date = [untechable.commonFunctions timestampStrToNsDate:untechable.startDate];
    }
    else if( clickedBtn == _btnEndTime || clickedBtn == _btnLblEndTime ){
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
        
        NSDate *endD = [untechable.commonFunctions timestampStrToNsDate:untechable.endDate];
        NSDate *statD = [untechable.commonFunctions timestampStrToNsDate:untechable.startDate];

        
        if( [untechable.commonFunctions date1IsSmallerThenDate2:endD date2:statD] ){
            endD = [statD dateByAddingTimeInterval:(60*120)];
            untechable.endDate = [untechable.commonFunctions nsDateToTimeStampStr:endD]; //current time +2hr
            NSString *dateStrUpdated = [untechable.dateFormatter stringFromDate:endD];
            [_btnEndTime setTitle:dateStrUpdated forState:UIControlStateNormal];
        }
        
        
        
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
    [self showHideTextPicker:NO];
}

-(void)showHideTextPicker:(BOOL)showHide{
    
    if ( IS_IPHONE_4 || IS_IPHONE_5 ){
        [_pickerCloseBtn setFrame:CGRectMake(245, 160, 76, 33)];
    }else if ( IS_IPHONE_6 ){
        [_pickerCloseBtn setFrame:CGRectMake(290, 170, 76, 33)];
    }else if (IS_IPHONE_6_PLUS){
        [_pickerCloseBtn setFrame:CGRectMake(330, 170, 76, 33)];
    }
    
    float alpha = (showHide) ? 1.0 : 0.0;
    
    _spendingTimeTextPicker.alpha = alpha;
    _pickerCloseBtn.alpha = alpha;
}


-(void)showHideDateTimePicker:(BOOL)showHide{

    if ( IS_IPHONE_4 || IS_IPHONE_5 ){
        [_pickerCloseBtn setFrame:CGRectMake(245, 382, 76, 33)];
    }else if ( IS_IPHONE_6 ){
        [_pickerCloseBtn setFrame:CGRectMake(300, 382, 76, 33)];
    }else if (IS_IPHONE_6_PLUS){
        [_pickerCloseBtn setFrame:CGRectMake(330, 382, 76, 33)];
    }
    
    float alpha = (showHide) ? 1.0 : 0.0;
    
    self.picker.alpha = alpha;
    _pickerCloseBtn.alpha = alpha;
    
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

#pragma mark -  Model funcs
// set default vaules in model
-(void)setDefaultModel{

    now1 = [NSDate date]; //current date
    
    //init object
    untechable  = [[Untechable alloc] init];
    untechable.commonFunctions = [[CommonFunctions alloc] init];

    //Set Date formate
    untechable.dateFormatter = [[NSDateFormatter alloc] init];
    [untechable.dateFormatter setDateFormat:DATE_FORMATE_1];
    
    //For testing -------- { --
        [self configureTestData];
    //For testing -------- } --
    
    BOOL isNew = YES;
    
    NSMutableDictionary *sUntechable = nil;
    
    //When we are going to edit event
    if ( indexOfUntechableInEditMode > -1 ){ //&& [untechable.commonFunctions getAllUntechables:untechable.userId].count > 0){
        sUntechable = [untechable.commonFunctions getUntechable:indexOfUntechableInEditMode UserId:untechable.userId];
        if( sUntechable != nil ){
            isNew = NO;
        }
    }
    
    //Check is there any incomplete untechable exist ?
    if( isNew == YES ){
        sUntechable = [untechable.commonFunctions getAnyInCompleteUntechable:untechable.userId];
        
        if( sUntechable != nil ){
            isNew = NO;
            callReset = @"RESET1";
        }
    }
    
    
    //Old Untechable going to edit, set the vars
    if( sUntechable != nil ){
        //Settings required for calling initUntechableDirectory
        untechable.uniqueId = sUntechable[@"uniqueId"];
        untechable.untechablePath = sUntechable[@"untechablePath"];
        [untechable initUntechableDirectory];
    }
    else if( isNew ) {
        [untechable initWithDefValues];
        [untechable initUntechableDirectory];
        callReset = @"";
    }
    
    
    if( ![callReset isEqualToString:@""] ){
        [self resetUntechable:callReset];
    }
    
}

-(void)resetUntechable:(NSString *)callResetFor{

    if( [callResetFor isEqualToString:@"RESET_DEFAULTS"] ){
        [untechable initWithDefValues];
    }
    else if( [callResetFor isEqualToString:@"RESET1"] ){
        //untechable.hasFinished = NO;
        untechable.savedOnServer = NO;
        //untechable.twillioNumber = @"";
        untechable.paid = NO;
        
        [untechable setOrSaveVars:SAVE];
    }
}

-(void)goToThankyou{
    ThankyouController *thankyouController;
    thankyouController = [[ThankyouController alloc]initWithNibName:@"ThankyouController" bundle:nil];
    thankyouController.untechable = untechable;
    [self.navigationController pushViewController:thankyouController animated:YES];
}

#pragma mark -  UI functions
-(void)updateUI
{
    
    [_btnLblWwud setTitleColor:defGray forState:UIControlStateNormal];
    _btnLblWwud.titleLabel.font = [UIFont fontWithName:APP_FONT size:25];

    _inputSpendingTimeText.text = untechable.spendingTimeTxt;
    if ( [untechable.spendingTimeTxt isEqualToString:@""] ){
        _inputSpendingTimeText.text = @"e.g Spending time with family.";
    }
    _inputSpendingTimeText.font = [UIFont fontWithName:APP_FONT size:18];
    
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
        [_inputSpendingTimeText becomeFirstResponder];
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    int len = (int)textView.text.length;
    _char_Limit.text=[NSString stringWithFormat:@"%i",124-len];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text length] == 0)
    {
        if([textView.text length] != 0)
        {
            return YES;
        }
    }
    else if([[textView text] length] > 139)
    {
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"e.g Spending time with family.";
    }
    [textView resignFirstResponder];
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    _inputSpendingTimeText.text = [_pickerData objectAtIndex:row];
    
    int len = (int)_inputSpendingTimeText.text.length;
    _char_Limit.text=[NSString stringWithFormat:@"%i",124-len];
}
/*
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textView.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    return (newLength > 140) ? NO : YES;
}
*/

- (IBAction)openPicker:(id)sender {
    
    [self.view addSubview:_spendingTimeTextPicker];
}
@end
