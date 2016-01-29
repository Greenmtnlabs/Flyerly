//
//  UntechablesList.h
//  Untechable
//
//  Created by RIKSOF Developer on 11/20/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"
#import "Reachability.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Flurry.h"


@interface UntechablesList : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, MFMailComposeViewControllerDelegate> {
    UIButton *btnInvite;
    UIButton *btnHelp;
    UIButton *settingsButton;
    Untechable *untechable;
    Reachability *internetReachable;
    IBOutlet UIButton *btnUntechNow;
    IBOutlet UIButton *btnUntechCustom;
}

@property(nonatomic,strong) IBOutlet UITableView *untechablesTable;

- (IBAction)untechNowClick:(id)sender;
- (IBAction)untechCustomClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIPickerView *timeDurationPicker;
- (IBAction)btnDoneClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *doneButtonView;

- (IBAction)emailComposer;
- (IBAction)goToInvite;

@end
