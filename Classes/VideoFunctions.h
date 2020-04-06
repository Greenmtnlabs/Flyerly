//
//  VideoFunctions
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 25/03/2016 By Abdul Rauf
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface VideoFunctions : NSObject {
    CALayer *aLayer;
    CALayer *parentLayer;
    CALayer *videoLayer;
}

-(void)mergeVideos:(NSArray *)aryVideosUrl outputURL:(NSURL *)outputURL width:(int)width height:(int)height completion:(void (^)(NSInteger, NSError *))callback;

@end
