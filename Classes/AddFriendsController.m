//
//  AddFriendsController.m
//  Flyr
//
//  Created by Rizwan Ahmad on 4/15/13.
//
//

#import "AddFriendsController.h"
#import "Common.h"
#import "AddFriendItem.h"
#import <QuartzCore/QuartzCore.h>
#import "FlyrAppDelegate.h"
#import "FBRequestConnection.h"
#import "LoadingView.h"

@implementation AddFriendsController
@synthesize uiTableView, contactsArray, deviceContactItems, contactsLabel, facebookLabel, twitterLabel, doneLabel, selectAllLabel, unSelectAllLabel, inviteLabel, contactsButton, facebookButton, twitterButton, loadingView;

const int TWITTER_TAB = 2;
const int FACEBOOK_TAB = 1;
const int CONTACTS_TAB = 0;
BOOL firstTableLoad = YES;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // By default first tab is selected 'Contacts'
    selectedTab = -1;
	loadingViewFlag = NO;
    loadingView = nil;
	loadingView = [[LoadingView alloc]init];
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 31, 30)];
    [menuButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu_button"] forState:UIControlStateNormal];
	[menuButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    [self.navigationItem setRightBarButtonItem:rightBarButton];

    // set borders on the table
    [[self.uiTableView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.uiTableView layer] setBorderWidth:1];
    
    // Set fonts type and sizes
    [self.contactsLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:13]];
    [self.contactsLabel setText:NSLocalizedString(@"contacts", nil)];

    [self.facebookLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:13]];
    [self.facebookLabel setText:NSLocalizedString(@"facebook", nil)];

    [self.twitterLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:13]];
    [self.twitterLabel setText:NSLocalizedString(@"twitter", nil)];

    [self.doneLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:13]];
    [self.doneLabel setText:NSLocalizedString(@"done", nil)];

    [self.selectAllLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:13]];
    [self.selectAllLabel setText:NSLocalizedString(@"select_all", nil)];

    [self.unSelectAllLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:13]];
    [self.unSelectAllLabel setText:NSLocalizedString(@"unselect_all", nil)];

    [self.inviteLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:13]];
    [self.inviteLabel setText:NSLocalizedString(@"invite", nil)];
    
}

-(void)goBack{

	[self.navigationController popToRootViewControllerAnimated:YES];
}

/*
 * This method is used to load device contact details
 */
