//
//  AddFriendsController.m
//  Flyr
//
//  Created by Riksof on 4/15/13.
//
//

#import "InviteForPrint.h"
#import "Common.h"
#import <QuartzCore/QuartzCore.h>
#import "FlyrAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CreateFlyerController.h"
#import "HelpController.h"
#import "Flurry.h"
#import "UIImagePDF.h"
#import "UserVoice.h"
#import "SendingPrintViewController.h"
#import "LobPostcardModel.h"
#import "LobAddressModel.h"
#import "LobRequest.h"
#import "LobObjectModel.h"
#import "PayPalPaymentViewController.h"


@interface InviteForPrint ()

@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;

@end

@implementation InviteForPrint
@synthesize uiTableView, contactsArray, selectedIdentifiers, searchTextField, iPhoneinvited,flyer;
@synthesize contactBackupArray;


#pragma mark  View Appear Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UVConfig *config = [UVConfig configWithSite:@"http://flyerly.uservoice.com/"];
    [UserVoice initialize:config];
    
    self.selectedIdentifiers = [[NSMutableArray alloc] init];
    globle = [FlyerlySingleton RetrieveSingleton];
    self.navigationItem.hidesBackButton = YES;
    [self.view setBackgroundColor:[UIColor colorWithRed:245/255.0 green:241/255.0 blue:222/255.0 alpha:1]];
    
    // Register notification for facebook login
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FacebookDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fbDidLogin) name:FacebookDidLoginNotification object:nil];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-28, -6, 50, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];
    label.text = @"INVITE";
    self.navigationItem.titleView = label;
    
    // Create left bar help button
    UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [helpButton addTarget:self action:@selector(loadHelpController) forControlEvents:UIControlEventTouchUpInside];
    [helpButton setImage:[UIImage imageNamed:@"help_icon"] forState:UIControlStateNormal];
    helpButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
    
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [backButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"home_button"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:backBarButton,leftBarButton,nil]];
    
    
    // INVITE BAR BUTTON
    UIButton *inviteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
	
    //if YES then Skip paypal payment for testing
    if( NO )
    [inviteButton addTarget:self action:@selector(sendPdfFlyer) forControlEvents:UIControlEventTouchUpInside];
    else
    [inviteButton addTarget:self action:@selector(invite) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [inviteButton setBackgroundImage:[UIImage imageNamed:@"post"] forState:UIControlStateNormal];
    inviteButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:inviteButton];
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];
    
    [self.uiTableView  setBackgroundColor:[UIColor colorWithRed:245/255.0 green:241/255.0 blue:222/255.0 alpha:1.0]];
    [searchTextField setReturnKeyType:UIReturnKeyDone];
    
    
    //HERE WE GET ALREADY INVITED FRIENDS
    PFUser *user = [PFUser currentUser];
    
    self.iPhoneinvited = [[NSMutableArray alloc] init];
    
    if (user[@"iphoneinvited"])
        self.iPhoneinvited  = user[@"iphoneinvited"];
    
    // Load device contacts
    [self loadLocalContacts];
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationItem.leftItemsSupplementBackButton = YES;
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark  Custom Methods

-(void)loadHelpController{
    
    [UserVoice presentUserVoiceInterfaceForParentViewController:self];
}

-(IBAction)goBack{
    
    [self.navigationController popViewControllerAnimated:NO];
    
}

-(void)showAlert:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (BOOL)ckeckExistContact:(NSString *)identifier{
    for (int i = 0; i < selectedIdentifiers.count ; i++) {
        if ([identifier isEqualToString:selectedIdentifiers[i]]) {
            return YES;
        }
    }
    return NO;
}


-(IBAction)invite{
    
    NSMutableArray *identifiers = [[NSMutableArray alloc] init];
    identifiers = selectedIdentifiers;
    NSLog(@"%@",identifiers);
    
    NSLog(@"%lu",(unsigned long)contactsArray.count);
    if([identifiers count] > 0) {
    
        [self openBuyPanel:selectedIdentifiers.count];

    } else {
        [self showAlert:@"Please select any contact to invite !" message:@""];
    }
    
    [Flurry logEvent:@"Friends Invited"];
}



