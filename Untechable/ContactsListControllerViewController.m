
//
//  ContactsListControllerViewController.m
//  Untechable
//
//  Created by RIKSOF Developer on 12/23/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "ContactsListControllerViewController.h"
#import "ContactListCell.h"
#import "ContactsCustomizedModal.h"
#import "ContactCustomizeDetailsControlelrViewController.h"
#import "SocialnetworkController.h"
#import "Common.h"
#import "ContactsCustomizedModal.h"
#import "EmailSettingController.h"
#import "EmailChangingController.h"
#import "SocialNetworksStatusModal.h"
#import "AddUntechableController.h"

@interface ContactsListControllerViewController () {
    
    NSMutableDictionary *customizedContactsDictionary;
    NSString *customizedContactsString;
    BOOL selectedAnyEmail;
}

@property (strong, nonatomic) IBOutlet UITableView *contactsTable;

@end

@implementation ContactsListControllerViewController

@synthesize contactModalsArray,contactsArray,contactBackupArray,searchTextField,selectedIdentifiers,untechable,currentlyEditingContacts;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationDefaults];
    
    _contactsTable.delegate = self;
    _contactsTable.dataSource = self;
    
    _contactsTable.contentInset = UIEdgeInsetsMake(-63.0f, 0.0f, 0.0f, 0.0f);
    
    [_contactsTable  setBackgroundColor:[UIColor colorWithRed:245/255.0 green:241/255.0 blue:222/255.0 alpha:1.0]];
    [searchTextField setReturnKeyType:UIReturnKeyDone];

    if ( untechable.customizedContactsForCurrentSession.count > 0 ){
        currentlyEditingContacts = untechable.customizedContactsForCurrentSession;
    }
    
    if ( currentlyEditingContacts == nil ){
        currentlyEditingContacts = [[NSMutableArray alloc] init];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self setNavigation:@"viewDidLoad"];
    
    contactBackupArray = nil;
    
    // Load device contacts
    [self loadLocalContacts];
    
    customizedContactsString = untechable.customizedContacts;
    
    selectedAnyEmail = NO;
    
    NSError *writeError = nil;
    customizedContactsDictionary =
    [NSJSONSerialization JSONObjectWithData: [customizedContactsString dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: &writeError];
    
    [_contactsTable reloadData];
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
        self.navigationItem.hidesBackButton = YES;
        
        // Center title __________________________________________________
        self.navigationItem.titleView = [untechable.commonFunctions navigationGetTitleView];
        
        // Back Navigation button
        backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        backButton.titleLabel.shadowColor = [UIColor clearColor];
        backButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [backButton setTitle:TITLE_BACK_TXT forState:normal];
        [backButton setTitleColor:defGray forState:UIControlStateNormal];
        //[backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchDown];
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        backButton.showsTouchWhenHighlighted = YES;
        
        UIBarButtonItem *lefttBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        [self.navigationItem setLeftBarButtonItem:lefttBarButton];//Left button ___________
        
        // Right Navigation ______________________________________________
        nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        //[nextButton setBackgroundColor:[UIColor redColor]];//for testing
        
        nextButton.titleLabel.shadowColor = [UIColor clearColor];
        //nextButton.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
        
        nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 33, 42)];
        [nextButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
        [nextButton setBackgroundImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
        nextButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [nextButton setTitle:TITLE_NEXT_TXT forState:normal];
        [nextButton setTitleColor:defGray forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(btnNextTouchStart) forControlEvents:UIControlEventTouchDown];
        [nextButton addTarget:self action:@selector(btnNextTouchEnd) forControlEvents:UIControlEventTouchUpInside];
        
        nextButton.showsTouchWhenHighlighted = YES;
        
        skipButton = [[UIButton alloc] initWithFrame:CGRectMake(33, 0, 33, 42)];
        skipButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_LEFT_SIZE];
        [skipButton setTitle:@"SKIP" forState:normal];
        [skipButton setTitleColor:defGray forState:UIControlStateNormal];
        [skipButton addTarget:self action:@selector(btnSkipTouchStart) forControlEvents:UIControlEventTouchDown];
        [skipButton addTarget:self action:@selector(btnSkipTouchEnd) forControlEvents:UIControlEventTouchUpInside];
        
        skipButton.showsTouchWhenHighlighted = YES;
        
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
        UIBarButtonItem *skipButtonBarButton = [[UIBarButtonItem alloc] initWithCustomView:skipButton];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton,skipButtonBarButton,nil];
        
        [self.navigationItem setRightBarButtonItems:rightNavItems];//Right button ___________
    }
}

