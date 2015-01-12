//
//  ESSoundManager.h
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 2/26/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESSoundManager : NSObject

typedef NS_ENUM(NSInteger, ESSoundIdentifier) {
    ESSoundBoardComplete,
    ESSoundSwoosh,
    ESSoundUnswoosh,
    ESSoundTrophyPlaced
};
typedef void (^ESSoundPlaybackCompletionBlock)();

+ (ESSoundManager *) sharedInstance;
- (void)playSound:(ESSoundIdentifier)soundId;
- (void)playSound:(ESSoundIdentifier)soundId withCompletionBlock:(ESSoundPlaybackCompletionBlock)completion;

@end
