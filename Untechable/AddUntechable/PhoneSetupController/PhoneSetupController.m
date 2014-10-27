//
//  PhoneSetupController.m
//  Untechable
//
//  Created by ABDUL RAUF on 24/09/2014.
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//

#import "PhoneSetupController.h"
#import "SocialnetworkController.h"
#import "Common.h"
#import "BSKeyboardControls.h"
#import "InviteScreen/InviteFriendsController.h"
#import "RecordController.h"

# define MSG_FORWADING_1 @"Get A Number"
# define MSG_FORWADING_2 @"Please wait..."
# define MSG_FORWADING_3 @"Forward call here"



@interface PhoneSetupController (){
    NSString *tableViewFor;
    
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    NSTimer *recTimer;
    NSTimer *playTimer;
    int timerRec, timerPlay;
    NSString *recFilePath;
    NSURL *outputFileURL;
    BOOL configuredRecorder, configuredPlayer;
    
}


@property (strong, nonatomic) IBOutlet UILabel *lbl1CustomVoic;
@property (strong, nonatomic) IBOutlet UILabel *lbl2CustomVoic;
@property (strong, nonatomic) IBOutlet UILabel *lbl3CustomVoic;
@property (strong, nonatomic) IBOutlet UILabel *lblRecTime;


@property (strong, nonatomic) IBOutlet UIButton *btnforwardingNumber;
@property (strong, nonatomic) IBOutlet UITextField *inputForwadingNumber;

@property (strong, nonatomic) IBOutlet UILabel *lblLocation;
@property (strong, nonatomic) IBOutlet UITextField *inputLocation;


@property (strong, nonatomic) IBOutlet UILabel *lblEmergencyNumber;
@property (strong, nonatomic) IBOutlet UITextField *inputEmergencyNumber;

@property (strong, nonatomic) IBOutlet UIButton *btnImport;

@property (strong, nonatomic) IBOutlet UITableView *contactsTableView;
@property (strong, nonatomic) IBOutlet UILabel *lblCanContactTxt;


@property (strong, nonatomic) UIAlertView *importContacts, *getANumberAlert;

@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

@end

@implementation PhoneSetupController



@synthesize untechable;
@synthesize btnPlay,btnRec,progressBar;



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
    
    [self setDefaultModel];
    
    [self setNavigationDefaults];
    [self setNavigation:@"viewDidLoad"];
    
    [self tableViewSR:@"start" callFor:@"contactsTableView"];
    
    NSArray *fields = @[ self.inputEmergencyNumber ];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
    
    [self initPlayRecSetting];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self updateUI];
}

/**
 * Update the view once it appears.
 */
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [untechable setOrSaveVars:SAVE];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 Hide keyboard on done button of keyboard press
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

// ________________________     Custom functions    ___________________________
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

