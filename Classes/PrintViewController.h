//
//  PrintViewController.h
//  Flyr
//
//  Created by Khurram on 15/07/2014.
//
//

#import <UIKit/UIKit.h>
#import "Flyer.h"

@interface PrintViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIButton *printButton;
@property (nonatomic, strong) IBOutlet UIButton *startButton;
@property (nonatomic,strong) Flyer *flyer;

- (IBAction)dismissPrintViewPanel:(UIButton *)sender;

- (IBAction)onPrintFlyer:(UIButton *)sender;

- (IBAction)startButton:(UIButton *)sender;

@end
