//
//  ContactsListControllerViewController.h
//  Untechable
//
//  Created by RIKSOF Developer on 12/23/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>


@interface ContactsListControllerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {

}

@property(nonatomic,strong) NSMutableArray *contactsArray;
@property(nonatomic,strong) NSMutableArray *contactBackupArray;
@property(nonatomic,strong) NSMutableArray *selectedIdentifiers;

@property(nonatomic,strong) IBOutlet UITextField *searchTextField;

@end
