//
//  HelpController.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 5/23/13.
//
//

#import <UIKit/UIKit.h>

@interface HelpController : UIViewController{

    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *doneButton;
}

@property(nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain) IBOutlet UIButton *doneButton;

-(IBAction)goBack;

@end
