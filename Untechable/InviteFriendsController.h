//
//  InviteFriendsController.h
//  Untechable
//
//  Created by rufi on 05/11/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHKSharer.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface InviteFriendsController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, SHKSharerDelegate, FBSDKAppInviteDialogDelegate>


@property (strong, nonatomic) IBOutlet UIButton *btnLocalContactsText;

@property (strong, nonatomic) IBOutlet UIButton *btnFBContacts;

@property (strong, nonatomic) IBOutlet UIButton *btnTwitterContacts;

@property (strong, nonatomic) IBOutlet UIButton *btnLocalContactsEmail;

@property (strong, nonatomic) IBOutlet UITextField *txtSearch;

@property (strong, nonatomic) IBOutlet UITableView *ContactsTableView;


@end





