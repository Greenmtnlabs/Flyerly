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

@implementation AfterUpdateController
@synthesize launchController;

-(void)viewDidLoad{
    self.navigationController.navigationBarHidden = YES;
}

-(IBAction)ok{
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    
    [self.navigationController popToViewController:appDelegate.lauchController animated:YES];
}

@end
