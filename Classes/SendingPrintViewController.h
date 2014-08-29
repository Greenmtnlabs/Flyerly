//
//  SendingPrintViewController.h
//  Flyr
//
//  Created by Khurram on 23/07/2014.
//
//

#import <UIKit/UIKit.h>
#import "Flyer.h"
#import <UIKit/UIKit.h>
#import <ParentViewController.h>
#import "PayPalMobile.h"
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "ParentViewController.h"
#import "Flyer.h"
#import <AFNetworking/AFNetworking.h>

@interface SendingPrintViewController : UIViewController < MFMailComposeViewControllerDelegate >

@property (nonatomic,strong) Flyer *flyer;
@property(nonatomic,strong) NSMutableArray *contactsArray;


@property (nonatomic, strong) IBOutlet UITextField *messageFeild;
@property (nonatomic, strong) IBOutlet UIImageView *flyerImage;
@property (nonatomic, strong) IBOutlet UITextField *streetAddress;
@property (nonatomic, strong) IBOutlet UITextField *state;
@property (nonatomic, strong) IBOutlet UITextField *city;
@property (nonatomic, strong) IBOutlet UITextField *country;
- (IBAction)send:(UIButton *)sender;
- (IBAction)dismiss:(UIButton *)sender;

@end
