//
//  SetupGuideViewController.h
//  Untechable
//
//  Created by RIKSOF Developer on 6/19/15.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"

@interface SetupGuideViewController : UIViewController < UITextViewDelegate >


//Properties
@property (nonatomic,strong)  Untechable *untechable;

@property (weak, nonatomic) IBOutlet UITextView *userNameTextView;
@property (weak, nonatomic) IBOutlet UITextView *userPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *usernameHintText;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberHintText;

@end
