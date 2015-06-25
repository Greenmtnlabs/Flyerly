//
//  UntechOptionsViewController.m
//  Untechable
//
//  Created by rufi on 24/06/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "UntechOptionsViewController.h"
#import "SetupGuideSecondViewController.h"
#import "AddUntechableController.h"
#import "Common.h"


@interface UntechOptionsViewController (){
    NSMutableArray *data;
}

@property (strong, nonatomic) IBOutlet UIButton *btnUntechCustom;

@property (strong, nonatomic) IBOutlet UIDatePicker *picker;


@end

@implementation UntechOptionsViewController

@synthesize untechable;

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [untechable printNavigation:[self navigationController]];
}

-(void) viewDidLoad{
    [super viewDidLoad];
    //navigation related Stuff
    [self setNavigationBarItems];
    
    [self showHidePicker:NO];
    [self updateUI];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self setNavigation:@"viewDidLoad"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -  UI functions
-(void)updateUI{
    
    [UntechCustom setTitleColor:defGray forState:UIControlStateNormal];
    UntechCustom.titleLabel.font = [UIFont fontWithName:APP_FONT size:22];
    UntechCustom.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [Untech setTitleColor:defGray forState:UIControlStateNormal];
    Untech.titleLabel.font = [UIFont fontWithName:APP_FONT size:22];
    Untech.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    
   }

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma - mark setting navigation bar related stuff
-(void) setNavigationBarItems {
    
    defGreen = [UIColor colorWithRed:66.0/255.0 green:247.0/255.0 blue:206.0/255.0 alpha:1.0];//GREEN
    defGray = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1.0];//GRAY
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES]; //show navigation bar
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
}

-(void)setNavigation:(NSString *)callFrom {
    
    if([callFrom isEqualToString:@"viewDidLoad"])
    {
        self.navigationItem.hidesBackButton = YES;
        
        // Center title __________________________________________________
        self.navigationItem.titleView = [untechable.commonFunctions navigationGetTitleView];
        
        
        // Back Navigation button
        backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        backButton.titleLabel.shadowColor = [UIColor clearColor];
        backButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [backButton setTitle:TITLE_BACK_TXT forState:normal];
        [backButton setTitleColor:defGray forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchDown];
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        backButton.showsTouchWhenHighlighted = YES;
        
        UIBarButtonItem *lefttBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        [self.navigationItem setLeftBarButtonItem:lefttBarButton];//Left button ___________
        // }
        // Right Navigation ______________________________________________
        nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        //[nextButton setBackgroundColor:[UIColor redColor]];//for testing
        
        nextButton.titleLabel.shadowColor = [UIColor clearColor];
        //nextButton.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
        
        [nextButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
        //[nextButton setBackgroundImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
        nextButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [nextButton setTitle:TITLE_NEXT_TXT forState:normal];
        [nextButton setTitleColor:defGray forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(btnNextTouchStart) forControlEvents:UIControlEventTouchDown];
        [nextButton addTarget:self action:@selector(btnNextTouchEnd) forControlEvents:UIControlEventTouchUpInside];
        
        nextButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton,nil];
        
        [self.navigationItem setRightBarButtonItems:rightNavItems];//Right button ___________
        
    }
}

#pragma - Mark UI PICKER VIEW Delegate Methods
// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return data.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return data[row];
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
    
    
}

-(void)initializePickerData {
    
    NSArray *arrayToBeAdded =  @[@"30 min", @"1 hr", @"1 day", @"2 days"];
   
    NSMutableOrderedSet * set = [NSMutableOrderedSet orderedSetWithArray:arrayToBeAdded ];
    
    [set unionSet:[NSSet setWithArray:arrayToBeAdded]];
    
    data = [NSMutableArray arrayWithArray:[set array]];
    
    
    self.untechNowPicker.dataSource = self;
    self.untechNowPicker.delegate = self;
}

-(void)showHidePicker:(BOOL)showHide{
    if ( IS_IPHONE_4 ){
        [btnClose setFrame:CGRectMake(-2, 300, 580, 30)];
        [_untechNowPicker setFrame:CGRectMake(0, 300, 0, 140)];
    }else if( IS_IPHONE_5 ){
        [btnClose setFrame:CGRectMake(-10, 340, 580, 35)];
        [_untechNowPicker setFrame:CGRectMake(0, 375, 0, 240)];
    }else if ( IS_IPHONE_6 ){
        [btnClose setFrame:CGRectMake(0, 400, 650, 40)];
        [_untechNowPicker setFrame:CGRectMake(0, 440, 0, 260)];
    }else if (IS_IPHONE_6_PLUS){
        [btnClose setFrame:CGRectMake(0, 500, 750, 50)];
        [_untechNowPicker setFrame:CGRectMake(0, 540, 0, 500)];
    }
    
    float alpha = (showHide) ? 1.0 : 0.0;
    
    _untechNowPicker.alpha = alpha;
    btnClose.alpha = alpha;
    [self addUpperBorder];
    btnClose.backgroundColor = [self colorFromHexString:@"#f1f1f1"];
    self.picker.backgroundColor = [self colorFromHexString:@"#fafafa"];
    
    //changing the "CLOSE"button text color to black
    [btnClose setTitleColor:[self colorFromHexString:@"#000000"] forState:UIControlStateNormal];
    
}

/**
 Adding a top border for a view
 **/
- (void)addUpperBorder
{
    CALayer *upperBorder = [CALayer layer];
    upperBorder.backgroundColor = [[UIColor lightGrayColor] CGColor];
    upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(btnClose.frame), 1.0f);
    [btnClose.layer addSublayer:upperBorder];
}

/**
 Hex Color Converter
 @params NSString
 retunrs UIColor
 */
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
-(void)btnNextTouchStart{
    [self setNextHighlighted:YES];
}
-(void)btnNextTouchEnd{
    [self setNextHighlighted:NO];
}
- (void)setNextHighlighted:(BOOL)highlighted {
    (highlighted) ? [nextButton setBackgroundColor:defGreen] : [nextButton setBackgroundColor:[UIColor clearColor]];
}

-(void)onNext{
    
}

-(void) goBack {
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:YES];
}


-(UIImageView *) navigationGetTitleView
{
    return  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
}



- (IBAction)untechButton:(id)sender {
    
    [self showHidePicker:YES];
    [self initializePickerData];
    
}

- (IBAction)untechCustomButton:(id)sender {
    AddUntechableController *customUntechScreen = [[AddUntechableController alloc] initWithNibName:@"AddUntechableController" bundle:nil];
    customUntechScreen.untechable = untechable;
    [self.navigationController pushViewController:customUntechScreen animated:YES];
}

- (IBAction)btnClosePicker:(id)sender {
    [self showHidePicker:NO];
}
@end