-(void) goBack {

    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[AddUntechableController class]]) {
            
            untechable.customizedContactsForCurrentSession = currentlyEditingContacts;
            AddUntechableController *addViewController = (AddUntechableController *)controller;
            addViewController.untechable = untechable;
            [self.navigationController popToViewController:addViewController animated:YES];
            break;
        }
    }
}

-(void)storeSceenVarsInDic
{
    //untechable.spendingTimeTxt = _inputSpendingTimeText.text;
    //untechable.hasEndDate = !([_cbNoEndDate isSelected]);
    
    [untechable setOrSaveVars:SAVE];
}

- (void)setSkipHighlighted:(BOOL)highlighted {
    (highlighted) ? [skipButton setBackgroundColor:defGreen] : [skipButton setBackgroundColor:[UIColor clearColor]];
}

-(void)next:(NSString *)after{
    
    if( [after isEqualToString:@"GO_TO_NEXT"] || [after isEqualToString:@"ON_SKIP"] ) {
        
        currentlyEditingContacts = [[NSMutableArray alloc] init];
        [_contactsTable reloadData];
        
        SocialnetworkController *socialnetwork;
        socialnetwork = [[SocialnetworkController alloc]initWithNibName:@"SocialnetworkController" bundle:nil];
        socialnetwork.untechable = untechable;
        [self.navigationController pushViewController:socialnetwork animated:YES];
        
    }
}
-(void)btnSkipTouchStart{
    [self setSkipHighlighted:YES];
}
-(void)btnSkipTouchEnd{
    [self setSkipHighlighted:NO];
    [self onSkip];
}

