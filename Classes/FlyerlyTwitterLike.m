//
//  FlyerlyTwitterLike.m
//  Flyr
//
//  Created by Khurram on 06/03/2014.
//
//

#import "FlyerlyTwitterLike.h"

@interface FlyerlyTwitterLike ()

@end

@implementation FlyerlyTwitterLike

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
    
    //Display Messege here on Success
    [self showAlert:@"Thank you for following us on Twitter!" message:@""];

}


- (void)sendStatus
{
    [self setQuiet:YES];
    
    
    OAMutableURLRequest *oRequest = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1.1/friendships/create.json"]
                                                                    consumer:self.consumer
                                                                       token:self.accessToken
                                                                       realm:nil
                                                           signatureProvider:nil];
	
	[oRequest setHTTPMethod:@"POST"];
    
    OARequestParameter *pageName = [[OARequestParameter alloc] initWithName:@"screen_name"
                                                                         value:@"flyerlyapp"];

    OARequestParameter *statusParam = [[OARequestParameter alloc] initWithName:@"follow"
                                                                         value:@"true"];
    NSArray *params = [NSArray arrayWithObjects:pageName,statusParam, nil];
	[oRequest setParameters:params];
	
	OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:oRequest
                                                                                          delegate:self
                                                                                 didFinishSelector:@selector(sendTicket:didFinishWithData:)
                                                                                   didFailSelector:@selector(sendTicket:didFailWithError:)];
	
	[fetcher start];


}

-(void)showAlert:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


@end
