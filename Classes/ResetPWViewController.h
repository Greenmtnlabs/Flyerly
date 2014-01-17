//
//  ResetPWViewController.h
//  Flyr
//
//  Created by Khurram on 23/08/2013.
//
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import <Parse/PFQuery.h>
#import "LauchViewController.h"
#import "FlyrAppDelegate.h"
#import "Singleton.h"
#import "ProfileViewController.h"
#import <Parse/PFLogInViewController.h>
#import <Parse/PFQuery.h>
#import "ParentViewController.h"

@interface ResetPWViewController : ParentViewController {
    NSString *dbUsername;
}

@property(nonatomic, strong) IBOutlet UITextField *username;
-(void)goBack;

-(IBAction)SearchBotton:(id)sender;

-(void)removeLoadingView;
-(void)showAlert:(NSString *)title message:(NSString *)message;
@end
