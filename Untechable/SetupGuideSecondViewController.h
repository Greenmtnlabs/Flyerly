//
//  SetupGuideSecondViewController.h
//  Untechable
//
//  Created by RIKSOF Developer on 6/19/15.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"

@interface SetupGuideSecondViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate>


//Properties
@property (nonatomic,strong)  Untechable *untechable;

@property (weak, nonatomic) IBOutlet UIPickerView *setupSpendingTimeText;

@end
