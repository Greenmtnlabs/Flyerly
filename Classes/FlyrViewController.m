//
//  FlyrViewController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 22/Jan/2014.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FlyrViewController.h"


@implementation FlyrViewController
@synthesize photoArray,tView,iconArray,photoDetailArray,ptController,searchTextField;


- (UIImage *)scale:(NSString *)imageName toSize:(CGSize)size
{
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
        return [attrs2[NSFileModificationDate]
                compare:attrs1[NSFileModificationDate]];
    }
	
    return [attrs1[NSFileModificationDate]
            compare:attrs2[NSFileModificationDate]];
}



-(void)filesByModDate
{
    
    PFUser *user = [PFUser currentUser];

	photoArray =[[NSMutableArray alloc]init];
	photoDetailArray =[[NSMutableArray alloc]init];
	iconArray = [[NSMutableArray alloc]init];
	NSString *homeDirectoryPath = NSHomeDirectory();
	NSString *unexpandedPath = [homeDirectoryPath stringByAppendingString: [NSString stringWithFormat:@"/Documents/%@/Flyr/",user.username]];
	NSString *folderPath = [NSString pathWithComponents:@[[NSString stringWithString:[unexpandedPath stringByExpandingTildeInPath]]]];
	
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
	NSString *finalImagePath;
	NSArray* sortedFiles;
	NSArray* detailSortedFiles;
	NSString *detailFinalImagePath;

	for(int i =0;i< [files count];i++)
	{
        
        NSString *img = files[i];
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
			finalImagePath = sortedFiles[i];
			UIImage *temp = [self scale:finalImagePath toSize:CGSizeMake(640,640)];
			[photoArray addObject:finalImagePath];
			[iconArray addObject:temp];
	}
    
    
    
	for(int j =0;j< [detailSortedFiles count];j++)
	{
        detailFinalImagePath = detailSortedFiles[j];
        //NSLog(@"detailFinalImagePath: %@", detailFinalImagePath);
        NSArray *myArray = [NSArray arrayWithContentsOfFile:detailFinalImagePath];
        [photoDetailArray addObject:myArray];
	}}


- (void)textFieldTapped:(id)sender {
    NSLog(@"%@",searchTextField.text);
    
    if (searchTextField.text == nil || [searchTextField.text isEqualToString:@""])
    {
        searching = NO;
        [self.tView reloadData];
        [searchTextField resignFirstResponder];
    }else{
        searching = YES;
        [self searchTableView:[NSString stringWithFormat:@"%@", ((UITextField *)sender).text]];
     
        
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if(searching){
        if([string isEqualToString:@"\n"]){
            
            if([searchTextField canResignFirstResponder])
            {
                [searchTextField resignFirstResponder];
            }
        }
    }
    return YES;
}

- (void) searchTableView:(NSString *)schTxt {
	NSString *sTemp;
    NSString *sTemp1;
	NSString *sTemp2;

	NSString *searchText = searchTextField.text;
     NSLog(@"%@", searchTextField.text);
   

	searchFlyerPaths = [[NSMutableArray alloc] init];
	
	for (int i =0 ; i < [flyerPaths count] ; i++)
	{
		
        Flyer *fly = [[Flyer alloc] initWithPath:[flyerPaths objectAtIndex:i]];
        
 		sTemp = [fly getFlyerTitle];
        sTemp1 = [fly getFlyerDescription];
        sTemp2 = [fly getFlyerDate];

        
        NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
        NSRange titleResultsRange1 = [sTemp1 rangeOfString:searchText options:NSCaseInsensitiveSearch];
        NSRange titleResultsRange2 = [sTemp2 rangeOfString:searchText options:NSCaseInsensitiveSearch];

        if (titleResultsRange.length > 0 || titleResultsRange1.length > 0 || titleResultsRange2.length > 0){

            [searchFlyerPaths addObject:[flyerPaths objectAtIndex:i]];
        }
        

	}
    [self.tView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    searching = NO;

    FlyerlySingleton *globle = [FlyerlySingleton RetrieveSingleton];
    [self.view setBackgroundColor:[globle colorWithHexString:@"f5f1de"]];
    
	letUserSelectRow = YES;
    self.navigationItem.hidesBackButton = YES;
    searchTextField.placeholder = @"Flyerly search";
    searchTextField.font = [UIFont systemFontOfSize:12.0];
    searchTextField.textAlignment = UITextAlignmentLeft;
    searchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [searchTextField setBorderStyle:UITextBorderStyleRoundedRect];


	[self.tView setBackgroundColor:[globle colorWithHexString:@"f5f1de"]];
	tView.dataSource = self;
	tView.delegate = self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.tView.contentInset = UIEdgeInsetsMake(-30, 0, 0, 0);
    }
	
    [self.view addSubview:tView];
    [self.tView setBackgroundView:nil];
    [self.tView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [searchTextField addTarget:self action:@selector(textFieldTapped:) forControlEvents:UIControlEventEditingChanged];
    searchTextField.borderStyle = nil;
    

}

-(void)callMenu
{
    //Here We Rename the flyer Name for Recent flyer
    
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    searching = NO;
    searchTextField.text = @"";

    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    // Set left bar items
    [self.navigationItem setLeftBarButtonItems: [self leftBarItems]];
    
    // Set right bar items
    [self.navigationItem setRightBarButtonItems: [self rightBarItems]];
    

    //HERE WE GET FLYERS
    flyerPaths = [self getFlyersPaths];

     [tView reloadData];

}

-(NSArray *)leftBarItems{
    
    // Create left bar help button
    UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [helpButton addTarget:self action:@selector(loadHelpController) forControlEvents:UIControlEventTouchUpInside];
    [helpButton setImage:[UIImage imageNamed:@"help_icon"] forState:UIControlStateNormal];
    helpButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
   
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
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
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];
    label.text = @"SAVED";
    self.navigationItem.titleView = label;

    // Create Button
    UIButton *createButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [createButton addTarget:self action:@selector(createFlyer:) forControlEvents:UIControlEventTouchUpInside];
    [createButton setBackgroundImage:[UIImage imageNamed:@"createButton"] forState:UIControlStateNormal];
    createButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *createBarButton = [[UIBarButtonItem alloc] initWithCustomView:createButton];
    
    return [NSMutableArray arrayWithObjects:createBarButton,nil];
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
    if (searching){
        return  [searchFlyerPaths count];
    }else{
        return  [flyerPaths count];
    }
}





+(NSString *)getFlyerNumberFromPath:(NSString *)imagePath{
    
    PFUser *user = [PFUser currentUser];

	NSString *homeDirectoryPath = NSHomeDirectory();
	NSString *flyerPath = [homeDirectoryPath stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@/Flyr/",user.username]];
	NSString *folderPath = [NSString pathWithComponents:@[[NSString stringWithString:[flyerPath stringByStandardizingPath]]]];
	
    NSString *onlyImageName = [imagePath stringByReplacingOccurrencesOfString:folderPath withString:@""];
    NSString *lastFileName = [onlyImageName stringByReplacingOccurrencesOfString:@".jpg" withString:@""];
    NSString *index = [lastFileName stringByReplacingOccurrencesOfString:@"/IMG_" withString:@""];

    return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"Cell";
    SaveFlyerCell *cell = (SaveFlyerCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    
    

  
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SaveFlyerCell" owner:self options:nil];
        cell = (SaveFlyerCell *)[nib objectAtIndex:0];
    }
    
    
    if( searching ){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            flyer = [[Flyer alloc] initWithPath:[searchFlyerPaths objectAtIndex:indexPath.row]];
            [cell renderCell:flyer];
            
        });


        return cell;
        

    }else{

        dispatch_async(dispatch_get_main_queue(), ^{
            
            flyer = [[Flyer alloc] initWithPath:[flyerPaths objectAtIndex:indexPath.row]];
            [cell renderCell:flyer];
            
        });


         return cell;
        
    }
    
}

