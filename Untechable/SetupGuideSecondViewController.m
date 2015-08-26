//
//  SetupGuideSecondViewController.m
//  Untechable
//
//  Created by RIKSOF Developer on 6/19/15.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "SetupGuideSecondViewController.h"
#import "SetupGuideThirdView.h"
#import "Common.h"

@interface SetupGuideSecondViewController () {
    NSMutableArray *customSpendingTextAry;
}


@end

@implementation SetupGuideSecondViewController

@synthesize untechable;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //navigation related Stuff
    [self setNavigationBarItems];
    
    [self setDefaultUntechSpendingTimeText];
    
    [self initializePickerData];

    [self applyLocalization];
}

-(void)applyLocalization{
    [_lblUntechQuestion setText:NSLocalizedString(UNTECH_QUESTION, nil)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated {    
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated {
    [self setNavigation:@"viewDidLoad"];
}

-(void)initializePickerData {
    
    customSpendingTextAry = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"cutomSpendingTimeTextAry"]];
    
    NSString *temStr = ( [untechable.spendingTimeTxt isEqualToString:@""] ) ? NSLocalizedString(UNTECH_EXEMPLARY_LABEL, nil) : untechable.spendingTimeTxt;
    [self setupDoctorsResearchLabel:temStr];
    
    self.setupSpendingTimeText.dataSource = self;
    self.setupSpendingTimeText.delegate = self;
}

/**
 Setting up Doctors Research Label to be shown
 **/
-(void) setupDoctorsResearchLabel:(NSString *)msg {
    _doctorsResearchLabel.text = [NSString stringWithFormat:NSLocalizedString(DOCTOR_RESEARCH_LABEL, nil), msg];
}

#pragma - Mark UI PICKER VIEW Delegate Methods
// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return customSpendingTextAry.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return customSpendingTextAry[row];
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    customSpendingTextAry =  [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"cutomSpendingTimeTextAry"]];

    if( [[customSpendingTextAry objectAtIndex:row] isEqualToString:[customSpendingTextAry objectAtIndex:customSpendingTextAry.count-1]] ) {
        [self showAddFieldPopUp];
    } else  {
        [self setupDoctorsResearchLabel:[customSpendingTextAry objectAtIndex:row]];
        untechable.spendingTimeTxt = [customSpendingTextAry objectAtIndex:row];
    }
}

//the size of the fonts in picker view was big for iphone 5 and small for iphone 6
// so again need to handle it programitacally
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
    lbl.text = [customSpendingTextAry objectAtIndex:row];
    lbl.adjustsFontSizeToFitWidth = YES;
    lbl.textAlignment = NSTextAlignmentCenter;
    
    [lbl sizeToFit];
    return lbl;
}

/**
 Showing a prompt where user can add their custom messages.
 **/
-(void) showAddFieldPopUp {
    
    UIAlertView *customMsg = [ [UIAlertView alloc] initWithTitle:@"Add Your Own Custom Untechable Message"
                                                    message:nil
                                                    delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Add", nil];
    
    customMsg.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [customMsg show];
}

#pragma - mark UIAlert View Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    // we will add new message at the second last index
    int position = ( int )[customSpendingTextAry count] - 1;
    
    //if cancel was not pressed
    if( buttonIndex != 0 ){
        
        // getting the newly added text from the field
        NSString *newMsg = [[alertView textFieldAtIndex:0] text];
        
        // adding the new msg at the second last index of the picker
        [customSpendingTextAry insertObject:newMsg atIndex:position];
        
        // inserting values in our pickerview's data source.
        [[NSUserDefaults standardUserDefaults] setObject:customSpendingTextAry forKey:@"cutomSpendingTimeTextAry"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //Update new msg in doctors research string
        [self setupDoctorsResearchLabel:newMsg];
        
        // save new Custom message to model 
        untechable.spendingTimeTxt = [customSpendingTextAry objectAtIndex:position];
        
        // reloading the new picker view with custom messages
        [_setupSpendingTimeText reloadAllComponents];

    }
}


#pragma - mark setting navigation bar related stuff
-(void) setNavigationBarItems {
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES]; //show navigation bar
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

-(void)setNavigation:(NSString *)callFrom {
        
    if([callFrom isEqualToString:@"viewDidLoad"])
    {
        self.navigationItem.hidesBackButton = YES;
        
        // Center title
        self.navigationItem.titleView = [untechable.commonFunctions navigationGetTitleView];
        
        // Back Navigation button
        backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        backButton.titleLabel.shadowColor = [UIColor clearColor];
        backButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [backButton setTitle:NSLocalizedString(TITLE_BACK_TXT, nil) forState:normal];
        [backButton setTitleColor:DEF_GRAY forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchDown];
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        backButton.showsTouchWhenHighlighted = YES;
        
        UIBarButtonItem *lefttBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        // adds left button to navigation bar
        [self.navigationItem setLeftBarButtonItem:lefttBarButton];

        // Right Navigation Button
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
        
        // adds right button to navigation bar
        [self.navigationItem setRightBarButtonItems:rightNavItems];
        
    }
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
    [self saveBeforeGoing];
    SetupGuideThirdView *thirdSetupScreen = [[SetupGuideThirdView alloc] initWithNibName:@"SetupGuideThirdView" bundle:nil];
    thirdSetupScreen.untechable = untechable;
    [self.navigationController pushViewController:thirdSetupScreen animated:YES];
}

-(void) goBack {
    
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:YES];
}

/**
 * if text not select then set first one
 */
-(void)saveBeforeGoing {
    if( untechable.spendingTimeTxt == nil || [untechable.spendingTimeTxt isEqualToString:@""] ) {
        untechable.spendingTimeTxt = [customSpendingTextAry objectAtIndex:0];
    }
}

/**
 * This method set default untech
 * spending time text in picker view
 */

-(void)setDefaultUntechSpendingTimeText{
    // set the selected default message or custom message in pickerview if already selected
    int positionToShow;
    for (int i = 0; i<customSpendingTextAry.count; i++) {
        if([customSpendingTextAry[i] isEqualToString:untechable.spendingTimeTxt] ){
            positionToShow = i;
            break;
        }
    }
    [self.setupSpendingTimeText selectRow:positionToShow inComponent:0 animated:NO];
}

@end
