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
#import "CreateFlyerController.h"
#import "HelpController.h"
#import "Flurry.h"
#import "UserVoice.h"
//#import "SHKSharer.h"
#import "Common.h"

@implementation InviteFriendsController {

    NSString *userUniqueObjectId;
    FlyerlyConfigurator *flyerConfigurator;
    NSString *cellDescriptionForRefrelFeature;
    NSMutableArray *usernames;
    NSArray *availableAccounts;
    ACAccount *selectedAccount;
    
    BOOL haveValidSubscription;
    UserPurchases *userPurchases;
    NSString *productIdentifier;
}

@synthesize uiTableView, emailsArray, contactsArray, selectedIdentifiers, emailButton, contactsButton, facebookButton, twitterButton,  searchTextField, facebookArray, twitterArray,fbinvited,twitterInvited,iPhoneinvited, emailInvited;
@synthesize emailBackupArray, contactBackupArray, facebookBackupArray, twitterBackupArray,refrelText;
@synthesize fbText;
@synthesize bannerAdsView;
@synthesize shouldShowAdd;
@synthesize btnBannerAdsDismiss;

const int EMAIL_TAB = 3;
const int TWITTER_TAB = 2;
const int FACEBOOK_TAB = 1;
const int CONTACTS_TAB = 0;

#pragma mark  View Appear Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    userPurchases = [UserPurchases getInstance];
    userPurchases.delegate = self;
    haveValidSubscription = !([userPurchases canShowAd]);
    
    bannerAdClosed = NO;
    bannerShowed = NO;
    
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

    [self setNavigation];
    
    [self.uiTableView  setBackgroundColor:[UIColor colorWithRed:245/255.0 green:241/255.0 blue:222/255.0 alpha:1.0]];
    [searchTextField setReturnKeyType:UIReturnKeyDone];
    
    if ([[PFUser currentUser] sessionToken].length != 0) {
        
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:[[PFUser currentUser] objectForKey:@"username"]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             if (!error)
             {
                 if (objects.count)
                 {
                     for (PFObject *object in objects)
                     {
                         NSLog(@"ParseUser unique object ID: %@", object.objectId);
                         
                         PFQuery *query = [PFUser  query];
                         [query whereKey:@"objectId" equalTo:object.objectId];
                         [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
                          {
                              if (!error)
                              {
                                  NSMutableDictionary *counterDictionary = [object valueForKey:@"estimatedData"];
                                  int refrelCounter = [[counterDictionary objectForKey:@"inviteCounter"] intValue];
                                  
                                  if ( refrelCounter >= 20 )
                                  {
                                      //Setting the feature name,feature description values for cell view using plist
                                      cellDescriptionForRefrelFeature = [NSString stringWithFormat:@"You have sucessfully unlocked Design Bundle feature by referring friends. Enjoy!"];
                                      
                                  }else if ( refrelCounter <= 0 ){
                                      cellDescriptionForRefrelFeature = [NSString stringWithFormat:@"Invite 20 people to %@ and unlock Design Bundle feature for FREE!", APP_NAME];
                                  }
                                  else if ( refrelCounter > 0 && refrelCounter < 20 )
                                  {
                                      int moreToInvite = 20 - refrelCounter;
                                    
                                      //Setting the feature name,feature description values for cell view using plist
                                      cellDescriptionForRefrelFeature = [NSString stringWithFormat:@"Invite %d more people to %@ and unlock Design Bundle feature for FREE!",  moreToInvite, APP_NAME];
                                  }
                                  
                                  [refrelText setText:cellDescriptionForRefrelFeature];
                            }
                          }];
                     }
                 }
             }
         }];
    }else {
        cellDescriptionForRefrelFeature = [NSString stringWithFormat:@"Invite 20 people to %@ and unlock Design Bundle feature for FREE!", APP_NAME];;

    }
    
    
    if ( [[PFUser currentUser] sessionToken].length != 0 ) {
        
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
    self.emailInvited = [[NSMutableArray alloc] init];
    
    if (user[@"iphoneinvited"])
        self.iPhoneinvited  = user[@"iphoneinvited"];

    if (user[@"fbinvited"])
        self.fbinvited  = user[@"fbinvited"];

    if (user[@"tweetinvited"])
        twitterInvited = user[@"tweetinvited"];
    if(user [@"emailinvited"])
        self.emailInvited = user[@"emailinvited"];
   
    // Load device contacts
    [self loadLocalContacts:self.contactsButton];
    
    
    
    if([FlyerlySingleton connected]){
        if( haveValidSubscription == NO ) {
            [self loadInterstitialAdd];
        }
    }
    
    // Execute the rest of the stuff, a little delayed to speed up loading.
    dispatch_async( dispatch_get_main_queue(), ^{
        
        if( IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS ){
            
            if( haveValidSubscription == NO ) {
                
                self.bannerAdsView.adUnitID = [flyerConfigurator bannerAdID];
                self.bannerAdsView.delegate = self;
                self.bannerAdsView.rootViewController = self;
                [self.bannerAdsView loadRequest:[self request]];
            }
        }
    });
    
}

