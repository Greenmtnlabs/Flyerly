//
//  EmailChangingController.h
//  Untechable
//
//  Created by Abdul Rauf on 30/01/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"

@interface EmailChangingController : UIViewController {
    
    UIButton *backButton;
    UIButton *nextButton;
    UIColor *defGreen;//GREEN
    UIColor *defGray;//GRAY
}

//Properties
@property (nonatomic,strong)  Untechable *untechable;

@property (strong, nonatomic) IBOutlet UILabel *emailAddress;

@property (strong, nonatomic) NSString *emailAddresstext;

@property(assign) BOOL setupScreenCalling;

@end
