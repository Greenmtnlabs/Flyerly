//
//  EmailSettingController.m
//  Untechable
//
//  Created by ABDUL RAUF on 30/09/2014.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "EmailSettingController.h"
#import "ThankyouController.h"
#import "Common.h"
#import "BSKeyboardControls.h"


@class EmailTableViewCell;

@interface EmailSettingController (){
 
}

@property (strong, nonatomic) IBOutlet UIView *emailSetting;
@property (strong, nonatomic) IBOutlet UIView *emailSetting1;
@property (strong, nonatomic) IBOutlet UIView *emailSetting2;

@property (strong, nonatomic) IBOutlet UITableView *tableView0;
@property (weak, nonatomic) IBOutlet UISegmentedControl *serverType;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ssl;


@property (strong, nonatomic) IBOutlet UILabel *lbl1;
@property (strong, nonatomic) IBOutlet UITextField *inputEmail;

@property (strong, nonatomic) IBOutlet UITextField *inputPassword;
@property (strong, nonatomic) IBOutlet UITextField *inputMsg;

@property (nonatomic, strong) BSKeyboardControls *keyboardControls;


@property (strong, nonatomic) NSMutableArray *table01Data;

@end

@implementation EmailSettingController

@synthesize untechable,ssl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationDefaults];
    [self setNavigation:@"viewDidLoad"];
    
    [self setDefaultModel];
    
    //[self.view addSubview:_emailSetting1];
    
    NSArray *fields = @[ self.inputEmail, self.inputPassword, self.inputMsg ];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
}

