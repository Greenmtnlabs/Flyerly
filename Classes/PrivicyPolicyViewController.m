//
//  PrivicyPolicyViewController.m
//  Flyr
//
//  Created by rufi on 11/03/2015.
//
//

#import "PrivicyPolicyViewController.h"
#import "Common.h"
@interface PrivicyPolicyViewController ()

@end

@implementation PrivicyPolicyViewController
@synthesize mylabel, textViewPrivicy, scrollViewPrivicy, txtViewPrivacyForFlyerlyBiz;
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
    label.text = @"PRIVACY POLICY";
    self.navigationItem.titleView = label;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:leftBarButton,nil]];
    if(IS_IPHONE_5){
        scrollViewPrivicy.contentSize=CGSizeMake(300, 3600);
    }else if(IS_IPHONE_6_PLUS || IS_IPHONE_XR || IS_IPHONE_XS){
        scrollViewPrivicy.contentSize=CGSizeMake(300, 2900);
    }else{
        scrollViewPrivicy.contentSize=CGSizeMake(300, 3200);
    }
    CGFloat fixedWidth = textViewPrivicy.frame.size.width;
    CGSize newSize = [textViewPrivicy sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textViewPrivicy.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textViewPrivicy.frame = newFrame;
    txtViewPrivacyForFlyerlyBiz.frame = newFrame;

    #if defined(FLYERLY)
        textViewPrivicy.hidden = NO;
        txtViewPrivacyForFlyerlyBiz.hidden = YES;
    #else
        textViewPrivicy.hidden = YES;
        txtViewPrivacyForFlyerlyBiz.hidden = NO;
    #endif
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
