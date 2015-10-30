//
//  TwitterFriends.h
//  Untechable
//
//  Created by rufi on 30/10/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//


#import "SHKTwitter.h"
#import <Twitter/Twitter.h>
#import "ShareKit.h"
#import <Foundation/Foundation.h>

@interface TwitterFriends : SHKTwitter {
    
    NSDecimalNumber  *nextCursor;
}

@property (nonatomic,strong)NSMutableDictionary *friendsList;
@end
