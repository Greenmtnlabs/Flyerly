//
//  NameAndPhoneCellView.h
//  Untechable
//
//  Created by RIKSOF Developer on 4/21/15.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NameAndPhoneCellView : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *onTouchLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameAndPhoneCellHeader;
- (IBAction)onEditButtonTouch:(id)sender;

@end
