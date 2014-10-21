//
//  RecordController.h
//  Untechable
//
//  Created by ABDUL RAUF on 20/10/2014.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Untechable.h"

@interface RecordController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *recordPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UILabel *recordTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *playTimeLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;

- (IBAction)recordPauseTapped:(id)sender;
- (IBAction)stopTapped:(id)sender;
- (IBAction)playTapped:(id)sender;

//Properties
@property (nonatomic,strong)  Untechable *untechable;

@end
