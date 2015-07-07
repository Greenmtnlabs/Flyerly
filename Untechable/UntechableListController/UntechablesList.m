//
//  UntechablesList.m
//  Untechable
//
//  Created by RIKSOF Developer on 11/20/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "UntechablesList.h"
#import "UntechableTableCell.h"
#import "AddUntechableController.h"
#import "SettingsViewController.h"
#import "Common.h"
#import "Untechable.h"
#import "ThankyouController.h"


@interface UntechablesList () {
    
    NSMutableArray *allUntechables;
    NSMutableArray *sectionOneArray;
    NSMutableArray *sectionTwoArray;
    
    NSArray *_pickerData;
    int timeDuration;

}

@end

@implementation UntechablesList

@synthesize untechablesTable;
int indexArrayS1[];
int indexArrayS2[];

#pragma mark -  Default functions
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/**
 * Update the view once it appears.
 */
-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [untechable printNavigation:[self navigationController]];
    
}

#pragma mark -  Navigation functions
- (void)setNavigationDefaults{
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES]; //show navigation bar
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

-(void)setNavigation:(NSString *)callFrom
{
    defGreen = [UIColor colorWithRed:66.0/255.0 green:247.0/255.0 blue:206.0/255.0 alpha:1.0];//GREEN
    defGray = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1.0];//GRAY
    
    if([callFrom isEqualToString:@"viewDidLoad"])
    {
        self.navigationItem.hidesBackButton = YES;
        
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
        
        // Center title __________________________________________________
        self.navigationItem.titleView = [untechable.commonFunctions navigationGetTitleView];
        
        // Right Navigation ______________________________________________
        newUntechableButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        newUntechableButton.titleLabel.shadowColor = [UIColor clearColor];
        newUntechableButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [newUntechableButton setTitle:TITLE_NEW_TXT forState:normal];
        [newUntechableButton setTitleColor:defGray forState:UIControlStateNormal];
        [newUntechableButton addTarget:self action:@selector(addUntechable) forControlEvents:UIControlEventTouchUpInside];
        newUntechableButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:newUntechableButton];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton,nil];
        
        [self.navigationItem setRightBarButtonItems:rightNavItems];//Right button ___________
    }
}

- (IBAction)goToSettings {
    
    NSLog(@"Go To p[refrences screen");
    SettingsViewController *settingsController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    settingsController.untechable = untechable;
    [self.navigationController pushViewController:settingsController animated:YES];
}

-(void)addUntechable{
    
    NSLog(@"Go To add untechable screen");
    AddUntechableController *addUntechable = [[AddUntechableController alloc]initWithNibName:@"AddUntechableController" bundle:nil];
    
    addUntechable.untechable = untechable;
    addUntechable.indexOfUntechableInEditMode = -1;
    [self.navigationController pushViewController:addUntechable animated:YES];
}

/*
 Variable we must need in model, for testing we can use these vars
 */

-(void) configureTestData
{
    untechable.userId   = TEST_UID;
}

#pragma mark -  Model funcs
// set default vaules in model
-(void)setDefaultModel{
    
    //init object
    untechable  = [[Untechable alloc] init];
    untechable.commonFunctions = [[CommonFunctions alloc] init];
    
    //For testing -------- { --
    [self configureTestData];
    //For testing -------- } --
    
    allUntechables = [untechable.commonFunctions getAllUntechables:untechable.userId];
    
    [self testInternetConnection];
}

- (void)viewWillAppear:(BOOL)animated{
    
    allUntechables = [untechable.commonFunctions getAllUntechables:untechable.userId];
        
    [self setNumberOfRowsInSection];
    
    untechablesTable.separatorInset = UIEdgeInsetsZero;
    
    [untechablesTable reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // During startup (-viewDidLoad or in storyboard) do:
    self.untechablesTable.allowsMultipleSelectionDuringEditing = NO;
    
    [self setDefaultModel];
    [self setNavigationDefaults];
    [self setNavigation:@"viewDidLoad"];
    [self updateUI];
    
    [self initializePickerData];
    [_timeDurationPicker setHidden:YES];
    [_doneButtonView setHidden:YES];

    // Do any additional setup after loading the view from its nib.
    
    //setting default time duration for untech now
    timeDuration = 30*60;
}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

/**
 * Show / hide, a loding indicator in the right bar button.
 */
- (void)showHidLoadingIndicator:(BOOL)show {
    if( show ){
        newUntechableButton.enabled = NO;
        
        UIActivityIndicatorView *uiBusy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [uiBusy setColor:[UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0]];
        uiBusy.hidesWhenStopped = YES;
        [uiBusy startAnimating];
        
        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:uiBusy];
        [self.navigationItem setRightBarButtonItem:btn animated:NO];
    }
    else{
        newUntechableButton.enabled = YES;
        [self setNavigation:@"viewDidLoad"];
    }
}

