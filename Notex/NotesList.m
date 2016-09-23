//////////////////////////////////////
//
//   Notex
//   created by FV iMAGINATION
//   ©2014
//
//////////////////////////////////////


#import "NotesList.h"
#import "CoreDataHelper.h"
#import "NoteEditor.h"

// Entity di CoreData
#import "NotesEntity.h"

@interface NotesList ()

@end

@implementation NotesList {
    
   // Array for searchBar results *****
    NSArray *searchResults;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated {
    // Loads all the stored notes and sorts them by Title *******
    _notesArray = [CoreDataHelper getObjectsForEntity:@"NotesEntity" withSortKey:@"noteTitle" andSortAscending:false andContext:_managedObjectContext];
    
    // Refreshes the tableView's rows ******
    [_tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_tableView reloadData];

    
    // init Colors =======
    red = [UIColor colorWithRed:251.0/255.0 green:110.0/255.0 blue:82.0/255.0 alpha:1.0];
    blue = [UIColor colorWithRed:79.0/255.0 green:192.0/255.0 blue:232.0/255.0 alpha:1.0];
    yellow = [UIColor colorWithRed:255.0/255.0 green:206.0/255.0 blue:85.0/255.0 alpha:1.0];
    purple = [UIColor colorWithRed:172.0/255.0 green:146.0/255.0 blue:237.0/255.0 alpha:1.0];
    green = [UIColor colorWithRed:160.0/255.0 green:212.0/255.0 blue:104.0/255.0 alpha:1.0];
    deepBlue = [UIColor colorWithRed:85.0/255.0 green:126.0/255.0 blue:222.0/255.0 alpha:1.0];
}


#pragma mark - TABLEVIEW METHODS **************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Shows search contents into the tableView
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return searchResults.count;
        
    } else {
        
    // Creates tableView's rows accordingly to the notes that has been saved so far (if there are no stored notes, the tableView will be empty)
    return _notesArray.count;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell
    static NSString *CellIdentifier = @"Cell";
    cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    // Initializes our CoreData Entity (NotesEntity)
    NotesEntity *notes = nil;
    
    // When you make a search in the searchBar, the tableView shows the results
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        notes = [searchResults objectAtIndex:indexPath.row];
    } else {
    // When you do not make any search, the tableView shows all your stored notes
    notes = [_notesArray objectAtIndex:indexPath.row];
    }
    
    //  Fills in the cell contents
    cell.textLabel.text = notes.noteTitle;
    cell.detailTextLabel.text = notes.noteText;
    
    // Cell's Image settings
    NSString *colorStr = [NSString stringWithFormat:@"%@", notes.noteColor];
    if ([colorStr isEqualToString:@"red"]) {
    cell.imageView.backgroundColor = red;
    } else if ([colorStr isEqualToString:@"blue"]) {
        cell.imageView.backgroundColor = blue;
    } else if ([colorStr isEqualToString:@"yellow"]) {
        cell.imageView.backgroundColor = yellow;
    } else if ([colorStr isEqualToString:@"purple"]) {
        cell.imageView.backgroundColor = purple;
    } else if ([colorStr isEqualToString:@"green"]) {
        cell.imageView.backgroundColor = green;
    } else if ([colorStr isEqualToString:@"deepBlue"]) {
        cell.imageView.backgroundColor = deepBlue;
    }
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  54;
}

// Delete cells with left swipe *********************
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)  {
        //  Gets a reference to the tableView's item in our data array
        NotesEntity *itemToDelete = [_notesArray objectAtIndex:indexPath.row];
        //  Deletes the item in Core Data
        [_managedObjectContext deleteObject:itemToDelete];
        //  Removes the item from our array
        [_notesArray removeObjectAtIndex:indexPath.row];
        
        //  Commits the deletion in core data
        NSError *error;
        if (![_managedObjectContext save:&error])
            NSLog(@"Failed to delete item with error: %@", [error domain]);
        
        // Deletes the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}



#pragma mark - SEARCHBAR METHODS *****************
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"noteTitle CONTAINS[cd] %@", searchText];
    searchResults = [_notesArray filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
      scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
         objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}





#pragma mark - PREPARE FOR SEGUE ***************

// This happens when AddButton is pressed or a tableView's row is selected
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender  {
    
    //  Gets a reference to our next ViewController (NoteEditor.m)
    NoteEditor *nextVC = (NoteEditor *)[segue destinationViewController];
    //  Passes the managedObjectContext to the NoteEditor ViewController
    nextVC.managedObjectContext = _managedObjectContext;
    
//  If we are editing an Entity (so we tap on a tableView's row) we need to first check the Segue Identifier
    if ([[segue identifier] isEqualToString:@"EditNoteSegue"])  {
        
        // Checks if we are searching something into the searchBar
        if (self.searchDisplayController.active)  {
        //  Passes the data from the tableView's selected row to the NoteEditor ViewController
        nextVC.notesEntity = [searchResults objectAtIndex: self.searchDisplayController.searchResultsTableView.indexPathForSelectedRow.row];
        } else {
            
        //  Passes the data from the tableView's selected row to the NoteEditor ViewController
        nextVC.notesEntity = [_notesArray objectAtIndex: _tableView.indexPathForSelectedRow.row];
    }
        
  }
}




@end
