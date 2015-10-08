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
#import "RUntechable.h"
#import "RSetUntechable.h"
#import "UserPurchases.h"


@interface UntechablesList () {
    
    int sectionCurrentUntech, sectionUpcomingUntech, sectionPastUntech;
    
    NSMutableArray *allUntechables;
    NSMutableArray *currentUntechs;
    NSMutableArray *upcomingUntechs;
    NSMutableArray *pastUntechs;
    
    int loadAllUntechs;
    
    NSArray *_pickerData;
    int timeDuration;
    NSString *timeInString;
    NSArray *arrayToBeAdded;
    UserPurchases *userPurchases;
}
@end

@implementation UntechablesList

@synthesize untechablesTable;

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
}

- (void)viewWillAppear:(BOOL)animated{
    
    NSLog( @"HomeDirectoryPath - this will help us in finding realm file: %@", NSHomeDirectory() );
    
    if( loadAllUntechs == 1)
        [self setDefaultModel];
    else
        loadAllUntechs = 1;
        
    untechablesTable.separatorInset = UIEdgeInsetsZero;
    
    [untechablesTable reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    arrayToBeAdded =  @[ NSLocalizedString(@"30 minutes", nil), NSLocalizedString(@"1 hour", nil), NSLocalizedString(@"1 Day", nil), NSLocalizedString(@"2 Days", nil)];
    userPurchases = [UserPurchases getInstance];

    
    //setting default time duration for untech now
    timeDuration = 30*60; //30 minutes
    timeInString = @"30 minutes";
    
    // During startup (-viewDidLoad or in storyboard) do:
    self.untechablesTable.allowsMultipleSelectionDuringEditing = NO;
    
    [self setDefaultModel];
    loadAllUntechs = 0;
    
    [self testInternetConnection];
    [self setNavigationDefaults];
    [self setNavigation:@"viewDidLoad"];
    [self updateUI];
    
    [self initializePickerData];
    [self showHideTextPicker:NO];
    [_timeDurationPicker setHidden:YES];
    [_doneButtonView setHidden:YES];

    // Do any additional setup after loading the view from its nib.
   
}

#pragma mark -  Navigation functions
- (void)setNavigationDefaults{
    [[self navigationController] setNavigationBarHidden:NO animated:YES]; //show navigation bar
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

-(void)setNavigation:(NSString *)callFrom{
    
    if([callFrom isEqualToString:@"viewDidLoad"]){
        
        self.navigationItem.hidesBackButton = YES;
        
        // Setting left Navigation button "Settings"
        settingsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 86, 42)];
        settingsButton.titleLabel.shadowColor = [UIColor clearColor];
        settingsButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [settingsButton setTitle:NSLocalizedString(TITLE_SETTINGS_TXT, nil) forState:normal];
        [settingsButton setTitleColor:DEF_GRAY forState:UIControlStateNormal];
        [settingsButton addTarget:self action:@selector(goToSettings) forControlEvents:UIControlEventTouchUpInside];
        settingsButton.showsTouchWhenHighlighted = YES;
        
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
        
        [self.navigationItem setLeftBarButtonItem:leftBarButton];//Left button ___________
        
        // Center title __________________________________________________
        self.navigationItem.titleView = [untechable.commonFunctions navigationGetTitleView];
        
        // Right Navigation ______________________________________________
        btnHelp = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        btnHelp.titleLabel.shadowColor = [UIColor clearColor];
        btnHelp.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [btnHelp setTitle:NSLocalizedString(TITLE_HELP_TXT, nil) forState:normal];
        [btnHelp setTitleColor:DEF_GRAY forState:UIControlStateNormal];
        [btnHelp addTarget:self action:@selector(emailComposer) forControlEvents:UIControlEventTouchUpInside];
        btnHelp.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:btnHelp];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton,nil];
        
        [self.navigationItem setRightBarButtonItems:rightNavItems];//Right button ___________
    }
}

- (IBAction)goToSettings {
    SettingsViewController *settingsController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    untechable.rUId = @"1";
    untechable.dic[@"rUId"] = @"1";
    settingsController.untechable = untechable;
    [self.navigationController pushViewController:settingsController animated:YES];
}

-(void)addUntechable{
    AddUntechableController *addUntechable = [[AddUntechableController alloc]initWithNibName:@"AddUntechableController" bundle:nil];
    addUntechable.untechable = untechable;
    addUntechable.totalUntechables = (int)allUntechables.count;
    [self.navigationController pushViewController:addUntechable animated:YES];
}

