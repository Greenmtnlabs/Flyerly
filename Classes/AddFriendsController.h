//
//  AddFriendsController.h
//  Flyr
//
//  Created by Rizwan Ahmad on 4/15/13.
//
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "FBConnect/FBConnect.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <Accounts/ACAccountStore.h>
#import <Accounts/ACAccountType.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface AddFriendsController : UIViewController<UITableViewDelegate,UITableViewDataSource,FBRequestDelegate,FBSessionDelegate,MFMessageComposeViewControllerDelegate>{

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

    IBOutlet UITableView *uiTableView;
	NSMutableArray *contactsArray;
    
    NSMutableArray *deviceContactItems;
    int selectedTab;

    //facebook
    BOOL secondRequest;
    int totalFacebookUserCounts;
    
}

@property(nonatomic,retain) IBOutlet UILabel *contactsLabel;
@property(nonatomic,retain) IBOutlet UILabel *facebookLabel;
@property(nonatomic,retain) IBOutlet UILabel *twitterLabel;
@property(nonatomic,retain) IBOutlet UILabel *doneLabel;
@property(nonatomic,retain) IBOutlet UILabel *selectAllLabel;
@property(nonatomic,retain) IBOutlet UILabel *unSelectAllLabel;
@property(nonatomic,retain) IBOutlet UILabel *inviteLabel;
@property(nonatomic,retain) IBOutlet UIButton *contactsButton;
@property(nonatomic,retain) IBOutlet UIButton *facebookButton;
@property(nonatomic,retain) IBOutlet UIButton *twitterButton;

@property(nonatomic,retain) IBOutlet UITableView *uiTableView;
@property(nonatomic,retain) NSMutableArray *contactsArray;
@property(nonatomic,retain) NSMutableArray *deviceContactItems;

- (IBAction)selectAllCheckBoxes:(UIButton *)sender;
- (IBAction)unSelectAllCheckBoxes:(UIButton *)sender;
- (IBAction)loadLocalContacts:(UIButton *)sender;
- (IBAction)loadFacebookContacts:(UIButton *)sender;
- (IBAction)loadTwitterContacts:(UIButton *)sender;
- (IBAction)invite;

@end
