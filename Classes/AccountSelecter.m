//
//  AccountSelecter.m
//  Flyr
//
//  Created by Khurram on 13/08/2013.
//
//

#import "AccountSelecter.h"

@interface AccountSelecter ()

@end

@implementation AccountSelecter

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
    arrayOfAccounts = globle.accounts;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma TableView Events



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return arrayOfAccounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier] ;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
		[[cell detailTextLabel] setTextColor:[UIColor lightGrayColor]];
		[[cell detailTextLabel] setFont:[UIFont systemFontOfSize:12.0]];
        [cell setBackgroundColor:[UIColor whiteColor]];
        
    }
     
    //Convert twitter username to email
    ACAccount *acct = [arrayOfAccounts objectAtIndex:indexPath.row] ;
    NSString *twitterEmail = [AccountController  getTwitterEmailByUsername:[acct username]] ;
    cell.textLabel.text = twitterEmail;
        
     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    sgnController = [[SigninController alloc]initWithNibName:@"SigninController" bundle:nil];
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = selectedCell.textLabel.text;
    // sign in
    [sgnController signIn:YES username:cellText password:@"null"];
}


@end
