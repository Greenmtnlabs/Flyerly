//
//  HowToScreenOneViewController.h
//  Untechable
//
//  Created by rufi on 03/12/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"

@interface HowToScreenOneViewController : UIViewController

@property (nonatomic,strong)  Untechable *untechable;
- (IBAction)onClickNext:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage1;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage2;

@property (nonatomic,assign) BOOL isComingFromSettings;

@property (strong, nonatomic) IBOutlet UIImageView *imgHowTo;
@end
