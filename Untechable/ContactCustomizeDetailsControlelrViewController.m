//
//  ContactCustomizeDetailsControlelrViewController.m
//  Untechable
//
//  Created by RIKSOF Developer on 12/26/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "ContactCustomizeDetailsControlelrViewController.h"
#import "FirstTableViewCell.h"
#import "PhoneNumberCell.h"
#import "EmailCell.h"
#import "CustomTextTableViewCell.h"
#import "Common.h"

@interface ContactCustomizeDetailsControlelrViewController (){

    int rowsInFirstSection,rowsInSecondSection;
    NSArray *phoneNumberTypes;
}
@property (weak, nonatomic) IBOutlet UITableView *contactDetailsTable;

@end

@implementation ContactCustomizeDetailsControlelrViewController

@synthesize contactModal,untechable;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationDefaults];
    [self setNavigation:@"viewDidLoad"];

    phoneNumberTypes = [contactModal.allPhoneNumbers allKeys];
    
    _contactDetailsTable.delegate = self;
    _contactDetailsTable.dataSource = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        /*
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
        
        [self.navigationItem setRightBarButtonItems:rightNavItems];//Right button ___________*/
    }
}

-(void) goBack {
    [untechable setOrSaveVars:SAVE];
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


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int numberOfRowsInSection;
    if ( section == 0 ){
        numberOfRowsInSection = 1;
    }else if ( section == 1 ){
        numberOfRowsInSection = (int)contactModal.allPhoneNumbers.count;
    }else if ( section == 2 ){
        numberOfRowsInSection = (int)contactModal.allEmails.count;
    }else if ( section == 3 ){
        numberOfRowsInSection = 1;
    }
    //return sectionHeader;
    return  numberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if ( indexPath.section == 0 ){
        static NSString *cellId = @"FirstTableViewCell";
        FirstTableViewCell *cell = (FirstTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FirstTableViewCell" owner:self options:nil];
        cell = (FirstTableViewCell *)[nib objectAtIndex:0];
        
        [cell setCellValues:contactModal.name ContactModal:contactModal];
        
        return cell;
    }else if ( indexPath.section == 1 ){
        
        static NSString *cellId = @"PhoneNumberCell";
        PhoneNumberCell *cell = (PhoneNumberCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PhoneNumberCell" owner:self options:nil];
        cell = (PhoneNumberCell *)[nib objectAtIndex:0];

        [cell setCellValues:[phoneNumberTypes objectAtIndex:indexPath.row] Number:[contactModal.allPhoneNumbers objectForKey:[phoneNumberTypes objectAtIndex:indexPath.row]]];
        
        cell.untechable = untechable;
        
        [cell setCellModal:contactModal];
        
        [cell.smsButton addTarget:self
                   action:@selector(smsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

        [cell.callButton addTarget:self
                           action:@selector(callButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
        
    }else if ( indexPath.section == 2 ){
        
        static NSString *cellId = @"EmailCell";
        EmailCell *cell = (EmailCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EmailCell" owner:self options:nil];
        cell = (EmailCell *)[nib objectAtIndex:0];
        
        NSMutableArray *aar = [[NSMutableArray alloc] initWithArray:contactModal.allEmails];
        
        [cell setCellValues: [aar objectAtIndex:indexPath.row]];
        
        cell.untechable = untechable;
        
        [cell setCellModal:contactModal];
        
        return cell;
        
    }else if ( indexPath.section == 3 ){
        
        static NSString *cellId = @"CustomText";
        CustomTextTableViewCell *cell = (CustomTextTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomTextTableViewCell" owner:self options:nil];
        cell = (CustomTextTableViewCell *)[nib objectAtIndex:0];
        
        [cell setCellValues: untechable.spendingTimeTxt];
        
        [cell setCellModal:contactModal];
        
        return cell;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(IBAction)smsButtonTapped:(id) sender
{
    PhoneNumberCell *cell = (PhoneNumberCell *)[[sender superview] superview];
    
    NSLog(@"%@", cell.nubmerType.text);
    
    BOOL alreadyExist = NO;
    
    for ( int i = 0; i < untechable.customizedContacts.count; i++ ){
        ContactsCustomizedModal *tempModal = [[ContactsCustomizedModal alloc] init];
        
        tempModal = [untechable.customizedContacts objectAtIndex:i];
        
        if ( [tempModal.name isEqualToString:contactModal.name] ){
            
            alreadyExist = YES;
        }
    }
    
    if ( alreadyExist ){
        
    }else {
        
        NSMutableArray *numberWithStatus = [[NSMutableArray alloc] initWithCapacity:3];
        
        // Phone Number at index 0 of this array
        [numberWithStatus setObject:cell.nubmer.text atIndexedSubscript:0];
        
        // SMS status at index 1 of this array
        [numberWithStatus setObject:@"1" atIndexedSubscript:1];
        
        NSMutableArray *phoneNumbersArray = [[NSMutableArray alloc] init];
        
        [phoneNumbersArray addObject:numberWithStatus];
        
        [contactModal.allPhoneNumbers setValue:phoneNumbersArray forKey:@"phoneNumbers"];
        
        NSMutableArray *customizedContactsModals = [[NSMutableArray alloc] init];
        
        [customizedContactsModals addObject:contactModal];
        
        untechable.customizedContacts = customizedContactsModals;
        
        //-(NSArray *)convertJsonStringIntoArray:(NSString *)value
        
        //[untechable.customizedContacts addObject:contactDict];
        /*
        
        NSMutableArray *temp = [[NSMutableArray alloc] init];
    
        NSMutableArray *contactArray = [[NSMutableArray alloc] init];
        
        NSMutableDictionary *contactDict = [[NSMutableDictionary alloc] init];
        
        [contactDict setObject:contactModal forKey:contactModal.name];
        
        NSMutableDictionary *status = [[NSMutableDictionary alloc] init];
        
        NSMutableArray *allStatus = [[ NSMutableArray alloc] initWithCapacity:2];
        
        [allStatus insertObject:@"YES" atIndex:0];
        
        [status setObject:allStatus forKey:cell.nubmerType.text];
        
        [temp addObject:status];
        
        [temp_ addObject:contactModal];
        
        contactModal.phoneNumbersStatus  = temp;
        
        //-(NSArray *)convertJsonStringIntoArray:(NSString *)value
        untechable.customizedContacts = [untechable.commonFunctions convertArrayIntoJsonString:temp_];
        //[untechable.customizedContacts addObject:contactDict];*/
    }
}

-(IBAction)callButtonTapped:(id) sender
{
    
}


@end
