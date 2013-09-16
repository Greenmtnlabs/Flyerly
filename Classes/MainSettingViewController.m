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
    globle = [Singleton RetrieveSingleton];
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
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(-35, -6, 50, 50)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"SETTINGS";
    
    self.navigationItem.titleView = label;
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

- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ZCell";
    
    UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:CellIdentifier] ;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [[cell textLabel] setFont:[UIFont fontWithName:TITLE_FONT size:14]];
		[[cell detailTextLabel] setTextColor:[UIColor lightGrayColor]];
		[[cell detailTextLabel] setFont:[UIFont systemFontOfSize:12.0]];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SettingcellBack"]]];
    }

    NSString *s =[NSString stringWithFormat:@"   %@",[category objectAtIndex:indexPath.row]]  ;
    cell.textLabel.text =s;
   
    if (indexPath.row == 0)cell.imageView.image =[UIImage imageNamed:@"share_settings"];
    if (indexPath.row == 1)cell.imageView.image =[UIImage imageNamed:@"save_gallery"];
    if (indexPath.row == 2)cell.imageView.image =[UIImage imageNamed:@"account_settings"];
    if (indexPath.row == 3)cell.imageView.image =[UIImage imageNamed:@"signout"];

        if (indexPath.row == 1){
            UISwitch *mSwitch = [[[UISwitch alloc] initWithFrame:CGRectMake(220, 4, 0, 0)] autorelease];
            [cell.contentView  addSubview:mSwitch];
            [mSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
            
            NSString  *savecamra = [[NSUserDefaults standardUserDefaults] stringForKey:@"saveToCameraRollSetting"];
            NSLog(@"%@",savecamra);
            if (savecamra == nil) {
                [mSwitch setOn:NO];
            }else{
                [mSwitch setOn:YES];
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
- (void)tableView:(UITableView *)tView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.row == 0) {
        oldsettingveiwcontroller = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
        [self.navigationController pushViewController:oldsettingveiwcontroller animated:YES];
  
    } else if(indexPath.row == 2) {
        accountUpdater = [[AccountSelecter alloc]initWithNibName:@"AccountSelecter" bundle:nil];
        [self.navigationController pushViewController:accountUpdater animated:YES];
    }else if(indexPath.row == 3){
        warningAlert = [[UIAlertView  alloc]initWithTitle:@"Are you sure?" message:@"" delegate:self cancelButtonTitle:@"Sign out" otherButtonTitles:@"Cancel",nil];
        [warningAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
        //[warningAlert show];
        [warningAlert autorelease];
    }
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(alertView == warningAlert && buttonIndex == 0) {
        [self signOut];
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
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate *) [[UIApplication sharedApplication]delegate];
    appDelegate.facebook = nil;
    appDelegate.facebook.sessionDelegate = nil;
    appDelegate.facebook.accessToken = nil;
    appDelegate.facebook.expirationDate = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"facebookSetting"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FBAccessTokenKey"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FBExpirationDateKey"];
    //For FlyerLee
    [[NSUserDefaults standardUserDefaults]  setObject:nil forKey:@"User"];
    [[NSUserDefaults standardUserDefaults]  setObject:nil forKey:@"Password"];

    // Forget in app purchases.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:IN_APP_DICTIONARY_KEY];
    
    // Log out from parse.
    [PFUser logOut];
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

-(IBAction)gofacbook:(id)sender{
    globle.inputValue = @"facebook";
    InputViewController  *inputcontroller = [[InputViewController alloc]initWithNibName:@"InputViewController" bundle:nil];
    [self.navigationController presentModalViewController:inputcontroller animated:YES];
}

-(IBAction)gotwitter:(id)sender{
    globle.inputValue = @"twitter";
    InputViewController  *inputcontroller = [[InputViewController alloc]initWithNibName:@"InputViewController" bundle:nil];
    [self.navigationController presentModalViewController:inputcontroller animated:YES];
}



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
