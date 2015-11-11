//
//  UntechableSingleton.h
//  Untechable
//
//  Created by rufi on 05/11/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface UntechableSingleton : NSObject

@property (nonatomic, strong) NSMutableArray *accounts;
@property (nonatomic, strong) NSString *twitterUser;
@property (nonatomic, strong) NSString *inputValue;
@property (nonatomic, strong) NSString *sharelink;
@property (nonatomic, strong) NSString *flyerName;
@property (nonatomic, strong) NSString *iosVersion;

@property (nonatomic, strong) NSString *appOpenFirstTime;
@property (nonatomic, strong) UIImage *NBUimage;
@property (nonatomic, strong) NSString *gallerComesFromCamera;

+(UntechableSingleton *)RetrieveSingleton;
+ (BOOL)connected;
+ (void)showNotConnectedAlert;

@end
