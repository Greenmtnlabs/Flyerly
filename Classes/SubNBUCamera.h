//
//  SubNBUCamera.h
//  Flyr
//
//  Created by Khurram on 04/04/2014.
//
//

#import "NBUCameraView.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIApplication+NBUAdditions.h"
#import "NSFileManager+NBUAdditions.h"
@interface SubNBUCamera : NBUCameraView <AVCaptureFileOutputRecordingDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>{

 AVCaptureSession * captureSession;
AVCaptureMovieFileOutput * captureMovieOutput;
}

@property (nonatomic, strong)           NSURL * targetMovieFolder;
@end
