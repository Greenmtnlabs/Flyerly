//
//  SubNBUCamera.m
//  Flyr
//
//  Created by Khurram on 04/04/2014.
//
//

#import "SubNBUCamera.h"

@interface NBUCameraView ()
- (void)updateCaptureSessionInput;
@end

@implementation SubNBUCamera

/**
 * Override from parent class to add audio to recording.
 */
- (void)updateCaptureSessionInput {
    [super updateCaptureSessionInput];
    
    AVCaptureSession * _captureSession = [self valueForKey:@"_captureSession"];
    
    [_captureSession beginConfiguration];
    
    // Remove previous input
    if ( _audioInput != nil ) {
        [_captureSession removeInput:_audioInput];
    }
    
    // Create a capture input
    NSError *error;
    
    AVCaptureDevice *_audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    
    _audioInput = [AVCaptureDeviceInput deviceInputWithDevice:_audioCaptureDevice
                                                          error:&error];
    if ( error ) {
        NSLog( @"Error creating an AVCaptureDeviceInput for audio: %@", error );
        return;
    }
    
    // Add audio input to session
    if ( [_captureSession canAddInput:_audioInput] ) {
        [_captureSession addInput:_audioInput];
    } else {
        NSLog( @"Unable to add audio to recording." );
    }
    
    [_captureSession commitConfiguration];
}

@end
