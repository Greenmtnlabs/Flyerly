//
//  AfterUpdateController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 22/Jan/2014.
//
//

#import "AfterUpdateController.h"

@implementation AfterUpdateController


-(void)viewDidLoad {
    self.navigationController.navigationBarHidden = YES;
}

-(IBAction)ok {
    
    accountController = [[AccountController alloc] initWithNibName:@"AccountController" bundle:nil];
    [self.navigationController pushViewController:accountController animated:YES];
}

@end
