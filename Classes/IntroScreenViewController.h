//
//  IntroScreenViewController.h
//  Flyr
//
//  Created by rufi on 09/09/2015.
//
//

@protocol IntroScreenViewControllerButtonProtocol

-(void)inAppPurchasePanelButtonTappedWasPressed:(NSString *)introScreenPanelButtonCurrentTitle;
-(void)openPanel;

@end


#import <UIKit/UIKit.h>

@interface IntroScreenViewController : UIViewController 

@property (nonatomic, assign) id <IntroScreenViewControllerButtonProtocol> buttonDelegate;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *btnHideMe;
@property (strong, nonatomic) IBOutlet UIButton *btnSignIn;

- (IBAction)signIn:(id)sender;
- (IBAction)hideTray:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;

- (IBAction)onClickBack:(id)sender;
- (IBAction)onClickNext:(id)sender;


@end
