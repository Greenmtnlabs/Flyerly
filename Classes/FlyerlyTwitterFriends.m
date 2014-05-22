//
//  FlyerlyTwitterFriendsViewController.m
//  Flyr
//
//  Created by Khurram on 04/03/2014.
//
//

#import "FlyerlyTwitterFriends.h"

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
    
    if([nextCursor compare:[NSDecimalNumber zero]] == NSOrderedSame){

    }else{

        [self performSelector:@selector(sendStatus:) withObject:nextCursor afterDelay:3.0 ];
       // [self sendStatus:nextCursor];
    }
}


- (void)sendStatus
{
    [self setQuiet:YES];

	OAMutableURLRequest *oRequest = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1.1/followers/list.json"]
                                                                    consumer:self.consumer
                                                                       token:self.accessToken
                                                                       realm:nil
                                                           signatureProvider:nil];
	
	[oRequest setHTTPMethod:@"GET"];
    
	OARequestParameter *statusParam = [[OARequestParameter alloc] initWithName:@"count"
                                                                         value:@"20"];
    NSArray *params = [NSArray arrayWithObjects:statusParam, nil];
	[oRequest setParameters:params];
	
	OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:oRequest
                                                                                          delegate:self
                                                                                 didFinishSelector:@selector(sendTicket:didFinishWithData:)
                                                                                   didFailSelector:@selector(sendTicket:didFailWithError:)];
	
	[fetcher start];
}


- (void)sendStatus:(NSDecimalNumber  *)cursor
{
    
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

@end
