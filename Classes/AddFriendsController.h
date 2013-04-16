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

@interface AddFriendsController : UIViewController<UITableViewDelegate,UITableViewDataSource>{

    IBOutlet UILabel *contactsLabel;
    IBOutlet UILabel *facebookLabel;
    IBOutlet UILabel *twitterLabel;
    IBOutlet UILabel *doneLabel;
    IBOutlet UILabel *selectAllLabel;
    IBOutlet UILabel *unSelectAllLabel;
    IBOutlet UILabel *inviteLabel;

    IBOutlet UITableView *uiTableView;
	NSMutableArray *contactsArray;
    
    NSMutableArray *deviceContactItems;
    int selectedTab;

}

@property(nonatomic,retain) IBOutlet UILabel *contactsLabel;
@property(nonatomic,retain) IBOutlet UILabel *facebookLabel;
@property(nonatomic,retain) IBOutlet UILabel *twitterLabel;
@property(nonatomic,retain) IBOutlet UILabel *doneLabel;
@property(nonatomic,retain) IBOutlet UILabel *selectAllLabel;
@property(nonatomic,retain) IBOutlet UILabel *unSelectAllLabel;
@property(nonatomic,retain) IBOutlet UILabel *inviteLabel;

@property(nonatomic,retain) IBOutlet UITableView *uiTableView;
@property(nonatomic,retain) NSMutableArray *contactsArray;
@property(nonatomic,retain) NSMutableArray *deviceContactItems;

- (IBAction)selectAllCheckBoxes:(UIButton *)sender;
- (IBAction)unSelectAllCheckBoxes:(UIButton *)sender;

@end
