//
//  SetupGuideFourthView.m
//  Untechable
//
//  Created by RIKSOF Developer on 6/30/15.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "SetupGuideFourthView.h"
#import "SocialnetworkController.h"
#import "UntechablesList.h"
#import "RSetUntechable.h"

@interface SetupGuideFourthView ()

@end

@implementation SetupGuideFourthView

@synthesize untechable;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //navigation related Stuff
    [self setNavigationBarItems];
    
    [self setupShareScreen];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated {
    [self setNavigation:@"viewDidLoad"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma - mark setting navigation bar related stuff
-(void) setNavigationBarItems {
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES]; //show navigation bar
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
}

-(void)setNavigation:(NSString *)callFrom {
    
    if([callFrom isEqualToString:@"viewDidLoad"])
    {
        self.navigationItem.hidesBackButton = YES;
        
        // Center title __________________________________________________
        self.navigationItem.titleView = [untechable.commonFunctions navigationGetTitleView];
        
        // Back Navigation button
        backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        backButton.titleLabel.shadowColor = [UIColor clearColor];
        backButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [backButton setTitle:TITLE_BACK_TXT forState:normal];
        [backButton setTitleColor:DEF_GRAY forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchDown];
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        backButton.showsTouchWhenHighlighted = YES;
        
        UIBarButtonItem *lefttBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        [self.navigationItem setLeftBarButtonItem:lefttBarButton];//Left button ___________
        // }
        // Right Navigation ______________________________________________
        nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        
        nextButton.titleLabel.shadowColor = [UIColor clearColor];
        
        [nextButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
        
        nextButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [nextButton setTitle:TITLE_DONE_TXT forState:normal];
        [nextButton setTitleColor:DEF_GRAY forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(btnNextTouchStart) forControlEvents:UIControlEventTouchDown];
        [nextButton addTarget:self action:@selector(btnNextTouchEnd) forControlEvents:UIControlEventTouchUpInside];
        
        nextButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton,nil];
        
        [self.navigationItem setRightBarButtonItems:rightNavItems];//Right button ___________
        
    }
}

-(void)btnNextTouchStart{
    [self setNextHighlighted:YES];
}
-(void)btnNextTouchEnd{
    [self setNextHighlighted:NO];
}
- (void)setNextHighlighted:(BOOL)highlighted {
    (highlighted) ? [nextButton setBackgroundColor:DEF_GREEN] : [nextButton setBackgroundColor:[UIColor clearColor]];
}

-(void)onNext{
    
    //Save setting untechable in data base
    [[RLMRealm defaultRealm] transactionWithBlock:^{
        untechable.hasFinished = YES;
        [untechable setOrSaveVars:SAVE dic2:nil];
        [RSetUntechable createOrUpdateInDefaultRealmWithValue:untechable.dic];
        
        UIAlertView *congratesAlert = [[UIAlertView alloc]initWithTitle:@"Congratulation" message:@"Thank you for setting up your Untech settings. Now you can easily become Untechable whenever you need a break from technology in order to spend more time with the people & experiencing the things that are most important." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [congratesAlert show];
    }];
}

-(void) goBack {
    
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:YES];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {    
    //we're assuming cancel as done because there is only one button on the alert
    if( buttonIndex == [alertView cancelButtonIndex] ) {
        
        UntechablesList *untechScreen = [[UntechablesList alloc] initWithNibName:@"UntechablesList" bundle:nil];
        [self.navigationController pushViewController:untechScreen animated:YES];
        
    }
}

-(void)setupShareScreen {
    
    SocialnetworkController *viewControllerToAdd = [[SocialnetworkController alloc] initWithNibName:@"SocialnetworkController" bundle:nil];
    
    viewControllerToAdd.untechable = untechable;
    
    [viewControllerToAdd willMoveToParentViewController:self];
    [self.viewForShareScreen addSubview:viewControllerToAdd.view];
    [self addChildViewController:viewControllerToAdd];
    
    [viewControllerToAdd didMoveToParentViewController:self];
    
}


@end
