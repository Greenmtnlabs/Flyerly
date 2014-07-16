//
//  PrintViewController.m
//  Flyr
//
//  Created by Khurram on 15/07/2014.
//
//

#import "PrintViewController.h"

@interface PrintViewController ()

@end

@implementation PrintViewController


@synthesize printButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    
    //UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    //printInfo.outputType = UIPrintInfoOutputGeneral;
    //printInfo.jobName = PRINT_DOCUMENT_NAME;
    //pic.printInfo = printInfo;
    
    /*UIMarkupTextPrintFormatter *htmlFormatter = [[UIMarkupTextPrintFormatter alloc]
                                                 initWithMarkupText:[self prepareReport]];*/
   //htmlFormatter.startPage = 0;
    //htmlFormatter.contentInsets = UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0); // 1 inch margins
    //htmlFormatter.maximumContentWidth = 6 * 72.0;
    //pic.printFormatter = htmlFormatter;
    pic.showsPageRange = YES;
    
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if (!completed && error) {
            
            NSLog(@"Error Occured");
            /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UNABLE_EMAIL_TITLE"
                                                            message:[@"UNABLE_EMAIL_MESSAGE]"
                                                           delegate:nil
                                                  cancelButtonTitle:@"UNABLE_EMAIL_CANCEL_BUTTON"
                                                  otherButtonTitles:@"UNABLE_EMAIL_OTHER_BUTTONS"];
            [alert show];*/
        }
    };
    
    [pic presentFromRect:printButton.frame inView:printButton.superview animated:YES completionHandler:completionHandler];
}

@end
