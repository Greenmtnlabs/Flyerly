//
//  AbstractBlockRequest.h
//  ZACodeBase
//
//  Created by Zealous Amoeba on 9/21/13.
//  www.zealousamoeba.org
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AbstractBlockRequest : NSObject <NSURLConnectionDelegate>

/**
 * The HTTP status code from the latest request made
 */
@property(nonatomic, assign) NSInteger statusCode;

/**
 * Performs a url request on the urlStr location with the given method, calling the edit block before performing the request
 * and finally returning the data in the response block
 */
- (void)getUrlStr:(NSString *)urlStr
      withMethod:(NSString *)method
        withEdit:(void(^) (NSMutableURLRequest *request))edit
     andResponse:(void(^) (NSData *data, NSError *error))response;

/**
 * Performs the given url request returning data in the response block
 */
- (void)performRequest:(NSMutableURLRequest *)request withResponse:(void(^) (NSData *data, NSError *error))response;

/**
 * Cancels the current request
 */
- (void)cancel;

#pragma mark -
#pragma mark Data Methods

/**
 * Given theData the function returns the base 64 encoded string representation
 */
+ (NSString*)base64forData:(NSData*)theData;

#pragma mark -
#pragma mark URL Methods

/**
 * Given an array of url parameters of the form 'str=str' the method returns the url extension string
 */
- (NSString*)urlParameterStringFromParameterArray:(NSArray *)array;

@end
