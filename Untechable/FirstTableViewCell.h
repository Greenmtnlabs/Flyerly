//
//  FirstTableViewCell.h
//  Untechable
//
//  Created by RIKSOF Developer on 12/26/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstTableViewCell : UITableViewCell

@property (nonatomic,strong)IBOutlet UILabel *contactName;
@property (nonatomic,strong)IBOutlet UIImageView *contactImage;

-(void)setCellValues :(NSString *)contactName;

@end
