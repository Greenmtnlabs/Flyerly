//////////////////////////////////////
//
//   Notex
//   created by FV iMAGINATION
//   ©2014
//
//////////////////////////////////////


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

// Dropbox import
#import <DropboxSDK/DropboxSDK.h>


// CoreData Entity
#import "NotesEntity.h"

// LongPress Menu
#import "FVLongPressMenuView.h"


// Variables =======
float fontSize;
NSString *textStr;

NSString *colorName;


@interface NoteEditor : UIViewController
<
FVLongPressOverlayViewDataSource, FVLongPressOverlayViewDelegate,
UITextFieldDelegate,
UITextViewDelegate,
UIActionSheetDelegate, UIActionSheetDelegate,
DBRestClientDelegate
>
{
    // RestClient for Dropbox
    DBRestClient *restClient;
    UIActivityIndicatorView *indicatorView;
    UIView *greyView;
}

// CoreData properties =========
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NotesEntity *notesEntity;

/* VIEWS */
@property (retain, nonatomic) IBOutlet UIView *topView;
@property (retain, nonatomic) IBOutlet UITextView *noteTextView;
@property (retain, nonatomic) IBOutlet UITextField *noteTitleTxt;



@end
