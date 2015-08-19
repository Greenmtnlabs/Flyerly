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
}

+ (SocialNetworksStatusModal*)sharedInstance;

- (void)setEmailAddress:(NSString *)emailAddressString;
- (void)setEmailPassword:(NSString *)emailPasswordString;
- (NSString *)getEmailAddress;
- (NSString *)getEmailPassword;

- (void)loginFacebook:(id)sender Controller:(UIViewController *) Controller;
- (void)loginTwitter:(id)sender Controller:(UIViewController *)Controller;
- (void)loginLinkedIn:(id)sender Controller:(UIViewController *) Controller;

@property (strong, nonatomic) NSString *mSocialStatus, *mFbAuth, *mFbAuthExpiryTs, *mTwitterAuth, *mTwOAuthTokenSecret, *mLinkedinAuth;

@end