-(void)setNavigation{

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
    UIBarButtonItem *rightBarInviteButton = [[UIBarButtonItem alloc] initWithCustomView:inviteButton];
    
    
    // InApp Purchase Button
    UIButton *btnInAppPurchase = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btnInAppPurchase addTarget:self action:@selector(openInAppPanel) forControlEvents:UIControlEventTouchUpInside];
    [btnInAppPurchase setBackgroundImage:[UIImage imageNamed:@"premium_features"] forState:UIControlStateNormal];
    btnInAppPurchase.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *rightBarInAppPurchaseButton = [[UIBarButtonItem alloc] initWithCustomView:btnInAppPurchase];
    
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarInviteButton, rightBarInAppPurchaseButton,nil]];

}

-(void)viewWillAppear:(BOOL)animated{
    self.btnBannerAdsDismiss.alpha = 0.0;
    self.bannerAdsView.alpha = 0.0;
    self.navigationItem.leftItemsSupplementBackButton = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma InApp Purchase Methods

-(void) openInAppPanel{
    inAppViewController = [InAppPurchaseRelatedMethods openInAppPurchasePanel:self];
}

- ( void )inAppPurchasePanelContent {
    [inAppViewController inAppDataLoaded];
}

- (void)inAppPanelDismissed {
    
}

- ( void )productSuccesfullyPurchased: (NSString *)productId {
    
    UserPurchases *userPurchases_ = [UserPurchases getInstance];
    userPurchases_.delegate = nil;
    inAppViewController.buttondelegate = self;
    haveValidSubscription = !([userPurchases canShowAd]);
    if ( haveValidSubscription ) {
        [self removeBAnnerAdd:YES];
    }
}

- (void)inAppPurchasePanelButtonTappedWasPressed:(NSString *)inAppPurchasePanelButtonCurrentTitle {
    
    __weak InAppViewController *inappviewcontroller_ = inAppViewController;
    if ([inAppPurchasePanelButtonCurrentTitle isEqualToString:(@"Sign In")]) {
        [inappviewcontroller_.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }else if ([inAppPurchasePanelButtonCurrentTitle isEqualToString:(@"Restore Purchases")]){
        [inappviewcontroller_ restorePurchase];
    }
}

- (void) userPurchasesLoaded {
    
    UserPurchases *userPurchases_ = [UserPurchases getInstance];
    userPurchases_.delegate = nil;
    
    if ( [userPurchases_ checkKeyExistsInPurchases: BUNDLE_IDENTIFIER_MONTHLY_SUBSCRIPTION]  ||
        [userPurchases_ checkKeyExistsInPurchases: BUNDLE_IDENTIFIER_YEARLY_SUBSCRIPTION] ) {
        [inAppViewController.paidFeaturesTview reloadData];
    } else {
        [self removeAdsBanner:YES];
    }
}


// Dismiss action for banner ad
-(void)removeAdsBanner:(BOOL)valForBannerClose{
    
    self.bannerAdsView.backgroundColor = [UIColor clearColor];
    
    UIView *viewToRemove = [bannerAdsView viewWithTag:999];
    [viewToRemove removeFromSuperview];
    //[bannerAdDismissBtn removeFromSuperview];
    [self.bannerAdsView removeFromSuperview];
    btnBannerAdsDismiss = nil;
    self.bannerAdsView = nil;
    
    bannerAdClosed = valForBannerClose;
}

#pragma mark  Custom Methods

-(void)loadHelpController{
    
    [UserVoice presentUserVoiceInterfaceForParentViewController:self];
}

-(IBAction)goBack{
    if ( self.shouldShowAdd != NULL ) {
        self.shouldShowAdd( @"", haveValidSubscription );
    }
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
    } else if (selectedTab == EMAIL_TAB){
        checkary = emailInvited;
    } else {
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
    
    //SHKItem *item;
    NSMutableArray *identifiers = [[NSMutableArray alloc] init];
    identifiers = selectedIdentifiers;
    
    NSString *sharingText = [NSString stringWithFormat:@"I'm using the %@ app to create and share flyers on the go! Want to give it a try? %@%@", APP_NAME, flyerConfigurator.referralURL, userUniqueObjectId];
    
    if([identifiers count] > 0){
        
        // Send invitations
        if(selectedTab == 0){ // for SMS
            globle.accounts = [[NSMutableArray alloc] initWithArray:selectedIdentifiers];

//            item = [SHKItem text:sharingText];
//            item.textMessageToRecipients = selectedIdentifiers;
//            
//            iosSharer = [[ SHKSharer alloc] init];
//            iosSharer = [SHKTextMessage shareItem:item];
//            iosSharer.shareDelegate = self;
   
        }else if(selectedTab == 1){ // for Facebook
            
//            item = [SHKItem text:sharingText];
//            
//            NSArray *shareFormFields = [SHKFacebookCommon shareFormFieldsForItem:item];
//            SHKFormController *rootView = [[SHKCONFIG(SHKFormControllerSubclass) alloc] initWithStyle:UITableViewStyleGrouped
//                                                                                                title:nil
//                                                                                     rightButtonTitle:SHKLocalizedString(@"Send to Facebook")
//                                           ];
//            
//            [rootView addSection:shareFormFields header:nil footer:item.URL!=nil?item.URL.absoluteString:nil];
//            
//            rootView.validateBlock = ^(SHKFormController *form) {
//                
//                // default does no checking and proceeds to share
//                [form saveForm];
//                
//            };
//        
//            rootView.saveBlock = ^(SHKFormController *form) {
//                [self updateItemWithForm:form];
//            };
//            
//            rootView.cancelBlock = ^(SHKFormController *form) {
//            };
//            
//            [[SHK currentHelper] showViewController:rootView];
        } else if (selectedTab == 3) { // for Email
//            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",flyerConfigurator.referralURL, userUniqueObjectId]];
//            item = [SHKItem URL:url title:@"Invite Friends" contentType:SHKURLContentTypeUndefined];
//            [item setMailToRecipients:identifiers];
//            item.text = [NSString stringWithFormat:@"I'm using the %@ app to create and share flyers on the go! Want to give it a try?", APP_NAME];
//            // Share the item with my custom class
//            [SHKMail shareItem:item];
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
    
    [selectedIdentifiers removeAllObjects];
    
    if( selectedTab == CONTACTS_TAB &&  sender.tag != EMAIL_TAB ){
        
        // INVITE BAR BUTTON
        UIButton *inviteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
        [inviteButton addTarget:self action:@selector(invite) forControlEvents:UIControlEventTouchUpInside];
        [inviteButton setBackgroundImage:[UIImage imageNamed:@"invite_friend"] forState:UIControlStateNormal];
        inviteButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:inviteButton];
        [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];
        return;
    }
    
    selectedTab = (int)sender.tag;//CONTACTS_TAB;
    
    [self showLoadingIndicator];
    
    self.selectedIdentifiers = nil;
    self.selectedIdentifiers = [[NSMutableArray alloc] init];
    
    // HERE WE HIGHLIGHT BUTTON SELECT AND
    // UNSELECTED BUTTON
    if(selectedTab == CONTACTS_TAB){
        [emailButton setSelected:NO];
        [contactsButton setSelected:YES];
    }
    if(selectedTab == EMAIL_TAB){
        [emailButton setSelected:YES];
        [contactsButton setSelected:NO];
    }
    
    [twitterButton setSelected:NO];
    [facebookButton setSelected:NO];
    
    
    // init email array
    if( emailBackupArray ){
        
        // Reload table data after all the contacts get loaded
        contactsArray = nil;
        if( selectedTab == CONTACTS_TAB ){
            contactsArray = contactBackupArray;
        } else if( selectedTab == EMAIL_TAB ){
            emailsArray = emailBackupArray;
        }
        
        // Filter contacts on new tab selection
        [self onSearchClick:nil];
        
        [[self uiTableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        [self hideLoadingIndicator];
        
        
    }
    else {
        contactsArray = [[NSMutableArray alloc] init];
        emailsArray = [[NSMutableArray alloc] init];
        searchTextField.text = @"";
        
        ABAddressBookRef m_addressbook = ABAddressBookCreateWithOptions(NULL, NULL);
        
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
    
    ContactsModel *model;
    ContactsModel *modelForEmail;
    
    for (int i=0;i < nPeople;i++) {
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);
        
        //For username and surname
        ABMultiValueRef phones =(__bridge ABMultiValueRef)((NSString*)CFBridgingRelease(ABRecordCopyValue(ref, kABPersonPhoneProperty)));
        ABMultiValueRef emails =(__bridge ABMultiValueRef)((NSString*)CFBridgingRelease(ABRecordCopyValue(ref, kABPersonEmailProperty)));
        CFStringRef firstName, lastName;
        firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        
        if(!firstName)
            firstName = (CFStringRef) @"";
        if(!lastName)
            lastName = (CFStringRef) @"";
        
        // For contact picture
        UIImage *contactPicture;
        
        //For Phone number
        NSString* mobileLabel;
        for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) {
            model = [[ContactsModel alloc] init];
            model.others = @"";
            model.name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
            
            // For Picture
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
            
            mobileLabel = (NSString*)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(phones, i));
            if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel]) {
                model.description = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, i));
                [contactsArray addObject:model];
                
            }else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel]) {
                model.description = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, i));
                [contactsArray addObject:model];
                
            }else if ([mobileLabel isEqualToString:(NSString*)kABHomeLabel]) {
                model.description = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, i));
                [contactsArray addObject:model];
                
            }else if ([mobileLabel isEqualToString:(NSString*)kABWorkLabel]) {
                model.description = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, i));
                [contactsArray addObject:model];
                
            }else {
                model.description = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, i));
                [contactsArray addObject:model];
                
            }
        }
        
        // For Email
        for(CFIndex i = 0; i < ABMultiValueGetCount(emails); i++) {
            modelForEmail = [[ContactsModel alloc] init];
            modelForEmail.others = @"";
            modelForEmail.name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
            
            // For Picture
            if (ref != nil && ABPersonHasImageData(ref)) {
                if ( &ABPersonCopyImageDataWithFormat != nil ) {
                    // iOS >= 4.1
                    contactPicture = [UIImage imageWithData:(NSData *)CFBridgingRelease(ABPersonCopyImageDataWithFormat(ref, kABPersonImageFormatThumbnail))];
                    modelForEmail.img = contactPicture;
                } else {
                    // iOS < 4.1
                    contactPicture = [UIImage imageWithData:(NSData *)CFBridgingRelease(ABPersonCopyImageData(ref))];
                    modelForEmail.img = contactPicture;
                }
            }
            
            modelForEmail.description = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(emails, i));
            [emailsArray addObject:modelForEmail];
        }
    }
    
    // Reload table data after all the contacts get loaded
    contactBackupArray = nil;
    contactBackupArray = contactsArray;
    
    emailBackupArray = nil;
    emailBackupArray = emailsArray;
    
    // Do in the main UI thread.
    dispatch_async( dispatch_get_main_queue(), ^{
        [[self uiTableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        [self hideLoadingIndicator];
    });
    
}



#pragma mark  Facebook Contact

/**
 * Called when facebook  button is selected on screen
 */
- (IBAction)loadFacebookContacts:(UIButton *)sender{
    FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
    content.appLinkURL = [NSURL URLWithString:flyerConfigurator.appLinkURL];
    //optionally set previewImageURL
    content.appInvitePreviewImageURL = [NSURL URLWithString:flyerConfigurator.appInvitePreviewImageURL];

    // present the dialog. Assumes self implements protocol `FBSDKAppInviteDialogDelegate`
    [FBSDKAppInviteDialog showFromViewController:self withContent:content delegate:self];
}


-(void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results {
    NSLog(@"app invite dialog did complete");
}

-(void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error {
    NSLog(@"app invite dialog did fail");
}

-(void) shareViaIOSFacebook:( BOOL ) withAccount {
    //SHKItem *item;
    
    // text to be share.
    NSString *sharingText = [NSString stringWithFormat:@"I'm using the %@ app to create and share flyers on the go! Want to give it a try? %@%@", APP_NAME, flyerConfigurator.referralURL, userUniqueObjectId];;
    
    // app URL with user id.
    NSString *urlToShare = [NSString stringWithFormat:@"%@%@", flyerConfigurator.referralURL, userUniqueObjectId];
    
    //item to be share
    //item = [SHKItem URL:[NSURL URLWithString:urlToShare] title:sharingText contentType:SHKShareTypeURL];
    
    if( withAccount ) {
        // we got a facebook account, share it via shkiOSFacebook
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            iosSharer = [[SHKiOSFacebook alloc] init];
//            [iosSharer loadItem:item];
//            iosSharer.shareDelegate = self;
//            [iosSharer share];
//
//        });
        
    } else {
        //we didn't have facebook app or account, then we have to use legendary SHKFacebook sharer.
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            iosSharer = [[SHKFacebook alloc] init];
//            [iosSharer loadItem:item];
//            iosSharer.shareDelegate = self;
//            [iosSharer share];
//        });
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
//- (void)updateItemWithForm:(SHKFormController *)form
//{
//	// Update item with new values from form
//    NSDictionary *formValues = [form formValues];
//	for(NSString *key in formValues)
//	{
//		
//		if ([key isEqualToString:@"text"]){
//            fbText = [formValues objectForKey:key];
//        }
//    }
//}


#pragma mark  TWITTER CONTACTS

/*
 * HERE WE REQUEST TO TWITTER FOR FRIENDS LIST
 */
- (IBAction)loadTwitterContacts:(UIButton *)sender{
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:twitterAccountType
                                          options:nil
                                       completion:^(BOOL granted, NSError *error) {
    if ( granted ) {
        availableAccounts = [accountStore accountsWithAccountType:twitterAccountType];
        
        if ([availableAccounts count] > 1) {
            
            usernames = [NSMutableArray arrayWithCapacity:[availableAccounts count]];
            
            for (ACAccount *acc in availableAccounts) {
                [usernames addObject:acc.username];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Choose Twitter Account" message:nil delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:nil];
                
                for( NSString* number in usernames )
                    [view addButtonWithTitle:number];
                
                [view show];
            });
            
        } else if ([availableAccounts count] > 0 ) {
            
             dispatch_async(dispatch_get_main_queue(), ^{
                // Just use the single account.
                selectedAccount = [availableAccounts objectAtIndex:0];
                [self afterTwitterSelected:selectedAccount];
             });
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self afterTwitterSelected:nil];
            });
        }
        
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self afterTwitterSelected:nil];
        });
    }
}];
    
}

