
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

@interface ContactsListControllerViewController ()

@property (strong, nonatomic) IBOutlet UITableView *contactsTable;

@end

@implementation ContactsListControllerViewController

@synthesize contactModalsArray,contactsArray,contactBackupArray,searchTextField,selectedIdentifiers,untechable;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationDefaults];
    [self setNavigation:@"viewDidLoad"];
    
    _contactsTable.delegate = self;
    _contactsTable.dataSource = self;
    
    [_contactsTable  setBackgroundColor:[UIColor colorWithRed:245/255.0 green:241/255.0 blue:222/255.0 alpha:1.0]];
    [searchTextField setReturnKeyType:UIReturnKeyDone];
    
    // Load device contacts
    [self loadLocalContacts];
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
        
        skipButton = [[UIButton alloc] initWithFrame:CGRectMake(33, 0, 33, 42)];
        skipButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_LEFT_SIZE];
        [skipButton setTitle:@"SKIP" forState:normal];
        [skipButton setTitleColor:defGray forState:UIControlStateNormal];
        [skipButton addTarget:self action:@selector(btnSkipTouchStart) forControlEvents:UIControlEventTouchDown];
        [skipButton addTarget:self action:@selector(btnSkipTouchEnd) forControlEvents:UIControlEventTouchUpInside];
        
        //[skipButton setBackgroundColor:[UIColor redColor]];
        skipButton.showsTouchWhenHighlighted = YES;
        
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
        UIBarButtonItem *skipButtonBarButton = [[UIBarButtonItem alloc] initWithCustomView:skipButton];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:skipButtonBarButton,nil];
        
        [self.navigationItem setRightBarButtonItems:rightNavItems];//Right button ___________
    }
}

