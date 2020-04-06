//
//  ResetPWViewController.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd on 23/08/2013.
//
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "FlyrAppDelegate.h"
#import "FlyerlySingleton.h"
#import "ProfileViewController.h"
//#import <ParseUI/PFLoginViewController.h>
#import <Parse/PFQuery.h>
#import "ParentViewController.h"

@interface ResetPWViewController : ParentViewController {
    NSString *dbUsername;
}

@property(nonatomic, strong) IBOutlet UITextField *username;
-(void)goBack;

-(IBAction)SearchBotton:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblRecoverAccount;
-(void)removeLoadingView;
-(void)showAlert:(NSString *)title message:(NSString *)message;
@end
