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
    Untechable *untechable;
}

-(void)setDefaultModel;

@property (strong, nonatomic) IBOutlet UIButton *btnStartTime;
@property (strong, nonatomic) IBOutlet UIButton *btnEndTime;
@property (strong, nonatomic) IBOutlet UIDatePicker *picker;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;



@end
