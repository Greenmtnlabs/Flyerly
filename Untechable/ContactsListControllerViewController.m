
//
//  ContactsListControllerViewController.m
//  Untechable
//
//  Created by RIKSOF Developer on 12/23/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "ContactsListControllerViewController.h"
#import "ContactListCell.h"
#import "ContactCustomizeDetailsControlelrViewController.h"
#import "SocialnetworkController.h"
#import "SetupGuideFourthView.h"
#import "Common.h"
#import "ContactsCustomizedModal.h"
#import "EmailSettingController.h"
#import "EmailChangingController.h"
#import "SocialNetworksStatusModal.h"
#import "AddUntechableController.h"

@interface ContactsListControllerViewController () {

    EmailSettingController *emailSettingController;
}

@property (strong, nonatomic) IBOutlet UITableView *contactsTable;

@end

@implementation ContactsListControllerViewController

@synthesize mobileContactsArray,mobileContactBackupArray,searchTextField,untechable, selectedAnyEmail;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    emailSettingController = [[EmailSettingController alloc]initWithNibName:@"EmailSettingController" bundle:nil];
    [self setNavigationDefaults];
    
    _contactsTable.delegate = self;
    _contactsTable.dataSource = self;
    
    _contactsTable.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 100.0f, 0.0f);
    
    [_contactsTable  setBackgroundColor:[UIColor colorWithRed:245/255.0 green:241/255.0 blue:222/255.0 alpha:1.0]];
    [searchTextField setReturnKeyType:UIReturnKeyDone];
    
    [searchTextField resignFirstResponder];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self setNavigation:@"viewDidLoad"];
    
    // Load device contacts and set into contactsArray
    [self loadContactsFromDevice];
    
    selectedAnyEmail = NO;

    [_contactsTable reloadData];
    
    //hides the keyboard when navigating between views
    [searchTextField resignFirstResponder];
}

/**
 dismiss keyboard when view will off the screen
 **/
- (void)viewWillDisappear:(BOOL)animated{
    [searchTextField resignFirstResponder];
}


#pragma mark -  Navigation functions
- (void)setNavigationDefaults{
    [[self navigationController] setNavigationBarHidden:NO animated:YES]; //show navigation bar
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

-(void)setNavigation:(NSString *)callFrom{
    
    if([callFrom isEqualToString:@"viewDidLoad"]) {
        self.navigationItem.hidesBackButton = YES;
        
        // Center title __________________________________________________
        self.navigationItem.titleView = [untechable.commonFunctions navigationGetTitleView];
        
        // Back Navigation button
        backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        backButton.titleLabel.shadowColor = [UIColor clearColor];
        backButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [backButton setTitle:TITLE_BACK_TXT forState:normal];
        [backButton setTitleColor:DEF_GRAY forState:UIControlStateNormal];
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
        [nextButton setTitleColor:DEF_GRAY forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(btnNextTouchStart) forControlEvents:UIControlEventTouchDown];
        [nextButton addTarget:self action:@selector(btnNextTouchEnd) forControlEvents:UIControlEventTouchUpInside];
        
        nextButton.showsTouchWhenHighlighted = YES;
        
        skipButton = [[UIButton alloc] initWithFrame:CGRectMake(33, 0, 33, 42)];
        skipButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_LEFT_SIZE];
        [skipButton setTitle:@"SKIP" forState:normal];
        [skipButton setTitleColor:DEF_GRAY forState:UIControlStateNormal];
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
            
            AddUntechableController *addViewController = (AddUntechableController *)controller;
            addViewController.untechable = untechable;
            [self.navigationController popToViewController:addViewController animated:YES];
            break;
        }
    }
    //hide keyboard when going back to view
    [searchTextField resignFirstResponder];
}


- (void)setSkipHighlighted:(BOOL)highlighted {
    (highlighted) ? [skipButton setBackgroundColor:DEF_GREEN] : [skipButton setBackgroundColor:[UIColor clearColor]];
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
    
    //reset contacts from model
    [untechable setCustomizedContactsForSession];
    [self mapAllSessionContactSelectionsOnMobileArray];
    
    [self onNext];
    
}

/**
 * Want to send email to any contact about untechable
 */
-(BOOL)haveSelectedAnyEmail{
    BOOL wantToSend = NO;
    for (int i = 0;i<untechable.customizedContactsForCurrentSession.count; i++){
        ContactsCustomizedModal *previousModal = [untechable.customizedContactsForCurrentSession objectAtIndex:i];
        
        if ( [previousModal getEmailStatus] ){
            wantToSend =  YES;
            break;
        }
    }
    
    return wantToSend;
}

