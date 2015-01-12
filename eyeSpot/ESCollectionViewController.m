//
//  ESCollectionViewController.m
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 3/13/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import <FlurrySDK/Flurry.h>
#import "ESCollectionViewController.h"
#import "UIViewController+ESEventTagging.h"

static const NSInteger BackgroundImageTag = 50;

@implementation ESCollectionViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [Flurry logEvent:kESEventTagForPageView
      withParameters:@{@"name" : [self eventTag]}
               timed:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [Flurry endTimedEvent:kESEventTagForPageView withParameters:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *backgroundImageView = (UIImageView *)[self.view viewWithTag:BackgroundImageTag];
    if (backgroundImageView && IS_IPHONE5) {
        backgroundImageView.image = [UIImage imageNamed:@"BackgroundImage-568h"];
    }
}

- (void)setupPagingButtons
{
    self.leftPagingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftPagingButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.leftPagingButton setImage:[UIImage imageNamed:@"LeftArrow"]
                           forState:UIControlStateNormal];
    [self.leftPagingButton setImage:[UIImage imageNamed:@"LeftArrow_Selected"]
                           forState:UIControlStateHighlighted];
    if (IS_IPAD) [self.leftPagingButton setImageEdgeInsets:UIEdgeInsetsMake(-25.0, 0.0, 0.0, 0.0)];
    
    self.rightPagingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightPagingButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.rightPagingButton setImage:[UIImage imageNamed:@"RightArrow"]
                            forState:UIControlStateNormal];
    [self.rightPagingButton setImage:[UIImage imageNamed:@"RightArrow_Selected"]
                            forState:UIControlStateHighlighted];
    if (IS_IPAD) [self.rightPagingButton setImageEdgeInsets:UIEdgeInsetsMake(-22.0, 0.0, 0.0, 0.0)];
    
    UIView *superview = self.collectionView.backgroundView;
    [superview addSubview:self.leftPagingButton];
    [superview addSubview:self.rightPagingButton];
    
    NSArray *constraints;
    NSDictionary *views = @{@"leftPagingButton" : self.leftPagingButton,
                            @"rightPagingButton" : self.rightPagingButton};
    NSDictionary *metrics = @{@"padding" : @(0)};
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[leftPagingButton]"
                                                          options:NSLayoutFormatAlignAllCenterY
                                                          metrics:metrics
                                                            views:views];
    [superview addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[leftPagingButton]-|"
                                                          options:NSLayoutFormatAlignAllCenterY
                                                          metrics:nil
                                                            views:views];
    [superview addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[rightPagingButton]-padding-|"
                                                          options:NSLayoutFormatAlignAllCenterY
                                                          metrics:metrics
                                                            views:views];
    [superview addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[rightPagingButton]-|"
                                                          options:NSLayoutFormatAlignAllCenterY
                                                          metrics:nil
                                                            views:views];
    [superview addConstraints:constraints];
    
}

@end
