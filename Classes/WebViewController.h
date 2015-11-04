//
//  WebViewController.h
//  Flyr
//
//  Created by rufi on 04/11/2015.
//
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController{

    UIButton *btnHome;
    UIBarButtonItem *leftBarButton;

}
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedButton;
- (IBAction)segmentedControlAction:(id)sender;

@end
