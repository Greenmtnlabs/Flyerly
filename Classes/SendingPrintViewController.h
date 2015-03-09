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
#import "AFNetworking.h"
#import "AbstractBlockRequest.h"

@class AbstractBlockRequest;
@interface SendingPrintViewController : ParentViewController< UITextFieldDelegate, MFMailComposeViewControllerDelegate, PayPalPaymentDelegate > {
    
    AbstractBlockRequest *requestClass;
}

@property (nonatomic,strong) Flyer *flyer;
@property(nonatomic,strong) NSMutableArray *contactsArray;


@property(nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UITextView *messageFeild;
@property (nonatomic, strong) IBOutlet UIImageView *flyerImage;
@property (nonatomic, strong) IBOutlet UITextField *name;
@property (nonatomic, strong) IBOutlet UITextField *streetAddress;
@property (nonatomic, strong) IBOutlet UITextField *state;
@property (nonatomic, strong) IBOutlet UITextField *zip;
@property (nonatomic, strong) IBOutlet UITextField *city;
@property (nonatomic, strong) IBOutlet UITextField *country;

@end
