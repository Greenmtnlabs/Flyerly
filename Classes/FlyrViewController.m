//
//  FlyrViewController.m
//  Flyr
//
//  Created by Nilesh on 23/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FlyrViewController.h"
#import "Common.h"
#import "DraftViewController.h"
#import "MyNavigationBar.h"
#import "Common.h"
#import "LauchViewController.h"
@implementation FlyrViewController
@synthesize photoArray,navBar,tView,iconArray;


- (UIImage *)scale:(NSString *)imageName toSize:(CGSize)size
{
	//NSData *imageData = [[NSData alloc ]initWithContentsOfMappedFile:imageName];
	//UIImage *image = [UIImage imageWithData:imageData];
	UIImage *image = [UIImage imageWithContentsOfFile:imageName ];
	
	UIGraphicsBeginImageContext(size);
	[image drawInRect:CGRectMake(0, 0, size.width, size.height)];
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	NSData *jpegData = UIImageJPEGRepresentation(scaledImage, 0.2);
	scaledImage = [UIImage imageWithData:jpegData];
	UIGraphicsEndImageContext();
	return scaledImage;
}

// Modified Date sort function

NSInteger dateModifiedSort(id file1, id file2, void *reverse) {
    NSDictionary *attrs1 = [[NSFileManager defaultManager]
                            attributesOfItemAtPath:file1
                            error:nil];
    NSDictionary *attrs2 = [[NSFileManager defaultManager]
                            attributesOfItemAtPath:file2
                            error:nil];
	
    if ((NSInteger *)reverse == 0) {
        return [[attrs2 objectForKey:NSFileModificationDate]
                compare:[attrs1 objectForKey:NSFileModificationDate]];
    }
	
    return [[attrs1 objectForKey:NSFileModificationDate]
            compare:[attrs2 objectForKey:NSFileModificationDate]];
}



-(void)filesByModDate
{
	photoArray =[[NSMutableArray alloc]init];
	iconArray = [[NSMutableArray alloc]init];
	NSString *homeDirectoryPath = NSHomeDirectory();
	NSString *unexpandedPath = [homeDirectoryPath stringByAppendingString:@"/Documents/Flyr/"];
	NSString *folderPath = [NSString pathWithComponents:[NSArray arrayWithObjects:[NSString stringWithString:[unexpandedPath stringByExpandingTildeInPath]], nil]];
	
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
	NSString *finalImagePath;
	NSArray* sortedFiles;

	for(int i =0;i< [files count];i++)
	{
		NSString *img = [files objectAtIndex:i];
		img = [@"/" stringByAppendingString:img];
		finalImagePath= [folderPath stringByAppendingString:img];
		[photoArray addObject:finalImagePath];
	}
           sortedFiles = [photoArray sortedArrayUsingFunction:dateModifiedSort
                                                       context:nil];
        //NSLog(@"sortedFiles: %@", sortedFiles);            
	[photoArray removeAllObjects];
	for(int i =0;i< [sortedFiles count];i++)
	{
			finalImagePath = [sortedFiles objectAtIndex:i];
			UIImage *temp = [self scale:finalImagePath toSize:CGSizeMake(100,100)];
			[photoArray addObject:finalImagePath];
			[iconArray addObject:temp];
		//NSLog(@"photoArray:%@",[photoArray objectAtIndex:i]);
	}	
}

- (void)viewDidLoad {
    [super viewDidLoad];

	tView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, 320, 416) style:UITableViewStyleGrouped];
	[self.tView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default.png"]]];
	tView.dataSource = self;
	tView.delegate = self;
	//tView.alpha  = .6f;
	[self.view addSubview:tView];
	self.tView.rowHeight =100;

	//Create sorted array with modificate date as key 
	[self filesByModDate];
}