#pragma mark - Keyboard Controls Delegate

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    /*
    UIView *view;
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        view = field.superview.superview;
    } else {
        view = field.superview.superview.superview;
    }
    
    [self.tableView scrollRectToVisible:view.frame animated:YES];
     */
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [self.view endEditing:YES];
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
        
       
         // Left Navigation ___________________________________________________________
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
       
        
        // Center title __________________________________________________
        self.navigationItem.titleView = [untechable.commonFunctions navigationGetTitleView];
        
        
        // Right Navigation ______________________________________________
        nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        [nextButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
        nextButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [nextButton setTitle:TITLE_NEXT_TXT forState:normal];
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

-(void)onNext{

    [self storeSceenVarsInDic];
    
    [self setNextHighlighted:NO];
    
    BOOL goToNext = YES;
    
    if( [untechable.twillioNumber isEqualToString:@""] ){
        UIAlertView *temAlert = [[UIAlertView alloc ]
                                 initWithTitle:@""
                                 message:@"Forwarding number required."
                                 delegate:self
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [temAlert show];
    }
    else if( goToNext ) {
        RecordController *recordController;
        recordController = [[RecordController alloc]initWithNibName:@"RecordController" bundle:nil];
        recordController.untechable = untechable;
        [self.navigationController pushViewController:recordController animated:YES];
    }
}

-(void)storeSceenVarsInDic{
    //untechable.twillioNumber = _inputForwadingNumber.text;
    //untechable.location = _inputLocation.text;
    untechable.emergencyNumber = _inputEmergencyNumber.text;
    //untechable.emergencyContacts = untechable.emergencyContacts; //no need
    
    [untechable setOrSaveVars:SAVE];
}

#pragma mark -  Model funcs
-(void)setDefaultModel{
    untechable.commonFunctions = [[CommonFunctions alloc] init];
}

#pragma mark -  UI functions
-(void)updateUI
{
    
    [_lbl1CustomVoic setTextColor:defGray];
    _lbl1CustomVoic.font = [UIFont fontWithName:APP_FONT size:20];

    [_lbl2CustomVoic setTextColor:defGray];
    _lbl2CustomVoic.font = [UIFont fontWithName:APP_FONT size:15];
    
    [_lbl3CustomVoic setTextColor:defGray];
    _lbl3CustomVoic.font = [UIFont fontWithName:APP_FONT size:15];
    
    [_lblRecTime setTextColor:defGray];
    _lblRecTime.font = [UIFont fontWithName:APP_FONT size:15];
    
    [_lblEmergencyNumber setTextColor:defGray];
    _lblEmergencyNumber.font = [UIFont fontWithName:APP_FONT size:20];
    
    [self.inputEmergencyNumber setTextColor:defGreen];
    self.inputEmergencyNumber.font = [UIFont fontWithName:APP_FONT size:16];
    self.inputEmergencyNumber.delegate = self;
    [self.inputEmergencyNumber setText:untechable.emergencyNumber];

    [self tableViewSR:@"reStart" callFor:@"contactsTableView"];
    
    [self.btnImport setTitleColor:defGray forState:UIControlStateNormal];
    self.btnImport.titleLabel.font = [UIFont fontWithName:APP_FONT size:20];
    
    [_lblCanContactTxt setTextColor:defGray];
    _lblCanContactTxt.font = [UIFont fontWithName:APP_FONT size:15];
    
}

#pragma mark -  Table view functions
-(void)tableViewSR:(NSString*)startRestart callFor:callFor{
    
    if( [startRestart isEqualToString:@"start"] ){
        
        if( [callFor isEqualToString:@"contactsTableView"] ) {
            tableViewFor = @"contactsTableView";
            _contactsTableView.allowsMultipleSelectionDuringEditing = NO;
            _contactsTableView.dataSource = self;
        }
    }
    else if( [startRestart isEqualToString:@"reStart"] ){
        
        if( [callFor isEqualToString:@"contactsTableView"] ) {
            //NSLog(@"tableViewSR restart untechable.emergencyContacts = %@",untechable.emergencyContacts);
            _contactsTableView.allowsMultipleSelectionDuringEditing = NO;
            tableViewFor = @"contactsTableView";
            [_contactsTableView reloadData];
        }
    }
    
}
-(NSInteger)getCountOf:(NSString *)contOf {
    NSInteger count = 0;

    if([contOf isEqualToString:@"contactsTableView"]) {
        NSArray * allKeys = [untechable.emergencyContacts allKeys];
        count   =   [allKeys count];
    }
    
    
   // NSLog(@"getCountForTableView Count of %@ : %ld", tableViewFor, (long)count);
    return count;
}

//3
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self getCountOf:tableViewFor];
}
//4
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //5
    static NSString *cellIdentifier = @"SettingsCell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    UITableViewCell *cell = nil;
    //5.1 you do not need this if you have set SettingsCell as identifier in the storyboard (else you can remove the comments on this code)
    if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
       }

    if([tableViewFor isEqualToString:@"contactsTableView"]) {
        
         //get sorted keys
         NSArray *arrayOfKeys = [[untechable.emergencyContacts allKeys] sortedArrayUsingSelector: @selector(compare:)];
        //NSLog(@"Keys: %@", arrayOfKeys);
        //NSArray *arrayOfValues = [untechable.emergencyContacts allValues];
        //NSLog(@"Values: %@", arrayOfValues);
        
        
        //6
        NSString *name = [arrayOfKeys objectAtIndex:indexPath.row];
        NSString *number = [untechable.emergencyContacts objectForKey:name];
        
        //7
        [cell.textLabel setText:name];
        cell.textLabel.textColor = defGreen;
        [cell.detailTextLabel setText:number];
        cell.detailTextLabel.textColor = defGray;
    }
    return cell;
}

