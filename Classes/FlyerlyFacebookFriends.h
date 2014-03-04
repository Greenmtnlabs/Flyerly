//
//  fbSubClass.h
//  Flyr
//
//  Created by Khurram on 25/02/2014.
//
//

#import "SHKFacebook.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FBSession.h"

@class FBSession;
@interface FlyerlyFacebookFriends : SHKFacebook


@property (nonatomic,strong)NSDictionary *friendsList;
@end
