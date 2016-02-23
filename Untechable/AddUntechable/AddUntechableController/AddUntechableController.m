//
//  AddUntechableController.m
//  Untechable
//
//  Created by RIKSOF Developer on 23/sep/2014
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//

#import "AddUntechableController.h"
#import "Common.h"
#import "BSKeyboardControls.h"
#import "SettingsViewController.h"
#import "ContactsListControllerViewController.h"
#import "UntechablesList.h"

@interface AddUntechableController (){
    
    NSMutableArray *_pickerData;
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

@synthesize totalUntechables,callReset,untechable,openPickerButton;
@synthesize lblQoute;


#pragma mark -  Default functions
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self setDefaultModel];
    
    [self setNavigationDefaults];
    
    [self showHideDateTimePicker:NO];
    
    // initializes array
    _pickerData = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"cutomSpendingTimeTextAry"]];

    [self showHideTextPicker:NO];
    
    // Connect data
    _spendingTimeTextPicker.dataSource = self;
    _spendingTimeTextPicker.delegate = self;
    
    self.picker.datePickerMode = UIDatePickerModeDateAndTime;
    // If the date is similer to current date time, then show NOW in date's area
    self.picker.minimumDate = now1;
    [self.picker setDate:now1 animated:YES];
    
    _inputSpendingTimeText.delegate = self;
   
    NSArray *fields = @[ _inputSpendingTimeText ];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
    
    [self updateUI];
    
}

