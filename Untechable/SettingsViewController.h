//
//  SettingsViewController.h
//  Untechable
//
//  Created by Abdul Rauf on 28/01/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"

@interface SettingsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>{
    
    UIColor *defGreen;//GREEN
    UIColor *defGray;//GRAY
    UIButton *backButton;
}

//Properties
@property (nonatomic,strong)  Untechable *untechable;

@end
