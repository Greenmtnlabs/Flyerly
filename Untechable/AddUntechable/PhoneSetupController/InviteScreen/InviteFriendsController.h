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
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "InviteFriendsCell.h"
#import "ContactsModel.h"



@interface InviteFriendsController : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    

}

@property(nonatomic,strong) IBOutlet UIButton *contactsButton;
@property(nonatomic,strong) IBOutlet UITextField *searchTextField;

@property(nonatomic,strong) IBOutlet UITableView *uiTableView;
@property(nonatomic,strong) NSMutableArray *contactsArray;


@property(nonatomic,strong) NSMutableArray *contactBackupArray;
@property(nonatomic,strong) NSMutableArray *selectedIdentifiers;
@property(nonatomic,strong) NSMutableArray *iPhoneinvited;





- (IBAction)loadLocalContacts:(UIButton *)sender;
- (IBAction)onSearchClick:(UIButton *)sender;
-(IBAction)goBack;
-(IBAction)invite;
- (BOOL)ckeckExistContact:(NSString *)identifier;

@end
