//////////////////////////////////////
//
//   Notex
//   created by FV iMAGINATION
//   ©2014
//
//////////////////////////////////////


#import "NoteEditor.h"
#import "NotesList.h"

// Keyboard with toolbar on its top
#import "KeyboardToolbar.h"
#import "ToolbarButton.h"

#import <DropboxSDK/DropboxSDK.h>


@interface NoteEditor ()

@end

@implementation NoteEditor 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - VIEW DID LOAD ********************
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Calls the restClient for Dropbox
    restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    restClient.delegate = self;
    
    
    // Initializes the text string
    textStr = _noteTextView.text;
    
    
    // init the Custom Keyboard
    [self initKeyboardButtons];
    
    
    // Fill Title and Text if we got to this Screen
    // by selecting a tableView's row on the NotesList VC
    if (_notesEntity) {
        _noteTitleTxt.text = _notesEntity.noteTitle;
        _noteTextView.text = _notesEntity.noteText;
        colorName = _notesEntity.noteColor;
    }
    
    
    // Load Font size =========
    fontSize = [[NSUserDefaults standardUserDefaults] floatForKey:@"fontSize"];
    UIFont *font = [UIFont fontWithName:@"Comfortaa-Light" size:fontSize + 14.0];
    _noteTextView.font = font;
    
    
    NSString *colorStr = [NSString stringWithFormat:@"%@", _notesEntity.noteColor];
        if ([colorStr isEqualToString:@"red"]) {
            _topView.backgroundColor = red;
        } else if ([colorStr isEqualToString:@"blue"]) {
            _topView.backgroundColor = blue;
        } else if ([colorStr isEqualToString:@"yellow"]) {
            _topView.backgroundColor = yellow;
        } else if ([colorStr isEqualToString:@"purple"]) {
            _topView.backgroundColor = purple;
        } else if ([colorStr isEqualToString:@"green"]) {
            _topView.backgroundColor = green;
        } else if ([colorStr isEqualToString:@"deepBlue"]) {
            _topView.backgroundColor = deepBlue;
        }
 
    
    
    
#pragma mark - LONGPRESS MENU SETUP =========================
    
    // Imports the FVLongPressMenuView into the ViewController
    FVLongPressMenuView *theOverlay = [[FVLongPressMenuView alloc] init];
    theOverlay.dataSource = self;
    theOverlay.delegate = self;
    
    // Adds the LongPress Gesture to the Root View
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:theOverlay action:@selector(longPressDetected:)];
    [self.view setUserInteractionEnabled:YES];
    [_noteTextView addGestureRecognizer: longPressRecognizer];
    
}
- (NSInteger) numberOfMenuItems  {
    // Here you set the number of buttons that will appear after a long press on the screen
    return 10;
}

// Assing an Image to every Button ****************
-(UIImage*) imageForItemAtIndex:(NSInteger)index
{
    // This is a String that allows you to just put the image names on every case (for every button)
    NSString *imageName = nil;
    
    // This switch statement sets the images of the buttons (the first buttons will have index "0")
    switch (index) {
        case 0: imageName = @"red";
            break;
        case 1: imageName = @"blue";
            break;
        case 2: imageName = @"yellow";
            break;
        case 3: imageName = @"purple";
            break;
        case 4: imageName = @"green";
            break;
        case 5: imageName = @"deepBlue";
            break;
        case 6: imageName = @"dropbox";
            break;
        case 7: imageName = @"shareIcon";
            break;
        case 8: imageName = @"minus";
            break;
        case 9: imageName = @"plus";
            break;
            
        default:  break;
    }
    return [UIImage imageNamed:imageName];
}

