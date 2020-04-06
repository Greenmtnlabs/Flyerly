//
//  InviteForPrint.h
//  Flyr
//
//  Created by Khurram on 17/07/2014.
//
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "ParentViewController.h"
#import "Flyer.h"
#import "AFNetworking.h"
#import <Contacts/Contacts.h>

@class FlyerlySingleton;

@interface InviteForPrint : ParentViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,MFMailComposeViewControllerDelegate>{
    
    FlyerlySingleton *globle;
}

@property (nonatomic,strong) Flyer *flyer;

@property(nonatomic,strong) IBOutlet UITextField *searchTextField;
@property(nonatomic,strong) IBOutlet UITextView *msgTextView;
@property(nonatomic,strong) IBOutlet UITableView *uiTableView;
@property(nonatomic,strong) NSMutableArray *contactsArray;
@property(nonatomic,strong) NSMutableArray *contactBackupArray;
@property(nonatomic,strong) NSMutableArray *selectedIdentifiers;

@property(nonatomic,strong) NSMutableArray *iPhoneinvited;

@end
