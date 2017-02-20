//
//  InputViewController.h
//  Flyr
//
//  Created by Riksof on 09/09/2013.
//
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "FlyerlySingleton.h"
#import "LaunchController.h"
#import <SHKTwitter.h>

@class FlyerlySingleton;
@interface InputViewController : UIViewController <SHKSharerDelegate>{
    
    FlyerlySingleton *globle ;    
    SHKSharer *iosSharer;

}
@property (weak, nonatomic) IBOutlet UILabel *lblTweetMsg;
@property(nonatomic, strong) IBOutlet UITextView *txtfield;
-(IBAction)cancel;
-(IBAction)post;

@end
