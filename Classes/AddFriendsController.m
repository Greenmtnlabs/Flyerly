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
#import "PhotoController.h"

@implementation AddFriendsController
@synthesize uiTableView, contactsArray, deviceContactItems, contactsLabel, facebookLabel, twitterLabel, doneLabel, selectAllLabel, unSelectAllLabel, inviteLabel, contactsButton, facebookButton, twitterButton, loadingView, filteredArray, searchTextField, backupArray;

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
    [self.navigationItem setRightBarButtonItems: [self rightBarItems]];

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
    
    [searchTextField setReturnKeyType:UIReturnKeyDone];

}

-(NSArray *)rightBarItems{
    
    // Create right bar help button
    //UILabel *saveFlyrLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 50)];
    //[saveFlyrLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:8.5]];
    //[saveFlyrLabel setTextColor:[MyCustomCell colorWithHexString:@"008ec0"]];
    //[saveFlyrLabel setBackgroundColor:[UIColor clearColor]];
    //[saveFlyrLabel setText:@"Invite Friends"];
    //UIBarButtonItem *barLabel = [[UIBarButtonItem alloc] initWithCustomView:saveFlyrLabel];
    self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Invite Friends"];

    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 31, 30)];
    [menuButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu_button"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    //[self.navigationItem setRightBarButtonItem:rightBarButton];
    
    
    return [NSMutableArray arrayWithObjects:menuBarButton,nil];
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

    loadingView =[LoadingView loadingViewInView:self.view  text:@"Loading..."];
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
    backupArray = nil;
    backupArray = contactsArray;
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
    
    [self setUnselectTab:sender];
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    appDelegate.facebook.sessionDelegate = self;
    
    if([appDelegate.facebook isSessionValid]) {

        loadingView =[LoadingView loadingViewInView:self.view  text:@"Loading..."];
        loadingViewFlag = YES;
        
        //self.contactsArray = [[NSMutableArray alloc] initWithCapacity:[users count]];
        self.contactsArray = [[NSMutableArray alloc] init];

        [appDelegate.facebook requestWithGraphPath:@"me/friends?fields=name,picture.height(35).width(35).type(small)&limit=30&offset=0" andDelegate:self];

    } else {
        
        [appDelegate.facebook authorize:[NSArray arrayWithObjects: @"read_stream",
                                      @"publish_stream", nil]];
        
    }
}

int totalCount = 0;

-(void)request:(FBRequest *)request didLoad:(id)result{
    
    //NSArray* users = result;
    int count = 0;

    for (NSDictionary *friendData in [result objectForKey:@"data"]) {
        
        //NSLog(@"Facebook picture: %@",[friendData objectForKey:@"picture"]);
        NSURL *imageURL = [NSURL URLWithString:[[[friendData objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];

        // Here we will get the facebook contacts
        NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];        
        [dOfPerson setObject:[friendData objectForKey:@"name"] forKey:@"name"];
        [dOfPerson setObject:[friendData objectForKey:@"id"] forKey:@"identifier"];
        if(image){
            [dOfPerson setObject:image forKey:@"image"];
        }
        //[dOfPerson setObject:[[[friendData objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"] forKey:@"image"];
        [self.contactsArray addObject:dOfPerson];
        
        count++;
        totalCount++;
    }
    
    backupArray = nil;
    backupArray = contactsArray;
    [self.uiTableView reloadData];
    
    if(count == 30){
        FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
        [appDelegate.facebook requestWithGraphPath:[NSString stringWithFormat:@"me/friends?fields=name,picture.height(35).width(35).type(small)&limit=30&offset=%d", totalCount] andDelegate:self];

        loadingView =[LoadingView loadingViewInView:self.view text:@"Loading..."];
        //loadingViewFlag = YES;
        
    } else {
        totalCount = 0;
    
        for (UIView *subview in self.view.subviews) {
            if([subview isKindOfClass:[LoadingView class]]){
                [subview removeFromSuperview];
            }
        }
    }
}

/*
 *
 */
- (IBAction)loadTwitterContacts:(UIButton *)sender{
    
    if(selectedTab == TWITTER_TAB){
        return;
    }
    
    loadingView =[LoadingView loadingViewInView:self.view text:@"Loading..."];
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
                    
                    self.contactsArray = [[NSMutableArray alloc] init];

                    [self cursoredTwitterContacts:[NSString stringWithFormat:@"%d", -1] arrayOfAccounts:arrayOfAccounts];
                }
            }
        }];
    
    } else {
        
        [self showAlert:@"No Twitter connection" message:@"You must be connected to Twitter to get contact list."];
        
        if(loadingViewFlag){
            for (UIView *subview in self.view.subviews) {
                if([subview isKindOfClass:[LoadingView class]]){
                    [subview removeFromSuperview];
                    loadingViewFlag = NO;
                }
            }
        }
    }
    
}

