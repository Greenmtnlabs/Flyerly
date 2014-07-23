//
//  SendingPrintViewController.h
//  Flyr
//
//  Created by Khurram on 23/07/2014.
//
//

#import <UIKit/UIKit.h>
#import "Flyer.h"

@interface SendingPrintViewController : UIViewController

@property (nonatomic,strong) Flyer *flyer;

- (IBAction)dismiss:(UIButton *)sender;
@property (nonatomic, strong) IBOutlet UILabel *messageFeild;
@property (nonatomic, strong) IBOutlet UIImageView *flyerImage;
@property (nonatomic, strong) IBOutlet UITextField *addressFeild;
- (IBAction)send:(UIButton *)sender;

@end
