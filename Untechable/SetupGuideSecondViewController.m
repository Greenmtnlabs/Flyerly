//
//  SetupGuideSecondViewController.m
//  Untechable
//
//  Created by RIKSOF Developer on 6/19/15.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "SetupGuideSecondViewController.h"
#import "SetupGuideViewController.h"
#import "SetupGuideThirdView.h"

@interface SetupGuideSecondViewController () {
    NSMutableArray *customSpendingText;
}


@end

@implementation SetupGuideSecondViewController

@synthesize untechable;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializePickerData];
    
    //navigation related Stuff
    [self setNavigationBarItems];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [untechable printNavigation:[self navigationController]];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self setNavigation:@"viewDidLoad"];
}

-(void)initializePickerData {
    
    NSArray *arrayToBeAdded =  @[@"Spending time with family.", @"Driving.", @"Spending time outdoors.", @"At the beach.", @"Enjoying the holidays.", @"Just needed a break.", @"Running.", @"On vacation.", @"Finding my inner peace.", @"Removing myself from technology.", @"Custom"];
    
    NSMutableOrderedSet * set = [NSMutableOrderedSet orderedSetWithArray:arrayToBeAdded ];
    
    NSArray *customSpendingTextArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"spendingTimeText"];
    
    [set unionSet:[NSSet setWithArray:customSpendingTextArray]];

    customSpendingText = [NSMutableArray arrayWithArray:[set array]];
    
    customSpendingText = [self customValAtTheEnd:customSpendingText];
    
    [self setupDoctorsResearchLabel:[customSpendingText objectAtIndex:0]];
    
    self.setupSpendingTimeText.dataSource = self;
    self.setupSpendingTimeText.delegate = self;
}

/**
 We Need To Set "Custom" Message at the end so we need to sort the
 array.
 **/
-(NSMutableArray *) customValAtTheEnd:(NSMutableArray *) customText {
 
    int totalCount = ( int )customText.count - 1;
    
    int customTextPosition = ( int )[customText indexOfObject:@"Custom"];
    
    [customText removeObjectAtIndex:customTextPosition];
    [customText insertObject:@"Custom" atIndex:totalCount];
    
    return customText;
}

/**
 Setting up Doctors Research Label to be shown
 **/
-(void) setupDoctorsResearchLabel:(NSString *)msg {
    _doctorsResearchLabel.text = [NSString stringWithFormat:@"Did you know that based on a study, people %@ have better relationships, better quality of sleep and in general are more emotionally balanced.", msg];
}

#pragma - Mark UI PICKER VIEW Delegate Methods
// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return customSpendingText.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return customSpendingText[row];
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if( [[customSpendingText objectAtIndex:row] isEqualToString:@"Custom"] ) {
        [self showAddFieldPopUp];
    } else  {
        [self setupDoctorsResearchLabel:[customSpendingText objectAtIndex:row]];
    }
    

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
    int position = ( int )[customSpendingText count] - 1;
    
    //if cancel was not pressed
    if( buttonIndex != 0 ){
        
        // getting the newly added text from the field
        NSString *newMsg = [[alertView textFieldAtIndex:0] text];
        
        // adding the new msg at the second last index of the picker
        [customSpendingText insertObject:newMsg atIndex:position];
        
        // inserting values in our pickerview's data source.
        [[NSUserDefaults standardUserDefaults] setObject:customSpendingText forKey:@"spendingTimeText"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //Update new msg in doctors research string
        [self setupDoctorsResearchLabel:newMsg];
        
        // reloading the new picker view with custom messages
        [_setupSpendingTimeText reloadAllComponents];
        

    }
}



#pragma - mark setting navigation bar related stuff
-(void) setNavigationBarItems {
    
    defGreen = [UIColor colorWithRed:66.0/255.0 green:247.0/255.0 blue:206.0/255.0 alpha:1.0];//GREEN
    defGray = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1.0];//GRAY
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES]; //show navigation bar
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
}

-(void)setNavigation:(NSString *)callFrom {
    
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
        [backButton setTitleColor:defGray forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchDown];
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        backButton.showsTouchWhenHighlighted = YES;
        
        UIBarButtonItem *lefttBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        [self.navigationItem setLeftBarButtonItem:lefttBarButton];//Left button ___________

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
    
    SetupGuideThirdView *thirdSetupScreen = [[SetupGuideThirdView alloc] initWithNibName:@"SetupGuideThirdView" bundle:nil];
    //secondSetupScreen.untechable = untechable;
    [self.navigationController pushViewController:thirdSetupScreen animated:YES];
}

-(void) goBack {
    
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:YES];
}

@end