-(void)cursoredTwitterContacts:(NSString *)cursor arrayOfAccounts:(NSArray *)arrayOfAccounts{

    // Keep it simple, use the first account available
    ACAccount *acct = [arrayOfAccounts objectAtIndex:0];
    
    // Build a twitter request
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:cursor forKey:@"cursor"];
    [params setObject:[acct identifier] forKey:@"user_id"];
    //NSLog(@"Account: %@", [acct username]);
    //NSLog(@"Account Id: %@", [acct identifier]);
    
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
            NSDictionary *users = [followers objectForKey:@"users"];            
            //NSLog(@"User Count: %d", [users count]);
            //NSLog(@"Users: %@", users);

            for (id user in users) {
                
                //NSLog(@"Image URL: %@", [user objectForKey:@"profile_image_url"]);
                NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];
                [dOfPerson setObject:[user objectForKey:@"name"] forKey:@"name"];
                [dOfPerson setObject:[user objectForKey:@"screen_name"] forKey:@"identifier"];
                
                NSURL *imageURL = [NSURL URLWithString:[user objectForKey:@"profile_image_url"]];
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                UIImage *image = [UIImage imageWithData:imageData];
                
                if(image){
                    [dOfPerson setObject:image forKey:@"image"];
                }
                
                [self.contactsArray addObject:dOfPerson];
            }

            nextCursor = [followers objectForKey:@"next_cursor"];
            
        }

        backupArray = nil;
        backupArray = contactsArray;
        if([nextCursor compare:[NSDecimalNumber zero]] == NSOrderedSame){
            [self.uiTableView reloadData];
        }else{
            [self cursoredTwitterContacts:[NSString stringWithFormat:@"%@", nextCursor] arrayOfAccounts:arrayOfAccounts];
        }

        NSLog(@"Twitter response, HTTP response: %i", [urlResponse statusCode]);
    }];
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
                    
                    backupArray = nil;
                    backupArray = contactsArray;
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
            [self sendSMS:@"I am using the flyerly app to create and share flyers on the go! - http://www.flyr.us" recipients:identifiers];
            
        }else if(selectedTab == 2){
            // Send tweets to twitter contacts
            for(NSString *follower in identifiers){
                [self sendTwitterMessage:@"I am using the flyerly app to create and share flyers on the go! -                                    http://www.flyr.us" screenName:follower];
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
        
        [FBRequestConnection startForPostStatusUpdate:@"I am using the flyerly app to create and share flyers on the go! - http://www.flyr.us" place:@"144479625584966" tags:identifiers completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            
            //NSLog(@"New Result: %@", result);
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
    
    //if(loadingViewFlag){
    //    [loadingView removeView];
    //    loadingViewFlag = NO;
    //}
    
    if(loadingViewFlag){
        for (UIView *subview in self.view.subviews) {
            if([subview isKindOfClass:[LoadingView class]]){
                [subview removeFromSuperview];
                loadingViewFlag = NO;
            }
        }
    }

    // Get index like 0, 2, 4, 6 etc
    int index = (indexPath.row * 2);
    //NSLog(@"index: %d", index);
    
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
        //NSLog(@"Reusing Row");
        cell = [self.deviceContactItems objectAtIndex:indexPath.row];
    }
    
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil];
        cell=[nib objectAtIndex:0];
        
        if(unSelectAll){
            [cell.leftCheckBox setSelected:NO];
            [cell.rightCheckBox setSelected:NO];
            cell.leftSelected = NO;
            cell.rightSelected = NO;
        } else {
            [cell.leftCheckBox setSelected:YES];
            [cell.rightCheckBox setSelected:YES];
            cell.leftSelected = YES;
            cell.rightSelected = YES;
        }

        // Add cell in array for tracking
        [self.deviceContactItems addObject:cell];
        
    } else {
        //NSLog(@"Reusing Row");
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
    __block UIImage *image1 = nil;
    if(selectedTab == FACEBOOK_TAB){
        //[dict1 objectForKey:@"image"];
        image1 =[dict1 objectForKey:@"image"];
    } else {
        image1 =[dict1 objectForKey:@"image"];
    }

    // Get right contact data
    NSMutableDictionary *dict2;
    NSString *name2;
    __block UIImage *image2 = nil;

    // Check index
    if([self.contactsArray count] > (index+ 1)){
        dict2 = [self.contactsArray objectAtIndex:(index + 1)];
        name2 = [dict2 objectForKey:@"name"];
        
        if(selectedTab == FACEBOOK_TAB){
            //image2 = [dict2 objectForKey:@"image"];
            image2 = [dict2 objectForKey:@"image"];
        } else {
            image2 = [dict2 objectForKey:@"image"];
        }
        
        cell.identifier2 = [dict2 objectForKey:@"identifier"];
    } else {
        name2 = @"";
        image2 = nil;
    }

    // Set data on screen
    [cell setValues:name1 title2:name2];
    
    //if(selectedTab == FACEBOOK_TAB){
    //
    //    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    //    dispatch_async(queue, ^(void) {
    //
    //        NSURL *imageURL1 = [NSURL URLWithString:[dict1 objectForKey:@"image"]];
    //        image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL1]];
    //        NSURL *imageURL2 = [NSURL URLWithString:[dict2 objectForKey:@"image"]];
    //        image2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL2]];
    //
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            [cell setImages:image1 image2:image2];
    //            [cell setNeedsLayout];
    //        });
    //    });
    //
    //}else{
        [cell setImages:image1 image2:image2];
    //}
    
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
    
    unSelectAll = NO;

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
    
    unSelectAll = YES;

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
    NSLog(@"%@",appDelegate.facebook.accessToken);
    NSLog(@"%@",appDelegate.facebook.expirationDate);

    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.facebook.accessToken forKey:@"FBAccessTokenKey"];
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.facebook.expirationDate forKey:@"FBExpirationDateKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self loadFacebookContacts:self.facebookButton];
}

