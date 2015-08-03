//
//  SettingsViewController.h
//  Untechable
//
//  Created by Abdul Rauf on 28/01/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"
#import "EmailSettingController.h"


@interface SettingsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>{
    
    UIColor *defGreen;//GREEN
    UIColor *defGray;//GRAY
    UIButton *backButton;
    UIButton *nextButton;
}

//Properties
@property (nonatomic,strong)  Untechable *untechable;

@property (nonatomic,strong)  EmailSettingController *emailSettingController;

@property (strong, nonatomic) IBOutlet UITableView *socialNetworksTable;

@end
