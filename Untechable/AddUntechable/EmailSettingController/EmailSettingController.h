//
//  EmailSettingController.h
//  Untechable
//
//  Created by Muhammad Raheel on 30/09/2014.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"

@interface EmailSettingController : UIViewController < UITextFieldDelegate >
{
    UILabel *titleLabel;
    UIButton *helpButton;
    UIButton *backButton;
    UIButton *nextButton;
    UIColor *defGreen;//GREEN
    UIColor *defGray;//GRAY
    
}
@property (nonatomic,strong)  Untechable *untechable;
@end
