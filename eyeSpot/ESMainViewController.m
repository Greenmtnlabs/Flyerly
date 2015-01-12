//
//  ESViewController.m
//  eyeSpot
//
//  Created by Vladimir Fleurima on 2/20/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import "ESMainViewController.h"
#import "ESTrophyViewController.h"
#import "ESBoardSelectionViewController.h"
#import "ESSoundManager.h"

@interface ESMainViewController ()

@end

@implementation ESMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[ESTrophyViewController class]]) {
        ESTrophyViewController *controller = (ESTrophyViewController *)segue.destinationViewController;
        controller.isReadOnly = YES;
    } else if ([segue.destinationViewController isKindOfClass:[ESBoardSelectionViewController class]]) {
        [[ESSoundManager sharedInstance] playSound:ESSoundSwoosh];
    }
}
@end
