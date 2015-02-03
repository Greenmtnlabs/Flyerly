//
//  SocialNetworksStatusModal.h
//  Untechable
//
//  Created by Abdul Rauf on 03/02/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonFunctions.h"

@interface SocialNetworksStatusModal : NSObject {
    
    CommonFunctions *commonFunctions;
}

+ (SocialNetworksStatusModal*)sharedInstance;

- (void)setFbAuth:(NSString *)fbAuthString;
- (void)setFbAuthExpiryTs:(NSString *)setFbAuthExpiryTsString;

- (void)setTwitterAuth:(NSString *)twitterAuthString;
- (void)setTwitterAuthTokkenSecerate:(NSString *)twitterAuthTokkenSecerate;
- (NSString *)getTwitterAuth;
- (NSString *)getTwitterAuthTokkenSecerate;

- (NSString *)getFbAuth;
- (NSString *)getFbAuthExpiryTs;

- (void)loginFacebook:(id)sender Controller:(UIViewController *) Controller;
- (void)loginTwitter:(id)sender Controller:(UIViewController *) Controller;



@property (strong, nonatomic) NSString *socialStatus, *fbAuth, *fbAuthExpiryTs, *twitterAuth, *twOAuthTokenSecret, *linkedinAuth;

@end
