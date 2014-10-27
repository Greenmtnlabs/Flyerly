//
//  RecordController.m
//  Untechable
//
//  Created by ABDUL RAUF on 20/10/2014.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "RecordController.h"
#import "Common.h"
#import "SocialnetworkController.h"


@interface RecordController (){
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    NSTimer *recTimer;
    NSTimer *playTimer;
    int timerI;
    NSString *recFilePath;
    NSURL *outputFileURL;
    BOOL configuredRecorder, configuredPlayer;
}

@end

@implementation RecordController

@synthesize untechable;

@synthesize stopButton, playButton, recordPauseButton;

@synthesize recordTimeLabel,playTimeLabel,progressBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationDefaults];
    [self setNavigation:@"viewDidLoad"];
    
	
    timerI = 0;
    configuredRecorder = NO;
    configuredPlayer = NO;
    
    // Disable Stop/Play button when application launches
    [stopButton setEnabled:NO];
    [playButton setEnabled:NO];
    
    recFilePath = [untechable getRecFilePath];
    outputFileURL = [NSURL URLWithString:recFilePath];
    
    //[self playTapped];
    
    [self configuredPlayerFn];
    
   // NSLog(@"player.duration: %f",player.duration);
    
    if( player.duration > 0.0 ){
        [playButton setEnabled:YES];
        [self updateLableOf:@"playTimeLabelOfRecorded"];
    }
    else{
        [self configureRecorder];
    }
    
}
-(void)viewWillAppear:(BOOL)animated {
    [self updateUI];
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
        
        
    }
}

- (IBAction)stopTapped:(id)sender {
    [self stopRec];
}

-(void)stopRec{
    
    if ( recTimer != nil ) {
        [recorder stop];
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:NO error:nil];
        
        untechable.hasRecording = YES;
        [self timerInit:NO callFor:1];
    }
    
    if ( playTimer != nil ) {
        [player stop];
        [self timerInit:NO callFor:2];
    }

}

-(void) stopAllTask
{
    [self stopRec];
    /*
     [player stop];
     [recorder stop];
     [self timerInit:NO callFor:1];
     [self timerInit:NO callFor:2];
     */
}

- (IBAction)playTapped:(id)sender {
    [self playTapped];
}
-(void)playTapped
{
    if ( !recorder.recording || player.duration > 0.0 ) {
        BOOL configured = NO;
        if( [playTimeLabel.text isEqualToString:@"00:00"] ){
            //WE MUST NEED CONFIGURED FOR PLAY EVERY TIME, BECAUSE FILE ALWAYS UPDATING ON NEW RECORDING
            if( [self configuredPlayerFn] ) {
                configured = YES;
            }
        }
        else {
            configured = YES;
        }
        
        if( configured ) {
            [player play];
            [self timerInit:YES callFor:2];
        }
    
    
    }
}


- (void)timerInit :(BOOL) init callFor:(int)callFor{
    
    //Record
    if( callFor == 1 ){
        
        if( init ){
            //this is nstimer to initiate update method
            recTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateRecSlider) userInfo:nil repeats:YES];
            recordTimeLabel.text = @"00:00";
            
            [stopButton setEnabled:YES];
            [playButton setEnabled:NO];
            
        }
        else{
            [recTimer invalidate];
            recTimer = nil;
            timerI = 0;
            
            [stopButton setEnabled:NO];
            [playButton setEnabled:YES];
        }
        
    }
    //Play timer
    else if( callFor == 2 ){

        if( init ){
            //this is nstimer to initiate update method
            playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updatePlaySlider) userInfo:nil repeats:YES];
            playTimeLabel.text = @"00:00";
            
            [stopButton setEnabled:YES];
            [playButton setEnabled:NO];

        }
        else{
            [playTimer invalidate];
            playTimer = nil;
            timerI = 0;
            
            [stopButton setEnabled:NO];
            [playButton setEnabled:YES];
        }
    }
    
}

- (void)updateRecSlider {
    NSLog(@"updateRecSlider counter: %i", timerI++);
    // Update the slider about the music time
    if ( recorder.recording ) {
        [self updateLableOf:@"recordTimeLabel"];
    }
}

-(void)updateLableOf:(NSString *)labelOf
{
    
    if( [labelOf isEqualToString:@"recordTimeLabel"] ) {
        float minutes = floor(recorder.currentTime/60);
        float seconds = recorder.currentTime - (minutes * 60);
        
        NSString *time = [[NSString alloc]
                          initWithFormat:@"%02.0f:%02.0f",
                          minutes, seconds];
        NSLog(@"recordTimeLabel time: %@", time);
        recordTimeLabel.text = time;
        
        [self updateSlider:1 seconds:seconds];
        
        if( seconds >= RECORDING_LIMIT_IN_SEC ){
            [self stopRec];
        }
    }
    else if( [labelOf isEqualToString:@"playTimeLabel"] ) {
        float minutes = floor(player.currentTime/60);
        float seconds = player.currentTime - (minutes * 60);
        
        NSString *time = [[NSString alloc]
                          initWithFormat:@"%02.0f:%02.0f",
                          minutes, seconds];
        NSLog(@"player time: %@", time);
        playTimeLabel.text = time;
        
        [self updateSlider:2 seconds:seconds];
    }
    else if( [labelOf isEqualToString:@"playTimeLabelOfRecorded"] ) {
        float minutes = floor(player.duration/60);
        float seconds = player.duration - (minutes * 60);
        
        NSString *time = [[NSString alloc]
                          initWithFormat:@"%02.0f:%02.0f",
                          minutes, seconds];
        NSLog(@"player time: %@", time);
        recordTimeLabel.text = time;
        
        [self updateSlider:2 seconds:0.0];
    }
}