/*
 * This method sends email
 * to support team
 */
- (IBAction)emailComposer {
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    if([MFMailComposeViewController canSendMail]){
        
        picker.mailComposeDelegate = self;
        [picker setSubject:@"Untech Email Feedback..."];
        
        // Set up recipients
        NSMutableArray *toRecipients = [[NSMutableArray alloc]init];
        [toRecipients addObject:@"support@greenmtnlabs.com"];
        [picker setToRecipients:toRecipients];
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

/**
 * Variable we must need in model, for testing we can use these vars
 */

-(void) setUserData{
    untechable.userId   = TEST_UID;
}

#pragma mark -  Model functions
-(void)setDefaultUntech{
    untechable  = [[Untechable alloc] initWithCommonFunctions];
    
    RLMResults *unsortedSetObjects = [RSetUntechable objectsWhere:@"rUId == '1'"];
    RSetUntechable *rSetUntechable = unsortedSetObjects[0];
    NSMutableDictionary *dic = [rSetUntechable getModelDic];
    dic[@"rUId"] = [untechable generateUniqueId];
    
    [untechable addOrUpdateInModel:UPDATE dictionary:dic];
    
    [self setTimeAcToCurVars];
    [self setUserData];
}

// set default vaules in model
-(void)setDefaultModel{
    
    [self setDefaultUntech];
    
    allUntechables = [[NSMutableArray alloc] init];
    currentUntechs = [[NSMutableArray alloc] init];
    upcomingUntechs = [[NSMutableArray alloc] init];
    pastUntechs = [[NSMutableArray alloc] init];
    
    NSDate *currentDate = [NSDate date];
    NSMutableArray *currentTimeStamps1 = [[NSMutableArray alloc] init];
    NSMutableArray *currentTimeStamps2 = [[NSMutableArray alloc] init];
    NSMutableArray *currentTimeStamps3 = [[NSMutableArray alloc] init];
    
    RLMResults *unsortedObjects = [RUntechable objectsWhere:@"rUId != ''"];
    int s1=0, s2=0, s3=0;
    // start for loop
    for(int i=0;i<unsortedObjects.count;i++){
        RSetUntechable *rUntechable = unsortedObjects[i];
        NSMutableDictionary *tempDict = [rUntechable getModelDic];
        [allUntechables addObject:tempDict];
        
        [tempDict setObject:[NSNumber numberWithInt:i] forKey:@"index"];
        
        NSDate *startDate = [untechable.commonFunctions convertTimestampToNSDate:[tempDict objectForKey:@"startDate"]];
        NSDate *endDate = [untechable.commonFunctions convertTimestampToNSDate:[tempDict objectForKey:@"endDate"]];
        
        
        if ([untechable.commonFunctions isEndDateGreaterThanStartDate:endDate endDate:currentDate] ){
            pastUntechs[s3++] = tempDict;
            [currentTimeStamps3 addObject:[tempDict valueForKey:@"startDate"]];
        }else if ( [untechable.commonFunctions isEndDateGreaterThanStartDate:startDate endDate:currentDate] && [untechable.commonFunctions isEndDateGreaterThanStartDate:currentDate endDate:endDate] ){
            currentUntechs[s2++] = tempDict;
            [currentTimeStamps2 addObject:[tempDict valueForKey:@"startDate"]];
        }else{
            upcomingUntechs[s1++] = tempDict;
            [currentTimeStamps1 addObject:[tempDict valueForKey:@"startDate"]];
        }
    }
    // end for loop
    
    [self sortOutTheTimeStamp:currentTimeStamps1 sortFor:@"upcoming"];
    [self sortOutTheTimeStamp:currentTimeStamps2 sortFor:@"current"];
    [self sortOutTheTimeStamp:currentTimeStamps3 sortFor:@"past"];
    
}

//getting the timestamps from the array and sorting it out!
-(void)sortOutTheTimeStamp:(NSMutableArray *)timeStampArray sortFor:(NSString *)sortFor{
    int timeStamps [timeStampArray.count];
    int sortedTimeStamps [timeStampArray.count];
    
    // get all the values from mutable array and change it into integer array
    for( int i = 0; i < timeStampArray.count; i++){
        //will be used as unsorted array to compare
        timeStamps[i] = (int)[timeStampArray[i] integerValue];
        
        // will be used as sorted array to compare
        sortedTimeStamps[i] = (int)[timeStampArray[i] integerValue];
    }
    
    // temporary variable that will hold the values when sorting being done
    int tempVal;
    
    // now sort it out on the timestamp
    for( int i = 0; i < timeStampArray.count; i++ ){
        for( int j = 0; j<timeStampArray.count-1; j++ ){
            if( sortedTimeStamps[j] < sortedTimeStamps [i] ){
                tempVal = sortedTimeStamps[j];
                sortedTimeStamps[j] = sortedTimeStamps[i];
                sortedTimeStamps[i] = tempVal;
            }
        }
    }
    
    NSMutableArray *tempCurrentUntechs = [[NSMutableArray alloc] init];
    NSMutableArray *tempUpcomingUntechs = [[NSMutableArray alloc] init];
    NSMutableArray *tempPastUntechs = [[NSMutableArray alloc] init];
    
    // gets the indexes of array and saves it
    for( int i = 0; i<timeStampArray.count; i++){
        for( int j = 0; j<timeStampArray.count; j++){
            if( sortedTimeStamps[i] == timeStamps[j] ){
                
                if( [sortFor isEqual:@"current"]){
                    tempCurrentUntechs[i] = currentUntechs[j];
                }else if( [sortFor isEqual:@"upcoming"]){
                    tempUpcomingUntechs[i] = upcomingUntechs[j];
                }else if( [sortFor isEqual:@"past"]){
                    tempPastUntechs[i] = pastUntechs[j];
                }
                    
                break;
            }
        }
    }
    
    if([sortFor isEqual:@"current"])
        currentUntechs = tempCurrentUntechs;
    else if ([sortFor isEqual:@"upcoming"])
        upcomingUntechs = tempUpcomingUntechs;
    else if([sortFor isEqual:@"past"])
        pastUntechs = tempPastUntechs;
}

/**
 * Show / hide, a loading indicator in the right bar button
 */
- (void)showHidLoadingIndicator:(BOOL)show {
    if( show ){
        
        UIActivityIndicatorView *uiBusy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [uiBusy setColor:[UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0]];
        uiBusy.hidesWhenStopped = YES;
        [uiBusy startAnimating];
        
        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:uiBusy];
        [self.navigationItem setRightBarButtonItem:btn animated:NO];
    }
    else{
        [self setNavigation:@"viewDidLoad"];
    }
}

-(void)changeNavigation:(NSString *)option
{
    int btnStatusInt = -1;
    
    // disables navigations when data is sent to API
    if([option isEqualToString:@"ON_FINISH"] ){
        btnStatusInt = 0;
    }
    
    // enables navigation when any error occurs
    else if( [option isEqualToString:@"ERROR_ON_FINISH"] || [option isEqualToString:@"ALERT_CANCEL"]){
        btnStatusInt = 1;
    }
    else if ( [option isEqualToString:@"ON_FINISH_SUCCESS"] ){
        
        btnStatusInt = 1;
        
        [self setDefaultModel];
        [untechablesTable reloadData];
    }
    
    BOOL btnsStatus = (btnStatusInt == 1) ? YES : NO;
    if( btnStatusInt != -1 ){
        btnHelp.enabled = btnsStatus;
        btnUntechNow.enabled = btnsStatus;
        btnUntechCustom.enabled = btnsStatus;
        settingsButton.enabled = btnsStatus;
        untechablesTable.userInteractionEnabled = btnsStatus;
        [self showHidLoadingIndicator:!(btnsStatus)];
    }
}


-(void)showMsgOnApiResponse:(NSString *)message{
    
    UIAlertView *temAlert = [[UIAlertView alloc ]
                             initWithTitle:@""
                             message:message
                             delegate:self
                             cancelButtonTitle:NSLocalizedString(OK, nil)
                             otherButtonTitles:nil];
    [temAlert show];
    if( [message isEqualToString:NSLocalizedString(@"Untechable created successfully", nil)] ){
    }
}

/**
 * Delete Untechable from Realm(Database)
 * @params: indexToremoveOnSucess - is the index table view section
 * @params: section - is table view section (we have different arrays for different sections)
 */
-(void)deleteUntechable:(NSInteger)indexToremoveOnSucess Section:(NSInteger)section {

    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    
    if(section == sectionCurrentUntech){
        tempDict = currentUntechs[indexToremoveOnSucess];
    } else if (section == sectionUpcomingUntech){
        tempDict = upcomingUntechs[indexToremoveOnSucess];
    } else if(section == sectionPastUntech){
        tempDict = pastUntechs[indexToremoveOnSucess];
    }
    
    [untechable deleteUntechable:tempDict[@"rUId"] callBack:^(bool deleted){
        [self setDefaultModel];
        [untechablesTable reloadData];
    }];
}

- (void)sendDeleteRequestToApi:(NSInteger)indexToremoveOnSucess Section:(NSInteger)section {
    
    BOOL errorOnFinish = NO;
    NSMutableDictionary *tempDict;
    NSString *apiDelete;
    
    if ( section == sectionCurrentUntech ){
        tempDict = [currentUntechs objectAtIndex:indexToremoveOnSucess];
        apiDelete = [NSString stringWithFormat:@"%@?eventId=%@",API_DELETE,[tempDict valueForKey:@"eventId"]];
    }else if ( section == sectionUpcomingUntech ){
        tempDict = [upcomingUntechs objectAtIndex:indexToremoveOnSucess];
        apiDelete = [NSString stringWithFormat:@"%@?eventId=%@",API_DELETE,[tempDict valueForKey:@"eventId"]];
    } else if ( section == sectionPastUntech ){
        tempDict = [pastUntechs objectAtIndex:indexToremoveOnSucess];
        apiDelete = [NSString stringWithFormat:@"%@?eventId=%@",API_DELETE,[tempDict valueForKey:@"eventId"]];
    }

    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:apiDelete]];
    [request setHTTPMethod:@"POST"];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
 
    NSString *message = @"";
    if( returnData != nil ){
        
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
        
        if( [[dict valueForKey:@"status"] isEqualToString:@"OK"] ) {
            
        } else{
            message = [dict valueForKey:@"message"];
            if( !([[dict valueForKey:@"eventId"] isEqualToString:@"0"]) ) {

            }
            errorOnFinish = YES;
        }
        
    }
    else{
        errorOnFinish = YES;
        message = NSLocalizedString(@"Unable to delete, please try agin later!", nil);
    }
    
    if( errorOnFinish ){
        dispatch_async( dispatch_get_main_queue(), ^{
            [self changeNavigation:@"ERROR_ON_FINISH"];
        });
    }
    else{
        dispatch_async( dispatch_get_main_queue(), ^{
            [self changeNavigation:@"ON_FINISH_SUCCESS"];
            [self deleteUntechable:indexToremoveOnSucess Section:section];
        });
    }
    
    if( !([message isEqualToString:@""]) ) {
        dispatch_async( dispatch_get_main_queue(), ^{
            [self showMsgOnApiResponse:message];
        });
    }
}

