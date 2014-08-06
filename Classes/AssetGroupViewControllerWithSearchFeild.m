//
//  AssetGroupViewControllerWithSearchFeild.m
//  Flyr
//
//  Created by RIKSOF Developer on 8/5/14.
//
//

#import "AssetGroupViewControllerWithSearchFeild.h"

@interface AssetGroupViewControllerWithSearchFeild ()

@end

@implementation AssetGroupViewControllerWithSearchFeild

@synthesize searchTextField;

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
    // Configure the grid view
    //self.gridView.margin = CGSizeMake(5.0, 5.0);
    //self.gridView.nibNameForViews = @"CustomAssetThumbnailView";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
