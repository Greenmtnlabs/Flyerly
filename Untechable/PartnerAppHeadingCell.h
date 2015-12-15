//
//  PartnerAppHeadingCell.h
//  Untechable
//
//  Created by rufi on 14/12/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartnerAppHeadingCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblHeading;

-(void) setLabelTitle: (NSString *) title;

@end