-(void)updateUI{
    
    btnUntechCustom.layer.cornerRadius = 10;
    [btnUntechCustom setTitle:NSLocalizedString(@"Untech Custom", nil) forState:normal];
    [btnUntechCustom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnUntechCustom setBackgroundColor:DEF_GRAY];
    btnUntechCustom.titleLabel.font = [UIFont fontWithName:APP_FONT size:16];
    btnUntechCustom.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    btnUntechNow.layer.cornerRadius = 10;
    [btnUntechNow setTitle:NSLocalizedString(@"Untech Now", nil) forState:normal];
    [btnUntechNow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnUntechNow setBackgroundColor:DEF_GRAY];
    btnUntechNow.titleLabel.font = [UIFont fontWithName:APP_FONT size:16];
    btnUntechNow.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
}

- (IBAction)btnTouchStart:(id)sender{
    [self setHighlighted:YES sender:sender];
}
- (IBAction)btnTouchEnd:(id)sender{
    [self setHighlighted:NO sender:sender];
}

- (void)setHighlighted:(BOOL)highlighted sender:(id)sender {
    (highlighted) ? [sender setBackgroundColor:DEF_GRAY] : [sender setBackgroundColor:DEF_GRAY];
}

/**
 * Override to support conditional editing of the table view.
 * This only needs to be implemented if you are going to return NO
 * for some items. By default, all items are editable.
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if( !internetReachable.isReachable ){
        // show alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No network connection", nil)
                                                        message:NSLocalizedString(@"You must be connected to the internet to use this app.", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(OK, nil)
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    else {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            [self changeNavigation:@"ON_FINISH"];
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                [self sendDeleteRequestToApi:indexPath.row Section:indexPath.section];
            });
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        NSMutableDictionary *tempDict = nil;
        int row = (int)indexPath.row;
    
        if ( indexPath.section == sectionCurrentUntech ){
            tempDict = currentUntechs[row];
        }else if ( indexPath.section == sectionUpcomingUntech ){
            tempDict = upcomingUntechs[row];
        }else if ( indexPath.section == sectionPastUntech ){
            tempDict = pastUntechs[row];
        }
        
        //Setting the packagename,packageprice,packagedesciption values for cell view
        if( tempDict != nil ){
            static NSString *cellId = @"UntechableTableCell";
            UntechableTableCell *cell = (UntechableTableCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UntechableTableCell" owner:self options:nil];
            cell = (UntechableTableCell *)[nib objectAtIndex:0];
            
            [cell setCellValueswithUntechableTitle:[tempDict objectForKey:@"spendingTimeTxt"]
                                        StartDate:[untechable.commonFunctions convertTimestampToAppDate:[tempDict objectForKey:@"startDate"]]
                                         StartTime:[untechable.commonFunctions convertTimestampToAppDateTime:[tempDict objectForKey:@"startDate"]]
                                           EndDate:[untechable.commonFunctions convertTimestampToAppDate:[tempDict objectForKey:@"endDate"]]
                                           EndTime:[untechable.commonFunctions convertTimestampToAppDateTime:[tempDict objectForKey:@"endDate"]]];
            return cell;
        }
        else{
            UITableViewCell *cell = nil;
            return cell;
        }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)];
    UILabel *label;
    
    if (section == sectionCurrentUntech ){
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.bounds.size.width - 10, 18)];
        label.text = NSLocalizedString(@"Current Untechs:", nil);
    }else if(section == sectionUpcomingUntech){
    
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.bounds.size.width - 10, 18)];
        label.text = NSLocalizedString(@"Upcoming Untechs:", nil);
    } else if (section == sectionPastUntech){
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.bounds.size.width - 10, 18)];
        label.text = NSLocalizedString(@"Past Untechs:", nil);
    }
    
    label.textColor = DEF_GRAY;
    [label setFont:[UIFont fontWithName:APP_FONT size:16]];
    label.backgroundColor = [UIColor clearColor];

    [headerView addSubview:label];
    
    return headerView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *tempDictionary;
    if ( indexPath.section == sectionCurrentUntech ){
        tempDictionary = currentUntechs[indexPath.row];
    } else if ( indexPath.section == sectionUpcomingUntech ){
        tempDictionary = upcomingUntechs[indexPath.row];
    }else if ( indexPath.section == sectionPastUntech ){
        tempDictionary = pastUntechs[indexPath.row];
    }
    
    
    AddUntechableController *addUntechable = [[AddUntechableController alloc]initWithNibName:@"AddUntechableController" bundle:nil];
    [untechable addOrUpdateInModel:UPDATE dictionary:tempDictionary];
    
    addUntechable.untechable = untechable;
    addUntechable.totalUntechables = (int)allUntechables.count;
    
    [self.navigationController pushViewController:addUntechable animated:YES];

    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int numberOfRowsInSection = 0;
    if ( section == sectionCurrentUntech ){
        numberOfRowsInSection = (int)currentUntechs.count;
    }else if ( section == sectionUpcomingUntech ){
        numberOfRowsInSection = (int)upcomingUntechs.count;
    }else if ( section == sectionPastUntech ){
        numberOfRowsInSection = (int)pastUntechs.count;
    }
    //return sectionHeader;
    return  numberOfRowsInSection;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int noOfSections = 0;
    sectionCurrentUntech = sectionUpcomingUntech = sectionPastUntech = -1;
    
    if(currentUntechs.count > 0){
        sectionCurrentUntech = noOfSections++;
    }
    if(upcomingUntechs.count > 0){
        sectionUpcomingUntech = noOfSections++;
    }
    if(pastUntechs.count > 0){
       sectionPastUntech = noOfSections++;
    }
    return noOfSections;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionHeader;
    if ( section == sectionCurrentUntech ){
        sectionHeader = NSLocalizedString(@"Current Untechs", nil);
    } else if ( section == sectionUpcomingUntech ){
        sectionHeader = NSLocalizedString(@"Upcoming Untechs", nil);
    }else if ( section == sectionPastUntech ){
        sectionHeader = NSLocalizedString(@"Past Untechs:", nil);
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
    
    //changes the "CLOSE" button text color to black
    [_doneButtonView setTitleColor:[self colorFromHexString:@"#000000"] forState:UIControlStateNormal];
    
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

/**
 * Adding a top border for a view
 */
