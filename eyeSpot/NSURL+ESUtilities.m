//
//  NSURL+ESUtilities.m
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 3/13/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import "NSURL+ESUtilities.h"

@implementation NSURL (ESUtilities)

- (BOOL)es_isEqualToFileURL:(NSURL *)target {
	NSAssert([self isFileURL], @"receiver must be a fileURL");
	NSAssert([target isFileURL], @"target must be a fileURL");
    
	if ([self isEqual:target]) {
		return YES;
	} else {
		NSError *error = nil;
		id resourceIdentifier1 = nil;
		id resourceIdentifier2 = nil;
        
		if (![self getResourceValue:&resourceIdentifier1 forKey:NSURLFileResourceIdentifierKey error:&error]) {
			@throw [NSException exceptionWithName:@"ResouceUnavailableException" reason:error.localizedDescription userInfo:nil];
		}
        
		if (![target getResourceValue:&resourceIdentifier2 forKey:NSURLFileResourceIdentifierKey error:&error]) {
			@throw [NSException exceptionWithName:@"ResouceUnavailableException" reason:error.localizedDescription userInfo:nil];
		}
        
		return [resourceIdentifier1 isEqual:resourceIdentifier2];
	}
}

- (NSString *)es_pathRelativeToHomeDirectory
{
    NSURL *originalURL = self;
//    NSRange range = [[originalURL lastPathComponent] rangeOfString:@" "];
//    if (range.location != NSNotFound) {
//        NSLog(@"demons lie ahead");
//    }
    NSString *originalURLString = [originalURL absoluteString];
    NSAssert(![originalURLString hasPrefix:NSHomeDirectory()],
             @"+[ESBoard pathRelativeToHomeDirectory:] home directory is not antecedent to url");
    
    NSURL *homeURL = [NSURL fileURLWithPath:NSHomeDirectory() isDirectory:YES];
    NSURL *url = originalURL;
    NSMutableArray *pathComponents = [NSMutableArray array];
    while (![homeURL es_isEqualToFileURL:url]) {
        NSString *component = [url lastPathComponent];
        component = [component stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [pathComponents insertObject:component atIndex:0];
        url = [url URLByDeletingLastPathComponent];
    }
    NSString *path = [pathComponents componentsJoinedByString:@"/"];
    NSURL *reconstructedURL = [NSURL URLWithString:path relativeToURL:homeURL];
    NSAssert([originalURL es_isEqualToFileURL:reconstructedURL],
             @"+[ESBoard pathRelativeToHomeDirectory:] logic error");
    
    return path;
}
@end
