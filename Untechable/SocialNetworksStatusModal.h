//
//  SocialNetworksStatusModal.h
//  Untechable
//
//  Created by Abdul Rauf on 03/02/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonFunctions.h"
#import "Untechable.h"

@interface SocialNetworksStatusModal : NSObject {
    
    CommonFunctions *commonFunctions;
}

+ (SocialNetworksStatusModal*)sharedInstance;

- (void)setFbAuth:(NSString *)fbAuthString;
- (void)setFbAuthExpiryTs:(NSString *)setFbAuthExpiryTsString;
- (NSString *)getFbAuth;
- (NSString *)getFbAuthExpiryTs;

- (void)setTwitterAuth:(NSString *)twitterAuthString;
- (void)setTwitterAuthTokkenSecerate:(NSString *)twitterAuthTokkenSecerate;
- (NSString *)getTwitterAuth;
- (NSString *)getTwitterAuthTokkenSecerate;

- (void)setLinkedInAuth:(NSString *)linkedInAuthString;
- (NSString *)getLinkedInAuth;

- (void)loginFacebook:(id)sender Controller:(UIViewController *) Controller Untechable:(Untechable *)untechable;
- (void)loginTwitter:(id)sender Controller:(UIViewController *)Controller Untechable:(Untechable *)untechable;
- (void)loginLinkedIn:(id)sender Controller:(UIViewController *) Controller Untechable:(Untechable *)untechable;



@property (strong, nonatomic) NSString *socialStatus, *fbAuth, *fbAuthExpiryTs, *twitterAuth, *twOAuthTokenSecret, *linkedinAuth;

@end
