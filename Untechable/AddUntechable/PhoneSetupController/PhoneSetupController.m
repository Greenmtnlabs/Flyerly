//
//  PhoneSetupController.m
//  Untechable
//
//  Created by ABDUL RAUF on 24/09/2014.
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//

#import "PhoneSetupController.h"
#import "SocialnetworkController.h"
#import "Common.h"
#import "BSKeyboardControls.h"
#import "InviteScreen/InviteFriendsController.h"
#import "RecordController.h"

# define MSG_FORWADING_1 @"Get A Number"
# define MSG_FORWADING_2 @"Please wait..."
# define MSG_FORWADING_3 @"Forward call here"



@interface PhoneSetupController (){
    NSString *tableViewFor;
}

@property (strong, nonatomic) IBOutlet UIButton *btnforwardingNumber;
@property (strong, nonatomic) IBOutlet UITextField *inputForwadingNumber;

@property (strong, nonatomic) IBOutlet UILabel *lblLocation;
@property (strong, nonatomic) IBOutlet UITextField *inputLocation;


@property (strong, nonatomic) IBOutlet UILabel *lblEmergencyNumber;
@property (strong, nonatomic) IBOutlet UITextField *inputEmergencyNumber;

@property (strong, nonatomic) IBOutlet UIButton *btnImport;

@property (strong, nonatomic) IBOutlet UITableView *contactsTableView;
@property (strong, nonatomic) IBOutlet UILabel *lblCanContactTxt;


@property (strong, nonatomic) UIAlertView *importContacts, *getANumberAlert;

@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

@end

@implementation PhoneSetupController



@synthesize untechable;



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
    
    [self tableViewSR:@"start" callFor:@"contactsTableView"];
    
    NSArray *fields = @[ self.inputEmergencyNumber, self.inputLocation, self.inputForwadingNumber];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self updateUI];
}

/**
 * Update the view once it appears.
 */
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [untechable setOrSaveVars:SAVE];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 Hide keyboard on done button of keyboard press
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
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
    
    defGreen = [UIColor colorWithRed:66.0/255.0 green:247.0/255.0 blue:206.0/255.0 alpha:1.0];//GREEN
    defGray = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1.0];//GRAY
    
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES]; //show navigation bar
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

-(void)setNavigation:(NSString *)callFrom
{
    if([callFrom isEqualToString:@"viewDidLoad"])
    {
        
       
         // Left Navigation ___________________________________________________________
        backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        backButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_LEFT_SIZE];
        [backButton setTitle:TITLE_BACK_TXT forState:normal];
        [backButton setTitleColor:defGray forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(btnBackTouchStart) forControlEvents:UIControlEventTouchDown];
        [backButton addTarget:self action:@selector(btnBackTouchEnd) forControlEvents:UIControlEventTouchUpInside];
        
        
        backButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        NSMutableArray  *leftNavItems  = [NSMutableArray arrayWithObjects:leftBarButton,nil];
        
        [self.navigationItem setLeftBarButtonItems:leftNavItems]; //Left button ___________
       
        
        // Center title __________________________________________________
        self.navigationItem.titleView = [untechable.commonFunctions navigationGetTitleView];
        
        
        // Right Navigation ______________________________________________
        nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
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
    [untechable goBack:self.navigationController];    
}

