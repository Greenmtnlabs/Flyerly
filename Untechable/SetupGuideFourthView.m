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
        
        // Center title
        self.navigationItem.titleView = [untechable.commonFunctions navigationGetTitleView];
        
        // Back Button
        backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        backButton.titleLabel.shadowColor = [UIColor clearColor];
        backButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [backButton setTitle:NSLocalizedString(TITLE_NEXT_TXT, nil) forState:normal];
        [backButton setTitleColor:DEF_GRAY forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchDown];
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        backButton.showsTouchWhenHighlighted = YES;
        
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        // adds left button to navigation bar
        [self.navigationItem setLeftBarButtonItem:leftBarButton];
        
        // Right Button
        nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        nextButton.titleLabel.shadowColor = [UIColor clearColor];
        [nextButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
        nextButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [nextButton setTitle:NSLocalizedString(TITLE_DONE_TXT, nil) forState:normal];
        [nextButton setTitleColor:DEF_GRAY forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(btnNextTouchStart) forControlEvents:UIControlEventTouchDown];
        [nextButton addTarget:self action:@selector(btnNextTouchEnd) forControlEvents:UIControlEventTouchUpInside];
        nextButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton,nil];
        
         // adds right button to navigation bar
        [self.navigationItem setRightBarButtonItems:rightNavItems];
        
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
    untechable.hasFinished = YES;
    [untechable addOrUpdateInDatabase];
    UIAlertView *congratesAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Congratulations!", nil)  message:NSLocalizedString(@"Thank you! Now easily Untech from technology and spend quality time with people while experiencing things that are important.", nil) delegate:self cancelButtonTitle:NSLocalizedString(OK, nil) otherButtonTitles:nil, nil];
    [congratesAlert show];
    
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
