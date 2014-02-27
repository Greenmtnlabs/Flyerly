//
//  AfterUpdateController.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 22/Jan/2014.
//
//

#import <Foundation/Foundation.h>
#import "LaunchController.h"

@class LaunchController;

@interface AfterUpdateController : UIViewController{

    LaunchController *accountController;

}

-(IBAction)ok;

@end
