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
    
   
    NSLog(@"asdasda");
    NSError *error = nil;
    NSMutableDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    /*
    // Build a twitter request
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
   // params[@"cursor"] = nil ;//cursor;
    
    params[@"user_id"] = [parsedData objectForKey:@"id"];
    
    TWRequest *getRequest = [[TWRequest alloc] initWithURL:
                             [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1.1/followers/list.json"]]
                                                parameters:params requestMethod:TWRequestMethodGET];
    
    // Post the request
    //[getRequest setAccount:acct];
    
    // Block handler to manage the response
    [getRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        NSError *jsonError = nil;
        NSDecimalNumber *nextCursor;
        
        if(responseData){
            
            NSDictionary *followers =  [NSJSONSerialization JSONObjectWithData:responseData
                                                                       options:NSJSONReadingMutableLeaves
                                                                         error:&jsonError];
        }
    }];
*/
}


- (void)sendStatus
{
    
    NSLog(@"");
  
    //[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1.1/followers/list.json"]
	OAMutableURLRequest *oRequest = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@""]
                                                                    consumer:consumer
                                                                       token:accessToken
                                                                       realm:nil
                                                           signatureProvider:nil];
	
	[oRequest setHTTPMethod:@"POST"];
	
	OARequestParameter *statusParam = [[OARequestParameter alloc] initWithName:@"status"
                                                                         value:[self.item customValueForKey:@"status"]];
    NSArray *params = [NSArray arrayWithObjects:statusParam, nil];
	[oRequest setParameters:params];
	
	OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:oRequest
                                                                                          delegate:self
                                                                                 didFinishSelector:@selector(sendTicket:didFinishWithData:)
                                                                                   didFailSelector:@selector(sendTicket:didFailWithError:)];
	
	[fetcher start];
}

@end
