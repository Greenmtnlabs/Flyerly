//
//  InputViewController.h
//  Flyr
//
//  Created by Khurram on 09/09/2013.
//
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "FlyerlySingleton.h"
#import "AccountController.h"
@class FlyerlySingleton;
@interface InputViewController : UIViewController <UIActionSheetDelegate>{
    FlyerlySingleton *globle ;
    
    NSString *sName;
    NSString *sMessage;
    NSArray *arrayOfAccounts;

}
@property(nonatomic, strong) IBOutlet UITextView *txtfield;
-(IBAction)cancel;
-(IBAction)post;

@end
