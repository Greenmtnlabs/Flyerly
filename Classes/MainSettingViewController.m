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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg_without_logo2"] forBarMetrics:UIBarMetricsDefault];
     self.navigationItem.title = @"Setting";
    groupCtg = [[NSMutableArray alloc] init];
    [groupCtg addObject:@"Preferences"];
    [groupCtg addObject:@"Account"];
    category = [[NSMutableArray alloc] init];
    [category addObject:@"Sharing Setting"];
    [category addObject:@"Save to Camera Roll"];
    [category addObject:@"Sign Out"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma TableView Events


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [groupCtg count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *s =[NSString stringWithFormat:@"%@",[groupCtg objectAtIndex:section]];
    return s;
    
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *s;
    s = @"Enter Shares Quantity";
    return s;
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
         return 2;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
		[[cell detailTextLabel] setTextColor:[UIColor lightGrayColor]];
		[[cell detailTextLabel] setFont:[UIFont systemFontOfSize:12.0]];
        [cell setBackgroundColor:[UIColor whiteColor]];
        
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
    if (indexPath.section == 0) {
        NSString *s =[NSString stringWithFormat:@"%@",[category objectAtIndex:indexPath.row]];
        cell.textLabel.text =s;
    
        if (indexPath.row == 0)cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        if (indexPath.row == 1){
            UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(220, 10, 0, 0)];
            [cell.contentView  addSubview:mySwitch];
            [mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
        }
        //    UISwitch *swc = (UISwitch *); }
    
    }else{
        NSString *s =[NSString stringWithFormat:@"%@",[category objectAtIndex:2]];
        cell.textLabel.text =s;
    }
    return cell;
}

- (void)changeSwitch:(id)sender{
    if([sender isOn]){
        // Execute any code when the switch is ON
        NSLog(@"Switch is ON");
        [[NSUserDefaults standardUserDefaults] setObject:@"enabled" forKey:@"saveToCameraRollSetting"];
    } else{
        // Execute any code when the switch is OFF
        NSLog(@"Switch is OFF");
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"saveToCameraRollSetting"];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 & indexPath.section == 0) {
        oldsettingveiwcontroller = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
        [self.navigationController pushViewController:oldsettingveiwcontroller animated:YES];
    }
 
}


@end
