 //
//  UntechableClass.m
//  Untechable
//
//  Created by Abdul Rauf on 23/sep/2014
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//
//

#import "Untechable.h"
#import "Common.h"


@implementation Untechable

@synthesize dateFormatter;

//0-Phone permissions vars
@synthesize hasFbPermission, hasTwitterPermission, hasLinkedinPermission;

//1-vars for screen1
@synthesize spendingTimeTxt, startDate, endDate, hasEndDate;

//2-vars for screen2
@synthesize forwardingNumber, emergencyContacts, emergencyNumbers;


-(void)initObj{
    self.hasFbPermission          = NO;
    self.hasTwitterPermission     = NO;
    self.hasLinkedinPermission    = NO;

    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:DATE_FORMATE_1];
    //[self.dateFormatter setDateStyle:NSDateFormatterShortStyle];    // show short-style date format
    //[self.dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
}

-(NSDate *)stringToDate:(NSString *)inputStrFormate dateString:(NSString *)dateString{
        NSLog(@"dateString is %@", dateString);
    NSDateFormatter *dateFormatterTemp = [[NSDateFormatter alloc] init];

    if( [inputStrFormate  isEqual:DATE_FORMATE_1] ){
        dateFormatterTemp.dateFormat = inputStrFormate;

        NSDate *dateFrmString = [dateFormatterTemp dateFromString:dateString];

        NSString *formattedDateString = [dateFormatterTemp stringFromDate:dateFrmString];
        NSLog(@"Date in new format is %@", formattedDateString);
        
        
        return dateFrmString;
    }
    
    return [NSDate date];//default
}
-(void)printNavigation:navigationControllerPointer
{

    // Pop the current view, and push the crop view.
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[navigationControllerPointer viewControllers]];
    NSLog(@"NSMutableArray *viewControllers = %@", viewControllers);
    /*
    [viewControllers removeLastObject];
    [viewControllers removeLastObject];
    [viewControllers addObject:nbuCrop];
    [[self navigationController] setViewControllers:viewControllers animated:YES];
     */
}

-(void)goBack:navigationControllerPointer{
    [navigationControllerPointer popViewControllerAnimated:YES];
    // Remove observers
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

