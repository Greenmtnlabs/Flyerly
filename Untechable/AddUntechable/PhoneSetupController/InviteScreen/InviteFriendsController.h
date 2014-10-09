//
//  AddFriendsController.h
//  Untechable
//
//  Created by Riksof on 4/15/13, update on 10/10/2014 by Abdul Rauf
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
#import "Untechable.h"


@interface InviteFriendsController : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    
    UILabel *titleLabel;
    //UIButton *helpButton;
    UIButton *backButton;
    //UIButton *nextButton;
    
    UIColor *defGreen;//GREEN
    UIColor *defGray;//GRAY
    
}

@property (nonatomic,strong)  Untechable *untechable;

@property(nonatomic,strong) IBOutlet UIButton *contactsButton;
@property(nonatomic,strong) IBOutlet UITextField *searchTextField;

@property(nonatomic,strong) IBOutlet UITableView *uiTableView;
@property(nonatomic,strong) NSMutableArray *contactsArray;


@property(nonatomic,strong) NSMutableArray *contactBackupArray;

@property(nonatomic,strong) NSMutableDictionary *selectedContacts;
@property(nonatomic,strong) NSMutableArray *iPhoneinvited;





-(IBAction)loadLocalContacts:(UIButton *)sender;
-(IBAction)onSearchClick:(UIButton *)sender;
-(IBAction)goBack;
-(BOOL)ckeckExistContact:(NSString *)identifier;

@end
