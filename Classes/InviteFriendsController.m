//
//  AddFriendsController.m
//  Flyr
//
//  Created by Riksof on 4/15/13.
//
//

#import "InviteFriendsController.h"
#import "Common.h"
#import <QuartzCore/QuartzCore.h>
#import "FlyrAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "LoadingView.h"
#import "CreateFlyerController.h"
#import "HelpController.h"
#import "Flurry.h"

@implementation InviteFriendsController
@synthesize uiTableView, contactsArray, deviceContactItems, contactsLabel, facebookLabel, twitterLabel, doneLabel, selectAllLabel, unSelectAllLabel, inviteLabel, contactsButton, facebookButton, twitterButton, loadingView, searchTextField, facebookArray, twitterArray,fbinvited,twitterInvited,iPhoneinvited;
@synthesize contactBackupArray, facebookBackupArray, twitterBackupArray;

const int TWITTER_TAB = 2;
const int FACEBOOK_TAB = 1;
const int CONTACTS_TAB = 0;
BOOL firstTableLoad = YES;
BOOL unSelectAll;
BOOL selectAll;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    contactsCount =0;
    self.deviceContactItems = [[NSMutableArray alloc] init];
    globle = [FlyerlySingleton RetrieveSingleton];
    self.navigationItem.hidesBackButton = YES;
    [self.view setBackgroundColor:[globle colorWithHexString:@"f5f1de"]];
    
    // Register notification for facebook login
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FacebookDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fbDidLogin) name:FacebookDidLoginNotification object:nil];
    
    // By default first tab is selected 'Contacts'
    selectedTab = -1;
	loadingViewFlag = NO;
    loadingView = nil;
	loadingView = [[LoadingView alloc]init];

    
    
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
    
    [self.uiTableView  setBackgroundColor:[globle colorWithHexString:@"f5f1de"]];
    [searchTextField setReturnKeyType:UIReturnKeyDone];
    
    
    //HERE WE GET ALREADY INVITED FRIENDS
    PFUser *user = [PFUser currentUser];
    
    self.iPhoneinvited = [[NSMutableArray alloc] init];
    self.fbinvited = [[NSMutableArray alloc] init];
    self.twitterInvited = [[NSMutableArray alloc] init];

    if (user[@"iphoneinvited"])
        self.iPhoneinvited  = user[@"iphoneinvited"];

    if (user[@"fbinvited"])
        self.fbinvited  = user[@"fbinvited"];

    if (user[@"tweetinvited"])
        twitterInvited = user[@"tweetinvited"];
   
    
    // Load device contacts
    [self loadLocalContacts:self.contactsButton];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    loadingViewFlag = YES;
    
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    
    if(loadingViewFlag){
        for (UIView *subview in self.view.subviews) {
            if([subview isKindOfClass:[LoadingView class]]){
                [subview removeFromSuperview];
                loadingViewFlag = NO;
            }
        }
    }
}


-(void)loadHelpController{
    HelpController *helpController = [[HelpController alloc]initWithNibName:@"HelpController" bundle:nil];
    [self.navigationController pushViewController:helpController animated:NO];
}

-(IBAction)goBack{
    [self.navigationController popViewControllerAnimated:YES];
    
}

/*
 * This method is used to load device contact details
 */
