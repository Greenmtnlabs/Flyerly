//
//  MainSettingViewController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd on 07/08/2013.
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
    
    globle = [FlyerlySingleton RetrieveSingleton];
    [self.view setBackgroundColor:[globle colorWithHexString:@"f5f1de"]];
    self.tableView.rowHeight = 40;

    self.tableView.backgroundView = nil;
    [self.tableView setBackgroundColor:[globle colorWithHexString:@"f5f1de"]];
    [self.tableView setSeparatorColor:[UIColor lightGrayColor]];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.tableView.contentInset = UIEdgeInsetsMake(-92, 0, 0, 0);
    }

    self.navigationItem.hidesBackButton = YES;
    
    UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [helpButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [helpButton setBackgroundImage:[UIImage imageNamed:@"help_icon"] forState:UIControlStateNormal];
    [helpButton addTarget:self action:@selector(gohelp) forControlEvents:UIControlEventTouchUpInside];
    helpButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *helpBarButton = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [backButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:backBarButton,helpBarButton,nil ]];
    
    
    UIButton *createButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [createButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [createButton setBackgroundImage:[UIImage imageNamed:@"createButton"] forState:UIControlStateNormal];
    [createButton addTarget:self action:@selector(createNewFlyer) forControlEvents:UIControlEventTouchUpInside];
    createButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *createBarButton = [[UIBarButtonItem alloc] initWithCustomView:createButton];
    
    [self.navigationItem setRightBarButtonItem:createBarButton];
        
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-35, -6, 50, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"SETTINGS";
    
    self.navigationItem.titleView = label;
    category = [[NSMutableArray alloc] init];
    [category addObject:@"Sharing Options"];
    [category addObject:@"Save to Gallery"];
    [category addObject:@"Account Setting"];
    [category addObject:@"Sign Out"];

}

#pragma TableView Events

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return [category count];
}

- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"SettingCell";
    
    // Create My custom cell view
    MainSettingCell *cell = (MainSettingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if ( cell == nil ) {
        cell = [[MainSettingCell alloc] initWithFrame:CGRectZero] ;
         [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SettingcellBack"]]];
    }

    NSString *title =[NSString stringWithFormat:@"%@",category[indexPath.row]];
    NSString *imgname =@"";
   
    if (indexPath.row == 0) imgname = @"share_settings";
    
    if (indexPath.row == 1){
        
        imgname = @"save_gallery";
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settingsrow"]]];
        
    }
    
    if (indexPath.row == 2)imgname = @"account_settings";
    
    if (indexPath.row == 3){
        
        imgname = @"signout";
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settingsrow"]]];
        
    }

        if (indexPath.row == 1){
            UISwitch *mSwitch;
             if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                 mSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(263, 4, 0, 0)] ;
             }else{
                 mSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(223, 4, 0, 0)] ;
             }
            
            [cell.contentView  addSubview:mSwitch];
            [mSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
            
            NSString  *savecamra = [[NSUserDefaults standardUserDefaults] stringForKey:@"saveToCameraRollSetting"];
            if (savecamra == nil) {
                [mSwitch setOn:NO];
            }else{
                [mSwitch setOn:YES];
            }
        }
    
    // Set cell Values
    [cell setCellObjects:title leftimage:imgname];
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
        oldsettingveiwcontroller = [[ShareSettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
        [self.navigationController pushViewController:oldsettingveiwcontroller animated:YES];
  
    } else if(indexPath.row == 2) {
        accountUpdater = [[ProfileViewController alloc]initWithNibName:@"AccountSelecter" bundle:nil];
        [self.navigationController pushViewController:accountUpdater animated:YES];
    }else if(indexPath.row == 3){
        warningAlert = [[UIAlertView  alloc]initWithTitle:@"Are you sure?" message:@"" delegate:self cancelButtonTitle:@"Sign out" otherButtonTitles:@"Cancel",nil];
        [warningAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    }
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
	if(alertView == warningAlert && buttonIndex == 0) {
        [self signOut];
        AccountController *actaController = nil;
        
        actaController = [[AccountController alloc] initWithNibName:@"AccountController" bundle:nil];
        
        [self.navigationController setRootViewController:actaController];
    }
    
}


- (void)signOut{

    //For FlyerLy
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


-(IBAction)rateApp:(id)sender{
    
    float ver = [ globle.iosVersion floatValue];
    NSString* url;
    if (ver >= 7) {
        url = [NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id344130515"];
    }else{
       url = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", @"344130515"];
    }
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
    
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
        NSMutableArray *toRecipients = [[NSMutableArray alloc]init];
        [toRecipients addObject:@"support@greenmtnlabs.com"];
        [picker setToRecipients:toRecipients];

        [self presentModalViewController:picker animated:YES];
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


-(void)gohelp{
    
    HelpController *helpController = [[HelpController alloc]initWithNibName:@"HelpController" bundle:nil];
    [self.navigationController pushViewController:helpController animated:NO];

}


-(void)createNewFlyer{
    
	ptController = [[CreateFlyerController alloc]initWithNibName:@"CreateFlyerController" bundle:nil];
    ptController.flyerNumber = -1;
	[self.navigationController pushViewController:ptController animated:YES];
    
}


@end
