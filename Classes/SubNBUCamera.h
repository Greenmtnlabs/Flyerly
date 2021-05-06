//
//  SubNBUCamera.h
//  Flyr
//
//  Created by Khurram on 04/04/2014.
//
//

#import "NBUCameraView.h"
#import <AVFoundation/AVFoundation.h>

@interface SubNBUCamera : NBUCameraView {
    AVCaptureDeviceInput *_audioInput;
}

@end