- (IBAction)loadLocalContacts:(UIButton *)sender{
    
    
    // HERE WE HIGHLIGHT BUTTON SELECT AND
    // UNSELECTED BUTTON
    [contactsButton setSelected:YES];
    [twitterButton setSelected:NO];
    [facebookButton setSelected:NO];

    
    invited = NO;
    [deviceContactItems removeAllObjects];
    contactsCount = 0;
    if(selectedTab == CONTACTS_TAB){
        
        // INVITE BAR BUTTON
        UIButton *inviteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
        [inviteButton addTarget:self action:@selector(invite) forControlEvents:UIControlEventTouchUpInside];
        [inviteButton setBackgroundImage:[UIImage imageNamed:@"invite_friend"] forState:UIControlStateNormal];
        inviteButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:inviteButton];
        [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];

        return;
    }
    [self showLoadingIndicator];
    
    selectAll = YES;
    self.deviceContactItems = nil;
    self.deviceContactItems = [[NSMutableArray alloc] init];
    selectedIdentifierDictionary = nil;
    
    selectedTab = CONTACTS_TAB;
    
    
    // init contact array
    if(contactBackupArray){
        
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
    
    // Reload table data after all the contacts get loaded
    contactBackupArray = nil;
    contactBackupArray = contactsArray;
    [[self uiTableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [self hideLoadingIndicator];
    
}

/**
 * Called when facebook  button is selected on screen
 */
- (IBAction)loadFacebookContacts:(UIButton *)sender{
    
    
    // HERE WE HIGHLIGHT BUTTON ON TOUCH
    // AND OTHERS SET UNSELECTED
    [contactsButton setSelected:NO];
    [twitterButton setSelected:NO];
    [facebookButton setSelected:YES];
    
    
    [self showLoadingIndicator];
    
    contactsCount = 0;
    invited = NO;
    
    selectAll = YES;
    self.deviceContactItems = nil;
    self.deviceContactItems = [[NSMutableArray alloc] init];
    selectedIdentifierDictionary = nil;
    selectedTab = FACEBOOK_TAB;
    
    
    if (facebookArray == nil) {
        self.facebookArray = [[NSMutableArray alloc] init];
        
        // Current Item For Sharing
        SHKItem *item = [[SHKItem alloc] init];
        item.shareType = SHKShareTypeUserInfo;
    
        iosSharer = [[ SHKSharer alloc] init];
    
        // Create controller and set share options
        iosSharer = [FlyerlyFacebookFriends shareItem:item];
        iosSharer.shareDelegate = self;
    }else {

        // INVITE BAR BUTTON
        UIButton *inviteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
        [inviteButton addTarget:self action:@selector(invite) forControlEvents:UIControlEventTouchUpInside];
        [inviteButton setBackgroundImage:[UIImage imageNamed:@"invite_friend"] forState:UIControlStateNormal];
        inviteButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:inviteButton];
        [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];

        
        //Update Table View
        [self.uiTableView reloadData];
    
    }
    
}

-(void)showAlert:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


int totalCount = 0;

-(void)makeFacebookArray :(NSDictionary *)result{
    
    int count = 0;
    
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
        
        [self.facebookArray addObject:model];
        
        count++;
        totalCount++;
    }
    
    facebookBackupArray = nil;
    facebookBackupArray = facebookArray;
    
    // Filter contacts on new tab selection
    [self onSearchClick:nil];
    
    [[self uiTableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    {
        totalCount = 0;
        
        [self hideLoadingIndicator];
        
    }
}




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
     
     //twitterBackupArray = nil;
     //twitterBackupArray = twitterArray;
    
        twitterArray = nil;
        twitterArray = twitterBackupArray;
     
     [uiTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
     [self hideLoadingIndicator];


}


-(void)request:(FBRequest *)request didLoad:(id)result{
    
    int count = 0;
    
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

        [self.facebookArray addObject:model];
        
        count++;
        totalCount++;
    }
    
    facebookBackupArray = nil;
    facebookBackupArray = facebookArray;
    
    // Filter contacts on new tab selection
    [self onSearchClick:nil];
    
    [[self uiTableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            {
         totalCount = 0;
         
        [self hideLoadingIndicator];

     }
}

/*
 *
 */
- (IBAction)loadTwitterContacts:(UIButton *)sender{
    
    // HERE WE HIGHLIGHT BUTTON SELECT AND
    // UNSELECTED BUTTON
    [contactsButton setSelected:NO];
    [twitterButton setSelected:YES];
    [facebookButton setSelected:NO];
    
    self.deviceContactItems = nil;
    self.deviceContactItems = [[NSMutableArray alloc] init];
    
    selectedTab = TWITTER_TAB;

    if (twitterBackupArray == nil) {
        self.twitterBackupArray = [[NSMutableArray alloc] init];
    
        // Current Item For Sharing
        SHKItem *item = [[SHKItem alloc] init];
        //item.shareType = SHKShareTypeUserInfo;
    
    
        iosSharer = [[ SHKSharer alloc] init];
    
        // Create controller and set share options
        iosSharer = [FlyerlyTwitterFriends shareItem:item];
        iosSharer.shareDelegate = self;
        
    }else {
    
        [self.uiTableView reloadData];
    }
}

-(void)cursoredTwitterContacts:(NSString *)cursor account:(ACAccount *)acct{
    
    account = acct;
    
    // Build a twitter request
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"cursor"] = cursor;
    
    //[params setObject:@"20" forKey:@"count"];
    params[@"user_id"] = [acct identifier];
    
    TWRequest *getRequest = [[TWRequest alloc] initWithURL:
                             [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1.1/followers/list.json"]]
                                                parameters:params requestMethod:TWRequestMethodGET];
    // Post the request
    [getRequest setAccount:acct];
    
    // Block handler to manage the response
    [getRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        NSError *jsonError = nil;
        NSDecimalNumber *nextCursor;
        
        if(responseData){
            
            NSDictionary *followers =  [NSJSONSerialization JSONObjectWithData:responseData
                                                                       options:NSJSONReadingMutableLeaves
                                                                         error:&jsonError];
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
                
                [self.twitterArray addObject:model];
            }
            
            twitterBackupArray = nil;
            twitterBackupArray = twitterArray;
            
            [uiTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            nextCursor = followers[@"next_cursor"];
            [self hideLoadingIndicator];

        }
        
        if([nextCursor compare:[NSDecimalNumber zero]] == NSOrderedSame){
            
            [[self uiTableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
          
        }else{
            
            [self cursoredTwitterContacts:[NSString stringWithFormat:@"%@", nextCursor] account:acct];
        }
        
        NSLog(@"Twitter response, HTTP response: %i", [urlResponse statusCode]);
    }];
    
    arrayOfAccounts = nil;
}

- (void)makeTwitterPost:(ACAccount *)acct {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"status"] = [NSString stringWithFormat:@"@%@ %@", sName, sMessage];
    
    // Build a twitter request
    TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"] parameters:params requestMethod:TWRequestMethodPOST];
    
    // Post the request
    [postRequest setAccount:acct];
    
    // Block handler to manage the response
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSLog(@"Twitter response, HTTP response: %i", [urlResponse statusCode]);
        
        twitterBackupArray = nil;
        twitterBackupArray = twitterArray;
        [[self uiTableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }];
    
    // Release stuff.
    sName = nil;
    sMessage = nil;
    arrayOfAccounts = nil;
}

/**
 *
 */
- (void)sendTwitterMessage:(NSString *)message screenName:(NSString *)screenName{
    
    sName = screenName;
    sMessage = message;
    
    [self makeTwitterPost:account];
}

/**
 * clickedButtonAtIndex (UIActionSheet)
 *
 * Handle the button clicks from mode of getting out selection.
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //if not cancel button presses
    if(buttonIndex != arrayOfAccounts.count) {
        
        //save to NSUserDefault
          account = arrayOfAccounts[buttonIndex];
        
        //Convert twitter username to email
        if ( actionSheet.tag == 1 ) {
            [self makeTwitterPost:account];
        } else {
            [self cursoredTwitterContacts:[NSString stringWithFormat:@"%d", -1] account:account];
        }
    }
}


- (BOOL)ckeckExistContact:(NSString *)identifier{
    for (int i = 0; i < deviceContactItems.count ; i++) {
        if ([identifier isEqualToString:deviceContactItems[i]]) {
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
    }else{
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
    
    NSMutableArray *identifiers = [[NSMutableArray alloc] init];
    identifiers = deviceContactItems;
    NSLog(@"%@",identifiers);
    
    if([identifiers count] > 0){
        contactsCount =0;
        
        // Send invitations
        if(selectedTab == 0){
            globle.accounts = [[NSMutableArray alloc] initWithArray:deviceContactItems];
            
            SHKItem *item = [SHKItem text:@"I'm using the flyerly app to create and share flyers on the go! Flyer.ly/Invite"];
            item.textMessageToRecipients = deviceContactItems;

            iosSharer = [[ SHKSharer alloc] init];
            iosSharer = [SHKTextMessage shareItem:item];
            iosSharer.shareDelegate = self;
            
            
        }else if(selectedTab == 1){
            
            // Current Item For Sharing
            SHKItem *item = [SHKItem image:[UIImage imageNamed:@""] title:[NSString stringWithFormat:@"I'm using the flyerly app to create and share flyers on the go! Flyer.ly/Facebook  #flyerly"]];
            item.tags = identifiers;
            
            //Calling ShareKit for Sharing
            iosSharer = [[ SHKSharer alloc] init];
            iosSharer = [FlyerlyFacebookInvite shareItem:item];
            iosSharer.shareDelegate = self;
            
            
        }
        
    } else {
        [self showAlert:@"Please select any contact to invite !" message:@""];
    }
    
    [Flurry logEvent:@"Friends Invited"];
}

- (void)messageComposeViewController:
(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:
            NSLog(@"Failed");
            break;
        case MessageComposeResultSent: {
            
            [self showAlert:@"Invitation Sent!" message:@"You have successfully invited your friends to join flyerly."];
            NSLog(@"%@",iPhoneinvited);
            NSLog(@"%@",globle.accounts);
            [iPhoneinvited  addObjectsFromArray:globle.accounts];
            NSLog(@"%@",iPhoneinvited);
            PFUser *user = [PFUser currentUser];
            user[@"iphoneinvited"] = iPhoneinvited;
            [user saveInBackground];
            [deviceContactItems   removeAllObjects];
            [self.uiTableView reloadData];
            break;
        }
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)tagFacebookUsersWithFeed:(NSArray *)identifiers {
    
    // Post a status update to the user's feed via the Graph API, and display an alert view
    // with the results or an error.
    
    [self performPublishAction:^{
        
        [FBRequestConnection startForPostStatusUpdate:@"I'm using the flyerly app to create and share flyers on the go! Flyer.ly/Facebook" place:@"144479625584966" tags:identifiers completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            
            NSLog(@"New Result: %@", result);
            NSLog(@"Error: %@", error);
            
            //[self showAlert:@"Invited !" message:@"You have successfully invited your friends to join flyerly."];
        }];
    }];
}


// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action {
    
    if ([[FBSession activeSession]isOpen]) {
        /*
         * if the current session has no publish permission we need to reauthorize
         */
        if ([[[FBSession activeSession]permissions]indexOfObject:@"publish_actions"] == NSNotFound) {
            
            [[FBSession activeSession] reauthorizeWithPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceOnlyMe completionHandler:^(FBSession *session, NSError *error) {
                
                [self publish_action:action];
            }];
            
        }else{
            
            [self publish_action:action];
            
        }
    }else{
        
        //open a new session with publish permission
        [FBSession openActiveSessionWithPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceOnlyMe allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            
            if (!error && status == FBSessionStateOpen) {
                [self publish_action:action];
            }else{
                NSLog(@"error");
            }
        }];
    }
}