- (void)addUpperBorder
{
    CALayer *upperBorder = [CALayer layer];
    upperBorder.backgroundColor = [[UIColor lightGrayColor] CGColor];
    upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(_doneButtonView.frame), 1.0f);
    [_doneButtonView.layer addSublayer:upperBorder];
}

-(void)initializePickerData {
    _pickerData = arrayToBeAdded;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    switch (row) {
        case 0:
            timeDuration = 30*60; // 30 minutes
            timeInString = arrayToBeAdded[0];
            break;
            
        case 1:
            timeDuration = 60*60; // 1 hr
            timeInString = arrayToBeAdded[1];
            break;
        
        case 2:
            timeDuration = 24*60*60; // 1 day
            timeInString = arrayToBeAdded[2];
            break;
        
        case 3:
            timeDuration = 2*24*60*60; // 2 days
            timeInString = arrayToBeAdded[3];
            break;
            
        default:
            timeDuration = 30*60; // 30 minutes
            timeInString = arrayToBeAdded[0];
            break;
    }
    
    [self setTimeAcToCurVars];
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
    
    // changes the "CLOSE" button text color to black
    [_doneButtonView setTitle:NSLocalizedString(TITLE_DONE_TXT, nil) forState:normal];
    [_doneButtonView setTitleColor:[self colorFromHexString:@"#000000"] forState:UIControlStateNormal];

    [self initializePickerData];
    [_timeDurationPicker setHidden:NO];
    [_doneButtonView setHidden:NO];
    [self showHideTextPicker:( (int)_timeDurationPicker.alpha == 0 )];
}

