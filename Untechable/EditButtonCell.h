//
//  EditButtonCell.h
//  Untechable
//
//  Created by rufi on 22/10/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditButtonCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *btnChangeUntechNowSettings;


-(void)updateUI;
@end
