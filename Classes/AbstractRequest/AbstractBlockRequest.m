//
//  AbstractBlockRequest.m
//  ZACodeBase
//
//  Created by Zealous Amoeba on 9/21/13.
//  www.zealousamoeba.org
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import "AbstractBlockRequest.h"

typedef void (^ResponseCallback)(NSData *data, NSError *error);

@interface AbstractBlockRequest()

@property(nonatomic, strong) NSMutableData *requestData;
@property(nonatomic, strong) ResponseCallback callback;
@property(nonatomic, strong) NSMutableURLRequest *request;
@property(nonatomic, strong) NSURLConnection *connection;

@end

@implementation AbstractBlockRequest

- (void)getUrlStr:(NSString *)urlStr
       withMethod:(NSString *)method
         withEdit:(void(^) (NSMutableURLRequest *request))edit
      andResponse:(void(^) (NSData *data, NSError *error))response
{
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSLog(@"(%@) %@",method,urlStr);
    
    self.request = [[NSMutableURLRequest alloc] init];
    self.request.URL = URL;
    self.request.HTTPMethod = method;
    self.request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    self.request.timeoutInterval = 60;
    
    edit(self.request);
    
    self.callback = response;
    self.requestData = [NSMutableData data];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self];
    [self.connection start];
    
}

- (void)performRequest:(NSMutableURLRequest *)request withResponse:(void(^) (NSData *data, NSError *error))response
{
    self.request = request;
    self.request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    self.request.timeoutInterval = 60;
    
    self.callback = response;
    self.requestData = [NSMutableData data];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self];
    [self.connection start];
}

- (void)cancel
{
    [self.connection cancel];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark -
#pragma mark NSURL Connection Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"HTTP Response Code: %li",(long)[(NSHTTPURLResponse*)response statusCode]);
    self.statusCode = [(NSHTTPURLResponse*)response statusCode];
    
    self.requestData = [NSMutableData data];
    self.requestData.length = 0;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.requestData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@",error);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.callback(self.requestData,error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //NSLog(@"Response: %@",[[NSString alloc] initWithData:self.requestData encoding:NSUTF8StringEncoding]);
    self.callback(self.requestData,NULL);
}


#pragma mark -
#pragma mark Data Methods

//Source - http://stackoverflow.com/questions/6006823/how-to-get-base64-nsstring-from-nsdata
+ (NSString *)base64forData:(NSData *)theData
{
    const uint8_t *input = (const uint8_t *)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t *output = (uint8_t *)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3)
    {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++)
        {
            value <<= 8;
            
            if (j < length)
            {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

#pragma mark -
#pragma mark URL Methods

- (NSString *)urlParameterStringFromParameterArray:(NSArray *)array
{
    if([array count] < 1)
        return @"";
    else if([array count] == 1)
        return [NSString stringWithFormat:@"?%@",array[0]];
    else
        return [NSString stringWithFormat:@"?%@",[array componentsJoinedByString:@"&"]];
}


@end
