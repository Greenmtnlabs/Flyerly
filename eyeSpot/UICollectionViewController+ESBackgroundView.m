//
//  UICollectionViewController+ESBackgroundView.m
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 3/5/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import "UICollectionViewController+ESBackgroundView.h"

static NSInteger TITLE_LABEL_TAG = 101;

@implementation UICollectionViewController (ESBackgroundView)

- (void)es_useDefaultBackgroundView
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.collectionView.backgroundView = backgroundView;
    UIImage *backgroundImage;
    if (IS_IPHONE5) {
         backgroundImage = [UIImage imageNamed:@"BackgroundImage-568h"];
    } else {
         backgroundImage = [UIImage imageNamed:@"BackgroundImage"];
    }
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    [backgroundView addSubview:backgroundImageView];
    
    backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *hortizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[backgroundImageView]-0-|"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:NSDictionaryOfVariableBindings(backgroundImageView)];
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-y-[backgroundImageView]-0-|"
                                                                           options:0
                                                                           metrics:@{@"y" : @(-20)}
                                                                             views:NSDictionaryOfVariableBindings(backgroundImageView)];
    [backgroundView addConstraints:hortizontalConstraints];
    [backgroundView addConstraints:verticalConstraints];
}

- (void)es_addTitleLabelToBackgroundView
{
    CGFloat fontSize, yOffset;
    if (IS_IPAD) {
        fontSize = 21.0; yOffset = 54.0;
    } else {
        fontSize = 14.0; yOffset = 32.0;
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.tag = TITLE_LABEL_TAG;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    [titleLabel sizeToFit];
    
    [self.collectionView.backgroundView addSubview:titleLabel];
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(<=1)-[titleLabel]-(<=1)-|"
                                                                             options:NSLayoutFormatAlignAllCenterY
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(titleLabel)];
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-y-[titleLabel]"
                                                                           options:0
                                                                           metrics:@{@"y" : @(yOffset)}
                                                                             views:NSDictionaryOfVariableBindings(titleLabel)];
    [self.collectionView.backgroundView addConstraints:horizontalConstraints];
    [self.collectionView.backgroundView addConstraints:verticalConstraints];
    
}
- (UILabel *)es_titleLabel
{
    return (UILabel *)[self.collectionView.backgroundView viewWithTag:TITLE_LABEL_TAG];
}
@end
