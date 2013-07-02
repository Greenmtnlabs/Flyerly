//
//  LocationController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 6/28/13.
//
//

#import "LocationController.h"
#import "LocationItem.h"
#import "PhotoController.h"

@interface LocationController ()

@end

@implementation LocationController
@synthesize uiTableView;

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
    
    // title background
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg_without_logo2"] forBarMetrics:UIBarMetricsDefault];
    
    // Setup cancel button
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 30)];
    [cancelButton addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"camera_cancel"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];
}

- (IBAction)onBack{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    
    // set title
    self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Locations" rect:CGRectMake(-50, -6, 50, 50)];

    [uiTableView reloadData];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // return count
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get cell
    static NSString *cellId = @"LocationItem";
    LocationItem *cell = (LocationItem *) [uiTableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    
    // Set data on screen
    cell.name.text = @"Name";
    cell.address.text = @"Address";
    
    // return cell
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