-(void)callMenu
{
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    // Set left bar items
    [self.navigationItem setLeftBarButtonItems: [self leftBarItems]];
    // Set right bar items
    [self.navigationItem setRightBarButtonItems: [self rightBarItems]];

    /*
	navBar= [[MyNavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
	[self.view addSubview:navBar];
	[navBar show:@"Saved Flyrs" left:@"Menu" right:@""];
	[self.view bringSubviewToFront:navBar];
	
	[navBar.leftButton removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	[navBar.rightButton removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	
	[navBar.leftButton addTarget:self action:@selector(callMenu) forControlEvents:UIControlEventTouchUpInside];
	[navBar.rightButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	navBar.alpha = ALPHA1;
     */
}

-(NSArray *)leftBarItems{
    
    // Create left bar help button
    UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 13, 16)];
    [helpButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [helpButton setBackgroundImage:[UIImage imageNamed:@"help_icon"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:helpButton];

    return [NSMutableArray arrayWithObjects:leftBarButton,nil];
}

-(NSArray *)rightBarItems{
    
    // Create right bar help button
    UILabel *saveFlyrLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [saveFlyrLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:8.5]];
    [saveFlyrLabel setTextColor:[MyCustomCell colorWithHexString:@"008ec0"]];
    [saveFlyrLabel setBackgroundColor:[UIColor clearColor]];
    [saveFlyrLabel setText:@"Share flyer"];
    UIBarButtonItem *barLabel = [[UIBarButtonItem alloc] initWithCustomView:saveFlyrLabel];

    UIBarButtonItem *shareBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIControlStateNormal
                                                                      target:nil action:nil ];
    
    return [NSMutableArray arrayWithObjects:shareBarButton,barLabel,nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [photoArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
          

	UIImage *imageName = [iconArray objectAtIndex:indexPath.row];
	SET_GLOBAL_CUSTOM_CELL_PROPERTIES(@"Title", @"Description of two lines to test the multiple line label", @"24/03/2013",imageName)
	
}

- (void) deselect
{
	[self.tView deselectRowAtIndexPath:[self.tView indexPathForSelectedRow] animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	 
	 DraftViewController *draftViewController = [[DraftViewController alloc] initWithNibName:@"DraftViewController" bundle:nil];
	NSString *imageName = [photoArray objectAtIndex:indexPath.row];
	 NSData *imageData = [[NSData alloc ]initWithContentsOfMappedFile:imageName];
	UIImage *currentFlyerImage = [UIImage imageWithData:imageData];
	draftViewController.fvController = self;
	draftViewController.selectedFlyerImage = currentFlyerImage;
	[self.navigationController pushViewController:draftViewController animated:YES];
	 [draftViewController release];
	[self performSelector:@selector(deselect) withObject:nil afterDelay:0.2f];

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
	[tableView beginUpdates];
	[tableView setEditing:YES animated:YES];

           if (editingStyle == UITableViewCellEditingStyleDelete)
	{
			[tableView deleteRowsAtIndexPaths:
			                    [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row  inSection:indexPath.section],nil] 
			                    withRowAnimation:UITableViewRowAnimationLeft];

			NSString *imageName = [photoArray objectAtIndex:[indexPath row]];
			[[NSFileManager defaultManager] removeItemAtPath:imageName error:nil];
			[photoArray removeObjectAtIndex:[indexPath row]];
		[iconArray removeObjectAtIndex:[indexPath row]];
	}   
	[tableView endUpdates];
	[tableView reloadData];
}


- (void)postDismissCleanup {
	[navBar removeFromSuperview];	
	[navBar release];

}

- (void)dismissNavBar:(BOOL)animated {
	
	
	if (animated) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(postDismissCleanup)];
		navBar.alpha = 0;
		[UIView commitAnimations];
	} else {
		[self postDismissCleanup];
	}
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self dismissNavBar:YES];
}

- (void)dealloc {
	[iconArray release];
	[tView release];
	[photoArray release];
    [super dealloc];
}


@end

