//
//  AfterUpdateController.h
//  Flyr
//
//  Created by Rizwan Ahmad on 4/18/13.
//
//

#import <Foundation/Foundation.h>

@class LauchViewController;

@interface AfterUpdateController : UIViewController{

    LauchViewController *launchController;
}

@property(nonatomic,strong) LauchViewController *launchController;

-(IBAction)ok;

@end
