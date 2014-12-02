//
//  AddUntechableController.h
//  Untechable
//
//  Created by Abdul Rauf on 23/sep/2014
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"
#import "BSKeyboardControls.h"

@interface AddUntechableController : UIViewController < BSKeyboardControlsDelegate >
{
    UILabel *titleLabel;
    UIButton *helpButton;
    UIButton *backButton;
    UIButton *nextButton;
    UIColor *defGreen;//GREEN
    UIColor *defGray;//GRAY
    NSString *pickerOpenFor;
    
    NSDate *now1; //current time +60mint
    
    Untechable *untechable;
}

-(void)setDefaultModel;

@property int indexOfUntechableInEditMode;

@end
