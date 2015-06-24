//
//  UntechOptionsViewController.h
//  Untechable
//
//  Created by rufi on 24/06/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"
#import "Common.h"

@interface UntechOptionsViewController : UIViewController  {
    
    UILabel *titleLabel;
    
    
   
    
    
    
    IBOutlet UIButton *Untech;
    IBOutlet UIButton *UntechCustom;
    
    UIButton *backButton;
    UIButton *nextButton;
    
    UIColor *defGreen;//GREEN
    UIColor *defGray;//GRAY
    
}

//Properties
@property (nonatomic,strong)  Untechable *untechable;

- (IBAction)untechButton:(id)sender;
- (IBAction)untechCustomButton:(id)sender;

@end