/**
 * Save data and go next
 */
-(void)onNext{
    
    [self removeExtrasFromSessionAry];
    
    selectedAnyEmail = [self haveSelectedAnyEmail];
    
    if( [untechable.rUId  isEqualToString: @"1"]){
        
        if( selectedAnyEmail ) {
            [self showEmailSetupScreen:YES];//calledFromSetupScreen is YES
        } else {
            
            SetupGuideFourthView *fourthScreen = [[SetupGuideFourthView alloc] initWithNibName:@"SetupGuideFourthView" bundle:nil];
            if([untechable.rUId isEqualToString:@"1"]){
                untechable.dic[@"rUId"] = @"1";
            }
            
            fourthScreen.untechable = untechable;
            [self.navigationController pushViewController:fourthScreen animated:YES];
        }
        
    } else if( ![untechable.rUId  isEqualToString: @"1"] ){
        if ( selectedAnyEmail  ){
            [self showEmailSetupScreen:NO];//calledFromSetupScreen is NO
        }else {
            
            SocialnetworkController *socialnetwork;
            socialnetwork = [[SocialnetworkController alloc]initWithNibName:@"SocialnetworkController" bundle:nil];
            socialnetwork.untechable = untechable;
            [self.navigationController pushViewController:socialnetwork animated:YES];
        }
    }
     //hides the keyboard when navigating to the next views
     [searchTextField resignFirstResponder];
}

-( void ) showEmailSetupScreen : ( BOOL ) calledFromSetupScreen {
    NSLog(@"%@", [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allValues]);
    
    NSArray *keys = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys];
    
    if (  [keys containsObject:EMAIL_KEY] || [keys containsObject:PASSWORD_KEY]  ){
        
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:EMAIL_KEY]);
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD_KEY]);
        
        if ( [[[NSUserDefaults standardUserDefaults] objectForKey:EMAIL_KEY] isEqualToString:@""] ||
            [[[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD_KEY] isEqualToString:@""] ){
            
            emailSettingController.untechable = untechable;
            
            [self changingBoolVals:calledFromSetupScreen];
            
            [self.navigationController pushViewController:emailSettingController animated:YES];
            
        }else {
            
            EmailChangingController *emailChangeController;
            emailChangeController = [[EmailChangingController alloc]initWithNibName:@"EmailChangingController" bundle:nil];
            emailChangeController.untechable = untechable;
            emailChangeController.setupScreenCalling = &(calledFromSetupScreen);
            emailChangeController.emailAddresstext = [[SocialNetworksStatusModal sharedInstance] getEmailAddress];
            [self.navigationController pushViewController:emailChangeController animated:YES];
        }
        
    }else {
        
        emailSettingController.untechable = untechable;
            
        [self changingBoolVals:calledFromSetupScreen];
        [self.navigationController pushViewController:emailSettingController animated:YES];
    }
}

-( void ) changingBoolVals : ( BOOL ) calledFromSetupScreen {
    
    if( calledFromSetupScreen ) {
        
        emailSettingController.comingFromSettingsScreen = NO;
        emailSettingController.comingFromChangeEmailScreen = NO;
        emailSettingController.comingFromContactsListScreen = NO;
        emailSettingController.comingFromSetupScreen = YES;
        
    } else {
        
        emailSettingController.comingFromSettingsScreen = NO;
        emailSettingController.comingFromChangeEmailScreen = NO;
        emailSettingController.comingFromContactsListScreen = YES;
        emailSettingController.comingFromSetupScreen = NO;
    }
}

