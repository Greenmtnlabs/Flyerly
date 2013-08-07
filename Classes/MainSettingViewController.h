//
//  MainSettingViewController.h
//  Flyr
//
//  Created by Khurram on 07/08/2013.
//
//

#import <UIKit/UIKit.h>
#import "SettingViewController.h"
	
@interface MainSettingViewController : UIViewController{

    UITableView *tableView;
    NSMutableArray *category;
    NSMutableArray *groupCtg;
    SettingViewController *oldsettingveiwcontroller;
    UISwitch *mySwitch;
    

}
@property (strong, nonatomic)IBOutlet UITableView *tableView;
- (void)changeSwitch:(id)sender;




@end
