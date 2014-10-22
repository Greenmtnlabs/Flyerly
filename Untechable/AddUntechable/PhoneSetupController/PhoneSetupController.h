//
//  PhoneSetupController.h
//  Untechable
//
//  Created by ABDUL RAUF on 24/09/2014.
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "BSKeyboardControls.h"

@interface PhoneSetupController : UIViewController < UITableViewDataSource, UITextFieldDelegate , BSKeyboardControlsDelegate >
{
    UILabel *titleLabel;
    UIButton *helpButton;
    UIButton *backButton;
    UIButton *nextButton;
    
    UIColor *defGreen;//GREEN
    UIColor *defGray;//GRAY

}
//Properties
@property (nonatomic,strong)  Untechable *untechable;

@end
