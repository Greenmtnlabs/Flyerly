//
//  InviteFriendsController.h
//  Untechable
//
//  Created by Riksof on 4/15/13.
//
//

#import "InviteFriendsController.h"
#import "Common.h"
#import <QuartzCore/QuartzCore.h>
#import "UserVoice.h"
#import <Parse/Parse.h>
#import "SHKTextMessage.h"
#import "SHKConfiguration.h"
#import "FBRequest.h"
#import "FacebookSDK.h"
#import "SHKiOSSharer.h"
#import "SHKiOSTwitter.h"
#import "SHKSharer.h"
#import "SHKMail.h"

#import <Foundation/Foundation.h>
#import "UntechableConfigurator.h"
#import "AppDelegate.h"


NSString *kCheckTokenStep1 = @"kCheckTokenStep";
NSString *FlickrSharingSuccessNotification = @"FlickrSharingSuccessNotification";
NSString *FlickrSharingFailureNotification = @"FlickrSharingFailureNotification";
NSString *FacebookDidLoginNotification = @"FacebookDidLoginNotification";

#define TIME 10


@implementation InviteFriendsController {

    NSString *cellDescriptionForRefrelFeature;
    NSMutableArray *usernames;
    NSArray *availableAccounts;
    ACAccount *selectedAccount;
    UntechableConfigurator *untechableConfigurator;
}

@synthesize uiTableView, emailsArray, contactsArray, selectedIdentifiers, emailButton, contactsButton, facebookButton, twitterButton,  searchTextField, facebookArray, twitterArray,fbinvited,twitterInvited,iPhoneinvited, emailInvited;
@synthesize emailBackupArray, contactBackupArray, facebookBackupArray, twitterBackupArray,refrelText;
@synthesize fbText;

const int EMAIL_TAB = 3;
const int TWITTER_TAB = 2;
const int FACEBOOK_TAB = 1;
const int CONTACTS_TAB = 0;

#pragma mark  View Appear Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    self.selectedIdentifiers = [[NSMutableArray alloc] init];
    globle = [UntechableSingleton RetrieveSingleton];
    
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication]delegate];
    untechableConfigurator = appDelegate.untechableConfigurator;

    self.navigationItem.hidesBackButton = YES;
    
    // Register notification for facebook login
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FacebookDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fbDidLogin) name:FacebookDidLoginNotification object:nil];
    
    // By default first tab is selected 'Contacts'
    selectedTab = -1;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-28, -6, 50, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = DEF_GRAY;
    label.text = NSLocalizedString(TITLE_INVITE_TXT, nil);
    self.navigationItem.titleView = label;
    
    // Create left bar help button
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
    
    backButton.titleLabel.shadowColor = [UIColor clearColor];
    backButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_LEFT_SIZE];
    [backButton setTitle:NSLocalizedString(TITLE_BACK_TXT, nil) forState:normal];
    [backButton setTitleColor:DEF_GRAY forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton addTarget:self action:@selector(btnTouchStart:) forControlEvents:UIControlEventTouchDown];
    [backButton addTarget:self action:@selector(btnTouchEnd:) forControlEvents:UIControlEventTouchUpInside];
    backButton.showsTouchWhenHighlighted = YES;

    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:backBarButton,nil]];
    
    // INVITE BAR BUTTON
    UIButton *inviteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
    
    inviteButton.titleLabel.shadowColor = [UIColor clearColor];
    inviteButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
    [inviteButton setTitle:NSLocalizedString(TITLE_INVITE_TXT, nil) forState:normal];
    [inviteButton setTitleColor:DEF_GRAY forState:UIControlStateNormal];
   [inviteButton addTarget:self action:@selector(invite) forControlEvents:UIControlEventTouchUpInside];
    [inviteButton addTarget:self action:@selector(btnTouchStart:) forControlEvents:UIControlEventTouchDown];
    [inviteButton addTarget:self action:@selector(btnTouchEnd:) forControlEvents:UIControlEventTouchUpInside];
    inviteButton.showsTouchWhenHighlighted = YES;
   
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:inviteButton];
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];
    inviteButton.showsTouchWhenHighlighted = YES;
    
    
    [self.uiTableView  setBackgroundColor:[UIColor colorWithRed:245/255.0 green:241/255.0 blue:222/255.0 alpha:1.0]];
    [searchTextField setReturnKeyType:UIReturnKeyDone];
        
    // Load device contacts
    [self loadLocalContacts:self.contactsButton];
    
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

