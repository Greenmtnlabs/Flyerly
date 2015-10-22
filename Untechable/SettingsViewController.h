//
//  SettingsViewController.h
//  Untechable
//
//  Created by RIKSOF Developer on 28/01/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface SettingsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource, MFMailComposeViewControllerDelegate>{
    UIButton *backButton;
    UIButton *nextButton;
}

//Properties
@property (nonatomic,strong)  Untechable *untechable;

@property (strong, nonatomic) IBOutlet UITableView *socialNetworksTable;
@property (strong, nonatomic) UIAlertView *editNameAlert;
- (IBAction)emailComposer;


@end
