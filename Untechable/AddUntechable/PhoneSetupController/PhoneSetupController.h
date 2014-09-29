//
//  PhoneSetupController.h
//  Untechable
//
//  Created by Muhammad Raheel on 24/09/2014.
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"


@interface PhoneSetupController : UIViewController < UITableViewDataSource >
{
    UILabel *titleLabel;
    UIButton *helpButton;
    UIButton *backButton;
    UIButton *nextButton;
    UIColor *defColor;//GREEN
    UIColor *defColor2;//GRAY

}
//Properties
@property (strong, nonatomic) NSString *startDate;
@property (nonatomic,strong)  Untechable *untechable;

@property (strong, nonatomic) IBOutlet UIButton *btnforwardingNumber;



@end
