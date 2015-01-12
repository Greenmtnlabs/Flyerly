//
//  ESViewController.m
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 3/13/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import "ESViewController.h"
#import "UIViewController+ESEventTagging.h"
#import <FlurrySDK/Flurry.h>

static const NSInteger BackgroundImageTag = 50;

@implementation ESViewController

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
@end