#pragma mark -  Highlighting Functions

-(void)btnTouchStart :(id)button{
    [self setHighlighted:YES sender:button];
}
-(void)btnTouchEnd :(id)button{
    [self setHighlighted:NO sender:button];
}
- (void)setHighlighted:(BOOL)highlighted sender:(id)button {
    (highlighted) ? [button setBackgroundColor:DEF_GREEN] : [button setBackgroundColor:[UIColor clearColor]];
}

#pragma mark  Custom Methods

-(IBAction)goBack{
    // To pop UntechablesList
    NSArray *array = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
    
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

- (BOOL)ckeckExistdb:(NSString *)identifier{
    NSMutableArray *checkary = [[NSMutableArray alloc] init];
    if (selectedTab == FACEBOOK_TAB){
        checkary = fbinvited;
    }else if(selectedTab == TWITTER_TAB){
        checkary = twitterInvited;
    } else if (selectedTab == EMAIL_TAB){
        checkary = emailInvited;
    } else {
        checkary = iPhoneinvited;
    }
    
    for (int i = 0; i < checkary.count ; i++) {
        if ([identifier isEqualToString:checkary[i]]) {
            return YES;
        }
    }
    return NO;
}

-(IBAction)invite{
    
    SHKItem *item;
    NSMutableArray *identifiers = [[NSMutableArray alloc] init];
    identifiers = selectedIdentifiers;
    NSLog(@"identifiers = %@,  selectedTab = %i",identifiers, selectedTab);

    NSString *sharingText = [NSString stringWithFormat:NSLocalizedString(@"Take a break from technology. Untech & Reconnect with life: %@", nil),untechableConfigurator.appURL];
    if([identifiers count] > 0){
        
        // Send invitations
        if(selectedTab == 0){ // for SMS
            globle.accounts = [[NSMutableArray alloc] initWithArray:selectedIdentifiers];
            
            item = [SHKItem text:sharingText];
            item.textMessageToRecipients = selectedIdentifiers;
            
            iosSharer = [[SHKSharer alloc] init];
            iosSharer = [SHKTextMessage shareItem:item];
            iosSharer.shareDelegate = self;
   
        }else if(selectedTab == 1){ // for Facebook
            
            item = [SHKItem text:sharingText];
            
            NSArray *shareFormFields = [SHKFacebookCommon shareFormFieldsForItem:item];
            SHKFormController *rootView = [[SHKCONFIG(SHKFormControllerSubclass) alloc] initWithStyle:UITableViewStyleGrouped
                                                                                                title:nil
                                                                                     rightButtonTitle:SHKLocalizedString(@"Send to Facebook")
                                           ];
            
            [rootView addSection:shareFormFields header:nil footer:item.URL!=nil?item.URL.absoluteString:nil];
            
            rootView.validateBlock = ^(SHKFormController *form) {
                
                // default does no checking and proceeds to share
                [form saveForm];
                
            };
        
            rootView.saveBlock = ^(SHKFormController *form) {
                [self updateItemWithForm:form];
            };
            
            rootView.cancelBlock = ^(SHKFormController *form) {
                [self fbCancel];
            };
            
            [[SHK currentHelper] showViewController:rootView];
        } else if (selectedTab == 3) { // for Email
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",untechableConfigurator.appLinkURL]];
            item = [SHKItem URL:url title: NSLocalizedString(@"Invite Friends",nil) contentType:SHKURLContentTypeUndefined];
            [item setMailToRecipients:identifiers];
            item.text =  [NSString stringWithFormat:NSLocalizedString(@"Take a break from technology. Untech & Reconnect with life:", nil)];
            // Share the item with my custom class
            [SHKMail shareItem:item];
        }
    } else {
        [self showAlert:NSLocalizedString(@"Please select any contact to invite!", nil) message:@""];
    }
    
}



#pragma mark  Device Contact List

/*
 * This method is used to load device contact details
 */
- (IBAction)loadLocalContacts:(UIButton *)sender{
    
    [selectedIdentifiers removeAllObjects];
    
    selectedTab = sender.tag;//CONTACTS_TAB;
    
    //[self showLoadingIndicator];
    
    self.selectedIdentifiers = nil;
    self.selectedIdentifiers = [[NSMutableArray alloc] init];
    
    // HERE WE HIGHLIGHT BUTTON SELECT AND
    // UNSELECTED BUTTON
    if(selectedTab == CONTACTS_TAB){
        [emailButton setSelected:NO];
        [contactsButton setSelected:YES];
    }
    if(selectedTab == EMAIL_TAB){
        [emailButton setSelected:YES];
        [contactsButton setSelected:NO];
    }
    
    [twitterButton setSelected:NO];
    [facebookButton setSelected:NO];
    
    
    // init email array
    if( emailBackupArray ){
        
        // Reload table data after all the contacts get loaded
        contactsArray = nil;
        if( selectedTab == CONTACTS_TAB ){
            contactsArray = contactBackupArray;
        } else if( selectedTab == EMAIL_TAB ){
            emailsArray = emailBackupArray;
        }
        
        // Filter contacts on new tab selection
        [self onSearchClick:nil];
        
        [[self uiTableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        //[self hideLoadingIndicator];
        
        
    }
    else {
        contactsArray = [[NSMutableArray alloc] init];
        emailsArray = [[NSMutableArray alloc] init];
        searchTextField.text = @"";
        
        ABAddressBookRef m_addressbook = ABAddressBookCreateWithOptions(NULL, NULL);
        
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
    
        ContactsModel *model = [[ContactsModel alloc] init];
        ContactsModel *modelForEmail = [[ContactsModel alloc] init];
        
        model.others = @"";
        modelForEmail.others = @"";
        
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
        
        model.name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        modelForEmail.name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];

        // For contact picture
        UIImage *contactPicture;
        
        if (ref != nil && ABPersonHasImageData(ref)) {
            if ( &ABPersonCopyImageDataWithFormat != nil ) {
                // iOS >= 4.1
                contactPicture = [UIImage imageWithData:(NSData *)CFBridgingRelease(ABPersonCopyImageDataWithFormat(ref, kABPersonImageFormatThumbnail))];
                model.img = contactPicture;
                modelForEmail.img = contactPicture;
            } else {
                // iOS < 4.1
                contactPicture = [UIImage imageWithData:(NSData *)CFBridgingRelease(ABPersonCopyImageData(ref))];
                model.img = contactPicture;
                modelForEmail.img = contactPicture;
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
        
        
            // For Email
            for(CFIndex i = 0; i < ABMultiValueGetCount(emails); i++) {
                modelForEmail.description = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(emails, i));
                [emailsArray addObject:modelForEmail];
                break;
            }
         }
    
    // Reload table data after all the contacts get loaded
    contactBackupArray = nil;
    contactBackupArray = contactsArray;
    
    emailBackupArray = nil;
    emailBackupArray = emailsArray;
    
    [[self uiTableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    //[self hideLoadingIndicator];
    
}


#pragma mark  Facebook Contact

/**
 * Called when facebook  button is selected on screen
 */
- (IBAction)loadFacebookContacts:(UIButton *)sender{
    FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
    content.appLinkURL = [NSURL URLWithString:untechableConfigurator.appLinkURL];
    
    //optionally set previewImageURL
    content.appInvitePreviewImageURL = [NSURL URLWithString:untechableConfigurator.appInvitePreviewImageURL];

    // present the dialog. Assumes self implements protocol `FBSDKAppInviteDialogDelegate`
    [FBSDKAppInviteDialog showFromViewController:self withContent:content delegate:self];
}


-(void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results {
    NSLog(@"app invite dialog did complete");
}

-(void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error {
    NSLog(@"app invite dialog did fail");
}

-(void) shareViaIOSFacebook:( BOOL ) withAccount {
    SHKItem *item;
    
    // text to be share.
    NSString *sharingText = NSLocalizedString(@"Take a break from technology. Untech & Reconnect with life.", nil);
    
    // app URL with user id.
    NSString *urlToShare = untechableConfigurator.appURL;
    
    //item to be share
    item = [SHKItem URL:[NSURL URLWithString:urlToShare] title:sharingText contentType:SHKShareTypeURL];
    
    if( withAccount ) {
        // we got a facebook account, share it via shkiOSFacebook
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            iosSharer = [[SHKSharer alloc] init];
            [iosSharer loadItem:item];
            iosSharer.shareDelegate = self;
            [iosSharer share];

        });
        
    } else {
        //we didn't have facebook app or account, then we have to use legendary SHKFacebook sharer.
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            iosSharer = [[SHKSharer alloc] init];
            [iosSharer loadItem:item];
            iosSharer.shareDelegate = self;
            [iosSharer share];
        });
    }
}

/* HERE WE CREATE ARRAY LIST FOR UITABLEVIEW WHICH RECIVED FROM FACEBOOK REQUEST
 *@PARAM
 *  followers DICTIONARY
 */
-(void)makeFacebookArray :(NSDictionary *)result{
    
    for (NSDictionary *friendData in result[@"data"]) {
        
        NSString *imageURL = friendData[@"picture"][@"data"][@"url"];
        
        // Here we will get the facebook contacts
        ContactsModel *model = [[ContactsModel   alloc]init];
        
        model.name = friendData[@"name"];
        model.description = friendData[@"id"];
        if (friendData[@"gender"]) {
            model.others = friendData[@"gender"];
        }
        if(imageURL){
            model.img = nil;
            model.imageUrl = imageURL;
        }
        
        [self.facebookBackupArray addObject:model];
        
    }
    
    self.facebookArray = [[NSMutableArray alloc] init];
    facebookArray = facebookBackupArray ;


    
    // Filter contacts on new tab selection
    [self onSearchClick:nil];
    
    [[self uiTableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    {
        
        //[self hideLoadingIndicator];
        
    }
}


/*
 * Here we Get Text from SHKFormController
 */
- (void)updateItemWithForm:(SHKFormController *)form
{
	// Update item with new values from form
    NSDictionary *formValues = [form formValues];
	for(NSString *key in formValues)
	{
		
		if ([key isEqualToString:@"text"]){
            fbText = [formValues objectForKey:key];
        }
    }
}


#pragma mark  TWITTER CONTACTS

/*
 * HERE WE REQUEST TO TWITTER FOR FRIENDS LIST
 */
- (IBAction)loadTwitterContacts:(UIButton *)sender{
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:twitterAccountType
                                          options:nil
                                       completion:^(BOOL granted, NSError *error) {
                                           if ( granted ) {
                                               availableAccounts = [accountStore accountsWithAccountType:twitterAccountType];
                                               
                                               if ([availableAccounts count] > 1) {
                                                   
                                                   usernames = [NSMutableArray arrayWithCapacity:[availableAccounts count]];
                                                   
                                                   for (ACAccount *acc in availableAccounts) {
                                                       [usernames addObject:acc.username];
                                                   }
                                                   
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       UIAlertView *view = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Choose Twitter Account", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel" ,nil) otherButtonTitles:nil];
                                                       
                                                       for( NSString* number in usernames )
                                                           [view addButtonWithTitle:number];
                                                       
                                                       [view show];
                                                   });
                                                   
                                               } else if ([availableAccounts count] > 0 ) {
                                                   
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       // Just use the single account.
                                                       selectedAccount = [availableAccounts objectAtIndex:0];
                                                       [self afterTwitterSelected:selectedAccount];
                                                   });
                                               } else {
                                                   
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       [self afterTwitterSelected:nil];
                                                   });
                                               }
                                               
                                           } else {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   [self afterTwitterSelected:nil];
                                               });
                                           }
                                       }];
}

