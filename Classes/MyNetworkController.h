//
//  MyNetworkController.h
//  iLifeApp
//
//  Created by Krunal on 26/05/09.
//  Copyright 2009 iauro. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyNetworkController : NSObject {

}
- (NSString *) getIPAddressForHost: (NSString *) theHost;
- (BOOL) hostAvailable: (NSString *) theHost;
- (BOOL) connectedToNetwork;
- (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address;
@end
