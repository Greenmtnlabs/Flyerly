//
//  ESBoardViewController.h
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 2/21/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESCollectionViewController.h"
#import "GADInterstitialDelegate.h"
#import "GADInterstitial.h"

@class ESBoard;

@interface ESBoardViewController : ESCollectionViewController <GADInterstitialDelegate>

@property ESBoard *board;
@property (weak, nonatomic) IBOutlet UIImageView *goodJobOverlayImageView;
@property(nonatomic, strong) GADInterstitial *interstitialAdd;

- (IBAction)back:(id)sender;
- (IBAction)goodJobOverlayTapped:(UITapGestureRecognizer *)sender;

@end
