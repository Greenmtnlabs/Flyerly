//
//  PrintViewController.m
//  Flyr
//
//  Created by Khurram on 15/07/2014.
//
//

#import "PrintViewController.h"
#import "CreateFlyerController.h"
#import "InviteForPrint.h"

@interface PrintViewController ()

@end

@implementation PrintViewController


@synthesize printButton,startButton,flyer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // setting border for login/restore purchases button
    
    //Setting up border on start button
    startButton.layer.borderWidth=1.0f;
    [startButton.layer setCornerRadius:3.0];
    startButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    
    //Setting up border on print button
    printButton.layer.borderWidth=1.0f;
    [printButton.layer setCornerRadius:3.0];
    printButton.layer.borderColor=[[UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0] CGColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissPrintViewPanel:(UIButton *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onPrintFlyer:(UIButton *)sender {
    
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
        if (!completed && error) NSLog(@"Print error: %@", error);
    };
    
    NSString *imageToPrintPath = [flyer getFlyerImage];
    UIImage *imageToPrint =  [UIImage imageWithContentsOfFile:imageToPrintPath];
    pic.printingItem = imageToPrint;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //[printController presentFromRect:printButton.frame inView:printButton.superview
                                //animated:YES completionHandler:completionHandler];
    } else {
        [pic presentAnimated:YES completionHandler:completionHandler];
    }
}

- (IBAction)startButton:(UIButton *)sender {
    
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PrintViewControllerDismissed"
                                                        object:nil
                                                      userInfo:nil];
}

@end
