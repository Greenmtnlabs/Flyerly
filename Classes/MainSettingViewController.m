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
    
    self.tableView.rowHeight =40;
    [self.tableView setBackgroundView:nil];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg_without_logo2"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.hidesBackButton = YES;
    
    UIButton *menuButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 30)] autorelease];
    [menuButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu_button"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];

    UIButton *editButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 29)] autorelease];
    [editButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [editButton setBackgroundImage:[UIImage imageNamed:@"pencil_icon"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *editBarButton = [[[UIBarButtonItem alloc] initWithCustomView:editButton] autorelease];
    
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:menuBarButton,editBarButton,nil ]];

    UIButton *backButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 29, 25)] autorelease];
    [backButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];

    UIButton *helpButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 16, 21)]autorelease];
    [helpButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [helpButton setBackgroundImage:[UIImage imageNamed:@"help_icon"] forState:UIControlStateNormal];
    [helpButton addTarget:self action:@selector(gohelp) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *helpBarButton = [[[UIBarButtonItem alloc] initWithCustomView:helpButton] autorelease];

    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:backBarButton,helpBarButton,nil ]];
    
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
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [[tableView dequeueReusableCellWithIdentifier:CellIdentifier] autorelease];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [[cell textLabel] setFont:[UIFont fontWithName:TITLE_FONT size:14]];
		[[cell detailTextLabel] setTextColor:[UIColor lightGrayColor]];
		[[cell detailTextLabel] setFont:[UIFont systemFontOfSize:12.0]];
       // [cell setBackgroundColor:[UIColor whiteColor]];
        
    }
    [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bg_first"]]];
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
            NSString *s =[[NSString stringWithFormat:@"   %@",[category objectAtIndex:indexPath.row]] autorelease];
        cell.textLabel.text =s;
    
    UIImageView *img = [[[UIImageView alloc ]initWithFrame:CGRectMake(0, 0, 21, 20)] autorelease];
    if (indexPath.row == 0)img.image =[UIImage imageNamed:@"share_settings"];
    if (indexPath.row == 1)img.image =[UIImage imageNamed:@"save_gallery"];
    if (indexPath.row == 2)img.image =[UIImage imageNamed:@"account_settings"];
    if (indexPath.row == 3)img.image =[UIImage imageNamed:@"signout"];
    cell.imageView.image = img.image;
        //if (indexPath.row == 0 || indexPath.row == 2)cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        if (indexPath.row == 1){
            UISwitch *mySwitch = [[[UISwitch alloc] initWithFrame:CGRectMake(220, 7, 0, 0)] autorelease];
            [cell.contentView  addSubview:mySwitch];
            [mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
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
    }else if(indexPath.row == 3){
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
   // SettingViewController *oldsettingveiwcontroller =[[SettingViewController alloc]init] ;
   // [oldsettingveiwcontroller  ];
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


-(void)editClick{}
-(void)gohelp{
    HelpController *helpController = [[[HelpController alloc]initWithNibName:@"HelpController" bundle:nil] autorelease];
    [self.navigationController pushViewController:helpController animated:YES];

}


@end
