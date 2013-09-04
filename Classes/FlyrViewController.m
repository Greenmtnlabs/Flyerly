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
#import "HelpController.h"
#import "FlyerOverlayController.h"
#import "FlyrAppDelegate.h"

@implementation FlyrViewController
@synthesize photoArray,navBar,tView,iconArray,photoDetailArray,ptController;


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
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];

	photoArray =[[NSMutableArray alloc]init];
	photoDetailArray =[[NSMutableArray alloc]init];
	iconArray = [[NSMutableArray alloc]init];
	NSString *homeDirectoryPath = NSHomeDirectory();
	NSString *unexpandedPath = [homeDirectoryPath stringByAppendingString: [NSString stringWithFormat:@"/Documents/%@/Flyr/",appDelegate.loginId]];
	NSString *folderPath = [NSString pathWithComponents:[NSArray arrayWithObjects:[NSString stringWithString:[unexpandedPath stringByExpandingTildeInPath]], nil]];
	
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
	NSString *finalImagePath;
	NSArray* sortedFiles;
	NSArray* detailSortedFiles;
	NSString *detailFinalImagePath;

	for(int i =0;i< [files count];i++)
	{
		NSString *img = [files objectAtIndex:i];
		img = [@"/" stringByAppendingString:img];
		finalImagePath= [folderPath stringByAppendingString:img];
        
        if([finalImagePath hasSuffix:@".jpg"]){
            [photoArray addObject:finalImagePath];
        } else if([finalImagePath hasSuffix:@".txt"]){
            [photoDetailArray addObject:finalImagePath];
        }
	}
    
    sortedFiles = [photoArray sortedArrayUsingFunction:dateModifiedSort context:nil];
    detailSortedFiles = [photoDetailArray sortedArrayUsingFunction:dateModifiedSort context:nil];

	[photoArray removeAllObjects];
	[photoDetailArray removeAllObjects];
	for(int i =0;i< [sortedFiles count];i++)
	{
			finalImagePath = [sortedFiles objectAtIndex:i];
			UIImage *temp = [self scale:finalImagePath toSize:CGSizeMake(640,640)];
			[photoArray addObject:finalImagePath];
			[iconArray addObject:temp];
		//NSLog(@"photoArray:%@",[photoArray objectAtIndex:i]);
	}
    
    
    
	for(int j =0;j< [detailSortedFiles count];j++)
	{
        detailFinalImagePath = [detailSortedFiles objectAtIndex:j];
        //NSLog(@"detailFinalImagePath: %@", detailFinalImagePath);
        NSArray *myArray = [NSArray arrayWithContentsOfFile:detailFinalImagePath];
        [photoDetailArray addObject:myArray];
	}}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    UIImageView *img = [[UIImageView    alloc]initWithImage:[UIImage imageNamed:@"text_box"]];
    [img setFrame:CGRectMake(8,54,230,30)];
    
    UITextField *searchText = [[UITextField alloc]initWithFrame:CGRectMake(15,62,240,25)];
    searchText.placeholder = @"Flyerly search";
    searchText.font = [UIFont systemFontOfSize:12.0];
    //Search Boutton
    UIButton *seaBotton = [[UIButton alloc] initWithFrame:CGRectMake(252, 54, 58, 30)];
    [seaBotton  setTitle:@"Search" forState:UIControlStateNormal] ;
    seaBotton.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
    //[seaBotton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [seaBotton setBackgroundImage:[UIImage imageNamed:@"crop_button"] forState:UIControlStateNormal];
    [self.view addSubview:img];
    [self.view addSubview:seaBotton];
    [self.view addSubview:searchText];
    if(IS_IPHONE_5){
        tView = [[UITableView alloc]initWithFrame:CGRectMake(0, 86, 320, 510) style:UITableViewStyleGrouped];
    }else{
        tView = [[UITableView alloc]initWithFrame:CGRectMake(0, 86, 320, 416) style:UITableViewStyleGrouped];
    }
//	[self.tView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default.png"]]];
	tView.dataSource = self;
	tView.delegate = self;
	//tView.alpha  = .6f;
	
    [self.view addSubview:tView];
	self.tView.rowHeight =102;
    [self.tView setBackgroundView:nil];
    [self.tView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg_without_logo2"] forBarMetrics:UIBarMetricsDefault];
}