-(void)onSkip{
    
    [self setSkipHighlighted:NO];
    
    [self storeSceenVarsInDic];
    //[self stopAllTask];
    
    [self next:@"ON_SKIP"];
    
}
-(void)onNext{

    if ( currentlyEditingContacts.count > 0 ){
        
        for (int i = 0;i<currentlyEditingContacts.count; i++){
            ContactsCustomizedModal *previousModal = [currentlyEditingContacts objectAtIndex:i];
            
            if ( [[previousModal.cutomizingStatusArray objectAtIndex:0] isEqualToString:@"1"] ){
                
                selectedAnyEmail = YES;
                break;
            }
        }
    }
    
    untechable.customizedContactsForCurrentSession = currentlyEditingContacts;
    
    if ( selectedAnyEmail  ){
        
        NSLog(@"%@", [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allValues]);
        
        NSArray *keys = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys];
        
        if (  [keys containsObject:EMAIL_KEY] || [keys containsObject:PASSWORD_KEY]  ){
            
            NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:EMAIL_KEY]);
            NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD_KEY]);
                         
            if ( [[[NSUserDefaults standardUserDefaults] objectForKey:EMAIL_KEY] isEqualToString:@""] ||
                [[[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD_KEY] isEqualToString:@""] ){
                
                EmailSettingController *emailSettingController;
                emailSettingController = [[EmailSettingController alloc]initWithNibName:@"EmailSettingController" bundle:nil];
                emailSettingController.untechable = untechable;
                emailSettingController.comingFromSettingsScreen = NO;
                emailSettingController.comingFromChangeEmailScreen = NO;
                emailSettingController.comingFromContactsListScreen = YES;
                [self.navigationController pushViewController:emailSettingController animated:YES];
                
            }else {
                
                EmailChangingController *emailChangeController;
                emailChangeController = [[EmailChangingController alloc]initWithNibName:@"EmailChangingController" bundle:nil];
                emailChangeController.untechable = untechable;
                emailChangeController.emailAddresstext = [[SocialNetworksStatusModal sharedInstance] getEmailAddress];
                [self.navigationController pushViewController:emailChangeController animated:YES];
            }
        }else {
            
            EmailSettingController *emailSettingController;
            emailSettingController = [[EmailSettingController alloc]initWithNibName:@"EmailSettingController" bundle:nil];
            emailSettingController.untechable = untechable;
            emailSettingController.comingFromSettingsScreen = NO;
            emailSettingController.comingFromChangeEmailScreen = NO;
            emailSettingController.comingFromContactsListScreen = YES;
            [self.navigationController pushViewController:emailSettingController animated:YES];
        }
    }else {
        
        SocialnetworkController *socialnetwork;
        socialnetwork = [[SocialnetworkController alloc]initWithNibName:@"SocialnetworkController" bundle:nil];
        socialnetwork.untechable = untechable;
        [self.navigationController pushViewController:socialnetwork animated:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *) getArrayOfSelectedTab{
    
        return contactsArray;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  self.getArrayOfSelectedTab.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"InviteCell";
    ContactListCell *cell = (ContactListCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    
    if ( cell == nil ) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ContactListCell" owner:self options:nil];
        cell = (ContactListCell *)[nib objectAtIndex:0];
    
        if( IS_IPHONE_5 ){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ContactListCell" owner:self options:nil];
            cell = (ContactListCell *)[nib objectAtIndex:0];
        } else if ( IS_IPHONE_6 ){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ContactListCell-iPhone6" owner:self options:nil];
            cell = (ContactListCell *)[nib objectAtIndex:0];
        } else if ( IS_IPHONE_6_PLUS ) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ContactListCell-iPhone6-Plus" owner:self options:nil];
            cell = (ContactListCell *)[nib objectAtIndex:0];
        }
    }
    
    if(!self.selectedIdentifiers){
        self.selectedIdentifiers = [[NSMutableArray alloc] init];
    }
    
    ContactsCustomizedModal *_contactModal;
    
    if ( [[ self getArrayOfSelectedTab ] count ] >= 1 ){
        
        // GETTING DATA FROM RECEIVED DICTIONARY
        // SET OVER MODEL FROM DATA
        
        _contactModal = [self getArrayOfSelectedTab ][(indexPath.row)];
    }
    
    if (_contactModal.img == nil) {
        _contactModal.img =[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dfcontact" ofType:@"jpg"]];
    }
    
    if ( currentlyEditingContacts.count > 0 ){
        
        for (int i = 0;i<currentlyEditingContacts.count; i++){
            
            ContactsCustomizedModal *previousModal = [currentlyEditingContacts objectAtIndex:i];
            
            if ( [previousModal.name isEqualToString:_contactModal.name] &&
                 previousModal.allPhoneNumbers.count == _contactModal.allPhoneNumbers.count )
            {
                _contactModal.cutomizingStatusArray = previousModal.cutomizingStatusArray;
                if ( [[_contactModal.cutomizingStatusArray objectAtIndex:0] isEqualToString:@"1"] ){
                    selectedAnyEmail = YES;
                }
                if ( previousModal.IsCustomized ) {
                    _contactModal.IsCustomized = YES;
                }
            }
        }
    }
    
    if ( currentlyEditingContacts.count <= 0 && [customizedContactsString isEqualToString:@""] ){
        
        [self resetContactModal:_contactModal];
    }

    // HERE WE PASS DATA TO CELL CLASS
    [cell setCellObjects:_contactModal :1 :@"InviteFriends"];
    
    return cell;
}

- (void)resetContactModal:(ContactsCustomizedModal *)contactModal{
    
    contactModal.cutomizingStatusArray = [[NSMutableArray alloc] initWithObjects:@"0",@"0",@"0", nil];
    
    for ( int i=0;i<contactModal.allPhoneNumbers.count;i++){
        NSMutableArray *tempPhoneArray = [contactModal.allPhoneNumbers objectAtIndex:i];
        [tempPhoneArray setObject:@"0" atIndexedSubscript:2];
        [tempPhoneArray setObject:@"0" atIndexedSubscript:3];
    }
    
    for (int j=0;j<contactModal.allEmails.count;j++){
        NSMutableArray *tempEmailArray = [contactModal.allEmails objectAtIndex:j];
        [tempEmailArray setObject:@"0" atIndexedSubscript:1];
    }
    
    contactModal.customTextForContact = untechable.spendingTimeTxt;
}


- (IBAction)onSearchClick:(UIButton *)sender{
    
    if([searchTextField canResignFirstResponder])
    {
        [searchTextField resignFirstResponder];
    }
    
    [self textField:searchTextField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@""];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if([string isEqualToString:@"\n"]){
        if([searchTextField canResignFirstResponder])
        {
            [searchTextField resignFirstResponder];
        }
        return NO;
    }
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if([newString isEqualToString:@""]){
        
        contactsArray = contactBackupArray;
        
        [_contactsTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        
        return YES;
    }
    
    NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
    
    for(int contactIndex=0; contactIndex<[[self getBackupArrayOfSelectedTab] count]; contactIndex++){
        // Get left contact data
        
        ContactsCustomizedModal *contactModal = [self getBackupArrayOfSelectedTab][contactIndex];
        
        NSString *name = contactModal.name;
        
        if([[name lowercaseString] rangeOfString:[newString lowercaseString]].location == NSNotFound){
            
        } else {
            [filteredArray addObject:contactModal];
        }
    }
    
    
    contactsArray = filteredArray;
    
    [_contactsTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    return YES;
}

-(NSArray *) getBackupArrayOfSelectedTab{
    
    return contactBackupArray;
}

#pragma mark  Device Contact List

/*
 * This method is used to load device contact details
 */
- (IBAction)loadLocalContacts{
    
    self.selectedIdentifiers = [[NSMutableArray alloc] init];
    
    [_contactsTable reloadData];
    
    // init contact array
    if(contactBackupArray){
        
        // Reload table data after all the contacts get loaded
        contactsArray = nil;
        contactsArray = contactBackupArray;
        
        
        // Filter contacts on new tab selection
        [self onSearchClick:nil];
        
        [_contactsTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    } else {
        
        contactsArray = [[NSMutableArray alloc] init];
        ABAddressBookRef m_addressbook = ABAddressBookCreateWithOptions(NULL, NULL);
        searchTextField.text = @"";
        
        if (m_addressbook == NULL) {
            m_addressbook = ABAddressBookCreateWithOptions(NULL, NULL);
        }
        
        if (m_addressbook) {
            // ABAddressBookRequestAccessWithCompletion is iOS 6 and up.
            if (&ABAddressBookRequestAccessWithCompletion) {
                ABAddressBookRequestAccessWithCompletion(m_addressbook,
                                                         ^(bool granted, CFErrorRef error) {
                                                             if (granted) {
                                                                 // constructInThread: will CFRelease ab.
                                                                 [NSThread detachNewThreadSelector:@selector(constructInThread:)
                                                                                          toTarget:self
                                                                                        withObject:(__bridge id)(m_addressbook)];
                                                             } else {
                                                                 CFRelease(m_addressbook);
                                                                 // Ignore the error
                                                             }
                                                         });
            } else {
                // constructInThread: will CFRelease ab.
                [NSThread detachNewThreadSelector:@selector(constructInThread:)
                                         toTarget:self
                                       withObject:(__bridge id)(m_addressbook)];
            }
        }
    }
}

/*
 * Mehod called to get contacts
 */
-(void)constructInThread:(ABAddressBookRef)m_addressbook{
    
    if (!m_addressbook) {
        NSLog(@"opening address book");
    }
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(m_addressbook);
    CFIndex nPeople = ABAddressBookGetPersonCount(m_addressbook);
    ContactsCustomizedModal *currentltRenderingContactModal;
    
    for (int i=0;i < nPeople;i++) {
        currentltRenderingContactModal = [[ContactsCustomizedModal alloc] init];
        
        currentltRenderingContactModal.others = @"";
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);
        
        //For username and surname
        ABMultiValueRef phones =(__bridge ABMultiValueRef)((NSString*)CFBridgingRelease(ABRecordCopyValue(ref, kABPersonPhoneProperty)));
        ABMultiValueRef emails =(__bridge ABMultiValueRef)((NSString*)CFBridgingRelease(ABRecordCopyValue(ref, kABPersonEmailProperty)));
        CFStringRef firstName, lastName;
        firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        
        if(!firstName)
            firstName = (CFStringRef) @"";
        if(!lastName)
            lastName = (CFStringRef) @"";
        
        currentltRenderingContactModal.name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        
        // For contact picture
        UIImage *contactPicture;
        
        if (ref != nil && ABPersonHasImageData(ref)) {
            if ( &ABPersonCopyImageDataWithFormat != nil ) {
                // iOS >= 4.1
                contactPicture = [UIImage imageWithData:(NSData *)CFBridgingRelease(ABPersonCopyImageDataWithFormat(ref, kABPersonImageFormatThumbnail))];
                currentltRenderingContactModal.img = contactPicture;
            } else {
                // iOS < 4.1
                contactPicture = [UIImage imageWithData:(NSData *)CFBridgingRelease(ABPersonCopyImageData(ref))];
                currentltRenderingContactModal.img = contactPicture;
            }
        }
    
        //For all emails
        NSMutableArray *allEmails = [[NSMutableArray alloc] initWithCapacity:CFArrayGetCount(allPeople)];
        
        NSString *emailLabel;
        for (CFIndex j=0; j < ABMultiValueGetCount(emails); j++) {
            
            emailLabel = (NSString*)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(emails, j));
            NSString* email = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(emails, j));
            NSMutableArray *emailWithStatus = [[NSMutableArray alloc] init];
            
            [emailWithStatus setObject:email atIndexedSubscript:0];
            [emailWithStatus setObject:@"0" atIndexedSubscript:1];
            
            [allEmails addObject:emailWithStatus];
            
        }
        currentltRenderingContactModal.allEmails = allEmails;
        
        [currentltRenderingContactModal.cutomizingStatusArray setObject:@"0" atIndexedSubscript:0];
        [currentltRenderingContactModal.cutomizingStatusArray setObject:@"0" atIndexedSubscript:1];
        [currentltRenderingContactModal.cutomizingStatusArray setObject:@"0" atIndexedSubscript:2];
        
        //For Phone number
        NSMutableArray *allNumbers = [[NSMutableArray alloc] initWithCapacity:CFArrayGetCount(allPeople)];
        NSString* mobileLabel;
        
        for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) {
            
            mobileLabel = (NSString*)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(phones, i));
            
            NSString *numberType;
            
            if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMainLabel])
            {
                numberType = @"Main";
            }
            
            if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
            {
                numberType = @"Mobile";
            }
            
            if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
            {
                numberType = @"iPhoneNumber";
            }
            
            if ([mobileLabel isEqualToString:(NSString*)kABHomeLabel])
            {
                numberType = @"Home";
            }
            
            if ([mobileLabel isEqualToString:(NSString*)kABWorkLabel])
            {
                numberType = @"Work";
            }
            
            if ( numberType != nil ){
                NSMutableArray *numberWithStatus = [[NSMutableArray alloc] init];
                // Phone Number type at index 0
                [numberWithStatus setObject:numberType atIndexedSubscript:0];
                // Phone Number at index 1
                [numberWithStatus setObject:(NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, i)) atIndexedSubscript:1];
                // Phone Number SMS status at index 2
                [numberWithStatus setObject:@"0" atIndexedSubscript:2];
                // Phone Number CALL status at index 3
                [numberWithStatus setObject:@"0" atIndexedSubscript:3];
                
                [allNumbers addObject:numberWithStatus];
            }
        }
        
        currentltRenderingContactModal.allPhoneNumbers = allNumbers;
        
        currentltRenderingContactModal.customTextForContact = untechable.spendingTimeTxt;
        
        // Here we getting all previously customized contacts status and setting it according to contact modal
        ContactsCustomizedModal *previuoslyEditedContact;
        
        for ( int editedContactsArrIndex = 0; editedContactsArrIndex < currentlyEditingContacts.count; editedContactsArrIndex++ ){
            
            previuoslyEditedContact = [[ContactsCustomizedModal alloc] init];
            
            previuoslyEditedContact = [currentlyEditingContacts objectAtIndex:editedContactsArrIndex];
            
            // getting previously customized contact phone numbers
            NSMutableArray *tempPhoneNumbers = previuoslyEditedContact.allPhoneNumbers;
            
            // setting phone number status in rendering contact according saved contact status
            for ( int i=0; i < tempPhoneNumbers.count; i++ ){
                
                NSMutableArray *phoneNumberDetails = [tempPhoneNumbers objectAtIndex:i];
                
                NSString *customizedNumber = [phoneNumberDetails objectAtIndex:1];
                
                //customizedNumber = [self NumberToFormatIntoUSstandard:customizedNumber];
                
                for ( int j=0; j < currentltRenderingContactModal.allPhoneNumbers.count; j++ ){
                    
                    NSMutableArray *currentContactNumberDetails = [currentltRenderingContactModal.allPhoneNumbers objectAtIndex:j];
                    
                    NSString *currentContactCustomizedNumber  = [currentContactNumberDetails objectAtIndex:1];
                    
                    //currentContactCustomizedNumber = [self NumberToFormatIntoUSstandard:currentContactCustomizedNumber];
                    
                    if ( [currentContactCustomizedNumber isEqualToString:customizedNumber] ){
                        
                        [currentltRenderingContactModal.allPhoneNumbers replaceObjectAtIndex:j withObject:phoneNumberDetails];
                        
                        if ( [[phoneNumberDetails objectAtIndex:2] isEqualToString:@"1"] ){
                            [currentltRenderingContactModal.cutomizingStatusArray setObject:@"1" atIndexedSubscript:2];
                        }else {
                            [currentltRenderingContactModal.cutomizingStatusArray setObject:@"0" atIndexedSubscript:2];
                        }
                        
                        if ( [[phoneNumberDetails objectAtIndex:3] isEqualToString:@"1"] ){
                            [currentltRenderingContactModal.cutomizingStatusArray setObject:@"1" atIndexedSubscript:1];
                        }else {
                            [currentltRenderingContactModal.cutomizingStatusArray setObject:@"0" atIndexedSubscript:1];
                        }
                        
                        previuoslyEditedContact.allPhoneNumbers = currentltRenderingContactModal.allPhoneNumbers;
                        
                        currentltRenderingContactModal.IsCustomized = YES;
                        
                        currentltRenderingContactModal.customTextForContact = previuoslyEditedContact.customTextForContact;
                    }
                }
            }
            
            NSMutableArray *tempEmails = previuoslyEditedContact.allEmails;
            
            // setting email status in rendering contact according saved contact status
            for ( int i=0; i < tempEmails.count; i++ ){
                
                NSString *exactEmailAddress;
                NSMutableArray *emailDetails;
                
                if ( [[tempEmails objectAtIndex:i] isKindOfClass:[NSString class]] ){
                    
                    exactEmailAddress = [tempEmails objectAtIndex:i];
                    
                }else if ( [[tempEmails objectAtIndex:i] isKindOfClass:[NSArray class]] ){
                    
                    emailDetails = [tempEmails objectAtIndex:i];
                    exactEmailAddress = [emailDetails objectAtIndex:0];
                }
                
                for ( int j=0; j < currentltRenderingContactModal.allEmails.count; j++ ){
                    
                    NSMutableArray *currentContactEmailDetails = [currentltRenderingContactModal.allEmails objectAtIndex:j];
                    
                    if ( [[currentContactEmailDetails objectAtIndex:0] isEqualToString:exactEmailAddress] ){
                        
                        if ( emailDetails.count > 0 ){
                            NSString *emailStatus = [emailDetails objectAtIndex:1];
                            if ( [emailStatus isEqualToString:@"1"] ){
                                [currentContactEmailDetails setObject:@"1" atIndexedSubscript:1];
                                [currentltRenderingContactModal.cutomizingStatusArray setObject:@"1" atIndexedSubscript:0];
                            }else {
                                [currentContactEmailDetails setObject:@"0" atIndexedSubscript:1];
                                [currentltRenderingContactModal.cutomizingStatusArray setObject:@"0" atIndexedSubscript:0];
                            }
                        }else {
                            [currentContactEmailDetails setObject:@"1" atIndexedSubscript:1];
                            [currentltRenderingContactModal.cutomizingStatusArray setObject:@"1" atIndexedSubscript:0];
                        }
                        
                        [currentltRenderingContactModal.allEmails replaceObjectAtIndex:j withObject:currentContactEmailDetails];
                        
                        previuoslyEditedContact.allEmails = currentltRenderingContactModal.allEmails;
                        
                        currentltRenderingContactModal.IsCustomized = YES;
                        
                        currentltRenderingContactModal.customTextForContact = previuoslyEditedContact.customTextForContact;
                        
                        break;
                    }
                }
            }
        }
    
        if ( currentltRenderingContactModal.allEmails.count > 0 || currentltRenderingContactModal.allPhoneNumbers.count > 0 ){
            [contactsArray addObject:currentltRenderingContactModal];
        }
    }
    // Reload table data after all the contacts get loaded
    contactBackupArray = nil;
    contactBackupArray = [[NSMutableArray alloc] initWithArray:contactsArray];
    [_contactsTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}


