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

@implementation AddFriendsController
@synthesize uiTableView, contactsArray, deviceContactItems, contactsLabel, facebookLabel, twitterLabel, doneLabel, selectAllLabel, unSelectAllLabel, inviteLabel, contactsButton, facebookButton, twitterButton;

const int TWITTER_TAB = 2;
const int FACEBOOK_TAB = 1;
const int CONTACTS_TAB = 0;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // By default first tab is selected 'Contacts'
    selectedTab = -1;
    
    // set borders on the table
    [[uiTableView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[uiTableView layer] setBorderWidth:1];
    
    // Set fonts type and sizes
    [contactsLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:13]];
    [contactsLabel setText:NSLocalizedString(@"contacts", nil)];

    [facebookLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:13]];
    [facebookLabel setText:NSLocalizedString(@"facebook", nil)];

    [twitterLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:13]];
    [twitterLabel setText:NSLocalizedString(@"twitter", nil)];

    [doneLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:13]];
    [doneLabel setText:NSLocalizedString(@"done", nil)];

    [selectAllLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:13]];
    [selectAllLabel setText:NSLocalizedString(@"select_all", nil)];

    [unSelectAllLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:13]];
    [unSelectAllLabel setText:NSLocalizedString(@"unselect_all", nil)];

    [inviteLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:13]];
    [inviteLabel setText:NSLocalizedString(@"invite", nil)];

    // Load device contacts
    [self loadLocalContacts:contactsButton];

}

/*
 * This method is used to load device contact details
 */
- (IBAction)loadLocalContacts:(UIButton *)sender{

    if(selectedTab == CONTACTS_TAB){
        return;
    }

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
    [uiTableView reloadData];
}

/**
 * Called when facebook  button is selected on screen
 */
- (IBAction)loadFacebookContacts:(UIButton *)sender{

    if(selectedTab == FACEBOOK_TAB){
        return;
    }

    selectedTab = FACEBOOK_TAB;
    [self setUnselectTab:sender];

    // Get facebook session from app delegate
    FlyrAppDelegate *appDele =(FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    if(appDele._session.uid != 0){
        
        // Create fql to loggedin user's info
        NSString* fql = [NSString stringWithFormat:@"SELECT uid,name,birthday_date FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 == %lld))", appDele._session.uid];
        NSDictionary* params = [NSDictionary dictionaryWithObject:fql forKey:@"query"];
        
        if(params){
            
            // Send request
            [[FBRequest requestWithDelegate:self] call:@"facebook.friends.get" params:params];
        }
    
    } else {
    
        // IF facebook is not connected then show this alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No facebook connection"
                                                        message:@"You must be connected to Facebook to get contact list."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void)request:(FBRequest *)request didLoad:(id)result{
    
    // check if not my facebook record
    if(!secondRequest) {
        NSArray* users = result;
        secondRequest = YES;
        
        // init contact array with number of friends counts
        totalFacebookUserCounts = [users count];
        [contactsArray release];
        contactsArray = nil;
        contactsArray = [[NSMutableArray alloc] initWithCapacity:totalFacebookUserCounts];

        for(NSInteger i=0;i<[users count];i++) {
            
            // Send second request for my  facebook contacts
            NSDictionary* user = [users objectAtIndex:i];
            NSString* uid = [user objectForKey:@"uid"];
            NSString* fql = [NSString stringWithFormat:
                             @"select name from user where uid == %@", uid];
            
            NSDictionary* params = [NSDictionary dictionaryWithObject:fql forKey:@"query"];
            [[FBRequest requestWithDelegate:self] call:@"facebook.fql.query" params:params];
        }
        
    } else {
        
        // Here we will get the facebook contacts
        NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];

        NSArray* users = result;
        NSDictionary* user = [users objectAtIndex:0];
        NSString* name = [user objectForKey:@"name"];
        
        [dOfPerson setObject:name forKey:@"name"];
        [contactsArray addObject:dOfPerson];
    }
    
    if([contactsArray count] == totalFacebookUserCounts){
        [uiTableView reloadData];
        secondRequest = NO;
        totalFacebookUserCounts = 0;
    }
}

//BOOL grantedBool;
- (IBAction)loadTwitterContacts:(UIButton *)sender{
    
    if(selectedTab == TWITTER_TAB){
        return;
    }
    
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
                            
                            [contactsArray release];
                            contactsArray = nil;
                            contactsArray = [[NSMutableArray alloc] initWithCapacity:[users count]];
                            
                            for (id user in users) {
                                NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];
                                [dOfPerson setObject:[user objectForKey:@"name"] forKey:@"name"];
                                [dOfPerson setObject:[user objectForKey:@"screen_name"] forKey:@"identifier"];
                                [contactsArray addObject:dOfPerson];
                            }
                        }
                        
                        NSLog(@"Twitter response, HTTP response: %i", [urlResponse statusCode]);
                        [uiTableView reloadData];
                    }];
                }
            }
        }];
    
    } else {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Twitter connection"
                                                        message:@"You must be connected to Twitter to get contact list."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
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
                    
                    [uiTableView reloadData];
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
        
        // prepare users to tweet
        if(selectedTab == 2){
            if([cell.leftCheckBox isSelected]){
                [identifiers addObject:cell.identifier1];
            }
            
            if([cell.rightCheckBox isSelected]){
                [identifiers addObject:cell.identifier2];
            }
            
            // prepare facebook contacts
        } else if(selectedTab == 1){
            
            // Post a status update to the user's feedm via the Graph API, and display an alert view
            // with the results or an error.

            if([cell.leftCheckBox isSelected]){
                FBStreamDialog *dialog = [[[FBStreamDialog alloc] init] autorelease];
                dialog.userMessagePrompt = @"Enter your message:";
                dialog.attachment = [NSString stringWithFormat:@"{\"name\":\"Facebook Connect for iPhone\",\"href\":\"http://developers.facebook.com/connect.php?tab=iphone\",\"caption\":\"Caption\",\"description\":\"Description\",\"media\":[{\"type\":\"image\",\"src\":\"http://img40.yfrog.com/img40/5914/iphoneconnectbtn.jpg\",\"href\":\"http://developers.facebook.com/connect.php?tab=iphone/\"}],\"properties\":{\"another link\":{\"text\":\"Facebook home page\",\"href\":\"http://www.facebook.com\"}}}"];
                [dialog show];
            }

            if([cell.rightCheckBox isSelected]){
                                
                FBStreamDialog *dialog = [[[FBStreamDialog alloc] init] autorelease];
                dialog.userMessagePrompt = @"Enter your message:";
                dialog.attachment = [NSString stringWithFormat:@"{\"name\":\"Facebook Connect for iPhone\",\"href\":\"http://developers.facebook.com/connect.php?tab=iphone\",\"caption\":\"Caption\",\"description\":\"Description\",\"media\":[{\"type\":\"image\",\"src\":\"http://img40.yfrog.com/img40/5914/iphoneconnectbtn.jpg\",\"href\":\"http://developers.facebook.com/connect.php?tab=iphone/\"}],\"properties\":{\"another link\":{\"text\":\"Facebook home page\",\"href\":\"http://www.facebook.com\"}}}"];
                [dialog show];
            }            
            
            // prepare contacts to sms
        } else if(selectedTab == 0){
        
            if([cell.leftCheckBox isSelected]){
                [identifiers addObject:cell.identifier1];
            }
            
            if([cell.rightCheckBox isSelected]){
                [identifiers addObject:cell.identifier2];
            }
        
        } 
    }
    
    // Send invitations
    if(selectedTab == 0){
        
        // send tweets to contacts
        [self sendSMS:@"Test SMS" recipients:identifiers];
        
    }else if(selectedTab == 2){
        // Send tweets to twitter contacts
        for(NSString *follower in identifiers){
            [self sendTwitterMessage:@"I am using the flyerly app to create and share flyers on the go! - https://itunes.apple.com/app/socialflyr/id344130515?ls=1&mt=8" screenName:follower];
        }
    }
}

