//
//  UICollectionViewController+ESBackgroundView.h
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 3/5/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionViewController (ESBackgroundView)

@property (nonatomic, readonly, weak) UILabel *es_titleLabel;
- (void)es_useDefaultBackgroundView;
- (void)es_addTitleLabelToBackgroundView;

@end
