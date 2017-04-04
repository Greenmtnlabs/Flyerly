//
//  TermsOfServiceViewController.m
//  Flyr
//
//  Created by rufi on 11/03/2015.
//
//

#import "TermsOfServiceViewController.h"
#import "Common.h"
@interface TermsOfServiceViewController ()

@end

@implementation TermsOfServiceViewController
@synthesize terms,scrollViewTerms, textViewTerms, txtViewTermsForFlyerlyBiz;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    //set title
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-35, -6, 50, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];
    label.text = @"TERMS OF SERVICE";
    self.navigationItem.titleView = label;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:leftBarButton,nil]];
    if(IS_IPHONE_6_PLUS){
        scrollViewTerms.contentSize=CGSizeMake(300, 8450);
    }else if(IS_IPHONE_5){
        scrollViewTerms.contentSize=CGSizeMake(300, 7800);
    }else{
        scrollViewTerms.contentSize=CGSizeMake(300, 9200);
    }
    
    CGFloat fixedWidth = textViewTerms.frame.size.width;
    CGSize newSize = [textViewTerms sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textViewTerms.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textViewTerms.frame = newFrame;
    txtViewTermsForFlyerlyBiz.frame = newFrame;
    
    #if defined(FLYERLY)
        textViewTerms.hidden = NO;
        txtViewTermsForFlyerlyBiz.hidden = YES;
    #else
        textViewTerms.hidden = YES;
        txtViewTermsForFlyerlyBiz.hidden = NO;
    #endif
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