-(void)sendSMS:(NSString *)message recipients:(NSArray*)recipients {
    
    //send SMS
    MFMessageComposeViewController *messageInstance = [[MFMessageComposeViewController alloc] init];
    
    if([MFMessageComposeViewController canSendText]) {

        [messageInstance setRecipients:recipients];
        messageInstance.body = message;
        messageInstance.messageComposeDelegate = self;
        [self presentModalViewController:messageInstance animated:YES];
        
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
    if(([contactsArray count] % 2) == 1){
        count++;
    }
    
    [deviceContactItems release];
    deviceContactItems = nil;
    deviceContactItems = [[NSMutableArray alloc] init];

    // return count
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    
    // Get index like 0, 2, 4, 6 etc
    int index = (indexPath.row * 2);
    
    // Get cell
    static NSString *cellId = @"AddFriendItem";
    AddFriendItem *cell = (AddFriendItem *)[uiTableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    
    // Get left contact data
    NSMutableDictionary *dict1 = [contactsArray objectAtIndex:index];
    NSString *name1 = [dict1 objectForKey:@"name"];
    UIImage *image1 = [dict1 objectForKey:@"image"];
    
    // Get right contact data
    NSMutableDictionary *dict2;
    NSString *name2;
    UIImage *image2;

    // Check index
    if([contactsArray count] > (index+ 1)){
        dict2 = [contactsArray objectAtIndex:(index + 1)];
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
    
    // init cell array if null
    if(!deviceContactItems){
        deviceContactItems = [[NSMutableArray alloc] init];
    }
    
    // Add cell in array for tracking
    [deviceContactItems addObject:cell];

    // return cell
    return cell;
}

/*
 * Method use to select all checkboxes
 */
- (IBAction)selectAllCheckBoxes:(UIButton *)sender{
    
    for(AddFriendItem *cell in deviceContactItems){
        [cell.leftCheckBox setSelected:YES];
        [cell.rightCheckBox setSelected:YES];
    }
}

/*
 * Method use to unselect al checkboxes
 */
- (IBAction)unSelectAllCheckBoxes:(UIButton *)sender{
    
    for(AddFriendItem *cell in deviceContactItems){
        [cell.leftCheckBox setSelected:NO];
        [cell.rightCheckBox setSelected:NO];
    }
}

-(void)setUnselectTab:(UIButton *)selectButton{

    [contactsButton setSelected:NO];
    [facebookButton setSelected:NO];
    [twitterButton setSelected:NO];
    
    [selectButton setSelected:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];	
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)dealloc {
    [super dealloc];
}

@end
