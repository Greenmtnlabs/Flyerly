//
//  AddFriendsController.h
//  Flyr
//
//  Created by Riksof on 4/15/13.
//
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <Accounts/ACAccountStore.h>
#import <Accounts/ACAccountType.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "FlyrAppDelegate.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "AsyncImageView.h"
#import "FlyerlySingleton.h"
#import "InviteFriendsCell.h"
#import "ParentViewController.h"
#import "SHKSharer.h"
#import <SHKFormController.h>
#import "SHKFacebookCommon.h"
#import "ContactsModel.h"
#import "FlyerlyTwitterFriends.h"
#import "Flurry.h"
#import "SHKSharerDelegate.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@class FlyerlySingleton,SHKSharer;

@interface InviteFriendsController : ParentViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, SHKSharerDelegate, FBSDKAppInviteDialogDelegate>{
    
    
    FlyerlySingleton *globle;
    IBOutlet AsyncImageView *aview;
    
    int selectedTab;
    ACAccount *account;    
    SHKSharer *iosSharer;
}

@property(nonatomic,strong) IBOutlet UILabel *refrelText;

@property(nonatomic,strong) IBOutlet UIButton *contactsButton;
@property(nonatomic,strong) IBOutlet UIButton *facebookButton;
@property(nonatomic,strong) IBOutlet UIButton *twitterButton;
@property(nonatomic,strong) IBOutlet UITextField *searchTextField;

@property(nonatomic,strong) IBOutlet UITableView *uiTableView;
@property(nonatomic,strong) NSMutableArray *contactsArray;
@property(nonatomic,strong) NSMutableArray *facebookArray;
@property(nonatomic,strong) NSMutableArray *twitterArray;

@property(nonatomic,strong) NSMutableArray *contactBackupArray;
@property(nonatomic,strong) NSMutableArray *facebookBackupArray;
@property(nonatomic,strong) NSMutableArray *twitterBackupArray;
@property(nonatomic,strong) NSMutableArray *selectedIdentifiers;
@property(nonatomic,strong) NSMutableArray *fbinvited;
@property(nonatomic,strong) NSMutableArray *twitterInvited;
@property(nonatomic,strong) NSMutableArray *iPhoneinvited;

@property(nonatomic,strong)NSString  *fbText;
- (void)fbSend;
- (void)fbCancel;


- (IBAction)loadLocalContacts:(UIButton *)sender;
- (IBAction)loadFacebookContacts:(UIButton *)sender;
- (IBAction)loadTwitterContacts:(UIButton *)sender;
- (IBAction)onSearchClick:(UIButton *)sender;
-(IBAction)goBack;
-(IBAction)invite;
- (BOOL)ckeckExistContact:(NSString *)identifier;

-(void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results;
-(void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error;

@end