// Override to support editing the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    //add code here for when you hit delete
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        if( [tableViewFor isEqualToString:@"contactsTableView"] ) {

            [untechable.commonFunctions deleteKeyFromDic:untechable.emergencyContacts delKeyAtIndex:indexPath.row];
            
            [self tableViewSR:@"reStart" callFor:@"contactsTableView"];
        }
    }
    
}




#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   if(alertView == _importContacts && buttonIndex == 1) {
        [self importContactsAfterAllow];
    }
}


#pragma mark -  Import Contacts
//Show select contacts screen
- (IBAction)importContacts:(id)sender {
    InviteFriendsController *ifc;
    ifc = [[InviteFriendsController alloc]initWithNibName:@"InviteFriendsController" bundle:nil];
    ifc.untechable = untechable;
    [self.navigationController pushViewController:ifc animated:YES];
}

- (IBAction)importContacts2:(id)sender {
    _importContacts = [[UIAlertView alloc ]
                                       initWithTitle:@""
                                       message:@"Untechable want to import your contacts"
                                       delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:@"Allow" ,
                                   nil];
    [_importContacts show];
    
}
-(void)importContactsAfterAllow {
    [self getAllContacts];
    [self tableViewSR:@"reStart" callFor:@"contactsTableView"];
}


-(void)getAllContacts{
    CFErrorRef *error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    
    for(int i = 0; i < numberOfPeople; i++) {
        
        ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
        
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        
        #ifdef DEBUG
                NSLog(@"Name:%@ %@", firstName, lastName);
        #endif
      
        
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
            NSString *phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);

            #ifdef DEBUG
                NSLog(@"phone:%@", phoneNumber);
            #endif
        }
        
        NSLog(@"=============================================");
        
    }
}

#pragma mark -  Recording functions
-(void)initPlayRecSetting
{
    
    timerRec = 0;
    timerPlay = 0;
    configuredRecorder = NO;
    configuredPlayer = NO;
    
    // Disable Stop/Play button when application launches
    [self setEnable:btnPlay enable:NO];
    
    recFilePath = [untechable getRecFilePath];
    outputFileURL = [NSURL URLWithString:recFilePath];
    
    //[self playTapped];
    
    [self configuredPlayerFn];
    
    NSLog(@"player.duration: %f",player.duration);
}

- (IBAction)recordPauseTapped:(id)sender {
    
    [self stopPlay];
    
    if ( recTimer == nil ) {
        
        [self configureRecorder];
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [recorder record];
        [self timerInit:YES callFor:1];
        
    } else {
        [self stopRec];
    }
}

- (IBAction)stopTapped:(id)sender {
    [self stopRec];
}
-(void)stopRec{
    
    if ( recTimer != nil ) {
        [recorder stop];
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:NO error:nil];
        
        untechable.hasRecording = YES;
        [self timerInit:NO callFor:1];
    }
}
-(void) stopAllTask
{
    [self stopRec];
    [self stopPlay];
}

-(void)stopPlay{
    if ( playTimer != nil ) {
        [player stop];
        [self timerInit:NO callFor:2];
    }
}


- (IBAction)playTapped:(id)sender {
    [self playTapped];
    
}
-(void)playTapped
{
    [self stopRec];
    
    
    [self configuredPlayerFn];
    
    if ( player.duration > 0.0 ) {
        if( playTimer == nil ){
            [player play];
            [self timerInit:YES callFor:2];
        }
        else{
            [self stopPlay];
        }
    }
}


- (void)timerInit :(BOOL) init callFor:(int)callFor{
    
    //Record
    if( callFor == 1 ){
        
        if( init ){
            //this is nstimer to initiate update method
            recTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateRecSlider) userInfo:nil repeats:YES];
            _lblRecTime.text = @"00:00";
        }
        else{
            [recTimer invalidate];
            recTimer = nil;
        }
        
    }
    //Play timer
    else if( callFor == 2 ){
        
        if( init ){
            //this is nstimer to initiate update method
            playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updatePlaySlider) userInfo:nil repeats:YES];
            _lblRecTime.text = @"00:00";
            
        }
        else{
            [playTimer invalidate];
            playTimer = nil;
        }
    }
    
    
    if( !(init) ){
        progressBar.progress = 1.0;
    }
    
}

