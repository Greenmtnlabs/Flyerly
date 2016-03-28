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

/**
 * mergeVideos: merge array of videos
 * @params: 
           aryVideosUrl:(NSArray *)aryVideosUrl
 *         outputURL:(NSURL *)outputURL
 */
-(void)mergeVideos:(NSArray *)aryVideosUrl outputURL:(NSURL *)outputURL width:(int)width height:(int)height completion:(void (^)(NSInteger, NSError *))callback{
    
    AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
    
    NSMutableArray *arrayInstruction = [[NSMutableArray alloc] init];
    
    AVMutableVideoCompositionInstruction * MainInstruction =
    [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    
    BOOL haveAudio = NO;
    AVMutableCompositionTrack *audioTrack;
    if ( haveAudio ){
        audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                 preferredTrackID:kCMPersistentTrackID_Invalid];
    }
    
    
    CMTime duration = kCMTimeZero;
    for(int i=0;i< aryVideosUrl.count;i++){
        AVAsset *currentAsset = [AVAsset assetWithURL:aryVideosUrl[i]]; // i take the for loop for geting the asset
        // Current Asset is the asset of the video From the Url Using AVAsset
        AVMutableCompositionTrack *currentTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [currentTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, currentAsset.duration) ofTrack:[[currentAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:duration error:nil];


        if ( haveAudio ){
            [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, currentAsset.duration) ofTrack:[[currentAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:duration error:nil];
        }

        
        
        AVMutableVideoCompositionLayerInstruction *currentAssetLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:currentTrack];
        AVAssetTrack *currentAssetTrack = [[currentAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        UIImageOrientation currentAssetOrientation  = UIImageOrientationUp;
        BOOL  isCurrentAssetPortrait  = NO;
        CGAffineTransform currentTransform = currentAssetTrack.preferredTransform;
        
        if(currentTransform.a == 0 && currentTransform.b == 1.0 && currentTransform.c == -1.0 && currentTransform.d == 0)  {currentAssetOrientation= UIImageOrientationRight; isCurrentAssetPortrait = YES;}
        if(currentTransform.a == 0 && currentTransform.b == -1.0 && currentTransform.c == 1.0 && currentTransform.d == 0)  {currentAssetOrientation =  UIImageOrientationLeft; isCurrentAssetPortrait = YES;}
        if(currentTransform.a == 1.0 && currentTransform.b == 0 && currentTransform.c == 0 && currentTransform.d == 1.0)   {currentAssetOrientation =  UIImageOrientationUp;}
        if(currentTransform.a == -1.0 && currentTransform.b == 0 && currentTransform.c == 0 && currentTransform.d == -1.0) {currentAssetOrientation = UIImageOrientationDown;}

        //create ration using width , height
        CGFloat FirstAssetScaleToFitRatio = width/height;
        if(isCurrentAssetPortrait){
            FirstAssetScaleToFitRatio = height/width;
            CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
            [currentAssetLayerInstruction setTransform:CGAffineTransformConcat(currentAssetTrack.preferredTransform, FirstAssetScaleFactor) atTime:duration];
        }else{
            CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
            [currentAssetLayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(currentAssetTrack.preferredTransform, FirstAssetScaleFactor),CGAffineTransformMakeTranslation(0, 0)) atTime:duration];
        }
        
        duration=CMTimeAdd(duration, currentAsset.duration);
        
        [currentAssetLayerInstruction setOpacity:0.0 atTime:duration];
        [arrayInstruction addObject:currentAssetLayerInstruction];
        
        NSLog(@"%lld", duration.value/duration.timescale);
        
        

        aLayer      = [CALayer layer];
        parentLayer = [CALayer layer];
        videoLayer  = [CALayer layer];
        
        aLayer.frame        = CGRectMake(0, 0, width, height);
        parentLayer.frame   = CGRectMake(0, 0, width, height);
        videoLayer.frame    = CGRectMake(0, 0, width, height);
        
        aLayer.opacity = 1;

        [parentLayer addSublayer:videoLayer];
        [parentLayer addSublayer:aLayer];
    }
    
    MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, duration);
    MainInstruction.layerInstructions = arrayInstruction;
    AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];
    
    MainCompositionInst.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    MainCompositionInst.instructions = [NSArray arrayWithObject:MainInstruction];
    MainCompositionInst.frameDuration = CMTimeMake(1, 30);
    MainCompositionInst.renderSize = CGSizeMake(width, height);
    
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL = outputURL;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.videoComposition = MainCompositionInst;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
         callback( exporter.status, exporter.error );
     }];
}


@end