// Method for when you select a button ************
- (void) didSelectItemAtIndex:(NSInteger)selectedIndex forMenuAtPoint:(CGPoint)point
{
    switch (selectedIndex) {
        case 0:
            colorName = @"red";
            _topView.backgroundColor = red;
            break;
        case 1:
            colorName = @"blue";
            _topView.backgroundColor = blue;
            break;
        case 2:
             colorName = @"yellow";
            _topView.backgroundColor = yellow;
            break;
        case 3:
             colorName = @"purple";
            _topView.backgroundColor = purple;
            break;
        case 4:
            colorName = @"green";
            _topView.backgroundColor = green;
            break;
        case 5:
             colorName = @"deepBlue";
            _topView.backgroundColor = deepBlue;
            break;
        case 6:
            [self uploadNoteToDB];
            break;
        case 7:
            [self shareNote];
            break;
            
        case 8:
            // Decrease Font size
            fontSize = fontSize -3;
            [self saveFontAttributes];
            break;
        case 9:
            // Increase Font size
            fontSize = fontSize +3;
            [self saveFontAttributes];
            break;

            
        default: break;
    }

}
//**************** END OF LONGPRESS MENU SETUP ***********************




-(void)saveFontAttributes {
    // Saves the fontName and Size
    [[NSUserDefaults standardUserDefaults] setFloat:fontSize forKey:@"fontSize"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIFont *font = [UIFont fontWithName: @"Comfortaa-Light" size:fontSize + 14.0];
    _noteTextView.font = font;
}



#pragma mark - KEYBOARD BUTTONS INTO ITS TOOLBAR ***********************
-(void)initKeyboardButtons {
    
    // List of keyboard's toolbar buttons ======
    ToolbarButton *doneButt = [ToolbarButton buttonWithTitle:@"⇣"];
    ToolbarButton *minButt = [ToolbarButton buttonWithTitle:@"-"];
    ToolbarButton *plusButt = [ToolbarButton buttonWithTitle:@"+"];
    ToolbarButton *comma = [ToolbarButton buttonWithTitle:@","];
    ToolbarButton *slashButt = [ToolbarButton buttonWithTitle:@"/"];
    ToolbarButton *openParenth = [ToolbarButton buttonWithTitle:@"("];
    ToolbarButton *closeParenth = [ToolbarButton buttonWithTitle:@")"];
    ToolbarButton *and = [ToolbarButton buttonWithTitle:@"&"];
    ToolbarButton *atButt = [ToolbarButton buttonWithTitle:@"@"];
    ToolbarButton *quotes = [ToolbarButton buttonWithTitle:@"''"];
    ToolbarButton *doublePoints = [ToolbarButton buttonWithTitle:@":"];
    ToolbarButton *question = [ToolbarButton buttonWithTitle:@"?"];
    ToolbarButton *equals = [ToolbarButton buttonWithTitle:@"="];
    ToolbarButton *usd = [ToolbarButton buttonWithTitle:@"$"];
    ToolbarButton *percent = [ToolbarButton buttonWithTitle:@"%"];
    ToolbarButton *hash = [ToolbarButton buttonWithTitle:@"#"];
    ToolbarButton *asterisc = [ToolbarButton buttonWithTitle:@"*"];
    ToolbarButton *snake = [ToolbarButton buttonWithTitle:@"~"];
    ToolbarButton *check = [ToolbarButton buttonWithTitle:@"✓"];
    ToolbarButton *half = [ToolbarButton buttonWithTitle:@"½"];
    ToolbarButton *openTag = [ToolbarButton buttonWithTitle:@"<"];
    ToolbarButton *closeTag = [ToolbarButton buttonWithTitle:@">"];
    ToolbarButton *openGraph = [ToolbarButton buttonWithTitle:@"{"];
    ToolbarButton *closeGraph = [ToolbarButton buttonWithTitle:@"}"];


    
    // doneButt *******
    [doneButt addEventHandler:^{
        [self saveNote];
        //Hides the keyboard
        [self.view endEditing:true];
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    // ======== FONT BUTTONS ===========
    [minButt addEventHandler:^{
        [_noteTextView insertText:@"-"];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [plusButt addEventHandler:^{
        [_noteTextView insertText: @"+"];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [comma addEventHandler:^{
        [_noteTextView insertText: @","];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [slashButt addEventHandler:^{
        [_noteTextView insertText: @"/"];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [openParenth addEventHandler:^{
        [_noteTextView insertText: @"("];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [closeParenth addEventHandler:^{
        [_noteTextView insertText: @")"];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [and addEventHandler:^{
        [_noteTextView insertText: @"&"];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [atButt addEventHandler:^{
        [_noteTextView insertText: @"@"];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [quotes addEventHandler:^{
        [_noteTextView insertText: @"''"];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [doublePoints addEventHandler:^{
        [_noteTextView insertText: @":"];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [question addEventHandler:^{
        [_noteTextView insertText: @"?"];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [equals addEventHandler:^{
        [_noteTextView insertText: @"="];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [usd addEventHandler:^{
        [_noteTextView insertText: @"$"];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [percent addEventHandler:^{
        [_noteTextView insertText: @"%"];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [hash addEventHandler:^{
        [_noteTextView insertText: @"#"];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [asterisc addEventHandler:^{
        [_noteTextView insertText: @"*"];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [snake addEventHandler:^{
        [_noteTextView insertText: @"~"];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [check addEventHandler:^{
        [_noteTextView insertText: @"✓"];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [half addEventHandler:^{
        [_noteTextView insertText: @"½"];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [openTag addEventHandler:^{
        [_noteTextView insertText: @"<"];
    } forControlEvents:UIControlEventTouchUpInside];

    [closeTag addEventHandler:^{
        [_noteTextView insertText: @">"];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [openGraph addEventHandler:^{
        [_noteTextView insertText: @"{"];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [closeGraph addEventHandler:^{
        [_noteTextView insertText: @"}"];
    } forControlEvents:UIControlEventTouchUpInside];
    

    
    // Creates a Keyboard Toolbar, add all of your buttons above
    // and set it as your TextView's inputAcessoryView
    _noteTextView.inputAccessoryView = [KeyboardToolbar toolbarViewWithButtons:
  @[
    doneButt,
    minButt, plusButt,
    slashButt,
    openParenth, closeParenth,
    and,
    atButt,
    quotes,
    doublePoints,
    question,
    equals,
    usd,
    percent,
    hash,
    asterisc,
    snake,
    check,
    half,
    openTag, closeTag,
    openGraph, closeGraph
    ]];

}



//  Moves the cursor from the textField to the textView by pressing NEXT on keyboard ************
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == _noteTitleTxt){
        [_noteTextView becomeFirstResponder];
    }
    return YES;
}


#pragma mark - noteTxt resizes by keyboard showing/hiding **********
-(void)viewDidAppear:(BOOL)animated  {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated  {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notif {
    //Sets TextView size when keyboards shows
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )  {
        // iPad  ****
        _noteTextView.frame = CGRectMake(0, 44, 768, 672);
    
    } else {
        // iPhone 5  ****
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
        _noteTextView.frame = CGRectMake(0, 44, 320, 260);
        } else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        // iPhone 4  ****
        _noteTextView.frame = CGRectMake(0, 44, 320, 170);
        } else if ([[UIScreen mainScreen] bounds].size.width == 375) {
        // iPhone 6  ****
        _noteTextView.frame = CGRectMake(0, 44, 375, 365);
        } else if ([[UIScreen mainScreen] bounds].size.width == 414) {
        // iPhone 6+  ****
        _noteTextView.frame = CGRectMake(0, 44, 414, 424);
        }
        
    }
}

- (void)keyboardWillHide:(NSNotification *)notif {
    //Sets TextView size when keyboards hides
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )  {
        // iPad ****
          _noteTextView.frame = CGRectMake(0, 44, 768, 920);
        
    } else {
        // iPhone 5  ****
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
        _noteTextView.frame = CGRectMake(0, 44, 320, 464);
        } else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        // iPhone 4  ****
        _noteTextView.frame = CGRectMake(0, 44, 320, 386);
        } else if ([[UIScreen mainScreen] bounds].size.width == 375) {
        // iPhone 6  ****
        _noteTextView.frame = CGRectMake(0, 44, 375, 570);
        } else if ([[UIScreen mainScreen] bounds].size.width == 414) {
        // iPhone 6+  ****
        _noteTextView.frame = CGRectMake(0, 44, 414, 640);
        }

    }
    
}





#pragma mark - SAVE NOTE *****************
-(void)saveNote {
    if (!_notesEntity)
    _notesEntity = (NotesEntity *)[NSEntityDescription insertNewObjectForEntityForName:@"NotesEntity" inManagedObjectContext: _managedObjectContext];
    
    // Saves data into CoreData attributes
    _notesEntity.noteTitle = _noteTitleTxt.text;
    _notesEntity.noteText = _noteTextView.text;
    _notesEntity.noteColor = colorName;
    
    //  Commit item to core data
    NSError *error;
    if (![_managedObjectContext save:&error])
        NSLog(@"failed saving records: %@", [error domain]);
}


#pragma mark - PRINT & SHARE NOTE BY EMAIL, FACEBOOK, TWITTER, ETC. *******************
-(void)shareNote {
    NSString *titleStr = _noteTitleTxt.text;
    NSString *textStr = _noteTextView.text;
    
    // Opens the printer dialog screen ******
    UISimpleTextPrintFormatter *printData = [[UISimpleTextPrintFormatter alloc]
                    initWithText: textStr];
    
    NSArray *shareItems = @[titleStr, textStr, printData];
    
    UIActivityViewController* activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems: shareItems
            applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[
    UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypePostToWeibo];
    
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )  {
        // iPad
        UIPopoverController *popCont = [[UIPopoverController alloc]initWithContentViewController:activityViewController];
        [popCont presentPopoverFromRect:CGRectZero inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:true];
    } else {
        // iPhone
        [self presentViewController:activityViewController animated:true completion:nil];
    }
}





#pragma mark - DROPBOX IMPLEMENTATION ==========

- (DBRestClient *)restClient {
    
    if (restClient == nil) {
        if ( [[DBSession sharedSession].userIds count] ) {
            restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
            restClient.delegate = self;
        }
    }
    
    return restClient;
}

-(void)uploadNoteToDB {
    
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
    
    // Writes a .txt file to the Local Documents Directory
    NSString *textToSave = [NSString stringWithFormat:@"%@", _noteTextView.text];
    NSString *filename = @"TextFile.txt";
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:filename];
    [textToSave writeToFile:localPath atomically:NO encoding:NSUTF8StringEncoding error:nil];
    
    // Uploads the txt file to Dropbox
    NSString *noteTileStr = [NSString stringWithFormat:@"%@.txt", _noteTitleTxt.text];
    NSString *destDir = @"/";
    [restClient uploadFile: noteTileStr toPath:destDir withParentRev:nil fromPath:localPath];

    
    
        // Adds a grey background view to better see the IndicatorView
        greyView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        greyView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self.view addSubview:greyView];
        
        // Adds an IndicatorView when uploading files to DB
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [indicatorView setCenter:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2)];
        [self.view addSubview:indicatorView];
        [indicatorView startAnimating];

    }


- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    // Stops and removes IndicatorView
    [indicatorView stopAnimating];
    [indicatorView removeFromSuperview];
    
    // Removes the grey bkg
    [greyView removeFromSuperview];
    
    // Note successfully uploaded ============
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DropBox"
    message:@"Note successfully uploaded!" delegate:nil
    cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
    
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    
        // Stops and removes IndicatorView
        [indicatorView stopAnimating];
        [indicatorView removeFromSuperview];
        
        // Removes the grey bkg
        [greyView removeFromSuperview];
    
        // Note upload failed ==========
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dropbox"
        message:@"Note upload failed!" delegate:nil
        cancelButtonTitle:@"Try again" otherButtonTitles:nil, nil];
        [alert show];
    
        NSLog(@"File upload failed with error: %@", error);
}
    
// =====================  END DROPBOX SESSION ==========================
// =====================================================================





#pragma mark - PREPARE FOR SEGUE ************************
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender  {
    // Saves the note *******
    [self saveNote];
    
    // Passes the managedObjectContext to the NotesList ViewController ****
    NotesList *nextVC = (NotesList *)[segue destinationViewController];
    nextVC.managedObjectContext = _managedObjectContext;
}




@end
