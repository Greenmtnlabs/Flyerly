//
//  ESHelpViewController.m
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 2/22/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import "ESHelpViewController.h"

@interface ESHelpViewController ()

@end

@implementation ESHelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}
@end
