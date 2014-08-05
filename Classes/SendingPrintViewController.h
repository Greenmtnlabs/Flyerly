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
@property(nonatomic,strong) NSMutableArray *contactsArray;


@property (nonatomic, strong) IBOutlet UILabel *messageFeild;
@property (nonatomic, strong) IBOutlet UIImageView *flyerImage;
@property (nonatomic, strong) IBOutlet UITextField *streetAddress;
@property (nonatomic, strong) IBOutlet UITextField *state;
@property (nonatomic, strong) IBOutlet UITextField *city;
@property (nonatomic, strong) IBOutlet UITextField *country;
- (IBAction)send:(UIButton *)sender;
- (IBAction)dismiss:(UIButton *)sender;

@end
