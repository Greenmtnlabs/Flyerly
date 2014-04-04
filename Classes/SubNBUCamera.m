//
//  SubNBUCamera.m
//  Flyr
//
//  Created by Khurram on 04/04/2014.
//
//

#import "SubNBUCamera.h"

@implementation SubNBUCamera

@synthesize  targetMovieFolder;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (IBAction)startStopRecording:(id)sender
{
    
    [super startStopRecording:nil];

    /*
    if (!self.recording)
    {
#ifndef __i386__
        if (!captureMovieOutput)
        {
            captureMovieOutput = [AVCaptureMovieFileOutput new];
        }
        
        NSError *error;
        AVCaptureDevice *audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:&error];
        
        if ([captureSession canAddOutput:captureMovieOutput])
        {
            [captureSession addOutput:captureMovieOutput];
            [captureSession addInput:audioInput];
            
        }
        
        if (!targetMovieFolder)
        {
            targetMovieFolder = [UIApplication sharedApplication].documentsDirectory;
        }
        
        NSURL * movieOutputURL = [NSFileManager URLForNewFileAtDirectory:targetMovieFolder
                                                      fileNameWithFormat:@"movie%02d.mov"];
        
        [captureMovieOutput startRecordingToOutputFileURL:movieOutputURL
                                         recordingDelegate:self];

#else
        NBULogInfo(@"No mock video recording on Simulator");
#endif
    }
    else
    {
         [captureMovieOutput stopRecording];
    }

    */
  
}


@end
