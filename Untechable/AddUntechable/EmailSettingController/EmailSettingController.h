//
//  EmailSettingController.h
//  Untechable
//
//  Created by ABDUL RAUF on 30/09/2014.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"
#import "BSKeyboardControls.h"
#import "EmailTableViewCell.h"

@class EmailTableViewCell;


@interface EmailSettingController :UIViewController <UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate , BSKeyboardControlsDelegate >
{
    UILabel *titleLabel;
    UIButton *helpButton;
    UIButton *backButton;
    UIButton *skipButton;
    UIButton *rightBarButton;
    UIColor *defGreen;//GREEN
    UIColor *defGray;//GRAY
    
}

//INCOMING MAIL SERVER
@property (weak, nonatomic) IBOutlet UITextField *imsHostName;// <  mail.thecreativeblink.com >
@property (weak, nonatomic) IBOutlet UITextField *imsPort;// 143
//OUTGOING MAIL SERVER
@property (weak, nonatomic) IBOutlet UITextField *omsHostName;// <  mail.thecreativeblink.com >
@property (weak, nonatomic) IBOutlet UITextField *omsPort;// 25
@property (weak, nonatomic) IBOutlet UITableView *serverAccountTable;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,strong)  Untechable *untechable;
@property (weak, nonatomic) IBOutlet UISwitch *sslSwitch;

//Check if coming from settings screen
@property (nonatomic, assign) BOOL comingFromSettingsScreen;

//Check if coming from change email screen
@property (nonatomic, assign) BOOL comingFromChangeEmailScreen;

//Check if coming from contacstListScreen screen
@property (nonatomic, assign) BOOL comingFromContactsListScreen;

//Check if coming from contacstListScreen screen
@property (nonatomic, assign) BOOL comingFromSetupScreen;

@end