-(void)changeNavigation:(NSString *)option
{
    // DISABLE NAVIGATION ON SEND DATA TO API
    if([option isEqualToString:@"ON_FINISH"] ){
        
        newUntechableButton.userInteractionEnabled = NO;
        [self showHidLoadingIndicator:YES];
    }
    
    // RE-ENABLE NAVIGATION WHEN ANY ERROR OCCURED
    else if([option isEqualToString:@"ERROR_ON_FINISH"] ){
        
        newUntechableButton.userInteractionEnabled = YES;
        
        [self showHidLoadingIndicator:NO];
    }
    
    else if ( [option isEqualToString:@"ON_FINISH_SUCCESS"] ){
        
        newUntechableButton.userInteractionEnabled = YES;
        
        [self showHidLoadingIndicator:NO];
        
        [self setNumberOfRowsInSection];
        
        [untechablesTable reloadData];
    }
}


-(void)showMsgOnApiResponse:(NSString *)message
{
    UIAlertView *temAlert = [[UIAlertView alloc ]
                             initWithTitle:@""
                             message:message
                             delegate:self
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
    [temAlert show];
    
    if( [message isEqualToString:@"Untechable created successfully"] ){
        
        /* //doing this app crashing bcz alert value nil
         //Go to main screen
         [self.navigationController popToRootViewControllerAnimated:YES];
         // Remove observers
         [[NSNotificationCenter defaultCenter] removeObserver:self];
         */
    }
}

- (void)sendDeleteRequestToApi:(NSInteger)indexToremoveOnSucess Section:(NSInteger)section {
    
    BOOL errorOnFinish = NO;
    
    [self changeNavigation:@"ON_FINISH"];
    
    NSMutableDictionary *tempDict;
    
    NSString *apiDelete;
    if ( section == 0 ){
        tempDict = [sectionOneArray objectAtIndex:indexToremoveOnSucess];
        apiDelete = [NSString stringWithFormat:@"%@?eventId=%@",API_DELETE,[tempDict valueForKey:@"eventId"]];
    }else if ( section == 1 ){
        tempDict = [sectionTwoArray objectAtIndex:indexToremoveOnSucess];
        apiDelete = [NSString stringWithFormat:@"%@?eventId=%@",API_DELETE,[tempDict valueForKey:@"eventId"]];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:apiDelete]];
    [request setHTTPMethod:@"POST"];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if( returnData != nil ){
        
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"In response of save api: %@",dict);
        
        NSString *message = @"";
        
        if( [[dict valueForKey:@"status"] isEqualToString:@"OK"] ) {
        
            if ( section == 0 ){
                NSString *untechablePath = [tempDict objectForKey:@"untechablePath"];
                [[NSFileManager defaultManager] removeItemAtPath:untechablePath error:nil];
                [sectionOneArray removeObjectAtIndex:indexToremoveOnSucess];
            }else if ( section == 1 ){
                NSString *untechablePath = [tempDict objectForKey:@"untechablePath"];
                [[NSFileManager defaultManager] removeItemAtPath:untechablePath error:nil];
                [sectionTwoArray removeObjectAtIndex:indexToremoveOnSucess];
            }
            
        } else{
            message = [dict valueForKey:@"message"];
            if( !([[dict valueForKey:@"eventId"] isEqualToString:@"0"]) ) {

            }
            errorOnFinish = YES;
        }
        
        if( !([message isEqualToString:@""]) ) {
            dispatch_async( dispatch_get_main_queue(), ^{
                [self showMsgOnApiResponse:message];
            });
        }
    }
    else{
        errorOnFinish = YES;
    }
    
    if( errorOnFinish ){
        dispatch_async( dispatch_get_main_queue(), ^{
            [self changeNavigation:@"ERROR_ON_FINISH"];
        });
    }
    else{
        dispatch_async( dispatch_get_main_queue(), ^{
            [self changeNavigation:@"ON_FINISH_SUCCESS"];
        });
    }
}

