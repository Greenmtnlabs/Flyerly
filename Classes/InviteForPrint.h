//
//  InviteForPrint.h
//  Flyr
//
//  Created by Khurram on 17/07/2014.
//
//

#import <UIKit/UIKit.h>
#import <ParentViewController.h>
#import "PayPalMobile.h"

@class FlyerlySingleton;

@interface InviteForPrint : ParentViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,PayPalPaymentDelegate>{
    
    FlyerlySingleton *globle;
}

@property(nonatomic,strong) IBOutlet UITextField *searchTextField;

@property(nonatomic,strong) IBOutlet UITableView *uiTableView;
@property(nonatomic,strong) NSMutableArray *contactsArray;
@property(nonatomic,strong) NSMutableArray *contactBackupArray;
@property(nonatomic,strong) NSMutableArray *selectedIdentifiers;

@property(nonatomic,strong) NSMutableArray *iPhoneinvited;

@end
