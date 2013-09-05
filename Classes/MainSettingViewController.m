//
//  MainSettingViewController.m
//  Flyr
//
//  Created by Khurram on 07/08/2013.
//
//

#import "MainSettingViewController.h"

@interface MainSettingViewController ()

@end

@implementation MainSettingViewController
@synthesize tableView;
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
    
    self.tableView.rowHeight = 35;
    [self.tableView setBackgroundView:nil];
   // [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setSeparatorColor:[UIColor blackColor]];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg_without_logo2"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.hidesBackButton = YES;
    
    UIButton *helpButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 16, 21)]autorelease];
    [helpButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [helpButton setBackgroundImage:[UIImage imageNamed:@"help_icon"] forState:UIControlStateNormal];
    [helpButton addTarget:self action:@selector(gohelp) forControlEvents:UIControlEventTouchUpInside];
    helpButton.showsTouchWhenHighlighted = YES;
    
    UIBarButtonItem *helpBarButton = [[[UIBarButtonItem alloc] initWithCustomView:helpButton] autorelease];

    UIButton *editButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 29)] autorelease];
    [editButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [editButton setBackgroundImage:[UIImage imageNamed:@"pencil_icon"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
    editButton.showsTouchWhenHighlighted = YES;

    UIBarButtonItem *editBarButton = [[[UIBarButtonItem alloc] initWithCustomView:editButton] autorelease];
    
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:helpBarButton,editBarButton,nil ]];

    UIButton *backButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 29, 25)] autorelease];
    [backButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *backBarButton = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];


    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:backBarButton,nil ]];
    
     self.navigationItem.title = @"SETTINGS";
    category = [[NSMutableArray alloc] init];
    [category addObject:@" Sharing Options"];
    [category addObject:@"Save to Gallery"];
    [category addObject:@"Account Setting"];
    [category addObject:@" Sign Out"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma TableView Events



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return [category count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ZCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier] ;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [[cell textLabel] setFont:[UIFont fontWithName:TITLE_FONT size:14]];
		[[cell detailTextLabel] setTextColor:[UIColor lightGrayColor]];
		[[cell detailTextLabel] setFont:[UIFont systemFontOfSize:12.0]];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SettingcellBack"]]];
    }
/*
    UILabel *lpz = [[UILabel alloc]initWithFrame:CGRectMake(150, 5, 130, 20)];
	[lpz setBackgroundColor:[UIColor whiteColor]];
    // [lpz setTextColor:[UIColor grayColor]];
    
	[lpz setFont:[UIFont systemFontOfSize:14.0]];
	[lpz setTextAlignment:UITextAlignmentLeft];
    NSString *ss =[NSString stringWithFormat:@"Last Price : %@",[[newsFeed objectAtIndex:indexPath.section] valueForKey:@"slspz"]];
	lpz.text = ss;
	[cell.contentView  addSubview:lpz];
*/
        NSString *s =[NSString stringWithFormat:@"   %@",[category objectAtIndex:indexPath.row]]  ;
        cell.textLabel.text =s;
   
    if (indexPath.row == 0)cell.imageView.image =[UIImage imageNamed:@"share_settings"];
    if (indexPath.row == 1)cell.imageView.image =[UIImage imageNamed:@"save_gallery"];
    if (indexPath.row == 2)cell.imageView.image =[UIImage imageNamed:@"account_settings"];
    if (indexPath.row == 3)cell.imageView.image =[UIImage imageNamed:@"signout"];
        //if (indexPath.row == 0 || indexPath.row == 2)cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        if (indexPath.row == 1){
            UISwitch *mySwitch = [[[UISwitch alloc] initWithFrame:CGRectMake(220, 4, 0, 0)] autorelease];
            [cell.contentView  addSubview:mySwitch];
            [mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
            
            NSString  *savecamra = [[NSUserDefaults standardUserDefaults] stringForKey:@"saveToCameraRollSetting"];
            NSLog(@"%@",savecamra);
            if (savecamra == nil) {
                [mySwitch setOn:NO];
            }else{
                [mySwitch setOn:YES];
            }
        }
    return cell;
}