/**
 After one of twitter account is selected
 **/
-(void)afterTwitterSelected:(ACAccount *)sAccount{
    if ([UntechableSingleton connected]) {
        
        // HERE WE HIGHLIGHT BUTTON SELECT AND
        // UNSELECTED BUTTON
        [contactsButton setSelected:NO];
        [twitterButton setSelected:YES];
        [facebookButton setSelected:NO];
        [emailButton setSelected:NO];
        
        self.selectedIdentifiers = nil;
        self.selectedIdentifiers = [[NSMutableArray alloc] init];
        
        selectedTab = TWITTER_TAB;
        [self.uiTableView reloadData];
        
        
        if (twitterBackupArray == nil || twitterBackupArray.count == 0) {
            searchTextField.text = @"";
            self.twitterBackupArray = [[NSMutableArray alloc] init];
            
            // Current Item For Sharing
            //here we are not set Any Share Type for Override sendStatus Method of SHKTwitter
            SHKItem *item = [[SHKItem alloc] init];
            
            if( sAccount ) {
                [item setCustomValue:sAccount forKey:@"selectedAccount"];
            }
            
            // Create controller and set share options
            iosSharer = [FlyerlyTwitterFriends shareItem:item];
            
            iosSharer.shareDelegate = self;
            
        }else {
            
            [self onSearchClick:nil];
            
            [self.uiTableView reloadData];
        }
        
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"You're not connected to the internet. Please connect and retry.", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(OK, nil) otherButtonTitles:nil, nil];
        
        [alert show];
    }

}

