//
//  AboutVC.m
// EverCam
//
//  Created by MacBook FV iMAGINATION on 08/05/15.
//  Copyright (c) 2015 FV iMAGINATION. All rights reserved.
//

#import "AboutVC.h"

@interface AboutVC ()

@end

@implementation AboutVC



- (void)viewDidLoad {
    [super viewDidLoad];

    _logoImage.layer.cornerRadius = 30;

}


- (IBAction)dismissButt:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