- (void)updatePlaySlider {
    NSLog(@"updatePlaySlider counter: %i", timerI++);
    // Update the slider about the music time
    //if ( recorder.recording ) {
        [self updateLableOf:@"playTimeLabel"];
    //}
}

-(void)updateSlider:(int)callFor seconds:(float)seconds {
    //1 //rec
    //2 play
    
    float progIn1Percentage;
    
    //if( callFor == 1 )
    progIn1Percentage = (seconds/RECORDING_LIMIT_IN_SEC);
    //else
    //progIn1Percentage = (seconds/player.duration);
    
    progressBar.progress = progIn1Percentage;
    
    
}

-(void)endRec{
    [recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
    [self timerInit:NO callFor:1];
}

#pragma mark - AVAudioRecorderDelegate
- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    [self endRec];
}



#pragma mark - AVAudioPlayerDelegate

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self timerInit:NO callFor:2];
}

#pragma mark -  Navigation functions

- (void)setNavigationDefaults{
    
    defGreen = [UIColor colorWithRed:66.0/255.0 green:247.0/255.0 blue:206.0/255.0 alpha:1.0];//GREEN
    defGray = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1.0];//GRAY
    
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES]; //show navigation bar
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}


-(void)setNavigation:(NSString *)callFrom
{
    if([callFrom isEqualToString:@"viewDidLoad"])
    {
        
        
        // Left Navigation ___________________________________________________________
        backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        backButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_LEFT_SIZE];
        [backButton setTitle:TITLE_BACK_TXT forState:normal];
        [backButton setTitleColor:defGray forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(btnBackTouchStart) forControlEvents:UIControlEventTouchDown];
        [backButton addTarget:self action:@selector(btnBackTouchEnd) forControlEvents:UIControlEventTouchUpInside];
        
        
        backButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        NSMutableArray  *leftNavItems  = [NSMutableArray arrayWithObjects:leftBarButton,nil];
        
        [self.navigationItem setLeftBarButtonItems:leftNavItems]; //Left button ___________
        
        
        // Center title ________________________________________
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_FONT_SIZE];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = defGreen;
        titleLabel.text = APP_NAME;
        
        
        self.navigationItem.titleView = titleLabel; //Center title ___________
        
        
        // Right Navigation ________________________________________
        nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        [nextButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
        nextButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [nextButton setTitle:TITLE_NEXT_TXT forState:normal];
        [nextButton setTitleColor:defGray forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(btnNextTouchStart) forControlEvents:UIControlEventTouchDown];
        [nextButton addTarget:self action:@selector(btnNextTouchEnd) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        nextButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton,nil];
        
        [self.navigationItem setRightBarButtonItems:rightNavItems];//Right buttons ___________
        
        
    }
}


-(void)btnNextTouchStart{
    [self setNextHighlighted:YES];
}
-(void)btnNextTouchEnd{
    [self setNextHighlighted:NO];
}
- (void)setNextHighlighted:(BOOL)highlighted {
    (highlighted) ? [nextButton setBackgroundColor:defGreen] : [nextButton setBackgroundColor:[UIColor clearColor]];
}

-(void)btnBackTouchStart{
    [self setBackHighlighted:YES];
}
-(void)btnBackTouchEnd{
    [self setBackHighlighted:NO];
    [self onBack];
}
- (void)setBackHighlighted:(BOOL)highlighted {
    (highlighted) ? [backButton setBackgroundColor:defGreen] : [backButton setBackgroundColor:[UIColor clearColor]];
}

-(void)onBack{
    
    [self stopAllTask];
    
    [untechable goBack:self.navigationController];
}

-(void)onNext{
    
    [self stopAllTask];
    
    [self setNextHighlighted:NO];
    
    BOOL goToNext = YES;
    
    if( goToNext ) {
        SocialnetworkController *socialnetwork;
        socialnetwork = [[SocialnetworkController alloc]initWithNibName:@"SocialnetworkController" bundle:nil];
        socialnetwork.untechable = untechable;
        [self.navigationController pushViewController:socialnetwork animated:YES];
        //[self storeSceenVarsInDic];
    }
}

#pragma mark -  UI functions
-(void)updateUI
{
    
}
-(void)configureRecorder
{
    configuredRecorder = YES;
    if( configuredRecorder ) {
        // Setup audio session
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
        NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc]init];
        [recordSetting setValue :[NSNumber  numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:11025.0] forKey:AVSampleRateKey];
        [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
        [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        
        
        // Initiate and prepare the recorder
        recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
        recorder.delegate = self;
        recorder.meteringEnabled = YES;
        [recorder prepareToRecord];
    }
}

-(BOOL)configuredPlayerFn{
    BOOL configured = NO;
    NSError *error;
    player = [[AVAudioPlayer alloc]
              initWithContentsOfURL:outputFileURL
              error:&error];
    if (error)
    {
        NSLog(@"Error in audioPlayer: %@",
              [error localizedDescription]);
    } else {
        player.delegate = self;
        [player prepareToPlay];
        
        configured = YES;
    }
    
    return configured;
}

@end