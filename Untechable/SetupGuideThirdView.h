//
//  SetupGuideThirdView.h
//  Untechable
//
//  Created by RIKSOF Developer on 6/22/15.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"
#import "Common.h"

@interface SetupGuideThirdView : UIViewController {
    UILabel *titleLabel;
    UIButton *backButton;
    UIButton *nextButton;
}

//Properties
@property (nonatomic,strong)  Untechable *untechable;
@property (weak, nonatomic) IBOutlet UIView *viewForContacts;

@end
