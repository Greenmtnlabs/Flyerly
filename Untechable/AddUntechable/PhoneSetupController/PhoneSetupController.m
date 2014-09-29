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

@interface PhoneSetupController (){
    NSString *tableViewFor;
    CommonFunctions *commonFunctions;
}

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// ________________________     Custom functions    ___________________________
#pragma mark -  Navigation functions

- (void)setNavigationDefaults{
    defBlueColor =  [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];

    [[self navigationController] setNavigationBarHidden:NO animated:YES]; //show navigation bar
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

-(void)setNavigation:(NSString *)callFrom
{
    if([callFrom isEqualToString:@"viewDidLoad"])
    {
        // Center title ________________________________________
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        titleLabel.backgroundColor = [UIColor clearColor];
        //titleLabel.font = [UIFont fontWithName:TITLE_FONT size:18];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = defBlueColor;
        titleLabel.text = @"Phone Setup";
        
        self.navigationItem.titleView = titleLabel; //Center title ___________
        
        
        // Right Navigation ________________________________________
        nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
        [nextButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
        //[nextButton setBackgroundImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
        [nextButton setTitle:@"Next" forState:normal];
        [nextButton setTitleColor:defBlueColor forState:UIControlStateNormal];
        
        nextButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton,nil];
        
        [self.navigationItem setRightBarButtonItems:rightNavItems];//Right buttons ___________
        
        
    }
}

-(void)onNext{
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
    
    if( !([untechable.forwardingNumber isEqualToString:@""]) ){
        [self setTextIn:@"btnforwardingNumber" str:untechable.startDate];
    }
}

-(IBAction)getForwardingNum{
    if( [self.btnforwardingNumber.titleLabel.text isEqualToString:@"Click here to get Forwarding #"] ){
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
        [cell.detailTextLabel setText:number];
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
        NSDictionary *dic = @{@"Khurram ali": @"222222222222",
                                         @"Ozair": @"33333333333333",
                                         @"Rehan ali": @"444444444",
                                         @"Abdul Rauf": @"00923453017449"};
        
        [untechable.emergencyContacts setDictionary:dic];

        //[commonFunctions sortDic:untechable.emergencyContacts]; //zarorat nhe pari , ya auto sort kar raha hy
        
        [self tableViewSR:@"reStart" callFor:@"contactsTableView"];
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

@end
