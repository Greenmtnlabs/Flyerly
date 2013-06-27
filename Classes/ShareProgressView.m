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

    //NSLog(@"%d", self.tag);
    NSDictionary *itemDetails = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", self.tag], @"tag", nil];
    
    [self removeFromSuperview];
	[[NSNotificationCenter defaultCenter] postNotificationName:CloseShareProgressNotification object:nil userInfo:itemDetails];
	//[[NSNotificationCenter defaultCenter] postNotificationName:CloseShareProgressNotification object:nil];
}

@end