-(void)btnNextTouchStart{
    [self setNextHighlighted:YES];
}
-(void)btnNextTouchEnd{
    [self setNextHighlighted:NO];
}
- (void)setNextHighlighted:(BOOL)highlighted {
    (highlighted) ? [nextButton setBackgroundColor:DEF_GREEN] : [nextButton setBackgroundColor:[UIColor clearColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  mobileContactsArray.count;
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
    // HERE WE PASS DATA TO CELL CLASS
    [cell setCellObjects:mobileContactsArray[indexPath.row] :1 :@"InviteFriends"];
    
    return cell;
}

- (IBAction)onSearchClick:(UIButton *)sender{
    
    if([searchTextField canResignFirstResponder]){
        [searchTextField resignFirstResponder];
    }
    
    [self textField:searchTextField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@""];
}

/**
 * When user starts typing in search contact input field
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if([string isEqualToString:@"\n"]){
        if([searchTextField canResignFirstResponder]) {
            [searchTextField resignFirstResponder];
        }
        return NO;
        
    } else{
        
        //When text is empty reset contactsArray with contactBackupArray
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if([newString isEqualToString:@""]){
            
            [self resetContactsArrayFromBackupArray];
            [self reloadContactsTableInMainThread];
            return YES;
            
        } else{
            //Filter array a/c to search text
            NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
            
            for(int contactIndex=0; contactIndex< mobileContactBackupArray.count; contactIndex++) {
                
                ContactsCustomizedModal *contactModal = mobileContactBackupArray[contactIndex];
                NSString *name = contactModal.contactName;
                
                if( !([[name lowercaseString] rangeOfString:[newString lowercaseString]].location == NSNotFound) ){
                    [filteredArray addObject:contactModal];
                }
            }
            
            mobileContactsArray = filteredArray;
            [self reloadContactsTableInMainThread];
            return YES;
        }
    }
}

// Reload table data after all the contacts get loaded
-(void)resetContactsArrayFromBackupArray{
    mobileContactsArray = [[NSMutableArray alloc] initWithArray:mobileContactBackupArray];
}
-(void)reloadContactsTableInMainThread{
    [_contactsTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

#pragma mark  Device Contact List

/*
 * This method is used to load device contact details
 * Load device contacts and set into contactsArray
 */
- (void)loadContactsFromDevice{
    
    // init contact array
    if( mobileContactBackupArray ){
        
        [self resetContactsArrayFromBackupArray];
        
        // Filter contacts on new tab selection
        [self onSearchClick:nil];
        
        [self reloadContactsTableInMainThread];
    } else {
        
        mobileContactsArray = [[NSMutableArray alloc] init];
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
 * Set all contacts of mobile in contactsArray, this is a kind of call back
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
        
        currentltRenderingContactModal.contactName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        
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
        
        for ( int editedContactsArrIndex = 0; editedContactsArrIndex < untechable.customizedContactsForCurrentSession.count; editedContactsArrIndex++ ){
            
            previuoslyEditedContact = [untechable.customizedContactsForCurrentSession objectAtIndex:editedContactsArrIndex];
            
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
                        
                        
                        previuoslyEditedContact.allPhoneNumbers = currentltRenderingContactModal.allPhoneNumbers;
                        
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
                            }else {
                                [currentContactEmailDetails setObject:@"0" atIndexedSubscript:1];
                            }
                        }else {
                            [currentContactEmailDetails setObject:@"1" atIndexedSubscript:1];
                        }
                        
                        [currentltRenderingContactModal.allEmails replaceObjectAtIndex:j withObject:currentContactEmailDetails];
                        
                        previuoslyEditedContact.allEmails = currentltRenderingContactModal.allEmails;

                        currentltRenderingContactModal.customTextForContact = previuoslyEditedContact.customTextForContact;
                        
                        break;
                    }
                }
            }
        }
    
        if ( currentltRenderingContactModal.allEmails.count > 0 || currentltRenderingContactModal.allPhoneNumbers.count > 0 ){
            [mobileContactsArray addObject:currentltRenderingContactModal ];
        }
    }
    

    [self mapAllSessionContactSelectionsOnMobileArray];
    
    // Reload table data after all the contacts get loaded
    mobileContactBackupArray = [[NSMutableArray alloc] initWithArray:mobileContactsArray];
    [self reloadContactsTableInMainThread];
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


/**
 * On row tap, go to contact details
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactCustomizeDetailsControlelrViewController *detailsController = [[ContactCustomizeDetailsControlelrViewController alloc] init];
    detailsController.untechable = untechable;

    
    // contact which is going to be edit
    ContactsCustomizedModal *mobileContModel = mobileContactsArray[indexPath.row];
    detailsController.contactModal = mobileContModel;
    
    [self.navigationController pushViewController:detailsController animated:YES];
}


/**
 * Deep copy the model
 */
- (ContactsCustomizedModal *)deepCopyWithDefaultValues:(ContactsCustomizedModal *)mobileContactModel{
    ContactsCustomizedModal *contactModal = [[ContactsCustomizedModal alloc] init];
    contactModal.customTextForContact = untechable.spendingTimeTxt;
    for ( int i=0;i<mobileContactModel.allPhoneNumbers.count;i++){
        [contactModal.allPhoneNumbers addObject:[NSMutableArray arrayWithArray:@[mobileContactModel.allPhoneNumbers[i][0], mobileContactModel.allPhoneNumbers[i][1], @"0",@"0"]]];
    }
    
    for ( int i=0;i<mobileContactModel.allEmails.count;i++){
        [contactModal.allEmails addObject:[NSMutableArray arrayWithArray:@[mobileContactModel.allEmails[i][0], @"0"]]];
    }
    
    contactModal.contactName = [NSString stringWithString:mobileContactModel.contactName];
    
    return contactModal;
}