-(void)updateUI{
    
    [btnUntechCustom setTitleColor:defGray forState:UIControlStateNormal];
    btnUntechCustom.titleLabel.font = [UIFont fontWithName:APP_FONT size:16];
    btnUntechCustom.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [btnUntechNow setTitleColor:defGray forState:UIControlStateNormal];
    btnUntechNow.titleLabel.font = [UIFont fontWithName:APP_FONT size:16];
    btnUntechNow.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if( !internetReachable.isReachable ){
        //show alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                        message:@"You must be connected to the internet to use this app."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    else {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            if ( indexPath.section == 0 ){
                
                [self sendDeleteRequestToApi:indexPath.row Section:indexPath.section];
        
            }else if ( indexPath.section == 1 ){
            
                [self sendDeleteRequestToApi:indexPath.row Section:indexPath.section];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        NSMutableDictionary *tempDict = nil;
        
        if ( indexPath.section == 0 ){
             tempDict = [sectionOneArray objectAtIndex:indexArrayS1[indexPath.row]];
        }else if ( indexPath.section == 1 ){
            int r = (int)indexPath.row;
            NSLog(@"r %i",r);
             tempDict = [sectionTwoArray objectAtIndex:indexArrayS2[r]];
        }
        
        //Setting the packagename,packageprice,packagedesciption values for cell view
        if( tempDict != nil ){
            static NSString *cellId = @"UntechableTableCell";
            UntechableTableCell *cell = (UntechableTableCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UntechableTableCell" owner:self options:nil];
            cell = (UntechableTableCell *)[nib objectAtIndex:0];
            
            [cell setCellValueswithUntechableTitle:[tempDict objectForKey:@"spendingTimeTxt"]
                                        StartDate:[untechable.commonFunctions timestampStringToAppDate:[tempDict objectForKey:@"startDate"]]
                                         StartTime:[untechable.commonFunctions timestampStringToAppDateTime:[tempDict objectForKey:@"startDate"]]
                                           EndDate:[untechable.commonFunctions timestampStringToAppDate:[tempDict objectForKey:@"endDate"]]
                                           EndTime:[untechable.commonFunctions timestampStringToAppDateTime:[tempDict objectForKey:@"endDate"]]];
            return cell;
        }
        else{
            UITableViewCell *cell = nil;
            return cell;
        }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    defGreen = [UIColor colorWithRed:66.0/255.0 green:247.0/255.0 blue:206.0/255.0 alpha:1.0];//GREEN
    defGray = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0];//GRAY
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)];
    UILabel *label;
    if (section == 0){
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, tableView.bounds.size.width - 10, 18)];
        label.text = @"Upcoming Untechable Time:";
        label.textColor = defGray;
        [label setFont:[UIFont fontWithName:APP_FONT size:16]];
        label.backgroundColor = [UIColor clearColor];
    
    }else {
    
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.bounds.size.width - 10, 30)];
        label.text = @"Current Untechable Time:";
        label.textColor = defGray;
        [label setFont:[UIFont fontWithName:APP_FONT size:16]];
        label.backgroundColor = [UIColor clearColor];
    }

    [headerView addSubview:label];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( indexPath.section == 0 ){
        
        NSMutableDictionary *tempDict = [sectionOneArray  objectAtIndex:indexArrayS1[indexPath.row]];
       

        AddUntechableController *addUntechable;
        addUntechable = [[AddUntechableController alloc]initWithNibName:@"AddUntechableController" bundle:nil];
        
        addUntechable.indexOfUntechableInEditMode = [[tempDict objectForKey:@"index"] intValue];
        addUntechable.callReset = @"";
        
        [self.navigationController pushViewController:addUntechable animated:YES];
        
    }else if ( indexPath.section == 1 ){
        
        NSMutableDictionary *tempDict = [sectionTwoArray  objectAtIndex:indexArrayS2[indexPath.row]];
        
        AddUntechableController *addUntechable;
        addUntechable = [[AddUntechableController alloc]initWithNibName:@"AddUntechableController" bundle:nil];
        
        addUntechable.indexOfUntechableInEditMode = [[tempDict objectForKey:@"index"] intValue];
        addUntechable.callReset = @"RESET1";
        
        [self.navigationController pushViewController:addUntechable animated:YES];
    }

    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

