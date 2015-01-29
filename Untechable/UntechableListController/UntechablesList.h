//
//  UntechablesList.h
//  Untechable
//
//  Created by RIKSOF Developer on 11/20/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"
#import "Reachability.h"

@interface UntechablesList : UIViewController <UITableViewDelegate,UITableViewDataSource> {

    UIColor *defGreen;//GREEN
    UIColor *defGray;//GRAY
    UIButton *newUntechableButton;
    UIButton *preferencesButton;
    Untechable *untechable;
    
    Reachability *internetReachable;
}

@property(nonatomic,strong) IBOutlet UITableView *untechablesTable;

@end
