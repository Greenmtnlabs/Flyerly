//
//  AddFriendsController.m
//  Flyr
//
//  Created by Riksof on 4/15/13.
//
//

#import "InviteFriendsController.h"
#import "Common.h"
#import "CommonFunctions.h"
#import <QuartzCore/QuartzCore.h>

@interface InviteFriendsController (){
  CommonFunctions *commonFunctions;
}
@end

@implementation InviteFriendsController
@synthesize uiTableView, contactsArray, selectedIdentifiers,contactsButton, searchTextField,iPhoneinvited;
@synthesize contactBackupArray;

#pragma mark  View Appear Methods

- (void)viewDidLoad {

    [super viewDidLoad];

    commonFunctions = [[CommonFunctions alloc] init];

    
    self.selectedIdentifiers = [[NSMutableArray alloc] init];

    self.navigationItem.hidesBackButton = YES;
    [self.view setBackgroundColor:[UIColor colorWithRed:245/255.0 green:241/255.0 blue:222/255.0 alpha:1]];


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
	[inviteButton addTarget:self action:@selector(invite) forControlEvents:UIControlEventTouchUpInside];
    [inviteButton setBackgroundImage:[UIImage imageNamed:@"invite_friend"] forState:UIControlStateNormal];
    inviteButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:inviteButton];
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];
    
    [self.uiTableView  setBackgroundColor:[UIColor colorWithRed:245/255.0 green:241/255.0 blue:222/255.0 alpha:1.0]];
    [searchTextField setReturnKeyType:UIReturnKeyDone];
    
    

    
    self.iPhoneinvited = [[NSMutableArray alloc] init];

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

#pragma mark  Custom Methods

-(IBAction)goBack{
    [self.navigationController popViewControllerAnimated:YES];
    
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
    return NO;
}

-(IBAction)invite{
    
    NSMutableArray *identifiers = [[NSMutableArray alloc] init];
    identifiers = selectedIdentifiers;
    NSLog(@"%@",identifiers);
    
    if([identifiers count] > 0){
        
        
        
    } else {

        [commonFunctions showAlert:@"Please select any contact to invite !" message:@""];
    }
    

}



#pragma mark  Device Contact List

/*
 * This method is used to load device contact details
 */
- (IBAction)loadLocalContacts:(UIButton *)sender{
    
    
    // HERE WE HIGHLIGHT BUTTON SELECT AND
    // UNSELECTED BUTTON
    [contactsButton setSelected:YES];



    
    self.selectedIdentifiers = nil;
    self.selectedIdentifiers = [[NSMutableArray alloc] init];
    
    
    [self.uiTableView reloadData];
    // init contact array
    if(contactBackupArray){
        
        // Reload table data after all the contacts get loaded
        contactsArray = nil;
        contactsArray = contactBackupArray;
  
        
        // Filter contacts on new tab selection
        [self onSearchClick:nil];
        
        [[self uiTableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        
    }
    else {
       
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
        

        
    }
    



    
    // Filter contacts on new tab selection
    [self onSearchClick:nil];
    
    [[self uiTableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    {
        

        
    }
}






/*
 * Here we Hide our facebook post View
 */
- (void)fbCancel {
    [selectedIdentifiers removeAllObjects];
    [uiTableView reloadData];
    
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
    [cell setCellObjects:receivedDic :status :@"InviteFriends"];
        
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	

    // HERE WE WORK FOR CONTACTS
    if (YES) {
        
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


@end