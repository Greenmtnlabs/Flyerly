//
//  BitlyTwitterOAuthAccount.m
//  BitlyLib
//
//  Created by Tracy Pesin on 7/14/11.
//  Copyright 2011 Betaworks. All rights reserved.
//

#import "BitlyTwitterOAuthAccount.h"
#import "BitlyLibUtil.h"
#import "BitlyDebug.h"

@implementation BitlyTwitterOAuthAccount

@synthesize oauthKey, oauthSecret;
@synthesize username, userID;

NSString * const UserDefaultsKey = @"BitlyTwitterOAuthAccount";

- (void)dealloc {
    [oauthKey release];
    [oauthSecret release];
    [username release];
    [userID release];
    
    [super dealloc];
}

+ (BitlyTwitterOAuthAccount *)accountWithTwitterResponse:(NSString *)twitterResponse {
    
    BitlyTwitterOAuthAccount *account = [[BitlyTwitterOAuthAccount alloc] init];
    if (account) {
        NSDictionary *params = [BitlyLibUtil parseQueryString:twitterResponse];
        account.oauthKey = params[@"oauth_token"];
        account.oauthSecret = params[@"oauth_token_secret"];
        account.username = params[@"screen_name"];
        account.userID = params[@"user_id"];
    }
    
    return [account autorelease];
}

- (BOOL)isValid {
    return (self.oauthKey && self.oauthSecret && self.username && self.userID);
}

- (OAToken *)oauthConsumerToken {
    return [[[OAToken alloc] initWithKey:self.oauthKey secret:oauthSecret] autorelease];
}


- (void)saveToKeychain {
    
    NSDictionary *accountDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       self.oauthKey, @"oauthKey", 
                                       self.oauthSecret, @"oauthSecret", 
                                       self.username, @"username", 
                                       self.userID, @"userID", 
                                       nil];

    
    NSData *accountData = [NSKeyedArchiver archivedDataWithRootObject:accountDictionary];
    
    NSDictionary *keychainQuery = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   kSecClassInternetPassword, kSecClass,
                                   @"twitter.com", kSecAttrServer,
                                   self.username, kSecAttrAccount,
                                   accountData, kSecValueData, 
                                   [NSDate date], (id)kSecAttrModificationDate,
                                   nil];
    
    OSStatus status = noErr;
    
    status = SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
    
    if (status != noErr) {
        BitlyLog(@"Error storing oauth data to keychain: status code %d", status); 
    } else {
        BitlyLog(@"Oauth info stored to keychain");
    }
    
    [accountDictionary release];
    [keychainQuery release];
}

+ (BitlyTwitterOAuthAccount *)savedAccount {
    BitlyTwitterOAuthAccount *account = nil;
    NSDictionary *accountDictionary = nil;
    
    NSDictionary *keychainQuery = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   kSecClassInternetPassword, kSecClass,
                                   @"twitter.com", kSecAttrServer,
                                   (id)kCFBooleanTrue, (id)kSecReturnAttributes,
                                   (id)kCFBooleanTrue, (id)kSecReturnData,
                                   nil];
    
    NSDictionary *result = nil;
    OSStatus status = noErr;
    
    status = SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *) &result);
    
    [keychainQuery release];
    
    if ((status != noErr) && (status != errSecItemNotFound)) {
        BitlyLog(@"ERROR in oauth info keychain lookup: %d", status);
    } else {
        NSData *accountData = kSecValueData;
        accountDictionary = (NSDictionary *) [NSKeyedUnarchiver unarchiveObjectWithData:accountData];
    }
    
    if (accountDictionary) {
        account = [[BitlyTwitterOAuthAccount alloc] init];
        account.oauthKey = accountDictionary[@"oauthKey"];
        account.oauthSecret = accountDictionary[@"oauthSecret"];
        account.username = accountDictionary[@"username"];
        account.userID = accountDictionary[@"userID"];
    }
    return [account autorelease];
}

@end