- (IBAction)untechCustomClick:(id)sender {
    [self addUntechable];
}
- (IBAction)btnDoneClick:(id)sender {
    
    [_timeDurationPicker setHidden:YES];
    [_doneButtonView setHidden:YES];
    [self changeNavigation:@"ON_FINISH"];
    
    [self checkPayment];
}

/**
 * navigate to ThankyouController screen when untech is created successfully
 */
-( void ) goToThankyouScreen {
    ThankyouController *thankyouScreen = [[ThankyouController alloc] init];
    thankyouScreen.untechable = untechable;
    [self.navigationController pushViewController:thankyouScreen animated:YES];
}
-( void )setTimeAcToCurVars {
    
    untechable.startDate  = [untechable.commonFunctions convertNSDateToTimestamp: [[NSDate date] dateByAddingTimeInterval:(0)] ]; // current time
    untechable.endDate  = [untechable.commonFunctions convertNSDateToTimestamp: [[NSDate date] dateByAddingTimeInterval:(timeDuration)] ]; // start time + selected time duration
    
    // the selected status from the setup screen would be set as default status on unetch now option
    NSArray *customArrayOfStatuses = [[NSUserDefaults standardUserDefaults]objectForKey:@"cutomSpendingTimeTextAry"];
    NSString *selectedStatus = @"";
    for (int i = 0; i<customArrayOfStatuses.count; i++) {
        if([customArrayOfStatuses[i] isEqualToString:untechable.spendingTimeTxt] ){
            selectedStatus = [customArrayOfStatuses objectAtIndex:i];
            break;
        }
    }
    
    //setting spendingTimeTxt to status got from setup screen.
    untechable.spendingTimeTxt = selectedStatus;
    NSString *socialStatus = [NSString stringWithFormat:NSLocalizedString(@"#Untechable for %@ %@ ", nil), timeInString, untechable.spendingTimeTxt];
    untechable.socialStatus = socialStatus;
    
}

