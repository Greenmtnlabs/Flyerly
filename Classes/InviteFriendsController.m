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
@synthesize uiTableView, contactsArray, deviceContactItems, contactsLabel, facebookLabel, twitterLabel, doneLabel, selectAllLabel, unSelectAllLabel, inviteLabel, contactsButton, facebookButton, twitterButton, loadingView, searchTextField, facebookArray, twitterArray,fbinvited,Twitterinvited,iPhoneinvited;
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
    
    
    // NEXT BAR BOTTON
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
	[nextButton addTarget:self action:@selector(invite) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
    nextButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];
    
    [self.uiTableView  setBackgroundColor:[globle colorWithHexString:@"f5f1de"]];
    [searchTextField setReturnKeyType:UIReturnKeyDone];
    
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
        return;
    }
    [self showLoadingIndicator];
    
    selectAll = YES;
    self.deviceContactItems = nil;
    self.deviceContactItems = [[NSMutableArray alloc] init];
    selectedIdentifierDictionary = nil;
    
    selectedTab = CONTACTS_TAB;
    
    PFUser *user = [PFUser currentUser];
    self.iPhoneinvited = [[NSMutableArray alloc] init];
    if (user[@"iphoneinvited"]) {
        self.iPhoneinvited  = user[@"iphoneinvited"];
    }
    
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
            }
            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
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
    
    
    // HERE WE HIGHLIGHT BUTTON SELECT AND
    // UNSELECTED BUTTON
    [contactsButton setSelected:NO];
    [twitterButton setSelected:NO];
    [facebookButton setSelected:YES];

    /*
    fbSubClass *fb = [[fbSubClass alloc] init];
    [fb freindList];
    return;*/
    
    if([InviteFriendsController connected]){
        
        [self showLoadingIndicator];
        
        contactsCount = 0;
        invited = NO;

        selectAll = YES;
        self.deviceContactItems = nil;
        self.deviceContactItems = [[NSMutableArray alloc] init];
        selectedIdentifierDictionary = nil;
        selectedTab = FACEBOOK_TAB;
  
       // init facebook array
        NSLog(@"%@",facebookBackupArray);

        if(facebookBackupArray){
            
            // Reload table data after all the contacts get loaded
            facebookArray = nil;
            facebookArray = facebookBackupArray;
            
            // Filter contacts on new tab selection
            [self onSearchClick:nil];
            [[self uiTableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            [self hideLoadingIndicator];

           
            
        } else{
            
          
             ACAccountStore *accountStore = [[ACAccountStore alloc]init];
             ACAccountType *FBaccountType= [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
            
            //get facebook app id
            NSString *path = [[NSBundle mainBundle] pathForResource: @"Flyr-Info" ofType: @"plist"];
            NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
            
            NSDictionary *options = @{ACFacebookAppIdKey : dict[@"FacebookAppID"],
                                      ACFacebookPermissionsKey : @[@"email", @"publish_stream"],
                                      ACFacebookAudienceKey:ACFacebookAudienceFriends};

            
            [accountStore requestAccessToAccountsWithType:FBaccountType options:options completion:^(BOOL granted, NSError *error) {
                
             // if User Login in device
             if (granted) {
             
             // Populate array with all available Twitter accounts
             arrayOfAccounts = [accountStore accountsWithAccountType:FBaccountType];
             account = [arrayOfAccounts lastObject];
             
             // Sanity check
             if ([arrayOfAccounts count] > 0) {
             
             NSURL *requestURL = [NSURL URLWithString:@"https://graph.facebook.com/me/friends"];
             SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
             requestMethod:SLRequestMethodGET
             URL:requestURL
             parameters:@{@"fields":@"name,gender,picture.height(72).width(72).type(small)"}];
             request.account = account;
             
             [request performRequestWithHandler:^(NSData *data,
             NSHTTPURLResponse *response,
             NSError *error) {
             
             if(!error){
                 NSDictionary *list =[NSJSONSerialization JSONObjectWithData:data
                                                                     options:kNilOptions error:&error];
                 NSLog(@"Dictionary contains: %@", list );
                 
                 self.facebookArray = [[NSMutableArray alloc] init];
                 
                 //Making Array for Loading
                 [self request:nil didLoad:list];
                 
                 //Getting already Invited Freinds
                 PFUser *user = [PFUser currentUser];
                 self.fbinvited = [[NSMutableArray alloc] init];
                 if (user[@"fbinvited"]) {
                     self.fbinvited  = user[@"fbinvited"];
                 }
                            [[self uiTableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
             }
             else{
             //handle error gracefully
             }
             
             }];
             }
             
             } else {
             //Fail gracefully...
                 NSLog(@"error getting permission %@",error);
                 [self showAlert:@"There is no Facebook account configured. You can add or create a Facebook account in Settings" message:@""];
             }
             }];
       
         }
    
    } else {
        
        [self showAlert:@"You're not connected to the internet. Please connect and retry." message:@""];
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

    
    if([InviteFriendsController connected]){

        contactsCount = 0;
        invited = NO;
        if(selectedTab == TWITTER_TAB){
            return;
        }

        [self showLoadingIndicator];
        
        selectAll = YES;
        self.deviceContactItems = nil;
        self.deviceContactItems = [[NSMutableArray alloc] init];
        selectedIdentifierDictionary = nil;

        selectedTab = TWITTER_TAB;
        
        // init twitter array
        if(twitterBackupArray){
            
            // Reload table data after all the contacts get loaded
            twitterArray = nil;
            twitterArray = twitterBackupArray;
            
            // Filter contacts on new tab selection
            [[self uiTableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            [self hideLoadingIndicator];

            
        } else{
            PFUser *user = [PFUser currentUser];
            self.Twitterinvited = [[NSMutableArray alloc] init];
            if (user[@"tweetinvited"]) {
                self.Twitterinvited  = user[@"tweetinvited"];
            }
            
            // Empty table view
            [[self uiTableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            
            if([TWTweetComposeViewController canSendTweet]){
                
                ACAccountStore *accountStore = [[ACAccountStore alloc] init];
                ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
                
                // Request access from the user to access their Twitter account
                [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
                    
                    // Did user allow us access?
                    if (granted == YES) {
                        
                        // Populate array with all available Twitter accounts
                        arrayOfAccounts = [accountStore accountsWithAccountType:accountType];
                        self.twitterArray = [[NSMutableArray alloc] init];
                        
                        // Sanity check
                        if ([arrayOfAccounts count] > 1) {
                            
                            // Show list of acccounts from which to select
                            dispatch_async(dispatch_get_main_queue(), ^{
                                UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Choose Account" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
                                actionSheet.tag = 2;
                                
                                for (int i = 0; i < arrayOfAccounts.count; i++) {
                                    ACAccount *acct = arrayOfAccounts[i];
                                    [actionSheet addButtonWithTitle:acct.username];
                                }
                                
                                [actionSheet addButtonWithTitle:@"Cancel"];
                                [actionSheet showInView:self.view];
                            });
                        } else if ([arrayOfAccounts count] > 0 ) {
                            [self cursoredTwitterContacts:[NSString stringWithFormat:@"%d", -1]
                                                  account:arrayOfAccounts[0]];
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
        
    } else {
        
        [self showAlert:@"You're not connected to the internet. Please connect and retry." message:@""];
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

/**
 * invite contacts
 */
-(void)inviteFreindUnselected:(NSString *)tag{
     NSMutableDictionary *dict2;
    dict2 = [self getArrayOfSelectedTab][[tag intValue]];
    NSString *identifier = [[NSString alloc]initWithString:dict2[@"identifier"]];

    for (int i =0; i < deviceContactItems.count; i++) {
        if ([identifier isEqualToString:deviceContactItems[i]]) {
            [deviceContactItems removeObjectAtIndex:i];
        }
        
    }
    
}

-(IBAction)inviteFreind:(id)sender{
    
    return;
    UIButton *cellImageButton = (UIButton *) sender;
    NSMutableDictionary *dict2;
    

        // Check index
        if([[self getArrayOfSelectedTab] count] >= 1){
            dict2 = [self getArrayOfSelectedTab][(cellImageButton.tag)];
            if ([self ckeckExistContact:dict2[@"identifier"]]) {
                  if (contactsCount <15) {
                      contactsCount = contactsCount +1;
                      [deviceContactItems addObject:dict2[@"identifier"]];
                      [cellImageButton setBackgroundImage:[UIImage imageNamed:@"checkgreen"] forState:UIControlStateNormal];
                  }else{
                      [self showAlert:@"You can only invite 15 user at a time" message:@""];
                  }
            }else{

                [self inviteFreindUnselected:[NSString stringWithFormat:@"%d",cellImageButton.tag]];
                 contactsCount = contactsCount -1;
                if ([self ckeckExistdb:dict2[@"identifier"]]) {
                    [cellImageButton setBackgroundImage:[UIImage imageNamed:@"checkwhite"] forState:UIControlStateNormal];
                }else{
                    [cellImageButton setBackgroundImage:[UIImage imageNamed:@"checkgray"] forState:UIControlStateNormal];
                }
            }
        }

    
}
- (BOOL)ckeckExistContact:(NSString *)identifier{
    for (int i = 0; i < deviceContactItems.count ; i++) {
        if ([identifier isEqualToString:deviceContactItems[i]]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)ckeckExistdb:(NSString *)identifier{
    NSMutableArray *checkary = [[NSMutableArray alloc] init];
    if (selectedTab == FACEBOOK_TAB){
        checkary = fbinvited;
    }else if(selectedTab == TWITTER_TAB){
        checkary = Twitterinvited;
    }else{
        checkary = iPhoneinvited;
    }
    
    for (int i = 0; i < checkary.count ; i++) {
        if ([identifier isEqualToString:checkary[i]]) {
            return NO;
        }
    }
    return YES;
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
            
            /*
            // send tweets to contacts
            [self sendSMS:@"I'm using the flyerly app to create and share flyers on the go! Flyer.ly/Invite" recipients:identifiers];*/
            
        }else if(selectedTab == 2){
            
                        
            // Send tweets to twitter contacts
            for(NSString *follower in identifiers){
                
                [self sendTwitterMessage:@"I'm using the @flyerlyapp to create and share flyers on the go! Flyer.ly/Twitter" screenName:follower];
                
            }
            
            [Twitterinvited  addObjectsFromArray:deviceContactItems];
            PFUser *user = [PFUser currentUser];
            user[@"tweetinvited"] = Twitterinvited;
            [user saveInBackground];
            [deviceContactItems   removeAllObjects];
            
            [self showAlert:@"Invitation Sent!" message:@"You have successfully invited your friends to join flyerly."];
            [self.uiTableView reloadData ];
            
        }else if(selectedTab == 1){
            NSLog(@"%@",identifiers);
            [self tagFacebookUsersWithFeed:identifiers];
            [fbinvited  addObjectsFromArray:deviceContactItems];
            NSLog(@"%@",fbinvited);
            
            PFUser *user = [PFUser currentUser];
            user[@"fbinvited"] = fbinvited;
            [user saveInBackground];
            [deviceContactItems removeAllObjects];
            [self showAlert:@"Invitation Sent!" message:@"You have successfully invited your friends to join flyerly."];
            [self.uiTableView reloadData ];
        }
        
    } else {
        [self showAlert:@"Nothing Selected !" message:@"Please select any contact to invite"];
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
       
        receivedDic = [ self getArrayOfSelectedTab ][(indexPath.row)];
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
    if ([self ckeckExistContact:receivedDic.description]) {
        if ([self ckeckExistdb:receivedDic.description]) {
            status = 0;
        }else{
            status = 1;
        }
    }else{
        status = 2;
        
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
        if (model.status == 2) {
            
            //REMOVE FROM SENDING LIST
            [deviceContactItems removeObject:model.description];

            if ([self ckeckExistdb:model.description]) {
                [model setInvitedStatus:1];
            }else {
                [model setInvitedStatus:0];
            }
        }else {
            [model setInvitedStatus:2];
            if ([self ckeckExistContact:model.description]) {
                [deviceContactItems addObject:model.description];
            }
        }
        
    }

    // HERE WE WORK FOR FACEBOOK
    if (selectedTab == 1) {
        
        ContactsModel *model = [self getArrayOfSelectedTab][(indexPath.row)];
        

        //CHECK FOR ALREADY SELECTED
        if (model.status == 2) {
            
            //REMOVE FROM SENDING LIST
            [deviceContactItems removeObject:model.description];
            
            if ([self ckeckExistdb:model.description]) {
                [model setInvitedStatus:1];
            }else {
                [model setInvitedStatus:0];
            }
            
        }else {
            [model setInvitedStatus:2];
            if ([self ckeckExistContact:model.description]) {
                [deviceContactItems addObject:model.description];
            }
            
            /*
            //Calling ShareKit for Sharing
            iosSharer = [[ SHKSharer alloc] init];
            NSString *tweet = [NSString stringWithFormat:@"I'm using the flyerly app to create and share flyers on the go! Flyer.ly/Facebook @%@ #flyerly",model.description];
            
            [deviceContactItems addObject:model.description];
            iosSharer = [SHKFacebook shareText:tweet];
            iosSharer.shareDelegate = self;*/

        }

        
        
    }

    
    // HERE WE WORK FOR TWITTER
    if (selectedTab == 2) {
        
        ContactsModel *model = [self getArrayOfSelectedTab][(indexPath.row)];
        
        //CHECK FOR ALREADY SELECTED
        if (model.status == 2) {

            //REMOVE FROM SENDING LIST
            [deviceContactItems removeObject:model.description];
            
            if ([self ckeckExistdb:model.description]) {
                [model setInvitedStatus:1];
            }else {
                [model setInvitedStatus:0];
            }
            
        }else {
            [model setInvitedStatus:2];
            if ([self ckeckExistContact:model.description]) {
                [deviceContactItems addObject:model.description];
            }
            
            //Calling ShareKit for Sharing
            iosSharer = [[ SHKSharer alloc] init];
            NSString *tweet = [NSString stringWithFormat:@"I'm using the @flyerlyapp to create and share flyers on the go! Flyer.ly/Twitter @%@ #flyerly",model.description];
            
            [deviceContactItems addObject:model.description];
            iosSharer = [SHKTwitter shareText:tweet];
            iosSharer.shareDelegate = self;
            
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
        NSMutableDictionary *dict1 = [self getBackupArrayOfSelectedTab][contactIndex];
        NSString *name1 = dict1[@"name"];
        
        if([[name1 lowercaseString] rangeOfString:[newString lowercaseString]].location == NSNotFound){
        } else {
            [filteredArray addObject:dict1];
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
    
    PFUser *user = [PFUser currentUser];
    
    // Here we Check Sharer for
    // Update PARSE
    if ( [sharer isKindOfClass:[SHKFacebook class]] == YES ) {
        
        //[self.flyer setFacebookStatus:1];
        
    } else if ( [sharer isKindOfClass:[SHKTwitter class]] == YES ) {
        
        // HERE WE GET AND SET SELECTED FOLLOWER
        [Twitterinvited  addObjectsFromArray:deviceContactItems];
        user[@"tweetinvited"] = Twitterinvited;
 
    } else if ( [sharer isKindOfClass:[SHKTextMessage class]] == YES ) {
        
        // HERE WE GET AND SET SELECTED CONTACT LIST
        [iPhoneinvited  addObjectsFromArray:deviceContactItems];
        user[@"iphoneinvited"] = iPhoneinvited;
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