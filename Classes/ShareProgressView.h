//
//  ShareProgressView.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 5/17/13.
//
//

#import <UIKit/UIKit.h>

extern NSString *CloseShareProgressNotification;
@interface ShareProgressView : UIView{

	IBOutlet UIButton *networkIcon;
	IBOutlet UIButton *statusIcon;
	IBOutlet UILabel *statusText;
	IBOutlet UIButton *refreshIcon;
	IBOutlet UIButton *cancelIcon;
}

@property(nonatomic,retain) IBOutlet UIButton *networkIcon;
@property(nonatomic,retain) IBOutlet UIButton *statusIcon;
@property(nonatomic,retain) IBOutlet UILabel *statusText;
@property(nonatomic,retain) IBOutlet UIButton *refreshIcon;
@property(nonatomic,retain) IBOutlet UIButton *cancelIcon;

-(IBAction)cancelPressed:(id)sender;
@end
