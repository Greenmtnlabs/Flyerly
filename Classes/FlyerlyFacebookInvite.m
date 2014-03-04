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
    
   
    
    [FBRequestConnection startForPostStatusUpdate: self.item.title place:@"144479625584966" tags: self.item.tags completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        
        [self.pendingConnections addObject:connection];
        NSLog(@"New Result: %@", result);
        NSLog(@"Error: %@", error);
        
		if ([self.shareDelegate respondsToSelector:@selector(sharerFinishedSending:)])
            [self.shareDelegate performSelector:@selector(sharerFinishedSending:) withObject:self];
    }];
    
    
}

@end
