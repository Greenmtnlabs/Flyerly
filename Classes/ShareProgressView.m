//
//  ShareProgressView.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 5/17/13.
//
//

#import "ShareProgressView.h"

NSString *CloseShareProgressNotification = @"CloseShareProgressNotification";
@implementation ShareProgressView
@synthesize networkIcon, statusIcon, statusText, refreshIcon, cancelIcon;

-(IBAction)cancelPressed:(id)sender{
	[[NSNotificationCenter defaultCenter] postNotificationName:CloseShareProgressNotification object:self];
    [self removeFromSuperview];
}

@end