- (IBAction)onSearchClick:(UIButton *)sender{
    [searchTextField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if([string isEqualToString:@"\n"]){
        [searchTextField resignFirstResponder];
        return NO;
    }
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if([newString isEqualToString:@""]){
        contactsArray = backupArray;
        [self.uiTableView reloadData];
        return YES;
    }
    
    filteredArray = nil;
    filteredArray = [[NSMutableArray alloc] init];
    
    for(int contactIndex=0; contactIndex<[backupArray count]; contactIndex++){
        // Get left contact data
        NSMutableDictionary *dict1 = [self.backupArray objectAtIndex:contactIndex];
        NSString *name1 = [dict1 objectForKey:@"name"];
        
        if([[name1 lowercaseString] hasPrefix:[newString lowercaseString]]){
            [filteredArray addObject:dict1];
        }
    }
    
    //NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease];
    //NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    //sortedArray = [contactsArray sortedArrayUsingDescriptors:sortDescriptors];
    
    contactsArray = filteredArray;
    
    [self.uiTableView reloadData];

    return YES;
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
    
	//if(loadingViewFlag)
	//{
	//	[loadingView removeFromSuperview];
	//	loadingViewFlag=NO;
	//}
    
    if(loadingViewFlag){
        for (UIView *subview in self.view.subviews) {
            if([subview isKindOfClass:[LoadingView class]]){
                [subview removeFromSuperview];
                loadingViewFlag = NO;
            }
        }
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
    
    [backupArray release];
    
    [super dealloc];
}

@end
