//
//  PrintViewController.h
//  Flyr
//
//  Created by Khurram on 15/07/2014.
//
//

#import <UIKit/UIKit.h>

@interface PrintViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIButton *printButton;

- (IBAction)dismissPrintViewPanel:(UIButton *)sender;

- (IBAction)onPrintFlyer:(UIButton *)sender;


@end
