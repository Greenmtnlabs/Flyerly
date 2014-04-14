//
//  SubNBUCamera.m
//  Flyr
//
//  Created by Khurram on 04/04/2014.
//
//

#import "SubNBUCamera.h"

@implementation SubNBUCamera

/**
 * We override the recording to allow us to add support for audio.
 */
- (IBAction)startStopRecording:(id)sender {
    
    [super startStopRecording:nil];
    
#ifndef __i386__
/*
    // If we are going to start recording.
    if ( !self.recording ) {

        // Since capture session is a private variable, this is the only way we can get it.
        AVCaptureSession *_captureSession = [self valueForKey:@"_captureSession"];
        NSError *error;
        
        // Get the audio device
        audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:&error];
        
        // Make sure we can add audio input to this session. If we can do it!
        if ([_captureSession canAddInput:audioInput]) {
            [_captureSession addInput:audioInput];
        }
        [super startStopRecording:nil];
    }else {

        
        AVCaptureMovieFileOutput * _captureMovieOutput =[self valueForKey:@"_captureMovieOutput"];
        [_captureMovieOutput stopRecording];
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError* error = nil;
        [audioSession setActive:NO error: &error];
        NSLog(@"error: %@", error);

    }*/
#endif


    
}


@end
