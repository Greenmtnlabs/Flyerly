//
//  ESCollectionViewController.h
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 3/13/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESCollectionViewController : UICollectionViewController

@property (strong, nonatomic) IBOutlet UIButton *leftPagingButton, *rightPagingButton;
- (void)setupPagingButtons;

@end