- (IBAction)loadLocalContacts:(UIButton *)sender{

    if(selectedTab == CONTACTS_TAB){
        return;
    }

    loadingView =[LoadingView loadingViewInView:self.view];
    loadingViewFlag = YES;

    selectedTab = CONTACTS_TAB;
    [self setUnselectTab:sender];

    // init contact array
    contactsArray = [[NSMutableArray alloc] init];
    ABAddressBookRef m_addressbook = ABAddressBookCreate();
    
    // ABAddressBookCreateWithOptions is iOS 6 and up.
    if (&ABAddressBookCreateWithOptions) {
        NSError *error = nil;
        m_addressbook = ABAddressBookCreateWithOptions(NULL, (CFErrorRef *)&error);
#if DEBUG
        if (error) { NSLog(@"%@", error); }
#endif
    }
    
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
                                                                                    withObject:m_addressbook];
                                                         } else {
                                                             CFRelease(m_addressbook);
                                                             // Ignore the error
                                                         }
                                                     });
        } else {
            // constructInThread: will CFRelease ab.
            [NSThread detachNewThreadSelector:@selector(constructInThread:)
                                     toTarget:self
                                   withObject:m_addressbook];
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
        NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);
        
        //For username and surname
        ABMultiValueRef phones =(NSString*)ABRecordCopyValue(ref, kABPersonPhoneProperty);
        CFStringRef firstName, lastName;
        firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        [dOfPerson setObject:[NSString stringWithFormat:@"%@ %@", firstName, lastName] forKey:@"name"];
        
        //For Email ids
        ABMutableMultiValueRef eMail  = ABRecordCopyValue(ref, kABPersonEmailProperty);
        if(ABMultiValueGetCount(eMail) > 0) {
            [dOfPerson setObject:(NSString *)ABMultiValueCopyValueAtIndex(eMail, 0) forKey:@"email"];            
        }
        
        // For contact picture
        UIImage *contactPicture;
        if (ref != nil && ABPersonHasImageData(ref)) {
            if ( &ABPersonCopyImageDataWithFormat != nil ) {
                // iOS >= 4.1
                contactPicture = [UIImage imageWithData:(NSData *)ABPersonCopyImageDataWithFormat(ref, kABPersonImageFormatThumbnail)];
                [dOfPerson setObject:contactPicture forKey:@"image"];
            } else {
                // iOS < 4.1
                contactPicture = [UIImage imageWithData:(NSData *)ABPersonCopyImageData(ref)];
                [dOfPerson setObject:contactPicture forKey:@"image"];
            }
        }        
        
        //For Phone number
        NSString* mobileLabel;
        for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) {
            mobileLabel = (NSString*)ABMultiValueCopyLabelAtIndex(phones, i);
            if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
            {
                [dOfPerson setObject:(NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"Phone"];
                [dOfPerson setObject:(NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"identifier"];
            }
            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
            {
                [dOfPerson setObject:(NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"Phone"];
                break ;
            }
            
            [contactsArray addObject:dOfPerson];
        }
        
        //CFRelease(ref);
        //CFRelease(firstName);
        //CFRelease(lastName);
    }
    
    // Reload table data after all the contacts get loaded
    [self.uiTableView reloadData];
}

/**
 * Called when facebook  button is selected on screen
 */
- (IBAction)loadFacebookContacts:(UIButton *)sender{

    //if(selectedTab == FACEBOOK_TAB){
    ////    return;
    //}

    selectedTab = FACEBOOK_TAB;
    
    //loadingView =[LoadingView loadingViewInView:self.view];
    //loadingViewFlag = YES;

    [self setUnselectTab:sender];
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];

    if(!appDelegate.facebook) {
        
        //get facebook app id
        NSString *path = [[NSBundle mainBundle] pathForResource: @"Flyr-Info" ofType: @"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
        appDelegate.facebook = [[Facebook alloc] initWithAppId:[dict objectForKey: @"FacebookAppID"] andDelegate:self];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        appDelegate.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        appDelegate.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    if([appDelegate.facebook isSessionValid]) {
        
        [appDelegate.facebook requestWithGraphPath:@"me/friends?fields=name,picture" andDelegate:self];
        
    } else {
        
        [appDelegate.facebook authorize:[NSArray arrayWithObjects: @"read_stream",
                                      @"publish_stream", nil]];
        
    }
}

-(void)request:(FBRequest *)request didLoad:(id)result{
    
    NSArray* users = result;   

    self.contactsArray = [[NSMutableArray alloc] initWithCapacity:[users count]];
    
    for (NSDictionary *friendData in [result objectForKey:@"data"])
    {
        // Here we will get the facebook contacts
        NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];        
        [dOfPerson setObject:[friendData objectForKey:@"name"] forKey:@"name"];
        [dOfPerson setObject:[friendData objectForKey:@"id"] forKey:@"identifier"];
        [self.contactsArray addObject:dOfPerson];
    }
    
    [self.uiTableView reloadData];    
}

/*
 *
 */
- (IBAction)loadTwitterContacts:(UIButton *)sender{
    
    if(selectedTab == TWITTER_TAB){
        return;
    }
    
    loadingView =[LoadingView loadingViewInView:self.view];
    loadingViewFlag = YES;

    selectedTab = TWITTER_TAB;
    [self setUnselectTab:sender];
    
    if([TWTweetComposeViewController canSendTweet]){

        ACAccountStore *account = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        // Request access from the user to access their Twitter account
        [account requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
            // Did user allow us access?
            if (granted == YES) {
                
                //grantedBool = YES;
                
                // Populate array with all available Twitter accounts
                NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
                
                // Sanity check
                if ([arrayOfAccounts count] > 0) {
                    
                    // Keep it simple, use the first account available
                    ACAccount *acct = [arrayOfAccounts objectAtIndex:0];
                    
                    // Build a twitter request
                    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                    [params setObject:@"-1" forKey:@"cursor"];
                    [params setObject:[acct identifier] forKey:@"user_id"];
                    //NSLog(@"Account: %@", [acct username]);
                    //NSLog(@"Account Id: %@", [acct identifier]);
                    
                    TWRequest *getRequest = [[TWRequest alloc] initWithURL:
                                             [NSURL URLWithString:@"https://api.twitter.com/1.1/followers/list.json"]
                                                                parameters:params requestMethod:TWRequestMethodGET];
                    // Post the request
                    [getRequest setAccount:acct];
                    
                    // Block handler to manage the response
                    [getRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                        
                        NSError *jsonError = nil;
                        
                        if(responseData){
                            
                            NSDictionary *followers =  [NSJSONSerialization JSONObjectWithData:responseData
                                                                                       options:NSJSONReadingMutableLeaves
                                                                                         error:&jsonError];
                            NSDictionary *users = [followers objectForKey:@"users"];
                            
                            self.contactsArray = [[NSMutableArray alloc] initWithCapacity:[users count]];
                            
                            for (id user in users) {
                                NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];
                                [dOfPerson setObject:[user objectForKey:@"name"] forKey:@"name"];
                                [dOfPerson setObject:[user objectForKey:@"screen_name"] forKey:@"identifier"];
                                [self.contactsArray addObject:dOfPerson];
                            }
                        }
                        
                        NSLog(@"Twitter response, HTTP response: %i", [urlResponse statusCode]);
                        [self.uiTableView reloadData];
                    }];
                }
            }
        }];
    
    } else {
        
        [self showAlert:@"No Twitter connection" message:@"You must be connected to Twitter to get contact list."];
    }
    
}