#pragma mark -  Payment functions
/**
 * Check have valid subscription before creating Untechable
 */
-(void)checkPayment{
    //When haven't any sms/call in Untechable
    if( [untechable.commonFunctions haveCallOrSms:untechable.customizedContactsForCurrentSession] == NO ){
        [self createUntechableAfterPaymentCheck];
    } else {
        if( [userPurchases isSubscriptionValid] ){
            [self createUntechableAfterPaymentCheck];
        } else{
            [self showOrLoadProductsForPurchase:YES];
        }
    }
}

/**
 * Create Untechable in free,without paid services (call/sms notifications)
 */
-(void)createFreeUntechable{
    //1-
    //Remove all sms / call flags, user wants free Untechable
    [untechable.commonFunctions delCallAndSmsStatus:untechable.customizedContactsForCurrentSession];
    
    //2-
    [self createUntechableAfterPaymentCheck];
}

/**
 * Create Untechable without payment
 */
-(void)createUntechableAfterPaymentCheck{
    // Background work
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
 * When products loaded from apple store then show, else load 
 * @param: For handling recursion deadlock we have this flag
 */
-(void)showOrLoadProductsForPurchase:(BOOL)canLoadProduct {
    
    if( userPurchases.productArray.count > 1) {
        [self showAlert:1];
    } else if( canLoadProduct ){
        
        [userPurchases loadAllProducts:^(NSString *errorMsg){
            
            if( [errorMsg isEqualToString:@""] ){
                [self showOrLoadProductsForPurchase:NO];
            } else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error occured while loading products"
                                                                message:errorMsg
                                                               delegate:self
                                                      cancelButtonTitle:@"Close"
                                                      otherButtonTitles: nil];
                alert.tag = 0;
                [alert show];
            }
        }];
        
    } else {
        [self changeNavigation:@"ERROR_ON_FINISH"];
    }
}