-(NSArray *)leftBarItems{
    
    // Create left bar help button
    UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 16, 21)];
    [helpButton addTarget:self action:@selector(loadHelpController) forControlEvents:UIControlEventTouchUpInside];
    [helpButton setImage:[UIImage imageNamed:@"help_icon"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
   
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 29, 25)];
    [backButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];

    return [NSMutableArray arrayWithObjects:backBarButton,leftBarButton,nil];
}

-(void)loadHelpController{
    HelpController *helpController = [[HelpController alloc]initWithNibName:@"HelpController" bundle:nil];
    [self.navigationController pushViewController:helpController animated:NO];
}

-(NSArray *)rightBarItems{
    
    // Create right bar help button
    //UILabel *saveFlyrLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    //[saveFlyrLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:8.5]];
    //[saveFlyrLabel setTextColor:[MyCustomCell colorWithHexString:@"008ec0"]];
    //[saveFlyrLabel setBackgroundColor:[UIColor clearColor]];
    //[saveFlyrLabel setText:@"Saved flyer"];
    //UIBarButtonItem *barLabel = [[UIBarButtonItem alloc] initWithCustomView:saveFlyrLabel];
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(-30, -6, 50, 50)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"SAVED";
    self.navigationItem.titleView = label;

    //self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Saved" rect:CGRectMake(-30, -6, 50, 50)];

    // Create left bar help button
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 29)];
    [shareButton addTarget:self action:@selector(doNew:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"pencil_icon"] forState:UIControlStateNormal];
    UIBarButtonItem *shareBarButton = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    //UIBarButtonItem *shareBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIControlStateNormal
    //                                                                  target:nil action:nil ];
    
    return [NSMutableArray arrayWithObjects:shareBarButton,nil];
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

-(void)showFlyerOverlay:(id)sender{
    
    // cast to button
    UIButton *cellImageButton = (UIButton *) sender;
    // Get image on button
    UIImage *flyerImage = [cellImageButton imageForState:UIControlStateNormal];
    // Create Modal trnasparent view
    UIView *modalView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [modalView setBackgroundColor:[MyCustomCell colorWithHexString:@"161616"]];
    modalView.alpha = 0.75;
    self.navigationController.navigationBar.alpha = 0.35;

    // Create overlay controller
    FlyerOverlayController *overlayController = [[FlyerOverlayController alloc]initWithNibName:@"FlyerOverlayController" bundle:nil image:flyerImage modalView:modalView];
    // set its parent
    [overlayController setViews:self];
    //NSLog(@"showFlyerOverlay Tag: %d", cellImageButton.tag);
    overlayController.flyerNumber = cellImageButton.tag;
    
    // Add modal view and overlay view
    [self.view addSubview:modalView];
    [self.view addSubview:overlayController.view];
}