/**
 *
 */
- (void)sendTwitterMessage:(NSString *)message screenName:(NSString *)screenName{
    
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    // Request access from the user to access their Twitter account
    [account requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        // Did user allow us access?
        if (granted == YES) {
            
            // Populate array with all available Twitter accounts
            NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
            
            // Sanity check
            if ([arrayOfAccounts count] > 0) {
                
                // Keep it simple, use the first account available
                ACAccount *acct = [arrayOfAccounts objectAtIndex:0];
                
                NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                [params setObject:[NSString stringWithFormat:@"@%@ %@", screenName, message] forKey:@"status"];

                 // Build a twitter request
                 TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"] parameters:params requestMethod:TWRequestMethodPOST];
                
                 // Build a twitter request
                 //TWRequest *postRequest = [[TWRequest alloc] initWithURL: [NSURL URLWithString:@"http://api.twitter.com/1/direct_messages/new.json"] parameters:params requestMethod:TWRequestMethodPOST];
                //[params setObject:screenName forKey:@"screen_name"];

                // Post the request
                [postRequest setAccount:acct];                                         
                                         
                // Block handler to manage the response
                [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {                    
                    NSLog(@"Twitter response, HTTP response: %i", [urlResponse statusCode]);
                    
                    [self.uiTableView reloadData];
                }];
            }
        }
    }];
}

/**
 * invite contacts
 */
