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
@synthesize uiTableView, contactsArray, deviceContactItems, contactsLabel, facebookLabel, twitterLabel, doneLabel, selectAllLabel, unSelectAllLabel, inviteLabel;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // By default first tab is selected 'Contacts'
    selectedTab = 0;
    
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
    [self loadLocalContacts];

}

/*
 * This method is used to load device contact details
 */
- (IBAction)loadLocalContacts{

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
        //NSLog(@"First Name:%@ -- Last Name: %@", firstName, lastName);
        
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

- (IBAction)loadFacebookContacts{

    FlyrAppDelegate *appDele =(FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];

    if(appDele._session.uid != 0){
        
        NSString* fql = [NSString stringWithFormat:@"SELECT uid,name,birthday_date FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 == %lld))", appDele._session.uid];
        //select uid,name from user where uid == %lld
        NSDictionary* params = [NSDictionary dictionaryWithObject:fql forKey:@"query"];
        
        if(params){
            
            [[FBRequest requestWithDelegate:self] call:@"facebook.friends.get" params:params];
        }
    
    } else {
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No facebook connection"
                                                        message:@"You must be connected to Facebook to get contact list."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

NSArray *myList;
int totalFacebookUserCounts;

-(void)request:(FBRequest *)request didLoad:(id)result{

    //NSLog(@"result: %@", result);
    
    if(myList==nil) {
        NSArray* users = result;
        myList =[[NSArray alloc] initWithArray: users];

        // init contact array with number of friends counts
        totalFacebookUserCounts = [users count];
        contactsArray = [[NSMutableArray alloc] initWithCapacity:totalFacebookUserCounts];

        for(NSInteger i=0;i<[users count];i++) {
            NSDictionary* user = [users objectAtIndex:i];
            NSString* uid = [user objectForKey:@"uid"];
            NSString* fql = [NSString stringWithFormat:
                             @"select name from user where uid == %@", uid];
            
            NSDictionary* params = [NSDictionary dictionaryWithObject:fql forKey:@"query"];
            [[FBRequest requestWithDelegate:self] call:@"facebook.fql.query" params:params];
        }
    }
    else {
        
        NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];

        NSArray* users = result;
        NSDictionary* user = [users objectAtIndex:0];
        NSString* name = [user objectForKey:@"name"];
        
        [dOfPerson setObject:name forKey:@"name"];
        [contactsArray addObject:dOfPerson];
                
        //NSLog(@"Name: %@", name);
    }
    
    if([contactsArray count] == totalFacebookUserCounts){
        [uiTableView reloadData];
        myList = nil;
        totalFacebookUserCounts = 0;
    }
}

-(void)loadTwitterContacts{
    
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
    } else {
        name2 = @"";
        image2 = nil;
    }

    // Set data on screen
    [cell setValues:name1 title2:name2];
    [cell setImages:image1 image2:image2];
    
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
