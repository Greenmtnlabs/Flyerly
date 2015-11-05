//
//  InviteFriendsController.h
//  Untechable
//
//  Created by rufi on 05/11/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteFriendsController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UIButton *btnLocalContactsText;

@property (strong, nonatomic) IBOutlet UIButton *btnFBContacts;

@property (strong, nonatomic) IBOutlet UIButton *btnTwitterContacts;

@property (strong, nonatomic) IBOutlet UIButton *btnLocalContactsEmail;

@property (strong, nonatomic) IBOutlet UITextField *txtSearch;

@property (strong, nonatomic) IBOutlet UITableView *ContactsTableView;


@end