-(IBAction)invite{
    
    NSMutableArray *identifiers = [[NSMutableArray alloc] init];
    
    for(AddFriendItem *cell in deviceContactItems){
        
        if([cell.leftCheckBox isSelected]){
            [identifiers addObject:cell.identifier1];
        }
        
        if([cell.rightCheckBox isSelected]){
            [identifiers addObject:cell.identifier2];
        }
    }
    
    if([identifiers count] > 0){
        // Send invitations
        if(selectedTab == 0){
            
            // send tweets to contacts
            [self sendSMS:@"Test SMS" recipients:identifiers];
            
        }else if(selectedTab == 2){
            // Send tweets to twitter contacts
            for(NSString *follower in identifiers){
                [self sendTwitterMessage:@"I am using the flyerly app to create and share flyers on the go! - https://itunes.apple.com/app/socialflyr/id344130515?ls=1&mt=8" screenName:follower];
            }
            
            [self showAlert:@"Invited !" message:@"Your selected contacts have been invited to flyerly!"];

        }else if(selectedTab == 1){
            
            [self tagFacebookUsersWithFeed:identifiers];
        }
        
    } else {
        [self showAlert:@"Nothing Selected !" message:@"Please select any contact to invite"];
    }
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
        case MessageComposeResultSent:
            [self showAlert:@"Invited !" message:@"Your selected contacts have been invited to flyerly!"];
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)tagFacebookUsersWithFeed:(NSArray *)identifiers {
    
    // Post a status update to the user's feed via the Graph API, and display an alert view
    // with the results or an error.

    [self performPublishAction:^{
        
        [FBRequestConnection startForPostStatusUpdate:@"I am using the flyerly app to create and share flyers on the go! - https://itunes.apple.com/app/socialflyr/id344130515?ls=1&mt=8" place:@"144479625584966" tags:identifiers completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            
            NSLog(@"New Result: %@", result);
        
            [self showAlert:@"Invited !" message:@"Your selected contacts have been invited to flyerly!"];
        }];
    }];
}

-(void)showAlert:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action {    
    
    if ([[FBSession activeSession]isOpen]) {
        /*
         * if the current session has no publish permission we need to reauthorize
         */
        if ([[[FBSession activeSession]permissions]indexOfObject:@"publish_actions"] == NSNotFound) {
            
            [[FBSession activeSession] reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceOnlyMe completionHandler:^(FBSession *session, NSError *error) {
                
                [self publish_action:action];
            }];
            
        }else{

            [self publish_action:action];

        }
    }else{
        /*
         * open a new session with publish permission
         */
        [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceOnlyMe allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            
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

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // since we have two contacts in single row we have to divide it by 2
    int count = ([contactsArray count]) / 2;
    
    // Add one if contact counts are odd
    if(([self.contactsArray count] % 2) == 1){
        count++;
    }
    
    [self.deviceContactItems release];
    self.deviceContactItems = nil;
    self.deviceContactItems = [[NSMutableArray alloc] init];

    // return count
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    
    if(loadingViewFlag){
        [loadingView removeView];
        loadingViewFlag = NO;
    }

    // Get index like 0, 2, 4, 6 etc
    int index = (indexPath.row * 2);
    NSLog(@"index: %d", index);
    
    // init cell array if null
    if(!self.deviceContactItems){
        self.deviceContactItems = [[NSMutableArray alloc] init];
    }
    
    // Get cell
    static NSString *cellId = @"AddFriendItem";
   // AddFriendItem *cell = (AddFriendItem *) [uiTableView dequeueReusableCellWithIdentifier:cellId];
    //AddFriendItem *cell = [(AddFriendItem *)[self.uiTableView dequeueReusableCellWithIdentifier:cellId] autorelease];
    
    AddFriendItem *cell = nil;
    
    if([self.deviceContactItems count] > indexPath.row){
        NSLog(@"Reusing Row");
        cell = [self.deviceContactItems objectAtIndex:indexPath.row];
    }
    
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil];
        cell=[nib objectAtIndex:0];
        [cell.leftCheckBox setSelected:YES];
        [cell.rightCheckBox setSelected:YES];
        cell.leftSelected = YES;
        cell.rightSelected = YES;
        // Add cell in array for tracking
        [self.deviceContactItems addObject:cell];
        
    } else {
        NSLog(@"Reusing Row");
        /*
        if(cell.leftSelected){
            [cell.leftCheckBox setSelected:YES];
        }else{
            [cell.leftCheckBox setSelected:NO];
        }

        if(cell.rightSelected){
            [cell.rightCheckBox setSelected:YES];
        }else{
            [cell.rightCheckBox setSelected:NO];
        }
         */
    }
    
    // Get left contact data
    NSMutableDictionary *dict1 = [self.contactsArray objectAtIndex:index];
    NSString *name1 = [dict1 objectForKey:@"name"];
    UIImage *image1 = [dict1 objectForKey:@"image"];

    // Get right contact data
    NSMutableDictionary *dict2;
    NSString *name2;
    UIImage *image2;

    // Check index
    if([self.contactsArray count] > (index+ 1)){
        dict2 = [self.contactsArray objectAtIndex:(index + 1)];
        name2 = [dict2 objectForKey:@"name"];
        image2 = [dict2 objectForKey:@"image"];
        cell.identifier2 = [dict2 objectForKey:@"identifier"];
    } else {
        name2 = @"";
        image2 = nil;
    }

    // Set data on screen
    [cell setValues:name1 title2:name2];
    [cell setImages:image1 image2:image2];
    cell.identifier1 = [dict1 objectForKey:@"identifier"];
    
    // Set consecutive colors on rows
    if (indexPath.row % 2) {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    } else {
        cell.contentView.backgroundColor = [[UIColor alloc]initWithRed:244.0/255.0 green:242.0/255.0 blue:243.0/255.0 alpha:1];
    }
    
    // return cell
    return cell;
}

