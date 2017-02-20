//
//  FlyerlyTwitterFriendsViewController.m
//  Flyr
//
//  Created by Khurram on 04/03/2014.
//
//

#import "FlyerlyTwitterFriends.h"
#import <Accounts/Accounts.h>

@interface FlyerlyTwitterFriends ()

@end

@implementation FlyerlyTwitterFriends


@synthesize friendsList;

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

- (void)sendTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    
    NSError *error = nil;
    NSMutableDictionary *followers =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    
    nextCursor = followers[@"next_cursor"];
    friendsList = followers;
    
    if ([self.shareDelegate respondsToSelector:@selector(sharerFinishedSending:)])
        [self.shareDelegate performSelector:@selector(sharerFinishedSending:) withObject:self];
    
    if([nextCursor compare:[NSDecimalNumber zero]] != NSOrderedSame) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self sendStatus:nextCursor];
        });
    }
}


- (void)sendStatus {
    nextCursor = [NSDecimalNumber decimalNumberWithString:@"-1.0"];
    [self sendStatus:nextCursor];
}


- (void)sendStatus:(NSDecimalNumber  *)cursor {
    [self setQuiet:YES];
    
    ACAccount *account = (ACAccount *)[self.item customValueForKey:@"selectedAccount"];
    
    // Setup the request
   if ( account ) {
        SLRequest *twitterRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/followers/list.json"] parameters:[NSDictionary dictionaryWithObjectsAndKeys:account.username, @"screen_name", [cursor stringValue], @"cursor", nil]];
    
        // This is important! Set the account for the request so we can do an authenticated request. Without this you cannot get the followers for private accounts and Twitter may also return an error if you're doing too many requests
        [twitterRequest setAccount:account];
    
        // Perform the request for Twitter friends
        [twitterRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            if (error) {
                // deal with any errors - keep in mind, though you may receive a valid response that contains an error, so you may want to look at the response and ensure no 'error:' key is present in the dictionary
                [self sendTicket:nil didFailWithError:error];
            } else {
                [self sendTicket:nil didFinishWithData:responseData];
            }
        }];
    } else {
        
        // We need to show the webview if no contacts exists
        OAMutableURLRequest *oRequest = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1.1/followers/list.json"]
                                                                        consumer:self.consumer
                                                                           token:self.accessToken
                                                                           realm:nil
                                                               signatureProvider:nil];
        
        [oRequest setHTTPMethod:@"GET"];
        
        OARequestParameter *statusParam = [[OARequestParameter alloc] initWithName:@"cursor"
                                                                             value:[cursor stringValue]];
        NSArray *params = [NSArray arrayWithObjects:statusParam, nil];
        [oRequest setParameters:params];
        
        
        OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:oRequest
                                                                                              delegate:self
                                                                                     didFinishSelector:@selector(sendTicket:didFinishWithData:)
                                                                                       didFailSelector:@selector(sendTicket:didFailWithError:)];
        
        [fetcher start];
        
    }
}

@end
