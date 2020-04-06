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
    } else if ( [_captureSession canAddInput:_audioInput] ) {
        // Add audio input to session
        [_captureSession addInput:_audioInput];
    } else {
        NSLog( @"Unable to add audio to recording." );
    }
    
    [_captureSession commitConfiguration];
}

/**
 * Start stop recoding should happen inside configuration block.
 */
- (IBAction)startStopRecording:(id)sender {
    AVCaptureSession * _captureSession = [self valueForKey:@"_captureSession"];
    
    [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    [super startStopRecording:sender];
}

@end
