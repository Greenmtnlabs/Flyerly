//
//  HelpController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 5/23/13.
//
//

#import "HelpController.h"
#import "PhotoController.h"

@interface HelpController ()

@end

@implementation HelpController
@synthesize scrollView, doneButton;

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
    
    [scrollView setContentSize:CGSizeMake(320, 1600)];
    [doneButton setFrame:CGRectMake(doneButton.frame.origin.x, 1330, doneButton.frame.size.width, doneButton.frame.size.height)];
    
    // Create right bar button
    UIButton *crossButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [crossButton setBackgroundImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
    [crossButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:crossButton];
    [self.navigationItem setRightBarButtonItem:rightBarButton];

    self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Help Center"];

}

-(IBAction)goBack{
    
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
