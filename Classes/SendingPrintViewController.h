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
#import "ParentViewController.h"
#import "PayPalMobile.h"
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "ParentViewController.h"
#import "Flyer.h"
#import "AFNetworking.h"
#import "LobLibrary.h"

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

@property (weak, nonatomic) IBOutlet UITextField *toName;
@property (weak, nonatomic) IBOutlet UITextField *toStreetAddress;
@property (weak, nonatomic) IBOutlet UITextField *toZip;
@property (weak, nonatomic) IBOutlet UITextField *toCity;
@property (weak, nonatomic) IBOutlet UITextField *toCountry;
@property (weak, nonatomic) IBOutlet UITextField *toState;
@property (weak, nonatomic) IBOutlet UIImageView *toimageText;
@property (weak, nonatomic) IBOutlet UIImageView *toimageText1;
@property (weak, nonatomic) IBOutlet UIImageView *toimageText2;
@property (weak, nonatomic) IBOutlet UIImageView *toimageText3;
@property (weak, nonatomic) IBOutlet UIImageView *toimageText4;
@property (weak, nonatomic) IBOutlet UIImageView *toimageText5;
@property (weak, nonatomic) IBOutlet UILabel * toLabel;
@property (weak, nonatomic) IBOutlet UILabel * characterCountLabel;


@property (nonatomic, strong) IBOutlet UITextView *contactlistTextView;
@end