- (void)changeSwitch:(id)sender{
    if([sender isOn]){
        // Execute any code when the switch is ON
        NSLog(@"Switch is ON");
        [[NSUserDefaults standardUserDefaults]  setObject:@"enabled" forKey:@"saveToCameraRollSetting"];
    } else{
        // Execute any code when the switch is OFF
        NSLog(@"Switch is OFF");
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"saveToCameraRollSetting"];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = selectedCell.textLabel.text;
//    indexPath.row == 0 & indexPath.section == 0
    if (indexPath.row == 0){
    
    oldsettingveiwcontroller = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
        [self.navigationController pushViewController:oldsettingveiwcontroller animated:YES];
  
    }else if(indexPath.row == 2){
        accountUpdater = [[AccountSelecter alloc]initWithNibName:@"AccountSelecter" bundle:nil];
        [self.navigationController pushViewController:accountUpdater animated:YES];
        
        

    }else if(indexPath.row == 3){
        warningAlert = [[UIAlertView  alloc]initWithTitle:@"Are you sure?" message:@"" delegate:self cancelButtonTitle:@"Sign out" otherButtonTitles:@"Cancel",nil];
        [warningAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
        //[warningAlert show];
        [warningAlert autorelease];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(alertView == warningAlert && buttonIndex == 0) {
        [self signOut];
        //selectedCell.textLabel.text = @"Sign Out Successfully";
        AccountController *actaController = [AccountController alloc];
        if(IS_IPHONE_5){
            [[actaController initWithNibName:@"AcountViewControlleriPhone5" bundle:nil] autorelease];
        }else{
            [[actaController initWithNibName:@"AccountController" bundle:nil] autorelease];
        }
        [self.navigationController pushViewController:actaController animated:YES];
    }
    [self.view release];

}


- (void)signOut{
    //For Facebook
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"facebookSetting"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"FBAccessTokenKey"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"FBExpirationDateKey"];
    //For FlyerLee
    [[NSUserDefaults standardUserDefaults]  setObject:nil forKey:@"User"];
    [[NSUserDefaults standardUserDefaults]  setObject:nil forKey:@"Password"];
    //Twiiter
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"twitterSetting"];
    // for Instagram
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"instagramSetting"];
    // Thumbler
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tumblrSetting"];
    // Flicker
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"flickrSetting"];


}
-(IBAction)gofacbook:(id)sender{
    /*
    NSMutableDictionary *res = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"This is my comment", @"message", YOUR ACCESS TOKEN,@"access_token",nil];
    [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@/comments",PHOTO'S ID] parameters:res HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                             if (error)
                                             {
                                                 NSLog(@"error: %@", error.localizedDescription);
                                             }
                                             else
                                             {
                                                 NSLog(@"ok!! %@",result);
                                             }
                                             }];
    */
}
-(IBAction)gotwitter:(id)sender{}
-(IBAction)goemail:(id)sender{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    if([MFMailComposeViewController canSendMail]){
        
        picker.mailComposeDelegate = self;
        [picker setSubject:@"email feedback..."];
        
        // Set up recipients
        NSMutableArray *toRecipients = [[[NSMutableArray alloc]init]autorelease];
        [toRecipients addObject:@"support@greenmtnlabs.com"];
        [picker setToRecipients:toRecipients];
        
        //NSString *emailBody = [NSString stringWithFormat:@"<font size='4'><a href = '%@'>Share a flyer</a></font>", @"http://www.flyer.us"];
        //[picker setMessageBody:emailBody isHTML:YES];
        
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }

}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	switch (result) {
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
			break;
	}
    
    [controller dismissModalViewControllerAnimated:YES];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)editClick{
    //[Flurry logEvent:@"Create Flyer"];    
	ptController = [[PhotoController alloc]initWithNibName:@"PhotoController" bundle:nil];
    ptController.flyerNumber = -1;
	[self.navigationController pushViewController:ptController animated:YES];
	[ptController release];

}

-(void)gohelp{
    HelpController *helpController = [[[HelpController alloc]initWithNibName:@"HelpController" bundle:nil] autorelease];
    [self.navigationController pushViewController:helpController animated:YES];

}


@end
