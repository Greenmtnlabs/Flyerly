//
//  ESTrophyViewController.h
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 2/22/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESViewController.h"

@class ESBoard;
@interface ESTrophyViewController : ESViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) ESBoard *board;
@property (weak, nonatomic) IBOutlet UICollectionView *boardCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *trophyCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIImageView *selectAnAwardImageView;
@property (assign, nonatomic) BOOL isReadOnly;

- (IBAction)handleTrophyDrag:(UIPanGestureRecognizer *)sender;
- (IBAction)back:(id)sender;
- (IBAction)share:(id)sender;

@end
