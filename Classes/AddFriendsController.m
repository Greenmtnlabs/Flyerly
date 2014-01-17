//
//  AddFriendsController.m
//  Flyr
//
//  Created by Rizwan Ahmad on 4/15/13.
//
//

#import "AddFriendsController.h"
#import "Common.h"
#import <QuartzCore/QuartzCore.h>
#import "FlyrAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "LoadingView.h"
#import "PhotoController.h"
#import "HelpController.h"
#import "Flurry.h"

@implementation AddFriendsController
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
    globle = [Singleton RetrieveSingleton];
    self.navigationItem.hidesBackButton = YES;
    [self.view setBackgroundColor:[globle colorWithHexString:@"f5f1de"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg_without_logo2"] forBarMetrics:UIBarMetricsDefault];
    
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
    label.textColor = [UIColor whiteColor];
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
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:backBarButton,leftBarButton,nil]];
    
    [self.uiTableView  setBackgroundColor:[globle colorWithHexString:@"f5f1de"]];
    [searchTextField setReturnKeyType:UIReturnKeyDone];
    
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
    invited = NO;
    [deviceContactItems removeAllObjects];
    contactsCount = 0;
    if(selectedTab == CONTACTS_TAB){
        return;
    }
    
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
        //[self.uiTableView reloadData];
        
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
        NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];
        
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
        
        dOfPerson[@"name"] = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        
        //For Email ids
        ABMutableMultiValueRef eMail  = ABRecordCopyValue(ref, kABPersonEmailProperty);
        if(ABMultiValueGetCount(eMail) > 0) {
            dOfPerson[@"email"] = (NSString *)CFBridgingRelease(ABMultiValueCopyValueAtIndex(eMail, 0));
        }
        
        // For contact picture
        UIImage *contactPicture;
        
        if (ref != nil && ABPersonHasImageData(ref)) {
            if ( &ABPersonCopyImageDataWithFormat != nil ) {
                // iOS >= 4.1
                contactPicture = [UIImage imageWithData:(NSData *)CFBridgingRelease(ABPersonCopyImageDataWithFormat(ref, kABPersonImageFormatThumbnail))];
                dOfPerson[@"image"] = contactPicture;
            } else {
                // iOS < 4.1
                contactPicture = [UIImage imageWithData:(NSData *)CFBridgingRelease(ABPersonCopyImageData(ref))];
                dOfPerson[@"image"] = contactPicture;
            }
        }
        
        //For Phone number
        NSString* mobileLabel;
        
        for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) {
            
            mobileLabel = (NSString*)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(phones, i));
            if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
            {
                dOfPerson[@"Phone"] = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, i));
                dOfPerson[@"identifier"] = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, i));
                [contactsArray addObject:dOfPerson];
            }
            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
            {
                dOfPerson[@"Phone"] = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, i));
                [contactsArray addObject:dOfPerson];
                break ;
            }
        }
        
    }
    
    // Reload table data after all the contacts get loaded
    contactBackupArray = nil;
    contactBackupArray = contactsArray;
    [[self uiTableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

/**
 * Called when facebook  button is selected on screen
 */
- (IBAction)loadFacebookContacts:(UIButton *)sender{
    
    if([AddFriendsController connected]){
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
           
            
        } else{
            
          
             ACAccountStore *accountStore = [[ACAccountStore alloc]init];
             ACAccountType *FBaccountType= [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
             NSDictionary *options = @{ACFacebookAppIdKey : @"136691489852349",
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
        NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];
        
        dOfPerson[@"name"] = friendData[@"name"];
        dOfPerson[@"identifier"] = friendData[@"id"];
        if (friendData[@"gender"]) {
            dOfPerson[@"gender"] = friendData[@"gender"];
        }
        if(imageURL){
            dOfPerson[@"image"] = imageURL;
        }

        [self.facebookArray addObject:dOfPerson];
        
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
    
    if([AddFriendsController connected]){
        contactsCount = 0;
        invited = NO;
        if(selectedTab == TWITTER_TAB){
            return;
        }
        
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
                NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];
                dOfPerson[@"name"] = user[@"name"];
                dOfPerson[@"identifier"] = user[@"screen_name"];
                dOfPerson[@"location"] = user[@"location"];
                
                NSString *imageURL = user[@"profile_image_url"];
                NSString *new = [imageURL stringByReplacingOccurrencesOfString: @"normal" withString:@"bigger"];
                
                if(imageURL){
                    dOfPerson[@"image"] = new;
                }
                
                [self.twitterArray addObject:dOfPerson];
            }
            
            twitterBackupArray = nil;
            twitterBackupArray = twitterArray;
            
            [uiTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            nextCursor = followers[@"next_cursor"];
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
            
            // send tweets to contacts
            [self sendSMS:@"I'm using the flyerly app to create and share flyers on the go! Flyer.ly/Invite" recipients:identifiers];
            
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
    
    static NSString *CellIdentifier = @"InviteCell";
    
    // Create My custom cell view
    AddFriendsDetail *cell = (AddFriendsDetail *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    if ( cell == nil ) {
        cell = [[AddFriendsDetail alloc] initWithFrame:CGRectZero] ;
        
    }
    [cell setBackgroundColor:[globle colorWithHexString:@"f5f1de"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(loadingViewFlag){
        for (UIView *subview in self.view.subviews) {
            if([subview isKindOfClass:[LoadingView class]]){
                [subview removeFromSuperview];
                loadingViewFlag = NO;
            }
        }
    }
    if(!self.deviceContactItems){
        self.deviceContactItems = [[NSMutableArray alloc] init];
    }
    
    NSMutableDictionary *dict2;
    NSString *name2;
    NSString *detailfield = nil;
    UIImage *imgfile =nil;
    NSString *imgfile2 =nil;
    // Check index
    if([[self getArrayOfSelectedTab] count] >= 1){
        
        dict2 = [self getArrayOfSelectedTab][(indexPath.row)];
        name2 = dict2[@"name"];
        if(selectedTab == FACEBOOK_TAB) detailfield = dict2[@"gender"];
        if(selectedTab == TWITTER_TAB) detailfield = dict2[@"location"];
        
        if(selectedTab == FACEBOOK_TAB || selectedTab == TWITTER_TAB){
            imgfile2 = dict2[@"image"];
        } else {
            imgfile = dict2[@"image"];
            detailfield = dict2[@"identifier"];
        }
        
    }
    if (imgfile == nil) {
        imgfile =[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dfcontact" ofType:@"jpg"]];
    }
    if(selectedTab == FACEBOOK_TAB || selectedTab == TWITTER_TAB){
        dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(dispatchQueue, ^(void)
                       {
                           dispatch_sync(dispatch_get_main_queue(), ^{
                               aview = [[AsyncImageView alloc]initWithFrame:CGRectMake(9, 7,72, 72)];
                               NSLog(@"%@",imgfile2);
                               NSURL *imageurl = [NSURL URLWithString:imgfile2];
                               NSLog(@"%@",imageurl);
                               [aview setImageURL:imageurl];
                               [cell.contentView addSubview:aview];
                           });
                       });
    }
    
    NSString *chkName = @"";
    if ([self ckeckExistContact:dict2[@"identifier"]]) {
        if ([self ckeckExistdb:dict2[@"identifier"]]) {
            chkName =@"checkwhite";
        }else{
             chkName =@"checkgray";
        }
    }else{
        chkName =@"checkgreen";
        
    }
    // Set cell Values
    [cell setCellObjects:name2 Description:detailfield :imgfile CheckImage:chkName];
    [cell.checkBtn addTarget:self action:@selector(inviteFreind:) forControlEvents:UIControlEventTouchUpInside];
    cell.checkBtn.tag = indexPath.row;
    
    return cell;
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

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    // Load device contacts
    [self loadLocalContacts:self.contactsButton];
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

@end