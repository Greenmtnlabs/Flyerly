//
//  FlyerlyFacebookInvite.m
//  Flyr
//
//  Created by Khurram on 04/03/2014.
//
//

#import "FlyerlyFacebookInvite.h"


@interface FlyerlyFacebookInvite ()

@end

@implementation FlyerlyFacebookInvite



#pragma mark  SHAREKIT OVERRIDE METHODS




+ (BOOL)canShareItem:(SHKItem *)item
{
    return YES ;
}


- (BOOL)shouldShareSilently {
    
    return YES;
}

- (BOOL)validateItem
{
    return YES;
}


- (void)doSend {
    
    [self setQuiet:YES];
    
    FBRequestConnection *con = [FBRequestConnection startForPostStatusUpdate: self.item.text place:@"500819963306066" tags: self.item.tags completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        //NSLog(@"New Result: %@", result);
        NSLog(@"Error: %@", error);
        
		if ([self.shareDelegate respondsToSelector:@selector(sharerFinishedSending:)])
            [self.shareDelegate performSelector:@selector(sharerFinishedSending:) withObject:self];
    }];
    
   // [self.pendingConnections addObject:con];
  
    
}

@end