-(void)publish_action:(void (^)(void)) action{
    
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                }
                                                //For this example, ignore errors (such as if user cancels).
                                            }];
    } else {
        action();
    }
}

-(void)sendSMS:(NSString *)message recipients:(NSArray*)recipients {
    
    //send SMS
    MFMessageComposeViewController *messageInstance = [[MFMessageComposeViewController alloc] init];
    
    if([MFMessageComposeViewController canSendText]) {
        
        [messageInstance setRecipients:recipients];
        messageInstance.body = message;
        messageInstance.messageComposeDelegate = self;
        [self presentViewController:messageInstance animated:YES completion:nil];
        
    }
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSArray *) getArrayOfSelectedTab{
    if(selectedTab == CONTACTS_TAB)
        return contactsArray;
    else if(selectedTab == FACEBOOK_TAB)
        return facebookArray;
    else
        return twitterArray;
}

-(NSArray *) getBackupArrayOfSelectedTab{
    if(selectedTab == CONTACTS_TAB)
        return contactBackupArray;
    else if(selectedTab == FACEBOOK_TAB)
        return facebookBackupArray;
    else
        return twitterBackupArray;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = ([[self getArrayOfSelectedTab] count]);
    return  count;
}

NSMutableDictionary *selectedIdentifierDictionary;
+(NSMutableDictionary *)getSelectedIdentifiersDictionary{
    
    if(selectedIdentifierDictionary){
        return selectedIdentifierDictionary;
    }else{
        selectedIdentifierDictionary = [[NSMutableDictionary alloc] init];
        return selectedIdentifierDictionary;
    }
}

