//
//  MySHKConfigurator.m
//  Flyr
//
//  Created by Riksof on 27/12/2013.
//
//

#import "CommonFunctions.h"
#import "VideoFunctions.h"

@interface VideoFunctions ()

@end

@implementation VideoFunctions


-(void)mergeVideos:(NSArray *)arrVideoPath outputURL:(NSURL *)outputURL width:(int)width height:(int)height completion:(void (^)(NSInteger, NSError *))callback{

    AVURLAsset *video;
    CGFloat totalDuration;
    totalDuration = 0;     //initialization, keep it 0
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *composedTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    //arrVideoPath contains all video paths
    for (int i = 0; i < [arrVideoPath count]; i++) {
        video = [[AVURLAsset alloc] initWithURL:[arrVideoPath objectAtIndex:i] options:nil];
        
        float curDuration = CMTimeGetSeconds([video duration]);
        totalDuration = totalDuration + curDuration;
        CMTime time1 = CMTimeMakeWithSeconds(totalDuration, 0);
        
        [composedTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, video.duration) ofTrack:[[video tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:time1 error:nil];
        
    }
    

        
        
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetHighestQuality];
    
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.outputURL = outputURL;
    exporter.shouldOptimizeForNetworkUse = YES;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        callback( exporter.status, exporter.error );
        
    }];
    
    
}

@end