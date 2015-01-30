//
//  ThankyouController.h
//  Untechable
//
//  Created by Muhammad Raheel on 28/10/2014.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ThankyouController : UIViewController
{
    UILabel *titleLabel;
    //UIButton *helpButton;

    UIButton *startNewUntechable;
    UIButton *settingsButton;
    UIButton *editUntechable;
    
    UIColor *defGreen;//GREEN
    UIColor *defGray;//GRAY
    
    MPMoviePlayerViewController *moviePlayer;
}
//Properties
@property (nonatomic,strong)  Untechable *untechable;

-(IBAction)playVideo:(id)sender;
@end