/**
 * Create Untechable on response
 */
-(void)handlePurchaseProductResponse:(NSString *)msg{
    if ( [msg isEqualToString:SUCCESS] ) {
        [self createUntechableAfterPaymentCheck];
    }
    else if ( [msg isEqualToString:CANCEL] ) {
        [self changeNavigation:@"ALERT_CANCEL"];
    }
    else{
        [self changeNavigation:@"ERROR_ON_FINISH"];
        [untechable.commonFunctions showAlert:@"Error in purchase" message:msg];
    }
}

/**
 * All ui alerts at one place
 */
-(void)showAlert:(int)tag{

    //Show products in alert
    if( tag == 1 ){
        NSMutableDictionary *prodDic = userPurchases.productArray[0];
        NSString *monthlySubs = [NSString stringWithFormat:@"%@ - %@",
                                 [prodDic objectForKey:@"packagename"],
                                 [prodDic objectForKey:@"packageprice"]];
        
        prodDic = userPurchases.productArray[1];
        NSString *yearlySubs = [NSString stringWithFormat:@"%@ - %@",
                                [prodDic objectForKey:@"packagename"],
                                [prodDic objectForKey:@"packageprice"]];
        
        // Show alert before start of match to purchase our product
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase Subscription"
                                                        message:@"You can purchase monthly and yearly subscription"
                                                       delegate:self
                                              cancelButtonTitle:@"Not now"
                                              otherButtonTitles: monthlySubs, yearlySubs , @"Restore", nil];
        alert.tag = tag;
        [alert show];
    }
    //Show create Untechable in free without sms/call, offer in alert
    else if( tag == 2 ){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Note"
                                                        message:@"App will not allow Call/SMS to your selected contact without premium subscription but Social Media Status and email we will be sent to your contacts"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles: @"Ok", nil];
        alert.tag = tag;
        [alert show];
    }
    
}

/**
 * Alert view delegate functions
 */
-(void)alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //Alert tag = 0, while loading product cause an error prompts the alert
    if( alertView.tag == 0 ) {
        [self changeNavigation:@"ALERT_CANCEL"];
    }
    //Alert tag = 1, while showing products in alert
    else if( alertView.tag == 1 ) {
        
        //Purchase monthly / yearly subscription
        if(buttonIndex == 1 || buttonIndex == 2) {
            NSString *productidentifier = ( buttonIndex == 1 ) ? PRO_MONTHLY_SUBS : PRO_YEARLY_SUBS;
            [userPurchases purchaseProductID:productidentifier callBack:^(NSString *msg){
                [self handlePurchaseProductResponse:msg];
            }];
        }
        //Restore purchase
        else if (buttonIndex == 3){
            [userPurchases restorePurchase:^(NSString *msg){
                [self handlePurchaseProductResponse:msg];
            }];
        }
        else{
            [self showAlert:2];
        }
    }
    //Create Untechable without call / sms
    else if( alertView.tag == 2 ){
        if( buttonIndex == 1 ){
            [self createFreeUntechable];
        }
        //Cancel
        else {
            [self changeNavigation:@"ALERT_CANCEL"];
        }
    }
}
@end