-(UITableViewCell *)setGlobalCustomCellProperties:(NSString *)title description:(NSString *)description created:(NSString *)created img:(UIImage *)img imagePath:(NSString *)imagePath indexPath:(NSIndexPath *)indexPath{

    static NSString *cellId = @"Cell";
    MyCustomCell *cell = (MyCustomCell *)[tView dequeueReusableCellWithIdentifier:cellId];
    
    NSLog(@"imagePath: %@", imagePath);
    NSString *index = [FlyrViewController getFlyerNumberFromPath:imagePath];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    if (cell == nil) {
        cell = [[[MyCustomCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellId] autorelease];
        cell.flyerNumber = [index intValue];
        cell.cellImage.tag = cell.flyerNumber;
        [cell.cellImage addTarget:self action:@selector(showFlyerOverlay:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [cell addToCell: title :description :created :img :imagePath :[index intValue]];
    
    return cell;
}

+(NSString *)getFlyerNumberFromPath:(NSString *)imagePath{
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];

	NSString *homeDirectoryPath = NSHomeDirectory();
	NSString *flyerPath = [homeDirectoryPath stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@/Flyr/",appDelegate.loginId]];
	NSString *folderPath = [NSString pathWithComponents:[NSArray arrayWithObjects:[NSString stringWithString:[flyerPath stringByStandardizingPath]],nil]];
	
    NSString *onlyImageName = [imagePath stringByReplacingOccurrencesOfString:folderPath withString:@""];
    NSString *lastFileName = [onlyImageName stringByReplacingOccurrencesOfString:@".jpg" withString:@""];
    NSString *index = [lastFileName stringByReplacingOccurrencesOfString:@"/IMG_" withString:@""];

    return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // Get image from array
	UIImage *image = [iconArray objectAtIndex:indexPath.row];
    // Get image name from array
	NSString *imageName = [photoArray objectAtIndex:indexPath.row];
    // get flyer detail from array
    NSArray *detailArray = [photoDetailArray objectAtIndex:indexPath.row];

    // return cell
    return [self setGlobalCustomCellProperties:[detailArray objectAtIndex:0] description:[detailArray objectAtIndex:1] created:[detailArray objectAtIndex:2] img:image imagePath:imageName indexPath:indexPath];
    
	//SET_GLOBAL_CUSTOM_CELL_PROPERTIES([detailArray objectAtIndex:0], [detailArray objectAtIndex:1], [detailArray objectAtIndex:2],image, imageName)
	
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
    
    if(photoDetailArray.count > indexPath.row){
        NSArray *detailArray = [photoDetailArray objectAtIndex:indexPath.row];
        NSString *title = [detailArray objectAtIndex:0];
        NSString *description = [detailArray objectAtIndex:1];
        draftViewController.selectedFlyerTitle = title;
        draftViewController.selectedFlyerDescription = description;
        draftViewController.imageFileName = imageName;
        
        NSString *newText = [imageName stringByReplacingOccurrencesOfString:@".jpg" withString:@".txt"];
        draftViewController.detailFileName = newText;
    }

	[self.navigationController pushViewController:draftViewController animated:YES];
	 [draftViewController release];
	[self performSelector:@selector(deselect) withObject:nil afterDelay:0.2f];

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
	[tableView beginUpdates];
	[tableView setEditing:YES animated:YES];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [tableView deleteRowsAtIndexPaths:
        [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row  inSection:indexPath.section],nil]
                         withRowAnimation:UITableViewRowAnimationLeft];
        
        // Remove flyer
        NSString *imageName = [photoArray objectAtIndex:[indexPath row]];
        [[NSFileManager defaultManager] removeItemAtPath:imageName error:nil];
        
        // Remove flyer detail file
        NSString *flyerFilePath = [imageName stringByReplacingOccurrencesOfString:@".jpg" withString:@".txt"];
        [[NSFileManager defaultManager] removeItemAtPath:flyerFilePath error:nil];

        FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];

        // Remove flyer social detail file
        NSString *socialFlyerFolderPath = [imageName stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/Flyr/", appDelegate.loginId] withString:[NSString stringWithFormat:@"%@/Flyr/Social/", appDelegate.loginId]];
        NSString *socialFilePath = [socialFlyerFolderPath stringByReplacingOccurrencesOfString:@".jpg" withString:@".soc"];
        [[NSFileManager defaultManager] removeItemAtPath:socialFilePath error:nil];

        [photoArray removeObjectAtIndex:[indexPath row]];
		[iconArray removeObjectAtIndex:[indexPath row]];
	}
    
	[tableView endUpdates];
	[tableView reloadData];
}

-(IBAction)doNew:(id)sender{
	ptController = [[PhotoController alloc]initWithNibName:@"PhotoController" bundle:nil];
    ptController.flyerNumber = -1;
	[self.navigationController pushViewController:ptController animated:YES];
	//[ptController release];
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
    self.navigationController.navigationBar.alpha = 1.0;
}

- (void)dealloc {
	[iconArray release];
	[tView release];
	[photoArray release];
    [ptController release];
    [super dealloc];
}

-(void)goBack{
    /*
    if(IS_IPHONE_5){
        launchCotroller = [[LauchViewController alloc]initWithNibName:@"LauchViewControllerIPhone5" bundle:nil];
    }   else{
        launchCotroller = [[LauchViewController alloc]initWithNibName:@"LauchViewController" bundle:nil];
    }
     [self.navigationController pushViewController:launchCotroller animated:NO];
*/
  	[self.navigationController popViewControllerAnimated:YES];
}
@end

