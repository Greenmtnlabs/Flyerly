//
//  AfterUpdateController.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 22/Jan/2014.
//
//

#import <Foundation/Foundation.h>
#import "AccountController.h"

@class AccountController;

@interface AfterUpdateController : UIViewController{

    AccountController *accountController;

}

-(IBAction)ok;

@end
