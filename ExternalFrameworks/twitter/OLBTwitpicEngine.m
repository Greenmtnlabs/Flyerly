//
//
//  Created by Krunal on 05/10/09.
//  Copyright 2009 iauro. All rights reserved.
//
#import "OLBTwitpicEngine.h"

#define kTwitpicUploadURL @"https://twitpic.com/api/uploadAndPost"  
#define kTwitpicImageJPEGCompression 0.4  


@implementation OLBTwitpicEngine


- (id)initWithDelegate:(id)theDelegate
{
	if (self = [super init])
	{
		delegate = theDelegate;  
	}
	return self;
}


- (void)uploadingDataWithURLRequest:(NSURLRequest *)urlRequest
{
	NSHTTPURLResponse *urlResponse;
	NSError			  *error;
	NSString		  *responseString;
	NSData			  *responseData;
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];	
	
	[urlRequest retain]; 
	
	urlResponse = nil;  
	responseData = [NSURLConnection sendSynchronousRequest:urlRequest
										 returningResponse:&urlResponse   
													 error:&error];  
	responseString = [[NSString alloc] initWithData:responseData
										   encoding:NSUTF8StringEncoding];

	NSLog(@"Response Code: %d", [urlResponse statusCode]);
	if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300)
	{
		NSLog(@"urlResultString: %@", responseString);

		NSString *match = responseString;  
		NSLog(@"match: %@", @"Success");

		[delegate twitpicEngine:self didUploadImageWithResponse:match]; 
	}
	else
	{
		NSLog(@"Error while uploading, got 400 error back or no response at all: %@", [urlResponse statusCode]);
		[delegate twitpicEngine:self didUploadImageWithResponse:@"Fail"];	}
	
	[pool release];	 
	[responseString release];  
	[urlRequest release];
}


- (BOOL)uploadImageToTwitpic:(UIImage *)image withMessage:(NSString *)theMessage 
					username:(NSString *)username password:(NSString *)password
{
	NSString			*stringBoundary, *contentType, *message, *baseURLString, *urlString;
	NSData				*imageData;
	NSURL				*url;
	NSMutableURLRequest *urlRequest;
	NSMutableData		*postBody;
	
	baseURLString	= kTwitpicUploadURL;
	urlString		= [NSString stringWithFormat:@"%@", baseURLString];  
	url				= [NSURL URLWithString:urlString];
	urlRequest		= [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
	[urlRequest setHTTPMethod:@"POST"];	
	
	message		  = ([theMessage length] > 1) ? theMessage : @"Created by SocialFlyr";
	imageData	  = UIImageJPEGRepresentation(image, kTwitpicImageJPEGCompression);
	
	stringBoundary = [NSString stringWithString:@"0xKhTmLbOuNdArY"];
	contentType    = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", stringBoundary];
	[urlRequest addValue:contentType forHTTPHeaderField:@"Content-Type"]; 
	
	postBody = [NSMutableData data];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"source\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Created by SocialFlyr"] dataUsingEncoding:NSUTF8StringEncoding]];  	
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:username] dataUsingEncoding:NSUTF8StringEncoding]]; 
	
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"password\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:password] dataUsingEncoding:NSUTF8StringEncoding]]; 
	
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"message\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:message] dataUsingEncoding:NSUTF8StringEncoding]];  
	
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"media\"; filename=\"%@\"\r\n", @"_image.jpg" ] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Type: image/jpg\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];  
	[postBody appendData:[[NSString stringWithString:@"Content-Transfer-Encoding: binary\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:imageData];  
	
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[urlRequest setHTTPBody:postBody];
	
    [NSThread detachNewThreadSelector:@selector(uploadingDataWithURLRequest:) toTarget:self withObject:urlRequest];	
	
	return YES;  
}


#pragma mark -
#pragma mark Misc


- (void)dealloc 
{	
    [super dealloc];
}


@end
