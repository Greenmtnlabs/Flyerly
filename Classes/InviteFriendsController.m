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
#import "CreateFlyerController.h"
#import "HelpController.h"
#import "Flurry.h"
#import "UserVoice.h"

@implementation InviteFriendsController {

    NSString *userUniqueObjectId;
    FlyerlyConfigurator *flyerConfigurator;
}
@synthesize uiTableView, contactsArray, selectedIdentifiers,contactsButton, facebookButton, twitterButton,  searchTextField, facebookArray, twitterArray,fbinvited,twitterInvited,iPhoneinvited;
@synthesize contactBackupArray, facebookBackupArray, twitterBackupArray;
@synthesize fbText;

const int TWITTER_TAB = 2;
const int FACEBOOK_TAB = 1;
const int CONTACTS_TAB = 0;


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
    
    // By default first tab is selected 'Contacts'
    selectedTab = -1;

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
    
    
    if ( [[PFUser currentUser] sessionToken].length != 0 )
    {
        
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:[[PFUser currentUser] objectForKey:@"username"]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                if (objects.count) {
                    for (PFObject *object in objects){
                        NSLog(@"Object ID: %@", object.objectId);
                        userUniqueObjectId = object.objectId;
                        
                        
                    }
                }
            }
        }];
    }
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    flyerConfigurator = appDelegate.flyerConfigurator;
    
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
    [self.navigationController popViewControllerAnimated:YES];
    
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
    identifiers = selectedIdentifiers;
    NSLog(@"%@",identifiers);

    NSString *sharingText = [NSString stringWithFormat:@"I'm using the Flyerly app to create and share flyers on the go! Want to give it a try? %@%@", flyerConfigurator.referralURL, userUniqueObjectId];
    
    if([identifiers count] > 0){
        
        // Send invitations
        if(selectedTab == 0){
            globle.accounts = [[NSMutableArray alloc] initWithArray:selectedIdentifiers];
            
            SHKItem *item = [SHKItem text:sharingText];
            item.textMessageToRecipients = selectedIdentifiers;
            
            iosSharer = [[ SHKSharer alloc] init];
            iosSharer = [SHKTextMessage shareItem:item];
            iosSharer.shareDelegate = self;
            
            
        }else if(selectedTab == 1){
            
            SHKItem *i = [SHKItem text:sharingText];
            
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
    
    [Flurry logEvent:@"Friends Invited"];
}



#pragma mark  Device Contact List

/*
 * This method is used to load device contact details
 */
- (IBAction)loadLocalContacts:(UIButton *)sender{
    
    
    // HERE WE HIGHLIGHT BUTTON SELECT AND
    // UNSELECTED BUTTON
    [contactsButton setSelected:YES];
    [twitterButton setSelected:NO];
    [facebookButton setSelected:NO];

    
    [selectedIdentifiers removeAllObjects];
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
    
    self.selectedIdentifiers = nil;
    self.selectedIdentifiers = [[NSMutableArray alloc] init];
    
    selectedTab = CONTACTS_TAB;
    
    [self.uiTableView reloadData];
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
    [self hideLoadingIndicator];
    
}


#pragma mark  Facebook Contact

/**
 * Called when facebook  button is selected on screen
 */
- (IBAction)loadFacebookContacts:(UIButton *)sender{
    
    if ([FlyerlySingleton connected]) {
        
        selectedTab = FACEBOOK_TAB;
        [self.uiTableView reloadData];

        // HERE WE HIGHLIGHT BUTTON ON TOUCH
        // AND OTHERS SET UNSELECTED
        [contactsButton setSelected:NO];
        [twitterButton setSelected:NO];
        [facebookButton setSelected:YES];
        
        [self showLoadingIndicator];
        
        self.selectedIdentifiers = nil;
        self.selectedIdentifiers = [[NSMutableArray alloc] init];
        
        
        if (facebookBackupArray == nil || facebookBackupArray.count == 0) {
            searchTextField.text = @"";
            facebookBackupArray = [[NSMutableArray alloc] init];
            
            // Current Item For Sharing
            SHKItem *item = [[SHKItem alloc] init];
            item.shareType = SHKShareTypeUserInfo;
            
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

            [self onSearchClick:nil];
            //Update Table View
            [self.uiTableView reloadData];
        
        }
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You're not connected to the internet. Please connect and retry." message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
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
        
        [self hideLoadingIndicator];
        
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


/*
 * Here we Send Request to facebook for tags Friends
 */
- (void)fbSend{
    
    
    // Current Item For Sharing
    SHKItem *item = [SHKItem text:fbText];
    item.tags = selectedIdentifiers;
    
    //Calling ShareKit for Sharing
    iosSharer = [[SHKSharer alloc] init];
    iosSharer = [FlyerlyFacebookInvite shareItem:item];
    iosSharer.shareDelegate = self;
    
    
}

/*
 * Here we Hide our facebook post View
 */
- (void)fbCancel {
    [selectedIdentifiers removeAllObjects];
    [uiTableView reloadData];
    
}


#pragma mark  TWITTER CONTACTS

/*
 * HERE WE REQUEST TO TWITTER FOR FRIENDS LIST
 */
- (IBAction)loadTwitterContacts:(UIButton *)sender{
    
    if ([FlyerlySingleton connected]) {
        
        // HERE WE HIGHLIGHT BUTTON SELECT AND
        // UNSELECTED BUTTON
        [contactsButton setSelected:NO];
        [twitterButton setSelected:YES];
        [facebookButton setSelected:NO];
        
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
            
            // Create controller and set share options
            iosSharer = [FlyerlyTwitterFriends shareItem:item];
            iosSharer.shareDelegate = self;
            
        }else {
        
            [self onSearchClick:nil];
            
            [self.uiTableView reloadData];
        }
    
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You're not connected to the internet. Please connect and retry." message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
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
    
    twitterArray = nil;
    twitterArray = twitterBackupArray;
    
    [uiTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [self hideLoadingIndicator];
    
    
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CGRect newFrame = CGRectMake( 0, 0,
                                 tableView.frame.size.width,
                                 100);
    
    
    
    static NSString *cellId = @"InviteCell";
    InviteFriendsCell *cell = (InviteFriendsCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    
    if ( cell == nil ) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InviteFriendsCell" owner:self options:nil];
        cell = (InviteFriendsCell *)[nib objectAtIndex:0];
        
        //cell.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        //[cell setFrame:newFrame];
        
        if( IS_IPHONE_5 ){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InviteFriendsCell" owner:self options:nil];
        cell = (InviteFriendsCell *)[nib objectAtIndex:0];
        } else if ( IS_IPHONE_6 ){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InviteFreindsCell-iPhone6" owner:self options:nil];
            cell = (InviteFriendsCell *)[nib objectAtIndex:0];
        } else if ( IS_IPHONE_6_PLUS ) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InviteFreindsCell-iPhone6-Plus" owner:self options:nil];
            cell = (InviteFriendsCell *)[nib objectAtIndex:0];
        }
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
    if (selectedTab == 0) {
        
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
        
        NSString *sharingText = [NSString stringWithFormat:@"I'm using the Flyerly app to create and share flyers on the go! Want to give it a try? %@%@", flyerConfigurator.referralURL, userUniqueObjectId];
        
        //CHECK FOR ALREADY SELECTED
        if (model.status == 0) {
            [model setInvitedStatus:1];
            
            [selectedIdentifiers addObject:model.description];
            
            //Calling ShareKit for Sharing
            iosSharer = [[ SHKSharer alloc] init];
            NSString *tweet = [NSString stringWithFormat:@"%@ @%@ #flyerly",sharingText,model.description];
            
            [selectedIdentifiers addObject:model.description];
            iosSharer = [SHKTwitter shareText:tweet];
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
        [twitterInvited  addObjectsFromArray:selectedIdentifiers];
        user[@"tweetinvited"] = twitterInvited;
        [self friendsInvited];
 
    } else if ( [sharer isKindOfClass:[SHKTextMessage class]] == YES ) {
        
        // HERE WE GET AND SET SELECTED CONTACT LIST
        [iPhoneinvited  addObjectsFromArray:selectedIdentifiers];
        user[@"iphoneinvited"] = iPhoneinvited;
        [self friendsInvited];

        
    } else  if ( [sharer isKindOfClass:[FlyerlyFacebookInvite class]] == YES ) {
    
        // HERE WE GET AND SET SELECTED Facebook LIST
        [fbinvited  addObjectsFromArray:selectedIdentifiers];
        user[@"fbinvited"] = fbinvited;
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

@end