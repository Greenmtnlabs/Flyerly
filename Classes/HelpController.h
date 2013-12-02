//
//  HelpController.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 5/23/13.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "MyNavigationBar.h"
#import "Singleton.h"


@class Singleton;
@interface HelpController : UIViewController<MFMailComposeViewControllerDelegate>{

    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *doneButton;

    IBOutlet UIButton *linkButton;
    IBOutlet UIButton *emailButton;
    IBOutlet UIButton *linkFaceBook;
    IBOutlet UIButton *twitLink;
    Singleton *globle;
}

@property(nonatomic,strong) IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong) IBOutlet UIButton *doneButton;

@property(nonatomic,strong) IBOutlet UIButton *linkButton;
@property(nonatomic,strong) IBOutlet UIButton *emailButton;
@property(nonatomic,strong) IBOutlet UIButton *linkFaceBook;
@property(nonatomic,strong) IBOutlet UIButton *twitLink;

-(IBAction)goBack;
/*
-(void) openLink:(UIButton *)sender;
-(void) openFbLink:(UIButton *)sender;
-(void) openTwLink:(UIButton *)sender;
*/
@end
