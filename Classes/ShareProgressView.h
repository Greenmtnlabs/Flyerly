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

@property(nonatomic,strong) IBOutlet UIButton *networkIcon;
@property(nonatomic,strong) IBOutlet UIButton *statusIcon;
@property(nonatomic,strong) IBOutlet UILabel *statusText;
@property(nonatomic,strong) IBOutlet UIButton *refreshIcon;
@property(nonatomic,strong) IBOutlet UIButton *cancelIcon;

-(IBAction)cancelPressed:(id)sender;
@end
