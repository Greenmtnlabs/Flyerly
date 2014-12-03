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
    UIButton *nextButton;
    UIColor *defGreen;//GREEN
    UIColor *defGray;//GRAY
    
}

@property (nonatomic,strong)  Untechable *untechable;
@property(nonatomic,strong) IBOutlet UISegmentedControl *serverSegment;

@end
