//
//  InputViewController.h
//  Flyr
//
//  Created by Khurram on 09/09/2013.
//
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "Singleton.h"
#import "AccountController.h"
@class Singleton;
@interface InputViewController : UIViewController <UIActionSheetDelegate>{
    Singleton *globle ;
    
    NSString *sName;
    NSString *sMessage;
    NSArray *arrayOfAccounts;

}
@property(nonatomic, strong) IBOutlet UITextView *txtfield;
-(IBAction)cancel;
-(IBAction)post;

@end