- (void) setNumberOfRowsInSection {
    
    NSDate *currentDate = [NSDate date];
    
    sectionOneArray = [[NSMutableArray alloc] init];
    sectionTwoArray = [[NSMutableArray alloc] init];
    NSMutableArray *currentTimeStamps1 = [[NSMutableArray alloc] init];
    NSMutableArray *currentTimeStamps2 = [[NSMutableArray alloc] init];
    
    allUntechables = [untechable.commonFunctions getAllUntechables:untechable.userId];
    
    for (int i=0 ; i < allUntechables.count ; i++){
        NSMutableDictionary *tempDict = [allUntechables objectAtIndex:i];
        [tempDict setObject:[NSNumber numberWithInt:i] forKey:@"index"];
        
        NSDate *startDate = [untechable.commonFunctions timestampStrToNsDate:[tempDict objectForKey:@"startDate"]];
        if ( ![untechable.commonFunctions date1IsSmallerThenDate2:startDate date2:currentDate] ){
            [sectionOneArray addObject:tempDict];
            [currentTimeStamps1 addObject:[tempDict valueForKey:@"startDate"]];
        }else{
            [sectionTwoArray addObject:tempDict];
            [currentTimeStamps2 addObject:[tempDict valueForKey:@"startDate"]];
        }
        
    }
    
    [self sortOutTheTimeStamp:currentTimeStamps1 sortFor:@"sec1"];
    [self sortOutTheTimeStamp:currentTimeStamps2 sortFor:@"sec2"];
    
}

//getting the time stamps from the array and sorting it out!
-(void)sortOutTheTimeStamp:(NSMutableArray *)timeStampArray sortFor:(NSString *)sortFor{
    int timeStamps [timeStampArray.count];
    int sortedTimeStamps [timeStampArray.count];
    
    // get all the values from mutable array and change it into integer array
    for( int i = 0; i < timeStampArray.count; i++){
        //will be used as unsorted array to compare
        timeStamps[i] = [timeStampArray[i] integerValue];
        
        // will be used as sorted array to compare
        sortedTimeStamps[i] = [timeStampArray[i] integerValue];
    }
    
    // temprary variable that will hold down the values when sorting being done
    int tempVal;
    
    // now sort it out on the time stamp
    for( int i = 0; i < timeStampArray.count; i++ ){
        for( int j = 0; j<timeStampArray.count-1; j++ ){
            if( sortedTimeStamps[j] < sortedTimeStamps [i] ){
                tempVal = sortedTimeStamps[j];
                sortedTimeStamps[j] = sortedTimeStamps[i];
                sortedTimeStamps[i] = tempVal;
            }
        }
    }

    // temporary array that will hold indexes of values
    int indexArray [timeStampArray.count];
    if( [sortFor isEqual:@"sec1"]){
        indexArrayS1 [timeStampArray.count];
    }else{
        indexArrayS2 [timeStampArray.count];
    }
    
    //now getting the indexes of array and save it.
    for( int i = 0; i<timeStampArray.count; i++){
        for( int j = 0; j<timeStampArray.count; j++){

            if( sortedTimeStamps[i] == timeStamps[j] ){
                indexArray[i] = j;
                if( [sortFor isEqual:@"sec1"]){
                    indexArrayS1[i] = j;
                }else{
                    indexArrayS2[i] = j;
                }
                break;
            }
        }
    }
    
    // testing
    //print out all the arrays
    for( int i = 0; i < timeStampArray.count; i++ ){
        NSLog(@" Index array is %i, sorted array %i, unsorted array %i", indexArray[i], sortedTimeStamps[i], timeStamps[i] );
    }
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int numberOfRowsInSection = 0;
    if ( section == 0 ){
        numberOfRowsInSection = (int)sectionOneArray.count;
    }else if ( section == 1 ){
        numberOfRowsInSection = (int)sectionTwoArray.count;
    }
    //return sectionHeader;
    return  numberOfRowsInSection;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionHeader;
    if ( section == 0 ){
        sectionHeader = @"Upcoming Untechables";
    }else if ( section == 1 ){
        sectionHeader = @"Archives Untechables";
    }
    return sectionHeader;
}

// Checks if we have an internet connection or not
- (void)testInternetConnection
{
    internetReachable = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachable.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Yayyy, we have the interwebs!");
        });
    };
    
    // Internet is not reachable
    internetReachable.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Someone broke the internet :(");
        });
    };
    
    [internetReachable startNotifier];
}

-(void)showHideTextPicker:(BOOL)showHide{

    float alpha = (showHide) ? 1.0 : 0.0;
    
    _timeDurationPicker.alpha = alpha;
    _doneButtonView.alpha = alpha;
    [self addUpperBorder];
    self.doneButtonView.backgroundColor = [self colorFromHexString:@"#f1f1f1"];
    self.timeDurationPicker.backgroundColor = [self colorFromHexString:@"#fafafa"];
    
    //changing the "CLOSE"button text color to black
    [_doneButtonView setTitleColor:[self colorFromHexString:@"#000000"] forState:UIControlStateNormal];
    
}

/**
 Hex Color Converter
 @params NSString
 retunrs UIColor
 */
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

/**
 Adding a top border for a view
 **/