-(void) goBack {
    [self.navigationController popViewControllerAnimated:YES];
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
    
    [self storeSceenVarsInDic];
    
    //[self hideAllControlls];
    
    BOOL goToNext = untechable.hasEndDate ? NO : YES;
    
    //When we have end date, must check end date is greater then start date
    if( untechable.hasEndDate == YES )
    {
        NSDate *d1 = [untechable.commonFunctions timestampStrToNsDate:untechable.startDate];
        NSDate *d2 = [untechable.commonFunctions timestampStrToNsDate:untechable.endDate];
        
        
        goToNext = [untechable.commonFunctions date1IsSmallerThenDate2:d1 date2:d2];
        
        if( goToNext == NO ) {
            
            [untechable.commonFunctions showAlert:@"Invalid Dates" message:@"End date should be greater then start date."];
        }
        
    }
    
    NSLog(goToNext ? @"goToNext- YES" : @"goToNext- NO");
    
    
    if( goToNext ) {
        
        ContactsListControllerViewController *listController = [[ContactsListControllerViewController alloc] initWithNibName:@"ContactsListControllerViewController" bundle:nil];
        listController.untechable = untechable;
        [self.navigationController pushViewController:listController animated:YES];
        
        /*PhoneSetupController *phoneSetup;
         phoneSetup = [[PhoneSetupController alloc]initWithNibName:@"PhoneSetupController" bundle:nil];
         phoneSetup.untechable = untechable;
         [self.navigationController pushViewController:phoneSetup animated:YES];*/
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
        
        //cell.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        //[cell setFrame:newFrame];
        
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
    
    ContactsCustomizedModal *receivedDic;
    
    if ( [[ self getArrayOfSelectedTab ] count ] >= 1 ){
        
        // GETTING DATA FROM RECEIVED DICTIONARY
        // SET OVER MODEL FROM DATA
        
        receivedDic = [self getArrayOfSelectedTab ][(indexPath.row)];
    }
    
    if (receivedDic.img == nil) {
        receivedDic.img =[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dfcontact" ofType:@"jpg"]];
    }
    
    // HERE WE CHECK STATUS OF FRIEND INVITE
    /*int status = 0;
    
    if ([self ckeckExistdb:receivedDic.description]) {
        status = 2;
    }else{
        if ([self ckeckExistContact:receivedDic.description]) {
            status = 1;
            
        }else{
            status = 0;
            
        }
    }*/
    
    
    // HERE WE PASS DATA TO CELL CLASS
    [cell setCellObjects:receivedDic :1 :@"InviteFriends"];
    
    return cell;
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
    
    for (int i=0;i < nPeople;i++) {
        ContactsCustomizedModal *contactModal = [[ContactsCustomizedModal alloc] init];
        
        contactModal.others = @"";
        
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
        
        contactModal.name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        
        // For contact picture
        UIImage *contactPicture;
        
        if (ref != nil && ABPersonHasImageData(ref)) {
            if ( &ABPersonCopyImageDataWithFormat != nil ) {
                // iOS >= 4.1
                contactPicture = [UIImage imageWithData:(NSData *)CFBridgingRelease(ABPersonCopyImageDataWithFormat(ref, kABPersonImageFormatThumbnail))];
                contactModal.img = contactPicture;
            } else {
                // iOS < 4.1
                contactPicture = [UIImage imageWithData:(NSData *)CFBridgingRelease(ABPersonCopyImageData(ref))];
                contactModal.img = contactPicture;
            }
        }
        
        //For all emails
        NSMutableArray *allEmails = [[NSMutableArray alloc] initWithCapacity:CFArrayGetCount(allPeople)];
        
        NSString *emailLabel;
        for (CFIndex j=0; j < ABMultiValueGetCount(emails); j++) {
            
            emailLabel = (NSString*)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(emails, i));
            NSString* email = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(emails, j));
            [allEmails addObject:email];
            
        }
        contactModal.allEmails = allEmails;
        
        //For Phone number
         NSMutableDictionary *allNumbers = [[NSMutableDictionary alloc] initWithCapacity:CFArrayGetCount(allPeople)];
        NSString* mobileLabel;
        
        for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) {
            
            mobileLabel = (NSString*)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(phones, i));
            
            if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMainLabel])
            {
                NSMutableArray *numberWithStatus = [[NSMutableArray alloc] initWithCapacity:3];
                
                [numberWithStatus setObject:(NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, i)) atIndexedSubscript:0];
                [numberWithStatus setObject:@"0" atIndexedSubscript:1];
                [numberWithStatus setObject:@"0" atIndexedSubscript:2];
                
                [allNumbers setObject:numberWithStatus forKey:@"Main"];
            }
            
            if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
            {
                NSMutableArray *numberWithStatus = [[NSMutableArray alloc] initWithCapacity:3];
                
                [numberWithStatus setObject:(NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, i))atIndexedSubscript:0];
                [numberWithStatus setObject:@"0" atIndexedSubscript:1];
                [numberWithStatus setObject:@"0" atIndexedSubscript:2];
                
                [allNumbers setObject:numberWithStatus forKey:@"Mobile"];
            }
            
            if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
            {
                NSMutableArray *numberWithStatus = [[NSMutableArray alloc] initWithCapacity:3];
                
                [numberWithStatus setObject:(NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, i)) atIndexedSubscript:0];
                [numberWithStatus setObject:@"0" atIndexedSubscript:1];
                [numberWithStatus setObject:@"0" atIndexedSubscript:2];
                
                [allNumbers setObject:numberWithStatus forKey:@"iPhoneNumber"];
            }
            
            if ([mobileLabel isEqualToString:(NSString*)kABHomeLabel])
            {
                NSMutableArray *numberWithStatus = [[NSMutableArray alloc] initWithCapacity:3];
                
                [numberWithStatus setObject:(NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, i)) atIndexedSubscript:0];
                [numberWithStatus setObject:@"0" atIndexedSubscript:1];
                [numberWithStatus setObject:@"0" atIndexedSubscript:2];
                
                [allNumbers setObject:numberWithStatus forKey:@"Home"];
            }
            
            if ([mobileLabel isEqualToString:(NSString*)kABWorkLabel])
            {
                NSMutableArray *numberWithStatus = [[NSMutableArray alloc] initWithCapacity:3];
                
                [numberWithStatus setObject:(NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, i)) atIndexedSubscript:0];
                [numberWithStatus setObject:@"0" atIndexedSubscript:1];
                [numberWithStatus setObject:@"0" atIndexedSubscript:2];
                
                [allNumbers setObject:numberWithStatus forKey:@"Work"];
            }
            
            contactModal.allPhoneNumbers = allNumbers;
            
            contactModal.customTextForContact = untechable.spendingTimeTxt;
            
            [contactsArray addObject:contactModal];
        }
        
    }
    
    // Reload table data after all the contacts get loaded
    contactBackupArray = nil;
    contactBackupArray = contactsArray;
    [_contactsTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactCustomizeDetailsControlelrViewController *detailsController = [[ContactCustomizeDetailsControlelrViewController alloc] init];
    
    detailsController.untechable = untechable;
    
    detailsController.contactModal = [contactsArray objectAtIndex:indexPath.row];
    
    NSString *customizedContactsString = untechable.customizedContacts;
    
    NSError *writeError = nil;
    
    NSMutableDictionary *customizedContactsDictionary =
    [NSJSONSerialization JSONObjectWithData: [customizedContactsString dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: &writeError];
    
    NSMutableDictionary *curContactDetails;
    
    if ( ![customizedContactsString isEqualToString:@""] ){
        
        for ( int i = 0; i < customizedContactsDictionary.count; i++ ){
            
            curContactDetails =  [customizedContactsDictionary objectForKey:[NSString stringWithFormat:@"%i",i]];
            
            NSMutableDictionary *tempPhoneDict = [curContactDetails objectForKey:@"phoneNumbers"];
            
            if ( [[curContactDetails objectForKey:@"contactName"] isEqualToString:detailsController.contactModal.name] &&
                [detailsController.contactModal.allPhoneNumbers allKeys].count == [tempPhoneDict allKeys].count )
            {
                
                
            }else {
            
            }
        }
    }
    
    [self.navigationController pushViewController:detailsController animated:YES];
}
@end
