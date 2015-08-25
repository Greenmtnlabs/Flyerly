//
//  AddUntechableController.h
//  Untechable
//
//  Created by RIKSOF Developer on 23/sep/2014
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"
#import "BSKeyboardControls.h"

@interface AddUntechableController : UIViewController < UITextViewDelegate, BSKeyboardControlsDelegate, UIPickerViewDataSource , UIPickerViewDelegate>
{
    UILabel *titleLabel;
    UIButton *helpButton;
    UIButton *backButton;
    UIButton *settingsButton;
    UIButton *nextButton;
    
    UIButton *openPickerButton;
    NSString *pickerOpenFor;
    NSDate *now1; // current time + 60 min
}

-(void)setDefaultModel;

@property (nonatomic,strong)  Untechable *untechable;

@property int totalUntechables;
@property NSString *callReset;

@end
