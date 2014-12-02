//
//  UntechableTableCell.h
//  Untechable
//
//  Created by RIKSOF Developer on 11/20/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UntechableTableCell : UITableViewCell

@property (nonatomic,strong)IBOutlet UILabel *untechableTitle;
@property (nonatomic,strong)IBOutlet UILabel *untechableStartDate;
@property (nonatomic,strong)IBOutlet UILabel *untechableEndDate;
@property (nonatomic,strong)IBOutlet UILabel *untechableStartTime;
@property (nonatomic,strong)IBOutlet UILabel *untechableEndTime;

@property (nonatomic,strong)IBOutlet UILabel *startHeaderLabel;
@property (nonatomic,strong)IBOutlet UILabel *endHeaderLabel;

-(void)setCellValueswithUntechableTitle :(NSString *)title StartDate:(NSString *)startDate StartTime:(NSString *)startTime EndDate: (NSString *)endDate EndTime:(NSString *)endTime ;

@end