-(void)onNext{

    [self storeSceenVarsInDic];
    
    [self setNextHighlighted:NO];
    
    BOOL goToNext = YES;
    
    if( [untechable.twillioNumber isEqualToString:@""] ){
        UIAlertView *temAlert = [[UIAlertView alloc ]
                                 initWithTitle:@""
                                 message:@"Forwarding number required."
                                 delegate:self
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [temAlert show];
    }
    else if( goToNext ) {
        RecordController *recordController;
        recordController = [[RecordController alloc]initWithNibName:@"RecordController" bundle:nil];
        recordController.untechable = untechable;
        [self.navigationController pushViewController:recordController animated:YES];
    }
}

-(void)storeSceenVarsInDic{
    untechable.twillioNumber = _inputForwadingNumber.text;
    untechable.location = _inputLocation.text;
    untechable.emergencyNumber = _inputEmergencyNumber.text;
    //untechable.emergencyContacts = untechable.emergencyContacts; //no need
    
    [untechable setOrSaveVars:SAVE];
}

#pragma mark -  Model funcs
-(void)setDefaultModel{
    untechable.commonFunctions = [[CommonFunctions alloc] init];
}

#pragma mark -  UI functions
-(void)updateUI
{
    
    [self.btnforwardingNumber setTitleColor:defGray forState:UIControlStateNormal];
    self.btnforwardingNumber.titleLabel.font = [UIFont fontWithName:APP_FONT size:20];
    
    self.inputForwadingNumber.userInteractionEnabled = NO;
    [self.inputForwadingNumber setTextColor:defGreen];
    self.inputForwadingNumber.font = [UIFont fontWithName:APP_FONT size:16];
    self.inputForwadingNumber.delegate = self;

    if( ![untechable.twillioNumber isEqualToString:@""] ){
        [self.inputForwadingNumber setText:untechable.twillioNumber];
        [self.btnforwardingNumber setTitle:MSG_FORWADING_3 forState:UIControlStateNormal];
        self.btnforwardingNumber.userInteractionEnabled = NO;
    }
    
    
    [_lblLocation setTextColor:defGray];
    _lblLocation.font = [UIFont fontWithName:APP_FONT size:20];
    
    [self.inputLocation setTextColor:defGreen];
    self.inputLocation.font = [UIFont fontWithName:APP_FONT size:16];
    self.inputLocation.delegate = self;
    
    if( ![untechable.location isEqualToString:@""] )
    [self.inputLocation setText:untechable.location];

    
    [_lblEmergencyNumber setTextColor:defGray];
    _lblEmergencyNumber.font = [UIFont fontWithName:APP_FONT size:20];
    
    
    [self.inputEmergencyNumber setTextColor:defGreen];
    self.inputEmergencyNumber.font = [UIFont fontWithName:APP_FONT size:16];
    self.inputEmergencyNumber.delegate = self;
    [self.inputEmergencyNumber setText:untechable.emergencyNumber];
    
    if( ![untechable.twillioNumber isEqualToString:@""] )
    [self.inputEmergencyNumber setText:untechable.emergencyNumber];

    [self tableViewSR:@"reStart" callFor:@"contactsTableView"];
    
    
    
    [self.btnImport setTitleColor:defGray forState:UIControlStateNormal];
    self.btnImport.titleLabel.font = [UIFont fontWithName:APP_FONT size:20];
    
    [_lblCanContactTxt setTextColor:defGray];
    _lblCanContactTxt.font = [UIFont fontWithName:APP_FONT size:15];
    
    
}


-(IBAction)getForwardingNum {
    if( [self.btnforwardingNumber.titleLabel.text isEqualToString:MSG_FORWADING_1] ){
        _getANumberAlert = [[UIAlertView alloc ]
                           initWithTitle:@""
                           message:@"Would you like to purchase a forwarding number? This number will have a customizeable auto-response feature & can be used to forward your calls to while you're away."
                           delegate:self
                           cancelButtonTitle:@"No"
                           otherButtonTitles:@"Yes" ,
                           nil];
        [_getANumberAlert show];
    }
}
-(void)getForwadingNumAfterAllow {
    [self.btnforwardingNumber setTitle:MSG_FORWADING_2 forState:UIControlStateNormal];
    
    NSString *API_GETNUM = [NSString stringWithFormat:@"%@?userId=%@",API_GET_NUMBER,untechable.userId];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:API_GETNUM]];
    [request setHTTPMethod:@"GET"];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    // NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    if( returnData != nil ){
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"In response of save api: %@",dict);
        
        if( [[dict valueForKey:@"status"] isEqualToString:@"OK"] ) {
            untechable.eventId       = [dict valueForKey:@"eventID"];
            untechable.twillioNumber = [dict valueForKey:@"number"];
            self.inputForwadingNumber.text = untechable.twillioNumber;
            
            [untechable setOrSaveVars:SAVE];
            
            [self.btnforwardingNumber setTitle:MSG_FORWADING_3 forState:UIControlStateNormal];
            self.btnforwardingNumber.userInteractionEnabled = NO;
        }
        else if( [[dict valueForKey:@"code"] isEqualToString:@"number_unavailable"] ) {
            [self.btnforwardingNumber setTitle:MSG_FORWADING_1 forState:UIControlStateNormal];
            self.btnforwardingNumber.userInteractionEnabled = YES;
            
            UIAlertView *temAlert = [[UIAlertView alloc ]
                                initWithTitle:@""
                                message:[dict valueForKey:@"message"]
                                delegate:self
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil];
            [temAlert show];
        }
        
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
            //NSLog(@"tableViewSR restart untechable.emergencyContacts = %@",untechable.emergencyContacts);
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
    
    
   // NSLog(@"getCountForTableView Count of %@ : %ld", tableViewFor, (long)count);
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

            [untechable.commonFunctions deleteKeyFromDic:untechable.emergencyContacts delKeyAtIndex:indexPath.row];
            
            [self tableViewSR:@"reStart" callFor:@"contactsTableView"];
        }
    }
    
}




#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView == _getANumberAlert && buttonIndex == 1) {
        [self getForwadingNumAfterAllow];
    }
    else if(alertView == _importContacts && buttonIndex == 1) {
        [self importContactsAfterAllow];
    }
}


#pragma mark -  Import Contacts
//Show select contacts screen
- (IBAction)importContacts:(id)sender {
    InviteFriendsController *ifc;
    ifc = [[InviteFriendsController alloc]initWithNibName:@"InviteFriendsController" bundle:nil];
    ifc.untechable = untechable;
    [self.navigationController pushViewController:ifc animated:YES];
}

- (IBAction)importContacts2:(id)sender {
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
    [self getAllContacts];
    [self tableViewSR:@"reStart" callFor:@"contactsTableView"];
}


-(void)getAllContacts{
    CFErrorRef *error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    
    for(int i = 0; i < numberOfPeople; i++) {
        
        ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
        
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        
        #ifdef DEBUG
                NSLog(@"Name:%@ %@", firstName, lastName);
        #endif
      
        
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
            NSString *phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);

            #ifdef DEBUG
                NSLog(@"phone:%@", phoneNumber);
            #endif
        }
        
        NSLog(@"=============================================");
        
    }
}
@end
