//
//  AccountSelecter.h
//  Flyr
//
//  Created by Khurram on 13/08/2013.
//
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "AccountController.h"
#import "SigninController.h"


@class SigninController,Singleton;
@interface AccountSelecter : UIViewController <UITableViewDelegate>{

    Singleton *globle;
    SigninController  *sgnController;
    NSMutableArray *arrayOfAccounts;

}
@property (nonatomic,strong) IBOutlet UILabel *lableactType;
@property (strong, nonatomic)IBOutlet UITableView *tableView;
@end
