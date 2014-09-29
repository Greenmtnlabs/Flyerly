//
//  PhoneSetupController.m
//  Untechable
//
//  Created by Muhammad Raheel on 24/09/2014.
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//

#import "PhoneSetupController.h"
#import "CommonFunctions.h"
#import "SocialnetworkController.h"
#import "Common.h"

@interface PhoneSetupController (){
    NSString *tableViewFor;
    CommonFunctions *commonFunctions;
}
@property (strong, nonatomic) IBOutlet UILabel *canContactTxt;
@property (strong, nonatomic) IBOutlet UIButton *btnImport;


@property (strong, nonatomic) IBOutlet UITableView *contactsTableView;
@property (strong, nonatomic) UIAlertView *importContacts;

@end

@implementation PhoneSetupController



@synthesize untechable;
@synthesize btnforwardingNumber;


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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// ________________________     Custom functions    ___________________________
#pragma mark -  UI functions
-(void)updateUI
{    
    _canContactTxt.font = [UIFont fontWithName:APP_FONT size:15];
    
    self.btnforwardingNumber.titleLabel.font = [UIFont fontWithName:APP_FONT size:20];
    self.btnImport.titleLabel.font = [UIFont fontWithName:APP_FONT size:20];
}

#pragma mark -  Navigation functions

- (void)setNavigationDefaults{
    
    defGreen = [UIColor colorWithRed:66.0/255.0 green:247.0/255.0 blue:206.0/255.0 alpha:1.0];//GREEN
    defGray = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1.0];//GRAY
    
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES]; //show navigation bar
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

-(void)setNavigation:(NSString *)callFrom
{
    if([callFrom isEqualToString:@"viewDidLoad"])
    {
        
       
         // Left Navigation ________________________________________________________________________________________________________
         backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
        [backButton addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
        backButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_LEFT_SIZE];
        [backButton setTitle:TITLE_BACK_TXT forState:normal];
        [backButton setTitleColor:defGray forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(btnBackTouchStart) forControlEvents:UIControlEventTouchDown];
        [backButton addTarget:self action:@selector(btnBackTouchEnd) forControlEvents:UIControlEventTouchUpInside];
        
        
        backButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        NSMutableArray  *leftNavItems  = [NSMutableArray arrayWithObjects:leftBarButton,nil];
        
        [self.navigationItem setLeftBarButtonItems:leftNavItems]; //Left button ___________
       
        
        // Center title ________________________________________
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_FONT_SIZE];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = defGreen;
        titleLabel.text = APP_NAME;
        
        
        self.navigationItem.titleView = titleLabel; //Center title ___________
        
        
        // Right Navigation ________________________________________
        nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
        [nextButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
        nextButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [nextButton setTitle:TITLE_NEXT_TXT forState:normal];
        [nextButton setTitleColor:defGray forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(btnNextTouchStart) forControlEvents:UIControlEventTouchDown];
        [nextButton addTarget:self action:@selector(btnNextTouchEnd) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        nextButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton,nil];
        
        [self.navigationItem setRightBarButtonItems:rightNavItems];//Right buttons ___________
        
        
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

-(void)btnBackTouchStart{
    [self setBackHighlighted:YES];
}
-(void)btnBackTouchEnd{
    [self setBackHighlighted:NO];
    [self onBack];
}
- (void)setBackHighlighted:(BOOL)highlighted {
    (highlighted) ? [backButton setBackgroundColor:defGreen] : [backButton setBackgroundColor:[UIColor clearColor]];
}

-(void)onBack{
    [self.navigationController popViewControllerAnimated:YES];
    // Remove observers
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)onNext{

    [self setNextHighlighted:NO];
    
    BOOL goToNext = YES;
    
    if( goToNext ) {
        SocialnetworkController *socialnetwork;
        socialnetwork = [[SocialnetworkController alloc]initWithNibName:@"SocialnetworkController" bundle:nil];
        socialnetwork.untechable = untechable;
        [self.navigationController pushViewController:socialnetwork animated:YES];
    }
}

#pragma mark -  Model funcs
-(void)setTextIn:(NSString *)txtIn str:(NSString *)txt{
    if( [txtIn isEqualToString:@"btnforwardingNumber"] ) {
      [self.btnforwardingNumber setTitle:txt forState:UIControlStateNormal];
    }
}

-(void)setDefaultModel{
    
    commonFunctions = [[CommonFunctions alloc] init];
    
    [self tableViewSR:@"start" callFor:@"contactsTableView"];
    [self importContactsAfterAllow];//for testing
    
    if( !([untechable.forwardingNumber isEqualToString:@""]) ){
        [self setTextIn:@"btnforwardingNumber" str:untechable.startDate];
    }
}

-(IBAction)getForwardingNum{
    if( [self.btnforwardingNumber.titleLabel.text isEqualToString:@"Get Forwarding #"] ){
        [self setTextIn:@"btnforwardingNumber" str:@"Please wait..."];
        
        double delayInSeconds = 3.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self setTextIn:@"btnforwardingNumber" str:@"123"];
        });

    }
}

