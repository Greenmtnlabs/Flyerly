//////////////////////////////////////
//
//   Notex
//   created by FV iMAGINATION
//   ©2014
//
//////////////////////////////////////


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


UIColor *red, *blue, *yellow, *purple, *green, *deepBlue;
UITableViewCell *cell;


@interface NotesList : UIViewController <
UITableViewDelegate,
UISearchBarDelegate,
UISearchDisplayDelegate
>


// CoreData properties  *******
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSMutableArray *notesArray;

//UI VIEWS ***********
@property (retain, nonatomic) IBOutlet UIView *topView;

//TableView ********
@property (retain, nonatomic) IBOutlet UITableView *tableView;

// Labels *******
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *copyrightLabel;



@end
