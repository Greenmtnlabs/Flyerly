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
        
        if ( ![[contactInfoDict objectForKey:@"streetAddress"] isEqualToString:@""] && ![[contactInfoDict objectForKey:@"city"] isEqualToString:@""] && ![[contactInfoDict objectForKey:@"country"] isEqualToString:@""] ) {
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
            
            //For Phone number
            NSString* mobileLabel;
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
            }
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
            [selectedIdentifiers addObject:model.description];
            
        }else if (model.status == 1) {
            
            [model setInvitedStatus:0];
            
            //REMOVE FROM SENDING LIST
            [selectedIdentifiers removeObject:model.description];
            
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
    payment.amount = totalAmount;//[NSDecimalNumber decimalNumberWithDecimal:totalAmount];
    payment.currencyCode = @"USD";
    payment.shortDescription = @"Printing";//pqProduct.title;
    
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
    [self dismissViewControllerAnimated:YES completion:nil];
    [self sendPdfFlyer];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    // The payment was canceled; dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) sendPdfFlyer {
    
    if ( [MFMailComposeViewController canSendMail] ) {
        
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
    }
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
    UIView *catView = [[UIView alloc] initWithFrame:CGRectMake(0,0,1200,1200)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:imageToPrint];
    
    //specify the frame of the imageView in the superview , here it will fill the superview
    imageView.frame = catView.bounds;
    
    // add the imageview to the superview
    [catView addSubview:imageView];
    
    [page addSubview:catView];
    
    // Show teams information.
    /*CGRect frame = CGRectMake( 20, 65, 266, 300);
    UIView *team = [self teamInformationInPDF:match.firstTeam frame:frame];
    [page addSubview:team];
    
    // Second team.
    frame.origin = CGPointMake( frame.size.width + 60, 65);
    team = [self teamInformationInPDF:match.secondTeam frame:frame];
    [page addSubview:team];
    
    // Versus label.
    UILabelPDF *versus = [[UILabelPDF alloc] initWithFrame:CGRectMake( 282, 180, 50, 25)];
    versus.backgroundColor = [UIColor clearColor];
    versus.textColor = [UIColor lightGrayColor];
    versus.font = [UIFont fontWithName:@"Gurmukhi MN"
                                  size:25.0f];
    versus.textAlignment = UITextAlignmentCenter;
    versus.text = @"vs";
    [page addSubview:versus];
    
    // Rules label.
    UILabelPDF *rules = [[UILabelPDF alloc] initWithFrame:CGRectMake( 20, 375, 266, 25)];
    rules.backgroundColor = [UIColor clearColor];
    rules.textColor = [UIColor lightGrayColor];
    rules.font = [UIFont fontWithName:@"Gurmukhi MN"
                                 size:17.0f];
    rules.textAlignment = UITextAlignmentLeft;
    rules.text = @"Rules";
    [page addSubview:rules];
    
    UIView *rulesView = [self rulesInformationInPDFForFrame:CGRectMake(20, 400, 266, 165)];
    [page addSubview:rulesView];
    
    // Officials label.
    UILabelPDF *officials = [[UILabelPDF alloc] initWithFrame:CGRectMake( frame.origin.x, 375, 266, 25)];
    officials.backgroundColor = [UIColor clearColor];
    officials.textColor = [UIColor lightGrayColor];
    officials.font = [UIFont fontWithName:@"Gurmukhi MN"
                                     size:17.0f];
    officials.textAlignment = UITextAlignmentLeft;
    officials.text = @"Officials";
    [page addSubview:officials];
    
    // List of officials
    UIView *officialsView = [self officialsInformationInPDFForFrame:CGRectMake( frame.origin.x, 400,
                                                                               266, 165)];
    [page addSubview:officialsView];
    
    // Venue, weather and date.
    UIView *venueAndWeather = [self venueAndWeatherInformationInPDFForFrame:CGRectMake(20, 575, 572, 180)];
    [page addSubview:venueAndWeather];
    
    // Attributions.
    UIImageView *gImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 765, 104, 16)];
    gImg.image = [UIImage imageNamed:@"powered-by-google.png"];
    [page addSubview:gImg];
    
    UIImageView *wImg = [[UIImageView alloc] initWithFrame:CGRectMake(110, 762, 104, 20)];
    wImg.contentMode = UIViewContentModeScaleAspectFit;
    wImg.image = [UIImage imageNamed:@"wunderground.png"];
    [page addSubview:wImg];
    
    [page.layer renderInContext:context];
    
    // Match Analysis page.
    page = [self newPageInPDFWithTitle:@"Match Analysis" pageSize:pageSize];
    
    // Prepare the worm sections.
    UIImageView *sectionWorm = [[UIImageView alloc] initWithFrame:CGRectMake(20, 60, 572, 220)];
    sectionWorm.backgroundColor = [UIColor whiteColor];
    sectionWorm.layer.cornerRadius = 5.0;
    
    AnalysisViewController *analysisW = [[AnalysisViewController alloc] initWithFrame:CGRectMake(5, 5,
                                                                                                 sectionWorm.frame.size.width - 10, sectionWorm.frame.size.height - 10)
                                                                                 type:FOW_TYPE_WORM];
    sectionWorm.image = [analysisW.hostView.hostedGraph imageOfLayer];
    [page addSubview:sectionWorm];
    
    // Prepare the manhattan section.
    UIImageView *sectionManhattan = [[UIImageView alloc] initWithFrame:CGRectMake(20, 300, 572, 220)];
    sectionManhattan.backgroundColor = [UIColor whiteColor];
    sectionManhattan.layer.cornerRadius = 5.0;
    
    AnalysisViewController *analysisM = [[AnalysisViewController alloc] initWithFrame:CGRectMake(5, 5,
                                                                                                 sectionManhattan.frame.size.width - 10,
                                                                                                 sectionManhattan.frame.size.height - 10)
                                                                                 type:FOW_TYPE_MANHATTAN];
    sectionManhattan.image = [analysisM.hostView.hostedGraph imageOfLayer];
    [page addSubview:sectionManhattan];
    
    // Prepare the run rate section.
    UIImageView *sectionRunrate = [[UIImageView alloc] initWithFrame:CGRectMake(20, 540, 572, 220)];
    sectionRunrate.backgroundColor = [UIColor whiteColor];
    sectionRunrate.layer.cornerRadius = 5.0;
    
    AnalysisViewController *analysisR = [[AnalysisViewController alloc] initWithFrame:CGRectMake(5, 5,
                                                                                                 sectionRunrate.frame.size.width - 10,
                                                                                                 sectionRunrate.frame.size.height - 10)
                                                                                 type:FOW_TYPE_RUNRATE];
    sectionRunrate.image = [analysisR.hostView.hostedGraph imageOfLayer];
    [page addSubview:sectionRunrate];
    
    // Render the page.
    [page.layer renderInContext:context];
    
    // Second page
    page = [self newPageInPDFWithTitle:@"Scorecard - 1st Innings" pageSize:pageSize];
    
    UIView *innings1 = [self inningScorecardInPDF:0 frame:CGRectMake(0, 40,
                                                                     pageSize.width,
                                                                     pageSize.height )];
    [page addSubview:innings1];
    
    // Render the page.
    [page.layer renderInContext:context];
    
    
    // Third page
    page = [self newPageInPDFWithTitle:@"Scorecard - 2nd Innings" pageSize:pageSize];
    
    UIView *innings2 = [self inningScorecardInPDF:1 frame:CGRectMake(0, 40,
                                                                     pageSize.width,
                                                                     pageSize.height )];
    [page addSubview:innings2];
    
    // Render the page.
    [page.layer renderInContext:context];
    
    // Head to Head.
    // Prepare the list we will use.
    NSArray *list = [self headToHead];
    
    // Get the innings string.
    HeadToHead *headToHead = [list objectAtIndex:0];
    int inning = headToHead.inning;
    
    // Start with a new page.
    if ( inning == 0 ) {
        page = [self newPageInPDFWithTitle:@"Head to Head Comparison - 1st Innings" pageSize:pageSize];
    } else if ( inning == 1 ) {
        page = [self newPageInPDFWithTitle:@"Head to Head Comparison - 2nd Innings" pageSize:pageSize];
    }
    
    CGFloat currentHeight = 40;
    CGFloat requiredHeight = 0;
    
    for ( int i = 0; i < list.count; i++ ) {
        HeadToHead *element = [list objectAtIndex:i];
        
        UIView *item = nil;
        
        // Display header for this batsman.
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HeadToHeadHeader" owner:nil options:nil];
        HeadToHeadHeaderView *summary = (HeadToHeadHeaderView *)[nib objectAtIndex:0];
        summary.frame = CGRectMake( 0, currentHeight, pageSize.width, 35);
        
        // Set name of the batsman.
        summary.name.text = PLAYER_SHORT_NAME( element.batsman );
        item = summary;
        
        // We should have atleast this height on the page
        requiredHeight = 85;
        
        NSArray *statsAgainstBowlers = element.statsAgainstBowlers;
        for ( int j = 0; j < statsAgainstBowlers.count + 1; j++ ) {
            if ( j > 0 ) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HeadToHeadView" owner:nil options:nil];
                HeadToHeadView *summary = (HeadToHeadView *)[nib objectAtIndex:0];
                summary.frame = CGRectMake( 0, currentHeight, pageSize.width, 25);
                
                BattingStats *stats = [statsAgainstBowlers objectAtIndex:j - 1];
                
                NSString *wktString = @"";
                if( stats.wicketType == BOWLED ) {
                    wktString = @"Bowled";
                } else if ( stats.wicketType == CAUGHT ) {
                    wktString = @"Caught";
                } else if ( stats.wicketType == LBW ) {
                    wktString = @"LBW";
                } else if ( stats.wicketType == STUMPED ) {
                    wktString = @"Stumped";
                } else if ( stats.wicketType == RUNOUT ) {
                    wktString = @"Runout";
                } else if ( stats.wicketType == RETIREOUT ){
                    wktString = @"Retired";
                }
                
                // Fill data.
                summary.bowler.text = PLAYER_SHORT_NAME( stats.bowler );
                summary.zero.text = [NSString stringWithFormat:@"%u", stats.zeros];
                summary.one.text = [NSString stringWithFormat:@"%u", stats.ones];
                summary.two.text = [NSString stringWithFormat:@"%u", stats.twos];
                summary.three.text = [NSString stringWithFormat:@"%u", stats.threes];
                summary.four.text = [NSString stringWithFormat:@"%u", stats.fours];
                summary.six.text = [NSString stringWithFormat:@"%u", stats.sixes];
                summary.seven.text = [NSString stringWithFormat:@"%u", stats.sevenAndMore];
                summary.dismissal.text = wktString;
                summary.runs.text = [NSString stringWithFormat:@"%u", stats.runs];
                summary.balls.text = [NSString stringWithFormat:@"%u", stats.ballsCount];
                summary.sr.text = [NSString stringWithFormat:@"%.0f", stats.sr];
                
                item = summary;
                
                // We should have atleast this height on the page.
                requiredHeight = 45;
            }
            
            // If this is a new innings, just go to a new page.
            if ( inning != element.inning ) {
                inning = element.inning;
                
                // Start a new page.
                // Render the previous one.
                [page.layer renderInContext:context];
                
                if ( inning == 0 ) {
                    page = [self newPageInPDFWithTitle:@"Head to Head Comparison - 1st Innings" pageSize:pageSize];
                } else if ( inning == 1 ) {
                    page = [self newPageInPDFWithTitle:@"Head to Head Comparison - 2nd Innings" pageSize:pageSize];
                }
                
                CGRect fr = item.frame;
                fr.origin.y = 40;
                item.frame = fr;
                
                [page addSubview:item];
                currentHeight = 40 + item.frame.size.height;
                
                // Update the innings.
                inning = element.inning;
                
            } // If the item can fit within the page and we are not on a different innings.
            else if ( currentHeight + requiredHeight < pageSize.height  ) {
                currentHeight += item.frame.size.height;
                [page addSubview:item];
            } else {
                inning = element.inning;
                
                // Otherwise start a new page.
                // Render the previous one.
                [page.layer renderInContext:context];
                
                if ( inning == 0 ) {
                    page = [self newPageInPDFWithTitle:@"Head to Head Comparison - 1st Innings" pageSize:pageSize];
                } else if ( inning == 1 ) {
                    page = [self newPageInPDFWithTitle:@"Head to Head Comparison - 2nd Innings" pageSize:pageSize];
                }
                
                CGRect fr = item.frame;
                fr.origin.y = 40;
                item.frame = fr;
                
                [page addSubview:item];
                currentHeight = 40 + item.frame.size.height;
            }
        }
    }*/
    
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
    UIView *catView = [[UIView alloc] initWithFrame:CGRectMake(1600,1140,150,60)];
    
    UIImage *image = [UIImage imageNamed:@"flyerlylogo.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    //specify the frame of the imageView in the superview , here it will fill the superview
    imageView.frame = catView.bounds;
    
    // add the imageview to the superview
    [catView addSubview:imageView];
    
    //add the view to the main view
    
    //[self.view addSubview:catView];
//    /[attribution : [UIImage imageNamed:@"pdf_Bg.png"]];
    
    // Attribution
    /*UILabelPDF *attribution = [[UILabelPDF alloc] initWithFrame:
                               CGRectMake(0, pageSize.height - 12, pageSize.width - 5, 12)];
    attribution.backgroundColor = [UIColor clearColor];
    attribution.textColor = [UIColor darkGrayColor];
    attribution.font = [UIFont fontWithName:@"Georgia"
                                       size:10.0f];
    attribution.textAlignment = UITextAlignmentRight;
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        attribution.text = @"Match scored using Cricket Scorekeeper for iPad";
    } else {
        attribution.text = @"Match scored using Cricket Scorekeeper for iPhone";
    }*/
    
    [view addSubview:catView];
    
    // HEADING Bar
    /*UIView *headingBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, barSize.width, barSize.height)];
    headingBar.backgroundColor = [UIColor colorWithRed:(255.0/255.0)
                                                 green:(236.0/255.0)
                                                  blue:(219.0/255.0)
                                                 alpha:1];
    
    UILabelPDF *title = [[UILabelPDF alloc] initWithFrame:CGRectMake(0, 0, barSize.width, barSize.height)];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor colorWithRed:(161.0/255.0)
                                      green:(142.0/255.0)
                                       blue:(92.0/255.0)
                                      alpha:1.0];
    title.font = [UIFont fontWithName:@"Oswald-Regular"
                                 size:18.0f];
    title.textAlignment = UITextAlignmentCenter;
    title.text = titleStr;
    [headingBar addSubview:title];
    
    // Add heading bar to page view.
    [view addSubview:headingBar];*/
    
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