-(IBAction)serverType:(UISegmentedControl *)sender
{
    
    if ( sender == _serverType ) {
        NSLog(@"asdf");
    }
    if ( sender.selectedSegmentIndex==0 ) {
        
        NSLog(@"asdf");
    }
    
    else if ( sender.selectedSegmentIndex==1 ) {
        
        NSLog(@"asdf");
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 * Update the view once it appears.
 */
-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [untechable printNavigation:[self navigationController]];
    
    [untechable setOrSaveVars:SAVE];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [self updateUI];
}

/*
 Hide keyboard on done button of keyboard press
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
// ________________________     Custom functions    ___________________________

- (void)setDefaultModel {
    _table01Data = [[NSMutableArray alloc] init];
    [_table01Data addObject:@{@"type":@"image", @"imgPath":@"logo-icloud.jpg", @"text":@""}];
    [_table01Data addObject:@{@"type":@"image", @"imgPath":@"logo-Exchange.jpg", @"text":@""}];
    [_table01Data addObject:@{@"type":@"image", @"imgPath":@"logo-Google.jpg", @"text":@""}];
    [_table01Data addObject:@{@"type":@"image", @"imgPath":@"logo-Yahoo.jpg", @"text":@""}];
    [_table01Data addObject:@{@"type":@"image", @"imgPath":@"logo-Aol.jpg", @"text":@""}];
    [_table01Data addObject:@{@"type":@"image", @"imgPath":@"logo-outlook.jpg", @"text":@""}];
    [_table01Data addObject:@{@"type":@"image", @"imgPath":@"logo-other.png", @"text":@""}];
}


#pragma mark - Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.keyboardControls setActiveField:textField];
}

#pragma mark - Text View Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.keyboardControls setActiveField:textView];
}

#pragma mark - Keyboard Controls(< PREV , NEXT > )  Delegate

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    	
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [self.view endEditing:YES];
}

#pragma mark -  UI functions
-(void)updateUI
{
    
    [_lbl1 setTextColor:defGray];
    _lbl1.font = [UIFont fontWithName:APP_FONT size:20];
    
    [self.inputEmail setTextColor:defGreen];
    self.inputEmail.font = [UIFont fontWithName:APP_FONT size:16];
    self.inputEmail.delegate = self;
    self.inputEmail.text = untechable.email;
    
    [self.inputPassword setTextColor:defGreen];
    self.inputPassword.font = [UIFont fontWithName:APP_FONT size:16];
    self.inputPassword.delegate = self;
    self.inputPassword.text = untechable.password;
    
    [self.inputMsg setTextColor:defGreen];
    self.inputMsg.font = [UIFont fontWithName:APP_FONT size:16];
    self.inputMsg.delegate = self;
    self.inputMsg.text = untechable.respondingEmail;
    
}
#pragma mark -  Navigation functions

- (void)setNavigationDefaults{
    
    defGreen = [UIColor colorWithRed:66.0/255.0 green:247.0/255.0 blue:206.0/255.0 alpha:1.0];//GREEN
    defGray = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1.0];//GRAY
    
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES]; //show navigation bar
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

-(void)setNavigation:(NSString *)callFrom
{
    if([callFrom isEqualToString:@"viewDidLoad"])
    {
        
        
        // Left Navigation ________________________________________________________________________________________________________
        backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        backButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_LEFT_SIZE];
        [backButton setTitle:TITLE_BACK_TXT forState:normal];
        [backButton setTitleColor:defGray forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(btnBackTouchStart) forControlEvents:UIControlEventTouchDown];
        [backButton addTarget:self action:@selector(btnBackTouchEnd) forControlEvents:UIControlEventTouchUpInside];
        
        
        backButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        NSMutableArray  *leftNavItems  = [NSMutableArray arrayWithObjects:leftBarButton,nil];
        
        [self.navigationItem setLeftBarButtonItems:leftNavItems]; //Left button ___________
        
        
        // Center title ________________________________________
        self.navigationItem.titleView = [untechable.commonFunctions navigationGetTitleView];        
        
        // Right Navigation ________________________________________
        
        nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        [nextButton addTarget:self action:@selector(onFinish) forControlEvents:UIControlEventTouchUpInside];
        nextButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [nextButton setTitle:@"FINISH" forState:normal];
        [nextButton setTitleColor:defGray forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(btnNextTouchStart) forControlEvents:UIControlEventTouchDown];
        [nextButton addTarget:self action:@selector(btnNextTouchEnd) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        nextButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton,nil];
        
        [self.navigationItem setRightBarButtonItems:rightNavItems];//Right buttons ___________
        
        
    }
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

-(void)btnBackTouchStart{
    [self setBackHighlighted:YES];
}
-(void)btnBackTouchEnd{
    [self setBackHighlighted:NO];
    [self onBack];
}
- (void)setBackHighlighted:(BOOL)highlighted {
    (highlighted) ? [backButton setBackgroundColor:defGreen] : [backButton setBackgroundColor:[UIColor clearColor]];
}

-(void)onBack{
    [untechable goBack:self.navigationController];
}

-(void)onFinish {

    [self storeSceenVarsInDic];
    NSLog(@"onFinish dic = %@ ",untechable.dic);
    
    
    if( [APP_IN_MODE isEqualToString:TESTING] ){
        [self next:@"GO_TO_THANKYOU"];
    } else {
        [self sendToApi];
    }
    
}
-(void)storeSceenVarsInDic
{
    untechable.email = _inputEmail.text;
    untechable.password = _inputPassword.text;
    untechable.respondingEmail = _inputMsg.text;
    [untechable setOrSaveVars:SAVE];
}

-(void) sendToApi{

    [self changeNavigation:@"ON_FINISH"];

    //Background work
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        [self sendToApiAfterTask];
        
    });
}
                   
-(void) sendToApiAfterTask
{
    //NSLog(@"API_SAVE = %@ ",API_SAVE);
    //NSLog(@"[untechable getRecFilePath]: %@",[untechable getRecFilePath]);
    //NSLog(@"[untechable getRecFileName]: %@",[untechable getRecFileName]);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:API_SAVE]];
    [request setHTTPMethod:@"POST"];

    NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // -------------------- ---- Audio Upload Status ---------------------------\\
    //pass MediaType file
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"recording\"; filename=\"%@\"\r\n",[untechable getRecFileName]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: audio/caf\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // get the audio data from main bundle directly into NSData object
    NSData *audioData;
    audioData = [[NSData alloc] initWithContentsOfFile:[NSURL URLWithString:[untechable getRecFilePath]]];
    // add it to body
    [body appendData:audioData];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    NSArray *stringVarsAry = [[NSArray alloc] initWithObjects:@"eventId", @"userId", @"paid",
                              @"timezoneOffset", @"spendingTimeTxt", @"startDate", @"endDate", @"hasEndDate"
                             ,@"twillioNumber", @"location", @"emergencyNumber", @"hasRecording"
                             ,@"socialStatus", @"fbAuth", @"fbAuthExpiryTs" , @"twitterAuth",@"twOAuthTokenSecret",   @"linkedinAuth"
                             ,@"email", @"password", @"respondingEmail"
                             ,nil];
    
    for (NSString* key in untechable.dic) {
        BOOL sendIt =   NO;
        id value    =   [untechable.dic objectForKey:key];
        
        if([key isEqualToString:@"emergencyContacts"] ){
            value = [untechable.commonFunctions convertDicIntoJsonString:value];
            sendIt = YES;
        }
        
        if( sendIt || [stringVarsAry containsObject:key]){
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
    }//for
    
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    

    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    // NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];

    [self setNextHighlighted:NO];
    
    BOOL errorOnFinish = NO;
    
    if( returnData != nil ){
        
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"In response of save api: %@",dict);
        
        NSString *message = @"";
        
        if( [[dict valueForKey:@"status"] isEqualToString:@"OK"] ) {
            //message = @"Untechable saved successfully";
            
            untechable.twillioNumber = [dict valueForKey:@"twillioNumber"];
            untechable.eventId = [dict valueForKey:@"eventId"];
            untechable.savedOnServer    = YES;
            untechable.hasFinished = YES;
            [untechable setOrSaveVars:SAVE];
            
        } else{
            message = [dict valueForKey:@"message"];
            if( !([[dict valueForKey:@"eventId"] isEqualToString:@"0"]) ) {
                untechable.eventId = [dict valueForKey:@"eventId"];
                [untechable setOrSaveVars:SAVE];
            }
            
            errorOnFinish = YES;
        }
        
        if( !([message isEqualToString:@""]) ) {
            dispatch_async( dispatch_get_main_queue(), ^{
                [self showMsgOnApiResponse:message];
            });
        }
    }
    else{
        errorOnFinish = YES;
    }
    
    
    if( errorOnFinish ){
        dispatch_async( dispatch_get_main_queue(), ^{
            [self changeNavigation:@"ERROR_ON_FINISH"];
        });
    }
    else{
        dispatch_async( dispatch_get_main_queue(), ^{
            [self changeNavigation:@"ON_FINISH"];
            [self next:@"GO_TO_THANKYOU"];
        });
    }
    
    
}
-(void)changeNavigation:(NSString *)option
{
    // DISABLE NAVIGATION ON SEND DATA TO API
    if([option isEqualToString:@"ON_FINISH"] ){
    
        nextButton.userInteractionEnabled = NO;
        backButton.userInteractionEnabled = NO;
        
        [self showHidLoadingIndicator:YES];
        
    }
    
    // RE-ENABLE NAVIGATION WHEN ANY ERROR OCCURED
    else if([option isEqualToString:@"ERROR_ON_FINISH"] ){
        
        nextButton.userInteractionEnabled = YES;
        backButton.userInteractionEnabled = YES;
        
        [self showHidLoadingIndicator:NO];
        
        
    }
    
    // ON DATA SAVED TO API SUCCESSFULLY
    else if([option isEqualToString:@"GO_TO_THANKYOU"] ){
    
        [self next:@"GO_TO_THANKYOU"];
    }
}

-(void)next:(NSString *)after
{
    if( [after isEqualToString:@"GO_TO_THANKYOU"] ) {
        
        ThankyouController *thankyouController;
        thankyouController = [[ThankyouController alloc]initWithNibName:@"ThankyouController" bundle:nil];
        thankyouController.untechable = untechable;
        [self.navigationController pushViewController:thankyouController animated:YES];
        
    }
}
/**
 * Show / hide, a loding indicator in the right bar button.
 */
- (void)showHidLoadingIndicator:(BOOL)show {
    if( show ){
        nextButton.enabled = NO;
        backButton.enabled = NO;
        
        UIActivityIndicatorView *uiBusy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [uiBusy setColor:[UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0]];
        uiBusy.hidesWhenStopped = YES;
        [uiBusy startAnimating];
        
        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:uiBusy];
        [self.navigationItem setRightBarButtonItem:btn animated:NO];
    }
    else{
        nextButton.enabled = YES;
        backButton.enabled = YES;
        [self setNavigation:@"viewDidLoad"];
    }
}






