//
//  ESSettingsViewController.h
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 2/21/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESViewController.h"

@interface ESSettingsViewController : ESViewController

@property (weak, nonatomic) IBOutlet UIButton *soundOnButton;
@property (weak, nonatomic) IBOutlet UIButton *soundOffButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unnecessaryLayoutConstraint1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unnecessaryLayoutConstraint2;

- (IBAction)clearTrophyRoom:(id)sender;
- (IBAction)toggleSound:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)restorePurchases:(id)sender;

@end
