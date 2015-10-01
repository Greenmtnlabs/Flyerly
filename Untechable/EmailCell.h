//
//  EmailCell.h
//  Untechable
//
//  Created by RIKSOF Developer on 12/26/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EmailCell : UITableViewCell

@property (nonatomic,strong)IBOutlet UILabel *contactEmail;
@property (strong, nonatomic) IBOutlet UIButton *emailButton;

-(void)setCellValues :(NSString *)email;
@end
