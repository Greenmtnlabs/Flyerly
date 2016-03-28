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


-(void)mergeVideos:(NSArray *)aryVideosUrl outputURL:(NSURL *)outputURL width:(int)width height:(int)height completion:(void (^)(NSInteger, NSError *))callback{
    AVMutableComposition *mixComposition = [AVMutableComposition composition];
    AVMutableCompositionTrack *compositionTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    NSError * error = nil;
    NSMutableArray * timeRanges = [NSMutableArray arrayWithCapacity:aryVideosUrl.count];
    NSMutableArray * tracks = [NSMutableArray arrayWithCapacity:aryVideosUrl.count];
    for (int i=0; i<[aryVideosUrl count]; i++) {
        AVURLAsset *assetClip = [AVURLAsset URLAssetWithURL:[aryVideosUrl objectAtIndex:i] options:nil];
        AVAssetTrack *clipVideoTrackB = [[assetClip tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        
        [timeRanges addObject:[NSValue valueWithCMTimeRange:CMTimeRangeMake(kCMTimeZero, assetClip.duration)]];
        [tracks addObject:clipVideoTrackB];
    }
    [compositionTrack insertTimeRanges:timeRanges ofTracks:tracks atTime:kCMTimeZero error:&error];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    NSParameterAssert(exporter != nil);
    NSArray *t;
    NSString *u;
    
    t = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    u = [t objectAtIndex:0];

    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.outputURL = outputURL;
    [exporter exportAsynchronouslyWithCompletionHandler:^(void){
        callback( exporter.status, exporter.error );
    }];
}

@end