- (void) deselect
{
	[self.tView deselectRowAtIndexPath:[self.tView indexPathForSelectedRow] animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    flyer = [[Flyer alloc]initWithPath:[flyerPaths objectAtIndex:indexPath.row]];
    
    createFlyer = [[CreateFlyerController alloc]initWithNibName:@"CreateFlyerController" bundle:nil];
    
    // Set CreateFlyer Screen
    createFlyer.flyer = flyer;
	[self.navigationController pushViewController:createFlyer animated:YES];

	[self performSelector:@selector(deselect) withObject:nil afterDelay:0.2f];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
	[tableView beginUpdates];
	[tableView setEditing:YES animated:YES];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [tableView deleteRowsAtIndexPaths:
        @[[NSIndexPath indexPathForRow:indexPath.row  inSection:indexPath.section]]
                         withRowAnimation:UITableViewRowAnimationLeft];
        
        // HERE WE REMOVE FLYER FROM DIRECTORY
        if ( searching ) {
            
            [[NSFileManager defaultManager] removeItemAtPath:[searchFlyerPaths objectAtIndex:indexPath.row] error:nil];
            [searchFlyerPaths removeObjectAtIndex:indexPath.row];

        } else {
            
            [[NSFileManager defaultManager] removeItemAtPath:[flyerPaths objectAtIndex:indexPath.row] error:nil];
            [flyerPaths removeObjectAtIndex:indexPath.row];
        }

	}
    
    [tableView setEditing:NO animated:YES];
	[tableView endUpdates];
	[tableView reloadData];
}

-(IBAction)createFlyer:(id)sender {

    NSString *flyPath = [Flyer newFlyerPath];
    
    //Here We set Source for Flyer screen
    flyer = [[Flyer alloc]initWithPath:flyPath];
    
	createFlyer = [[CreateFlyerController alloc]initWithNibName:@"CreateFlyerController" bundle:nil];
    createFlyer.flyerPath = flyPath;
    createFlyer.flyer = flyer;
	[self.navigationController pushViewController:createFlyer animated:YES];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.alpha = 1.0;
}


-(void)goBack{
  	[self.navigationController popViewControllerAnimated:YES];
}


/*
 * Here we get All Flyers Directories
 * return
 *      Nsarray of Flyers Path
 */
-(NSMutableArray *)getFlyersPaths{
    
    PFUser *user = [PFUser currentUser];
    
    //Getting Home Directory
	NSString *homeDirectoryPath = NSHomeDirectory();
	NSString *usernamePath = [homeDirectoryPath stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@/Flyr",[user objectForKey:@"username"]]];

    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:usernamePath error:nil];
    
    NSMutableArray *sortedList = [ Flyer recentFlyerPreview:files.count];
    
    for(int i = 0 ; i < [sortedList count];i++)
    {
        
        //Here we remove File Name from Path
        NSString *pathWithoutFileName = [[sortedList objectAtIndex:i]
                                     stringByReplacingOccurrencesOfString:@"/flyer.jpg" withString:@""];
        [sortedList replaceObjectAtIndex:i withObject:pathWithoutFileName];
    }

    
    return sortedList;
}




@end



