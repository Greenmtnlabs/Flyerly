//
//  PhoneSetupController.m
//  Untechable
//
//  Created by Muhammad Raheel on 24/09/2014.
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//

#import "PhoneSetupController.h"


@interface PhoneSetupController (){
    NSString *tableViewFor;
}

@property (strong, nonatomic) IBOutlet UITableView *contactsTableView;

@end

@implementation PhoneSetupController



@synthesize untechable;
@synthesize btnforwardingNumber;


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
    
    NSLog(@"B-self.untechable.startDate startDate==%@",self.untechable.startDate);
    
    [self setNavigationDefaults];
    [self setNavigation:@"viewDidLoad"];
    
    [self setDefaultModel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// ________________________     Custom functions    ___________________________
#pragma mark -  Navigation functions

- (void)setNavigationDefaults{
    defBlueColor =  [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];

    [[self navigationController] setNavigationBarHidden:NO animated:YES]; //show navigation bar
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

-(void)setNavigation:(NSString *)callFrom
{
    if([callFrom isEqualToString:@"viewDidLoad"])
    {
        // Center title ________________________________________
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        titleLabel.backgroundColor = [UIColor clearColor];
        //titleLabel.font = [UIFont fontWithName:TITLE_FONT size:18];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = defBlueColor;
        titleLabel.text = @"Phone Setup";
        
        self.navigationItem.titleView = titleLabel; //Center title ___________
        
        
        // Right Navigation ________________________________________
        nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
        [nextButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
        //[nextButton setBackgroundImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
        [nextButton setTitle:@"Next" forState:normal];
        [nextButton setTitleColor:defBlueColor forState:UIControlStateNormal];
        
        nextButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton,nil];
        
        [self.navigationItem setRightBarButtonItems:rightNavItems];//Right buttons ___________
        
        
    }
}

-(void)onNext{
    BOOL goToNext = NO;
    
    if( goToNext ) {
        PhoneSetupController *phoneSetup;
        phoneSetup = [[PhoneSetupController alloc]initWithNibName:@"PhoneSetupController" bundle:nil];
        phoneSetup.untechable = untechable;
        [self.navigationController pushViewController:phoneSetup animated:YES];
    }
}

#pragma mark -  Model funcs
-(void)setTextIn:(NSString *)txtIn str:(NSString *)txt{
    if( [txtIn isEqualToString:@"btnforwardingNumber"] ) {
      [self.btnforwardingNumber setTitle:txt forState:UIControlStateNormal];
    }
}

-(void)setDefaultModel{
    
    _contactsTableView.dataSource = self;
    
    if( !([untechable.forwardingNumber isEqualToString:@""]) ){
        [self setTextIn:@"btnforwardingNumber" str:untechable.startDate];
    }
}

-(IBAction)getForwardingNum{
    if( [self.btnforwardingNumber.titleLabel.text isEqualToString:@"Click here to get Forwarding #"] ){
        [self setTextIn:@"btnforwardingNumber" str:@"Please wait..."];
        
        double delayInSeconds = 3.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self setTextIn:@"btnforwardingNumber" str:@"123"];
        });

    }
}

#pragma mark -  Table view functions
-(NSInteger)getCountForTableView {
    if([tableViewFor isEqualToString:@"abc"]){
        
    }
    
    return 3;//[tableViewArray count];
}


//3
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self getCountForTableView];
}
//4
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //5
    static NSString *cellIdentifier = @"SettingsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //5.1 you do not need this if you have set SettingsCell as identifier in the storyboard (else you can remove the comments on this code)
    if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
       }
    
    //6
    NSString *txt = [NSString stringWithFormat:@"My friend name %i", indexPath.row ];
    //[self.tweetsArray objectAtIndex:indexPath.row];
    
    //7
    [cell.textLabel setText:txt];
    [cell.detailTextLabel setText:@"00923453017449"];
    return cell;
}

@end