/**
 After one of twitter account is selected
 **/
-(void)afterTwitterSelected:(ACAccount *)sAccount{
    if ([FlyerlySingleton connected]) {
        
        // HERE WE HIGHLIGHT BUTTON SELECT AND
        // UNSELECTED BUTTON
        [contactsButton setSelected:NO];
        [twitterButton setSelected:YES];
        [facebookButton setSelected:NO];
        [emailButton setSelected:NO];
        
        self.selectedIdentifiers = nil;
        self.selectedIdentifiers = [[NSMutableArray alloc] init];
        
        selectedTab = TWITTER_TAB;
        [self.uiTableView reloadData];
        
        
        if (twitterBackupArray == nil || twitterBackupArray.count == 0) {
            searchTextField.text = @"";
            self.twitterBackupArray = [[NSMutableArray alloc] init];
            
            // Current Item For Sharing
            //here we are not set Any Share Type for Override sendStatus Method of SHKTwitter
//            SHKItem *item = [[SHKItem alloc] init];
//            
//            if( sAccount ) {
//                [item setCustomValue:sAccount forKey:@"selectedAccount"];
//            }
//            
//            // Create controller and set share options
//            iosSharer = [FlyerlyTwitterFriends shareItem:item];
//            
//            iosSharer.shareDelegate = self;
            
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
    
    twitterArray = twitterBackupArray;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [uiTableView reloadData];
        [self hideLoadingIndicator];
    });
}