+(void)disableSelectUnSelectFlags{
    unSelectAll = NO;
    selectAll = NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *cellId = @"InviteCell";
    InviteFriendsCell *cell = (InviteFriendsCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    
    if ( cell == nil ) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InviteFriendsCell" owner:self options:nil];
        cell = (InviteFriendsCell *)[nib objectAtIndex:0];
    }
        
    
    if(!self.deviceContactItems){
        self.deviceContactItems = [[NSMutableArray alloc] init];
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
    [cell setCellObjects:receivedDic :status];
        
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	

    // HERE WE WORK FOR CONTACTS
    if (selectedTab == 0) {
        
        ContactsModel *model = [self getArrayOfSelectedTab][(indexPath.row)];
        
        //CHECK FOR ALREADY SELECTED
        if (model.status == 0) {
            
            [model setInvitedStatus:1];
            [deviceContactItems addObject:model.description];
            
        }else if (model.status == 1) {
            
            [model setInvitedStatus:0];
            
            //REMOVE FROM SENDING LIST
            [deviceContactItems removeObject:model.description];
        }
        
    }

    // HERE WE WORK FOR FACEBOOK
    if (selectedTab == 1) {
        
        ContactsModel *model = [self getArrayOfSelectedTab][(indexPath.row)];
        
        //CHECK FOR ALREADY SELECTED
        if (model.status == 0) {
            [model setInvitedStatus:1];
            [deviceContactItems addObject:model.description];

            
        }else if (model.status == 1) {
            
            [model setInvitedStatus:0];
            
            //REMOVE FROM SENDING LIST
            [deviceContactItems removeObject:model.description];
            
        }
        
    }

    
    // HERE WE WORK FOR TWITTER
    if (selectedTab == 2) {
        
        ContactsModel *model = [self getArrayOfSelectedTab][(indexPath.row)];
        
        //CHECK FOR ALREADY SELECTED
        if (model.status == 0) {
            [model setInvitedStatus:1];
            
            [deviceContactItems addObject:model.description];
            
            //Calling ShareKit for Sharing
            iosSharer = [[ SHKSharer alloc] init];
            NSString *tweet = [NSString stringWithFormat:@"I'm using the @flyerlyapp to create and share flyers on the go! Flyer.ly/Twitter @%@ #flyerly",model.description];
            
            [deviceContactItems addObject:model.description];
            iosSharer = [SHKTwitter shareText:tweet];
            iosSharer.shareDelegate = self;
        
        }else if (model.status == 1) {
            
            [model setInvitedStatus:0];

            //REMOVE FROM SENDING LIST
            [deviceContactItems removeObject:model.description];
            
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
    else if (selectedTab == FACEBOOK_TAB)
        facebookArray = filteredArray;
    else if(selectedTab == TWITTER_TAB)
        twitterArray = filteredArray;
    
    [[self uiTableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    return YES;
}

+ (BOOL)connected {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    
    // Here we Get Friend List which sended from FlyerlyFacbookFriends
    if ( [sharer isKindOfClass:[FlyerlyFacebookFriends class]] == YES ) {
        
        FlyerlyFacebookFriends *facebook = (FlyerlyFacebookFriends*) sharer;
        
        // HERE WE MAKE ARRAY FOR SHOW DATA IN TABLEVIEW
        [self makeFacebookArray:facebook.friendsList ];
        [self.uiTableView reloadData];
        


        return;
    }
    
    // Here we Get Friend List which sended from FlyerlyFacbookFriends
    if ( [sharer isKindOfClass:[FlyerlyTwitterFriends class]] == YES ) {
        
        FlyerlyTwitterFriends *twitter = (FlyerlyTwitterFriends*) sharer;
        
        // HERE WE MAKE ARRAY FOR SHOW DATA IN TABLEVIEW
        [self makeTwitterArray:twitter.friendsList ];
        [self.uiTableView reloadData];
        
        
        
        return;
    }
    
    
    
    PFUser *user = [PFUser currentUser];
    
    // Here we Check Sharer for
    // Update PARSE
    if ( [sharer isKindOfClass:[SHKTwitter class]] == YES ) {
        
        // HERE WE GET AND SET SELECTED FOLLOWER
        [twitterInvited  addObjectsFromArray:deviceContactItems];
        user[@"tweetinvited"] = twitterInvited;
 
    } else if ( [sharer isKindOfClass:[SHKTextMessage class]] == YES ) {
        
        // HERE WE GET AND SET SELECTED CONTACT LIST
        [iPhoneinvited  addObjectsFromArray:deviceContactItems];
        user[@"iphoneinvited"] = iPhoneinvited;
        
    } else  if ( [sharer isKindOfClass:[FlyerlyFacebookInvite class]] == YES ) {
    
        // HERE WE GET AND SET SELECTED Facebook LIST
        [fbinvited  addObjectsFromArray:deviceContactItems];
        user[@"fbinvited"] = fbinvited;
    }

    // HERE WE UPDATE PARSE ACCOUNT FOR REMEMBER INVITED FRIENDS LIST
    [user saveInBackground];
    
    [self showAlert:@"Invitation Sent!" message:@"You have successfully invited your friends to join flyerly."];
    [deviceContactItems   removeAllObjects];
    [self.uiTableView reloadData ];
    
    
    if (!sharer.quiet)
		[[SHKActivityIndicator currentIndicator] displayCompleted:SHKLocalizedString(@"Saved!")];
}

- (void)sharer:(SHKSharer *)sharer failedWithError:(NSError *)error shouldRelogin:(BOOL)shouldRelogin
{
    
    [[SHKActivityIndicator currentIndicator] hide];
	NSLog(@"Sharing Error");
}

- (void)sharerCancelledSending:(SHKSharer *)sharer
{
    
    if ( [sharer isKindOfClass:[SHKTwitter class]] == YES ) {
        [deviceContactItems   removeAllObjects];
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


@end