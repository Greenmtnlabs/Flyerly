//
//  ESBoardViewController.h
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 2/21/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESCollectionViewController.h"

@class ESBoard;

@interface ESBoardViewController : ESCollectionViewController

@property ESBoard *board;
@property (weak, nonatomic) IBOutlet UIImageView *goodJobOverlayImageView;

- (IBAction)back:(id)sender;
- (IBAction)goodJobOverlayTapped:(UITapGestureRecognizer *)sender;

@end