#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSArray *) getArrayOfSelectedTab{
    if(selectedTab == CONTACTS_TAB)
        return contactsArray;
    else if (selectedTab == EMAIL_TAB)
        return emailsArray;
    else if(selectedTab == FACEBOOK_TAB)
        return facebookArray;
    else
        return twitterArray;
}

-(NSArray *) getBackupArrayOfSelectedTab{
    if(selectedTab == CONTACTS_TAB)
        return contactBackupArray;
    else if (selectedTab == EMAIL_TAB)
        return emailBackupArray;
    else if(selectedTab == FACEBOOK_TAB)
        return facebookBackupArray;
    else
        return twitterBackupArray;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = ((int)[[self getArrayOfSelectedTab] count]);
    NSLog(@"selectedTab = %i , numberOfRowsInSection - count = %i", selectedTab, count );
    return  count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"InviteCell";
    InviteFriendsCell *cell = (InviteFriendsCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    
    if ( cell == nil ) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InviteFriendsCell" owner:self options:nil];
        cell = (InviteFriendsCell *)[nib objectAtIndex:0];
        
        //cell.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        //[cell setFrame:newFrame];
        
        if( IS_IPHONE_5 || IS_IPHONE_4){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InviteFriendsCell" owner:self options:nil];
        cell = (InviteFriendsCell *)[nib objectAtIndex:0];
        } else if ( IS_IPHONE_6 ){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InviteFreindsCell-iPhone6" owner:self options:nil];
            cell = (InviteFriendsCell *)[nib objectAtIndex:0];
        } else if ( IS_IPHONE_6_PLUS ) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InviteFreindsCell-iPhone6-Plus" owner:self options:nil];
            cell = (InviteFriendsCell *)[nib objectAtIndex:0];
        } else {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InviteFriendsCell" owner:self options:nil];
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
        NSLog(@"selectedTab = %i, indexPath.row = %li",selectedTab, (long)indexPath.row);
       
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
    if (selectedTab == 0 || selectedTab == 3) {
        
        ContactsModel *model = [self getArrayOfSelectedTab][(indexPath.row)];
        
        //CHECK FOR ALREADY SELECTED
        if (model.status == 0) {
            [model setInvitedStatus:1];
            [selectedIdentifiers addObject:model.description];
        } else if (model.status == 1) {
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
        
        NSString *hashTag;
        NSString *sharingText;
        #if defined(FLYERLY)
            hashTag  = @"#flyerly";
        #else
            hashTag  = @"#FlyerlyBiz";
        #endif
        
        sharingText = [NSString stringWithFormat:@"I'm using the %@ app to create and share flyers on the go! %@%@", APP_NAME, flyerConfigurator.referralURL, userUniqueObjectId];
        
        ContactsModel *model = [self getArrayOfSelectedTab][(indexPath.row)];
        
        //CHECK FOR ALREADY SELECTED
        if (model.status == 0) {
            [model setInvitedStatus:1];
            
            [selectedIdentifiers addObject:model.description];
            
//            //Calling ShareKit for Sharing
//            iosSharer = [[ SHKiOSTwitter alloc] init];
//            NSString *tweet = [NSString stringWithFormat:@"%@ @%@ %@",sharingText,model.description, hashTag];
//            SHKItem *item;
//            
//            item = [SHKItem text:tweet];
            [selectedIdentifiers addObject:model.description];
//
//            if ( availableAccounts.count > 0 ) {
//                iosSharer = [SHKiOSTwitter shareItem:item];
//            } else {
//                iosSharer = [SHKTwitter shareItem:item];
//            }
//            
//            iosSharer.shareDelegate = self;
        
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
        else if (selectedTab == EMAIL_TAB)
            contactsArray = emailBackupArray;
        
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
    if(selectedTab == EMAIL_TAB)
        emailsArray = filteredArray;
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
    
//	if (!sharer.quiet)
//		[[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Saving to %@", [[sharer class] sharerTitle]) forSharer:sharer];
}

- (void)sharerFinishedSending:(SHKSharer *)sharer
{
    
//    // Here we Get Friend List which sended from FlyerlyFacbookFriends
//    if ( [sharer isKindOfClass:[FlyerlyTwitterFriends class]] == YES ) {
//        
//        FlyerlyTwitterFriends *twitter = (FlyerlyTwitterFriends*) sharer;
//        
//        // HERE WE MAKE ARRAY FOR SHOW DATA IN TABLEVIEW
//        [self makeTwitterArray:twitter.friendsList ];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//           [self.uiTableView reloadData]; 
//        });
//        
//        return;
//    }
    
    PFUser *user = [PFUser currentUser];
    
    // Here we Check Sharer for
    // Update PARSE
//    if ( [sharer isKindOfClass:[SHKiOSTwitter class]] == YES ||
//        [sharer isKindOfClass:[SHKTwitter class]] == YES ) {
//        
//        // HERE WE GET AND SET SELECTED FOLLOWER
//        [twitterInvited  addObjectsFromArray:selectedIdentifiers];
//        //user[@"tweetinvited"] = twitterInvited;
//        [self friendsInvited];
// 
//    } else if ( [sharer isKindOfClass:[SHKTextMessage class]] == YES ) {
//        
//        // HERE WE GET AND SET SELECTED CONTACT LIST
//        [iPhoneinvited  addObjectsFromArray:selectedIdentifiers];
//        //user[@"iphoneinvited"] = iPhoneinvited;
//        [self friendsInvited];
//
//    } else if ([sharer isKindOfClass:[SHKMail class]] == YES){
//        // HERE WE GET AND SET SELECTED EMAIL LIST
//        [emailInvited  addObjectsFromArray:selectedIdentifiers];
//        //user[@"emailinvited"] = emailInvited;
//        [self friendsInvited];
//    }


    // HERE WE UPDATE PARSE ACCOUNT FOR REMEMBER INVITED FRIENDS LIST
    [user saveInBackground];
    
    [self showAlert:@"Invitation Sent!" message:[NSString stringWithFormat:@"You have successfully invited your friends to join %@.", APP_NAME]];
    [selectedIdentifiers   removeAllObjects];
    [self.uiTableView reloadData ];
    
    
//    if (!sharer.quiet)
//		[[SHKActivityIndicator currentIndicator] displayCompleted:SHKLocalizedString(@"Saved!") forSharer:sharer];
}

//- (void)sharer:(SHKSharer *)sharer failedWithError:(NSError *)error shouldRelogin:(BOOL)shouldRelogin
//{
//    
////    [[SHKActivityIndicator currentIndicator] hideForSharer:sharer];
//	NSLog(@"Sharing Error");
//}
//
//- (void)sharerCancelledSending:(SHKSharer *)sharer
//{
//    
//    if ( [sharer isKindOfClass:[SHKiOSTwitter class]] == YES ||
//        [sharer isKindOfClass:[SHKTwitter class]] == YES ) {
//        [selectedIdentifiers   removeAllObjects];
//    }
//
//    [self.uiTableView reloadData ];
//    if (!sharer.quiet)
//        [[SHKActivityIndicator currentIndicator] displayCompleted:SHKLocalizedString(@"Cancelled!") forSharer:sharer];
//    
//}
//
//- (void)sharerShowBadCredentialsAlert:(SHKSharer *)sharer
//{
//    NSString *errorMessage = SHKLocalizedString(@"Sorry, %@ did not accept your credentials. Please try again.", [[sharer class] sharerTitle]);
//    
//    [[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Login Error")
//                                message:errorMessage
//                               delegate:nil
//                      cancelButtonTitle:SHKLocalizedString(@"Close")
//                      otherButtonTitles:nil] show];
//}
//
//- (void)sharerShowOtherAuthorizationErrorAlert:(SHKSharer *)sharer
//{
//    NSString *errorMessage = SHKLocalizedString(@"Sorry, %@ encountered an error. Please try again.", [[sharer class] sharerTitle]);
//    
//    [[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Login Error")
//                                message:errorMessage
//                               delegate:nil
//                      cancelButtonTitle:SHKLocalizedString(@"Close")
//                      otherButtonTitles:nil] show];
//}
//
//- (void)hideActivityIndicatorForSharer:(SHKSharer *)sharer {
//    
//    [[SHKActivityIndicator currentIndicator]  hideForSharer:sharer];
//}
//
//- (void)displayActivity:(NSString *)activityDescription forSharer:(SHKSharer *)sharer {
//    
//    if (sharer.quiet) return;
//    
//    [[SHKActivityIndicator currentIndicator]  displayActivity:activityDescription forSharer:sharer];
//}
//
//- (void)displayCompleted:(NSString *)completionText forSharer:(SHKSharer *)sharer {
//    
//    if (sharer.quiet) return;
//    [[SHKActivityIndicator currentIndicator]  displayCompleted:completionText forSharer:sharer];
//}
//
//- (void)showProgress:(CGFloat)progress forSharer:(SHKSharer *)sharer {
//    
//    if (sharer.quiet) return;
//    [[SHKActivityIndicator currentIndicator]  showProgress:progress forSharer:sharer];
//}

#pragma mark - UI Alert View Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ( buttonIndex != 0 ) {
        
        //reload the table data(i.e followers list)
        self.twitterBackupArray = [[NSMutableArray alloc] init];
        [self.uiTableView reloadData];
        
        selectedAccount = availableAccounts[buttonIndex-1];
        [self afterTwitterSelected:selectedAccount];
        
        NSLog( @"currently selected user for twitter is %@ : ", selectedAccount );
    
    } else {
        //Do nothing then, because cancel is pressed.
    }
}

#pragma mark Flurry Methods

-(void) friendsInvited {
    [Flurry logEvent:@"Friends Invited"];
}

#pragma Ads
-(void) loadInterstitialAdd{
    self.interstitialAds.delegate = nil;
    
    // Create a new GADInterstitial each time. A GADInterstitial will only show one request in its
    // lifetime. The property will release the old one and set the new one.
    self.interstitialAds = [[GADInterstitial alloc] init];
    self.interstitialAds.delegate = self;
    
    // Note: Edit SampleConstants.h to update kSampleAdUnitId with your interstitial ad unit id.
    self.interstitialAds.adUnitID = [flyerConfigurator interstitialAdID];
    
    [self.interstitialAds loadRequest:[self request]];
    
}
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    
    [self loadInterstitialAdd];
    
}

- (GADRequest *)request {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as well as any devices
    // you want to receive test ads.
    request.testDevices = @[
                            // TODO: Add your device/simulator test identifiers here. Your device identifier is printed to
                            // the console when the app is launched.
                            //NSString *udid = [UIDevice currentDevice].uniqueIdentifier;
                            GAD_SIMULATOR_ID
                            ];
    return request;
}

// We've received a Banner ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    
    if ( bannerAdClosed == NO && bannerShowed == NO ) {
        bannerShowed = YES;//keep bolean we have rendered banner or not ?
        self.bannerAdsView.alpha = 1.0;
        self.btnBannerAdsDismiss.alpha = 1.0;
        [self.bannerAdsView addSubview:btnBannerAdsDismiss];
    }
}

// Dismiss action for banner ad
-(void)dismissBannerAds:(BOOL)valForBannerClose{
    
    productIdentifier = BUNDLE_IDENTIFIER_AD_REMOVAL;
    inAppViewController = [[InAppViewController alloc] initWithNibName:@"InAppViewController" bundle:nil];
    inAppViewController.buttondelegate = self;
    [inAppViewController requestProduct];
    [inAppViewController purchaseProductByID:productIdentifier];
}

// Dismiss action for banner ad
-(void)removeBAnnerAdd:(BOOL)valForBannerClose{
    
    self.bannerAdsView.backgroundColor = [UIColor clearColor];
    
    UIView *viewToRemove = [bannerAdsView viewWithTag:999];
    [viewToRemove removeFromSuperview];
    //[bannerAdDismissBtn removeFromSuperview];
    [self.bannerAdsView removeFromSuperview];
    btnBannerAdsDismiss = nil;
    self.bannerAdsView = nil;
    
    bannerAdClosed = valForBannerClose;
}

- (IBAction)onClickBtnBannerAdsDismiss:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissBannerAds:YES];
    });
}
@end
