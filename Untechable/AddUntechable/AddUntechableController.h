//
//  AddUntechableController.h
//  Untechable
//
//  Created by Muhammad Raheel on 24/09/2014.
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddUntechableController : UIViewController
{
    
}

@property (strong, nonatomic) IBOutlet UIButton *btnStartTime;
@property (strong, nonatomic) IBOutlet UIButton *btnEndTime;
@property (strong, nonatomic) IBOutlet UIDatePicker *picker;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end
