//
//  ContactCustomizeDetailsControlelrViewController.h
//  Untechable
//
//  Created by RIKSOF Developer on 12/26/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"
#import "ContactsCustomizedModal.h"
#import "BSKeyboardControls.h"

@interface ContactCustomizeDetailsControlelrViewController : UIViewController <UITableViewDelegate, BSKeyboardControlsDelegate, UITableViewDataSource,UITextViewDelegate>
{
    
    UIButton *backButton;
    UIButton *nextButton;
    UIColor *defGreen;//GREEN
    UIColor *defGray;//GRAY
    
}

@property (nonatomic,strong)  Untechable *untechable;

@property (nonatomic,strong)  ContactsCustomizedModal *contactModal;

@end
