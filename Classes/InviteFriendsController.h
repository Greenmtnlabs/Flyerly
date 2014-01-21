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
#import "Reachability.h"
#import "AsyncImageView.h"
#import "FlyerlySingleton.h"
#import "InviteFriendsCell.h"

@class LoadingView,FlyerlySingleton;

@interface InviteFriendsController : UIViewController<UITableViewDelegate,UITableViewDataSource,MFMessageComposeViewControllerDelegate,UITextFieldDelegate, UIActionSheetDelegate>{
    FlyerlySingleton *globle;
    IBOutlet UILabel *contactsLabel;
    IBOutlet UILabel *facebookLabel;
    IBOutlet UILabel *twitterLabel;
    IBOutlet UILabel *doneLabel;
    IBOutlet UILabel *selectAllLabel;
    IBOutlet UILabel *unSelectAllLabel;
    IBOutlet UILabel *inviteLabel;
    IBOutlet UIButton *contactsButton;
    IBOutlet UIButton *facebookButton;
    IBOutlet UIButton *twitterButton;
    IBOutlet UITextField *searchTextField;
	LoadingView *loadingView;
    IBOutlet AsyncImageView *aview;
    IBOutlet UITableView *uiTableView;
	NSMutableArray *contactsArray;
	NSMutableArray *facebookArray;
	NSMutableArray *twitterArray;
    NSMutableArray *fbinvited;

    NSMutableArray *contactBackupArray;
    NSMutableArray *facebookBackupArray;
    NSMutableArray *twitterBackupArray;
    
    NSMutableArray *deviceContactItems;
    int selectedTab;
    int contactsCount;

	BOOL loadingViewFlag;
    BOOL invited;
    NSArray *arrayOfAccounts;
    ACAccount *account;
    NSString *sName;
    NSString *sMessage;
}

@property(nonatomic,strong) IBOutlet UILabel *contactsLabel;
@property(nonatomic,strong) IBOutlet UILabel *facebookLabel;
@property(nonatomic,strong) IBOutlet UILabel *twitterLabel;
@property(nonatomic,strong) IBOutlet UILabel *doneLabel;
@property(nonatomic,strong) IBOutlet UILabel *selectAllLabel;
@property(nonatomic,strong) IBOutlet UILabel *unSelectAllLabel;
@property(nonatomic,strong) IBOutlet UILabel *inviteLabel;
@property(nonatomic,strong) IBOutlet UIButton *contactsButton;
@property(nonatomic,strong) IBOutlet UIButton *facebookButton;
@property(nonatomic,strong) IBOutlet UIButton *twitterButton;
@property(nonatomic,strong) IBOutlet UITextField *searchTextField;
@property (nonatomic, strong) LoadingView *loadingView;

@property(nonatomic,strong) IBOutlet UITableView *uiTableView;
@property(nonatomic,strong) NSMutableArray *contactsArray;
@property(nonatomic,strong) NSMutableArray *facebookArray;
@property(nonatomic,strong) NSMutableArray *twitterArray;

@property(nonatomic,strong) NSMutableArray *contactBackupArray;
@property(nonatomic,strong) NSMutableArray *facebookBackupArray;
@property(nonatomic,strong) NSMutableArray *twitterBackupArray;
@property(nonatomic,strong) NSMutableArray *deviceContactItems;
@property(nonatomic,strong) NSMutableArray *fbinvited;
@property(nonatomic,strong) NSMutableArray *Twitterinvited;
@property(nonatomic,strong) NSMutableArray *iPhoneinvited;

- (IBAction)loadLocalContacts:(UIButton *)sender;
- (IBAction)loadFacebookContacts:(UIButton *)sender;
- (IBAction)loadTwitterContacts:(UIButton *)sender;
- (IBAction)onSearchClick:(UIButton *)sender;
-(IBAction)goBack;
-(IBAction)invite;
-(IBAction)inviteFreind:(id)sender;
-(void)inviteFreindUnselected:(NSString *)tag;


+ (BOOL)connected;
- (BOOL)ckeckExistContact:(NSString *)identifier;
+(NSMutableDictionary *)getSelectedIdentifiersDictionary;
+(void)disableSelectUnSelectFlags;

@end
