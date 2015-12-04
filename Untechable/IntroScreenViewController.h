//
//  IntroScreenViewController.h
//  Untechable
//
//  Created by rufi on 29/10/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"

#import <AVFoundation/AVFoundation.h>

@interface IntroScreenViewController : UIViewController <AVAudioPlayerDelegate>{
      
}

@property (nonatomic,strong)  Untechable *untechable;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSTimer *timer;



@end
