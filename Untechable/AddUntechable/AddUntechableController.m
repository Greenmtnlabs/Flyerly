//
//  AddUntechableController.m
//  Untechable
//
//  Created by Muhammad Raheel on 24/09/2014.
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//

#import "AddUntechableController.h"

@interface AddUntechableController ()

@end

@implementation AddUntechableController

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
    // Do any additional setup after loading the view from its nib.

    [self setNavigationDefaults];
    
    [self setNavigation:@"viewDidLoad"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * Update the view once it appears.
 */
-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

}


- (void)setNavigationDefaults{
    //[[self navigationController] setNavigationBarHidden:YES animated:YES]; //hide navigation bar
    [[self navigationController] setNavigationBarHidden:NO animated:YES]; //show navigation bar
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

-(void)setNavigation:(NSString *)callFrom
{
    if([callFrom isEqualToString:@"viewDidLoad"])
    {
       // Left Navigation ________________________________________________________________________________________________________
        backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
        [backButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        /*
        //[backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        // HERE WE SET BACK BUTTON IMAGE AS REQUIRED
        NSArray * arrayOfControllers =  self.navigationController.viewControllers;
        int idx = [arrayOfControllers count] -2 ;
        id previous = [arrayOfControllers objectAtIndex:idx];
        if ([previous isKindOfClass:[AddUntechableController class]])
        {
            //[backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
        } else {
            //[backButton setBackgroundImage:[UIImage imageNamed:@"home_button"] forState:UIControlStateNormal];
        }
        */

        [backButton setTitle:@"Back" forState:normal];
        
        backButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];

        helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
        //[helpButton addTarget:self action:@selector(loadHelpController) forControlEvents:UIControlEventTouchUpInside];
        //[helpButton setBackgroundImage:[UIImage imageNamed:@"help_icon"] forState:UIControlStateNormal];
        [helpButton setTitle:@"Help" forState:normal];
        helpButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *leftBarHelpButton = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
        NSMutableArray  *leftNavItems  = [NSMutableArray arrayWithObjects:backBarButton,leftBarHelpButton,nil];
        [self.navigationItem setLeftBarButtonItems:leftNavItems]; //Left button ___________
        
        
        
        
        // Center title ________________________________________________________________________________________________________
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        titleLabel.backgroundColor = [UIColor clearColor];
        //titleLabel.font = [UIFont fontWithName:TITLE_FONT size:18];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];
        titleLabel.text = @"Untechable";
        
        self.navigationItem.titleView = titleLabel; //Center title ___________
        
        

        // Right Navigation ________________________________________________________________________________________________________
        
        
        nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
        //[nextButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        //[nextButton setBackgroundImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
        [nextButton setTitle:@"next" forState:normal];
        [nextButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [nextButton setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
        nextButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton,nil];
        
        [self.navigationItem setRightBarButtonItems:rightNavItems];//Right button ___________
        
    }
}

@end
