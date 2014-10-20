//
//  RecordController.m
//  Untechable
//
//  Created by ABDUL RAUF on 20/10/2014.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "RecordController.h"

@interface RecordController (){
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    NSTimer *recTimer;
    NSTimer *playTimer;
    int i;
}

@end

@implementation RecordController
@synthesize stopButton, playButton, recordPauseButton;

@synthesize recordTimeLabel,playTimeLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    i = 0;
    // Disable Stop/Play button when application launches
    [stopButton setEnabled:NO];
    [playButton setEnabled:NO];
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudioMemo.m4a",
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recordPauseTapped:(id)sender {
    // Stop the audio player before recording
    if (player.playing) {
        [player stop];
    }
    
    if (!recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [recorder record];
        [recordPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        
        [self timerInit:YES callFor:1];
        
    } else {
        
        // Pause recording
        [recorder pause];
        [recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
        
        [self timerInit:NO callFor:1];
    }
    
    [stopButton setEnabled:YES];
    [playButton setEnabled:NO];
}

- (IBAction)stopTapped:(id)sender {
    
    if ( recorder.recording ) {
        [recorder stop];
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:NO error:nil];
        
        [self timerInit:NO callFor:1];
    }
    else if ( player.playing ) {
        [player stop];
        [self timerInit:NO callFor:2];
    }
}

- (IBAction)playTapped:(id)sender {
    if ( !recorder.recording ){
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play];

        [self timerInit:YES callFor:2];
        [stopButton setEnabled:YES];
    }
}
- (void)timerInit :(BOOL) init callFor:(int)callFor{
    
    //Record
    if( callFor == 1 ){
        
        if( init ){
            //this is nstimer to initiate update method
            recTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateRecSlider) userInfo:nil repeats:YES];
            recordTimeLabel.text = @"0:0";
            
        }
        else{
            [recTimer invalidate];
            recTimer = nil;
        }
        
    }
    //Play timer
    else if( callFor == 2 ){

        if( init ){
            //this is nstimer to initiate update method
            playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updatePlaySlider) userInfo:nil repeats:YES];
            playTimeLabel.text = @"0:0";
        }
        else{
            [playTimer invalidate];
            playTimer = nil;
        }
    }
    
}

- (void)updateRecSlider {
    NSLog(@"updateRecSlider counter: %i", i);
    // Update the slider about the music time
    if ( recorder.recording ) {
        
        float minutes = floor(recorder.currentTime/60);
        float seconds = recorder.currentTime - (minutes * 60);
        
        NSString *time = [[NSString alloc]
                          initWithFormat:@"%0.0f.%0.0f",
                          minutes, seconds];
        NSLog(@"recordTimeLabel time: %@", time);
        recordTimeLabel.text = time;
    }
}

- (void)updatePlaySlider {
    NSLog(@"updatePlaySlider counter: %i", i);
    // Update the slider about the music time
    //if ( recorder.recording ) {
        
        float minutes = floor(player.currentTime/60);
        float seconds = player.currentTime - (minutes * 60);
        
        NSString *time = [[NSString alloc]
                          initWithFormat:@"%0.0f.%0.0f",
                          minutes, seconds];
        NSLog(@"player time: %@", time);
        playTimeLabel.text = time;
    //}
}


#pragma mark - AVAudioRecorderDelegate

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    [recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
    //[stopButton setEnabled:NO];
    [playButton setEnabled:YES];
}

#pragma mark - AVAudioPlayerDelegate

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
                                                    message: @"Finish playing the recording!"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
     */
    
    [self timerInit:NO callFor:2];
    [stopButton setEnabled:YES];
    
}


@end