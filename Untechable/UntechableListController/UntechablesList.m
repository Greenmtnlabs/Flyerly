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
#import "Common.h"
#import "Untechable.h"

@interface UntechablesList () {
    
    NSMutableArray *allUntechables;
    int sectionOneCount;
    int sectionTwoCount;
    
    NSMutableArray *sectionOneArray;
    NSMutableArray *sectionTwoArray;
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
    [untechable printNavigation:[self navigationController]];
    
}

#pragma mark -  Navigation functions
- (void)setNavigationDefaults{
    
    /*
     NSDateFormatter *df = [[NSDateFormatter alloc] init];
     [df setDateFormat:@"EEEE, dd MMMM yyyy HH:mm"];
     NSDate *date = [df dateFromString:@"Sep 25, 2014 05:27 PM"];
     NSLog(@"\n\n  DATE: %@ \n\n\n", date);
     */
    
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
        
        // Center title __________________________________________________
        self.navigationItem.titleView = [untechable.commonFunctions navigationGetTitleView];
        
        // Right Navigation ______________________________________________
        nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        //[nextButton setBackgroundColor:[UIColor redColor]];//for testing
        
        nextButton.titleLabel.shadowColor = [UIColor clearColor];
        //nextButton.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
        
        
        //[nextButton setBackgroundImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
        nextButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [nextButton setTitle:TITLE_NEW_TXT forState:normal];
        [nextButton setTitleColor:defGray forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(addUntechable) forControlEvents:UIControlEventTouchUpInside];
        
        
        nextButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton,nil];
        
        [self.navigationItem setRightBarButtonItems:rightNavItems];//Right button ___________
        
        
    }
}

-(void)addUntechable{
    AddUntechableController *addUntechable;
    addUntechable = [[AddUntechableController alloc]initWithNibName:@"AddUntechableController" bundle:nil];
    //addUntechable.untechable = untechable;
    [self.navigationController pushViewController:addUntechable animated:YES];
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
    
    //init object
    untechable  = [[Untechable alloc] init];
    untechable.commonFunctions = [[CommonFunctions alloc] init];
    
    //For testing -------- { --
    [self configureTestData];
    //For testing -------- } --
    
    allUntechables = [untechable.commonFunctions getAllUntechables:untechable.userId];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    
    untechablesTable.separatorInset = UIEdgeInsetsZero;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setDefaultModel];
    
    [self setNavigationDefaults];
    [self setNavigation:@"viewDidLoad"];
    [self setNumberOfRowsInSection];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"UntechableTableCell";
    UntechableTableCell *cell = (UntechableTableCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    
    if ( cell == nil ) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UntechableTableCell" owner:self options:nil];
        cell = (UntechableTableCell *)[nib objectAtIndex:0];
        
        NSMutableDictionary *tempDict;
        
        if ( indexPath.section == 0 ){
             tempDict = [sectionOneArray objectAtIndex:indexPath.row];
        }else if ( indexPath.section == 1 ){
             tempDict = [sectionTwoArray objectAtIndex:indexPath.row];
        }
        
        //Setting the packagename,packageprice,packagedesciption values for cell view
        [cell setCellValueswithUntechableTitle:[tempDict objectForKey:@"spendingTimeTxt"]
                                  StartDate:[untechable.commonFunctions timestampStrToAppDate:[tempDict objectForKey:@"startDate"]]
                                  EndDate:[untechable.commonFunctions timestampStrToAppDate:[tempDict objectForKey:@"endDate"]]];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( indexPath.section == 0 ){
        
        NSLog(@"%ld",indexPath.row );
        NSMutableDictionary *tempDict = [sectionOneArray objectAtIndex:indexPath.row];

        AddUntechableController *addUntechable;
        addUntechable = [[AddUntechableController alloc]initWithNibName:@"AddUntechableController" bundle:nil];
        
        addUntechable.indexOfUntechableInEditMode = [[tempDict objectForKey:@"index"] intValue];
        addUntechable.callReset = @"RESET1";
        
        [self.navigationController pushViewController:addUntechable animated:YES];
        
    }else if ( indexPath.section == 1 ){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"." message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }

}

- (void) setNumberOfRowsInSection {
    
    NSDate *currentDate = [NSDate date];
    
    sectionOneArray = [[NSMutableArray alloc] init];
    sectionTwoArray = [[NSMutableArray alloc] init];
    sectionOneCount = 0;
    sectionTwoCount = 0;
    
    for (int i=0 ; i < allUntechables.count ; i++){
        NSMutableDictionary *tempDict = [allUntechables objectAtIndex:i];
        [tempDict setObject:[NSNumber numberWithInt:i] forKey:@"index"];
        
        NSDate *startDate = [untechable.commonFunctions timestampStrToNsDate:[tempDict objectForKey:@"startDate"]];
        if ( ![untechable.commonFunctions date1IsSmallerThenDate2:startDate date2:currentDate] ){
            sectionOneCount++;
            [sectionOneArray addObject:tempDict];
        }else{
            sectionTwoCount++;
            [sectionTwoArray addObject:tempDict];
        }
    }
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int numberOfRowsInSection;
    if ( section == 0 ){
        numberOfRowsInSection = sectionOneCount;
    }else if ( section == 1 ){
        numberOfRowsInSection = sectionTwoCount;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