#pragma mark -  Table view functions
-(void)tableViewSR:(NSString*)startRestart callFor:callFor{
    
    if( [startRestart isEqualToString:@"start"] ){
        
        if( [callFor isEqualToString:@"contactsTableView"] ) {
            tableViewFor = @"contactsTableView";
            _contactsTableView.allowsMultipleSelectionDuringEditing = NO;
            _contactsTableView.dataSource = self;
        }
    }
    else if( [startRestart isEqualToString:@"reStart"] ){
        
        if( [callFor isEqualToString:@"contactsTableView"] ) {
           NSLog(@"tableViewSR restart untechable.emergencyContacts = %@",untechable.emergencyContacts);
            _contactsTableView.allowsMultipleSelectionDuringEditing = NO;
            tableViewFor = @"contactsTableView";
            [_contactsTableView reloadData];
        }
    }
    
}
-(NSInteger)getCountOf:(NSString *)contOf {
    NSInteger count = 0;

    if([contOf isEqualToString:@"contactsTableView"]) {
        NSArray * allKeys = [untechable.emergencyContacts allKeys];
        count   =   [allKeys count];
    }
    
    
    NSLog(@"getCountForTableView Count of %@ : %d", tableViewFor, count);
    return count;
}

//3
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self getCountOf:tableViewFor];
}
//4
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //5
    static NSString *cellIdentifier = @"SettingsCell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    UITableViewCell *cell = nil;
    //5.1 you do not need this if you have set SettingsCell as identifier in the storyboard (else you can remove the comments on this code)
    if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
       }

    if([tableViewFor isEqualToString:@"contactsTableView"]) {
        
         //get sorted keys
         NSArray *arrayOfKeys = [[untechable.emergencyContacts allKeys] sortedArrayUsingSelector: @selector(compare:)];
        //NSLog(@"Keys: %@", arrayOfKeys);
        //NSArray *arrayOfValues = [untechable.emergencyContacts allValues];
        //NSLog(@"Values: %@", arrayOfValues);
        
        
        //6
        //NSString *txt = [NSString stringWithFormat:@"My friend name %i", indexPath.row ];
        //NSString *number = [arrayOfValues objectAtIndex:indexPath.row];
        NSString *name = [arrayOfKeys objectAtIndex:indexPath.row];
        NSString *number = [untechable.emergencyContacts objectForKey:name];
       
        
        
        //7
        [cell.textLabel setText:name];
        cell.textLabel.textColor = defGreen;
        [cell.detailTextLabel setText:number];
        cell.detailTextLabel.textColor = defGray;
    }
    return cell;
}

// Override to support editing the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    //add code here for when you hit delete
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        if( [tableViewFor isEqualToString:@"contactsTableView"] ) {

            [commonFunctions deleteKeyFromDic:untechable.emergencyContacts delKeyAtIndex:indexPath.row];
            
            [self tableViewSR:@"reStart" callFor:@"contactsTableView"];
        }
    }
    
}




#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView == _importContacts && buttonIndex == 1) {
        [self importContactsAfterAllow];
    }
}

#pragma mark -  Import Contacts
- (IBAction)importContacts:(id)sender {
    _importContacts = [[UIAlertView alloc ]
                                       initWithTitle:@""
                                       message:@"Untechable want to import your contacts"
                                       delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:@"Allow" ,
                                   nil];
    [_importContacts show];
    
}
-(void)importContactsAfterAllow {
    NSDictionary *dic = @{@"Khurram ali": @"3333333333",
                          @"Ozair": @"5555555555",
                          @"Rehan ali": @"7777777777",
                          @"Abdul Rauf": @"00923453017449",
                          @"Raheel Mateen": @"6666666666",
                          @"Arbab": @"2222222222",
                          @"M.Zeshan": @"4444444444",
                          @"Zeshan Lalani": @"00923453017449",
                          @"Shoaib": @"9999999999",
                          @"Sharjeel Shahni": @"8888888888"
                          };
    
    [untechable.emergencyContacts setDictionary:dic];
    
    //[commonFunctions sortDic:untechable.emergencyContacts]; //zarorat nhe pari , ya auto sort kar raha hy
    
    [self tableViewSR:@"reStart" callFor:@"contactsTableView"];
}

@end
