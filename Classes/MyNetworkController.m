//
//  MyNetworkController.m
//  iLifeApp
//
//  Created by Krunal on 26/05/09.
//  Copyright 2009 iauro. All rights reserved.
//

#import "MyNetworkController.h"
#import <SystemConfiguration/SystemConfiguration.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

@implementation MyNetworkController

- (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address
{
	if (!IPAddress || ![IPAddress length]) {
		return NO;
	}
	
	memset((char *) address, sizeof(struct sockaddr_in), 0);
	address->sin_family = AF_INET;
	address->sin_len = sizeof(struct sockaddr_in);
	
	int conversionResult = inet_aton([IPAddress UTF8String], &address->sin_addr);
	if (conversionResult == 0) {
		//NSAssert1(conversionResult != 1, @"Failed to convert the IP address string into a sockaddr_in: %@", IPAddress);
		return NO;
	}
	
	return YES;
}

- (NSString *) getIPAddressForHost: (NSString *) theHost
{
	struct hostent *host = gethostbyname([theHost UTF8String]);
	
    if (host == NULL) {
        herror("resolv");
		return NULL;
	}
	
	struct in_addr **list = (struct in_addr **)host->h_addr_list;
	NSString *addressString = @(inet_ntoa(*list[0]));
	return addressString;
}

- (BOOL) hostAvailable: (NSString *) theHost
{
	
	NSString *addressString = [self getIPAddressForHost:theHost];
	if (!addressString) 
	{
		//printf("Error recovering IP address from host name\n");
		return NO;
	}
	
	struct sockaddr_in address;
	BOOL gotAddress = [self addressFromString:addressString address:&address];
	
	if (!gotAddress)
	{
		//printf("Error recovering sockaddr address from %s\n", [addressString UTF8String]);
		return NO;
	}
	
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&address);
	SCNetworkReachabilityFlags flags;
	
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	
	if (!didRetrieveFlags) 
	{
		//printf("Error. Could not recover network reachability flags\n");
		return NO;
	}
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	return isReachable ? YES : NO;;
}

- (BOOL) connectedToNetwork
{
	// Part 1 - Create Internet socket addr of zero
	struct sockaddr_in zeroAddr;
	bzero(&zeroAddr, sizeof(zeroAddr));
	zeroAddr.sin_len = sizeof(zeroAddr);
	zeroAddr.sin_family = AF_INET;
	
	// Part 2- Create target in format need by SCNetwork
	SCNetworkReachabilityRef target = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *) &zeroAddr);
	
	// Part 3 - Get the flags
	SCNetworkReachabilityFlags flags;
	SCNetworkReachabilityGetFlags(target, &flags);
	
	// Part 4 - Create output
	NSString *sNetworkReachable;
	if (flags & kSCNetworkFlagsReachable)
		sNetworkReachable = @"YES";
	else
		sNetworkReachable = @"NO";
	
	NSString *sCellNetwork;
	if (flags & kSCNetworkReachabilityFlagsIsWWAN)
		sCellNetwork = @"YES";
	else
		sCellNetwork = @"NO";
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	//BOOL isEDGE = flags & kSCNetworkReachabilityFlagsIsWWAN;
	if (isReachable && !needsConnection )
	{	
		BOOL netCheckFlag = [self hostAvailable: @"www.google.com"];
		return netCheckFlag;
	}	
	else
		return NO;
	
}
@end
