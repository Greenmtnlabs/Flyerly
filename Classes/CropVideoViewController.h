//
//  CropVideoViewController.h
//  Flyr
//
//  Created by Khurram Ali on 21/05/2014.
//
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CropView.h"

@interface CropVideoViewController : UIViewController {
    MPMoviePlayerController     *player;
    CGFloat                     aspectRatio;
    CGFloat                     scaleRatio;
    CGRect                     originalConceptualFrame;
    CGRect                      originalCropFrame;
}

@property CGSize desiredVideoSize;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, copy) void (^onVideoFinished)(NSURL *, CGRect, CGFloat);
@property (nonatomic, copy) void (^onVideoCancel)();
@property BOOL fromCamera;

@property (nonatomic, strong) IBOutlet UIView *playerView;
@property (nonatomic, strong) IBOutlet CropView *cropView;
@property (nonatomic, strong) NSMutableDictionary *giphyDic;

@end
