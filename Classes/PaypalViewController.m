//
//  PaypalViewController.m
//  PiggybaQ
//
//  Created by Khurram Ali on 26/05/2014.
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//

#import "PaypalViewController.h"

@interface PaypalViewController ()

@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;

@end

@implementation PaypalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _payPalConfiguration = [[PayPalConfiguration alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentNoNetwork];
}

@end
