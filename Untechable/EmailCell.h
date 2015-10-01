//
//  EmailCell.h
//  Untechable
//
//  Created by rufi on 01/10/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmailCell : UITableViewCell

@property (nonatomic,strong)IBOutlet UILabel *contactEmail;
@property (strong, nonatomic) IBOutlet UIButton *emailButton;

-(void)setCellValues :(NSString *)email;

@end