- (void)updateRecSlider {
    NSLog(@"updateRecSlider counter: %i", timerRec++);
    // Update the slider about the music time
    if ( recorder.recording ) {
        [self updateLableOf:@"recordTimeLabel"];
    }
}

-(void)updateLableOf:(NSString *)labelOf
{
    
    if( [labelOf isEqualToString:@"recordTimeLabel"] ) {
        float minutes = floor(recorder.currentTime/60);
        float seconds = recorder.currentTime - (minutes * 60);
        
        NSString *time = [[NSString alloc]
                          initWithFormat:@"%02.0f:%02.0f",
                          minutes, seconds];
        NSLog(@"recordTimeLabel time: %@", time);
        _lblRecTime.text = time;
        
        [self updateSlider:1 seconds:seconds];
        
        if( seconds >= RECORDING_LIMIT_IN_SEC ){
            [self stopRec];
        }
    }
    else if( [labelOf isEqualToString:@"playTimeLabel"] ) {
        float minutes = floor(player.currentTime/60);
        float seconds = player.currentTime - (minutes * 60);
        
        NSString *time = [[NSString alloc]
                          initWithFormat:@"%02.0f:%02.0f",
                          minutes, seconds];
        NSLog(@"player time: %@", time);
        _lblRecTime.text = time;
        
        [self updateSlider:2 seconds:seconds];
    }
    else if( [labelOf isEqualToString:@"playTimeLabelOfRecorded"] ) {
        float minutes = floor(player.duration/60);
        float seconds = player.duration - (minutes * 60);
        
        NSString *time = [[NSString alloc]
                          initWithFormat:@"%02.0f:%02.0f",
                          minutes, seconds];
        NSLog(@"player time: %@", time);
        _lblRecTime.text = time;
        
        [self updateSlider:2 seconds:0.0];
    }
}

- (void)updatePlaySlider {
    NSLog(@"updatePlaySlider counter: %i", timerPlay++);
    // Update the slider about the music time
    //if ( recorder.recording ) {
    [self updateLableOf:@"playTimeLabel"];
    //}
}

-(void)updateSlider:(int)callFor seconds:(float)seconds {
    //1 //rec
    //2 play
    
    float progIn1Percentage;
    
    if( callFor == 1 )
    progIn1Percentage = (seconds/RECORDING_LIMIT_IN_SEC);
    else
    progIn1Percentage = (seconds/player.duration);
    
    progressBar.progress = progIn1Percentage;
}

#pragma mark - AVAudioRecorderDelegate
- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    [self stopRec];
}



#pragma mark - AVAudioPlayerDelegate

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self stopPlay];
}


-(void)configureRecorder
{
    configuredRecorder = YES;
    if( configuredRecorder ) {
        // Setup audio session
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
        NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc]init];
        [recordSetting setValue :[NSNumber  numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:11025.0] forKey:AVSampleRateKey];
        [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
        [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        
        
        // Initiate and prepare the recorder
        recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
        recorder.delegate = self;
        recorder.meteringEnabled = YES;
        [recorder prepareToRecord];
    }
}

-(BOOL)configuredPlayerFn
{
    BOOL configured = NO;
    NSError *error;
    player = [[AVAudioPlayer alloc]
              initWithContentsOfURL:outputFileURL
              error:&error];
    if (error)
    {
        NSLog(@"Error in audioPlayer: %@",
              [error localizedDescription]);
    } else {
        player.delegate = self;
        [player prepareToPlay];
        
        configured = YES;
    }
    
    [self setEnable:btnPlay enable:YES];
    [self updateLableOf:@"playTimeLabelOfRecorded"];
    
    return configured;
}

-(void) setEnable:(UIButton *)btn enable:(BOOL)enable
{
    //[btn setEnabled:enable];
}

@end
