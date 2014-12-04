//
//  ServerAccountDetailsViewCell.h
//  Untechable
//
//  Created by RIKSOF Developer on 12/4/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServerAccountDetailsViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *inputFeild;
@property (weak, nonatomic) IBOutlet UILabel *inputLabel;

-(void)setCellValueswithInputLabel :(NSString *)label FeildPlaceholder:(NSString *)palceHolder;

@end
