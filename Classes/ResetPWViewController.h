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
#import "FBConnect.h"
#import "Singleton.h"
#import "AccountSelecter.h"
#import <Parse/PFLogInViewController.h>
#import <Parse/PFQuery.h>

@interface ResetPWViewController : UIViewController{
    LoadingView *loadingView;
}

@property (nonatomic, retain) LoadingView *loadingView;
@property(nonatomic, retain) IBOutlet UITextField *username;
-(void)goBack;

-(IBAction)SearchBotton:(id)sender;

-(void)showLoadingView:(NSString *)message;
-(void)removeLoadingView;
@end