- (void)addUpperBorder
{
    CALayer *upperBorder = [CALayer layer];
    upperBorder.backgroundColor = [[UIColor lightGrayColor] CGColor];
    upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(_doneButtonView.frame), 1.0f);
    [_doneButtonView.layer addSublayer:upperBorder];
}

-(void)initializePickerData {
    
    NSArray *arrayToBeAdded =  @[@"30 min", @"1 hr", @"1 day", @"2 days"];
   
    _pickerData = arrayToBeAdded;
    
    self.timeDurationPicker.dataSource = self;
    self.timeDurationPicker.delegate = self;
    
    
}

- (NSDate *)timestampStrToNsDate:(NSString *)timeStamp
{
    return [NSDate dateWithTimeIntervalSince1970:[timeStamp integerValue]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    switch (row) {
        case 0:
            timeDuration = 30*60; //30 minutes
            break;
            
        case 1:
            timeDuration = 60*60; //1 hr
            break;
        
        case 2:
            timeDuration = 24*60*60; //1 day
            break;
        
        case 3:
            timeDuration = 2*24*60*60; //2 days
            break;
            
        default:
            timeDuration = 30*60; //30 minutes
            break;
    }
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

- (IBAction)untechNowClick:(id)sender {
    
    self.doneButtonView.backgroundColor = [self colorFromHexString:@"#f1f1f1"];
    
    //changing the "CLOSE"button text color to black
    [_doneButtonView setTitleColor:[self colorFromHexString:@"#000000"] forState:UIControlStateNormal];

    
    [self initializePickerData];
    [_timeDurationPicker setHidden:NO];
    [_doneButtonView setHidden:NO];
    [self showHideTextPicker:YES];
   
}

- (IBAction)untechCustomClick:(id)sender {
   
    NSLog(@"Go To add untechable screen");
    AddUntechableController *addUntechable = [[AddUntechableController alloc]initWithNibName:@"AddUntechableController" bundle:nil];
    
    addUntechable.untechable = untechable;
    addUntechable.indexOfUntechableInEditMode = -1;
    [self.navigationController pushViewController:addUntechable animated:YES];
    
}
- (IBAction)btnDoneClick:(id)sender {
    
    
    [_timeDurationPicker setHidden:YES];
    [_doneButtonView setHidden:YES];
    
    [self initializeUntechNow];
    
    [self changeNavigation:@"ON_FINISH"];
    
    //Background work
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        [untechable sendToApiAfterTask:^(BOOL errorOnFinish,NSString *message){
            
            if( !([message isEqualToString:@""]) ) {
                dispatch_async( dispatch_get_main_queue(), ^{
                    [self showMsgOnApiResponse:message];
                });
            }
            
            if( errorOnFinish ){
                dispatch_async( dispatch_get_main_queue(), ^{
                    [self changeNavigation:@"ERROR_ON_FINISH"];
                });
            }
            else{
                dispatch_async( dispatch_get_main_queue(), ^{
                    [self changeNavigation:@"ON_FINISH_SUCCESS"];
                    [self goToThankyouScreen];
                });
            }
            
        }];
        
    });

}

/**
 Initiailzing related stuff for Untech now Option
 e.g Directory, Untech vals, and options
 */
-(void)initializeUntechNow {
    
    [untechable initWithDefValues];
    [untechable initUntechableDirectory];
    untechable.startDate  = [untechable.commonFunctions nsDateToTimeStampStr: [[NSDate date] dateByAddingTimeInterval:(0)] ]; //current time + time duration
    
    untechable.endDate  = [untechable.commonFunctions nsDateToTimeStampStr: [[NSDate date] dateByAddingTimeInterval:(timeDuration)] ]; //start time +1 Day
    
    // the selected status from the setup screen would be set as default status on unetch now option
    NSInteger positionOfSelectedStatusFromArray = [[NSUserDefaults standardUserDefaults] integerForKey:@"positionToRemember"];
    NSArray *customArrayOfStatuses = [[NSUserDefaults standardUserDefaults]objectForKey:@"spendingTimeText"];
    NSString *selectedStatus = [customArrayOfStatuses objectAtIndex:positionOfSelectedStatusFromArray];
    //setting spending time text to status got from setup screen.
    untechable.spendingTimeTxt = selectedStatus;
}

/**
 navigate to thank you controller screen when successfully user create an untech
 **/
-( void ) goToThankyouScreen {
    ThankyouController *thankyouScreen = [[ThankyouController alloc] init];
    thankyouScreen.untechable = untechable;
    [self.navigationController pushViewController:thankyouScreen animated:YES];
}
@end
