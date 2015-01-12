//
//  ESSettings.h
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 2/21/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESSettings : NSObject

@property (nonatomic, assign) BOOL isSoundEnabled;

- (void)registerDefaults;
- (void)clearTrophyRoom;
+ (ESSettings *) sharedInstance;

@end
