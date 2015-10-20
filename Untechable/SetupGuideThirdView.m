//
//  SetupGuideThirdView.m
//  Untechable
//
//  Created by RIKSOF Developer on 6/22/15.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "SetupGuideThirdView.h"
#import "ContactsListControllerViewController.h"

@interface SetupGuideThirdView () {
    
    ContactsListControllerViewController *viewControllerToAdd;
}
@end

@implementation SetupGuideThirdView

@synthesize untechable;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //navigation related Stuff
    [self setNavigationBarItems];
    
    //setting up a view and showing contact list in it
    [self setupContactView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];    
}

-(void)viewWillAppear:(BOOL)animated {
    [self setNavigation:@"viewDidLoad"];
}

-(void)setupContactView {
    
    viewControllerToAdd = [[ContactsListControllerViewController alloc] initWithNibName:@"ContactsListControllerViewController" bundle:nil];
    
    viewControllerToAdd.untechable = untechable;
    
    [viewControllerToAdd willMoveToParentViewController:self];
    [self.viewForContacts addSubview:viewControllerToAdd.view];
    [self addChildViewController:viewControllerToAdd];

    [viewControllerToAdd didMoveToParentViewController:self];
    
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
        [backButton setTitle:NSLocalizedString(TITLE_BACK_TXT, nil) forState:normal];
        [backButton setTitleColor:DEF_GRAY forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        [backButton addTarget:self action:@selector(btnTouchStart:) forControlEvents:UIControlEventTouchDown];
        [backButton addTarget:self action:@selector(btnTouchEnd:) forControlEvents:UIControlEventTouchUpInside];
        backButton.showsTouchWhenHighlighted = YES;
        
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        // adds left button to navigation bar
        [self.navigationItem setLeftBarButtonItem:leftBarButton];
        
        // Right Button
        nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        nextButton.titleLabel.shadowColor = [UIColor clearColor];
        [nextButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
        nextButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [nextButton setTitle:NSLocalizedString(TITLE_NEXT_TXT, nil) forState:normal];
        [nextButton setTitleColor:DEF_GRAY forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(btnTouchStart:) forControlEvents:UIControlEventTouchDown];
        [nextButton addTarget:self action:@selector(btnTouchEnd:) forControlEvents:UIControlEventTouchUpInside];
        
        nextButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton,nil];
        
        // adds right button to navigation bar
        [self.navigationItem setRightBarButtonItems:rightNavItems];
    }
}

#pragma mark -  Highlighting Functions

-(void)btnTouchStart :(id)button{
    [self setHighlighted:YES sender:button];
}
-(void)btnTouchEnd :(id)button{
    [self setHighlighted:NO sender:button];
}
- (void)setHighlighted:(BOOL)highlighted sender:(id)button {
    (highlighted) ? [button setBackgroundColor:DEF_GREEN] : [button setBackgroundColor:[UIColor clearColor]];
}

-(void)onNext{
    [viewControllerToAdd onNext];
}

-(void) goBack {
    
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:YES];
    
}

@end
