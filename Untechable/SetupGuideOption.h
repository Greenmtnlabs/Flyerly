//
//  SetupGuideOption.h
//  Untechable
//
//  Created by RIKSOF Developer on 7/7/15.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetupGuideOption : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
- (IBAction)onTouchSetup:(id)sender;

@end
