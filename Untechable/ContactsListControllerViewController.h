//
//  ContactsListControllerViewController.h
//  Untechable
//
//  Created by RIKSOF Developer on 12/23/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Untechable.h"
#import <AddressBook/AddressBook.h>


@interface ContactsListControllerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {

    UIButton *backButton;
    UIButton *nextButton;
    UIButton *skipButton;
}

@property (nonatomic,strong)  Untechable *untechable;
//Array of all phone contacts
@property(nonatomic,strong) NSMutableArray *contactsArray;
@property(nonatomic,strong) NSMutableArray *contactBackupArray;
@property(nonatomic,strong) NSMutableArray *currentlyEditingContacts;

//This will help us on next, if emails are exist then go to setup email screen
@property(assign) BOOL selectedAnyEmail;

@property(nonatomic,strong) IBOutlet UITextField *searchTextField;
- (void) showEmailSetupScreen : ( BOOL ) calledFromSetupScreen;



@end
