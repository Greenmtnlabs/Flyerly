//
//  HowToScreenThreeViewController.h
//  Untechable
//
//  Created by rufi on 03/12/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"

@interface HowToScreenThreeViewController : UIViewController

@property (nonatomic,strong)  Untechable *untechable;

- (IBAction)onClickDone:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnDone;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;

@property (nonatomic, assign) BOOL isComingFromThankYou;
@property (strong, nonatomic) IBOutlet UIPageControl *pageView;

@property (nonatomic,assign) BOOL isComingFromSettings;

@end