-(void)showMsgOnApiResponse:(NSString *)message
{
    UIAlertView *temAlert = [[UIAlertView alloc ]
                             initWithTitle:@""
                             message:message
                             delegate:self
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
    [temAlert show];
    
    if( [message isEqualToString:@"Untechable created successfully"] ){
        
        /* //doing this app crashing bcz alert value nil
        //Go to main screen
        [self.navigationController popToRootViewControllerAnimated:YES];
        // Remove observers
        [[NSNotificationCenter defaultCenter] removeObserver:self];
         */
    }

}

- (IBAction)showEmailSettings1:(id)sender {
    [self hideAllViews];
    [UIView transitionWithView:self.view duration:0.5
                       options:UIViewAnimationOptionTransitionCurlUp //change to whatever animation you like
                    animations:^ { [self.view addSubview:_emailSetting1]; }
                    completion:^(BOOL finished){
                        
                    }];
    
}

- (IBAction)showEmailSettings2:(id)sender {
    [self hideAllViews];
    [UIView transitionWithView:self.view duration:0.5
                       options:UIViewAnimationOptionTransitionCurlUp //change to whatever animation you like
                    animations:^ { [self.view addSubview:_emailSetting2]; }
                    completion:^(BOOL finished){
                        
                    }];
    
}


-(void)hideAllViews {
    [_emailSetting1 removeFromSuperview];
    [_emailSetting2 removeFromSuperview];
}


//3
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = 0;
    
    if( tableView == _tableView0 )
    count = _table01Data.count;
    
    return count;
}
//4
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if( tableView == _tableView0 ) {
        static NSString *cellId = @"EmailTableViewCell";
        EmailTableViewCell *cell = (EmailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EmailTableViewCell" owner:self options:nil];
            cell = (EmailTableViewCell *)[nib objectAtIndex:0];
        }
        
        NSString *imgPath = [[_table01Data objectAtIndex:indexPath.row] objectForKey:@"imgPath"];
        cell.button1.tag = indexPath.row;
        [cell.button1 setBackgroundImage:[UIImage imageNamed:imgPath] forState:UIControlStateNormal];
        [cell.button1 addTarget:self action:@selector(clickedOnEmailOption:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }
    else {
        return cell;
    }
}


//Allow cell editing(swip to delete)
// Override to support editing the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}


-(IBAction)clickedOnEmailOption:(id)sender
{
    UIButton *btn = sender;
    NSLog(@"btn tag %i", btn.tag);
    if ( btn.tag == 6 ){
        
        [self hideAllViews];
        [UIView transitionWithView:self.view duration:0.5
                           options:UIViewAnimationOptionTransitionCurlUp //change to whatever animation you like
                        animations:^ { [self.view addSubview:_emailSetting1]; }
                        completion:^(BOOL finished){
                            
                        }];
        
    }
    //[self showEmailSettings2:nil];
}

@end