/*
-(NSString *) NumberToFormatIntoUSstandard :(NSString *)nonFormatedNumber{
    
    NSMutableString *stringts = [NSMutableString stringWithString:nonFormatedNumber];
    [stringts insertString:@"(" atIndex:0];
    [stringts insertString:@")" atIndex:4];
    [stringts insertString:@"-" atIndex:5];
    [stringts insertString:@"-" atIndex:9];
    return stringts;
}*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactCustomizeDetailsControlelrViewController *detailsController = [[ContactCustomizeDetailsControlelrViewController alloc] init];
    
    detailsController.untechable = untechable;
    detailsController.contactListController = self;
    
    NSMutableDictionary *curContactDetails;
    
    contactBackupArray = [[NSMutableArray alloc] initWithArray:contactsArray];
    ContactsCustomizedModal *tempModal = [contactBackupArray objectAtIndex:indexPath.row];
    
    if ( ![customizedContactsString isEqualToString:@""] ){
        
        for ( int i = 0; i < customizedContactsDictionary.count; i++ ){
            
            curContactDetails =  [customizedContactsDictionary objectForKey:[NSString stringWithFormat:@"%i",i]];
            
            NSMutableArray *tempPhonesNumbers = [curContactDetails objectForKey:@"phoneNumbers"];
            
            if ( [[curContactDetails objectForKey:@"contactName"] isEqualToString:detailsController.contactModal.name]
                &&
                tempModal.allPhoneNumbers.count == tempPhonesNumbers.count) {
                
                tempModal.name = [curContactDetails objectForKey:@"contactName"];
                tempModal.allPhoneNumbers = [curContactDetails objectForKey:@"phoneNumbers"];
                tempModal.allEmails = [curContactDetails objectForKey:@"emailAddresses"];
                tempModal.customTextForContact = [curContactDetails objectForKey:@"customTextForContact"];
            
                detailsController.contactModal = tempModal;
                break;
                
            }else {
                
                detailsController.contactModal = tempModal;
                break;
            }
        }
    }else{
        
        detailsController.contactModal = tempModal;
    }
    detailsController.customizedContactsDictionary =  customizedContactsDictionary;
    [self.navigationController pushViewController:detailsController animated:YES];
}
@end
