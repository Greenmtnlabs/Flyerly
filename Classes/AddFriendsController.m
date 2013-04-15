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

@implementation AddFriendsController
@synthesize tableContainer, uiTableView, contactsArray;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    CGRect targetRect = CGRectMake(0, 0, self.tableContainer.frame.size.width, self.tableContainer.frame.size.height);
	uiTableView = [[UITableView alloc] initWithFrame:targetRect style:UITableViewStylePlain];
	
    [self.uiTableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default.png"]]];
    
    uiTableView.dataSource = self;
	uiTableView.delegate = self;
	[self.tableContainer addSubview:uiTableView];
	self.uiTableView.rowHeight =40;
    
    [self loadLocalContacts];
}

-(void)loadLocalContacts{

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
        
        NSLog(@"First Name:%@ -- Last Name: %@", firstName, lastName);
        
        //For Email ids
        ABMutableMultiValueRef eMail  = ABRecordCopyValue(ref, kABPersonEmailProperty);
        if(ABMultiValueGetCount(eMail) > 0) {
            [dOfPerson setObject:(NSString *)ABMultiValueCopyValueAtIndex(eMail, 0) forKey:@"email"];
            
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
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return  [contactsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    
    static NSString *cellId = @"AddFriendItem";
    AddFriendItem *cell = (AddFriendItem *)[uiTableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    
    NSMutableDictionary *dict = [contactsArray objectAtIndex:indexPath.row];
    NSString *name = [dict objectForKey:@"name"];
    
    [cell setValues:name title2:name];

    if (indexPath.row % 2) {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    } else {
        cell.contentView.backgroundColor = [UIColor grayColor];
    }
    
    return cell;
}

- (void) deselect
{
	//[self.tView deselectRowAtIndexPath:[self.tView indexPathForSelectedRow] animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
    DraftViewController *draftViewController = [[DraftViewController alloc] initWithNibName:@"DraftViewController" bundle:nil];
	NSString *imageName = [photoArray objectAtIndex:indexPath.row];
    NSData *imageData = [[NSData alloc ]initWithContentsOfMappedFile:imageName];
	UIImage *currentFlyerImage = [UIImage imageWithData:imageData];
	draftViewController.fvController = self;
	draftViewController.selectedFlyerImage = currentFlyerImage;
	[self.navigationController pushViewController:draftViewController animated:YES];
    [draftViewController release];
	[self performSelector:@selector(deselect) withObject:nil afterDelay:0.2f];
    */
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
	[tableView beginUpdates];
	[tableView setEditing:YES animated:YES];
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
	{
        [tableView deleteRowsAtIndexPaths:
         [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row  inSection:indexPath.section],nil]
                         withRowAnimation:UITableViewRowAnimationLeft];
        
        NSString *imageName = [photoArray objectAtIndex:[indexPath row]];
        [[NSFileManager defaultManager] removeItemAtPath:imageName error:nil];
        [photoArray removeObjectAtIndex:[indexPath row]];
		[iconArray removeObjectAtIndex:[indexPath row]];
	}
	[tableView endUpdates];
	[tableView reloadData];
     */
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
