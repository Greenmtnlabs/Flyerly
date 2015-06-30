//
//  SetupGuideFourthView.h
//  Untechable
//
//  Created by RIKSOF Developer on 6/30/15.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"
#import "Common.h"

@interface SetupGuideFourthView : UIViewController <UIAlertViewDelegate>{
    UILabel *titleLabel;
    UIButton *backButton;
    UIButton *nextButton;
    UIColor *defGreen;//GREEN
    UIColor *defGray;//GRAY
}

@property (nonatomic,strong)  Untechable *untechable;


@end
