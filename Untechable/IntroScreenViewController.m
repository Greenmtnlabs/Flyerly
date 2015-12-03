//
//  IntroScreenViewController.m
//  Untechable
//
//  Created by rufi on 29/10/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "IntroScreenViewController.h"
#import "SetupGuideViewController.h"

#import "Common.h"
#import "UntechablesList.h"
#import "RSetUntechable.h"
#import "IntroScreenViewController.h"
#import "SetupGuideViewController.h"


@interface IntroScreenViewController ()

@end

@implementation IntroScreenViewController

@synthesize untechable;
@synthesize audioPlayer, timer;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController setNavigationBarHidden:YES];
    
    // Plays playback sound
    [self startPlayback];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * This method plays sound
 * @params:
 *      void
 * @return:
 *      void
 */
-(void)startPlayback{
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *filePath = [mainBundle pathForResource:@"untech" ofType:@"mp3"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0
                                                  target:self
                                                selector:@selector(updateTime)
                                                userInfo:nil
                                                 repeats:NO];
}

/*
 * This method updates time
 * @params:
 *      void
 * @return:
 *      void
 */
- (void)updateTime {
    NSTimeInterval currentTime = self.audioPlayer.currentTime;
    
    NSInteger minutes = floor(currentTime/60);
    NSInteger seconds = trunc(currentTime - minutes * 60);
    
    if(seconds == 0){
        
        self.audioPlayer = nil;
        RLMResults *unsortedObjects = [RSetUntechable objectsWhere:@"rUId == '1'"];
        
        //If we have default Untechable then go to UntechablesList screen
        if (unsortedObjects.count > 0){
            UntechablesList *mainViewController = [[UntechablesList alloc] initWithNibName:@"UntechablesList" bundle:nil];
            [self.navigationController pushViewController:mainViewController animated:YES];
        } else {
            RSetUntechable *rSetUntechable = [[RSetUntechable alloc] init];
            [rSetUntechable setDefault];
            rSetUntechable.rUId = @"1";
            NSMutableDictionary *dic = [rSetUntechable getModelDic];
            
            untechable  = [[Untechable alloc] initWithCommonFunctions];
            [untechable addOrUpdateInModel:UPDATE dictionary:dic];
            
            // Load SetupGuideViewController
            SetupGuideViewController *setupGuideViewController = [[SetupGuideViewController alloc] initWithNibName:@"SetupGuideViewController" bundle:nil];
            setupGuideViewController.untechable = untechable;
            [self.navigationController pushViewController:setupGuideViewController animated:YES];
        }
    }
}



@end
