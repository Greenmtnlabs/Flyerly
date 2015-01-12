//
//  ESSoundManager.m
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 2/26/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "ESSoundManager.h"
#import "ESSettings.h"

@interface ESSoundManager ()
@property (nonatomic, strong) NSDictionary *idFilenameMap, *idSystemSoundIdMap;
@property (nonatomic, strong) NSMutableDictionary *idCompletionHandlerMap;
@property (nonatomic, assign) BOOL allSoundsLoaded;
@end

@implementation ESSoundManager

+ (ESSoundManager *) sharedInstance
{
    static ESSoundManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ESSoundManager alloc] init];
        sharedInstance.idFilenameMap = @{@(ESSoundBoardComplete) : @"board_complete.wav",
                                         @(ESSoundSwoosh) : @"swoosh.wav",
                                         @(ESSoundUnswoosh) : @"unswoosh.wav",
                                         @(ESSoundTrophyPlaced) : @"trophy_placed.wav"};
        [sharedInstance loadSystemSoundIds];
        sharedInstance.idCompletionHandlerMap = [NSMutableDictionary dictionary];
    });
    return sharedInstance;
}

- (void)loadSystemSoundIds
{
    self.allSoundsLoaded = YES;
    NSMutableDictionary *map = [NSMutableDictionary dictionary];
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    
    for (NSNumber *appSoundId in self.idFilenameMap) {
        NSString *fullFilename = self.idFilenameMap[appSoundId];
        NSString *filename = [fullFilename stringByDeletingPathExtension];
        NSString *extension = [fullFilename pathExtension];
        CFURLRef soundFileURLRef = CFBundleCopyResourceURL(mainBundle,
                                                            (__bridge CFStringRef)(filename),
                                                            (__bridge CFStringRef)(extension),
                                                            NULL);
        SystemSoundID systemSoundId;
        OSStatus status = AudioServicesCreateSystemSoundID(soundFileURLRef, &systemSoundId);
        map[appSoundId] = (status == kAudioServicesNoError) ? [NSNumber numberWithUnsignedInt:systemSoundId] : nil;
    }
    self.idSystemSoundIdMap = map;
}

- (void)playSound:(ESSoundIdentifier)soundId
{
    if ([[ESSettings sharedInstance] isSoundEnabled]) {
        NSNumber *systemSoundIdWrapper = self.idSystemSoundIdMap[@(soundId)];
        if (systemSoundIdWrapper != nil) {
            SystemSoundID systemSoundId = [systemSoundIdWrapper unsignedIntValue];
            AudioServicesPlaySystemSound(systemSoundId);
        }
    }
}

- (void)playSound:(ESSoundIdentifier)soundId withCompletionBlock:(ESSoundPlaybackCompletionBlock)completion
{
    if ([[ESSettings sharedInstance] isSoundEnabled]) {
        NSNumber *systemSoundIdWrapper = self.idSystemSoundIdMap[@(soundId)];
        if (systemSoundIdWrapper != nil) {
            SystemSoundID systemSoundId = [systemSoundIdWrapper unsignedIntValue];
            self.idCompletionHandlerMap[systemSoundIdWrapper] = [completion copy];
            AudioServicesAddSystemSoundCompletion(systemSoundId,
                                                  NULL,
                                                  NULL,
                                                  MyAudioServicesSystemSoundCompletionProc,
                                                  NULL);
            AudioServicesPlaySystemSound(systemSoundId);
        }
    }
}

void MyAudioServicesSystemSoundCompletionProc (SystemSoundID  ssID,
                                               void           *clientData)
{
    AudioServicesRemoveSystemSoundCompletion(ssID);
    ESSoundPlaybackCompletionBlock block = [ESSoundManager sharedInstance].idCompletionHandlerMap[@(ssID)];
    if (block != NULL) block();
    [[ESSoundManager sharedInstance].idCompletionHandlerMap removeObjectForKey:@(ssID)];
}

@end
