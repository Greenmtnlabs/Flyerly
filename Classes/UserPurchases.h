//
//  UserPurchases.h
//  Flyr
//
//  Created by Khurram on 08/05/2014.
//
//

#import <Foundation/Foundation.h>

@protocol UserPurchasesDelegate

- (void) userPurchasesLoaded;


@end

@interface UserPurchases : NSObject

@property(nonatomic, strong)NSMutableDictionary *oldPurchases;
@property (nonatomic, assign) id <UserPurchasesDelegate> delegate;

+ (id) getInstance;
- (void) setUserPurcahsesFromParse;
- (BOOL) checkKeyExistsInPurchases : (NSString *)productId;
- (BOOL) canCreateVideoFlyer;
- (BOOL) haveProduct : (NSString *)productId;
- (BOOL) isSubscriptionValid;
- (BOOL) canShowAd;
@end