/* HERE WE CREATE ARRAY LIST FOR UITABLEVIEW WHICH RECIVED FROM TWITTER REQUEST
 *@PARAM
 *  followers DICTIONARY
 */
-(void)makeTwitterArray :(NSMutableDictionary *)followers{
    
    NSDictionary *users = followers[@"users"];
    
    for (id user in users) {
        
        ContactsModel *model = [[ContactsModel   alloc]init];
        model.name = user[@"name"];
        model.description = user[@"screen_name"];
        model.others = user[@"location"];
        
        NSString *imageURL = user[@"profile_image_url"];
        NSString *new = [imageURL stringByReplacingOccurrencesOfString: @"normal" withString:@"bigger"];
        
        if(imageURL){
            model.img = nil;
            model.imageUrl = new;
        }
        
        [self.twitterBackupArray addObject:model];
    }
    
    twitterArray = twitterBackupArray;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [uiTableView reloadData];
        //[self hideLoadingIndicator];
    });
}




#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSArray *) getArrayOfSelectedTab{
    if(selectedTab == CONTACTS_TAB)
        return contactsArray;
    else if (selectedTab == EMAIL_TAB)
        return emailsArray;
    else if(selectedTab == FACEBOOK_TAB)
        return facebookArray;
    else
        return twitterArray;
}

