//
//  UntechableTableCell.m
//  Untechable
//
//  Created by RIKSOF Developer on 11/20/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "UntechableTableCell.h"
#import "Common.h"


@implementation UntechableTableCell
@synthesize untechableTitle,untechableStartDate,untechableEndDate;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setCellValueswithUntechableTitle :(NSString *)title StartDate:(NSString *)startDate EndDate: (NSString *)endDate {
    
    UIColor *defGreen = [UIColor colorWithRed:66.0/255.0 green:247.0/255.0 blue:206.0/255.0 alpha:1.0];//GREEN
    UIColor *defGray = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1.0];//GRAY
    
    untechableTitle.font = [UIFont fontWithName:APP_FONT size:22];
    untechableTitle.text = title;
    untechableStartDate.font = [UIFont fontWithName:APP_FONT size:14];
    untechableStartDate.text = startDate;
    untechableEndDate.font = [UIFont fontWithName:APP_FONT size:14];
    untechableEndDate.text = endDate;
}



@end
