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

    UITableView *uiTableView;
    IBOutlet UIView *tableContainer;
	NSMutableArray *contactsArray;
}

@property(nonatomic,retain) UITableView *uiTableView;
@property(nonatomic,retain) IBOutlet UIView *tableContainer;
@property(nonatomic,retain) NSMutableArray *contactsArray;
@end
