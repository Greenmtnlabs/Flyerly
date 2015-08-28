//
//  ContactCustomizeDetailsControllerViewController.h
//  Untechable
//
//  Created by RIKSOF Developer on 12/26/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"
#import "ContactsListControllerViewController.h"
#import "ContactsCustomizedModal.h"
#import "BSKeyboardControls.h"

@interface ContactCustomizeDetailsControllerViewController : UIViewController <UITableViewDelegate, BSKeyboardControlsDelegate, UITableViewDataSource,UITextViewDelegate> {
    
    UIButton *backButton;
    UIButton *saveButton;    
}

@property (nonatomic,strong)  Untechable *untechable;
@property (nonatomic,strong)  ContactsCustomizedModal *contactModal;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;

- (void) saveSpendingTimeText;
@end
