//
//  AfterUpdateController.m
//  Flyr
//
//  Created by Rizwan Ahmad on 4/18/13.
//
//

#import "AfterUpdateController.h"
#import "LauchViewController.h"
#import "Common.h"
#import "FlyrAppDelegate.h"
#import "AccountController.h"

@implementation AfterUpdateController
@synthesize launchController;

-(void)viewDidLoad {
    self.navigationController.navigationBarHidden = YES;
}

-(IBAction)ok {
    
    AccountController *accountController = nil; ;
    if(IS_IPHONE_5){
        accountController = [[AccountController alloc] initWithNibName:@"AcountViewControlleriPhone5" bundle:nil];
    }else{
        accountController = [[AccountController alloc] initWithNibName:@"AccountController" bundle:nil];
    }
    
    [self.navigationController pushViewController:accountController animated:YES];
}

@end