-(NSArray *) getBackupArrayOfSelectedTab{
    if(selectedTab == CONTACTS_TAB)
        return contactBackupArray;
    else if (selectedTab == EMAIL_TAB)
        return emailBackupArray;
    else if(selectedTab == FACEBOOK_TAB)
        return facebookBackupArray;
    else
        return twitterBackupArray;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = ((int)[[self getArrayOfSelectedTab] count]);
    NSLog(@"selectedTab = %i , numberOfRowsInSection - count = %i", selectedTab, count );
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
        NSLog(@"selectedTab = %i, indexPath.row = %li",selectedTab, (long)indexPath.row);
       
        receivedDic = [self getArrayOfSelectedTab ][(indexPath.row)];
    }

    if (receivedDic.img == nil) {
        receivedDic.img =[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dfcontact" ofType:@"jpg"]];
    }
    
    //HERE WE LOAD IMAGE FROM URL FOR FACEBOOK AND TWITTER FRIENDS
    if( selectedTab == FACEBOOK_TAB || selectedTab == TWITTER_TAB ){
        
        dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(dispatchQueue, ^(void)
                       {
                           dispatch_sync(dispatch_get_main_queue(), ^{
                               aview = [[AsyncImageView alloc]initWithFrame:CGRectMake(6, 14,72, 72)];
                               [ aview setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];

                               NSURL *imageurl = [NSURL URLWithString:receivedDic.imageUrl];
                               [aview setImageURL:imageurl];
                               [cell.contentView addSubview:aview];
                           });
                       });
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
    [cell setCellObjects:receivedDic :status :@"InviteFriends"];
        
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	

    // HERE WE WORK FOR CONTACTS
    if (selectedTab == 0 || selectedTab == 3) {
        
        ContactsModel *model = [self getArrayOfSelectedTab][(indexPath.row)];
        
        //CHECK FOR ALREADY SELECTED
        if (model.status == 0) {
            [model setInvitedStatus:1];
            [selectedIdentifiers addObject:model.description];
        } else if (model.status == 1) {
            [model setInvitedStatus:0];
            //REMOVE FROM SENDING LIST
            [selectedIdentifiers removeObject:model.description];
        }
    }

    // HERE WE WORK FOR FACEBOOK
    if (selectedTab == 1) {
        
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

    
    // HERE WE WORK FOR TWITTER
    if (selectedTab == 2) {
        
        ContactsModel *model = [self getArrayOfSelectedTab][(indexPath.row)];
        
        NSString *sharingText = [NSString stringWithFormat:NSLocalizedString(@"Take a break from technology. Untech & Reconnect with life: %@", nil),untechableConfigurator.appURL];
        
        //CHECK FOR ALREADY SELECTED
        if (model.status == 0) {
            [model setInvitedStatus:1];
            
            [selectedIdentifiers addObject:model.description];
            
            //Calling ShareKit for Sharing
            iosSharer = [[ SHKiOSTwitter alloc] init];
            NSString *tweet = [NSString stringWithFormat:@"%@ @%@ #gountech",sharingText,model.description];
            SHKItem *item;
            
            item = [SHKItem text:tweet];
            [selectedIdentifiers addObject:model.description];
            
            if ( availableAccounts.count > 0 ) {
                iosSharer = [SHKiOSTwitter shareItem:item];
            } else {
                iosSharer = [SHKTwitter shareItem:item];
            }
            
            iosSharer.shareDelegate = self;
        
        }else if (model.status == 1) {
            
            [model setInvitedStatus:0];

            //REMOVE FROM SENDING LIST
            [selectedIdentifiers removeObject:model.description];
            
        }
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
        
        if(selectedTab == CONTACTS_TAB)
            contactsArray = contactBackupArray;
        else if (selectedTab == FACEBOOK_TAB)
            facebookArray = facebookBackupArray;
        else if(selectedTab == TWITTER_TAB)
            twitterArray = twitterBackupArray;
        else if (selectedTab == EMAIL_TAB)
            contactsArray = emailBackupArray;
        
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
    
    if(selectedTab == CONTACTS_TAB)
        contactsArray = filteredArray;
    if(selectedTab == EMAIL_TAB)
        emailsArray = filteredArray;
    else if (selectedTab == FACEBOOK_TAB)
        facebookArray = filteredArray;
    else if(selectedTab == TWITTER_TAB)
        twitterArray = filteredArray;
    
    [[self uiTableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    return YES;
}



#pragma mark - All Shared Response

// These are used if you do not provide your own custom UI and delegate
- (void)sharerStartedSending:(SHKSharer *)sharer
{
    
	if (!sharer.quiet)
		[[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(NSLocalizedString(@"Saving to %@", nil), [[sharer class] sharerTitle]) forSharer:sharer];
}

- (void)sharerFinishedSending:(SHKSharer *)sharer
{
    
    // Here we Get Friend List which sended from FlyerlyFacbookFriends
    if ( [sharer isKindOfClass:[FlyerlyTwitterFriends class]] == YES ) {
        
        FlyerlyTwitterFriends *twitter = (FlyerlyTwitterFriends*) sharer;
        
        // HERE WE MAKE ARRAY FOR SHOW DATA IN TABLEVIEW
        [self makeTwitterArray:twitter.friendsList ];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.uiTableView reloadData];
        });
        
        return;
    }
    
    
    [self showAlert: NSLocalizedString(@"Invitation Sent!", nil) message: NSLocalizedString(@"You have successfully invited your friends to join untech.", nil)];
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
    
    if ( [sharer isKindOfClass:[SHKiOSTwitter class]] == YES ||
        [sharer isKindOfClass:[SHKiOSTwitter class]] == YES ) {
        [selectedIdentifiers   removeAllObjects];
    }

    [self.uiTableView reloadData ];
    if (!sharer.quiet)
        [[SHKActivityIndicator currentIndicator] displayCompleted:SHKLocalizedString(@"Cancelled!") forSharer:sharer];
    
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

#pragma mark - UI Alert View Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ( buttonIndex != 0 ) {
        
        //reload the table data(i.e followers list)
        self.twitterBackupArray = [[NSMutableArray alloc] init];
        [self.uiTableView reloadData];
        
        selectedAccount = availableAccounts[buttonIndex-1];
        [self afterTwitterSelected:selectedAccount];
        
        NSLog( @"currently selected user for twitter is %@ : ", selectedAccount );
    
    } else {
        //Do nothing then, because cancel is pressed.
    }
}

#pragma mark Flurry Methods

-(void) friendsInvited {
}

@end