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


//Array of all contacts (extracted from phonebook)
@property(nonatomic,strong) NSMutableArray *mobileContactsArray;

//The above array (contactsArray) is sorted w.r.t name when searched by name
//but when user removes searching text, we have to fill that array with it
@property(nonatomic,strong) NSMutableArray *mobileContactBackupArray;

//This will help us on next, if emails exist then go to setup email screen
@property(assign) BOOL selectedAnyEmail;
- (void) showEmailSetupScreen : ( BOOL ) calledFromSetupScreen;

@property(nonatomic,strong) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;

-(void)onNext;
@end