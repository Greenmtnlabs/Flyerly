//
//  FlyerlyTwitterFriendsViewController.h
//  Flyr
//
//  Created by Khurram on 04/03/2014.
//
//

#import "SHKTwitter.h"
#import <Twitter/Twitter.h>
#import "ShareKit.h"

@interface FlyerlyTwitterFriends : SHKTwitter {

    NSDecimalNumber  *nextCursor;
}

@property (nonatomic,strong)NSMutableDictionary *friendsList;
@end