- (void)pickerSetAcTo:(NSString *)callFor
{
    if( [callFor isEqualToString:@"_btnStartTime"] ) {
        pickerOpenFor = @"_btnStartTime";
        [self.picker setDate:[NSDate date] animated:YES];
        [self dateChanged];
    }
    else if( [callFor isEqualToString:@"_btnEndTime"] ) {
        pickerOpenFor = @"_btnEndTime";
        [self.picker setDate:[untechable.commonFunctions convertTimestampToNSDate:untechable.endDate] animated:YES];
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
    [self setNavigation:@"viewDidLoad"];
}
/**
 * before appearing view
 * we need to set some UI fields
 */
-(void)viewWillAppear:(BOOL)animated {
    [self setNavigation:@"viewDidLoad"];
    [self hideAllControlls];
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
    if ( [textView.text isEqualToString:NSLocalizedString(@"e.g. Spending time with family", nil)] ){
        textView.text = @"";
    }
    if ( textView == _inputSpendingTimeText ){
        if ([textView.text isEqualToString:NSLocalizedString(@"e.g. Spending time with family", nil)]) {
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
    }

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [self.view endEditing:YES];
}

#pragma mark -  Navigation functions
- (void)setNavigationDefaults{
    
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

        // Back Navigation button
        backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        backButton.titleLabel.shadowColor = [UIColor clearColor];
        backButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [backButton setTitle:TITLE_BACK_TXT forState:normal];
        [backButton setTitleColor:DEF_GRAY forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchDown];
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        backButton.showsTouchWhenHighlighted = YES;
        
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [self.navigationItem setLeftBarButtonItem:leftBarButton];//Left button ___________
        
        // Right Navigation ______________________________________________
        nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        nextButton.titleLabel.shadowColor = [UIColor clearColor];
        [nextButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
        nextButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [nextButton setTitle:NSLocalizedString(TITLE_NEXT_TXT, nil) forState:normal];
        [nextButton setTitleColor:DEF_GRAY forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(btnNextTouchStart) forControlEvents:UIControlEventTouchDown];
        [nextButton addTarget:self action:@selector(btnNextTouchEnd) forControlEvents:UIControlEventTouchUpInside];

        nextButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton,nil];
        
        [self.navigationItem setRightBarButtonItems:rightNavItems];//Right button ___________
    }
}


-(void) goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -  Highlighting Functions

-(void)btnSettingsTouchStart{
    [self setSettingsHighlighted:YES];
}
-(void)btnSettingsTouchEnd{
    [self setSettingsHighlighted:NO];
}
- (void)setSettingsHighlighted:(BOOL)highlighted {
    (highlighted) ? [settingsButton setBackgroundColor:DEF_GREEN] : [settingsButton setBackgroundColor:[UIColor clearColor]];
}

-(void)btnNextTouchStart{
    [self setNextHighlighted:YES];
}
-(void)btnNextTouchEnd{
    [self setNextHighlighted:NO];
}
- (void)setNextHighlighted:(BOOL)highlighted {
    (highlighted) ? [nextButton setBackgroundColor:DEF_GREEN] : [nextButton setBackgroundColor:[UIColor clearColor]];
}


-(void)onNext{
    
    if ( ![_inputSpendingTimeText.text isEqualToString:NSLocalizedString(@"e.g. Spending time with family", nil)] ){
        [self storeScreenVarsInDic];
        
        [self hideAllControlls];
        
        BOOL goToNext = untechable.hasEndDate ? NO : YES;
        
        if( untechable.hasEndDate == YES )
        {
            NSDate *startDate = [untechable.commonFunctions convertTimestampToNSDate:untechable.startDate];
            NSDate *endDate = [untechable.commonFunctions convertTimestampToNSDate:untechable.endDate];
            
            goToNext = [untechable.commonFunctions isEndDateGreaterThanStartDate:startDate endDate:endDate];
            
            if( goToNext == NO ) {
                
                [untechable.commonFunctions showAlert:NSLocalizedString(@"Invalid Dates", nil) message:NSLocalizedString(@"End date should be greater than start date.", nil)];
            }
        }
        
        if( goToNext ) {
            NSString *getDaysOrHours = [untechable calculateHoursDays:untechable.startDate  endTime: untechable.endDate];
            untechable.socialStatus = [NSString stringWithFormat:NSLocalizedString(@"#untechable for %@ %@ - Reconnect with life: http://www.unte.ch", nil), getDaysOrHours,untechable.spendingTimeTxt];
            ContactsListControllerViewController *listController = [[ContactsListControllerViewController alloc] initWithNibName:@"ContactsListControllerViewController" bundle:nil];
            listController.untechable = untechable;
            [self.navigationController pushViewController:listController animated:YES];
        }
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"What are you going Untech for?", nil)
                                                        message:NSLocalizedString(@"You must specify what you'll be doing with your time away from technology before proceeding.", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(OK, nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)storeScreenVarsInDic {
    untechable.spendingTimeTxt = _inputSpendingTimeText.text;
    untechable.hasEndDate = !([_cbNoEndDate isSelected]);
}

-(void) hideAllControlls {
    [self showHideDateTimePicker:NO];
    [self showHideTextPicker:NO];
    [_inputSpendingTimeText resignFirstResponder];
}

#pragma mark- Select text
//when user taps on select text
-(IBAction)selectText:(id)sender{
    
    [self hideAllControlls];
    
    [self showHideTextPicker:YES];
}

#pragma mark -  Select Date
//when user taps on datepicker
-(IBAction)changeDate:(id)sender
{
    [self hideAllControlls];
    
    [self showHideDateTimePicker:YES];
    
    UIButton *clickedBtn = sender;
    if( clickedBtn == _btnStartTime || clickedBtn == _btnLblStartTime ){
        pickerOpenFor = @"_btnStartTime";
        _picker.date = [untechable.commonFunctions convertTimestampToNSDate:untechable.startDate];
    }
    else if( clickedBtn == _btnEndTime || clickedBtn == _btnLblEndTime ){
        pickerOpenFor = @"_btnEndTime";
        _picker.date = [untechable.commonFunctions convertTimestampToNSDate:untechable.endDate];
    }
    
}
//when user selects the date from datepicker
-(IBAction)onDateChange:(id)sender {
    [self dateChanged];
}

-(void)dateChanged
{
    NSString *dateStr, *pickerTimeStampStr;
    pickerTimeStampStr   = [untechable.commonFunctions convertNSDateToTimestamp:[_picker date]];
	dateStr = [untechable.dateFormatter stringFromDate:[_picker date]];

    NSString *nowDateStr = [untechable.dateFormatter stringFromDate:[NSDate date]];
    if( [nowDateStr isEqualToString:dateStr] ){
        dateStr = NSLocalizedString(@"NOW", nil);
    }
    
	if( [pickerOpenFor isEqualToString:@"_btnStartTime"] ){
        untechable.startDate = pickerTimeStampStr;
        [_btnStartTime setTitle:dateStr forState:UIControlStateNormal];
        
        NSDate *endD = [untechable.commonFunctions convertTimestampToNSDate:untechable.endDate];
        NSDate *startD = [untechable.commonFunctions convertTimestampToNSDate:untechable.startDate];
    
        if( [untechable.commonFunctions isEndDateGreaterThanStartDate:endD endDate: startD] ){
            endD = [startD dateByAddingTimeInterval:(60*60*24)];
            untechable.endDate = [untechable.commonFunctions convertNSDateToTimestamp:endD]; //current time +1 day
            NSString *dateStrUpdated = [untechable.dateFormatter stringFromDate:endD];
            [_btnEndTime setTitle:dateStrUpdated forState:UIControlStateNormal];
        }
    }
    else if( [pickerOpenFor isEqualToString:@"_btnEndTime"] ){
        untechable.endDate = pickerTimeStampStr;
        
        if( [_cbNoEndDate isSelected] )
        dateStr =NSLocalizedString(@"Never", nil);
        
        [_btnEndTime setTitle:dateStr forState:UIControlStateNormal];
    }
}


- (IBAction)closeDateTimePicker:(id)sender {
   [self showHideDateTimePicker:NO];
    [self showHideTextPicker:NO];
}

-(void)showHideTextPicker:(BOOL)showHide{
    
    // set the selected default message or custom message in picker view
    
    NSInteger positionToShow = 0;
    for (int i = 0; i<_pickerData.count; i++) {
        if([_pickerData[i] isEqualToString:untechable.spendingTimeTxt] ){
            positionToShow = i;
            break;
        }
    }
    [self.spendingTimeTextPicker selectRow:positionToShow inComponent:0 animated:NO];

    if ( IS_IPHONE_4 ){
        [_pickerCloseBtn setFrame:CGRectMake(-2, 300, 580, 30)];
        [_spendingTimeTextPicker setFrame:CGRectMake(0, 300, 0, 140)];
    }else if( IS_IPHONE_5 ){
        [_pickerCloseBtn setFrame:CGRectMake(-10, 340, 580, 35)];
        [_spendingTimeTextPicker setFrame:CGRectMake(0, 375, 0, 240)];
    }else if ( IS_IPHONE_6 ){
        [_pickerCloseBtn setFrame:CGRectMake(0, 400, 650, 40)];
        [_spendingTimeTextPicker setFrame:CGRectMake(0, 440, 0, 260)];
    }else if (IS_IPHONE_6_PLUS){
        [_pickerCloseBtn setFrame:CGRectMake(0, 500, 750, 50)];
        [_spendingTimeTextPicker setFrame:CGRectMake(0, 540, 0, 500)];
    }
    
    float alpha = (showHide) ? 1.0 : 0.0;
    
    _uiViewLayer.alpha = alpha;
    _spendingTimeTextPicker.alpha = alpha;
    _pickerCloseBtn.alpha = alpha;
    [self addUpperBorder];
    self.pickerCloseBtn.backgroundColor = [self colorFromHexString:@"#f1f1f1"];
    
    //changes the "CLOSE" button text color to black
    [_pickerCloseBtn setTitleColor:[self colorFromHexString:@"#000000"] forState:UIControlStateNormal];
   
}


-(void)showHideDateTimePicker:(BOOL)showHide{

    if ( IS_IPHONE_4 ){
        [_pickerCloseBtn setFrame:CGRectMake(-2, 300, 580, 30)];
        [_picker setFrame:CGRectMake(0, 310, 0, 140)];
    }else if( IS_IPHONE_5 ){
        [_pickerCloseBtn setFrame:CGRectMake(-10, 340, 580, 35)];
        [_picker setFrame:CGRectMake(0, 360, 0, 260)];
    }else if ( IS_IPHONE_6 ){
        [_pickerCloseBtn setFrame:CGRectMake(0, 430, 650, 40)];
        [_picker setFrame:CGRectMake(0, 440, 0, 260)];
    }else if (IS_IPHONE_6_PLUS){
        [_pickerCloseBtn setFrame:CGRectMake(0, 500, 750, 45)];
        [_picker setFrame:CGRectMake(0, 510, 0, 500)];
    }
    
    lblQoute.hidden = showHide;
    float alpha = (showHide) ? 1.0 : 0.0;
    [self addUpperBorder];
    _picker.alpha = alpha;
    _pickerCloseBtn.alpha = alpha;
    _uiViewLayer.alpha = alpha;
    self.pickerCloseBtn.backgroundColor = [self colorFromHexString:@"#f1f1f1"];
  
    // changing the "CLOSE" button text color to black
    [_pickerCloseBtn setTitleColor:[self colorFromHexString:@"#000000"] forState:UIControlStateNormal];
}

/**
 * Hex Color Converter
 * @params: NSString
 * returns: UIColor
 */
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

#pragma mark -  Model functions
// set default vaules in model
-(void)setDefaultModel{

    now1 = [NSDate date]; // current date
    
    //Set Date format
    untechable.dateFormatter = [[NSDateFormatter alloc] init];
    [untechable.dateFormatter setDateFormat:DATE_FORMATE_1];
    
}
#pragma mark -  UI functions
-(void)updateUI{
    
    [_btnLblWwud setTitle:NSLocalizedString(@"This is what I will be doing when I untech...", nil) forState:normal];
    [_btnLblWwud setTitleColor:DEF_GRAY forState:UIControlStateNormal];
 
    _inputSpendingTimeText.text = untechable.spendingTimeTxt;
    if ( [untechable.spendingTimeTxt isEqualToString:@""] ){
        _inputSpendingTimeText.text = NSLocalizedString(@"e.g. Spending time with family", nil);
    } else{
        _inputSpendingTimeText.text = untechable.spendingTimeTxt;
    }
    _inputSpendingTimeText.font = [UIFont fontWithName:APP_FONT size:18];
    
    [_btnLblStartTime setTitle:NSLocalizedString(@"Start (when will you begin your untech time?)", nil) forState:normal];
    [_btnLblStartTime setTitleColor:DEF_GRAY forState:UIControlStateNormal];
    
    [_btnStartTime setTitleColor:DEF_GREEN forState:UIControlStateNormal];
    _btnStartTime.titleLabel.font = [UIFont fontWithName:APP_FONT size:18];
    [_btnStartTime setTitle:[untechable.commonFunctions convertTimestampToAppDate:untechable.startDate] forState:UIControlStateNormal];
    
    [_btnLblEndTime setTitle:NSLocalizedString(@"End (this is when you come crawling back to technology)", nil) forState:normal];
    [_btnLblEndTime setTitleColor:DEF_GRAY forState:UIControlStateNormal];
    
    [_btnEndTime setTitleColor:DEF_GREEN forState:UIControlStateNormal];
    _btnEndTime.titleLabel.font = [UIFont fontWithName:APP_FONT size:18];
    [_btnEndTime setTitle:[untechable.commonFunctions convertTimestampToAppDate:untechable.endDate] forState:UIControlStateNormal];
    
    [_lblNoEndDate setText:NSLocalizedString(@"No End Date",nil)];
    [_lblNoEndDate setTextColor:DEF_GRAY];
    _lblNoEndDate.font = [UIFont fontWithName:APP_FONT size:14];

    [_cbNoEndDate setSelected:!(untechable.hasEndDate)];
    
    [_pickerCloseBtn setTitle:NSLocalizedString(@"DONE", nil) forState:normal];
    [_pickerCloseBtn setTitleColor:DEF_GRAY forState:UIControlStateNormal];
    _pickerCloseBtn.titleLabel.font = [UIFont fontWithName:APP_FONT size:18];
    
    [self setDefaultTimeDuration];
    
}

/*
 * This method sets default time duration (24 hr)
 * @params:
 *      void
 * @return:
 *      void
 */
-(void) setDefaultTimeDuration{
    
    NSDate *startD = [untechable.commonFunctions convertTimestampToNSDate:untechable.startDate];
    NSDate *endD = [untechable.commonFunctions convertTimestampToNSDate:untechable.endDate];
    
    if( [untechable.commonFunctions isEndDateGreaterThanStartDate:endD endDate: startD] ){
        startD = [startD dateByAddingTimeInterval:(0)];
        endD = [startD dateByAddingTimeInterval:(60*60*24)];
        
        untechable.startDate = [untechable.commonFunctions convertNSDateToTimestamp:startD]; //current time
        untechable.endDate = [untechable.commonFunctions convertNSDateToTimestamp:endD]; //current time +1 day
        
        NSString *startDateTime = [untechable.dateFormatter stringFromDate:startD];
        NSString *endDateTime = [untechable.dateFormatter stringFromDate:endD];
        
        [_btnStartTime setTitle:startDateTime forState:UIControlStateNormal];
        [_btnEndTime setTitle:endDateTime forState:UIControlStateNormal];
    }


}

- (IBAction)noEndDate:(id)sender {
    untechable.hasEndDate = [_cbNoEndDate isSelected];
    [_cbNoEndDate setSelected:!(untechable.hasEndDate)];
    
    [self showHideDateTimePicker:NO];
    
    if( !([_cbNoEndDate isSelected]) ){
        untechable.endDate  = [untechable.commonFunctions convertNSDateToTimestamp: [[NSDate date] dateByAddingTimeInterval:(60*60*24)] ]; //current time + 1 Day
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
        textView.text = NSLocalizedString(@"e.g. Spending time with family", nil);
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

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
    lbl.text = [_pickerData objectAtIndex:row];
    lbl.adjustsFontSizeToFitWidth = YES;
    lbl.textAlignment= NSTextAlignmentCenter;
    
    //change the text size of pickers array accordingly
    if( IS_IPHONE_4 ){
        lbl.font=[UIFont systemFontOfSize:19];
    } if( IS_IPHONE_5 ){
        lbl.font=[UIFont systemFontOfSize:20];
    } if( IS_IPHONE_6 ){
        lbl.font=[UIFont systemFontOfSize:23];
    } if( IS_IPHONE_6_PLUS ){
        lbl.font=[UIFont systemFontOfSize:24];
    }
    return lbl;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    _pickerData = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"cutomSpendingTimeTextAry"]];
    
    if( [[_pickerData objectAtIndex:row] isEqualToString:[_pickerData objectAtIndex:_pickerData.count-1]] ){
        [self showAddFieldPopUp];
    } else  {
        untechable.spendingTimeTxt = [_pickerData objectAtIndex:row];
    }
    
    _inputSpendingTimeText.text = [_pickerData objectAtIndex:row];
    
    int len = (int)_inputSpendingTimeText.text.length;
    _char_Limit.text=[NSString stringWithFormat:@"%i",124-len];

}

/**
 Showing a prompt where user can add their custom messages.
 **/
-(void) showAddFieldPopUp {
    
    UIAlertView *customMsg = [ [UIAlertView alloc] initWithTitle:NSLocalizedString(@"Add Your Own Custom Untech Message", nil)
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                               otherButtonTitles:NSLocalizedString(@"Add", nil), nil];
    
    [customMsg setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [customMsg textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeSentences;
    [customMsg show];
}

#pragma - mark UIAlert View Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    // we will add new message at the second last index
    int position = ( int )[_pickerData count] - 1;
    
    //if cancel was not pressed
    if( buttonIndex != 0 ){
        
        // getting the newly added text from the field
        NSString *newMsg = [[alertView textFieldAtIndex:0] text];
        
        // adding the new msg at the second last index of the picker
        [_pickerData insertObject:newMsg atIndex:position];
        
        // inserting values in data source of picker view.
        [[NSUserDefaults standardUserDefaults] setObject:_pickerData forKey:@"cutomSpendingTimeTextAry"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // save new Custom message to model
        untechable.spendingTimeTxt = [_pickerData objectAtIndex:position];
        
        // reloading the new picker view with custom messages
        [_spendingTimeTextPicker reloadAllComponents];
        
        _inputSpendingTimeText.text = [_pickerData objectAtIndex:position];
        
        int len = (int)_inputSpendingTimeText.text.length;
        _char_Limit.text=[NSString stringWithFormat:@"%i",124-len];
        
    }
}


/**
 * Adding a top border for a view
 */
- (void)addUpperBorder
{
    CALayer *upperBorder = [CALayer layer];
    upperBorder.backgroundColor = [[UIColor lightGrayColor] CGColor];
    upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(_pickerCloseBtn.frame), 1.0f);
    //[_pickerCloseBtn.layer addSublayer:upperBorder];
}

- (IBAction)openPicker:(id)sender {
    
    [self.view addSubview:_spendingTimeTextPicker];
}

#pragma mark -  Localization Functions

/*
 * Method to apply localization
 * @params:
 *      void
 * @return:
 *      void
 */
-(void)applyLocalization{
    lblQoute.text = NSLocalizedString(@"Take this untech time and enjoy to the fullest the people, experiences and life around you.", nil);
    
    
}

@end
