//
//  ThankyouController.h
//  Untechable
//
//  Created by RIKSOF Developer on 28/10/2014.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"

@interface ThankyouController : UIViewController {
    UILabel *titleLabel;
    UIButton *startNewUntechable;
    UIButton *settingsButton;
    UIButton *editUntechable;
}
//Properties
@property (nonatomic,strong)  Untechable *untechable;


@end
