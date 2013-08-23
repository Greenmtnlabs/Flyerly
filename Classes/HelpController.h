//
//  HelpController.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 5/23/13.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface HelpController : UIViewController<MFMailComposeViewControllerDelegate>{

    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *doneButton;

    IBOutlet UIButton *linkButton;
    IBOutlet UIButton *emailButton;
    IBOutlet UIButton *linkFaceBook;
    IBOutlet UIButton *twitLink;
}

@property(nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain) IBOutlet UIButton *doneButton;

@property(nonatomic,retain) IBOutlet UIButton *linkButton;
@property(nonatomic,retain) IBOutlet UIButton *emailButton;
@property(nonatomic,retain) IBOutlet UIButton *linkFaceBook;
@property(nonatomic,retain) IBOutlet UIButton *twitLink;

-(IBAction)goBack;
/*
-(void) openLink:(UIButton *)sender;
-(void) openFbLink:(UIButton *)sender;
-(void) openTwLink:(UIButton *)sender;
*/
@end
