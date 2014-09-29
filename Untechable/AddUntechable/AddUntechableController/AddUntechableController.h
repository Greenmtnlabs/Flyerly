//
//  AddUntechableController.h
//  Untechable
//
//  Created by Abdul Rauf on 23/sep/2014
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"

@interface AddUntechableController : UIViewController
{
    UILabel *titleLabel;
    UIButton *helpButton;
    UIButton *backButton;
    UIButton *nextButton;
    UIColor *defGreen;//GREEN
    UIColor *defGray;//GRAY
    NSString *pickerOpenFor;
    
    NSDate *now1; //current time + 2mint
    NSDate *now2; //current time + 2hr
    
    Untechable *untechable;
}

-(void)setDefaultModel;

@property (strong, nonatomic) IBOutlet UIButton *btnStartTime;
@property (strong, nonatomic) IBOutlet UIButton *btnEndTime;
@property (strong, nonatomic) IBOutlet UIDatePicker *picker;





@end