/**
 * This function will map the session values on to mobileContactsArray( extracted from mobile contacts) this
 * will be using between contact list and contact list details controllers
 */
-(void)mapAllSessionContactSelectionsOnMobileArray{
    for (int i = 0;i< untechable.customizedContactsForCurrentSession.count; i++){
        ContactsCustomizedModal *sessionModel = [untechable.customizedContactsForCurrentSession objectAtIndex:i];

        for (int j = 0; j< mobileContactsArray.count; j++){
            ContactsCustomizedModal *mobileContModel = [mobileContactsArray objectAtIndex:j];
            
            if( [sessionModel.contactName isEqualToString:mobileContModel.contactName] ){
                mobileContModel = [self mapSingleSessionModelToSingleMobileModel:mobileContModel sessionModel:sessionModel];
                break;
            }
        }//for2//
    }//for1//
}

//Mapping of single sessionModel on to single mobileContactModel, will return mobileContactModel
-(ContactsCustomizedModal *)mapSingleSessionModelToSingleMobileModel:(ContactsCustomizedModal *)mobileContModel sessionModel:(ContactsCustomizedModal *)sessionModel{
    
    BOOL found = NO;
    
    for(int i=0; i<mobileContModel.allPhoneNumbers.count; i++){
        for(int j=0; j<sessionModel.allPhoneNumbers.count; j++){
            if( [mobileContModel.allPhoneNumbers[i][0] isEqualToString:sessionModel.allPhoneNumbers[j][0] ] ){
                
                mobileContModel.allPhoneNumbers[i][2] = ( [sessionModel.allPhoneNumbers[j][2] isEqualToString:@"1"] ) ? @"1" : @"0";
                mobileContModel.allPhoneNumbers[i][3] = ( [sessionModel.allPhoneNumbers[j][3] isEqualToString:@"1"] ) ? @"1" : @"0";
                
                found = YES;
                break;
            }
        }
        
        if( found == NO ){
            mobileContModel.allPhoneNumbers[i][2] = @"0";
            mobileContModel.allPhoneNumbers[i][3] = @"0";
        }
        
        found = NO;
        
        
    }
    
    for(int i=0; i<mobileContModel.allEmails.count; i++){
        for(int j=0; j<sessionModel.allEmails.count; j++){
            if( [mobileContModel.allEmails[i][0] isEqualToString:sessionModel.allEmails[j][0] ] ){
                mobileContModel.allEmails[i][1] = ( [sessionModel.allEmails[j][1] isEqualToString:@"1"] ) ? @"1" : @"0";
                
                found = YES;
                break;
            }
        }
        
        if( found == NO ){
            mobileContModel.allEmails[i][1] = @"0";
            found = NO;
        }
    }
    
    mobileContModel.customTextForContact = sessionModel.customTextForContact;
    
    return mobileContModel;
}

/**
 * Before going to next page, remove extras from session model
 */
-(void)removeExtrasFromSessionAry{
    for (int i = 0;i< untechable.customizedContactsForCurrentSession.count; i++){
        ContactsCustomizedModal *sessionModel = [untechable.customizedContactsForCurrentSession objectAtIndex:i];

        //Only save selected contacts
        NSMutableArray *tempAllPhoneNumbers = [[NSMutableArray alloc] init];
        for( int j=0; j < sessionModel.allPhoneNumbers.count; j++){
            if( [sessionModel.allPhoneNumbers[j][2] isEqualToString:@"1"] || [sessionModel.allPhoneNumbers[j][3] isEqualToString:@"1"] )
                [tempAllPhoneNumbers addObject:sessionModel.allPhoneNumbers[j]];
        }
        sessionModel.allPhoneNumbers = tempAllPhoneNumbers;
        
        //only save selected email addresses
        NSMutableArray *tempAllEmails = [[NSMutableArray alloc] init];
        for( int j=0; j < sessionModel.allEmails.count; j++){
            if( [sessionModel.allEmails[j][1] isEqualToString:@"1"] )
                [tempAllEmails addObject:sessionModel.allEmails[j]];
        }
        sessionModel.allEmails = tempAllEmails;
        
        [untechable.customizedContactsForCurrentSession replaceObjectAtIndex:i withObject:sessionModel];
    }
}

@end
