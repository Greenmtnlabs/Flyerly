//
//  HelpController.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 5/23/13.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "FlyerlySingleton.h"
#import "Common.h"



@class FlyerlySingleton;
@interface HelpController : UIViewController<MFMailComposeViewControllerDelegate>{

    FlyerlySingleton *globle;
}

@property(nonatomic,strong) IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong) IBOutlet UIButton *doneButton;
@property(nonatomic,strong) IBOutlet UIButton *linkButton;
@property(nonatomic,strong) IBOutlet UIButton *emailButton;
@property(nonatomic,strong) IBOutlet UIButton *linkFaceBook;
@property(nonatomic,strong) IBOutlet UIButton *twitLink;

-(IBAction)goBack;

@end