#pragma mark  Device Contact List

/*
 * This method is used to load device contact details
 */
- (void)loadLocalContacts {
    
    [selectedIdentifiers removeAllObjects];
    
    // INVITE BAR BUTTON
    /*UIButton *inviteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [inviteButton addTarget:self action:@selector(invite) forControlEvents:UIControlEventTouchUpInside];
    [inviteButton setBackgroundImage:[UIImage imageNamed:@"invite_friend"] forState:UIControlStateNormal];
    inviteButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:inviteButton];
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];*/
    //return;
    
    [self showLoadingIndicator];
    
    self.selectedIdentifiers = nil;
    self.selectedIdentifiers = [[NSMutableArray alloc] init];

    [self.uiTableView reloadData];
    // init contact array
    if( contactBackupArray ){
        
        // Reload table data after all the contacts get loaded
        contactsArray = nil;
        contactsArray = contactBackupArray;
        
        // Filter contacts on new tab selection
        [self onSearchClick:nil];
        
        [[self uiTableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        [self hideLoadingIndicator];
        
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
    
    //----
    
    NSArray *countryCodes = [NSLocale ISOCountryCodes];
    NSMutableArray *countries = [NSMutableArray arrayWithCapacity:[countryCodes count]];
    
    for (NSString *countryCode in countryCodes)
    {
        NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject: countryCode forKey: NSLocaleCountryCode]];
        NSString *country_ = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_UK"] displayNameForKey: NSLocaleIdentifier value: identifier];
        [countries addObject: country_];
    }
    
    NSDictionary *codeForCountryDictionary = [[NSDictionary alloc] initWithObjects:countryCodes forKeys:countries];
    
    
    
    for (int i=0;i < nPeople;i++) {
        ContactsModel *model = [[ContactsModel alloc] init];
        
        model.others = @"";
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);
        
        // For Contact adress
        NSMutableDictionary *contactInfoDict = [[NSMutableDictionary alloc]
                                                initWithObjects:@[@"", @"", @"", @"", @""]
                                                forKeys:@[@"streetAddress",@"city",@"state",@"zip",@"country"]];
        
        ABMultiValueRef addressRef = ABRecordCopyValue(ref, kABPersonAddressProperty);
        if (ABMultiValueGetCount(addressRef) > 0) {
            NSDictionary *addressDict = (__bridge NSDictionary *)ABMultiValueCopyValueAtIndex(addressRef, 0);
            
            if( [addressDict objectForKey:(NSString *)kABPersonAddressStreetKey] != nil ){
                [contactInfoDict setObject:[addressDict objectForKey:(NSString *)kABPersonAddressStreetKey] forKey:@"streetAddress"];
            }
            if( [addressDict objectForKey:(NSString *)kABPersonAddressCityKey] != nil ){
                [contactInfoDict setObject:[addressDict objectForKey:(NSString *)kABPersonAddressCityKey] forKey:@"city"];
            }
            if( [addressDict objectForKey:(NSString *)kABPersonAddressStateKey] != nil ){
                [contactInfoDict setObject:[addressDict objectForKey:(NSString *)kABPersonAddressStateKey] forKey:@"state"];
            }
            if( [addressDict objectForKey:(NSString *)kABPersonAddressZIPKey] != nil ){
                [contactInfoDict setObject:[addressDict objectForKey:(NSString *)kABPersonAddressZIPKey] forKey:@"zip"];
            }
            if( [addressDict objectForKey:(NSString *)kABPersonAddressCountryKey] != nil ){
                [contactInfoDict setObject:[addressDict objectForKey:(NSString *)kABPersonAddressCountryKey] forKey:@"country"];
            }
            
        }
        CFRelease(addressRef);
        //-------
        
        if ( ![[contactInfoDict objectForKey:@"streetAddress"] isEqualToString:@""] &&
             ![[contactInfoDict objectForKey:@"state"] isEqualToString:@""] &&
             ![[contactInfoDict objectForKey:@"city"] isEqualToString:@""] &&
             ![[contactInfoDict objectForKey:@"country"] isEqualToString:@""] &&
             ![[contactInfoDict objectForKey:@"zip"] isEqualToString:@""]) {
    
            model.streetAddress = [contactInfoDict objectForKey:@"streetAddress"];
            model.state = [contactInfoDict objectForKey:@"state"];
            model.city = [contactInfoDict objectForKey:@"city"];
            model.country = [codeForCountryDictionary objectForKey:[contactInfoDict objectForKey:@"country"]];
            model.zip = [contactInfoDict objectForKey:@"zip"];
        
            //For username and surname
            ABMultiValueRef phones =(__bridge ABMultiValueRef)((NSString*)CFBridgingRelease(ABRecordCopyValue(ref, kABPersonPhoneProperty)));
            CFStringRef firstName, lastName;
            firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
            lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
            
            if(!firstName)
                firstName = (CFStringRef) @"";
            if(!lastName)
                lastName = (CFStringRef) @"";
            
            model.name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
            
            // For contact picture
            UIImage *contactPicture;
            
            if (ref != nil && ABPersonHasImageData(ref)) {
                if ( &ABPersonCopyImageDataWithFormat != nil ) {
                    // iOS >= 4.1
                    contactPicture = [UIImage imageWithData:(NSData *)CFBridgingRelease(ABPersonCopyImageDataWithFormat(ref, kABPersonImageFormatThumbnail))];
                    model.img = contactPicture;
                } else {
                    // iOS < 4.1
                    contactPicture = [UIImage imageWithData:(NSData *)CFBridgingRelease(ABPersonCopyImageData(ref))];
                    model.img = contactPicture;
                }
            }
            
            if ( [model.country isEqualToString:@"US"] ) {
                
                [contactsArray addObject:model];
                
            }
            
            //For Phone number
            /*NSString* mobileLabel;
            for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) {
                
                mobileLabel = (NSString*)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(phones, i));
                if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
                {
                    model.description = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, i));
                    [contactsArray addObject:model];
                    break ;
                }
                else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
                {
                    model.description = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, i));
                    [contactsArray addObject:model];
                    break ;
                }else if ([mobileLabel isEqualToString:(NSString*)kABHomeLabel])
                {
                    model.description = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, i));
                    [contactsArray addObject:model];
                    break ;
                }else if ([mobileLabel isEqualToString:(NSString*)kABWorkLabel])
                {
                    model.description = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, i));
                    [contactsArray addObject:model];
                    break ;
                }
            }*/
        }
    }
    
    // Reload table data after all the contacts get loaded
    contactBackupArray = nil;
    contactBackupArray = contactsArray;
    [[self uiTableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [self hideLoadingIndicator];
    
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSArray *) getArrayOfSelectedTab{
    
        return contactsArray;
}

-(NSArray *) getBackupArrayOfSelectedTab{
    
        return contactBackupArray;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = ([[self getArrayOfSelectedTab] count]);
    return  count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *cellId = @"InviteCell";
    InviteFriendsCell *cell = (InviteFriendsCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    
    if( IS_IPHONE_5 ){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InviteFriendsCell" owner:self options:nil];
        cell = (InviteFriendsCell *)[nib objectAtIndex:0];
    } else if ( IS_IPHONE_6 ){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InviteFreindsCell-iPhone6" owner:self options:nil];
        cell = (InviteFriendsCell *)[nib objectAtIndex:0];
    } else if ( IS_IPHONE_6_PLUS ) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InviteFreindsCell-iPhone6-Plus" owner:self options:nil];
        cell = (InviteFriendsCell *)[nib objectAtIndex:0];
    }
    
    
    if(!self.selectedIdentifiers){
        self.selectedIdentifiers = [[NSMutableArray alloc] init];
    }
    
    ContactsModel *receivedDic;
    
    if ( [[ self getArrayOfSelectedTab ] count ] >= 1 ){
        
        // GETTING DATA FROM RECEIVED DICTIONARY
        // SET OVER MODEL FROM DATA
        
        receivedDic = [self getArrayOfSelectedTab ][(indexPath.row)];
    }
    
    if (receivedDic.img == nil) {
        receivedDic.img =[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dfcontact" ofType:@"jpg"]];
    }
    
    // HERE WE CHECK STATUS OF FRIEND INVITE
    int status = 0;
    
    if ([self ckeckExistdb:receivedDic.description]) {
        //status = 2;
    }else{
        if ([self ckeckExistContact:receivedDic.description]) {
            //status = 1;
            
        }else{
            //status = 0;
            
        }
    }
    
    
    // HERE WE PASS DATA TO CELL CLASS
    [cell setCellObjects:receivedDic :status :@"PrintInvites"];
    
    return cell;
}

- (BOOL)ckeckExistdb:(NSString *)identifier{
    NSMutableArray *checkary = [[NSMutableArray alloc] init];
   checkary = iPhoneinvited;
   
    
    for (int i = 0; i < checkary.count ; i++) {
        if ([identifier isEqualToString:checkary[i]]) {
            return YES;
        }
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    ContactsModel *model = [self getArrayOfSelectedTab][(indexPath.row)];
    
        //CHECK FOR ALREADY SELECTED
        if (model.status == 0) {
            
            [model setInvitedStatus:1];
            [selectedIdentifiers addObject:model];
            
        }else if (model.status == 1) {
            
            [model setInvitedStatus:0];
            
            //REMOVE FROM SENDING LIST
            [selectedIdentifiers removeObject:model.streetAddress];
            
        }
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
        [[self uiTableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        
        return YES;
    }
    
    NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
    
    for(int contactIndex=0; contactIndex<[[self getBackupArrayOfSelectedTab] count]; contactIndex++){
        // Get left contact data
        
        ContactsModel *model = [self getBackupArrayOfSelectedTab][contactIndex];
        
        NSString *name = model.name;
        
        if([[name lowercaseString] rangeOfString:[newString lowercaseString]].location == NSNotFound){
        } else {
            [filteredArray addObject:model];
        }
    }
    
    contactsArray = filteredArray;
    
    [[self uiTableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    return YES;
}



#pragma mark - All Shared Response

// These are used if you do not provide your own custom UI and delegate
- (void)sharerStartedSending:(SHKSharer *)sharer
{
    
	if (!sharer.quiet)
		[[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Saving to %@", [[sharer class] sharerTitle]) forSharer:sharer];
}

- (void)sharerFinishedSending:(SHKSharer *)sharer
{

    PFUser *user = [PFUser currentUser];
    
    // Here we Check Sharer for
    // Update PARSE
    if ( [sharer isKindOfClass:[SHKTextMessage class]] == YES ) {
        
        // HERE WE GET AND SET SELECTED CONTACT LIST
        [iPhoneinvited  addObjectsFromArray:selectedIdentifiers];
        user[@"iphoneinvited"] = iPhoneinvited;
        [self friendsInvited];
        
        
    }
    
    // HERE WE UPDATE PARSE ACCOUNT FOR REMEMBER INVITED FRIENDS LIST
    [user saveInBackground];
    
    [self showAlert:@"Invitation Sent!" message:@"You have successfully invited your friends to join flyerly."];
    [selectedIdentifiers   removeAllObjects];
    [self.uiTableView reloadData ];
    
    
    if (!sharer.quiet)
		[[SHKActivityIndicator currentIndicator] displayCompleted:SHKLocalizedString(@"Saved!") forSharer:sharer];
}

- (void)sharer:(SHKSharer *)sharer failedWithError:(NSError *)error shouldRelogin:(BOOL)shouldRelogin
{
    
    [[SHKActivityIndicator currentIndicator] hideForSharer:sharer];
	NSLog(@"Sharing Error");
}

- (void)sharerCancelledSending:(SHKSharer *)sharer
{
    
    if ( [sharer isKindOfClass:[SHKTwitter class]] == YES ) {
        [selectedIdentifiers   removeAllObjects];
    }
    [self.uiTableView reloadData ];
}

- (void)sharerShowBadCredentialsAlert:(SHKSharer *)sharer
{
    NSString *errorMessage = SHKLocalizedString(@"Sorry, %@ did not accept your credentials. Please try again.", [[sharer class] sharerTitle]);
    
    [[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Login Error")
                                message:errorMessage
                               delegate:nil
                      cancelButtonTitle:SHKLocalizedString(@"Close")
                      otherButtonTitles:nil] show];
}

- (void)sharerShowOtherAuthorizationErrorAlert:(SHKSharer *)sharer
{
    NSString *errorMessage = SHKLocalizedString(@"Sorry, %@ encountered an error. Please try again.", [[sharer class] sharerTitle]);
    
    [[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Login Error")
                                message:errorMessage
                               delegate:nil
                      cancelButtonTitle:SHKLocalizedString(@"Close")
                      otherButtonTitles:nil] show];
}

- (void)hideActivityIndicatorForSharer:(SHKSharer *)sharer {
    
    [[SHKActivityIndicator currentIndicator]  hideForSharer:sharer];
}

- (void)displayActivity:(NSString *)activityDescription forSharer:(SHKSharer *)sharer {
    
    if (sharer.quiet) return;
    
    [[SHKActivityIndicator currentIndicator]  displayActivity:activityDescription forSharer:sharer];
}

- (void)displayCompleted:(NSString *)completionText forSharer:(SHKSharer *)sharer {
    
    if (sharer.quiet) return;
    [[SHKActivityIndicator currentIndicator]  displayCompleted:completionText forSharer:sharer];
}

- (void)showProgress:(CGFloat)progress forSharer:(SHKSharer *)sharer {
    
    if (sharer.quiet) return;
    [[SHKActivityIndicator currentIndicator]  showProgress:progress forSharer:sharer];
}

#pragma mark Flurry Methods

-(void) friendsInvited {
    [Flurry logEvent:@"Friends Invited"];
}


/*
 * Here we Open Buy Panel
 */
-(void)openBuyPanel : (int) totalContactsToSendPrint {
    // Create a PayPalPayment
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    
    // Amount, currency, and description
    NSDecimalNumber *totalAmount = [[NSDecimalNumber alloc] initWithInt:(2 * totalContactsToSendPrint)];
    payment.amount = totalAmount;
    payment.currencyCode = @"USD";
    payment.shortDescription = @"Printing Flyer PostCard";
    
    // Use the intent property to indicate that this is a "sale" payment,
    // meaning combined Authorization + Capture. To perform Authorization only,
    // and defer Capture to your server, use PayPalPaymentIntentAuthorize.
    payment.intent = PayPalPaymentIntentSale;
    
    // Check whether payment is processable.
    if ( payment.processable ) {
        // If, for example, the amount was negative or the shortDescription was empty, then
        // this payment would not be processable. You would want to handle that here.
        PayPalPaymentViewController *paymentViewController;
        paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                       configuration:self.payPalConfiguration
                                                                            delegate:self];
        
        // Present the PayPalPaymentViewController.
        [self presentViewController:paymentViewController animated:YES completion:nil];
    }
}

#pragma mark - Paypal delegate

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController
                 didCompletePayment:(PayPalPayment *)completedPayment {
    

    // Dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Successfully logged in.");
        [self sendPdfFlyer];
    }];
    
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    // The payment was canceled; dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) sendPdfFlyer {
    
    SendingPrintViewController *sendingControoler = [[SendingPrintViewController alloc]initWithNibName:@"SendingPrintViewController" bundle:nil];
    sendingControoler.flyer = self.flyer;
    sendingControoler.contactsArray = self.selectedIdentifiers;
	[self.navigationController pushViewController:sendingControoler animated:YES];

}

#pragma mark - Message UI Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [self.navigationController.visibleViewController dismissViewControllerAnimated:NO completion:nil];
    NSString* message = nil;
    switch(result)
    {
        case MFMailComposeResultCancelled:
            message = @"Not sent at user request.";
            break;
        case MFMailComposeResultSaved:
            message = @"Saved";
            break;
        case MFMailComposeResultSent:
            message = @"Sent";
            break;
        case MFMailComposeResultFailed:
            message = @"Error";
    }
    NSLog(@"%s %@", __PRETTY_FUNCTION__, message);
}

@end