/*-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"index path: %d", [indexPath row]);
    NSLog(@"indexPathsForVisibleRows: %d", ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row);

    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){

        if(firstTableLoad){
            [self selectAllCheckBoxes:nil];
            firstTableLoad = NO;
        }
        
    }
}*/

/*
 * Method use to select all checkboxes
 */
- (IBAction)selectAllCheckBoxes:(UIButton *)sender{
    
    for(AddFriendItem *cell in self.deviceContactItems){
        [cell.leftCheckBox setSelected:YES];
        cell.leftSelected = YES;
        
        if(![cell.rightCheckBox isHidden]){
            [cell.rightCheckBox setSelected:YES];
            cell.rightSelected = YES;
        }
    }
}

/*
 * Method use to unselect al checkboxes
 */
- (IBAction)unSelectAllCheckBoxes:(UIButton *)sender{
    
    for(AddFriendItem *cell in self.deviceContactItems){
        [cell.leftCheckBox setSelected:NO];
        cell.leftSelected = NO;
        
        if(![cell.rightCheckBox isHidden]){
            [cell.rightCheckBox setSelected:NO];
            cell.rightSelected = NO;
        }
    }
}

-(void)setUnselectTab:(UIButton *)selectButton{

    [self.contactsButton setSelected:NO];
    [self.facebookButton setSelected:NO];
    [self.twitterButton setSelected:NO];
    
    [selectButton setSelected:YES];
}

- (void)fbDidLogin {
	NSLog(@"logged in");

    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];

    //save to session
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.facebook.accessToken forKey:@"FBAccessToken"];
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.facebook.expirationDate forKey:@"FBSExpirationDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self loadFacebookContacts:self.facebookButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];	
}

-(void)viewWillAppear:(BOOL)animated{

    //loadingViewFlag = NO;
    
    // Load device contacts
    [self loadLocalContacts:self.contactsButton];
    loadingViewFlag = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    
	if(loadingViewFlag)
	{
		[loadingView removeFromSuperview];
		loadingViewFlag=NO;
	}
}

- (void)dealloc {
    
    contactsLabel = nil;
    facebookLabel = nil;
    twitterLabel = nil;
    doneLabel = nil;
    selectAllLabel = nil;
    unSelectAllLabel = nil;
    inviteLabel = nil;
    contactsButton = nil;
    facebookButton = nil;
    twitterButton = nil;
    
    uiTableView = nil;
    contactsArray = nil;
    deviceContactItems = nil;
    
    [super dealloc];
}

@end
