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
#import "Lob/LobRequest.h"
#import "LobObjectModel.h"
#import "PayPalPaymentViewController.h"

static NSString *testApiKey = @"test_13fb536c2d9e23b0e25657d9f923261b03b";

@interface InviteForPrint ()


@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;

@end

LobRequest *request;

@implementation InviteForPrint
@synthesize uiTableView, contactsArray, selectedIdentifiers, searchTextField, iPhoneinvited,flyer;
@synthesize contactBackupArray;


#pragma mark  View Appear Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //[self ebayUploadPicture];

    // use default environment, should be Production in real life
    //self.environment = PayPalEnvironmentSandbox;
    
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
    label.textAlignment = UITextAlignmentCenter;
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
	[inviteButton addTarget:self action:@selector(invite) forControlEvents:UIControlEventTouchUpInside];
    [inviteButton setBackgroundImage:[UIImage imageNamed:@"invite_friend"] forState:UIControlStateNormal];
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
    
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentSandbox];
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
    }
    /*if([identifiers count] > 0){
        
        // Send invitations
        if(selectedTab == 0){
            globle.accounts = [[NSMutableArray alloc] initWithArray:selectedIdentifiers];
            
            SHKItem *item = [SHKItem text:@"I'm using the Flyerly app to create and share flyers on the go! Want to give it a try? Flyer.ly/Invite "];
            item.textMessageToRecipients = selectedIdentifiers;
            
            iosSharer = [[ SHKSharer alloc] init];
            iosSharer = [SHKTextMessage shareItem:item];
            iosSharer.shareDelegate = self;
            
            
        }else if(selectedTab == 1){
            
            SHKItem *i = [SHKItem text:@"I'm using the Flyerly app to create and share flyers on the go! Want to give it a try? http://Flyer.ly/Invite"];
            
            NSArray *shareFormFields = [SHKFacebookCommon shareFormFieldsForItem:i];
            SHKFormController *rootView = [[SHKCONFIG(SHKFormControllerSubclass) alloc] initWithStyle:UITableViewStyleGrouped
                                                                                                title:nil
                                                                                     rightButtonTitle:SHKLocalizedString(@"Send to Facebook")
                                           ];
            
            [rootView addSection:shareFormFields header:nil footer:i.URL!=nil?i.URL.absoluteString:nil];
            
            
            rootView.validateBlock = ^(SHKFormController *form) {
                
                // default does no checking and proceeds to share
                [form saveForm];
                
            };
            
            
            rootView.saveBlock = ^(SHKFormController *form) {
                
                [self updateItemWithForm:form];
                [self fbSend];
                
            };
            
            rootView.cancelBlock = ^(SHKFormController *form) {
                
                [self fbCancel];
                
            };
            
            [[SHK currentHelper] showViewController:rootView];
            
        }
        
    } else {
        [self showAlert:@"Please select any contact to invite !" message:@""];
    }
    
    [Flurry logEvent:@"Friends Invited"];*/
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
        ABAddressBookRef m_addressbook = ABAddressBookCreate();
        searchTextField.text = @"";
        
        if (m_addressbook == NULL) {
            m_addressbook = ABAddressBookCreate();
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
        
        if ( ![[contactInfoDict objectForKey:@"streetAddress"] isEqualToString:@""] && ![[contactInfoDict objectForKey:@"state"] isEqualToString:@""] && ![[contactInfoDict objectForKey:@"city"] isEqualToString:@""] && ![[contactInfoDict objectForKey:@"country"] isEqualToString:@""] ) {
            
            model.streetAddress = [contactInfoDict objectForKey:@"streetAddress"];
            model.state = [contactInfoDict objectForKey:@"state"];
            model.city = [contactInfoDict objectForKey:@"city"];
            model.country = [contactInfoDict objectForKey:@"country"];
            
            
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
            
            [contactsArray addObject:model];
            
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
    
    if ( cell == nil ) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InviteFriendsCell" owner:self options:nil];
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
        status = 2;
    }else{
        if ([self ckeckExistContact:receivedDic.description]) {
            status = 1;
            
        }else{
            status = 0;
            
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
            [selectedIdentifiers addObject:model.streetAddress];
            
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
    payment.shortDescription = @"Printing";
    
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
    sendingControoler.contactsArray = self.contactsArray;
	[self.navigationController pushViewController:sendingControoler animated:YES];
    
    /*sendingControoler.flyer = self.flyer;
    // Present the Sending Print Controller.
    [self presentModalViewController:sendingControoler animated:NO];*/
    /*if ( [MFMailComposeViewController canSendMail] ) {
        
        // Prepare the email in a background thread.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0), ^{
            
            // Prepare email.
            MFMailComposeViewController* mailer = [[MFMailComposeViewController alloc] init];
            mailer.mailComposeDelegate = self;
            
            // The subject.
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MMMM d, YYY"];
            
            [mailer setSubject:@"Flyer"];

            
            [mailer addAttachmentData:[self exportFlyerToPDF] mimeType:@"application/pdf" fileName:@"Flyer.pdf"];
            
            // We are done. Now bring up the email in main thread.
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.navigationController.visibleViewController presentModalViewController:mailer animated:YES];
            });
        });
    }*/
}

/**
 * Upload picture to ebay.
 */
-(void)ebayUploadPicture{
    
    #define Test_Address_Harry @{@"name" : @"HARRY ZHANG", \
    @"email" : [NSNull null], \
    @"phone" : [NSNull null], \
    @"address_line1" : @"1600 AMPHITHEATRE PKWY", \
    @"address_line2" : @"UNIT 199", \
    @"address_city" : @"MOUNTAIN VIEW", \
    @"address_state" : @"CA", \
    @"address_zip" : @"94085", \
    @"address_country" : @"UNITED STATES"}
    
    NSMutableDictionary *sendingFromAddress_ = [[NSMutableDictionary alloc] init];
    [sendingFromAddress_ setObject:@"Jenn" forKey:@"name"];
    [sendingFromAddress_ setObject:@"123 Test Avenue" forKey:@"address_line1"];
    [sendingFromAddress_ setObject:@"Seattle" forKey:@"address_city"];
    [sendingFromAddress_ setObject:@"WA" forKey:@"address_state"];
    [sendingFromAddress_ setObject:@"94041" forKey:@"address_zip"];
    [sendingFromAddress_ setObject:@"US" forKey:@"address_country"];
    
    NSDictionary *postcardDict = @{@"name" : @"Demo Postcard",
                                   @"front" : @"https://www.lob.com/postcardfront.pdf",
                                   @"back" : @"https://www.lob.com/postcardback.pdf",
                                   @"to" : Test_Address_Harry,
                                   @"from" : Test_Address_Harry};
    
    LobPostcardModel *postcardModel = [LobPostcardModel initWithDictionary:postcardDict];
    
    request = [[LobRequest alloc] initWithAPIKey:testApiKey];
    
    [request createPostcardWithModel:postcardModel
                        withResponse:^(LobPostcardModel *postcard, NSError *error)
     {
         NSLog(@"*** Postcard Create Response ***");
         
         NSLog(@"%u", request.statusCode);

     }];
    
    return;
    
    //NSDictionary *pdfDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:[self exportFlyerToPDF]];
    
    NSDictionary *objectDict = @{@"name" : @"Go Blue",
                                 @"setting" : @{@"id" : @"100"},
                                 @"file" : [self exportFlyerToPDF]};
    
    LobObjectModel *objectModel = [LobObjectModel initWithDictionary:objectDict];
    objectModel.localFilePath = YES;
    
    
    NSMutableDictionary *sendingToAddress = [[NSMutableDictionary alloc] init];
    [sendingToAddress setObject:@"Zhang" forKey:@"name"];
    [sendingToAddress setObject:@"123 Test Street" forKey:@"address_line1"];
    [sendingToAddress setObject:@"Mountain View" forKey:@"address_city"];
    [sendingToAddress setObject:@"CA" forKey:@"address_state"];
    [sendingToAddress setObject:@"94041" forKey:@"address_zip"];
    [sendingToAddress setObject:@"US" forKey:@"address_country"];
    
    NSMutableDictionary *sendingFromAddress = [[NSMutableDictionary alloc] init];
    [sendingFromAddress setObject:@"Jenn" forKey:@"name"];
    [sendingFromAddress setObject:@"123 Test Avenue" forKey:@"address_line1"];
    [sendingFromAddress setObject:@"Seattle" forKey:@"address_city"];
    [sendingFromAddress setObject:@"WA" forKey:@"address_state"];
    [sendingFromAddress setObject:@"94041" forKey:@"address_zip"];
    [sendingFromAddress setObject:@"US" forKey:@"address_country"];
    
    
    NSMutableDictionary *lodDictionary = [[NSMutableDictionary alloc] init];
    
    [lodDictionary setObject:@"Post card ID" forKey:@"id"];
    [lodDictionary setObject:@"Custom Name" forKey:@"name"];
    [lodDictionary setObject:@"Custom Message" forKey:@"message"];
    [lodDictionary setObject:sendingToAddress forKey:@"to"];
    [lodDictionary setObject:sendingFromAddress forKey:@"from"];
    [lodDictionary setObject:@"https://www.lob.com/postcardfront.pdf" forKey:@"front"];
    [lodDictionary setObject:@"https://www.lob.com/postcardback.pdf" forKey:@"back"];
    
    /*LobPostcardModel *flyerPostCard = [[LobPostcardModel alloc] initWithDictionary:lodDictionary];
    
    [request createPostcardWithModel:flyerPostCard withResponse:^(LobPostcardModel *postcard, NSError *error){
         NSLog(@"%@",postcard);
         NSLog(@"%@",error);
     }];*/
    
    /*
    LobAddressModel *sendingFromAddress_ = [[LobAddressModel alloc] initAddressWithName:@"Jenn" email:@"sample@gmail.com" phone:@"123456789" addressLine1:@"123 Test Avenue" addressLine2:@"123 Test Avenue" addressCity:@"Seattle" addressState:@"WA" addressZip:@"94041" addressCountry:@"US"];
    
    
    //for (int i=0;i<contactsArray.count;i++){
        
        //ContactsModel *model__ = [[ContactsModel alloc] init];
        //model__ = [contactsArray objectAtIndex:i];
        
        LobAddressModel *sendingToAddress_ = [[LobAddressModel alloc] initAddressWithName:@"Zhang" email:@"sample@gmail.com" phone:@"123456789" addressLine1:@"123 Test Street" addressLine2:@"123 Test Street"  addressCity:@"Mountain View" addressState:@"CA" addressZip:@"94041" addressCountry:@"US"];
        
        LobPostcardModel *flyerPostCard_ = [[LobPostcardModel alloc] initPostcardWithName:@"My Flyer" message:@"Please Checkout my new flyer" toAddress:sendingToAddress_ fromAddress:sendingFromAddress_ status:@"2" price:@"$2" frontUrl:@"https://www.lob.com/postcardfront.pdf" backUrl:@"https://www.lob.com/postcardback.pdf" fullBleed:YES];
    
    //}
    
    //LobPostcardModel *flyerPostCard = [[LobPostcardModel alloc] init];
    
    request = [[LobRequest alloc] initWithAPIKey:testApiKey];
    
    [request createPostcardWithModel:flyerPostCard_ withResponse:^(LobPostcardModel *postcard, NSError *error){
        
        NSLog(@"%@", postcard.status);
        NSLog(@"%@", error.debugDescription);
        
    }];

    
    /*
    self.status = dict[@"status"];
    self.price = dict[@"price"];
    self.frontUrl = dict[@"front"];
    self.backUrl = dict[@"back"];
    
    if(dict[@"full_bleed"]) self.fullBleed = [dict[@"full_bleed"] boolValue];
    else self.fullBleed = false;*/
        
    /*NSString *urlString = @"https://api.lob.com/v1/postcards";
    
    NSData *pdfData = [NSData dataWithData:[self exportFlyerToPDF]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:urlString parameters:@"test_0dc8d51e0acffcb1880e0f19c79b2f5b0cc" constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:pdfData name:@"FlyerPDF" fileName:@"flyer.pdf" mimeType:@"application/pdf"];
        [formData appendPartWithFormData:[[NSString stringWithUTF8String:"Preston Junger"] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:@"name"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];*/
    
}


/**
 * Prepare the flyer in PDF format.
 */
- (NSMutableData *) exportFlyerToPDF {
    
    // Create the PDF context using the default page size of 612 x 792.
    CGSize pageSize = CGSizeMake( 1800, 1200);
    NSMutableData *pdfData = [NSMutableData data];
    
    // Make the context.
    UIGraphicsBeginPDFContextToData(pdfData, CGRectZero, nil);
    
    // Get reference to context.
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Prepare the page.
    UIView *page = [self newPageInPDFWithTitle:@"Flyer" pageSize:pageSize];
    
    NSString *imageToPrintPath = [flyer getFlyerImage];
    UIImage *imageToPrint =  [UIImage imageWithContentsOfFile:imageToPrintPath];
    
    //You need to specify the frame of the view
    UIView *catView = [[UIView alloc] initWithFrame:CGRectMake(200,0,1200,1200)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:imageToPrint];
    
    //specify the frame of the imageView in the superview , here it will fill the superview
    imageView.frame = catView.bounds;
    
    // add the imageview to the superview
    [catView addSubview:imageView];
    
    [page addSubview:catView];

    // Render the last page.
    [page.layer renderInContext:context];
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
    
    return pdfData;
    
}

/**
 * Prepare a new page.
 */
- (UIView *)newPageInPDFWithTitle:(NSString *)titleStr pageSize:(CGSize)pageSize {

    // First Page
    CGRect pageFrame = CGRectMake(0, 0, pageSize.width, pageSize.height);
    UIGraphicsBeginPDFPageWithInfo( pageFrame, nil);
    
    // Fill with background color.
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pageSize.width,
                                                            pageSize.height)];
    view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pdf_Bg.png"]];

    //You need to specify the frame of the view
    UIView *catView = [[UIView alloc] initWithFrame:CGRectMake(1620,1130,150,60)];
    
    UIImage *image = [UIImage imageNamed:@"flyerlylogo.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    //specify the frame of the imageView in the superview , here it will fill the superview
    imageView.frame = catView.bounds;
    
    // add the imageview to the superview
    [catView addSubview:imageView];
    
    [view addSubview:catView];
    
    return view;
}

#pragma mark - Message UI Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [self.navigationController.visibleViewController dismissModalViewControllerAnimated:YES];
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